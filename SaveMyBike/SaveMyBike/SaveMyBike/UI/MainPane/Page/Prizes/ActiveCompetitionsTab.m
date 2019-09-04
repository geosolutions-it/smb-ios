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

@interface ActiveCompetitionsTab()
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
}

- (void)onDeactivate
{
	[self stopItemListFetchRequest];
}

@end
