//
//  BadgesPage.m
//  SaveMyBike
//
//  Created by Szymon Tomasz Stefanek on 18/06/2019.
//  Copyright © 2019 GeoSolutions SaS. All rights reserved.
//

#import "BadgesPage.h"


#import "BadgesBadgesTab.h"
#import "BadgesProfileTab.h"
#import "STSI18N.h"
#import "TabView.h"

@interface BadgesPage()
{
	TabView * m_pTabView;
	
	STSTabViewTab * m_pProfileTab;
	STSTabViewTab * m_pBadgesTab;
}

@end

@implementation BadgesPage

- (id)init
{
	self = [super init];
	if(!self)
		return nil;
	
	m_pTabView = [[TabView alloc] initWithTabsAbove:false];
	
	[self addView:m_pTabView row:0 column:0];
	
	m_pProfileTab = [STSTabViewTab new];
	m_pProfileTab.text = __trCtx(@"Profile",@"BadgesPage");
	m_pProfileTab.createView = ^(){ return [BadgesProfileTab new]; };
	[m_pTabView addTab:m_pProfileTab];
	
	m_pBadgesTab = [STSTabViewTab new];
	m_pBadgesTab.text = __trCtx(@"Badges",@"BadgesPage");
	m_pBadgesTab.createView = ^(){ return [BadgesBadgesTab new]; };
	[m_pTabView addTab:m_pBadgesTab];

	
	return self;
}


- (void)switchToProfileTab
{
	[m_pTabView setCurrentTab:m_pProfileTab];
}

- (void)switchToBadgesTab
{
	[m_pTabView setCurrentTab:m_pBadgesTab];
}

@end
