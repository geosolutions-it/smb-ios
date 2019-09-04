//
//  TracksStatsTab.m
//  SaveMyBike
//
//  Created by Szymon Tomasz Stefanek on 08/07/2019.
//  Copyright © 2019 GeoSolutions SaS. All rights reserved.
//

#import "TracksStatsTab.h"

#import "TracksActiveTracksSubTab.h"
#import "TracksPendingTracksSubTab.h"

#import "STSI18N.h"

@interface TracksStatsTab()
{
	STSTabViewTab * m_pActiveTracksTab;
	STSTabViewTab * m_pPendingTracksTab;
}

@end

@implementation TracksStatsTab

- (id)init
{
	self = [super initWithTabsAbove:true];
	if(!self)
		return nil;
	
	m_pActiveTracksTab = [STSTabViewTab new];
	m_pActiveTracksTab.text = __trCtx(@"TRACKS",@"TracksStatsTab");
	m_pActiveTracksTab.createView = ^(){ return [TracksActiveTracksSubTab new]; };
	[self addTab:m_pActiveTracksTab];
	
	m_pPendingTracksTab = [STSTabViewTab new];
	m_pPendingTracksTab.text = __trCtx(@"TO SEND",@"TracksStatsTab");
	m_pPendingTracksTab.createView = ^(){ return [TracksPendingTracksSubTab new]; };
	[self addTab:m_pPendingTracksTab];

	return self;
}

@end
