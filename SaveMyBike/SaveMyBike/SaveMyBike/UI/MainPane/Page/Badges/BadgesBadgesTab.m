//
//  BadgesBadgesTab.m
//  SaveMyBike
//
//  Created by Szymon Tomasz Stefanek on 08/07/2019.
//  Copyright © 2019 GeoSolutions SaS. All rights reserved.
//

#import "BadgesBadgesTab.h"

#import "LargeIconAndTwoTextsView.h"
#import "BackendRequestGetMyBadges.h"
#import "STSI18N.h"
#import "STSViewStack.h"
#import "BadgeDescriptor.h"
#import "AppDelegate.h"

@interface BadgesBadgesTab()<STSViewStackView,NotificationDelegate>
{
	BadgeDescriptor * m_pDescriptor;
}
@end

@implementation BadgesBadgesTab

- (id)init
{
	self = [super init];
	if(!self)
		return nil;
	
	m_pDescriptor = [BadgeDescriptor new];
	
	return self;
}

- (BackendPagedRequest *)onCreateRequest
{
	return [BackendRequestGetMyBadges new];
}

- (void)onSetupTableItemCell:(STSSimpleTableViewCell *)cell withItem:(NSObject *)ob
{
	STSSimpleTableViewCellWithImageAndTwoLabels * pCell = (STSSimpleTableViewCellWithImageAndTwoLabels *)cell;
	
	Badge * cmp = (Badge *)ob;
	
	NSRange r = [cmp.name rangeOfString:@"_"];
	if(r.location != NSNotFound)
	{
		NSString * s = [cmp.name substringFromIndex:r.location+1];

		NSString * title = [m_pDescriptor.titles objectForKey:s];
		
		pCell.upperLabel.text = title ? title : cmp.name;
		pCell.lowerLabel.text = cmp.description;
		
		NSString * b = cmp.acquired ? [NSString stringWithFormat:@"badge_%@_acquired", s] : [NSString stringWithFormat:@"badge_%@", s];
		UIImage * img = [UIImage imageNamed:b];
		pCell.iconView.image = img ? img : [UIImage imageNamed:@"large_gray_icon_badge"];
		
	} else {
		pCell.upperLabel.text = cmp.name;
		pCell.lowerLabel.text = cmp.description;

		pCell.iconView.image = [UIImage imageNamed:@"large_gray_icon_badge"];
	}
	pCell.iconView.alpha = cmp.acquired ? 1.0 : 0.3;
	pCell.upperLabel.alpha = cmp.acquired ? 1.0 : 0.3;
	pCell.lowerLabel.alpha = cmp.acquired ? 1.0 : 0.3;
}

- (NSMutableArray< NSObject * > *)onGetItemsFromRequest:(BackendPagedRequest *)pRequest
{
	BackendRequestGetMyBadges * rq = (BackendRequestGetMyBadges *)pRequest;
	return (NSMutableArray< NSObject * > *)rq.badges;
}

- (LargeIconAndTwoTextsView *)onCreateNothingHereYetView
{
	return [[LargeIconAndTwoTextsView alloc]
			initWithIcon:@"large_gray_icon_badge"
			shortText:__trCtx(@"No badges",@"BadgesBadgesTab")
			longText:__trCtx(@"You have no badges yet",@"BadgesBadgesTab")
		];
}

- (void)onItemSelected:(NSObject *)pItem
{
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
	if([sMessage isEqualToString:@"badge_won"])
		[self refresh];
}


@end
