//
//  AvailableCompetitionsTab.m
//  SaveMyBike
//
//  Created by Szymon Tomasz Stefanek on 08/08/2019.
//  Copyright © 2019 GeoSolutions SaS. All rights reserved.
//

#import "AvailableCompetitionsTab.h"

#import "BackendRequestGetMyCompetitionsAvailable.h"
#import "Competition.h"
#import "STSI18n.h"
#import "CompetitionPage.h"
#import "MainView.h"
#import "STSDisplay.h"
#import "AppDelegate.h"

@interface AvailableCompetitionsTab()<NotificationDelegate>
{
}

@end

@implementation AvailableCompetitionsTab

- (void)onSetupTableItemCell:(STSSimpleTableViewCell *)cell withItem:(NSObject *)ob
{
	STSSimpleTableViewCellWithImageAndTwoLabels * pCell = (STSSimpleTableViewCellWithImageAndTwoLabels *)cell;
	
	Competition * cmp = (Competition *)ob;
	
	pCell.upperLabel.text = cmp.name;
	pCell.lowerLabel.text = cmp.description;
	pCell.iconView.image = [UIImage imageNamed:@"competition"];

}

- (STSSimpleTableViewCell *)onCreateTableViewCell
{
	STSSimpleTableViewCellWithImageAndTwoLabels * pCell = (STSSimpleTableViewCellWithImageAndTwoLabels *)[super onCreateTableViewCell];
	
	STSDisplay * dpy = [STSDisplay instance];
	
	CGFloat m = [dpy millimetersToScreenUnits:1.0];
	CGFloat m2 = [dpy minorScreenDimensionFractionToScreenUnits:0.05];
	
	pCell.topOuterMargin = m2;
	pCell.leftOuterMargin = m2;
	pCell.rightOuterMargin = m2;
	pCell.bottomOuterMargin = m;
	
	pCell.grid.backgroundColor = [UIColor whiteColor];
	pCell.grid.layer.cornerRadius = [dpy centimetersToScreenUnits:0.1];
	pCell.grid.layer.shadowColor = [[UIColor blackColor] CGColor];
	pCell.grid.layer.shadowOpacity = 0.5;
	pCell.grid.layer.shadowRadius = [dpy centimetersToScreenUnits:0.1];
	pCell.grid.layer.shadowOffset = CGSizeMake(0.0, [dpy centimetersToScreenUnits:0.1]);
	pCell.grid.clipsToBounds = true;
	pCell.grid.layer.masksToBounds = false;
	return pCell;
}

- (BackendPagedRequest *)onCreateRequest
{
	return [BackendRequestGetMyCompetitionsAvailable new];
}

- (NSMutableArray< NSObject * > *)onGetItemsFromRequest:(BackendPagedRequest *)pRequest
{
	BackendRequestGetMyCompetitionsAvailable * rq = (BackendRequestGetMyCompetitionsAvailable *)pRequest;
	return (NSMutableArray< NSObject * > *)rq.competitions;
}

- (LargeIconAndTwoTextsView *)onCreateNothingHereYetView
{
	return [[LargeIconAndTwoTextsView alloc]
			initWithIcon:@"large_gray_icon_trophy"
			shortText:__trCtx(@"No competitions available",@"ActivePrizesTab")
			longText:__trCtx(@"There are no active competitions in your area at the moment. Please check this page in the nexts days",@"AvailableCompetitionsTab")
		];
}


- (void)onItemSelected:(NSObject *)pItem
{
	[[MainView instance] pushCompetitionPage:(Competition *)pItem withParticipation:nil];
}

- (void)onActivate
{
	[self refresh];
	[[AppDelegate instance] addNotificationDelegate:self];
}

- (void)onDeactivate
{
	[[AppDelegate instance] removeNotificationDelegate:self];
	[self stopItemListFetchRequest];
}

- (void)onNotificationReceived:(NSString *)sMessage
{
	if([sMessage isEqualToString:@"prize_won"])
		[self refresh];
}

@end
