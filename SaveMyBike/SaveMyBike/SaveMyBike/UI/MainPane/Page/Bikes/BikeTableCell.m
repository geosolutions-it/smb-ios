//
//  BikeTableCell.m
//  SaveMyBike
//
//  Created by Szymon Tomasz Stefanek on 23/08/2019.
//  Copyright © 2019 GeoSolutions SaS. All rights reserved.
//

#import "BikeTableCell.h"

#import "STSImageView.h"
#import "STSRemoteImageView.h"
#import "STSLabel.h"
#import "STSDisplay.h"

#import "Bike.h"
#import "Globals.h"

@interface BikeTableCell()
{
	STSRemoteImageView * m_pImageView;
	STSLabel * m_pNameLabel;
	Bike * m_pBike;
}

@end

@implementation BikeTableCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
	if(!self)
		return nil;

	STSDisplay * dpy = [STSDisplay instance];
	
	STSGridLayoutView * g = self.grid;

	m_pNameLabel = [STSLabel new];
	m_pNameLabel.font = [UIFont boldSystemFontOfSize:[dpy centimetersToFontUnits:0.3]];
	m_pNameLabel.text = @"---";
	[g addView:m_pNameLabel row:0 column:0 rowSpan:1 columnSpan:1 verticalSizePolicy:STSSizePolicyCanExpand horizontalSizePolicy:STSSizePolicyIgnore];

	m_pImageView = [[STSRemoteImageView alloc] initWithDownloader:[Globals instance].cachedImageDownloader andDownloaderCategory:@"bikes"];
	m_pImageView.contentMode = UIViewContentModeScaleAspectFill;
	[g addView:m_pImageView row:1 column:0 rowSpan:1 columnSpan:1 verticalSizePolicy:STSSizePolicyIgnore horizontalSizePolicy:STSSizePolicyIgnore];

	[g setRow:0 minimumHeight:[dpy centimetersToScreenUnits:0.4]];
	[g setRow:1 fixedHeight:[dpy centimetersToScreenUnits:3.5]];

	[g setMargin:[dpy centimetersToScreenUnits:0.2f]];
	[g setSpacing:[dpy centimetersToScreenUnits:0.1f]];
	
	// Requested.
	self.selectionStyle = UITableViewCellSelectionStyleNone;
	
	return self;
}

- (void)setBike:(Bike *)bk
{
	m_pBike = bk;
	
	m_pNameLabel.text = bk.nickname;
	
	NSString * img = (bk.pictures && bk.pictures.count > 0) ? [bk.pictures objectAtIndex:0] : nil;

	[m_pImageView setImageURL:img andPlaceholder:@"bike_placeholder"];
}

@end
