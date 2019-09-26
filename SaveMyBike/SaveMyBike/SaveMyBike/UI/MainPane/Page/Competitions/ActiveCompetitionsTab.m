//
//  ActiveCompetitionsCurrent.m
//  SaveMyBike
//
//  Created by Szymon Tomasz Stefanek on 08/08/2019.
//  Copyright © 2019 GeoSolutions SaS. All rights reserved.
//

#import "ActiveCompetitionsTab.h"

#import "BackendRequestGetMyCompetitionsCurrent.h"
#import "CompetitionParticipation.h"
#import "STSI18n.h"
#import "CompetitionPage.h"
#import "MainView.h"
#import "STSDisplay.h"
#import "AppDelegate.h"

@interface ActiveCompetitionsTab()<NotificationDelegate>
{
}

@end

@implementation ActiveCompetitionsTab

- (BackendPagedRequest *)onCreateRequest
{
	return [BackendRequestGetMyCompetitionsCurrent new];
}

- (void)onSetupTableItemCell:(STSSimpleTableViewCell *)cell withItem:(NSObject *)ob
{
	STSSimpleTableViewCellWithImageAndTwoLabels * pCell = (STSSimpleTableViewCellWithImageAndTwoLabels *)cell;
	
	CompetitionParticipation * cmp = (CompetitionParticipation *)ob;
	
	pCell.upperLabel.text = cmp.competition.name;
	pCell.lowerLabel.text = cmp.competition.description;
	if([cmp.registrationStatus isEqualToString:@"approved"])
		pCell.iconView.image = [UIImage imageNamed:@"competition_participating"];
	else
		pCell.iconView.image = [UIImage imageNamed:@"competition_waiting"];
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

- (NSMutableArray< NSObject * > *)onGetItemsFromRequest:(BackendPagedRequest *)pRequest
{
	BackendRequestGetMyCompetitionsCurrent * rq = (BackendRequestGetMyCompetitionsCurrent *)pRequest;
	return (NSMutableArray< NSObject * > *)rq.competitions;
}

- (LargeIconAndTwoTextsView *)onCreateNothingHereYetView
{
	return [[LargeIconAndTwoTextsView alloc]
			initWithIcon:@"large_gray_icon_trophy"
			shortText:__trCtx(@"No competitions",@"ActivePrizesTab")
			longText:__trCtx(@"You aren't participating in any competition at the moment.",@"ActiveCompetitionsPage")
		];
}

- (void)onItemSelected:(NSObject *)pItem
{
	CompetitionParticipation * p = (CompetitionParticipation *)pItem;
	if(!p)
		return;
	
	[[MainView instance] pushCompetitionPage:p.competition withParticipation:p];
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
