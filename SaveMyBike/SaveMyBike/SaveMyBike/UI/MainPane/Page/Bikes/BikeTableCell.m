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
#import "STSImageButton.h"

#import "BikeListView.h"
#import "Bike.h"
#import "BikeStatus.h"
#import "Globals.h"

@interface BikeTableCell()<STSImageButtonDelegate>
{
	STSRemoteImageView * m_pImageView;
	STSLabel * m_pNameLabel;
	Bike * m_pBike;
	STSImageButton * m_pStatusButton;
	BikeListView * m_pListView;
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
	[g addView:m_pNameLabel row:0 column:0 rowSpan:1 columnSpan:3 verticalSizePolicy:STSSizePolicyCanExpand horizontalSizePolicy:STSSizePolicyIgnore];

	m_pImageView = [[STSRemoteImageView alloc] initWithDownloader:[Globals instance].cachedImageDownloader andDownloaderCategory:@"bikes"];
	m_pImageView.contentMode = UIViewContentModeScaleAspectFill;
	[g addView:m_pImageView row:1 column:0 rowSpan:3 columnSpan:3 verticalSizePolicy:STSSizePolicyIgnore horizontalSizePolicy:STSSizePolicyIgnore];

	m_pStatusButton = [STSImageButton new];
	[m_pStatusButton setImage:[UIImage imageNamed:@"lock_open"] forState:STSButtonStateActive];
	[m_pStatusButton setImage:[UIImage imageNamed:@"lock_open"] forState:STSButtonStateActivePressed];
	[m_pStatusButton setImage:[UIImage imageNamed:@"lock_closed"] forState:STSButtonStateNormal];
	[m_pStatusButton setImage:[UIImage imageNamed:@"lock_closed"] forState:STSButtonStatePressed];
	[m_pStatusButton setBackgroundColor:[UIColor whiteColor] forState:STSButtonStateNormal];
	[m_pStatusButton setBackgroundColor:[UIColor whiteColor] forState:STSButtonStateActive];
	[m_pStatusButton setBackgroundColor:[UIColor lightGrayColor] forState:STSButtonStatePressed];
	[m_pStatusButton setMargins:[STSMargins marginsWithAllValues:[dpy centimetersToScreenUnits:0.2]]];
	m_pStatusButton.layer.shadowColor = [[UIColor blackColor] CGColor];
	m_pStatusButton.layer.shadowOpacity = 0.5;
	m_pStatusButton.layer.cornerRadius = [dpy centimetersToScreenUnits:0.2];
	m_pStatusButton.layer.shadowRadius = [dpy centimetersToScreenUnits:0.1];
	m_pStatusButton.layer.shadowOffset = CGSizeMake(0.0, [dpy centimetersToScreenUnits:0.1]);
	m_pStatusButton.clipsToBounds = true;
	m_pStatusButton.layer.masksToBounds = false;
	
	[m_pStatusButton setDelegate:self];
	[g addView:m_pStatusButton row:2 column:1 rowSpan:1 columnSpan:1 verticalSizePolicy:STSSizePolicyIgnore horizontalSizePolicy:STSSizePolicyIgnore];

	[g setRow:0 minimumHeight:[dpy centimetersToScreenUnits:0.4]];
	[g setRow:1 fixedHeight:[dpy centimetersToScreenUnits:2.4]];
	[g setRow:2 fixedHeight:[dpy centimetersToScreenUnits:1.0]];
	[g setRow:3 fixedHeight:[dpy centimetersToScreenUnits:0.2]];

	[g setColumn:0 expandWeight:100.0];
	[g setColumn:1 fixedWidth:[dpy centimetersToScreenUnits:1.0]];
	[g setColumn:2 fixedWidth:[dpy centimetersToScreenUnits:0.2]];

	[g setMargin:[dpy centimetersToScreenUnits:0.2f]];
	[g setSpacing:[dpy centimetersToScreenUnits:0.1f]];
	
	// Requested.
	self.selectionStyle = UITableViewCellSelectionStyleNone;
	
	return self;
}

- (void)imageButtonTapped:(STSImageButton *)pButton
{
	if(!m_pBike)
		return;
	
	if(!m_pListView)
		return;
	
	[m_pListView onBikeTableCellStatusButtonPressed:m_pBike];
}

- (void)setBike:(Bike *)bk andListView:(BikeListView *)lv
{
	m_pBike = bk;
	
	m_pNameLabel.text = bk.nickname;
	
	NSString * img = (bk.pictures && bk.pictures.count > 0) ? [bk.pictures objectAtIndex:0] : nil;

	[m_pImageView setImageURL:img andPlaceholder:@"bike_placeholder"];
	
	[m_pStatusButton setActive:(bk.currentStatus != nil) && bk.currentStatus.lost];
	
	m_pListView = lv;
}

@end
