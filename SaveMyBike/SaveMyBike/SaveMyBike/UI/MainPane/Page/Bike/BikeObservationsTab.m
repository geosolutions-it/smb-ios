//
//  BikeObservationsTab.m
//  SaveMyBike
//
//  Created by Szymon Tomasz Stefanek on 28/08/2019.
//  Copyright © 2019 GeoSolutions SaS. All rights reserved.
//

#import "BikeObservationsTab.h"
#import "BikeObservationsList.h"
#import "Bike.h"
#import "BikeObservation.h"
#import "BikeObservationProperties.h"

#import "MapDisplay.h"
#import "STSDisplay.h"

#import "STSCore.h"
#import "STSLabel.h"

#import "STSI18n.h"

#import "STSGeoJSONObject.h"
#import "STSGeoJSONPoint.h"
#import "STSGeoJSONLineString.h"
#import "STSGeoJSONMultiLineString.h"
#import "STSLatLongBoundingBox.h"

#import "LargeIconAndTwoTextsView.h"

#import "NSDate+Format.h"

@interface BikeObservationsTab()<UIGestureRecognizerDelegate>
{
	Bike * m_pBike;
	
	MapDisplay * m_pDisplay;
	
	STSGridLayoutView * m_pDetailsView;
	
	BikeObservationsList * m_pList;
	
	CGFloat m_dDetailsViewHeight;
	CGFloat m_dDetailsViewMinimumHeight;
	CGFloat m_dInitialDetailsViewVisibleHeight;
	CGFloat m_dDetailsViewVisibleHeight;
	
	UIPanGestureRecognizer * m_pVerticalSwipeRecognizer;
	
	BikeObservation * m_pCurrentObservation;
	
	NSDateFormatter * m_pFormatter;
	
	bool m_bGotObservations;
	
	LargeIconAndTwoTextsView * m_pNoObservationsView;
}

@end

@implementation BikeObservationsTab

- (id)initWithBike:(Bike *)pBike
{
	self = [super init];
	if(!self)
		return nil;
	
	m_pBike = pBike;

	STSDisplay * dpy = [STSDisplay instance];
	
	m_pFormatter = [NSDateFormatter new];
	[m_pFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
	[m_pFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];

	m_pDisplay = [MapDisplay new];
	[self addView:m_pDisplay row:0 column:0];
	
	m_pDetailsView = [self _createDetailsView];
	
	[self addSubview:m_pDetailsView];
	
	m_pVerticalSwipeRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(_onVerticalPanGesture:)];
	m_pVerticalSwipeRecognizer.delegate = self;
	[self addGestureRecognizer:m_pVerticalSwipeRecognizer];
	
	m_dDetailsViewHeight = [dpy majorScreenDimensionFractionToScreenUnits:0.6];
	m_dDetailsViewMinimumHeight = [dpy centimetersToScreenUnits:1.5];
	m_dDetailsViewVisibleHeight = m_dDetailsViewMinimumHeight;
	
	[self setupMap];
	
	m_pNoObservationsView = nil;
	
	return self;
}

- (STSGridLayoutView *)_createDetailsView
{
	STSGridLayoutView * g = [STSGridLayoutView new];
	
	g.backgroundColor = [UIColor whiteColor];
	
	STSDisplay * dpy = [STSDisplay instance];
	
	STSLabel * l = [STSLabel new];

	l.font = [UIFont boldSystemFontOfSize:[dpy centimetersToFontUnits:0.3]];
	l.textAlignment = NSTextAlignmentCenter;
	l.text = __trCtx(@"OBSERVATIONS",@"BikeObservationsTab");

	[g addView:l row:0 column:0 verticalSizePolicy:STSSizePolicyFixed horizontalSizePolicy:STSSizePolicyIgnore];
	
	[g setRow:0 minimumHeight:[dpy centimetersToScreenUnits:1.5]];
	
	[self _createSeparator:g row:1 col:0 colSpan:1];
	
	m_pList = [[BikeObservationsList alloc] initWithBike:m_pBike andObservationTab:self];
	
	[g addView:m_pList row:2 column:0];
	
	[g setRow:2 expandWeight:1000.0];
	
	[g setMargin:[dpy centimetersToScreenUnits:0.1]];
	[g setSpacing:[dpy centimetersToScreenUnits:0.1]];
	
	return g;
}

- (void)setObservationCount:(int)iCount
{
	m_bGotObservations = iCount;
	
	if(iCount < 1)
	{
		m_pNoObservationsView = [m_pList onCreateNothingHereYetView];
		[self addSubview:m_pNoObservationsView];
	} else {
	}
	
	[self setNeedsLayout];
}

- (void)_createSeparator:(STSGridLayoutView *)g row:(int)r col:(int)c colSpan:(int)cs
{
	UIView * v = [UIView new];
	v.backgroundColor = [UIColor lightGrayColor];
	
	[g addView:v row:r column:c rowSpan:1 columnSpan:cs verticalSizePolicy:STSSizePolicyIgnore horizontalSizePolicy:STSSizePolicyIgnore];
	[g setRow:r fixedHeight:1];
}

- (void)setCurrentObservation:(BikeObservation *)o
{
	m_pCurrentObservation = o;
	
	[m_pDisplay removeAllOverlays];
	
	STSGeoJSONObject * ob = [STSGeoJSONObject decodeJSONString:o.geometry];
	if(ob && (ob.type == STSGeoJSONObjectTypePoint))
	{
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
		
		NSString * txt = [NSString
				stringWithFormat:__trCtx(@"Observed At: %@\nAddress: %@\nReporter Name: %@\nReporter Type: %@\nDetails: %@",@"BikeObservationsTab"),
				(dt ? [dt stringWithFormat:DateTimeFormatVisibleDateTime] : @"?"),
				props.address ? props.address : @"",
				props.reporterName ? props.reporterName : @"",
				props.reporterType ? props.reporterType : @"",
				props.details ? props.details : @""
			];
		
		STSGeoJSONPoint * pnt = (STSGeoJSONPoint *)ob;
		[m_pDisplay
			addMarkerWithLatitude:pnt.coordinates.latitude
		 		longitude:pnt.coordinates.longitude
		 		title:m_pBike.nickname
		 		andDescription:txt
		 ];
		
		[m_pDisplay animateToLatitude:pnt.coordinates.latitude longitude:pnt.coordinates.longitude zoom:12];
	}
}


- (void)setupMap
{

}

- (void)onAnimateToBox:(NSTimer *)tim
{
	STSLatLongBoundingBox * box = (STSLatLongBoundingBox *)tim.userInfo;
	if(!box)
		return;
	
	[m_pDisplay animateToBoundingBox:box];
}

- (void)createPath:(STSGeoJSONObject *)ob
{
	switch(ob.type)
	{
		case STSGeoJSONObjectTypePoint:
		case STSGeoJSONObjectTypeMultiPoint:
		case STSGeoJSONObjectTypeMultiPolygon:
		case STSGeoJSONObjectTypePolygon:
			// not used
			break;
		case STSGeoJSONObjectTypeLineString:
		{
			STSGeoJSONLineString * ls = (STSGeoJSONLineString *)ob;
			[m_pDisplay createPathForPoints:ls.points];
		}
			break;
		case STSGeoJSONObjectTypeMultiLineString:
		{
			STSGeoJSONMultiLineString * mls = (STSGeoJSONMultiLineString *)ob;
			for(STSGeoJSONLineString * ls in mls.lineStrings)
				[m_pDisplay createPathForPoints:ls.points];
		}
			break;
	}
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	if(m_pNoObservationsView)
	{
		[self bringSubviewToFront:m_pNoObservationsView];
		m_pNoObservationsView.frame = self.bounds;
		m_pDetailsView.hidden = true;
		m_pDisplay.hidden = true;
		return;
	}
	
	[self bringSubviewToFront:m_pDetailsView];
	
	m_pDetailsView.frame = CGRectMake(0,self.frame.size.height - m_dDetailsViewVisibleHeight,self.frame.size.width,m_dDetailsViewVisibleHeight);
}

- (void)openDetailsViewWithVelocity:(CGFloat)fVelocity
{
	CGFloat fDistance = m_dDetailsViewHeight - m_dDetailsViewVisibleHeight;
	NSTimeInterval fDuration = MAX(fDistance/ABS(fVelocity),0.0);
	
	[UIView
	 animateWithDuration:fDuration
	 delay:0
	 options:0
	 animations:^(void){
		 m_dDetailsViewVisibleHeight = m_dDetailsViewHeight;
		 [self layoutSubviews];
	 }
	 completion:nil
	 ];
}

- (void)closeDetailsViewWithVelocity:(CGFloat)fVelocity
{
	CGFloat fDistance = m_dDetailsViewVisibleHeight;
	NSTimeInterval fDuration = MAX(fDistance/ABS(fVelocity),0.0);
	
	[UIView
	 animateWithDuration:fDuration
	 delay:0
	 options:0
	 animations:^(void){
		 m_dDetailsViewVisibleHeight = m_dDetailsViewMinimumHeight;
		 [self layoutSubviews];
	 }
	 completion:nil
	 ];
}

- (void)_onVerticalPanGesture:(UIPanGestureRecognizer *)r
{
	//CGPoint pnt = [r translationInView:self];
	//CGPoint loc = [r locationInView:self];
	//STS_CORE_LOG(@"TRN(%f,%f) LOC(%f,%f)",pnt.x,pnt.y,loc.x,loc.y);
	
	[self.layer removeAllAnimations];
	
	switch(r.state)
	{
		case UIGestureRecognizerStateBegan:
		{
			m_dInitialDetailsViewVisibleHeight = m_dDetailsViewVisibleHeight;
		}
		case UIGestureRecognizerStateChanged:
		{
			m_dDetailsViewVisibleHeight = m_dInitialDetailsViewVisibleHeight - [r translationInView:self].y;
			if(m_dDetailsViewVisibleHeight < m_dDetailsViewMinimumHeight)
				m_dDetailsViewVisibleHeight = m_dDetailsViewMinimumHeight;
			if(m_dDetailsViewVisibleHeight > m_dDetailsViewHeight)
				m_dDetailsViewVisibleHeight = m_dDetailsViewHeight;
			[self layoutSubviews];
			break;
		}
		case UIGestureRecognizerStateEnded:
		case UIGestureRecognizerStateCancelled:
		{
			CGPoint velox = [r velocityInView:self];
			if(velox.y < 0)
				[self openDetailsViewWithVelocity:velox.y];
			else
				[self closeDetailsViewWithVelocity:velox.y];
			break;
		}
		default:
			break;
	}
	
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
	if(gestureRecognizer != m_pVerticalSwipeRecognizer)
		return YES;

	if(!m_bGotObservations)
		return NO;

	const CGPoint pnt = [m_pVerticalSwipeRecognizer locationInView:self];
	const CGPoint velocity = [m_pVerticalSwipeRecognizer velocityInView:self];
	
	//STS_CORE_LOG(@"Pnt(%f,%f) Vel(%f,%f)",pnt.x,pnt.y,velocity.x,velocity.y);
	
	float y1 = self.frame.size.height - m_dDetailsViewVisibleHeight;// - m_dDetailsViewHeight;
	
	if(pnt.y < y1)
		return NO;

	STSDisplay * dpy = [STSDisplay instance];
	
	float y2 = y1 + [dpy centimetersToScreenUnits:1.5];

	if(pnt.y > y2)
		return NO;

	if(fabsf((float)velocity.y) < fabsf((float)velocity.x)) // not vertical
		return NO;
	
	return YES;
}


@end
