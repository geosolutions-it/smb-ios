//
//  TitleImageAndDescriptionView.m
//  SaveMyBike
//
//  Created by Pragma on 26/09/2019.
//  Copyright © 2019 STS. All rights reserved.
//

#import "TitleImageAndDescriptionView.h"

#import "STSRemoteImageView.h"
#import "STSLabel.h"
#import "STSDisplay.h"

#import "Globals.h"
#import "Config.h"
#import "MainView.h"

@interface TitleImageAndDescriptionView()
{
	STSLabel * m_pTitleLabel;
	STSLabel * m_pDescriptionLabel;
	STSRemoteImageView * m_pImageView;
}
@end

@implementation TitleImageAndDescriptionView

- (id)initWithTitle:(NSString *)sTitle imageURL:(NSString *)sURL placeholder:(NSString *)sPlaceholder description:(NSString *)sDescription
{
	self = [super init];
	if(!self)
		return nil;
	
	STSDisplay * dpy = [STSDisplay instance];
	
	m_pTitleLabel = [STSLabel new];
	m_pTitleLabel.textAlignment = NSTextAlignmentCenter;
	m_pTitleLabel.font = [UIFont boldSystemFontOfSize:[dpy millimetersToFontUnits:2.5]];
	m_pTitleLabel.textColor = [Config instance].highlight1Color;
	m_pTitleLabel.text = sTitle;
	[self addView:m_pTitleLabel row:0 column:0];
	
	m_pImageView = [[STSRemoteImageView alloc] initWithDownloader:[Globals instance].cachedImageDownloader andDownloaderCategory:@"banners"];
	m_pImageView.contentMode = UIViewContentModeScaleAspectFill;
	[m_pImageView setImageURL:sURL andPlaceholder:sPlaceholder];
	m_pImageView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
	[self addView:m_pImageView row:1 column:0];
	
	m_pDescriptionLabel = [STSLabel new];
	m_pDescriptionLabel.textAlignment = NSTextAlignmentCenter;
	m_pDescriptionLabel.text = sDescription;
	[self addView:m_pDescriptionLabel row:2 column:0];
	
	[self setRow:1 fixedHeight:[dpy minorScreenDimensionFractionToScreenUnits:0.5]];
	
	[self setMargin:[dpy centimetersToScreenUnits:0.2]];
	[self setSpacing:[dpy centimetersToScreenUnits:0.1]];
	
	self.backgroundColor = [UIColor whiteColor];
	self.layer.cornerRadius = [dpy centimetersToScreenUnits:0.1];
	self.layer.shadowColor = [[UIColor blackColor] CGColor];
	self.layer.shadowOpacity = 0.5;
	self.layer.shadowRadius = [dpy centimetersToScreenUnits:0.1];
	self.layer.shadowOffset = CGSizeMake(0.0, [dpy centimetersToScreenUnits:0.1]);
	self.clipsToBounds = true;
	self.layer.masksToBounds = false;
	
	return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
	if(!_openURL)
		return;
	self.backgroundColor = [UIColor lightGrayColor];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
	if(!_openURL)
		return;
	self.backgroundColor = [UIColor whiteColor];
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:_openURL] options:nil completionHandler:nil];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
	if(!_openURL)
		return;
	self.backgroundColor = [UIColor whiteColor];
}

@end
