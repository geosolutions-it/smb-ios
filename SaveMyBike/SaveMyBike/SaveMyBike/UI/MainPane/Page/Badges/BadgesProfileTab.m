//
//  BadgesProfileTab.m
//  SaveMyBike
//
//  Created by Szymon Tomasz Stefanek on 08/07/2019.
//  Copyright © 2019 GeoSolutions SaS. All rights reserved.
//

#import "BadgesProfileTab.h"

#import "STSImageView.h"
#import "STSLabel.h"
#import "STSDisplay.h"
#import "STSI18N.h"
#import "GridPatch.h"

#import "Globals.h"
#import "Config.h"

#import "Emissions.h"
#import "HealthBenefits.h"

@interface BadgesProfileTab()
{
	STSLabel * m_pNameLabel;
	STSLabel * m_pCOLabel;
	STSLabel * m_pCO2Label;
	STSLabel * m_pPM10Label;
	STSLabel * m_pNOXLabel;
	STSLabel * m_pSO2Label;
	STSLabel * m_pCaloriesLabel;

	STSLabel * m_pMailLabel;
	
	STSImageView * m_pBackgroundView;
}

@end

@implementation BadgesProfileTab

- (id)init
{
	self = [super init];
	if(!self)
		return nil;
	
	STSDisplay * dpy = [STSDisplay instance];

	m_pBackgroundView = [STSImageView new];
	m_pBackgroundView.image = [UIImage imageNamed:@"header_background"];
	m_pBackgroundView.contentMode = UIViewContentModeScaleAspectFill;
	m_pBackgroundView.clipsToBounds = true;

	[self addSubview:m_pBackgroundView];
	
	m_pNameLabel = [STSLabel new];
	m_pNameLabel.textColor = [UIColor whiteColor];
	m_pNameLabel.textAlignment = NSTextAlignmentCenter;
	m_pNameLabel.font = [UIFont boldSystemFontOfSize:[dpy millimetersToFontUnits:4.0]];
	m_pNameLabel.lineBreakMode = NSLineBreakByWordWrapping;

	[self addView:m_pNameLabel row:0 column:0 verticalSizePolicy:STSSizePolicyFixed horizontalSizePolicy:STSSizePolicyCanExpand];
	
	STSGridLayoutView * g = [GridPatch new];
	
	m_pCOLabel = [self _createSavingsLabel:g row:0 col:0 text:__trCtx(@"CO Saved",@"BadgesProfileTab")];
	m_pCO2Label = [self _createSavingsLabel:g row:0 col:1 text:__trCtx(@"CO2 Saved",@"BadgesProfileTab")];
	m_pPM10Label = [self _createSavingsLabel:g row:0 col:2 text:__trCtx(@"PM10 Saved",@"BadgesProfileTab")];
	m_pSO2Label = [self _createSavingsLabel:g row:2 col:0 text:__trCtx(@"SO2 Saved",@"BadgesProfileTab")];
	m_pNOXLabel = [self _createSavingsLabel:g row:2 col:1 text:__trCtx(@"SO2 Saved",@"BadgesProfileTab")];
	m_pCaloriesLabel = [self _createSavingsLabel:g row:2 col:2 text:__trCtx(@"Calories",@"BadgesProfileTab")];
	
	[g setColumn:0 fixedWidthPercent:0.33];
	[g setColumn:1 fixedWidthPercent:0.34];
	[g setColumn:2 fixedWidthPercent:0.33];
	[g setRow:1 expandWeight:1000];
	[g setRow:3 expandWeight:1000];
	[g setMargin:[dpy centimetersToScreenUnits:0.1]];
	[g setSpacing:[dpy centimetersToScreenUnits:0.1]];
	
	[self addView:g row:1 column:0 verticalSizePolicy:STSSizePolicyCanExpand horizontalSizePolicy:STSSizePolicyCanExpand];
	
	
	g = [GridPatch new];

	m_pMailLabel = [self _createInfoLabel:g row:0 text:__trCtx(@"Mail", @"BadgesProfileTab")];

	[self addView:g row:2 column:0 verticalSizePolicy:STSSizePolicyCanExpand horizontalSizePolicy:STSSizePolicyCanExpand];

	
	//[g setColumn:0 fixedWidth:[dpy centimetersToScreenUnits:0.8]];
	[g setColumn:1 expandWeight:1000];
	[g setMargin:[dpy centimetersToScreenUnits:0.1]];
	[g setSpacing:[dpy centimetersToScreenUnits:0.1]];
	
	[self setRow:5 expandWeight:1000];

	[self setSpacing:[dpy centimetersToScreenUnits:0.2]];
	[self setMargin:[dpy centimetersToScreenUnits:0.2]];

	[self displayUser];
	
	return self;
}

- (STSLabel *)_createInfoLabel:(STSGridLayoutView *)g row:(int)iRow text:(NSString *)txt
{
	STSDisplay * dpy = [STSDisplay instance];

	STSLabel * l = [STSLabel new];
	l.text = txt;
	l.textAlignment = NSTextAlignmentRight;
	l.textColor = [Config instance].generalForegroundColor;
	[g addView:l row:iRow column:0 verticalSizePolicy:STSSizePolicyCanExpand horizontalSizePolicy:STSSizePolicyCanExpand];
	
	STSLabel * l2 = [STSLabel new];
	l2.textAlignment = NSTextAlignmentCenter;
	l2.font = [UIFont boldSystemFontOfSize:[dpy millimetersToFontUnits:3.4]];
	l2.textColor = [Config instance].generalForegroundColor;
	[g addView:l2 row:iRow column:1 verticalSizePolicy:STSSizePolicyCanExpand horizontalSizePolicy:STSSizePolicyCanExpand];
	
	return l2;
}

- (STSLabel *)_createSavingsLabel:(STSGridLayoutView *)g row:(int)iRow col:(int)iCol text:(NSString *)txt
{
	STSDisplay * dpy = [STSDisplay instance];

	STSLabel * l = [STSLabel new];
	l.text = txt;
	l.textAlignment = NSTextAlignmentCenter;
	l.textColor = [Config instance].generalForegroundColor;
	[g addView:l row:iRow column:iCol verticalSizePolicy:STSSizePolicyCanExpand horizontalSizePolicy:STSSizePolicyCanExpand];
	
	STSLabel * l2 = [STSLabel new];
	l2.textAlignment = NSTextAlignmentCenter;
	l2.font = [UIFont boldSystemFontOfSize:[dpy millimetersToFontUnits:3.4]];
	l2.textColor = [Config instance].highlight1Color;
	[g addView:l2 row:iRow+1 column:iCol verticalSizePolicy:STSSizePolicyCanExpand horizontalSizePolicy:STSSizePolicyCanExpand];

	return l2;
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	m_pBackgroundView.frame = self.bounds;
}

- (void)displayUser
{
	UserData * ud = [Globals instance].userData;
	
	m_pNameLabel.text = ud ? [NSString stringWithFormat:@"%@ %@",ud.firstName ? ud.firstName : @"",ud.lastName ? ud.lastName : @""] : @"?";
	m_pCOLabel.text = (ud && ud.totalEmissions) ? [NSString stringWithFormat:@"%.2f g",ud.totalEmissions.co_saved] : __tr(@"N/A");
	m_pCO2Label.text = (ud && ud.totalEmissions) ? [NSString stringWithFormat:@"%.2f g",ud.totalEmissions.co2_saved] : __tr(@"N/A");
	m_pPM10Label.text = (ud && ud.totalEmissions) ? [NSString stringWithFormat:@"%.2f g",ud.totalEmissions.pm10_saved] : __tr(@"N/A");
	m_pNOXLabel.text = (ud && ud.totalEmissions) ? [NSString stringWithFormat:@"%.2f g",ud.totalEmissions.nox_saved] : __tr(@"N/A");
	m_pSO2Label.text = (ud && ud.totalEmissions) ? [NSString stringWithFormat:@"%.2f g",ud.totalEmissions.so2_saved] : __tr(@"N/A");
	m_pCaloriesLabel.text = (ud && ud.totalHealthBenefits) ? [NSString stringWithFormat:@"%.0f",ud.totalHealthBenefits.calories_consumed] : __tr(@"N/A");
	
	m_pMailLabel.text = ud ? ud.email : @"-";
	
	[self setNeedsLayout];
}

@end
