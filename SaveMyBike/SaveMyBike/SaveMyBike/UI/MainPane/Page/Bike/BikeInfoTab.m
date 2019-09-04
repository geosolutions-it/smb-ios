//
//  BikeInfoTab.m
//  SaveMyBike
//
//  Created by Szymon Tomasz Stefanek on 28/08/2019.
//  Copyright © 2019 GeoSolutions SaS. All rights reserved.
//

#import "BikeInfoTab.h"

#import "STSGridLayoutView.h"
#import "STSI18n.h"
#import "STSDisplay.h"

#import "STSLabel.h"
#import "STSRemoteImageView.h"

#import "Bike.h"


@interface BikeInfoTab()
{
	Bike * m_pBike;
}

@end

@implementation BikeInfoTab

- (id)initWithBike:(Bike *)bk
{
	self = [super init];
	if(!self)
		return nil;
	
	m_pBike = bk;
	
	[self _createGrid];
	
	return self;
}

- (void)_createGrid
{
	STSDisplay * dpy = [STSDisplay instance];
	
	STSGridLayoutView * g = [STSGridLayoutView new];
	
	STSLabel * l = [STSLabel new];
	l.font = [UIFont boldSystemFontOfSize:[dpy centimetersToFontUnits:0.35]];
	l.text = m_pBike.nickname;
	[g addView:l row:0 column:0 rowSpan:1 columnSpan:2 verticalSizePolicy:STSSizePolicyFixed horizontalSizePolicy:STSSizePolicyIgnore];
	
	STSRemoteImageView * riv = [STSRemoteImageView new];
	riv.contentMode = UIViewContentModeScaleAspectFill;

	NSString * img = (m_pBike.pictures && m_pBike.pictures.count > 0) ? [m_pBike.pictures objectAtIndex:0] : nil;

	[riv setImageURL:img andPlaceholder:@"bike_placeholder"];
	[g addView:riv row:1 column:0 rowSpan:1 columnSpan:2 verticalSizePolicy:STSSizePolicyIgnore horizontalSizePolicy:STSSizePolicyIgnore];
	
	[g setRow:1 fixedHeight:[dpy minorScreenDimensionFractionToScreenUnits:0.7]];

	int r = 2;
	
	[self _createPair:g row:r left:__trCtx(@"Status",@"BikeInfoTab") right:m_pBike.currentStatus];
	r++;
	[self _createPair:g row:r left:__trCtx(@"Brand",@"BikeInfoTab") right:m_pBike.brand];
	r++;
	[self _createPair:g row:r left:__trCtx(@"Model",@"BikeInfoTab") right:m_pBike.model];
	r++;
	[self _createPair:g row:r left:__trCtx(@"Type",@"BikeInfoTab") right:m_pBike.bikeType];
	r++;
	[self _createPair:g row:r left:__trCtx(@"Gear",@"BikeInfoTab") right:m_pBike.gear];
	r++;
	[self _createPair:g row:r left:__trCtx(@"Brake",@"BikeInfoTab") right:m_pBike.brake];
	r++;
	[self _createPair:g row:r left:__trCtx(@"Color",@"BikeInfoTab") right:m_pBike.color];
	r++;
	[self _createPair:g row:r left:__trCtx(@"Saddle",@"BikeInfoTab") right:m_pBike.saddle];
	r++;
	[self _createPair:g row:r left:__trCtx(@"Basket",@"BikeInfoTab") right:m_pBike.hasBasket ? __tr(@"Yes") : __tr(@"No")];
	r++;
	[self _createPair:g row:r left:__trCtx(@"Cargo Rack",@"BikeInfoTab") right:m_pBike.hasCargoRack ? __tr(@"Yes") : __tr(@"No")];
	r++;
	[self _createPair:g row:r left:__trCtx(@"Bags",@"BikeInfoTab") right:m_pBike.hasBags ? __tr(@"Yes") : __tr(@"No")];
	r++;
	[self _createPair:g row:r left:__trCtx(@"Other",@"BikeInfoTab") right:m_pBike.otherDetails];
	r++;

	/*
	 - (NSMutableArray<NSString *> *)pictures;
	 - (void)setPictures:(NSMutableArray<NSString *> *)lPictures;
	 - (NSMutableArray<NSString *> *)tags;
	 - (void)setTags:(NSMutableArray<NSString *> *)lTags;
	 - (NSString *)lastUpdate;
	 - (void)setLastUpdate:(NSString *)sLastUpdate;
	 */

	[g setRow:r expandWeight:1000.0];
	
	[g setSpacing:[dpy centimetersToScreenUnits:0.1]];
	[g setMargin:[dpy centimetersToScreenUnits:0.2]];
	
	[self setView:g];
	[self setFillViewport:true];
}

- (void)_createPair:(STSGridLayoutView *)g row:(int)r left:(NSString *)sLeft right:(NSString *)sRight
{
	STSDisplay * dpy = [STSDisplay instance];

	STSLabel * l1 = [STSLabel new];
	l1.text = sLeft;
	l1.font = [UIFont systemFontOfSize:[dpy centimetersToFontUnits:0.3]];
	l1.textColor = [UIColor colorWithWhite:0.5 alpha:1.0];
	l1.textAlignment = NSTextAlignmentLeft;
	[g addView:l1 row:r column:0 verticalSizePolicy:STSSizePolicyFixed horizontalSizePolicy:STSSizePolicyIgnore];

	STSLabel * l2 = [STSLabel new];
	l2.text = sRight;
	l2.font = [UIFont boldSystemFontOfSize:[dpy centimetersToFontUnits:0.3]];
	l2.textAlignment = NSTextAlignmentRight;
	[g addView:l2 row:r column:1 verticalSizePolicy:STSSizePolicyFixed horizontalSizePolicy:STSSizePolicyIgnore];
}

- (void)_createSeparator:(STSGridLayoutView *)g row:(int)r col:(int)c colSpan:(int)cs
{
	UIView * v = [UIView new];
	v.backgroundColor = [UIColor lightGrayColor];
	
	[g addView:v row:r column:c rowSpan:1 columnSpan:cs verticalSizePolicy:STSSizePolicyIgnore horizontalSizePolicy:STSSizePolicyIgnore];
	[g setRow:r fixedHeight:1];
}

@end
