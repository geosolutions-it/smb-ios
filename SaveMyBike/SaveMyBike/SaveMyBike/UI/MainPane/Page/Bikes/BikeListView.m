//
//  BikeListView.m
//  SaveMyBike
//
//  Created by Szymon Tomasz Stefanek on 07/08/2019.
//  Copyright © 2019 GeoSolutions SaS. All rights reserved.
//

#import "BikeListView.h"

#import "LargeIconAndTwoTextsView.h"
#import "BackendRequestGetMyBikes.h"
#import "STSI18N.h"
#import "BikeTableCell.h"
#import "STSViewStack.h"
#import "STSDisplay.h"
#import "STSSimpleTableView.h"
#import "MainView.h"
#import "Bike.h"

@interface BikeListView()<STSViewStackView>
{
	BikeTableCell * m_pSampleCell;
}
@end

@implementation BikeListView

- (id)init
{
	self = [super init];
	if(!self)
		return nil;
	
	[self.tableView registerClass:[BikeTableCell class] forCellReuseIdentifier:@"tableCell"];
	
	return self;
}

- (CGFloat)onComputeTableViewCellHeight
{
	if(!m_pSampleCell)
		m_pSampleCell = [BikeTableCell new];
	
	float fCellHeight = [m_pSampleCell.grid intrinsicContentSize].height;
	
	STSDisplay * dpy = [STSDisplay instance];
	
	float fMinHeight = [dpy millimetersToScreenUnits:3.0];
	
	if(fCellHeight < fMinHeight)
		fCellHeight = fMinHeight;
	
	return fCellHeight;
}

- (BackendPagedRequest *)onCreateRequest
{
	return [BackendRequestGetMyBikes new];
}

- (STSSimpleTableViewCell *)onCreateTableViewCell
{
	BikeTableCell * c = [self.tableView dequeueReusableCellWithIdentifier:@"tableCell"];
	if(!c)
		c = [BikeTableCell new];
	return c;
}

- (void)onSetupTableItemCell:(STSSimpleTableViewCell *)cell withItem:(NSObject *)ob
{
	BikeTableCell * pCell = (BikeTableCell *)cell;

	[pCell setBike:(Bike *)ob];
}

- (NSMutableArray<NSObject *> *)onGetItemsFromRequest:(BackendPagedRequest *)pRequest
{
	BackendRequestGetMyBikes * rq = (BackendRequestGetMyBikes *)pRequest;
	return (NSMutableArray< NSObject * > *)rq.bikes;
}

- (LargeIconAndTwoTextsView *)onCreateNothingHereYetView
{
	return [[LargeIconAndTwoTextsView alloc]
			initWithIcon:@"large_gray_icon_bike"
			shortText:__trCtx(@"No bikes registered",@"BikeListView")
			longText:__trCtx(@"You did not register any bike yet. Please go to your personal area of the web portal to register a bike.",@"BikeListView")
		];
}

- (void)onItemSelected:(NSObject *)pItem
{
	if(!pItem)
		return; // ?
	[[MainView instance] pushBikePage:(Bike *)pItem];
}

- (void)onActivate
{
	[self startItemListFetchRequest];
}

- (void)onDeactivate
{
	[self stopItemListFetchRequest];
}


@end
