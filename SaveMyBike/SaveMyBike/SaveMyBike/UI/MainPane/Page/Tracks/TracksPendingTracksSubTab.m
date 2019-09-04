//
//  TracksPendingTracksSubTab.m
//  SaveMyBike
//
//  Created by Szymon Tomasz Stefanek on 08/07/2019.
//  Copyright © 2019 GeoSolutions SaS. All rights reserved.
//

#import "TracksPendingTracksSubTab.h"

#import "LargeIconAndTwoTextsView.h"
#import "STSI18N.h"
#import "STSSimpleTableViewCellWithImageAndTwoLabels.h"
#import "TrackingSession.h"
#import "Database.h"
#import "STSSQLSelectQueryBuilder.h"
#import "NSDate+Format.h"
#import "Config.h"

@interface TracksPendingTracksSubTab()
{
}

@end

@implementation TracksPendingTracksSubTab

- (id)init
{
	self = [super init];
	if(!self)
		return nil;
	
	[self reload];
	
	return self;
}

- (void)reload
{
	STSSQLSelectQueryBuilder * qb = [[Database instance].connection createSelectQueryBuilder];
	
	[qb setTableName:[TrackingSession SQLTableName]];
	[qb.where
		addConditionWithField:[TrackingSession SQLFieldStateName]
			operator:STSSQLOperator_IsEqualTo
			rightObject:[TrackingSessionStateEnumHelpers idFromEnum:TrackingSessionState_Complete]
			rightType:STSSQLOperandType_VarCharConstant
		];
	[qb addOrderBy:[TrackingSession SQLFieldEndDateTimeName] withDirection:STSSQLSelectQueryBuilderOrderByDirection_Descending];
	
	NSMutableArray<TrackingSession *> * pSessions = [TrackingSession dbFetchListBySQL:[qb build] fromDatabase:[Database instance].connection];

	if(!pSessions)
	{
		[self showErrorWithTitle:__trCtx(@"Failed to Fetch Sessions", @"TracksPendingTracksSubTab") andMessage:[Database instance].connection.errorStack.buildMessage];
		return;
	}

	self.items = (NSMutableArray<NSObject *> *)pSessions;

	[self switchToTableView];
}

- (void)onSetupTableItemCell:(STSSimpleTableViewCell *)cell withItem:(NSObject *)ob
{
	STSSimpleTableViewCellWithImageAndTwoLabels * pCell = (STSSimpleTableViewCellWithImageAndTwoLabels *)cell;
	
	TrackingSession * s = (TrackingSession *)ob;

	pCell.iconView.image = [UIImage imageNamed:@"track_stats"];

	pCell.upperLabel.text = [s.endDateTime stringWithFormat:DateTimeFormatVisibleDateTime2];
	pCell.lowerLabel.text = @"?";
}

- (void)onItemSelected:(NSObject *)ob
{
}

- (LargeIconAndTwoTextsView *)onCreateNothingHereYetView
{
	return [
		[LargeIconAndTwoTextsView alloc]
			initWithIcon:@"large_gray_icon_checked"
				shortText:__trCtx(@"No Tracks to Upload",@"TracksPendingTracksSubTab")
				longText:__trCtx(@"There are no tracks to upload. If you want to create a new track please use the \"Record\" tab.",@"TracksPendingTracksSubTab")
		];

}


@end

