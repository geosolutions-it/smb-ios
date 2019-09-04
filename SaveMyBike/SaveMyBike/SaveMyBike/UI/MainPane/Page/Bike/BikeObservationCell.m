//
//  BikeObservationCell.m
//  SaveMyBike
//
//  Created by Szymon Tomasz Stefanek on 28/08/2019.
//  Copyright © 2019 GeoSolutions SaS. All rights reserved.
//

#import "BikeObservationCell.h"

#import "STSImageView.h"
#import "STSLabel.h"

#import "STSDisplay.h"

#import "NSDate+Format.h"

#import "BikeObservation.h"
#import "BikeObservationProperties.h"

@interface BikeObservationCell()
{
	STSImageView * m_pImageView;
	
	STSLabel * m_pDateLabel;
	STSLabel * m_pPositionLabel;
	
	NSDateFormatter * m_pFormatter;
}

@end

@implementation BikeObservationCell

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

	m_pImageView = [STSImageView new];
	m_pImageView.contentMode = UIViewContentModeScaleAspectFit;
	
	[g addView:m_pImageView row:0 column:0 rowSpan:2 columnSpan:1 verticalSizePolicy:STSSizePolicyIgnore horizontalSizePolicy:STSSizePolicyIgnore];
	
	m_pDateLabel = [STSLabel new];
	m_pDateLabel.font = [UIFont boldSystemFontOfSize:[dpy centimetersToFontUnits:0.3]];
	[g addView:m_pDateLabel row:0 column:1 rowSpan:1 columnSpan:1 verticalSizePolicy:STSSizePolicyCanExpand horizontalSizePolicy:STSSizePolicyCanExpand];

	m_pPositionLabel = [STSLabel new];
	m_pPositionLabel.font = [UIFont systemFontOfSize:[dpy centimetersToFontUnits:0.25]];
	m_pPositionLabel.text = @"-, -";
	[g addView:m_pPositionLabel row:1 column:1 rowSpan:1 columnSpan:1 verticalSizePolicy:STSSizePolicyCanExpand horizontalSizePolicy:STSSizePolicyCanExpand];
	
	[g setColumn:0 fixedWidth:[dpy centimetersToScreenUnits:1.0]];
	[g setColumn:1 expandWeight:1000.0];
	
	double mv = [dpy centimetersToScreenUnits:0.1f];
	double mh = [dpy centimetersToScreenUnits:0.2f];
	
	[g setMarginLeft:mh top:mv right:mh bottom:mv];
	[g setSpacing:[dpy centimetersToScreenUnits:0.2f]];
	
	return self;
}

- (void)setupForBikeObservation:(BikeObservation *)o
{
	// The date format is buggy
	
	BikeObservationProperties * props = o.properties;
	
	NSString * sObservedAt = props ? props.observedAt : @"";
	
	NSString * sDate = [sObservedAt stringByReplacingOccurrencesOfString:@"000Z" withString:@""];
	
	NSDate * dt = [m_pFormatter dateFromString:sDate];
	if(!dt)
	{
		dt = [NSDate dateFromString:sDate withFormat:DateTimeFormatISO8601DateTime];
		if(!dt)
			dt = [NSDate dateFromAnyFormatString:sDate withDefault:nil];
	}
	
	m_pDateLabel.text = dt ? [dt stringWithFormat:DateTimeFormatVisibleDateTime] : @"?";
	
	if(props)
	{
		m_pPositionLabel.text = props.address;
	} else {
		m_pPositionLabel.text = @"?";
	}
	
	m_pImageView.image = [UIImage imageNamed:@"small_icon_location"];
}


@end
