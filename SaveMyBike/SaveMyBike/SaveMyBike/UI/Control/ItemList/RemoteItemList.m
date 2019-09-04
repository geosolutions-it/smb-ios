//
//  RemoteItemList.m
//  SaveMyBike
//
//  Created by Szymon Tomasz Stefanek on 06/08/2019.
//  Copyright © 2019 GeoSolutions SaS. All rights reserved.
//

#import "RemoteItemList.h"

#import "STSI18N.h"
#import "BackendPagedRequest.h"
#import "Config.h"

@interface RemoteItemList()<BackendRequestDelegate>
{
	bool m_bReceivedResponse;
	BackendPagedRequest * m_pRequest;
}

@end

@implementation RemoteItemList

- (id)init
{
	self = [super init];
	if(!self)
		return nil;
	
	m_bReceivedResponse = false;
	m_pRequest = nil;

	return self;
}

- (bool)refresh
{
	m_bReceivedResponse = false;
	return [self startItemListFetchRequest];
}

- (bool)startItemListFetchRequest
{
	if(m_pRequest || m_bReceivedResponse)
		return false;

	m_pRequest = [self onCreateRequest];
	if(!m_pRequest)
		return false;

	[m_pRequest setBackendRequestDelegate:self];
	[m_pRequest start];
	
	//if((!self.items) || (self.items.count < 1))
	[self switchToWaitView];
	
	return true;
}

- (void)stopItemListFetchRequest
{
	if(m_pRequest)
	{
		[m_pRequest cancel];
		m_pRequest = nil;
	}
}

- (BackendPagedRequest *)onCreateRequest
{
	STS_CORE_LOG_ERROR(@"Internal error: RemoteItemList.onCreateRequets not overridden");
	return nil;
}

- (NSMutableArray< NSObject * > *)onGetItemsFromRequest:(BackendPagedRequest *)pRequest
{
	STS_CORE_LOG_ERROR(@"Internal error: RemoteItemList.onGetItemsFromRequest not overridden");
	return nil;
}

- (void)backendRequestCompleted:(BackendRequest *)pRequest
{
	if(!m_pRequest)
		return; // aborted
	if(!m_pRequest.succeeded)
	{
		[self showErrorWithTitle:__trCtx(@"Loading Failed", @"RemoteItemList") andMessage:pRequest.error];
		self.items = nil;
		m_pRequest = nil;
		return;
	}
	self.items = [self onGetItemsFromRequest:m_pRequest];
	m_pRequest = nil;
	if(self.items.count < 1)
		[self switchToNothingHereYetView];
	else
		[self switchToTableView];
	m_bReceivedResponse = true;
}

@end
