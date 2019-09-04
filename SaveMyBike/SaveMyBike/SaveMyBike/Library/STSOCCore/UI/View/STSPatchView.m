//
//  STSPatchView.m
//  
//  Created by Szymon Tomasz Stefanek on 2/25/17.
//  Copyright © 2017 Szymon Tomasz Stefanek. All rights reserved.
//

#import "STSPatchView.h"
#import "STSCore.h"

//#define DEBUG_LAYOUT

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#define INVALID_FIXED_COLUMN 99999

@interface STSPatchViewItem : NSObject
{
@public
	UIView *  pView;
	
	unsigned int uFlags;
	unsigned int uFixedColumn;
	
	// Runtime
	CGSize sContentsSize;
}
@end

@implementation STSPatchViewItem
@end

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

typedef enum _STSPatchViewConstraintType
{
	STSPatchViewConstraintColumnFixedWidth,
	STSPatchViewConstraintColumnFixedWidthPercent
} STSPatchViewConstraintType;

@interface STSPatchViewConstraint : NSObject
{
@public
	STSPatchViewConstraintType eType;
	unsigned int uColumn;
	CGFloat fValue;
}
@end

@implementation STSPatchViewConstraint
@end


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@interface STSPatchViewView : NSObject
{
@public
	UIView * pView;
	CGRect rRect;
}
@end

@implementation STSPatchViewView
@end

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@interface STSPatchViewColumn : NSObject
{
@public
	NSMutableArray<STSPatchViewItem *> * pItems;
	
	CGFloat fX;
	CGFloat fWidth;
	
	CGFloat fMaxPreferredWidth;
	
	CGFloat fUsedHeight;
}
@end

@implementation STSPatchViewColumn
@end

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@interface STSPatchViewLayout : NSObject
{
@public
	NSMutableArray<STSPatchViewColumn *> * pColumns;
	NSMutableArray<STSPatchViewView *> * pViews;
	
	CGSize sRequestedSize;

	CGSize sMinimumSize;
	CGSize sPreferredSize;
	CGSize sActualSize;
}
@end

@implementation STSPatchViewLayout : NSObject
@end

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@interface STSPatchView()
{
	NSMutableArray<STSPatchViewItem *> * m_pItems;
	NSMutableArray<STSPatchViewConstraint *> * m_pConstraints;
	STSPatchViewLayout * m_pLayout;

	CGFloat m_fTopMargin;
	CGFloat m_fLeftMargin;
	CGFloat m_fRightMargin;
	CGFloat m_fBottomMargin;
	
	CGFloat m_fRowSpacing;
	CGFloat m_fColumnSpacing;
	
	unsigned int m_uColumnCount;
	
	BOOL m_bReduceColumnsIfNotEnoughItems;
}
@end

@implementation STSPatchView

- (id)init
{
	self = [super init];
	if(!self)
		return nil;
	[self _initPatchView];
	return self;
}

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if(!self)
		return nil;
	[self _initPatchView];
	return self;
}

- (void)_initPatchView
{
	m_pItems = [[NSMutableArray alloc] init];
	m_pConstraints = [[NSMutableArray alloc] init];
	
	m_bReduceColumnsIfNotEnoughItems = false;
	
	m_fTopMargin = 0.0f;
	m_fLeftMargin = 0.0f;
	m_fRightMargin = 0.0f;
	m_fBottomMargin = 0.0f;
	
	m_fRowSpacing = 0.0f;
	m_fColumnSpacing = 0.0f;
	
	m_uColumnCount = 1;
	
	m_pLayout = nil;
}

- (void)dealloc
{
	[self _dropLayout];
	[m_pItems removeAllObjects];
	[m_pConstraints removeAllObjects];
	m_pItems = nil;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)setColumnCount:(unsigned int)uCount
{
	if(m_uColumnCount == uCount)
		return;
	m_uColumnCount = uCount > 0 ? uCount : 1;
	[self setNeedsLayout];
}

- (void)setReduceColumnsIfNotEnoughItems:(BOOL)bReduce;
{
	if(m_bReduceColumnsIfNotEnoughItems == bReduce)
		return;
	m_bReduceColumnsIfNotEnoughItems = bReduce;
	[self setNeedsLayout];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)setColumn:(unsigned int)uColumn fixedWidth:(CGFloat)fWidth
{
	STSPatchViewConstraint * c = [STSPatchViewConstraint new];
	c->eType = STSPatchViewConstraintColumnFixedWidth;
	c->uColumn = uColumn;
	c->fValue = fWidth;
	[m_pConstraints addObject:c];
	[self setNeedsLayout];
}

- (void)setColumn:(unsigned int)uColumn fixedWidthPercent:(CGFloat)fWidth
{
	STSPatchViewConstraint * c = [STSPatchViewConstraint new];
	c->eType = STSPatchViewConstraintColumnFixedWidthPercent;
	c->uColumn = uColumn;
	c->fValue = fWidth;
	[m_pConstraints addObject:c];
	[self setNeedsLayout];
}

- (void)removeAllConstraints
{
	[m_pConstraints removeAllObjects];
	[self setNeedsLayout];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)addView:(UIView *)pView
{
	[self addView:pView withFlags:0];
}

- (void)addView:(UIView *)pView withFlags:(unsigned int)uFlags
{
	[self addView:pView inFixedColumn:INVALID_FIXED_COLUMN withFlags:uFlags];
}

- (void)addView:(UIView *)pView inFixedColumn:(unsigned int)uColumn
{
	[self addView:pView inFixedColumn:uColumn withFlags:0];
}

- (void)addView:(UIView *)pView inFixedColumn:(unsigned int)uColumn withFlags:(unsigned int)uFlags
{
	STSPatchViewItem * v = [STSPatchViewItem new];
	
	v->pView = pView;
	v->uFixedColumn = uColumn;
	v->uFlags = uFlags;
	
	[m_pItems addObject:v];
	
	[self addSubview:pView];
	
	[self setNeedsLayout];
}

- (void)removeView:(UIView *)pView
{
	int idx = 0;
	for(STSPatchViewItem * v in m_pItems)
	{
		if(v->pView == pView)
		{
			[pView removeFromSuperview];
			[m_pItems removeObjectAtIndex:idx];
			[self setNeedsLayout];
			return;
		}
		idx++;
	}
}

- (void)removeAllViews
{
	for(STSPatchViewItem * v in m_pItems)
		[v->pView removeFromSuperview];

	[m_pItems removeAllObjects];
	
	[self setNeedsLayout];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

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

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)_dropLayout
{
	if(!m_pLayout)
		return;
	[m_pLayout->pViews removeAllObjects];
	[m_pLayout->pColumns removeAllObjects];
	m_pLayout = nil;
}

- (void)setNeedsLayout
{
	[self _dropLayout];
	[super setNeedsLayout];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


- (STSPatchViewLayout *)_computeLayoutForSize:(CGSize)sRequestedSize
{
#ifdef DEBUG_LAYOUT
	STS_CORE_LOG(@"Requested size is %f,%f",sRequestedSize.width,sRequestedSize.height);
#endif
	
	STSPatchViewLayout * pLayout = [[STSPatchViewLayout alloc] init];
	
	pLayout->pViews = [[NSMutableArray alloc] init];
	pLayout->pColumns = [[NSMutableArray alloc] init];
	
	pLayout->sRequestedSize = sRequestedSize;

	unsigned int uColumnCount = m_uColumnCount;
	if(m_bReduceColumnsIfNotEnoughItems && (m_pItems.count < uColumnCount))
		uColumnCount = (unsigned int)m_pItems.count;
	
	if(uColumnCount < 1)
		uColumnCount = 1;
	
	unsigned int uCol;
	STSPatchViewColumn * pColumn;
	
	CGFloat fFixedW = m_fLeftMargin + m_fRightMargin + ((uColumnCount - 1) * m_fColumnSpacing);
	CGFloat fAvailableW = pLayout->sRequestedSize.width - fFixedW;
	if(fAvailableW < 0.0)
		fAvailableW = 0.0;
	
	for(uCol = 0;uCol < uColumnCount;uCol++)
	{
		pColumn = [STSPatchViewColumn new];
		pColumn->pItems = [NSMutableArray new];
		pColumn->fWidth = -1.0; // unassigned
		pColumn->fMaxPreferredWidth = 0.0;
		[pLayout->pColumns addObject:pColumn];
	}
	
	for(STSPatchViewConstraint * pConstraint in m_pConstraints)
	{
		if(pConstraint->uColumn >= uColumnCount)
			continue; // out
		
		pColumn = [pLayout->pColumns objectAtIndex:pConstraint->uColumn];
		
		switch(pConstraint->eType)
		{
			case STSPatchViewConstraintColumnFixedWidth:
				pColumn->fWidth = pConstraint->fValue;
				break;
			case STSPatchViewConstraintColumnFixedWidthPercent:
				pColumn->fWidth = pConstraint->fValue * fAvailableW;
				break;
		}
	}
	
	CGFloat fUnassigned = 0.0;
	
	for(pColumn in pLayout->pColumns)
	{
		if(pColumn->fWidth < 0.0)
		{
			fUnassigned += 1.0;
			continue;
		}
		
		fFixedW += pColumn->fWidth;
		fAvailableW -= pColumn->fWidth;
	}
	
	if(fUnassigned > 0.0)
	{
		CGFloat fPerColumn = fAvailableW / fUnassigned;
		
		for(pColumn in pLayout->pColumns)
		{
			if(pColumn->fWidth < 0.0)
				pColumn->fWidth = fPerColumn;
		}
	} else if(fAvailableW > 0.1)
	{
		// no unassigned columns but available width: what here?
	}
	
	CGFloat fX = m_fLeftMargin;
	CGFloat fTotalUsedWidth = m_fLeftMargin + m_fRightMargin;
	
	int idx = 0;
	for(pColumn in pLayout->pColumns)
	{
		pColumn->fUsedHeight = m_fTopMargin; // remember that bottom margin is missing!
		pColumn->fX = fX;
		fX += pColumn->fWidth;
		fX += m_fColumnSpacing;
		
		if(idx > 0)
			fTotalUsedWidth += m_fColumnSpacing;
		else
			idx++;
		fTotalUsedWidth += pColumn->fWidth;
	}
	
	STSPatchViewItem * pItem;
	STSPatchViewView * pView;
	
	for(pItem in m_pItems)
	{
		CGFloat fY;
		CGFloat fWidth;

		if(pItem->uFlags & STSPatchViewPatchSpansAllColumns)
		{
			// Special case
			
			// find longest column
			CGFloat fMaxUsedHeight = 0.0;
			bool bGotOneItem = false;
			for(pColumn in pLayout->pColumns)
			{
				if(pColumn->fUsedHeight > fMaxUsedHeight)
					fMaxUsedHeight = pColumn->fUsedHeight;
				if(pColumn->pItems.count > 0)
					bGotOneItem = true;
			}
			
			// column 0 takes it
			pColumn = [pLayout->pColumns objectAtIndex:0];
			[pColumn->pItems addObject:pItem];

			if(bGotOneItem)
				fMaxUsedHeight += m_fRowSpacing;

			// all the columns are brought to the specified height
			for(pColumn in pLayout->pColumns)
				pColumn->fUsedHeight = fMaxUsedHeight;

			pColumn = [pLayout->pColumns objectAtIndex:0];

			fY = fMaxUsedHeight;
			fWidth = fTotalUsedWidth - m_fLeftMargin - m_fRightMargin;
		} else {
			if((pItem->uFixedColumn != INVALID_FIXED_COLUMN) && (pItem->uFixedColumn <= uColumnCount))
			{
				// column pre-assigned
				pColumn = [pLayout->pColumns objectAtIndex:pItem->uFixedColumn];
			} else {
				// assign the best column
				CGFloat fMinUsedHeight = 99999.9;
				STSPatchViewColumn * pBestColumn = nil;
				for(pColumn in pLayout->pColumns)
				{
					if(!pBestColumn)
					{
						pBestColumn = pColumn;
						fMinUsedHeight = pColumn->fUsedHeight;
						continue;
					}
					
					if(pColumn->fUsedHeight < fMinUsedHeight)
					{
						pBestColumn = pColumn;
						fMinUsedHeight = pColumn->fUsedHeight;
					}
				}

				pColumn = pBestColumn;
			}

			if(pColumn->pItems.count > 0) // not first
			{
				//fY += m_fRowSpacing;
				pColumn->fUsedHeight += m_fRowSpacing;
			}

			[pColumn->pItems addObject:pItem];

			fY = pColumn->fUsedHeight;
			fWidth = pColumn->fWidth;
		}
			
		pView = [STSPatchViewView new];
		pView->pView = pItem->pView;

		if(pItem->sContentsSize.width > pColumn->fMaxPreferredWidth)
			pColumn->fMaxPreferredWidth = pItem->sContentsSize.width;
		
		pItem->sContentsSize = [pItem->pView sizeThatFits:CGSizeMake(fWidth,99999.9f)];
		if(pItem->sContentsSize.height > 99000.0f)
		{
			// bogus height...
			pItem->sContentsSize = [pItem->pView intrinsicContentSize];
		}
		
		pView->rRect = CGRectMake(pColumn->fX,fY,fWidth,pItem->sContentsSize.height);
		
		if(pItem->uFlags & STSPatchViewPatchSpansAllColumns)
		{
			for(pColumn in pLayout->pColumns)
				pColumn->fUsedHeight += pItem->sContentsSize.height;
		} else {
			pColumn->fUsedHeight += pItem->sContentsSize.height;
		}

#ifdef DEBUG_LAYOUT
		STS_CORE_LOG(@"View rect (%f,%f,%f,%f)",pView->rRect.origin.x,pView->rRect.origin.y,pView->rRect.size.width,pView->rRect.size.height);
#endif

		[pLayout->pViews addObject:pView];
	}
	
	CGFloat fMaxUsedHeight = 0.0;
	CGFloat fTotalPreferredWidth = m_fLeftMargin + m_fRightMargin;
	
	for(pColumn in pLayout->pColumns)
	{
		pColumn->fUsedHeight += m_fBottomMargin;
		if(pColumn->fUsedHeight > fMaxUsedHeight)
			fMaxUsedHeight = pColumn->fUsedHeight;
		fTotalPreferredWidth += pColumn->fMaxPreferredWidth;
	}
	
	// Currently actual, minimum and preferred are all the same here.
	// Later we could change the actual to use different heights
	// And compute a real minimum...
	
	pLayout->sActualSize = CGSizeMake(fTotalUsedWidth,fMaxUsedHeight);
	pLayout->sPreferredSize = CGSizeMake(fTotalPreferredWidth + (pLayout->pColumns.count - 1) * m_fColumnSpacing,fMaxUsedHeight);
	pLayout->sMinimumSize = CGSizeMake(MIN(pLayout->sPreferredSize.width,fTotalUsedWidth),fMaxUsedHeight);

#ifdef DEBUG_LAYOUT
	STS_CORE_LOG(@"Minimum size is %f,%f",pLayout->sMinimumSize.width,pLayout->sMinimumSize.height);
	STS_CORE_LOG(@"Preferred size is %f,%f",pLayout->sPreferredSize.width,pLayout->sPreferredSize.height);
	STS_CORE_LOG(@"Actual size is %f,%f",pLayout->sActualSize.width,pLayout->sActualSize.height);
#endif

	return pLayout;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)_applyLayout
{
	if(!m_pLayout)
		m_pLayout = [self _computeLayoutForSize:self.frame.size];
	
	for(STSPatchViewView * pView in m_pLayout->pViews)
		pView->pView.frame = pView->rRect;
}

- (void)layoutSubviews
{
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
}

- (CGSize)intrinsicContentSize
{
	if(!m_pLayout)
		m_pLayout = [self _computeLayoutForSize:self.frame.size];
	
	return m_pLayout->sPreferredSize;
}

- (CGSize)sizeThatFits:(CGSize)size
{
	STSPatchViewLayout * pLayout = nil;
	
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
