//
//  BikePage.m
//  SaveMyBike
//
//  Created by Szymon Tomasz Stefanek on 17/06/2019.
//  Copyright © 2019 GeoSolutions SaS. All rights reserved.
//

#import "BikePage.h"

#import "BikeInfoTab.h"
#import "BikeObservationsTab.h"
#import "STSI18N.h"
#import "TabView.h"

@interface BikePage()
{
	Bike * m_pBike;
	
	TabView * m_pTabView;
	
	STSTabViewTab * m_pInfoTab;
	STSTabViewTab * m_pObservationsTab;
	
	BikeInfoTab * m_pInfoTabView;
}

@end

@implementation BikePage

- (id)initWithBike:(Bike *)bk
{
	self = [super init];
	if(!self)
		return nil;
	
	m_pBike = bk;
	
	m_pTabView = [[TabView alloc] initWithTabsAbove:false];
	
	[self addView:m_pTabView row:0 column:0];
	
	m_pInfoTab = [STSTabViewTab new];
	m_pInfoTab.text = __trCtx(@"Info",@"BikePage");
	m_pInfoTabView = [[BikeInfoTab alloc] initWithBike:bk];
	m_pInfoTab.view = m_pInfoTabView;
	[m_pTabView addTab:m_pInfoTab];
	
	m_pObservationsTab = [STSTabViewTab new];
	m_pObservationsTab.text = __trCtx(@"Observations",@"BikePage");
	m_pObservationsTab.createView = ^(){ return [[BikeObservationsTab alloc] initWithBike:bk]; };
	[m_pTabView addTab:m_pObservationsTab];
	
	return self;
}


@end
