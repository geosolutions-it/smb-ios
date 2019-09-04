//
//  TracksRecordTab.m
//  SaveMyBike
//
//  Created by Szymon Tomasz Stefanek on 08/07/2019.
//  Copyright © 2019 GeoSolutions SaS. All rights reserved.
//

#import "TracksRecordTab.h"

#import "STSImageView.h"
#import "STSDisplay.h"
#import "STSLabel.h"
#import "STSI18N.h"
#import "STSImageButton.h"
#import "Tracker.h"
#import "TrackingSession.h"
#import "VehicleType.h"
#import "STSMessageBox.h"

@interface TracksRecordTab()<STSImageButtonDelegate>
{
	STSImageView * m_pBackground;

	NSMutableDictionary<NSString *,STSImageButton *> * m_pButtons;
	
	STSImageButton * m_pRecordButton;
	
	NSString * m_sCurrentVehicleType;
	VehicleType m_eCurrentVehicleType;

	STSLabel * m_pTimeLabel;
	STSLabel * m_pDistanceLabel;
	
	NSTimer * m_pUpdateTimer;
	
}
@end

@implementation TracksRecordTab

- (id)init
{
	self = [super init];
	if(!self)
		return nil;

	STSDisplay * dpy = [STSDisplay instance];
	
	m_pUpdateTimer = nil;
	
	m_pBackground = [STSImageView new];
	m_pBackground.image = [UIImage imageNamed:@"tracks_page_background"];
	m_pBackground.contentMode = UIViewContentModeScaleAspectFill;
	[self addSubview:m_pBackground];

	STSLabel * l = [STSLabel new];
	l.text = __trCtx(@"Select a Vehicle", @"TracksRecordTab");
	l.textAlignment = NSTextAlignmentCenter;
	l.textColor = [UIColor whiteColor];
	[self addView:l row:0 column:0 rowSpan:0 columnSpan:5];
	
	m_pButtons = [NSMutableDictionary new];
	
	[self _createVehicleButton:@"walk" vehicleType:VehicleTypeFoot row:1 column:1];
	[self _createVehicleButton:@"bike" vehicleType:VehicleTypeBike row:1 column:3];
	[self _createVehicleButton:@"moto" vehicleType:VehicleTypeMotorcycle row:2 column:1];
	[self _createVehicleButton:@"car" vehicleType:VehicleTypeCar row:2 column:3];
	[self _createVehicleButton:@"bus" vehicleType:VehicleTypeBus row:3 column:1];
	[self _createVehicleButton:@"train" vehicleType:VehicleTypeTrain row:3 column:3];

	STSGridLayoutView * g = [STSGridLayoutView new];
	//g.backgroundColor = [UIColor redColor];
	
	m_pTimeLabel = [STSLabel new];
	m_pTimeLabel.textColor = [UIColor whiteColor];
	m_pTimeLabel.font = [UIFont boldSystemFontOfSize:[dpy millimetersToFontUnits:2.5]];
	m_pTimeLabel.textAlignment = NSTextAlignmentCenter;
	m_pTimeLabel.text = @"--:--";
	
	[g addView:m_pTimeLabel row:0 column:0];
	
	m_pRecordButton = [STSImageButton new];
	
	[m_pRecordButton setImage:[UIImage imageNamed:@"record_play_pause"] forState:STSButtonStateNormal];
	[m_pRecordButton setImage:[UIImage imageNamed:@"record_stop"] forState:STSButtonStateActive];
	[m_pRecordButton setBackgroundColor:[UIColor grayColor] forState:STSButtonStatePressed];
	[m_pRecordButton setBackgroundColor:[UIColor clearColor] forState:STSButtonStateActive];
	[m_pRecordButton setBackgroundColor:[UIColor clearColor] forState:STSButtonStateNormal];
	[m_pRecordButton setDelegate:self];
	
	m_pRecordButton.payload = @"record";
	
	[g addView:m_pRecordButton row:0 column:1];
	
	m_pDistanceLabel = [STSLabel new];
	m_pDistanceLabel.textColor = [UIColor whiteColor];
	m_pDistanceLabel.font = [UIFont boldSystemFontOfSize:[dpy millimetersToFontUnits:2.5]];
	m_pDistanceLabel.textAlignment = NSTextAlignmentCenter;
	m_pDistanceLabel.text = @"--- km";

	[g addView:m_pDistanceLabel row:0 column:2];

	[g setColumn:0 minimumWidthPercent:0.3];
	[g setColumn:1 minimumWidthPercent:0.3];
	[g setColumn:2 minimumWidthPercent:0.3];

	[self addView:g row:4 column:1 rowSpan:1 columnSpan:3];
	
	double hmax = [dpy majorScreenDimensionFractionToScreenUnits:0.15];
	double h = [dpy centimetersToScreenUnits:1.8];
	if(h > hmax)
		h = hmax;

	[self setRow:1 minimumHeight:h];
	[self setRow:2 minimumHeight:h];
	[self setRow:3 minimumHeight:h];
	
	h = [dpy centimetersToScreenUnits:1.1];
	if(h > hmax)
		h = hmax;
	[self setRow:4 minimumHeight:h];

	[self setColumn:0 minimumWidthPercent:0.05];
	[self setColumn:1 minimumWidth:[dpy centimetersToScreenUnits:2.0]];
	[self setColumn:2 minimumWidthPercent:0.05];
	[self setColumn:3 minimumWidth:[dpy centimetersToScreenUnits:2.0]];
	[self setColumn:4 minimumWidthPercent:0.05];
	[self setMargin:[dpy centimetersToScreenUnits:0.2]];
	[self setSpacing:[dpy centimetersToScreenUnits:0.1]];

	m_sCurrentVehicleType = nil;
	m_eCurrentVehicleType = VehicleTypeBike;
	
	[self _setSelectedVehicleId:VehicleTypeBike];
	
	return self;
}

- (void)onActivate
{
	[self _updateState];
	if(m_pUpdateTimer)
		return;
	m_pUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(_onUpdateTimerTimeout) userInfo:nil repeats:true];
}

- (void)onDeactivate
{
	[self _updateState];
	if(!m_pUpdateTimer)
		return;
	[m_pUpdateTimer invalidate];
	m_pUpdateTimer = nil;
}

- (void)_onUpdateTimerTimeout
{
	[self _updateState];
}

- (void)_setSelectedVehicleId:(VehicleType)eType
{
	if(m_sCurrentVehicleType)
	{
		STSImageButton * b = [m_pButtons objectForKey:m_sCurrentVehicleType];
		if(b)
			[b setActive:false];
	}
	
	m_eCurrentVehicleType = eType;
	m_sCurrentVehicleType = [NSString stringWithFormat:@"%d",(int)eType];

	STSImageButton * b = [m_pButtons objectForKey:m_sCurrentVehicleType];
	if(b)
		[b setActive:true];
	
	[[Tracker instance] setCurrentVehicleType:eType];
}

- (STSImageButton *)_createVehicleButton:(NSString *)sId vehicleType:(VehicleType)eType row:(int)iRow column:(int)iColumn
{
	STSImageButton * b = [STSImageButton new];
	
	[b setImage:[UIImage imageNamed:[NSString stringWithFormat:@"record_%@",sId]] forState:STSButtonStateNormal];
	[b setImage:[UIImage imageNamed:[NSString stringWithFormat:@"record_%@_selected",sId]] forState:STSButtonStateActive];
	
	[b setTheme:STSButtonThemeNoBackgroundWhiteForeground];
	[b setBackgroundColor:[UIColor grayColor] forState:STSButtonStatePressed];
	[b setBackgroundColor:[UIColor clearColor] forState:STSButtonStateActive];

	[b setDelegate:self];

	NSString * sNum = [NSString stringWithFormat:@"%d",(int)eType];
	
	b.payload = sNum;

	[self addView:b row:iRow column:iColumn];
	
	[m_pButtons setValue:b forKey:sNum];
	
	return b;
}

- (void)imageButtonTapped:(STSImageButton *)pButton
{
	NSString * s = (NSString *)pButton.payload;
	if(!s)
		return;
	
	if([s isEqualToString:@"record"])
	{
		[self _onRecordPressed];
		return;
	}
	
	int iVal = [s intValue];
	
	[self _setSelectedVehicleId:(VehicleType)iVal];
}

- (void)layoutSubviews
{
	m_pBackground.frame = self.bounds;
	[super layoutSubviews];
}

- (void)_onRecordPressed
{
	if(![Tracker instance].session)
	{
		// FIXME: handle start errors? are there any?
		TrackingSession * s = [[Tracker instance] startTrackingSessionWithVehicleType:m_eCurrentVehicleType];
		[self _updateState];
		if(!s)
			[STSMessageBox showWithMessage:__trCtx(@"Failed to start the session",@"TracksRecordTab")];
		return;
	}
	
	[[Tracker instance] stopTrackingSession];
	[self _updateState];
}

- (void)_updateState
{
	TrackingSession * s = [Tracker instance].session;
	if(s)
	{
		long int t = (long int)-[s.startDateTime timeIntervalSinceNow];
		
		long h = t / 3600;
		long m = (t % 3600) / 60;
		long s = t % 60;

		m_pTimeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",h,m,s];

		double dDist = [Tracker instance].currentDistance;
		if(dDist < 1000.0)
			m_pDistanceLabel.text = [NSString stringWithFormat:@"%.0f m",dDist];
		else if(dDist < 10000.0)
			m_pDistanceLabel.text = [NSString stringWithFormat:@"%.2f km",dDist / 1000.0];
		else
			m_pDistanceLabel.text = [NSString stringWithFormat:@"%.1f km",dDist / 1000.0];

		m_pTimeLabel.alpha = 1.0;
		m_pDistanceLabel.alpha = 1.0;
		
		[m_pRecordButton setActive:true];

	} else {
		m_pTimeLabel.alpha = 0.0;
		m_pDistanceLabel.alpha = 0.0;

		[m_pRecordButton setActive:false];
	}
}

@end
