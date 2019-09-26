//
//  Created by Szymon Tomasz Stefanek on 18/06/2019.
//  Copyright © 2019 GeoSolutions SaS. All rights reserved.
//

#import "CompetitionsPage.h"

#import "AvailableCompetitionsTab.h"
#import "ActiveCompetitionsTab.h"
#import "WonCompetitionsTab.h"
#import "STSI18N.h"
#import "TabView.h"

@interface CompetitionsPage()
{
	TabView * m_pTabView;
	
	STSTabViewTab * m_pAvailableTab;
	STSTabViewTab * m_pActiveTab;
	STSTabViewTab * m_pWonTab;
}

@end

@implementation CompetitionsPage

- (id)init
{
	self = [super init];
	if(!self)
		return nil;
	
	m_pTabView = [[TabView alloc] initWithTabsAbove:false];
	
	[self addView:m_pTabView row:0 column:0];

	m_pAvailableTab = [STSTabViewTab new];
	m_pAvailableTab.text = __trCtx(@"Available",@"CompetitionsPage");
	m_pAvailableTab.createView = ^(){ return [AvailableCompetitionsTab new]; };
	[m_pTabView addTab:m_pAvailableTab];

	m_pActiveTab = [STSTabViewTab new];
	m_pActiveTab.text = __trCtx(@"Active",@"CompetitionsPage");
	m_pActiveTab.createView = ^(){ return [ActiveCompetitionsTab new]; };
	[m_pTabView addTab:m_pActiveTab];

	m_pWonTab = [STSTabViewTab new];
	m_pWonTab.text = __trCtx(@"My Prizes",@"CompetitionsPage");
	m_pWonTab.createView = ^(){ return [WonCompetitionsTab new]; };
	[m_pTabView addTab:m_pWonTab];

	return self;
}

- (void)onPageActivate
{
	STSTabViewTab * tab = m_pTabView.currentTab;
	if(!tab)
		return;
	
	UIView * v = tab.view;
	if(!v)
		return;

	if(![v conformsToProtocol:@protocol(STSViewStackView)])
		return;
		
	id<STSViewStackView> vv = (id<STSViewStackView>)v;
	
	[vv onActivate];
}

@end
