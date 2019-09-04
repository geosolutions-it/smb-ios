//
//  ItemList.m
//  SaveMyBike
//
//  Created by Szymon Tomasz Stefanek on 19/07/2019.
//  Copyright © 2019 GeoSolutions SaS. All rights reserved.
//

#import "ItemList.h"


#import "LargeIconAndTwoTextsView.h"
#import "STSI18N.h"
#import "STSSimpleTableView.h"
#import "STSSimpleTableViewCellWithImageAndTwoLabels.h"
#import "BackendPagedRequest.h"
#import "LargeIconAndTwoTextsView.h"
#import "JSONConvertible.h"
#import "STSDisplay.h"
#import "M13ProgressViewRing.h"
#import "Config.h"

@interface ItemList()<STSSimpleTableViewDataProvider>
{
	NSMutableArray<NSObject *> * m_pItems;
	STSSimpleTableView * m_pTableView;
	LargeIconAndTwoTextsView * m_pNothingHereYetView;
	LargeIconAndTwoTextsView * m_pErrorView;
	STSSimpleTableViewCellWithImageAndTwoLabels * m_pSampleCell;
	STSGridLayoutView * m_pWaitView;
	M13ProgressViewRing * m_pProgressView;
	float m_fImageSize;
	float m_fCellHeight;
	NSMutableArray<UIView *> * m_pAttachedViews;
}

@end

@implementation ItemList

- (id)init
{
	self = [super init];
	if(!self)
		return nil;
	
	_items = nil;

	m_pNothingHereYetView = nil;
	m_pErrorView = nil;
	m_pSampleCell = nil;
	m_fCellHeight = 0.0;
	m_pWaitView = nil;
	m_pAttachedViews = [NSMutableArray new];
	
	STSDisplay * dpy = [STSDisplay instance];
	
	m_fImageSize = [dpy minorScreenDimensionFractionToScreenUnits:0.2];
	float fMin = [dpy centimetersToScreenUnits:1.2];
	if(m_fImageSize < fMin)
		m_fImageSize = fMin;
	
	m_pTableView = [STSSimpleTableView new];
	[m_pTableView registerClass:[STSSimpleTableViewCellWithImageAndTwoLabels class] forCellReuseIdentifier:@"default"];
	[m_pTableView setDataProvider:self];

	[self addCentralView:m_pTableView];
	
	return self;
}

- (STSSimpleTableView *)tableView
{
	return m_pTableView;
}

- (STSSimpleTableViewCell *)onCreateTableViewCell
{
	STSSimpleTableViewCellWithImageAndTwoLabels * c = [m_pTableView dequeueReusableCellWithIdentifier:@"default"];
	if(!c)
		c = [STSSimpleTableViewCellWithImageAndTwoLabels new];

	[c.grid setColumn:0 fixedWidth:m_fImageSize];
	c.lowerLabel.adjustsFontSizeToFitWidth = NO;
	c.lowerLabel.lineBreakMode = NSLineBreakByTruncatingTail;
	c.lowerLabel.numberOfLines = 2;

	return c;
}

- (void)setItems:(NSMutableArray<NSObject *> *)pItems
{
	_items = pItems;
	[m_pTableView reloadData];
}

- (void)addCentralView:(UIView *)pView
{
	[m_pAttachedViews addObject:pView];
	[self addView:pView row:0 column:0];
}

- (void)switchToCentralView:(UIView *)pView
{
	for(UIView * v in m_pAttachedViews)
		v.hidden = (v != pView);
	[self bringSubviewToFront:pView];
	[self setNeedsLayout];
}

- (void)_createWaitView
{
	m_pWaitView = [STSGridLayoutView new];
	m_pWaitView.backgroundColor = [Config instance].generalBackgroundColor;
	
	m_pProgressView = [M13ProgressViewRing new];
	m_pProgressView.primaryColor = [UIColor lightGrayColor];
	m_pProgressView.secondaryColor = [UIColor lightGrayColor];
	m_pProgressView.indeterminate = true;
	m_pProgressView.showPercentage = false;
	
	[m_pWaitView addView:m_pProgressView row:1 column:1];

	//STSLabel * l = [STSLabel new];
	//l.textColor = [UIColor lightGrayColor];
	//l.textAlignment = NSTextAlignmentCenter;
	//l.text = __trCtx(@".... loading ...", @"ItemList");
	
	//[m_pWaitView addView:l row:2 column:1];
	
	STSDisplay * dpy = [STSDisplay instance];

	[m_pWaitView setRow:0 expandWeight:1000];
	[m_pWaitView setRow:1 minimumHeight:[dpy centimetersToScreenUnits:2.0]];
	[m_pWaitView setRow:2 expandWeight:1000];
	[m_pWaitView setColumn:0 expandWeight:1000];
	[m_pWaitView setColumn:1 minimumWidth:[dpy centimetersToScreenUnits:2.0]];
	[m_pWaitView setColumn:2 expandWeight:1000];
	[m_pWaitView setSpacing:[dpy centimetersToScreenUnits:0.5]];
	
	[self addCentralView:m_pWaitView];
}

- (void)switchToWaitView
{
	if(!m_pWaitView)
		[self _createWaitView];
	
	[self switchToCentralView:m_pWaitView];
}

- (int)simpleTableViewGetRowCount:(STSSimpleTableView *)stv
{
	if(!_items)
		return 0;
	return (int)[_items count];
}

- (void)onSetupTableItemCell:(STSSimpleTableViewCell *)cell withItem:(NSObject *)ob
{
	STS_CORE_LOG_ERROR(@"Internal error: ItemList.onSetupTableItemCell not overridden");
}

- (UITableViewCell *)simpleTableView:(STSSimpleTableView *)stv createCellForRow:(int)iRow
{
	if((!_items) || (iRow < 0) || (iRow >= _items.count))
		return nil;

	NSObject * cmp = [_items objectAtIndex:iRow];

	STSSimpleTableViewCell * c = [self onCreateTableViewCell];

	[self onSetupTableItemCell:c withItem:cmp];

	return c;
}

- (void)simpleTableViewSelectionChanged:(STSSimpleTableView *)stv
{
	if(!_items)
		return;
	
	int iRow = stv.selectedRow;
	if((iRow < 0) || (iRow >= _items.count))
		return;

	[self onItemSelected:[_items objectAtIndex:iRow]];
}

- (void)onItemSelected:(NSObject *)ob
{
	STS_CORE_LOG_ERROR(@"Internal error: ItemList.onItemSelected not overridden");
}

- (CGFloat)onComputeTableViewCellHeight
{
	if(!m_pSampleCell)
	{
		m_pSampleCell = [STSSimpleTableViewCellWithImageAndTwoLabels new];
		m_pSampleCell.upperLabel.text = @"AAA BBB CCC";
		m_pSampleCell.lowerLabel.text = @"aaaaaaa aaaaa uewqoi ueiqeequoqeu qeuoeqweiqwepoi i wqpeiepqow ieoqeqwyiepoqw iq eqewq ewoqieu iq eow eowq uewq eq ueqweqwu eoqw ieowu ewqe";
		m_pSampleCell.imageView.image = [UIImage imageNamed:@"large_gray_icon_trophy"];
	
		[m_pSampleCell.grid setColumn:0 fixedWidth:m_fImageSize];
		m_pSampleCell.lowerLabel.adjustsFontSizeToFitWidth = NO;
		m_pSampleCell.lowerLabel.lineBreakMode = NSLineBreakByTruncatingTail;
		m_pSampleCell.lowerLabel.numberOfLines = 2;
	}
	
	float fCellHeight = [m_pSampleCell.grid intrinsicContentSize].height;
	
	STSDisplay * dpy = [STSDisplay instance];
	
	float fMinHeight = m_fImageSize + [dpy millimetersToScreenUnits:2.0];
	
	if(fCellHeight < fMinHeight)
		fCellHeight = fMinHeight;
	
	return fCellHeight;
}

- (CGFloat)simpleTableViewGetCellHeight:(STSSimpleTableView *)stv
{
	if(m_fCellHeight <= 0.0)
		m_fCellHeight = [self onComputeTableViewCellHeight];
	return m_fCellHeight;
}

- (void)showErrorWithTitle:(NSString *)sTitle andMessage:(NSString *)sMessage
{
	if(!m_pErrorView)
	{
		m_pErrorView = [[LargeIconAndTwoTextsView alloc] initWithIcon:@"large_gray_icon_warning" shortText:sTitle longText:sMessage];
		[self addCentralView:m_pErrorView];
	} else {
		[m_pErrorView setIcon:@"warning" shortText:sTitle longText:sMessage];
	}
	
	[self switchToCentralView:m_pErrorView];
}

- (void)switchToTableView
{
	[self switchToCentralView:m_pTableView];
}

- (void)switchToNothingHereYetView
{
	if(!m_pNothingHereYetView)
	{
		m_pNothingHereYetView = [self onCreateNothingHereYetView];
		if(m_pNothingHereYetView)
			[self addCentralView:m_pNothingHereYetView];
	}
	if(m_pNothingHereYetView)
	[self switchToCentralView:m_pNothingHereYetView];
}

- (LargeIconAndTwoTextsView *)onCreateNothingHereYetView
{
	STS_CORE_LOG_ERROR(@"Internal error: ItemList.createNothingHereYetView not overridden");
	return nil;
}


@end
