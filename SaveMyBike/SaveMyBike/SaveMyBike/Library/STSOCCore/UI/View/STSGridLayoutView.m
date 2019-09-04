//
//  STSGridLayoutView.m
//  
//  Created by Szymon Tomasz Stefanek on 1/20/17.
//  Copyright © 2017 Szymon Tomasz Stefanek. All rights reserved.
//

#import "STSGridLayoutView.h"

#import "STSCore.h"
#import "STSGridItemView.h"
#import "STSPatchView.h"

//#define DEBUG_LAYOUT

@interface STSGridLayoutViewItem : NSObject
{
@public
	UIView * pView;

	int iRow;
	int iColumn;
	int iRowSpan;
	int iColumnSpan;
	
	int iLastRow;
	int iLastColumn;

	STSSizePolicy eHorizontalSizePolicy;
	STSSizePolicy eVerticalSizePolicy;

	STSMargins * pMargins;
	
	// runtime stuff
	CGFloat fAssignedWidth;
	CGSize sContentsSize; // intrinsicContentsSize
	CGSize sMinimumSize;
	CGSize sPreferredSize; // sizeThatFits, generally
	CGSize sMaximumSize;
}
@end

@implementation STSGridLayoutViewItem
@end

typedef enum _ConstraintType
{
	ConstraintTypeRowMinimumHeight,
	ConstraintTypeRowMaximumHeight,
	ConstraintTypeRowMinimumHeightPercent,
	ConstraintTypeRowMaximumHeightPercent,
	ConstraintTypeRowExpandWeight,
	ConstraintTypeRowShrinkWeight,
	ConstraintTypeColumnMinimumWidth,
	ConstraintTypeColumnMaximumWidth,
	ConstraintTypeColumnMinimumWidthPercent,
	ConstraintTypeColumnMaximumWidthPercent,
	ConstraintTypeColumnExpandWeight,
	ConstraintTypeColumnShrinkWeight
} ConstraintType;

@interface STSGridLayoutViewConstraint : NSObject
{
@public
	ConstraintType eType;
	int iCoordinate;
	CGFloat fValue;
}
@end

@implementation STSGridLayoutViewConstraint
@end

@interface STSGridLayoutViewView : NSObject
{
@public
	STSGridLayoutViewItem * pItem;
	UIView * pView;
	CGRect rRect;
}
@end

@implementation STSGridLayoutViewView
@end

// Define this to use the maximum preferred size for each row/column instead of the average
#define USE_MAXIMUM_PREFERRED

@interface STSGridLayoutViewRowOrColumn : NSObject
{
@public
	CGFloat fExpandWeight;
	CGFloat fExpandWeightDivisor;
	CGFloat fShrinkWeight;
	CGFloat fShrinkWeightDivisor;
	
	CGFloat fPreferred;
#ifndef USE_MAXIMUM_PREFERRED
	CGFloat fPreferredDivisor;
#endif
	
	CGFloat fMinimum;
	CGFloat fMaximum;

	CGFloat fActual; // size
	CGFloat fStart; // start coordinate
}
@end

@implementation STSGridLayoutViewRowOrColumn
@end

@interface STSGridLayoutViewLayout : NSObject
{
@public
	CGSize sRequestedSize;

	CGSize sMinimumSize;
	CGSize sPreferredSize;
	// This may be less or more than the preferred (but never less than minimum)
	CGSize sActualSize;
	
	int iRows;
	int iColumns;
	
	NSMutableArray * pRows;
	NSMutableArray * pColumns;
	
	NSMutableArray * pViews;
}
@end

@implementation STSGridLayoutViewLayout
@end

@interface STSGridLayoutView()
{
	NSMutableArray * m_pItems;
	NSMutableArray * m_pConstraints;
	
	CGFloat m_fTopMargin;
	CGFloat m_fLeftMargin;
	CGFloat m_fRightMargin;
	CGFloat m_fBottomMargin;
	
	CGFloat m_fRowSpacing;
	CGFloat m_fColumnSpacing;
	
	STSGridLayoutViewLayout * m_pLayout;
}
@end

@implementation STSGridLayoutView

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if(!self)
		return nil;

	[self _gridLayoutViewInit];
	
	return self;
}

- (id)init
{
	self = [super initWithFrame:CGRectZero];
	if(!self)
		return nil;
	
	[self _gridLayoutViewInit];

	return self;
}

- (void)_gridLayoutViewInit
{
	m_pItems = [[NSMutableArray alloc] init];
	m_pConstraints = [[NSMutableArray alloc] init];
	
	m_fTopMargin = 0.0f;
	m_fLeftMargin = 0.0f;
	m_fRightMargin = 0.0f;
	m_fBottomMargin = 0.0f;
	
	m_fRowSpacing = 0.0f;
	m_fColumnSpacing = 0.0f;
	
	m_pLayout = nil;
}

- (void)dealloc
{
	[self _dropLayout];
	[m_pItems removeAllObjects];
	m_pItems = nil;
	[m_pConstraints removeAllObjects];
	m_pConstraints = nil;
}

- (void)_dropLayout
{
	if(!m_pLayout)
		return;
	[m_pLayout->pViews removeAllObjects];
	[m_pLayout->pRows removeAllObjects];
	[m_pLayout->pColumns removeAllObjects];
	m_pLayout = nil;
}

- (void)setNeedsLayout
{
	[self _dropLayout];
	[super setNeedsLayout];
}

- (void)_setConstraint:(ConstraintType)eType coordinate:(int)iCoordinate value:(CGFloat)fValue
{
	STSGridLayoutViewConstraint * c;
	
	for(c in m_pConstraints)
	{
		if((c->eType == eType) && (c->iCoordinate == iCoordinate))
		{
			c->fValue = fValue;
			return;
		}
	}

	c = [[STSGridLayoutViewConstraint alloc] init];
	
	c->eType = eType;
	c->iCoordinate = iCoordinate;
	c->fValue = fValue;
	
	[m_pConstraints addObject:c];
	[self setNeedsLayout];
}

- (void)setRow:(int)iRow fixedHeight:(CGFloat)fHeight
{
	[self _setConstraint:ConstraintTypeRowMinimumHeight coordinate:iRow value:fHeight];
	[self _setConstraint:ConstraintTypeRowMaximumHeight coordinate:iRow value:fHeight];
}

- (void)setRow:(int)iRow minimumHeight:(CGFloat)fHeight
{
	[self _setConstraint:ConstraintTypeRowMinimumHeight coordinate:iRow value:fHeight];
}

- (void)setRow:(int)iRow maximumHeight:(CGFloat)fHeight
{
	[self _setConstraint:ConstraintTypeRowMaximumHeight coordinate:iRow value:fHeight];
}

- (void)setRow:(int)iRow fixedHeightPercent:(CGFloat)fHeight
{
	[self _setConstraint:ConstraintTypeRowMinimumHeightPercent coordinate:iRow value:fHeight];
	[self _setConstraint:ConstraintTypeRowMaximumHeightPercent coordinate:iRow value:fHeight];
}

- (void)setRow:(int)iRow minimumHeightPercent:(CGFloat)fHeight
{
	[self _setConstraint:ConstraintTypeRowMinimumHeightPercent coordinate:iRow value:fHeight];
}

- (void)setRow:(int)iRow maximumHeightPercent:(CGFloat)fHeight
{
	[self _setConstraint:ConstraintTypeRowMaximumHeightPercent coordinate:iRow value:fHeight];
}

- (void)setRow:(int)iRow expandWeight:(CGFloat)fWeight
{
	[self _setConstraint:ConstraintTypeRowExpandWeight coordinate:iRow value:fWeight];
}

- (void)setRow:(int)iRow shrinkWeight:(CGFloat)fWeight
{
	[self _setConstraint:ConstraintTypeRowShrinkWeight coordinate:iRow value:fWeight];
}

- (void)setColumn:(int)iColumn minimumWidth:(CGFloat)fWidth
{
	[self _setConstraint:ConstraintTypeColumnMinimumWidth coordinate:iColumn value:fWidth];
}

- (void)setColumn:(int)iColumn maximumWidth:(CGFloat)fWidth
{
	[self _setConstraint:ConstraintTypeColumnMaximumWidth coordinate:iColumn value:fWidth];
}

- (void)setColumn:(int)iColumn fixedWidth:(CGFloat)fWidth
{
	[self _setConstraint:ConstraintTypeColumnMaximumWidth coordinate:iColumn value:fWidth];
	[self _setConstraint:ConstraintTypeColumnMinimumWidth coordinate:iColumn value:fWidth];
}

- (void)setColumn:(int)iColumn minimumWidthPercent:(CGFloat)fWidth
{
	[self _setConstraint:ConstraintTypeColumnMinimumWidthPercent coordinate:iColumn value:fWidth];
}

- (void)setColumn:(int)iColumn maximumWidthPercent:(CGFloat)fWidth
{
	[self _setConstraint:ConstraintTypeColumnMaximumWidthPercent coordinate:iColumn value:fWidth];
}

- (void)setColumn:(int)iColumn fixedWidthPercent:(CGFloat)fWidth
{
	[self _setConstraint:ConstraintTypeColumnMaximumWidthPercent coordinate:iColumn value:fWidth];
	[self _setConstraint:ConstraintTypeColumnMinimumWidthPercent coordinate:iColumn value:fWidth];
}

- (void)setColumn:(int)iColumn expandWeight:(CGFloat)fWeight
{
	[self _setConstraint:ConstraintTypeColumnExpandWeight coordinate:iColumn value:fWeight];
}

- (void)setColumn:(int)iColumn shrinkWeight:(CGFloat)fWeight
{
	[self _setConstraint:ConstraintTypeColumnShrinkWeight coordinate:iColumn value:fWeight];
}

- (void)removeAllConstraints
{
	[m_pConstraints removeAllObjects];
	[self setNeedsLayout];
}

- (void)setMarginLeft:(CGFloat)fLeftMargin top:(CGFloat)fTopMargin right:(CGFloat)fRightMargin bottom:(CGFloat)fBottomMargin
{
	m_fLeftMargin = fLeftMargin;
	m_fRightMargin = fRightMargin;
	m_fBottomMargin = fBottomMargin;
	m_fTopMargin = fTopMargin;
	
	[self setNeedsLayout];
}

- (void)setLeftMargin:(CGFloat)fLeftMargin
{
	m_fLeftMargin = fLeftMargin;
	
	[self setNeedsLayout];
}

- (void)setRightMargin:(CGFloat)fRightMargin
{
	m_fRightMargin = fRightMargin;
	
	[self setNeedsLayout];
}

- (void)setBottomMargin:(CGFloat)fBottomMargin
{
	m_fBottomMargin = fBottomMargin;
	
	[self setNeedsLayout];
}

- (void)setTopMargin:(CGFloat)fTopMargin
{
	m_fTopMargin = fTopMargin;
	
	[self setNeedsLayout];
}

- (void)setMargin:(CGFloat)fAllMargins
{
	m_fLeftMargin = fAllMargins;
	m_fRightMargin = fAllMargins;
	m_fBottomMargin = fAllMargins;
	m_fTopMargin = fAllMargins;
	
	[self setNeedsLayout];
}

- (void)setColumnSpacing:(CGFloat)fColumnSpacing
{
	m_fColumnSpacing = fColumnSpacing;
	
	[self setNeedsLayout];
}

- (void)setRowSpacing:(CGFloat)fRowSpacing
{
	m_fRowSpacing = fRowSpacing;
	
	[self setNeedsLayout];
}

- (void)setSpacing:(CGFloat)fAllSpacings
{
	m_fColumnSpacing = fAllSpacings;
	m_fRowSpacing = fAllSpacings;
	
	[self setNeedsLayout];
}

- (void)addView:(UIView *)pView row:(int)iRow column:(int)iColumn
{
	[self addView:pView row:iRow column:iColumn rowSpan:1 columnSpan:1];
}

- (void)addView:(UIView *)pView row:(int)iRow column:(int)iColumn rowSpan:(int)iRowSpan columnSpan:(int)iColumnSpan
{
	STSSizePolicy eHorizontalSizePolicy = STSSizePolicyCanShrinkAndExpand;
	STSSizePolicy eVerticalSizePolicy = STSSizePolicyCanShrinkAndExpand;
	
	if([pView isKindOfClass:[UITextField class]] || [pView isKindOfClass:[UISearchBar class]])
	{
		eVerticalSizePolicy = STSSizePolicyFixed;
		eHorizontalSizePolicy = STSSizePolicyCanShrinkButShouldExpand;
	} else if([pView isKindOfClass:[UITextView class]] || [pView isKindOfClass:[UITableView class]])
	{
		eVerticalSizePolicy = STSSizePolicyCanShrinkButShouldExpand;
		eHorizontalSizePolicy = STSSizePolicyCanShrinkButShouldExpand;
	} else if([pView isKindOfClass:[UIButton class]])
	{
		eVerticalSizePolicy = STSSizePolicyFixed;
		eHorizontalSizePolicy = STSSizePolicyCanExpand;
	} else if([pView isKindOfClass:[STSGridItemView class]])
	{
		eVerticalSizePolicy = STSSizePolicyCanShrinkButShouldExpand;
		eHorizontalSizePolicy = STSSizePolicyCanShrinkButShouldExpand;
	} else if([pView isKindOfClass:[STSGridLayoutView class]])
	{
		eVerticalSizePolicy = STSSizePolicyCanExpand; // Fixed ?
	} else if([pView isKindOfClass:[STSPatchView class]])
	{
		eVerticalSizePolicy = STSSizePolicyCanExpand; // Fixed ?
	}
	
	[self addView:pView row:iRow column:iColumn rowSpan:iRowSpan columnSpan:iColumnSpan verticalSizePolicy:eVerticalSizePolicy horizontalSizePolicy:eHorizontalSizePolicy];
}

- (void)addView:(UIView *)pView row:(int)iRow column:(int)iColumn verticalSizePolicy:(STSSizePolicy)eVerticalSizePolicy horizontalSizePolicy:(STSSizePolicy)eHorizontalSizePolicy;
{
	STSGridLayoutViewItem * pItem = [STSGridLayoutViewItem new];
	
	pItem->pView = pView;
	
	pItem->iRow = iRow;
	pItem->iColumn = iColumn;
	pItem->iRowSpan = 1;
	pItem->iColumnSpan = 1;
	
	pItem->iLastRow = iRow;
	pItem->iLastColumn = iColumn;
	
	pItem->eHorizontalSizePolicy = eHorizontalSizePolicy;
	pItem->eVerticalSizePolicy = eVerticalSizePolicy;
	
	[m_pItems addObject:pItem];
	
	if(pView.superview != self)
		[self addSubview:pView];
	
	[self setNeedsLayout];
}

- (void)addView:(UIView *)pView row:(int)iRow column:(int)iColumn rowSpan:(int)iRowSpan columnSpan:(int)iColumnSpan verticalSizePolicy:(STSSizePolicy)eVerticalSizePolicy horizontalSizePolicy:(STSSizePolicy)eHorizontalSizePolicy
{
	STSGridLayoutViewItem * pItem = [STSGridLayoutViewItem new];

	pItem->pView = pView;

	pItem->iRow = iRow;
	pItem->iColumn = iColumn;
	if(iRowSpan < 1)
		iRowSpan = 1;
	pItem->iRowSpan = iRowSpan;
	if(iColumnSpan < 1)
		iColumnSpan = 1;
	pItem->iColumnSpan = iColumnSpan;
	
	pItem->iLastRow = iRow + iRowSpan - 1;
	pItem->iLastColumn = iColumn + iColumnSpan - 1;
	
	pItem->eHorizontalSizePolicy = eHorizontalSizePolicy;
	pItem->eVerticalSizePolicy = eVerticalSizePolicy;
	
	[m_pItems addObject:pItem];
	
	if(pView.superview != self)
		[self addSubview:pView];
	
	[self setNeedsLayout];
}

- (void)removeView:(UIView *)pView
{
	for(STSGridLayoutViewItem * pItem in m_pItems)
	{
		if(pItem->pView == pView)
		{
			pItem->pView = nil;
			[m_pItems removeObject:pItem];
			[pView removeFromSuperview];
			break;
		}
	}
	
	[self setNeedsLayout];
}

- (void)clear
{
	[self removeAllViews];
	[self removeAllConstraints];
}

- (void)removeAllViews
{
	for(STSGridLayoutViewItem * pItem in m_pItems)
	{
		[pItem->pView removeFromSuperview];
		pItem->pView = nil;
	}
	
	[m_pItems removeAllObjects];
	
	[self setNeedsLayout];
}

- (void)removeAllViewsFromLayoutButKeepThemAttachedToView
{
	for(STSGridLayoutViewItem * pItem in m_pItems)
		pItem->pView = nil;
	
	[m_pItems removeAllObjects];
	
	[self setNeedsLayout];
}


- (void)setView:(UIView *)pView margins:(STSMargins *)pMargins
{
	for(STSGridLayoutViewItem * i in m_pItems)
	{
		if(i->pView == pView)
		{
			i->pMargins = pMargins;
			return;
		}
	}
	
	[self setNeedsLayout];
}

#if 0

- (STSGridLayoutViewLayout *)_computeLayoutForSize:(CGSize)sRequestedSize
{
#ifdef DEBUG_LAYOUT
	STS_CORE_LOG(@"Requested size is %f,%f",sRequestedSize.width,sRequestedSize.height);
#endif
	
	STSGridLayoutViewLayout * pLayout = [[STSGridLayoutViewLayout alloc] init];
	
	pLayout->pViews = [[NSMutableArray alloc] init];
	pLayout->pRows = [[NSMutableArray alloc] init];
	pLayout->pColumns = [[NSMutableArray alloc] init];

	pLayout->sRequestedSize = sRequestedSize;
	pLayout->iRows = 0;
	pLayout->iColumns = 0;
	
	STSGridLayoutViewItem * pItem;
	STSGridLayoutViewConstraint * pConstraint;
	STSGridLayoutViewRowOrColumn * pRowOrColumn;
	
	int iLastRow = 0;
	int iLastColumn = 0;
	
	for(pItem in m_pItems)
	{
		pItem->sContentsSize = [pItem->pView intrinsicContentSize];
		
		if(pItem->pMargins)
		{
			pItem->sContentsSize = CGSizeMake(
					pItem->sContentsSize.width + pItem->pMargins.left + pItem->pMargins.right,
					pItem->sContentsSize.height + pItem->pMargins.top + pItem->pMargins.bottom
				);
		}
		
		//pItem->sPreferredSize = [pItem->pView sizeThatFits:pLayout->sRequestedSize];
		
		switch(pItem->eHorizontalSizePolicy)
		{
			case STSSizePolicyIgnore:
				pItem->sMinimumSize.width = 0.0f;
				pItem->sMaximumSize.width = 99999.9f;
				pItem->sPreferredSize.width = 0.0f;
				break;
			case STSSizePolicyFixed:
				pItem->sMinimumSize.width = pItem->sContentsSize.width;
				pItem->sMaximumSize.width = pItem->sContentsSize.width;
				pItem->sPreferredSize.width = pItem->sContentsSize.width;
				break;
			case STSSizePolicyCanExpand:
			case STSSizePolicyShouldExpand:
				pItem->sPreferredSize.width = pItem->sContentsSize.width;
				pItem->sMinimumSize.width = pItem->sContentsSize.width;
				pItem->sMaximumSize.width = 99999.9f;
				break;
			case STSSizePolicyCanShrink:
				pItem->sPreferredSize.width = pItem->sContentsSize.width;
				pItem->sMaximumSize.width = pItem->sContentsSize.width;
				pItem->sMinimumSize.width = 0.0f;
				break;
			//case STSSizePolicyCanShrinkAndExpand:
			//case STSSizePolicyCanShrinkButShouldExpand:
			default:
				pItem->sPreferredSize.width = pItem->sContentsSize.width;
				pItem->sMinimumSize.width = 0.0f;
				pItem->sMaximumSize.width = 99999.9f;
				break;
		}

		switch(pItem->eVerticalSizePolicy)
		{
			case STSSizePolicyIgnore:
				pItem->sMinimumSize.height = 0.0f;
				pItem->sMaximumSize.height = 99999.9f;
				pItem->sPreferredSize.height = 0.0f;
				break;
			case STSSizePolicyFixed:
				pItem->sMinimumSize.height = pItem->sContentsSize.height;
				pItem->sMaximumSize.height = pItem->sContentsSize.height;
				pItem->sPreferredSize.height = pItem->sContentsSize.height;
				break;
			case STSSizePolicyCanExpand:
			case STSSizePolicyShouldExpand:
				pItem->sPreferredSize.height = pItem->sContentsSize.height;
				pItem->sMinimumSize.height = pItem->sContentsSize.height;
				pItem->sMaximumSize.height = 99999.9f;
				break;
			case STSSizePolicyCanShrink:
				pItem->sPreferredSize.height = pItem->sContentsSize.height;
				pItem->sMaximumSize.height = pItem->sContentsSize.height;
				pItem->sMinimumSize.height = 0.0f;
				break;
			//case STSSizePolicyCanShrinkAndExpand:
			//case STSSizePolicyCanShrinkButShouldExpand:
			default:
				pItem->sPreferredSize.height = pItem->sContentsSize.height;
				pItem->sMinimumSize.height = 0.0f;
				pItem->sMaximumSize.height = 99999.9f;
				break;
		}
		
		if(iLastRow < pItem->iLastRow)
			iLastRow = pItem->iLastRow;
		if(iLastColumn < pItem->iLastColumn)
			iLastColumn = pItem->iLastColumn;
	}
	
	for(pConstraint in m_pConstraints)
	{
		switch(pConstraint->eType)
		{
			case ConstraintTypeRowExpandWeight:
			case ConstraintTypeRowShrinkWeight:
			case ConstraintTypeRowMaximumHeight:
			case ConstraintTypeRowMinimumHeight:
			case ConstraintTypeRowMaximumHeightPercent:
			case ConstraintTypeRowMinimumHeightPercent:
				if(iLastRow < pConstraint->iCoordinate)
					iLastRow = pConstraint->iCoordinate;
			break;
			case ConstraintTypeColumnExpandWeight:
			case ConstraintTypeColumnShrinkWeight:
			case ConstraintTypeColumnMaximumWidth:
			case ConstraintTypeColumnMinimumWidth:
			case ConstraintTypeColumnMaximumWidthPercent:
			case ConstraintTypeColumnMinimumWidthPercent:
				if(iLastColumn < pConstraint->iCoordinate)
					iLastColumn = pConstraint->iCoordinate;
			break;
		}
	}
	
	pLayout->iRows = iLastRow + 1;
	pLayout->iColumns = iLastColumn + 1;

	int i;
	
	CGRect sScreen = [UIScreen mainScreen].bounds;
	
	for(i=0;i<pLayout->iRows;i++)
	{
		pRowOrColumn = [[STSGridLayoutViewRowOrColumn alloc] init];
		
		pRowOrColumn->fMinimum = 0.0f;
		pRowOrColumn->fMaximum = 999999.9f;
		pRowOrColumn->fActual = 0.0f;
		pRowOrColumn->fExpandWeight = 1.0f;
		pRowOrColumn->fExpandWeightDivisor = 1.0f;
		pRowOrColumn->fShrinkWeight = 1.0f;
		pRowOrColumn->fShrinkWeightDivisor = 1.0f;
		pRowOrColumn->fPreferred = 0.0f;
#ifndef USE_MAXIMUM_PREFERRED
		pRowOrColumn->fPreferredDivisor = 1.0f;
#endif
		[pLayout->pRows addObject:pRowOrColumn];
	}

	for(i=0;i<pLayout->iColumns;i++)
	{
		pRowOrColumn = [[STSGridLayoutViewRowOrColumn alloc] init];
		
		pRowOrColumn->fMinimum = 0.0f;
		pRowOrColumn->fMaximum = sScreen.size.width;
		pRowOrColumn->fActual = 0.0f;
		pRowOrColumn->fExpandWeight = 1.0f;
		pRowOrColumn->fExpandWeightDivisor = 1.0f;
		pRowOrColumn->fShrinkWeight = 1.0f;
		pRowOrColumn->fShrinkWeightDivisor = 1.0f;
		pRowOrColumn->fPreferred = 0.0f;
#ifndef USE_MAXIMUM_PREFERRED
		pRowOrColumn->fPreferredDivisor = 1.0f;
#endif
		[pLayout->pColumns addObject:pRowOrColumn];
	}

	for(pItem in m_pItems)
	{
		if(pItem->iColumnSpan == 1)
		{
			pRowOrColumn = (STSGridLayoutViewRowOrColumn *)[pLayout->pColumns objectAtIndex:pItem->iColumn];
			
			if(pRowOrColumn->fMinimum < pItem->sMinimumSize.width)
				pRowOrColumn->fMinimum = pItem->sMinimumSize.width;
			if(pRowOrColumn->fMaximum > pItem->sMaximumSize.width)
				pRowOrColumn->fMaximum = pItem->sMaximumSize.width;
			
			switch(pItem->eHorizontalSizePolicy)
			{
				case STSSizePolicyIgnore:
				case STSSizePolicyFixed:
				case STSSizePolicyCanShrink:
					pRowOrColumn->fShrinkWeight += 100.0f;
					pRowOrColumn->fShrinkWeightDivisor += 1.0f;
					break;
				case STSSizePolicyCanShrinkAndExpand:
					pRowOrColumn->fShrinkWeight += 100.0f;
					pRowOrColumn->fShrinkWeightDivisor += 1.0f;
					pRowOrColumn->fExpandWeight += 100.0f;
					pRowOrColumn->fExpandWeightDivisor += 1.0f;
					break;
				case STSSizePolicyCanExpand:
					pRowOrColumn->fExpandWeight += 200.0f;
					pRowOrColumn->fExpandWeightDivisor += 1.0f;
					break;
				case STSSizePolicyCanShrinkButShouldExpand:
					pRowOrColumn->fShrinkWeight += 100.0f;
					pRowOrColumn->fShrinkWeightDivisor += 1.0f;
					pRowOrColumn->fExpandWeight += 500.0f;
					pRowOrColumn->fExpandWeightDivisor += 1.0f;
					break;
				case STSSizePolicyShouldExpand:
					pRowOrColumn->fExpandWeight += 500.0f;
					pRowOrColumn->fExpandWeightDivisor += 1.0f;
					break;
			}

			switch(pItem->eHorizontalSizePolicy)
			{
				case STSSizePolicyIgnore:
					break;
				case STSSizePolicyFixed:
				case STSSizePolicyCanShrinkAndExpand:
				case STSSizePolicyCanExpand:
				case STSSizePolicyShouldExpand:
				case STSSizePolicyCanShrink:
				case STSSizePolicyCanShrinkButShouldExpand:
#ifdef USE_MAXIMUM_PREFERRED
					if(pItem->sPreferredSize.width > pRowOrColumn->fPreferred)
						pRowOrColumn->fPreferred = pItem->sPreferredSize.width;
#else
					pRowOrColumn->fPreferred += pItem->sPreferredSize.width;
					pRowOrColumn->fPreferredDivisor += 1.0f;
#endif
					break;
			}
			
		} else {
			for(i=pItem->iColumn;i<=pItem->iLastColumn;i++)
			{
				pRowOrColumn = (STSGridLayoutViewRowOrColumn *)[pLayout->pColumns objectAtIndex:i];

				switch(pItem->eHorizontalSizePolicy)
				{
					case STSSizePolicyIgnore:
					case STSSizePolicyFixed:
					case STSSizePolicyCanShrink:
						pRowOrColumn->fShrinkWeight += 100.0f / ((CGFloat)(pItem->iColumnSpan));
						pRowOrColumn->fShrinkWeightDivisor += 1.0f;
						break;
					case STSSizePolicyCanShrinkAndExpand:
						pRowOrColumn->fShrinkWeight += 100.0f / ((CGFloat)(pItem->iColumnSpan));
						pRowOrColumn->fShrinkWeightDivisor += 1.0f;
						pRowOrColumn->fExpandWeight += 100.0f / ((CGFloat)(pItem->iColumnSpan));
						pRowOrColumn->fExpandWeightDivisor += 1.0f;
						break;
					case STSSizePolicyCanExpand:
						pRowOrColumn->fExpandWeight += 200.0f / ((CGFloat)(pItem->iColumnSpan));
						pRowOrColumn->fExpandWeightDivisor += 1.0f;
						break;
					case STSSizePolicyCanShrinkButShouldExpand:
						pRowOrColumn->fShrinkWeight += 100.0f / ((CGFloat)(pItem->iColumnSpan));
						pRowOrColumn->fShrinkWeightDivisor += 1.0f;
						pRowOrColumn->fExpandWeight += 500.0f / ((CGFloat)(pItem->iColumnSpan));
						pRowOrColumn->fExpandWeightDivisor += 1.0f;
						break;
					case STSSizePolicyShouldExpand:
						pRowOrColumn->fExpandWeight += 500.0f / ((CGFloat)(pItem->iColumnSpan));
						pRowOrColumn->fExpandWeightDivisor += 1.0f;
						break;
				}
				
				switch(pItem->eHorizontalSizePolicy)
				{
					case STSSizePolicyIgnore:
						break;
					case STSSizePolicyFixed:
					case STSSizePolicyCanShrinkAndExpand:
					case STSSizePolicyCanExpand:
					case STSSizePolicyShouldExpand:
					case STSSizePolicyCanShrink:
					case STSSizePolicyCanShrinkButShouldExpand:
					{
						CGFloat fPreferred = pItem->sPreferredSize.width / ((CGFloat)(pItem->iColumnSpan));
#ifdef USE_MAXIMUM_PREFERRED
						if(fPreferred > pRowOrColumn->fPreferred)
							pRowOrColumn->fPreferred = fPreferred;
#else
						pRowOrColumn->fPreferred += fPreferred;
						pRowOrColumn->fPreferredDivisor += 1.0f;
#endif
					}
					break;
				}
			}
		}

	
		if(pItem->iRowSpan == 1)
		{
			pRowOrColumn = (STSGridLayoutViewRowOrColumn *)[pLayout->pRows objectAtIndex:pItem->iRow];
			
			if(pRowOrColumn->fMinimum < pItem->sMinimumSize.height)
				pRowOrColumn->fMinimum = pItem->sMinimumSize.height;
			if(pRowOrColumn->fMaximum > pItem->sMaximumSize.height)
				pRowOrColumn->fMaximum = pItem->sMaximumSize.height;
			
			switch(pItem->eVerticalSizePolicy)
			{
				case STSSizePolicyIgnore:
				case STSSizePolicyFixed:
				case STSSizePolicyCanShrink:
					pRowOrColumn->fShrinkWeight += 100.0f;
					pRowOrColumn->fShrinkWeightDivisor += 1.0f;
					break;
				case STSSizePolicyCanShrinkAndExpand:
					pRowOrColumn->fShrinkWeight += 100.0f;
					pRowOrColumn->fShrinkWeightDivisor += 1.0f;
					pRowOrColumn->fExpandWeight += 100.0f;
					pRowOrColumn->fExpandWeightDivisor += 1.0f;
					break;
				case STSSizePolicyCanExpand:
					pRowOrColumn->fExpandWeight += 200.0f;
					pRowOrColumn->fExpandWeightDivisor += 1.0f;
					break;
				case STSSizePolicyCanShrinkButShouldExpand:
					pRowOrColumn->fShrinkWeight += 100.0f;
					pRowOrColumn->fShrinkWeightDivisor += 1.0f;
					pRowOrColumn->fExpandWeight += 500.0f;
					pRowOrColumn->fExpandWeightDivisor += 1.0f;
					break;
				case STSSizePolicyShouldExpand:
					pRowOrColumn->fExpandWeight += 500.0f;
					pRowOrColumn->fExpandWeightDivisor += 1.0f;
					break;
			}
			
			switch(pItem->eVerticalSizePolicy)
			{
				case STSSizePolicyIgnore:
					break;
				case STSSizePolicyFixed:
				case STSSizePolicyCanShrinkAndExpand:
				case STSSizePolicyCanExpand:
				case STSSizePolicyShouldExpand:
				case STSSizePolicyCanShrink:
				case STSSizePolicyCanShrinkButShouldExpand:
#ifdef USE_MAXIMUM_PREFERRED
					if(pItem->sPreferredSize.height > pRowOrColumn->fPreferred)
						pRowOrColumn->fPreferred = pItem->sPreferredSize.height;
#else
					pRowOrColumn->fPreferred += pItem->sPreferredSize.height;
					pRowOrColumn->fPreferredDivisor += 1.0f;
#endif
					break;
			}
			
		} else {
			for(i=pItem->iRow;i<=pItem->iLastRow;i++)
			{
				pRowOrColumn = (STSGridLayoutViewRowOrColumn *)[pLayout->pRows objectAtIndex:i];
				
				switch(pItem->eVerticalSizePolicy)
				{
					case STSSizePolicyIgnore:
					case STSSizePolicyFixed:
					case STSSizePolicyCanShrink:
						pRowOrColumn->fShrinkWeight += 100.0f / ((CGFloat)(pItem->iRowSpan));
						pRowOrColumn->fShrinkWeightDivisor += 1.0f;
						break;
					case STSSizePolicyCanShrinkAndExpand:
						pRowOrColumn->fShrinkWeight += 100.0f / ((CGFloat)(pItem->iRowSpan));
						pRowOrColumn->fShrinkWeightDivisor += 1.0f;
						pRowOrColumn->fExpandWeight += 100.0f / ((CGFloat)(pItem->iRowSpan));
						pRowOrColumn->fExpandWeightDivisor += 1.0f;
						break;
					case STSSizePolicyCanExpand:
						pRowOrColumn->fExpandWeight += 200.0f / ((CGFloat)(pItem->iRowSpan));
						pRowOrColumn->fExpandWeightDivisor += 1.0f;
						break;
					case STSSizePolicyCanShrinkButShouldExpand:
						pRowOrColumn->fShrinkWeight += 100.0f / ((CGFloat)(pItem->iRowSpan));
						pRowOrColumn->fShrinkWeightDivisor += 1.0f;
						pRowOrColumn->fExpandWeight += 500.0f / ((CGFloat)(pItem->iRowSpan));
						pRowOrColumn->fExpandWeightDivisor += 1.0f;
						break;
					case STSSizePolicyShouldExpand:
						pRowOrColumn->fExpandWeight += 500.0f / ((CGFloat)(pItem->iRowSpan));
						pRowOrColumn->fExpandWeightDivisor += 1.0f;
						break;
				}
				
				switch(pItem->eVerticalSizePolicy)
				{
					case STSSizePolicyIgnore:
						break;
					case STSSizePolicyFixed:
					case STSSizePolicyCanShrinkAndExpand:
					case STSSizePolicyCanExpand:
					case STSSizePolicyShouldExpand:
					case STSSizePolicyCanShrink:
					case STSSizePolicyCanShrinkButShouldExpand:
					{
						CGFloat fPreferred = pItem->sPreferredSize.height / ((CGFloat)(pItem->iColumnSpan));
#ifdef USE_MAXIMUM_PREFERRED
						if(fPreferred > pRowOrColumn->fPreferred)
							pRowOrColumn->fPreferred = fPreferred;
#else
						pRowOrColumn->fPreferred += fPreferred;
						pRowOrColumn->fPreferredDivisor += 1.0f;
#endif
					}
					break;
				}
			}
		}

	}
	
	// Margins and spacings
	CGSize sLockedSize = CGSizeMake(
			m_fLeftMargin + m_fRightMargin + ((pLayout->iColumns - 1) * m_fColumnSpacing),
			m_fTopMargin + m_fBottomMargin + ((pLayout->iRows - 1) * m_fRowSpacing)
		);
	CGSize sTotalAvailableSize = CGSizeMake(
			pLayout->sRequestedSize.width > sLockedSize.width ? (pLayout->sRequestedSize.width - sLockedSize.width) : 0.0f,
			pLayout->sRequestedSize.height > sLockedSize.height ? (pLayout->sRequestedSize.height - sLockedSize.height) : 0.0f
		);

	CGFloat tmp;
	
	// Now we can apply user constraints (which will eventually override the computed values)
	for(pConstraint in m_pConstraints)
	{
		switch(pConstraint->eType)
		{
			case ConstraintTypeRowExpandWeight:
				pRowOrColumn = (STSGridLayoutViewRowOrColumn *)[pLayout->pRows objectAtIndex:pConstraint->iCoordinate];
				pRowOrColumn->fExpandWeight = pConstraint->fValue;
				pRowOrColumn->fExpandWeightDivisor = 1.0f;
				break;
			case ConstraintTypeRowShrinkWeight:
				pRowOrColumn = (STSGridLayoutViewRowOrColumn *)[pLayout->pRows objectAtIndex:pConstraint->iCoordinate];
				pRowOrColumn->fShrinkWeight = pConstraint->fValue;
				pRowOrColumn->fShrinkWeightDivisor = 1.0f;
				break;
			case ConstraintTypeRowMaximumHeight:
				pRowOrColumn = (STSGridLayoutViewRowOrColumn *)[pLayout->pRows objectAtIndex:pConstraint->iCoordinate];
				if(pRowOrColumn->fMaximum > pConstraint->fValue)
					pRowOrColumn->fMaximum = pConstraint->fValue;
				break;
			case ConstraintTypeRowMaximumHeightPercent:
				pRowOrColumn = (STSGridLayoutViewRowOrColumn *)[pLayout->pRows objectAtIndex:pConstraint->iCoordinate];
				tmp = pConstraint->fValue * sTotalAvailableSize.height;
				if(pRowOrColumn->fMaximum > tmp)
					pRowOrColumn->fMaximum = tmp;
				break;
			case ConstraintTypeRowMinimumHeight:
				pRowOrColumn = (STSGridLayoutViewRowOrColumn *)[pLayout->pRows objectAtIndex:pConstraint->iCoordinate];
				if(pRowOrColumn->fMinimum < pConstraint->fValue)
					pRowOrColumn->fMinimum = pConstraint->fValue;
				break;
			case ConstraintTypeRowMinimumHeightPercent:
				pRowOrColumn = (STSGridLayoutViewRowOrColumn *)[pLayout->pRows objectAtIndex:pConstraint->iCoordinate];
				tmp = pConstraint->fValue * sTotalAvailableSize.height;
				if(pRowOrColumn->fMinimum < tmp)
					pRowOrColumn->fMinimum = tmp;
				break;
			case ConstraintTypeColumnExpandWeight:
				pRowOrColumn = (STSGridLayoutViewRowOrColumn *)[pLayout->pColumns objectAtIndex:pConstraint->iCoordinate];
				pRowOrColumn->fExpandWeight = pConstraint->fValue;
				pRowOrColumn->fExpandWeightDivisor = 1.0f;
				break;
			case ConstraintTypeColumnShrinkWeight:
				pRowOrColumn = (STSGridLayoutViewRowOrColumn *)[pLayout->pColumns objectAtIndex:pConstraint->iCoordinate];
				pRowOrColumn->fShrinkWeight = pConstraint->fValue;
				pRowOrColumn->fShrinkWeightDivisor = 1.0f;
				break;
			case ConstraintTypeColumnMaximumWidth:
				pRowOrColumn = (STSGridLayoutViewRowOrColumn *)[pLayout->pColumns objectAtIndex:pConstraint->iCoordinate];
				if(pRowOrColumn->fMaximum > pConstraint->fValue)
					pRowOrColumn->fMaximum = pConstraint->fValue;
				break;
			case ConstraintTypeColumnMaximumWidthPercent:
				pRowOrColumn = (STSGridLayoutViewRowOrColumn *)[pLayout->pColumns objectAtIndex:pConstraint->iCoordinate];
				tmp = pConstraint->fValue * sTotalAvailableSize.width;
				if(pRowOrColumn->fMaximum > tmp)
					pRowOrColumn->fMaximum = tmp;
				break;
			case ConstraintTypeColumnMinimumWidth:
				pRowOrColumn = (STSGridLayoutViewRowOrColumn *)[pLayout->pColumns objectAtIndex:pConstraint->iCoordinate];
				if(pRowOrColumn->fMinimum < pConstraint->fValue)
					pRowOrColumn->fMinimum = pConstraint->fValue;
				break;
			case ConstraintTypeColumnMinimumWidthPercent:
				pRowOrColumn = (STSGridLayoutViewRowOrColumn *)[pLayout->pColumns objectAtIndex:pConstraint->iCoordinate];
				tmp = pConstraint->fValue * sTotalAvailableSize.width;
				if(pRowOrColumn->fMinimum < tmp)
					pRowOrColumn->fMinimum = tmp;
				break;
		}
	}
	
	CGSize sUsedSize = CGSizeZero;
	CGSize sMinimumSize = CGSizeZero;
	
	for(pRowOrColumn in pLayout->pColumns)
	{
		pRowOrColumn->fExpandWeight /= pRowOrColumn->fExpandWeightDivisor;
		pRowOrColumn->fShrinkWeight /= pRowOrColumn->fShrinkWeightDivisor;
#ifndef USE_MAXIMUM_PREFERRED
		pRowOrColumn->fPreferred /= pRowOrColumn->fPreferredDivisor;
#endif
		if(pRowOrColumn->fMaximum < pRowOrColumn->fMinimum)
			pRowOrColumn->fMaximum = pRowOrColumn->fMinimum;
		
		if(pRowOrColumn->fPreferred < pRowOrColumn->fMinimum)
		{
			pRowOrColumn->fActual = pRowOrColumn->fMinimum;
			pRowOrColumn->fShrinkWeight = 0.0f; // don't shrink
		} else if(pRowOrColumn->fPreferred > pRowOrColumn->fMaximum)
		{
			pRowOrColumn->fActual = pRowOrColumn->fMaximum;
			pRowOrColumn->fExpandWeight = 0.0f; // don't expand
		} else {
			pRowOrColumn->fActual = pRowOrColumn->fPreferred;
		}
		
		sUsedSize.width += pRowOrColumn->fActual;
		sMinimumSize.width += pRowOrColumn->fMinimum;
	}

	for(pRowOrColumn in pLayout->pRows)
	{
		pRowOrColumn->fExpandWeight /= pRowOrColumn->fExpandWeightDivisor;
		pRowOrColumn->fShrinkWeight /= pRowOrColumn->fShrinkWeightDivisor;
#ifndef USE_MAXIMUM_PREFERRED
		pRowOrColumn->fPreferred /= pRowOrColumn->fPreferredDivisor;
#endif
		if(pRowOrColumn->fMaximum < pRowOrColumn->fMinimum)
			pRowOrColumn->fMaximum = pRowOrColumn->fMinimum;
		
		if(pRowOrColumn->fPreferred < pRowOrColumn->fMinimum)
		{
			pRowOrColumn->fActual = pRowOrColumn->fMinimum;
			pRowOrColumn->fShrinkWeight = 0.0f; // don't shrink
		} else if(pRowOrColumn->fPreferred > pRowOrColumn->fMaximum)
		{
			pRowOrColumn->fActual = pRowOrColumn->fMaximum;
			pRowOrColumn->fExpandWeight = 0.0f; // don't expand
		} else {
			pRowOrColumn->fActual = pRowOrColumn->fPreferred;
		}

		sUsedSize.height += pRowOrColumn->fActual;
		sMinimumSize.height += pRowOrColumn->fMinimum;
	}

	[self _adjustRowsOrColumns:pLayout->pColumns forAvailableSize:sTotalAvailableSize.width andUsedSize:sUsedSize.width];

	
	
	pLayout->sMinimumSize = CGSizeMake(sLockedSize.width + sMinimumSize.width,sLockedSize.height + sMinimumSize.height);
	pLayout->sPreferredSize = CGSizeMake(sLockedSize.width + sUsedSize.width,sLockedSize.height + sUsedSize.height);
#ifdef DEBUG_LAYOUT
	STS_CORE_LOG(@"Minimum size is %f,%f",pLayout->sMinimumSize.width,pLayout->sMinimumSize.height);
	STS_CORE_LOG(@"Preferred size is %f,%f",pLayout->sPreferredSize.width,pLayout->sPreferredSize.height);
#endif

	[self _adjustRowsOrColumns:pLayout->pRows forAvailableSize:sTotalAvailableSize.height andUsedSize:sUsedSize.height];
	
	pLayout->sActualSize = CGSizeMake(
			[self _assignCoordinatesAndComputeTotal:pLayout->pColumns forStartMargin:m_fLeftMargin endMargin:m_fRightMargin andSpacing:m_fColumnSpacing],
			[self _assignCoordinatesAndComputeTotal:pLayout->pRows forStartMargin:m_fTopMargin endMargin:m_fBottomMargin andSpacing:m_fRowSpacing]
		);
	
#ifdef DEBUG_LAYOUT
	STS_CORE_LOG(@"Actual size is %f,%f",pLayout->sActualSize.width,pLayout->sActualSize.height);
#endif

	// apply row/column sizes to items
	
	for(pItem in m_pItems)
	{
		STSGridLayoutViewView * vv = [[STSGridLayoutViewView alloc] init];
		vv->pItem = pItem;
		vv->pView = pItem->pView;
		
		pRowOrColumn = [pLayout->pColumns objectAtIndex:pItem->iColumn];
		
		CGFloat x1 = pRowOrColumn->fStart;
		
		pRowOrColumn = [pLayout->pColumns objectAtIndex:pItem->iLastColumn];
		
		CGFloat x2 = pRowOrColumn->fStart + pRowOrColumn->fActual;
		
		pRowOrColumn = [pLayout->pRows objectAtIndex:pItem->iRow];
		
		CGFloat y1 = pRowOrColumn->fStart;
		
		pRowOrColumn = [pLayout->pRows objectAtIndex:pItem->iLastRow];
		
		CGFloat y2 = pRowOrColumn->fStart + pRowOrColumn->fActual;

		CGFloat fWidth = x2 - x1;
		CGFloat fHeight = y2 - y1;
		
		if(fWidth > pItem->sMaximumSize.width)
			fWidth = pItem->sMaximumSize.width;
		if(fHeight > pItem->sMaximumSize.height)
			fHeight = pItem->sMaximumSize.height;
		
		if(pItem->pMargins)
		{
			CGFloat ml = pItem->pMargins.left;
			CGFloat mt = pItem->pMargins.top;
			CGFloat fViewWidth = fWidth - ml - pItem->pMargins.right;
			if(fViewWidth < 0.0)
			{
				fViewWidth = 0.0;
				ml = 0.0; // doesn't matter
			}
			CGFloat fViewHeight = fHeight - mt - pItem->pMargins.bottom;
			if(fViewHeight < 0.0)
			{
				fViewHeight = 0.0;
				mt = 0.0; // doesn't matter
			}
			vv->rRect = CGRectMake(x1 + ml,y1 + mt,fViewWidth,fViewHeight);
		} else {
			vv->rRect = CGRectMake(x1,y1,fWidth,fHeight);
		}
		
#ifdef DEBUG_LAYOUT
		STS_CORE_LOG(@"View at (%d,%d) rect (%f,%f,%f,%f)",pItem->iRow,pItem->iColumn,vv->rRect.origin.x,vv->rRect.origin.y,vv->rRect.size.width,vv->rRect.size.height);
#endif

		[pLayout->pViews addObject:vv];
	}
	
	return pLayout;
}

#else

- (STSGridLayoutViewLayout *)_computeLayoutForSize:(CGSize)sRequestedSize
{
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// NEW VERSION: FIRST THE ROWS, THEN THE COLUMNS

#ifdef DEBUG_LAYOUT
	STS_CORE_LOG_ENTER(@"Requested size is %f,%f",sRequestedSize.width,sRequestedSize.height);
#endif
	
	STSGridLayoutViewLayout * pLayout = [[STSGridLayoutViewLayout alloc] init];
	
	pLayout->pViews = [[NSMutableArray alloc] init];
	pLayout->pRows = [[NSMutableArray alloc] init];
	pLayout->pColumns = [[NSMutableArray alloc] init];
	
	pLayout->sRequestedSize = sRequestedSize;
	pLayout->iRows = 0;
	pLayout->iColumns = 0;
	
	STSGridLayoutViewItem * pItem;
	STSGridLayoutViewConstraint * pConstraint;
	STSGridLayoutViewRowOrColumn * pRowOrColumn;
	
	int iLastRow = 0;
	int iLastColumn = 0;

	/////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// INITIAL COMMON PART
	
	// Get the contents size as "intrisic content size".
	// This *may* be overridden later by a call to sizeThatFits
	for(pItem in m_pItems)
	{
		pItem->sContentsSize = [pItem->pView intrinsicContentSize];

#ifdef DEBUG_LAYOUT
		STS_CORE_LOG(@"View %x:%@ at (%d,%d) intrinsic size (%f,%f)",(unsigned int)pItem->pView,NSStringFromClass([pItem->pView class]),pItem->iRow,pItem->iColumn,pItem->sContentsSize.width,pItem->sContentsSize.height);
#endif

		// Some views tend to return [-1,-1]
		if(pItem->sContentsSize.width < 0.0)
			pItem->sContentsSize.width = 0.0;
		if(pItem->sContentsSize.height < 0.0)
			pItem->sContentsSize.height = 0.0;
		
		if(pItem->pMargins)
		{
			pItem->sContentsSize = CGSizeMake(
					pItem->sContentsSize.width + pItem->pMargins.left + pItem->pMargins.right,
					pItem->sContentsSize.height + pItem->pMargins.top + pItem->pMargins.bottom
				);
		}

		//pItem->sPreferredSize = [pItem->pView sizeThatFits:pLayout->sRequestedSize];
		
		switch(pItem->eHorizontalSizePolicy)
		{
			case STSSizePolicyIgnore:
				pItem->sMinimumSize.width = 0.0f;
				pItem->sMaximumSize.width = 99999.9f;
				pItem->sPreferredSize.width = 0.0f;
				break;
			case STSSizePolicyFixed:
				pItem->sMinimumSize.width = pItem->sContentsSize.width;
				pItem->sMaximumSize.width = pItem->sContentsSize.width;
				pItem->sPreferredSize.width = pItem->sContentsSize.width;
				break;
			case STSSizePolicyCanExpand:
			case STSSizePolicyShouldExpand:
				pItem->sPreferredSize.width = pItem->sContentsSize.width;
				pItem->sMinimumSize.width = pItem->sContentsSize.width;
				pItem->sMaximumSize.width = 99999.9f;
				break;
			case STSSizePolicyCanShrink:
				pItem->sPreferredSize.width = pItem->sContentsSize.width;
				pItem->sMaximumSize.width = pItem->sContentsSize.width;
				pItem->sMinimumSize.width = 0.0f;
				break;
				//case STSSizePolicyCanShrinkAndExpand:
				//case STSSizePolicyCanShrinkButShouldExpand:
			default:
				pItem->sPreferredSize.width = pItem->sContentsSize.width;
				pItem->sMinimumSize.width = 0.0f;
				pItem->sMaximumSize.width = 99999.9f;
				break;
		}
		
		switch(pItem->eVerticalSizePolicy)
		{
			case STSSizePolicyIgnore:
				pItem->sMinimumSize.height = 0.0f;
				pItem->sMaximumSize.height = 99999.9f;
				pItem->sPreferredSize.height = 0.0f;
				break;
			case STSSizePolicyFixed:
				pItem->sMinimumSize.height = pItem->sContentsSize.height;
				pItem->sMaximumSize.height = pItem->sContentsSize.height;
				pItem->sPreferredSize.height = pItem->sContentsSize.height;
				break;
			case STSSizePolicyCanExpand:
			case STSSizePolicyShouldExpand:
				pItem->sPreferredSize.height = pItem->sContentsSize.height;
				pItem->sMinimumSize.height = pItem->sContentsSize.height;
				pItem->sMaximumSize.height = 99999.9f;
				break;
			case STSSizePolicyCanShrink:
				pItem->sPreferredSize.height = pItem->sContentsSize.height;
				pItem->sMaximumSize.height = pItem->sContentsSize.height;
				pItem->sMinimumSize.height = 0.0f;
				break;
				//case STSSizePolicyCanShrinkAndExpand:
				//case STSSizePolicyCanShrinkButShouldExpand:
			default:
				pItem->sPreferredSize.height = pItem->sContentsSize.height;
				pItem->sMinimumSize.height = 0.0f;
				pItem->sMaximumSize.height = 99999.9f;
				break;
		}
		
		if(iLastRow < pItem->iLastRow)
			iLastRow = pItem->iLastRow;
		if(iLastColumn < pItem->iLastColumn)
			iLastColumn = pItem->iLastColumn;
	}
	
	for(pConstraint in m_pConstraints)
	{
		switch(pConstraint->eType)
		{
			case ConstraintTypeRowExpandWeight:
			case ConstraintTypeRowShrinkWeight:
			case ConstraintTypeRowMaximumHeight:
			case ConstraintTypeRowMinimumHeight:
			case ConstraintTypeRowMaximumHeightPercent:
			case ConstraintTypeRowMinimumHeightPercent:
				if(iLastRow < pConstraint->iCoordinate)
					iLastRow = pConstraint->iCoordinate;
				break;
			case ConstraintTypeColumnExpandWeight:
			case ConstraintTypeColumnShrinkWeight:
			case ConstraintTypeColumnMaximumWidth:
			case ConstraintTypeColumnMinimumWidth:
			case ConstraintTypeColumnMaximumWidthPercent:
			case ConstraintTypeColumnMinimumWidthPercent:
				if(iLastColumn < pConstraint->iCoordinate)
					iLastColumn = pConstraint->iCoordinate;
				break;
		}
	}
	
	pLayout->iRows = iLastRow + 1;
	pLayout->iColumns = iLastColumn + 1;
	
	int i;
	
	CGRect sScreen = [UIScreen mainScreen].bounds;
	
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// COLUMNS
	
	for(i=0;i<pLayout->iColumns;i++)
	{
		pRowOrColumn = [[STSGridLayoutViewRowOrColumn alloc] init];
		
		pRowOrColumn->fMinimum = 0.0f;
		pRowOrColumn->fMaximum = sScreen.size.width;
		pRowOrColumn->fActual = 0.0f;
		pRowOrColumn->fExpandWeight = 1.0f;
		pRowOrColumn->fExpandWeightDivisor = 1.0f;
		pRowOrColumn->fShrinkWeight = 1.0f;
		pRowOrColumn->fShrinkWeightDivisor = 1.0f;
		pRowOrColumn->fPreferred = 0.0f;
#ifndef USE_MAXIMUM_PREFERRED
		pRowOrColumn->fPreferredDivisor = 1.0f;
#endif
		[pLayout->pColumns addObject:pRowOrColumn];
	}
	
	for(pItem in m_pItems)
	{
		if(pItem->iColumnSpan == 1)
		{
			pRowOrColumn = (STSGridLayoutViewRowOrColumn *)[pLayout->pColumns objectAtIndex:pItem->iColumn];
			
			if(pRowOrColumn->fMinimum < pItem->sMinimumSize.width)
				pRowOrColumn->fMinimum = pItem->sMinimumSize.width;
			if(pRowOrColumn->fMaximum > pItem->sMaximumSize.width)
				pRowOrColumn->fMaximum = pItem->sMaximumSize.width;
			
			switch(pItem->eHorizontalSizePolicy)
			{
				case STSSizePolicyIgnore:
				case STSSizePolicyFixed:
				case STSSizePolicyCanShrink:
					pRowOrColumn->fShrinkWeight += 100.0f;
					pRowOrColumn->fShrinkWeightDivisor += 1.0f;
					break;
				case STSSizePolicyCanShrinkAndExpand:
					pRowOrColumn->fShrinkWeight += 100.0f;
					pRowOrColumn->fShrinkWeightDivisor += 1.0f;
					pRowOrColumn->fExpandWeight += 100.0f;
					pRowOrColumn->fExpandWeightDivisor += 1.0f;
					break;
				case STSSizePolicyCanExpand:
					pRowOrColumn->fExpandWeight += 200.0f;
					pRowOrColumn->fExpandWeightDivisor += 1.0f;
					break;
				case STSSizePolicyCanShrinkButShouldExpand:
					pRowOrColumn->fShrinkWeight += 100.0f;
					pRowOrColumn->fShrinkWeightDivisor += 1.0f;
					pRowOrColumn->fExpandWeight += 500.0f;
					pRowOrColumn->fExpandWeightDivisor += 1.0f;
					break;
				case STSSizePolicyShouldExpand:
					pRowOrColumn->fExpandWeight += 500.0f;
					pRowOrColumn->fExpandWeightDivisor += 1.0f;
					break;
			}
			
			switch(pItem->eHorizontalSizePolicy)
			{
				case STSSizePolicyIgnore:
					break;
				case STSSizePolicyFixed:
				case STSSizePolicyCanShrinkAndExpand:
				case STSSizePolicyCanExpand:
				case STSSizePolicyShouldExpand:
				case STSSizePolicyCanShrink:
				case STSSizePolicyCanShrinkButShouldExpand:
#ifdef USE_MAXIMUM_PREFERRED
					if(pItem->sPreferredSize.width > pRowOrColumn->fPreferred)
						pRowOrColumn->fPreferred = pItem->sPreferredSize.width;
#else
					pRowOrColumn->fPreferred += pItem->sPreferredSize.width;
					pRowOrColumn->fPreferredDivisor += 1.0f;
#endif
					break;
			}
		} else {
			for(i=pItem->iColumn;i<=pItem->iLastColumn;i++)
			{
				pRowOrColumn = (STSGridLayoutViewRowOrColumn *)[pLayout->pColumns objectAtIndex:i];
				
				switch(pItem->eHorizontalSizePolicy)
				{
					case STSSizePolicyIgnore:
					case STSSizePolicyFixed:
					case STSSizePolicyCanShrink:
						pRowOrColumn->fShrinkWeight += 100.0f / ((CGFloat)(pItem->iColumnSpan));
						pRowOrColumn->fShrinkWeightDivisor += 1.0f;
						break;
					case STSSizePolicyCanShrinkAndExpand:
						pRowOrColumn->fShrinkWeight += 100.0f / ((CGFloat)(pItem->iColumnSpan));
						pRowOrColumn->fShrinkWeightDivisor += 1.0f;
						pRowOrColumn->fExpandWeight += 100.0f / ((CGFloat)(pItem->iColumnSpan));
						pRowOrColumn->fExpandWeightDivisor += 1.0f;
						break;
					case STSSizePolicyCanExpand:
						pRowOrColumn->fExpandWeight += 200.0f / ((CGFloat)(pItem->iColumnSpan));
						pRowOrColumn->fExpandWeightDivisor += 1.0f;
						break;
					case STSSizePolicyCanShrinkButShouldExpand:
						pRowOrColumn->fShrinkWeight += 100.0f / ((CGFloat)(pItem->iColumnSpan));
						pRowOrColumn->fShrinkWeightDivisor += 1.0f;
						pRowOrColumn->fExpandWeight += 500.0f / ((CGFloat)(pItem->iColumnSpan));
						pRowOrColumn->fExpandWeightDivisor += 1.0f;
						break;
					case STSSizePolicyShouldExpand:
						pRowOrColumn->fExpandWeight += 500.0f / ((CGFloat)(pItem->iColumnSpan));
						pRowOrColumn->fExpandWeightDivisor += 1.0f;
						break;
				}
				
				switch(pItem->eHorizontalSizePolicy)
				{
					case STSSizePolicyIgnore:
						break;
					case STSSizePolicyFixed:
					case STSSizePolicyCanShrinkAndExpand:
					case STSSizePolicyCanExpand:
					case STSSizePolicyShouldExpand:
					case STSSizePolicyCanShrink:
					case STSSizePolicyCanShrinkButShouldExpand:
					{
						CGFloat fPreferred = pItem->sPreferredSize.width / ((CGFloat)(pItem->iColumnSpan));
#ifdef USE_MAXIMUM_PREFERRED
						if(fPreferred > pRowOrColumn->fPreferred)
							pRowOrColumn->fPreferred = fPreferred;
#else
						pRowOrColumn->fPreferred += fPreferred;
						pRowOrColumn->fPreferredDivisor += 1.0f;
#endif
					}
						break;
				}
			}
		}
	}
	
	// Margins and spacings
	CGFloat fLockedWidth = m_fLeftMargin + m_fRightMargin + ((pLayout->iColumns - 1) * m_fColumnSpacing);
	CGFloat fTotalAvailableWidth = pLayout->sRequestedSize.width > fLockedWidth ? (pLayout->sRequestedSize.width - fLockedWidth) : 0.0f;

	CGFloat tmp;
	
	// Now we can apply user constraints (which will eventually override the computed values)
	// Only for columns
	for(pConstraint in m_pConstraints)
	{
		switch(pConstraint->eType)
		{
			case ConstraintTypeColumnExpandWeight:
				pRowOrColumn = (STSGridLayoutViewRowOrColumn *)[pLayout->pColumns objectAtIndex:pConstraint->iCoordinate];
				pRowOrColumn->fExpandWeight = pConstraint->fValue;
				pRowOrColumn->fExpandWeightDivisor = 1.0f;
				break;
			case ConstraintTypeColumnShrinkWeight:
				pRowOrColumn = (STSGridLayoutViewRowOrColumn *)[pLayout->pColumns objectAtIndex:pConstraint->iCoordinate];
				pRowOrColumn->fShrinkWeight = pConstraint->fValue;
				pRowOrColumn->fShrinkWeightDivisor = 1.0f;
				break;
			case ConstraintTypeColumnMaximumWidth:
				pRowOrColumn = (STSGridLayoutViewRowOrColumn *)[pLayout->pColumns objectAtIndex:pConstraint->iCoordinate];
				if(pRowOrColumn->fMaximum > pConstraint->fValue)
					pRowOrColumn->fMaximum = pConstraint->fValue;
				break;
			case ConstraintTypeColumnMaximumWidthPercent:
				pRowOrColumn = (STSGridLayoutViewRowOrColumn *)[pLayout->pColumns objectAtIndex:pConstraint->iCoordinate];
				tmp = pConstraint->fValue * fTotalAvailableWidth;
				if(pRowOrColumn->fMaximum > tmp)
					pRowOrColumn->fMaximum = tmp;
				break;
			case ConstraintTypeColumnMinimumWidth:
				pRowOrColumn = (STSGridLayoutViewRowOrColumn *)[pLayout->pColumns objectAtIndex:pConstraint->iCoordinate];
				if(pRowOrColumn->fMinimum < pConstraint->fValue)
					pRowOrColumn->fMinimum = pConstraint->fValue;
				break;
			case ConstraintTypeColumnMinimumWidthPercent:
				pRowOrColumn = (STSGridLayoutViewRowOrColumn *)[pLayout->pColumns objectAtIndex:pConstraint->iCoordinate];
				tmp = pConstraint->fValue * fTotalAvailableWidth;
				if(pRowOrColumn->fMinimum < tmp)
					pRowOrColumn->fMinimum = tmp;
				break;
			default:
				break;
		}
	}
	
	CGFloat fUsedWidth = 0.0;
	CGFloat fMinimumWidth = 0.0;
	
	for(pRowOrColumn in pLayout->pColumns)
	{
		pRowOrColumn->fExpandWeight /= pRowOrColumn->fExpandWeightDivisor;
		pRowOrColumn->fShrinkWeight /= pRowOrColumn->fShrinkWeightDivisor;
#ifndef USE_MAXIMUM_PREFERRED
		pRowOrColumn->fPreferred /= pRowOrColumn->fPreferredDivisor;
#endif
		if(pRowOrColumn->fMaximum < pRowOrColumn->fMinimum)
			pRowOrColumn->fMaximum = pRowOrColumn->fMinimum;
		
		if(pRowOrColumn->fPreferred < pRowOrColumn->fMinimum)
		{
			pRowOrColumn->fActual = pRowOrColumn->fMinimum;
			pRowOrColumn->fShrinkWeight = 0.0f; // don't shrink
		} else if(pRowOrColumn->fPreferred > pRowOrColumn->fMaximum)
		{
			pRowOrColumn->fActual = pRowOrColumn->fMaximum;
			pRowOrColumn->fExpandWeight = 0.0f; // don't expand
		} else {
			pRowOrColumn->fActual = pRowOrColumn->fPreferred;
		}
		
		fUsedWidth += pRowOrColumn->fActual;
		fMinimumWidth += pRowOrColumn->fMinimum;
	}
	
	[self _adjustRowsOrColumns:pLayout->pColumns forAvailableSize:fTotalAvailableWidth andUsedSize:fUsedWidth];

	CGFloat fActualWidth = [self _assignCoordinatesAndComputeTotal:pLayout->pColumns forStartMargin:m_fLeftMargin endMargin:m_fRightMargin andSpacing:m_fColumnSpacing];
	
	// apply column sizes to items
	
	for(pItem in m_pItems)
	{
		STSGridLayoutViewView * vv = [[STSGridLayoutViewView alloc] init];
		vv->pItem = pItem;
		vv->pView = pItem->pView;
		
		pRowOrColumn = [pLayout->pColumns objectAtIndex:pItem->iColumn];
		
		CGFloat x1 = pRowOrColumn->fStart;
		
		pRowOrColumn = [pLayout->pColumns objectAtIndex:pItem->iLastColumn];
		
		CGFloat x2 = pRowOrColumn->fStart + pRowOrColumn->fActual;
		
		CGFloat fWidth = x2 - x1;
		
		if(fWidth > pItem->sMaximumSize.width)
			fWidth = pItem->sMaximumSize.width;
		
		if(pItem->pMargins)
		{
			CGFloat ml = pItem->pMargins.left;
			CGFloat fViewWidth = fWidth - ml - pItem->pMargins.right;
			if(fViewWidth < 0.0)
			{
				fViewWidth = 0.0;
				ml = 0.0; // doesn't matter
			}
			pItem->fAssignedWidth = fViewWidth;
			vv->rRect = CGRectMake(x1 + ml,0.0,fViewWidth,0.0);
		} else {
			pItem->fAssignedWidth = fWidth;
			vv->rRect = CGRectMake(x1,0.0,fWidth,0.0);
		}

		[pLayout->pViews addObject:vv];
	}

	
	// ROWS
	
	// First of all recompute the preferred height of items that have been assigned an "unexpected" width

	for(pItem in m_pItems)
	{
		if(fabs(pItem->fAssignedWidth - pItem->sContentsSize.width) < 1.0)
			continue; // assigned the requested width

		if(pItem->eVerticalSizePolicy == STSSizePolicyIgnore)
			continue; // ignore at all

		CGSize sFitting = [pItem->pView sizeThatFits:CGSizeMake(pItem->fAssignedWidth,99999.9f)];
		
#ifdef DEBUG_LAYOUT
		STS_CORE_LOG(@"View %x:%@ at (%d,%d) size that fits width of %f is (%f,%f)",(unsigned int)pItem->pView,NSStringFromClass([pItem->pView class]),pItem->iRow,pItem->iColumn,pItem->fAssignedWidth,sFitting.width,sFitting.height);
#endif

		if(sFitting.height > 99000.0f)
			continue; // bogus: the view said that it would take all the vertical space we give it.

		// The view reported an actual vertical size
		if(pItem->pMargins)
		{
			pItem->sContentsSize = CGSizeMake(
					  sFitting.width + pItem->pMargins.left + pItem->pMargins.right,
					  sFitting.height + pItem->pMargins.top + pItem->pMargins.bottom
				  );
		} else {
			pItem->sContentsSize = sFitting;
		}

#ifdef DEBUG_LAYOUT
		STS_CORE_LOG(@"View %x:%@ at (%d,%d) content size is (%f,%f)",(unsigned int)pItem->pView,NSStringFromClass([pItem->pView class]),pItem->iRow,pItem->iColumn,pItem->sContentsSize.width,pItem->sContentsSize.height);
#endif

		// adjust minimum/maximum/preferred
		switch(pItem->eVerticalSizePolicy)
		{
			case STSSizePolicyIgnore:
				// never here (skipped above)
				break;
			case STSSizePolicyFixed:
				pItem->sMinimumSize.height = pItem->sContentsSize.height;
				pItem->sMaximumSize.height = pItem->sContentsSize.height;
				pItem->sPreferredSize.height = pItem->sContentsSize.height;
				break;
			case STSSizePolicyCanExpand:
			case STSSizePolicyShouldExpand:
				pItem->sPreferredSize.height = pItem->sContentsSize.height;
				pItem->sMinimumSize.height = pItem->sContentsSize.height;
				pItem->sMaximumSize.height = 99999.9f;
				break;
			case STSSizePolicyCanShrink:
				pItem->sPreferredSize.height = pItem->sContentsSize.height;
				pItem->sMaximumSize.height = pItem->sContentsSize.height;
				pItem->sMinimumSize.height = 0.0f;
				break;
				//case STSSizePolicyCanShrinkAndExpand:
				//case STSSizePolicyCanShrinkButShouldExpand:
			default:
				pItem->sPreferredSize.height = pItem->sContentsSize.height;
				pItem->sMinimumSize.height = 0.0f;
				pItem->sMaximumSize.height = 99999.9f;
				break;
		}
	}

	for(i=0;i<pLayout->iRows;i++)
	{
		pRowOrColumn = [[STSGridLayoutViewRowOrColumn alloc] init];
		
		pRowOrColumn->fMinimum = 0.0f;
		pRowOrColumn->fMaximum = 999999.9f;
		pRowOrColumn->fActual = 0.0f;
		pRowOrColumn->fExpandWeight = 1.0f;
		pRowOrColumn->fExpandWeightDivisor = 1.0f;
		pRowOrColumn->fShrinkWeight = 1.0f;
		pRowOrColumn->fShrinkWeightDivisor = 1.0f;
		pRowOrColumn->fPreferred = 0.0f;
#ifndef USE_MAXIMUM_PREFERRED
		pRowOrColumn->fPreferredDivisor = 1.0f;
#endif
		[pLayout->pRows addObject:pRowOrColumn];
	}

	for(pItem in m_pItems)
	{
		if(pItem->iRowSpan == 1)
		{
			pRowOrColumn = (STSGridLayoutViewRowOrColumn *)[pLayout->pRows objectAtIndex:pItem->iRow];
			
			if(pRowOrColumn->fMinimum < pItem->sMinimumSize.height)
				pRowOrColumn->fMinimum = pItem->sMinimumSize.height;
			if(pRowOrColumn->fMaximum > pItem->sMaximumSize.height)
				pRowOrColumn->fMaximum = pItem->sMaximumSize.height;
			
			switch(pItem->eVerticalSizePolicy)
			{
				case STSSizePolicyIgnore:
				case STSSizePolicyFixed:
				case STSSizePolicyCanShrink:
					pRowOrColumn->fShrinkWeight += 100.0f;
					pRowOrColumn->fShrinkWeightDivisor += 1.0f;
					break;
				case STSSizePolicyCanShrinkAndExpand:
					pRowOrColumn->fShrinkWeight += 100.0f;
					pRowOrColumn->fShrinkWeightDivisor += 1.0f;
					pRowOrColumn->fExpandWeight += 100.0f;
					pRowOrColumn->fExpandWeightDivisor += 1.0f;
					break;
				case STSSizePolicyCanExpand:
					pRowOrColumn->fExpandWeight += 200.0f;
					pRowOrColumn->fExpandWeightDivisor += 1.0f;
					break;
				case STSSizePolicyCanShrinkButShouldExpand:
					pRowOrColumn->fShrinkWeight += 100.0f;
					pRowOrColumn->fShrinkWeightDivisor += 1.0f;
					pRowOrColumn->fExpandWeight += 500.0f;
					pRowOrColumn->fExpandWeightDivisor += 1.0f;
					break;
				case STSSizePolicyShouldExpand:
					pRowOrColumn->fExpandWeight += 500.0f;
					pRowOrColumn->fExpandWeightDivisor += 1.0f;
					break;
			}
			
			switch(pItem->eVerticalSizePolicy)
			{
				case STSSizePolicyIgnore:
					break;
				case STSSizePolicyFixed:
				case STSSizePolicyCanShrinkAndExpand:
				case STSSizePolicyCanExpand:
				case STSSizePolicyShouldExpand:
				case STSSizePolicyCanShrink:
				case STSSizePolicyCanShrinkButShouldExpand:
#ifdef USE_MAXIMUM_PREFERRED
					if(pItem->sPreferredSize.height > pRowOrColumn->fPreferred)
						pRowOrColumn->fPreferred = pItem->sPreferredSize.height;
#else
					pRowOrColumn->fPreferred += pItem->sPreferredSize.height;
					pRowOrColumn->fPreferredDivisor += 1.0f;
#endif
					break;
			}
			
		} else {
			CGFloat fHeightToAssign = pItem->sPreferredSize.height;
			CGFloat fRowsRemaining = ((CGFloat)(pItem->iRowSpan));
			CGFloat fHeightPart = fHeightToAssign / fRowsRemaining;
		
			for(i=pItem->iRow;i<=pItem->iLastRow;i++)
			{
				pRowOrColumn = (STSGridLayoutViewRowOrColumn *)[pLayout->pRows objectAtIndex:i];
				
				switch(pItem->eVerticalSizePolicy)
				{
					case STSSizePolicyIgnore:
					case STSSizePolicyFixed:
					case STSSizePolicyCanShrink:
						pRowOrColumn->fShrinkWeight += 100.0f / ((CGFloat)(pItem->iRowSpan));
						pRowOrColumn->fShrinkWeightDivisor += 1.0f;
						break;
					case STSSizePolicyCanShrinkAndExpand:
						pRowOrColumn->fShrinkWeight += 100.0f / ((CGFloat)(pItem->iRowSpan));
						pRowOrColumn->fShrinkWeightDivisor += 1.0f;
						pRowOrColumn->fExpandWeight += 100.0f / ((CGFloat)(pItem->iRowSpan));
						pRowOrColumn->fExpandWeightDivisor += 1.0f;
						break;
					case STSSizePolicyCanExpand:
						pRowOrColumn->fExpandWeight += 200.0f / ((CGFloat)(pItem->iRowSpan));
						pRowOrColumn->fExpandWeightDivisor += 1.0f;
						break;
					case STSSizePolicyCanShrinkButShouldExpand:
						pRowOrColumn->fShrinkWeight += 100.0f / ((CGFloat)(pItem->iRowSpan));
						pRowOrColumn->fShrinkWeightDivisor += 1.0f;
						pRowOrColumn->fExpandWeight += 500.0f / ((CGFloat)(pItem->iRowSpan));
						pRowOrColumn->fExpandWeightDivisor += 1.0f;
						break;
					case STSSizePolicyShouldExpand:
						pRowOrColumn->fExpandWeight += 500.0f / ((CGFloat)(pItem->iRowSpan));
						pRowOrColumn->fExpandWeightDivisor += 1.0f;
						break;
				}
				
				switch(pItem->eVerticalSizePolicy)
				{
					case STSSizePolicyIgnore:
						break;
					case STSSizePolicyFixed:
					case STSSizePolicyCanShrinkAndExpand:
					case STSSizePolicyCanExpand:
					case STSSizePolicyShouldExpand:
					case STSSizePolicyCanShrink:
					case STSSizePolicyCanShrinkButShouldExpand:
					{
#ifdef USE_MAXIMUM_PREFERRED
						if(fHeightPart > pRowOrColumn->fPreferred)
						{
							pRowOrColumn->fPreferred = fHeightPart;
							fHeightToAssign -= fHeightPart;
						} else {
							fHeightToAssign -= pRowOrColumn->fPreferred;
						}
						
						fRowsRemaining -= 1.0;
						
						if(fHeightToAssign < 0.0)
						{
							fHeightToAssign = 0.0;
							fHeightPart = 0.0;
						} else {
							if(fRowsRemaining >= 1.0)
								fHeightPart = fHeightToAssign / fRowsRemaining;
							else
								fHeightPart = fHeightToAssign;
						}

#else
						pRowOrColumn->fPreferred += fPreferred;
						pRowOrColumn->fPreferredDivisor += 1.0f;
#endif
#ifdef DEBUG_LAYOUT
						STS_CORE_LOG(@"View %x:%@ at (%d,%d) row %d preferred height %f",(unsigned int)pItem->pView,NSStringFromClass([pItem->pView class]),pItem->iRow,pItem->iColumn,i,pRowOrColumn->fPreferred);
#endif

					}
					break;
				}
			}
		}
		
	}

	// Margins and spacings
	CGFloat fLockedHeight = m_fTopMargin + m_fBottomMargin + ((pLayout->iRows - 1) * m_fRowSpacing);
	CGFloat fTotalAvailableHeight = pLayout->sRequestedSize.height > fLockedHeight ? (pLayout->sRequestedSize.height - fLockedHeight) : 0.0f;
	
	// Now we can apply user constraints (which will eventually override the computed values)
	// Only for rows
	for(pConstraint in m_pConstraints)
	{
		switch(pConstraint->eType)
		{
			case ConstraintTypeRowExpandWeight:
				pRowOrColumn = (STSGridLayoutViewRowOrColumn *)[pLayout->pRows objectAtIndex:pConstraint->iCoordinate];
				pRowOrColumn->fExpandWeight = pConstraint->fValue;
				pRowOrColumn->fExpandWeightDivisor = 1.0f;
				break;
			case ConstraintTypeRowShrinkWeight:
				pRowOrColumn = (STSGridLayoutViewRowOrColumn *)[pLayout->pRows objectAtIndex:pConstraint->iCoordinate];
				pRowOrColumn->fShrinkWeight = pConstraint->fValue;
				pRowOrColumn->fShrinkWeightDivisor = 1.0f;
				break;
			case ConstraintTypeRowMaximumHeight:
				pRowOrColumn = (STSGridLayoutViewRowOrColumn *)[pLayout->pRows objectAtIndex:pConstraint->iCoordinate];
				if(pRowOrColumn->fMaximum > pConstraint->fValue)
					pRowOrColumn->fMaximum = pConstraint->fValue;
				break;
			case ConstraintTypeRowMaximumHeightPercent:
				pRowOrColumn = (STSGridLayoutViewRowOrColumn *)[pLayout->pRows objectAtIndex:pConstraint->iCoordinate];
				tmp = pConstraint->fValue * fTotalAvailableHeight;
				if(pRowOrColumn->fMaximum > tmp)
					pRowOrColumn->fMaximum = tmp;
				break;
			case ConstraintTypeRowMinimumHeight:
				pRowOrColumn = (STSGridLayoutViewRowOrColumn *)[pLayout->pRows objectAtIndex:pConstraint->iCoordinate];
				if(pRowOrColumn->fMinimum < pConstraint->fValue)
					pRowOrColumn->fMinimum = pConstraint->fValue;
				break;
			case ConstraintTypeRowMinimumHeightPercent:
				pRowOrColumn = (STSGridLayoutViewRowOrColumn *)[pLayout->pRows objectAtIndex:pConstraint->iCoordinate];
				tmp = pConstraint->fValue * fTotalAvailableHeight;
				if(pRowOrColumn->fMinimum < tmp)
					pRowOrColumn->fMinimum = tmp;
				break;
			default:
				break;
		}
	}

	CGFloat fUsedHeight = 0.0;
	CGFloat fMinimumHeight = 0.0;

	for(pRowOrColumn in pLayout->pRows)
	{
		pRowOrColumn->fExpandWeight /= pRowOrColumn->fExpandWeightDivisor;
		pRowOrColumn->fShrinkWeight /= pRowOrColumn->fShrinkWeightDivisor;
#ifndef USE_MAXIMUM_PREFERRED
		pRowOrColumn->fPreferred /= pRowOrColumn->fPreferredDivisor;
#endif
		if(pRowOrColumn->fMaximum < pRowOrColumn->fMinimum)
			pRowOrColumn->fMaximum = pRowOrColumn->fMinimum;
		
		if(pRowOrColumn->fPreferred < pRowOrColumn->fMinimum)
		{
			pRowOrColumn->fActual = pRowOrColumn->fMinimum;
			pRowOrColumn->fShrinkWeight = 0.0f; // don't shrink
		} else if(pRowOrColumn->fPreferred > pRowOrColumn->fMaximum)
		{
			pRowOrColumn->fActual = pRowOrColumn->fMaximum;
			pRowOrColumn->fExpandWeight = 0.0f; // don't expand
		} else {
			pRowOrColumn->fActual = pRowOrColumn->fPreferred;
		}
		
		fUsedHeight += pRowOrColumn->fActual;
		fMinimumHeight += pRowOrColumn->fMinimum;
	}

	[self _adjustRowsOrColumns:pLayout->pRows forAvailableSize:fTotalAvailableHeight andUsedSize:fUsedHeight];

	CGFloat fActualHeight = [self _assignCoordinatesAndComputeTotal:pLayout->pRows forStartMargin:m_fTopMargin endMargin:m_fBottomMargin andSpacing:m_fRowSpacing];
	
	// apply row sizes
	
	for(STSGridLayoutViewView * vv in pLayout->pViews)
	{
		pItem = vv->pItem;

		pRowOrColumn = [pLayout->pRows objectAtIndex:pItem->iRow];
		
		CGFloat y1 = pRowOrColumn->fStart;
		
		pRowOrColumn = [pLayout->pRows objectAtIndex:pItem->iLastRow];
		
		CGFloat y2 = pRowOrColumn->fStart + pRowOrColumn->fActual;
		
		CGFloat fHeight = y2 - y1;
		
		if(fHeight > pItem->sMaximumSize.height)
			fHeight = pItem->sMaximumSize.height;
		
		if(pItem->pMargins)
		{
			CGFloat mt = pItem->pMargins.top;
			CGFloat fViewHeight = fHeight - mt - pItem->pMargins.bottom;
			if(fViewHeight < 0.0)
			{
				fViewHeight = 0.0;
				mt = 0.0; // doesn't matter
			}
			vv->rRect = CGRectMake(vv->rRect.origin.x,y1 + mt,vv->rRect.size.width,fViewHeight);
		} else {
			vv->rRect = CGRectMake(vv->rRect.origin.x,y1,vv->rRect.size.width,fHeight);
		}
		
#ifdef DEBUG_LAYOUT
		STS_CORE_LOG(@"View %x:%@ at (%d,%d) rect (%f,%f,%f,%f)",(unsigned int)pItem->pView,NSStringFromClass([pItem->pView class]),pItem->iRow,pItem->iColumn,vv->rRect.origin.x,vv->rRect.origin.y,vv->rRect.size.width,vv->rRect.size.height);
#endif
	}

	pLayout->sMinimumSize = CGSizeMake(fLockedWidth + fMinimumWidth,fLockedHeight + fMinimumHeight);
	pLayout->sPreferredSize = CGSizeMake(fLockedWidth + fUsedWidth,fLockedHeight + fUsedHeight);
	pLayout->sActualSize = CGSizeMake(fActualWidth,fActualHeight);
	
#ifdef DEBUG_LAYOUT
	STS_CORE_LOG(@"Minimum size is %f,%f",pLayout->sMinimumSize.width,pLayout->sMinimumSize.height);
	STS_CORE_LOG(@"Preferred size is %f,%f",pLayout->sPreferredSize.width,pLayout->sPreferredSize.height);
	STS_CORE_LOG(@"Actual size is %f,%f",pLayout->sActualSize.width,pLayout->sActualSize.height);
	STS_CORE_LOG_LEAVE(@"Layout computed");
#endif
	
	
	return pLayout;
}


#endif

- (CGFloat)_assignCoordinatesAndComputeTotal:(NSMutableArray *)aRowsOrColumns forStartMargin:(CGFloat)fStartMargin endMargin:(CGFloat)fEndMargin andSpacing:(CGFloat)fSpacing
{
	CGFloat v = fStartMargin - fSpacing;
	
	for(STSGridLayoutViewRowOrColumn * rc in aRowsOrColumns)
	{
		v += fSpacing;
		rc->fStart = v;
		v += rc->fActual;
	}
	
	return v + fEndMargin;
}

- (void)_adjustRowsOrColumns:(NSMutableArray *)aRowsOrColumns forAvailableSize:(CGFloat)fAvailable andUsedSize:(CGFloat)fUsed
{
	CGFloat fSpare = fAvailable - fUsed;

	STSGridLayoutViewRowOrColumn * pRowOrColumn;
	
	if((fSpare > -0.1f) && (fSpare < 0.1f))
		return;

#ifdef DEBUG_LAYOUT
	STS_CORE_LOG(@"_adjustRowsOrColumns for available %f used %f spare %f",fAvailable,fUsed,fSpare);
#endif
	
	// Spare or missing space (fSpare CAN be negative)
	
	BOOL bexpand = (fSpare > 0.0f);
		
	for(int i=0;i<3;i++)
	{
		CGFloat fWeightSum = 0.0f;
		
		for(pRowOrColumn in aRowsOrColumns)
			fWeightSum += bexpand ? pRowOrColumn->fExpandWeight : pRowOrColumn->fShrinkWeight;
		
		if(fWeightSum < 1.0f)
			fWeightSum = 1.0f;
		
		CGFloat fInitialSpare = fSpare;
		
#ifdef DEBUG_LAYOUT
		int idx = 0;
#endif
		for(pRowOrColumn in aRowsOrColumns)
		{
			CGFloat fWeight = bexpand ? pRowOrColumn->fExpandWeight : pRowOrColumn->fShrinkWeight;
			if(fWeight < 0.1f)
				continue;
			
			CGFloat fAdd = (fInitialSpare * fWeight) / fWeightSum;


			fSpare += pRowOrColumn->fActual;
			pRowOrColumn->fActual += fAdd;
			if(pRowOrColumn->fActual < pRowOrColumn->fMinimum)
			{
				pRowOrColumn->fActual = pRowOrColumn->fMinimum;
				pRowOrColumn->fShrinkWeight = 0.0f;
			} else if(pRowOrColumn->fActual > pRowOrColumn->fMaximum)
			{
				pRowOrColumn->fActual = pRowOrColumn->fMaximum;
				pRowOrColumn->fExpandWeight = 0.0f;
			}
#ifdef DEBUG_LAYOUT
			STS_CORE_LOG(@"Adding %f to row/column %d which became %f",fAdd,idx,pRowOrColumn->fActual);
			idx++;
#endif

			fSpare -= pRowOrColumn->fActual;
		}
		
		if((fSpare > -0.1f) && (fSpare < 0.1f))
			return;
	}

	// Ignore minimums and weights
/*
	CGFloat fAddToAll = fSpare / ((CGFloat)[aRowsOrColumns count]);
	
	for(pRowOrColumn in aRowsOrColumns)
	{
		pRowOrColumn->fActual += fAddToAll;
		if(pRowOrColumn->fActual < 0.0f)
			pRowOrColumn->fActual = 0.0f;
	}
*/
}

- (void)_applyLayout
{
#ifdef DEBUG_LAYOUT
	STS_CORE_LOG_ENTER(@"");
#endif

	if(!m_pLayout)
		m_pLayout = [self _computeLayoutForSize:self.frame.size];

	for(STSGridLayoutViewView * pView in m_pLayout->pViews)
		pView->pView.frame = pView->rRect;

#ifdef DEBUG_LAYOUT
	STS_CORE_LOG_LEAVE(@"");
#endif
}

- (void)layoutSubviews
{
#ifdef DEBUG_LAYOUT
	STS_CORE_LOG_ENTER(@"");
#endif
	if(
			(!m_pLayout) ||
	   		(fabs(m_pLayout->sRequestedSize.width - self.frame.size.width) > 0.1) ||
	   		(fabs(m_pLayout->sRequestedSize.height - self.frame.size.height) > 0.1)
	   )
	{
		if(m_pLayout)
			[self _dropLayout];
		m_pLayout = [self _computeLayoutForSize:self.frame.size];
	}

	[self _applyLayout];

#ifdef DEBUG_LAYOUT
	STS_CORE_LOG_LEAVE(@"");
#endif
}

- (CGSize)intrinsicContentSize
{
#ifdef DEBUG_LAYOUT
	STS_CORE_LOG_ENTER(@"");
#endif

	if(!m_pLayout)
		m_pLayout = [self _computeLayoutForSize:self.frame.size];

#ifdef DEBUG_LAYOUT
	STS_CORE_LOG_LEAVE(@"Returning %f,%f",m_pLayout->sPreferredSize.width,m_pLayout->sPreferredSize.height);
#endif

	return m_pLayout->sPreferredSize;
}

- (CGSize)sizeThatFits:(CGSize)size
{
#ifdef DEBUG_LAYOUT
	STS_CORE_LOG_ENTER(@"Size that fits (%f,%f)",size.width,size.height);
#endif

	STSGridLayoutViewLayout * pLayout = nil;
	
	if(m_pLayout)
	{
		if(
			(fabs(m_pLayout->sRequestedSize.width - size.width) < 0.1f) &&
			(fabs(m_pLayout->sRequestedSize.height - size.height) < 0.1f)
		)
			pLayout = m_pLayout;
	}

	if(!pLayout)
		pLayout = [self _computeLayoutForSize:size];

	// For width we return the actual size
	// For height we return the preferred, if fitting
	CGFloat fWidth = pLayout->sActualSize.width;
	CGFloat fHeight = pLayout->sPreferredSize.height;
	if(fHeight > size.height)
		fHeight = MAX(size.height,pLayout->sMinimumSize.height);

#ifdef DEBUG_LAYOUT
	STS_CORE_LOG_LEAVE(@"Returning (%f,%f)",fWidth,fHeight);
#endif

	return CGSizeMake(fWidth,fHeight);
}

-(void)sizeToFit
{
	if(!m_pLayout)
		m_pLayout = [self _computeLayoutForSize:self.frame.size];

	self.frame = CGRectMake(self.frame.origin.x,self.frame.origin.y,m_pLayout->sPreferredSize.width,m_pLayout->sPreferredSize.height);
	[self layoutSubviews];
}

@end
