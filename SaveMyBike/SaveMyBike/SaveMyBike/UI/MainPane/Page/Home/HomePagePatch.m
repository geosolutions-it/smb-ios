//
//  HomePagePatch.m
//  SaveMyBike
//
//  Created by Szymon Tomasz Stefanek on 20/06/2019.
//  Copyright © 2019 GeoSolutions SaS. All rights reserved.
//

#import "HomePagePatch.h"

#import "STSDisplay.h"
#import "STSLabel.h"
#import "STSImageView.h"
#import "UIColorUtilities.h"
#import "MainView.h"
#import "TracksPage.h"

#import "Config.h"

@interface HomePagePatch()
{
	STSImageView * m_pImageView;
	STSLabel * m_pTitleLabel;
	UIView * m_pSeparatorView;
	STSLabel * m_pInfoLabel;
	NSString * m_sTarget;
}

@end

@implementation HomePagePatch

- (id)initWithIcon:(NSString *)sIcon title:(NSString *)sTitle info:(NSString *)sInfo target:(NSString *)sTarget bottomRowCount:(int)iRowCount
{
	self = [super init];
	if(!self)
		return nil;
	
	m_sTarget = sTarget;
	
	STSDisplay * dpy = [STSDisplay instance];
	
	m_pImageView = [STSImageView new];
	m_pImageView.contentMode = UIViewContentModeScaleAspectFit;
	m_pImageView.image = [UIImage imageNamed:sIcon];
	[self addView:m_pImageView row:0 column:0];
	float f = [dpy majorScreenDimensionFractionToScreenUnits:0.1];
	if(f > [dpy centimetersToScreenUnits:1.5])
		f = [dpy centimetersToScreenUnits:1.5];
	[self setRow:0 fixedHeight:f];
	
	m_pTitleLabel = [STSLabel new];
	m_pTitleLabel.text = sTitle;
	m_pTitleLabel.font = [UIFont boldSystemFontOfSize:[dpy centimetersToFontUnits:0.3]];
	m_pTitleLabel.textAlignment = NSTextAlignmentCenter;
	m_pTitleLabel.textColor = [Config instance].generalForegroundColor;
	
	[self addView:m_pTitleLabel row:1 column:0];
	
	m_pSeparatorView = [UIView new];
	m_pSeparatorView.backgroundColor = [[Config instance].generalForegroundColor withAlpha:128];

	[self addView:m_pSeparatorView row:2 column:0];
	[self setRow:2 fixedHeight:1];

	m_pInfoLabel = [STSLabel new];
	m_pInfoLabel.text = sInfo;
	m_pInfoLabel.textAlignment = NSTextAlignmentCenter;
	m_pInfoLabel.lineBreakMode = NSLineBreakByWordWrapping;
	m_pInfoLabel.numberOfLines = iRowCount;
	m_pInfoLabel.textColor = [Config instance].generalForegroundColor;
	
	[self addView:m_pInfoLabel row:3 column:0];
	
	float mh = [dpy centimetersToScreenUnits:0.2];
	float mv = [dpy centimetersToScreenUnits:0.2];
	[self setMarginLeft:mh top:mv right:mh bottom:mv];
	[self setSpacing:[dpy centimetersToScreenUnits:0.1]];

	return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
	self.backgroundColor = [UIColor lightGrayColor];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
	self.backgroundColor = [UIColor whiteColor];
	if([m_sTarget isEqualToString:@"tracks"])
	{
		[[MainView instance] switchToStatsPage];
		return;
	}
	if([m_sTarget isEqualToString:@"prizes"])
	{
		[[MainView instance] pushPrizesPage];
		return;
	}
	if([m_sTarget isEqualToString:@"tracks/record"])
	{
		[[MainView instance] pushTracksPage];
		return;
	}
	if([m_sTarget isEqualToString:@"badges"])
	{
		[[MainView instance] pushBadgesPage];
		return;
	}
	if([m_sTarget isEqualToString:@"bikes"])
	{
		[[MainView instance] pushBikesPage];
		return;
	}
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
	self.backgroundColor = [UIColor whiteColor];
}

@end
