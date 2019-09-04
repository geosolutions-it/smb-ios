//
//  BikeObservationsList.m
//  SaveMyBike
//
//  Created by Szymon Tomasz Stefanek on 28/08/2019.
//  Copyright © 2019 GeoSolutions SaS. All rights reserved.
//

#import "BikeObservationsList.h"

#import "BikeObservationsTab.h"
#import "BikeObservationCell.h"

#import "Bike.h"

#import "BackendRequestGetMyBikeObservations.h"

#import "STSI18n.h"

#import "STSSimpleTableView.h"

@interface BikeObservationsList()
{
	Bike * m_pBike;
	BikeObservationsTab * m_pTab;
}

@end

@implementation BikeObservationsList

- (id)initWithBike:(Bike *)bk andObservationTab:(BikeObservationsTab *)pTab
{
	self = [super init];
	if(!self)
		return nil;
	
	m_pTab = pTab;
	m_pBike = bk;
	
	[self.tableView registerClass:[BikeObservationCell class] forCellReuseIdentifier:@"tableCell"];
	
	[self startItemListFetchRequest];

	return self;
}

- (BackendPagedRequest *)onCreateRequest
{
	BackendRequestGetMyBikeObservations * r = [BackendRequestGetMyBikeObservations new];
	r.bike = m_pBike.shortUUID;
	return r;
}

- (STSSimpleTableViewCell *)onCreateTableViewCell
{
	BikeObservationCell * c = [self.tableView dequeueReusableCellWithIdentifier:@"tableCell"];
	if(!c)
		c = [BikeObservationCell new];
	return c;
}

- (void)onSetupTableItemCell:(STSSimpleTableViewCell *)cell withItem:(NSObject *)ob
{
	BikeObservationCell * pCell = (BikeObservationCell *)cell;
	
	BikeObservation * o = (BikeObservation *)ob;
	
	[pCell setupForBikeObservation:o];
}

- (void)backendRequestCompleted:(BackendRequest *)pRequest
{
	if(pRequest.succeeded)
	{
		BackendRequestGetMyBikeObservations * rq = (BackendRequestGetMyBikeObservations *)pRequest;
		[m_pTab setObservationCount:rq ? (rq.bikeObservations ? rq.bikeObservations.count : 0) : 0];
	} else {
		[m_pTab setObservationCount:0];
	}
	
	[super backendRequestCompleted:pRequest];
}

- (NSMutableArray< NSObject * > *)onGetItemsFromRequest:(BackendPagedRequest *)pRequest
{
	BackendRequestGetMyBikeObservations * rq = (BackendRequestGetMyBikeObservations *)pRequest;
	return (NSMutableArray< NSObject * > *)rq.bikeObservations;
}

- (LargeIconAndTwoTextsView *)onCreateNothingHereYetView
{
	return [[LargeIconAndTwoTextsView alloc]
			initWithIcon:@"large_gray_icon_bike"
			shortText:__trCtx(@"No Observations",@"BikeObservationsList")
			longText:__trCtx(@"There are no registered observations of this bike",@"BikeObservationsList")
		];
}

- (void)onItemSelected:(NSObject *)pItem
{
	BikeObservation * o = (BikeObservation *)pItem;
	[m_pTab setCurrentObservation:o];
}


@end
