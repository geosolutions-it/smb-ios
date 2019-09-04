//
//  TracksPage.m
//  SaveMyBike
//
//  Created by Szymon Tomasz Stefanek on 17/06/2019.
//  Copyright © 2019 GeoSolutions SaS. All rights reserved.
//

#import "TracksPage.h"

#import "TracksRecordTab.h"
#import "TracksStatsTab.h"
#import "STSI18N.h"
#import "TabView.h"

@interface TracksPage()<STSTabViewCurrentTabWatcher>
{
	TabView * m_pTabView;
	
	STSTabViewTab * m_pRecordTab;
	STSTabViewTab * m_pStatsTab;
	
	TracksRecordTab * m_pRecordTabView;
}

@end

@implementation TracksPage

- (id)init
{
	self = [super init];
	if(!self)
		return nil;
	
	m_pTabView = [[TabView alloc] initWithTabsAbove:false];
	
	[self addView:m_pTabView row:0 column:0];
	
	m_pRecordTab = [STSTabViewTab new];
	m_pRecordTab.text = __trCtx(@"Record",@"TracksPage");
	m_pRecordTabView = [TracksRecordTab new];
	m_pRecordTab.view = m_pRecordTabView;
	[m_pTabView addTab:m_pRecordTab];
	
	m_pStatsTab = [STSTabViewTab new];
	m_pStatsTab.text = __trCtx(@"Stats",@"TracksPage");
	m_pStatsTab.createView = ^(){ return [TracksStatsTab new]; };
	[m_pTabView addTab:m_pStatsTab];
	
	
	return self;
}

- (void)switchToStatsTab
{
	[m_pTabView setCurrentTab:m_pStatsTab];
}

- (void)onTabView:(STSTabView *)view currentTabChanged:(STSTabViewTab *)cur
{
	if(cur == m_pRecordTab)
		[m_pRecordTabView onActivate];
	else
		[m_pRecordTabView onDeactivate];
}

- (void)onPageActivate
{
	[m_pRecordTabView onActivate];
	[m_pTabView addCurrentTabWatcher:self];
}

- (void)onPageDeactivate
{
	[m_pTabView removeCurrentTabWatcher:self];
	[m_pRecordTabView onDeactivate];
}

@end
