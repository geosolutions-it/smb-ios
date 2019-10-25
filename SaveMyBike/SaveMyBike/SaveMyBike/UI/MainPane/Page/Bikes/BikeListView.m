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
#import "BikeStatus.h"
#import "STSMessageBox.h"
#import "Config.h"
#import "BackendRequestSetBikeStatus.h"
#import "STSProgressDialog.h"

@interface BikeListView()<STSViewStackView,BackendRequestDelegate>
{
	BikeTableCell * m_pSampleCell;
	BackendRequestSetBikeStatus * m_pSetBikeStatusRequest;
	STSProgressDialog * m_pProgressDialog;
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

	[pCell setBike:(Bike *)ob andListView:self];
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

- (void)onBikeTableCellStatusButtonPressed:(Bike *)bk
{
	if(m_pSetBikeStatusRequest)
		return;
	
	STSMessageBoxParams * mb = [STSMessageBoxParams new];
	
	BikeListView * lv = self;
	
	if(bk.currentStatus && bk.currentStatus.lost)
	{
		mb.title = __trCtx(@"Mark Bike as Found", @"BikeListView");
		mb.message = __trCtx(@"Do you confirm that you have found this bike?", @"BikeListView");
		mb.button0Text = __tr(@"NO");
		mb.button1Text = __tr(@"YES");
		mb.callback = ^(STSMessageBoxParams *pParams, int iButtonIdx) {
			if(iButtonIdx != 1)
				return;

			[lv markBikeAsFound:bk];
		};
		
		[STSMessageBox show:mb];
		return;
	}
	
	[[MainView instance] pushBikeLostPage:bk];
}

- (void)showProgressDialog
{
	if(m_pProgressDialog)
		return;
	m_pProgressDialog = [STSProgressDialog new];
	[m_pProgressDialog showAsIndeterminate:true];
}

- (void)hideProgressDialog
{
	if(!m_pProgressDialog)
		return;
	[m_pProgressDialog close:true];
	m_pProgressDialog = nil;
}

- (void)markBikeAsFound:(Bike *)bk
{
	if(m_pSetBikeStatusRequest)
		return;
	
	m_pSetBikeStatusRequest = [BackendRequestSetBikeStatus new];
	m_pSetBikeStatusRequest.lost = false;
	m_pSetBikeStatusRequest.details = @"";
	m_pSetBikeStatusRequest.url = @"";
	m_pSetBikeStatusRequest.bikeUUID = bk.shortUUID;
	[m_pSetBikeStatusRequest setBackendRequestDelegate:self];
	
	if(![m_pSetBikeStatusRequest start])
	{
		[STSMessageBox showWithMessage:__tr(@"Failed to start request")];
		return;
	}
	
	[self showProgressDialog];
}

- (void)backendRequestCompleted:(BackendRequest *)pRequest
{
	if(pRequest == m_pSetBikeStatusRequest)
	{
		[self hideProgressDialog];
		if(!m_pSetBikeStatusRequest.succeeded)
			[STSMessageBox showWithMessage:m_pSetBikeStatusRequest.error];
		m_pSetBikeStatusRequest = nil;
		[self refresh];
		return;
	}
	
	[super backendRequestCompleted:pRequest];
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
