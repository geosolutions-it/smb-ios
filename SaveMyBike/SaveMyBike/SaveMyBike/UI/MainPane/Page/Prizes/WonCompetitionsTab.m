//
//  Created by Szymon Tomasz Stefanek on 08/08/2019.
//  Copyright © 2019 GeoSolutions SaS. All rights reserved.
//

#import "WonCompetitionsTab.h"

#import "BackendRequestGetMyCompetitionsWon.h"
#import "CompetitionParticipation.h"
#import "STSI18n.h"
#import "CompetitionPage.h"
#import "MainView.h"

@interface WonCompetitionsTab()
{
}

@end

@implementation WonCompetitionsTab

- (void)onSetupTableItemCell:(STSSimpleTableViewCell *)cell withItem:(NSObject *)ob
{
	STSSimpleTableViewCellWithImageAndTwoLabels * pCell = (STSSimpleTableViewCellWithImageAndTwoLabels *)cell;
	
	CompetitionParticipation * cmp = (CompetitionParticipation *)ob;
	
	pCell.upperLabel.text = cmp.competition.name;
	pCell.lowerLabel.text = cmp.competition.description;
	pCell.iconView.image = [UIImage imageNamed:@"competition_won"];
}

- (BackendPagedRequest *)onCreateRequest
{
	return [BackendRequestGetMyCompetitionsWon new];
}

- (NSMutableArray< NSObject * > *)onGetItemsFromRequest:(BackendPagedRequest *)pRequest
{
	BackendRequestGetMyCompetitionsWon * rq = (BackendRequestGetMyCompetitionsWon *)pRequest;
	return (NSMutableArray< NSObject * > *)rq.competitions;
}

- (LargeIconAndTwoTextsView *)onCreateNothingHereYetView
{
	return [[LargeIconAndTwoTextsView alloc]
			initWithIcon:@"large_gray_icon_trophy"
				shortText:__trCtx(@"No prizes",@"ActivePrizesTab")
				longText:__trCtx(@"You haven't won anything yet. Please look at the 'Available' tab and participate in a competition.",@"WonCompetitionsTab")
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
