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

@interface AvailableCompetitionsTab()
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
}

- (void)onDeactivate
{
	[self stopItemListFetchRequest];
}

@end
