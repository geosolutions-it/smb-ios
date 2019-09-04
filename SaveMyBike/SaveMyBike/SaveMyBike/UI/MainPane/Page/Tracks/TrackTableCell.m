//
//  TracksPage.m
//  SaveMyBike
//
//  Created by Szymon Tomasz Stefanek on 17/06/2019.
//  Copyright © 2019 GeoSolutions SaS. All rights reserved.
//

#import "TrackTableCell.h"

#import "STSImageView.h"
#import "STSLabel.h"
#import "STSDisplay.h"
#import "STSGridLayoutView.h"
#import "NSDate+Format.h"
#import "STSI18n.h"

#import "Track.h"

#define VEHICLE_VIEWS 3

@interface TrackTableCell()
{
	STSImageView * m_pImageView;
	
	STSImageView * m_pErrorView;
	STSImageView * m_pTimeView;
	
	STSImageView * m_pVehicleView[VEHICLE_VIEWS];

	STSLabel * m_pDateLabel;
	STSLabel * m_pDurationLabel;
	STSLabel * m_pDistanceLabel;
	
	NSDateFormatter * m_pFormatter;
}

@end

@implementation TrackTableCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
	if(!self)
		return nil;
	
	m_pFormatter = [NSDateFormatter new];
	[m_pFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
	[m_pFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
	
	STSDisplay * dpy = [STSDisplay instance];

	STSGridLayoutView * g = self.grid;

	m_pDateLabel = [STSLabel new];
	m_pDateLabel.font = [UIFont boldSystemFontOfSize:[dpy centimetersToFontUnits:0.3]];
	[g addView:m_pDateLabel row:0 column:0 rowSpan:1 columnSpan:2 verticalSizePolicy:STSSizePolicyCanExpand horizontalSizePolicy:STSSizePolicyCanExpand];

	m_pErrorView = [STSImageView new];
	m_pErrorView.contentMode = UIViewContentModeScaleAspectFit;
	[g addView:m_pErrorView row:0 column:2 rowSpan:1 columnSpan:1 verticalSizePolicy:STSSizePolicyIgnore horizontalSizePolicy:STSSizePolicyIgnore];

	for(int i=0;i<VEHICLE_VIEWS;i++)
	{
		m_pVehicleView[i] = [STSImageView new];
		m_pVehicleView[i].contentMode = UIViewContentModeScaleAspectFit;
		[g addView:m_pVehicleView[i] row:0 column:3+i rowSpan:1 columnSpan:1 verticalSizePolicy:STSSizePolicyIgnore horizontalSizePolicy:STSSizePolicyIgnore];
	}
	
	
	m_pImageView = [STSImageView new];
	m_pImageView.contentMode = UIViewContentModeScaleAspectFit;

	[g addView:m_pImageView row:1 column:0 rowSpan:1 columnSpan:1 verticalSizePolicy:STSSizePolicyIgnore horizontalSizePolicy:STSSizePolicyIgnore];

	
	m_pDistanceLabel = [STSLabel new];
	m_pDistanceLabel.font = [UIFont systemFontOfSize:[dpy centimetersToFontUnits:0.25]];
	m_pDistanceLabel.text = @"0 km";
	[g addView:m_pDistanceLabel row:1 column:1 rowSpan:1 columnSpan:1 verticalSizePolicy:STSSizePolicyCanExpand horizontalSizePolicy:STSSizePolicyCanExpand];

	
	m_pTimeView = [STSImageView new];
	m_pTimeView.contentMode = UIViewContentModeScaleAspectFit;
	[g addView:m_pTimeView row:1 column:2 rowSpan:1 columnSpan:1 verticalSizePolicy:STSSizePolicyIgnore horizontalSizePolicy:STSSizePolicyIgnore];


	m_pDurationLabel = [STSLabel new];
	m_pDurationLabel.font = [UIFont systemFontOfSize:[dpy centimetersToFontUnits:0.25]];
	m_pDurationLabel.textAlignment = NSTextAlignmentRight;
	m_pDurationLabel.text = @"00:00:00";
	[g addView:m_pDurationLabel row:1 column:3 rowSpan:1 columnSpan:VEHICLE_VIEWS verticalSizePolicy:STSSizePolicyCanExpand horizontalSizePolicy:STSSizePolicyCanExpand];

	
	[g setColumn:0 fixedWidth:[dpy centimetersToScreenUnits:0.7]];
	[g setColumn:2 fixedWidth:[dpy centimetersToScreenUnits:0.6]];
	for(int i=0;i<VEHICLE_VIEWS;i++)
		[g setColumn:3+i fixedWidth:[dpy centimetersToScreenUnits:0.6]];

	[g setColumn:1 expandWeight:1000.0];

	double mv = [dpy centimetersToScreenUnits:0.1f];
	double mh = [dpy centimetersToScreenUnits:0.2f];
	
	[g setMarginLeft:mh top:mv right:mh bottom:mv];
	[g setSpacing:[dpy centimetersToScreenUnits:0.1f]];
	
	return self;
}

- (void)setupForTrack:(Track *)trk
{
	// The date format is buggy
	
	NSString * sDate = [trk.endDate stringByReplacingOccurrencesOfString:@"000Z" withString:@""];
	
	NSDate * dt = [m_pFormatter dateFromString:sDate];
	if(!dt)
	{
		dt = [NSDate dateFromString:sDate withFormat:DateTimeFormatISO8601DateTime];
		if(!dt)
			dt = [NSDate dateFromAnyFormatString:sDate withDefault:nil];
	}
	
	m_pDateLabel.text = dt ? [dt stringWithFormat:DateTimeFormatVisibleDateTime] : @"?";

	m_pDistanceLabel.text = trk.isValid ?
		[NSString stringWithFormat:@"%.1f km",trk.lengthMeters / 1000.0] :
		__trCtx(@"Invalid Track",@"TrackTableCell");
	
	m_pDistanceLabel.textColor = trk.isValid ? [UIColor blackColor] : [UIColor redColor];
	
	int totalSecs = (int)(trk.durationMinutes * 60.0);
	int h = totalSecs / 3600;
	int m = (totalSecs % 3600) / 60;
	int s = totalSecs % 60;
	
	m_pDurationLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d",h,m,s];
	
	m_pImageView.image = [UIImage imageNamed:@"track_stats"];

	m_pTimeView.image = [UIImage imageNamed:@"track_stats_time"];
	m_pTimeView.alpha = 0.7;

	m_pErrorView.image = trk.isValid ? nil : [UIImage imageNamed:@"track_stats_error"];
	//m_pErrorView.backgroundColor = [UIColor blueColor];

	int i = VEHICLE_VIEWS - 1;
	
	for(NSString * sV in trk.vehicleTypes)
	{
		UIImage * img = [UIImage imageNamed:[NSString stringWithFormat:@"track_stats_%@",sV]];
		m_pVehicleView[i].image = img ? img : [UIImage imageNamed:@"track_stats_car"];
		i--;
		if(i < 0)
			break;
	}
	while(i >= 0)
	{
		m_pVehicleView[i].image = nil;
		i--;
	}
	
}

/*
 
 - (int)id;
 - (void)setId:(int)iId;
 - (NSString *)url;
 - (void)setUrl:(NSString *)sUrl;
 - (long)sessionId;
 - (void)setSessionId:(long)iSessionId;
 - (NSString *)owner;
 - (void)setOwner:(NSString *)sOwner;
 - (NSString *)startDate;
 - (void)setStartDate:(NSString *)sStartDate;
 - (NSString *)endDate;
 - (void)setEndDate:(NSString *)sEndDate;
 - (double)durationMinutes;
 - (void)setDurationMinutes:(double)dDurationMinutes;
 - (double)lengthMeters;
 - (void)setLengthMeters:(double)dLengthMeters;
 - (NSMutableArray<NSString *> *)vehicleTypes;
 - (void)setVehicleTypes:(NSMutableArray<NSString *> *)lVehicleTypes;
 - (bool)isValid;
 - (void)setIsValid:(bool)bIsValid;
 - (NSString *)validationError;
 - (void)setValidationError:(NSString *)sValidationError;
 - (Emissions *)emissions;
 - (void)setEmissions:(Emissions *)oEmissions;
 - (HealthBenefits *)health;
 - (void)setHealth:(HealthBenefits *)oHealth;
 - (Costs *)costs;
 - (void)setCosts:(Costs *)oCosts;
 - (NSMutableArray<Segment *> *)segments;
 - (void)setSegments:(NSMutableArray<Segment *> *)lSegments;

 
 */

@end
