//
//  BikesPage.m
//  SaveMyBike
//
//  Created by Szymon Tomasz Stefanek on 18/06/2019.
//  Copyright © 2019 GeoSolutions SaS. All rights reserved.
//

#import "BikesPage.h"

#import "BikeListView.h"

@interface BikesPage()
{
	BikeListView * m_pListView;
}

@end

@implementation BikesPage

- (id)init
{
	self = [super init];
	if(!self)
		return nil;
	
	m_pListView = [BikeListView new];
	[self addView:m_pListView row:0 column:0];
	
	return self;
}

- (void)onPageActivate
{
	[m_pListView onActivate];
}

- (void)onPageDeactivate
{
	[m_pListView onDeactivate];
}


@end
