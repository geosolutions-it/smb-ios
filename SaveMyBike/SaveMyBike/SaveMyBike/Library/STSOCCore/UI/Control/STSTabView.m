//
//  STSTabView.m
//
//  Created by Szymon Tomasz Stefanek on 17/06/2019.
//  Copyright © 2019 Szymon Tomasz Stefanek. All rights reserved.
//

#import "STSTabView.h"

#import "STSSegmentedControl.h"
#import "STSViewStack.h"
#import "STSDisplay.h"
#import "STSDelegateArray.h"

@implementation STSTabViewTab
@end

@interface STSTabView()
{
	NSMutableArray<STSTabViewTab *> * m_pTabs;
	
	STSTabViewTab * m_pCurrentTab;
	
	NSMutableArray<NSString *> * m_pSectionImages;
	NSMutableArray<NSString *> * m_pSectionSelectedImages;
	NSMutableArray<NSString *> * m_pSectionTitles;
	
	STSDelegateArray * m_pCurrentTabWatchers;
}

@end

@implementation STSTabView

- (id)init
{
	self = [super init];
	if(!self)
		return nil;
	
	[self _commonInitWithTabsAbove:false andSegmentedControlType:STSSegmentedControlTypeText];
	
	return self;
}

- (id)initWithSegmentedControlType:(STSSegmentedControlType)eType
{
	self = [super init];
	if(!self)
		return nil;
	
	[self _commonInitWithTabsAbove:false andSegmentedControlType:eType];
	
	return self;
}

- (id)initWithTabsAbove:(bool)bAbove
{
	self = [super init];
	if(!self)
		return nil;
	
	[self _commonInitWithTabsAbove:bAbove andSegmentedControlType:STSSegmentedControlTypeText];
	
	return self;
}

- (id)initWithTabsAbove:(bool)bAbove andSegmentedControlType:(STSSegmentedControlType)eType
{
	self = [super init];
	if(!self)
		return nil;
	
	[self _commonInitWithTabsAbove:bAbove andSegmentedControlType:eType];
	
	return self;
}


- (void)_commonInitWithTabsAbove:(bool)bAbove andSegmentedControlType:(STSSegmentedControlType)eType
{
	m_pTabs = [NSMutableArray new];
	m_pCurrentTab = nil;
	
	m_pCurrentTabWatchers = [STSDelegateArray new];
	
	m_pSectionImages = [NSMutableArray new];
	m_pSectionSelectedImages = [NSMutableArray new];
	m_pSectionTitles = [NSMutableArray new];
	
	_viewStack = [STSViewStack new];
	
	STSTabView * that = self;
	
	_segmentedControl = [STSSegmentedControl new];

	_segmentedControl.sectionTitles = m_pSectionTitles;
	_segmentedControl.sectionImages = m_pSectionImages;
	_segmentedControl.sectionSelectedImages = m_pSectionSelectedImages;
	_segmentedControl.type = eType;
	
	[_segmentedControl setIndexChangeBlock:^(NSInteger index){
		[that _onSegmentedControlIndexChanged:(int)index];
	}];

	[self addView:_viewStack row:(bAbove ? 1 : 0) column:0 verticalSizePolicy:STSSizePolicyCanExpand horizontalSizePolicy:STSSizePolicyIgnore];
	[self addView:_segmentedControl row:(bAbove ? 0 : 1) column:0 verticalSizePolicy:STSSizePolicyCanExpand horizontalSizePolicy:STSSizePolicyIgnore];
	
	STSDisplay * dpy = [STSDisplay instance];
	
	[self setRow:(bAbove ? 1 : 0) expandWeight:1000.0];
	[self setRow:(bAbove ? 0 : 1) minimumHeight:[dpy centimetersToScreenUnits:0.6]];
}

- (void)addTab:(STSTabViewTab *)tab
{
	[m_pTabs addObject:tab];
	
	[m_pSectionTitles addObject:tab.text ? tab.text : @"?"];
	[m_pSectionImages addObject:tab.icon ? tab.icon : @""];
	[m_pSectionSelectedImages addObject:tab.selectedIcon ? tab.selectedIcon : (tab.icon ? tab.icon : @"")];
	
	_segmentedControl.sectionTitles = m_pSectionTitles;
	_segmentedControl.sectionImages = m_pSectionImages;
	_segmentedControl.sectionSelectedImages = m_pSectionSelectedImages;

	if(self.superview && (!m_pCurrentTab))
		[self setCurrentTab:tab];
}

- (STSTabViewTab *)currentTab
{
	return m_pCurrentTab;
}

- (void)addCurrentTabWatcher:(id<STSTabViewCurrentTabWatcher>)d
{
	[m_pCurrentTabWatchers addDelegate:d];
}

- (void)removeCurrentTabWatcher:(id<STSTabViewCurrentTabWatcher>)d
{
	[m_pCurrentTabWatchers removeDelegate:d];
}

- (void)didMoveToSuperview
{
	[super didMoveToSuperview];

	if((!m_pCurrentTab) && (m_pTabs.count > 0))
		[self setCurrentTab:[m_pTabs objectAtIndex:0]];
}

- (void)setCurrentTab:(STSTabViewTab *)tab
{
	[self _setCurrentTab:tab manageSegmentedControl:true];
}

- (void)_setCurrentTab:(STSTabViewTab *)tab manageSegmentedControl:(bool)bManageIt
{
	if(!tab)
		return;
	
	[self _activateViewForTab:tab];
	
	m_pCurrentTab = tab;

	if(bManageIt)
	{
		NSUInteger idx = [m_pTabs indexOfObject:tab];
		if((idx != NSNotFound) && (idx <m_pTabs.count))
			[_segmentedControl setSelectedSegmentIndex:idx animated:true];
	}

	if(m_pCurrentTabWatchers.count > 0)
		[m_pCurrentTabWatchers performSelectorOnAllDelegates:@selector(onTabView:currentTabChanged:) withObject:self withObject:tab];
}

- (void)setCurrentTabByIndex:(int)iIndex
{
	if(iIndex < 0)
		return;
	if(m_pTabs.count < iIndex)
		return;
	STSTabViewTab * tab = [m_pTabs objectAtIndex:iIndex];
	if(!tab)
		return;
	[self setCurrentTab:tab];
}

- (void)_onSegmentedControlIndexChanged:(int)iIdx
{
	STSTabViewTab * tab = [m_pTabs objectAtIndex:iIdx];
	
	[self _setCurrentTab:tab manageSegmentedControl:false];
}

- (void)_activateViewForTab:(STSTabViewTab *)tab
{
	if(!tab)
		return;
	
	if(!tab.view)
	{
		tab.view = (tab.createView)();
		if(!tab.view)
			return; // aargh!
		
		[_viewStack addView:tab.view];
	} else if(!tab.view.superview)
	{
		[_viewStack addView:tab.view];
	}

	[_viewStack setCurrentView:tab.view];
}

@end
