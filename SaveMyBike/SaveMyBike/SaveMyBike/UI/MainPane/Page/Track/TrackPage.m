//
//  TrackPage.m
//  SaveMyBike
//
//  Created by Szymon Tomasz Stefanek on 20/08/2019.
//  Copyright © 2019 GeoSolutions SaS. All rights reserved.
//

#import "TrackPage.h"

#import "Track.h"

#import "MapDisplay.h"
#import "STSDisplay.h"

#import "TrackDetailsView.h"

#import "STSCore.h"

#import "STSGeoJSONObject.h"
#import "STSGeoJSONLineString.h"
#import "STSGeoJSONMultiLineString.h"
#import "STSLatLongBoundingBox.h"

@interface TrackPage()<UIGestureRecognizerDelegate>
{
	Track * m_pTrack;
	
	MapDisplay * m_pDisplay;
	
	TrackDetailsView * m_pDetailsView;

	CGFloat m_dDetailsViewHeight;
	CGFloat m_dDetailsViewMinimumHeight;
	CGFloat m_dInitialDetailsViewVisibleHeight;
	CGFloat m_dDetailsViewVisibleHeight;

	UIPanGestureRecognizer * m_pVerticalSwipeRecognizer;
}

@end

@implementation TrackPage

- (id)initWithTrack:(Track *)pTrack
{
	self = [super init];
	if(!self)
		return nil;
	
	self.actionBarMode = STSPageStackActionBarModeOverlappingView;
	self.actionBarCenterView = nil;
	self.actionBarBackgroundColor = [UIColor clearColor];
	
	STSDisplay * dpy = [STSDisplay instance];
	
	m_pDisplay = [MapDisplay new];
	[self addView:m_pDisplay row:0 column:0];

	m_pDetailsView = [TrackDetailsView new];
	[self addSubview:m_pDetailsView];
	
	m_pVerticalSwipeRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(_onVerticalPanGesture:)];
	m_pVerticalSwipeRecognizer.delegate = self;
	[self addGestureRecognizer:m_pVerticalSwipeRecognizer];
	
	m_dDetailsViewHeight = [dpy majorScreenDimensionFractionToScreenUnits:0.9];
	m_dDetailsViewMinimumHeight = m_pDetailsView.headerHeight;
	if(m_dDetailsViewMinimumHeight < [dpy centimetersToScreenUnits:1.5])
		m_dDetailsViewMinimumHeight = [dpy centimetersToScreenUnits:1.5];

	m_dDetailsViewVisibleHeight = m_dDetailsViewMinimumHeight;
	

	m_pTrack = pTrack;
	
	[self setupMap];
	
	[m_pDetailsView setupForTrack:m_pTrack];
	
	return self;
}

- (void)setupMap
{
	if(!m_pTrack.segments)
		return;
	
	STSLatLongBoundingBox * box = nil;
	
	for(Segment * s in m_pTrack.segments)
	{
		if(!s.geom)
			continue;
		if(s.geom.length < 1)
			continue;
		STSGeoJSONObject * ob = [STSGeoJSONObject decodeJSONString:s.geom];
		if(!ob)
			continue;
		[self createPath:ob];
		if(!box)
			box = ob.boundingBox;
		else
			[box extend:ob.boundingBox];
	}
	
	if(box)
		[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(onAnimateToBox:) userInfo:box repeats:false];
	
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
	CGPoint pnt = [r translationInView:self];
	CGPoint loc = [r locationInView:self];
	STS_CORE_LOG(@"TRN(%f,%f) LOC(%f,%f)",pnt.x,pnt.y,loc.x,loc.y);
	
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
	
	const CGPoint pnt = [m_pVerticalSwipeRecognizer locationInView:self];
	const CGPoint velocity = [m_pVerticalSwipeRecognizer velocityInView:self];
	
	STS_CORE_LOG(@"Pnt(%f,%f) Vel(%f,%f)",pnt.x,pnt.y,velocity.x,velocity.y);
	
	if(pnt.y < (self.frame.size.height - m_dDetailsViewVisibleHeight - m_dDetailsViewHeight))
		return NO;
	
	if(fabsf((float)velocity.y) < fabsf((float)velocity.x)) // not vertical
		return NO;
	
	return YES;
}


@end
