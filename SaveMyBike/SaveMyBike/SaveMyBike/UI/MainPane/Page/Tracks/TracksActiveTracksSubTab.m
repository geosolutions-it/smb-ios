//
//  TracksActiveTracksSubTab.m
//  SaveMyBike
//
//  Created by Szymon Tomasz Stefanek on 08/07/2019.
//  Copyright © 2019 GeoSolutions SaS. All rights reserved.
//

#import "TracksActiveTracksSubTab.h"

#import "LargeIconAndTwoTextsView.h"
#import "STSI18N.h"
#import "BackendRequestGetMyTracks.h"
#import "STSI18N.h"
#import "Track.h"
#import "STSViewStack.h"
#import "MainView.h"
#import "NSDate+Format.h"
#import "STSSimpleTableView.h"
#import "TrackTableCell.h"
#import "STSMessageBox.h"
#import "AppDelegate.h"

@interface TracksActiveTracksSubTab()<STSViewStackView,NotificationDelegate>

@end

@implementation TracksActiveTracksSubTab

- (id)init
{
	self = [super init];
	if(!self)
		return nil;

	[self.tableView registerClass:[TrackTableCell class] forCellReuseIdentifier:@"tableCell"];

	return self;
}

- (BackendPagedRequest *)onCreateRequest
{
	return [BackendRequestGetMyTracks new];
}

- (STSSimpleTableViewCell *)onCreateTableViewCell
{
	TrackTableCell * c = [self.tableView dequeueReusableCellWithIdentifier:@"tableCell"];
	if(!c)
		c = [TrackTableCell new];
	return c;
}

- (void)onSetupTableItemCell:(STSSimpleTableViewCell *)cell withItem:(NSObject *)ob
{
	TrackTableCell * pCell = (TrackTableCell *)cell;
	
	Track * cmp = (Track *)ob;
	
	[pCell setupForTrack:cmp];
}

- (NSMutableArray< NSObject * > *)onGetItemsFromRequest:(BackendPagedRequest *)pRequest
{
	BackendRequestGetMyTracks * rq = (BackendRequestGetMyTracks *)pRequest;
	return (NSMutableArray< NSObject * > *)rq.tracks;
}

- (LargeIconAndTwoTextsView *)onCreateNothingHereYetView
{
	return [[LargeIconAndTwoTextsView alloc]
			initWithIcon:@"large_gray_icon_track"
			shortText:__trCtx(@"No Tracks Available",@"TracksActiveTracksSubTab")
			longText:__trCtx(@"You don't have any track recorded. To create a track, record it using the \"Record\" tab first. At the end of the recording session open the \"To Send\" tab in the \"Stats\" section and upload your data. You will see your data here after the processing ends.",@"TracksActiveTracksSubTab")
		];
}

- (void)onItemSelected:(NSObject *)pItem
{
	Track * trk = (Track *)pItem;
	if(!trk.isValid)
	{
		[STSMessageBox showWithMessage:__trCtx(@"This track has been identified as invalid. It will not be used in indexes count and assigning prizes", @"TracksActiveTracksSubTab") title:__trCtx(@"Invalid Track", @"TracksActiveTracksSubTab")];
		return;
	}
	[[MainView instance] pushTrackPage:trk];
}

- (void)onActivate
{
	[self startItemListFetchRequest];
	[[AppDelegate instance] addNotificationDelegate:self];
}

- (void)onDeactivate
{
	[[AppDelegate instance] removeNotificationDelegate:self];
	[self stopItemListFetchRequest];
}

- (void)onNotificationReceived:(NSString *)sMessage
{
	if([sMessage isEqualToString:@"track_validated"])
		[self refresh];
}


@end
