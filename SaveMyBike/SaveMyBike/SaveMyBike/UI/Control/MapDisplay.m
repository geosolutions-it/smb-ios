//
//  MapDisplay.m
//  SaveMyBike
//
//  Created by Szymon Tomasz Stefanek on 20/08/2019.
//  Copyright © 2019 GeoSolutions SaS. All rights reserved.
//

#import "MapDisplay.h"

#import <GoogleMaps/GoogleMaps.h>

#import "STSGeoCoordinate.h"
#import "STSLatLongBoundingBox.h"

#import "STSGeoJSONObject.h"
#import "STSGeoCoordinate.h"

@implementation MapDisplay
{
	GMSMapView * m_pMapView;
	
	NSMutableArray<GMSOverlay *> * m_pOverlays;
}

- (id)init
{
	self = [super init];
	if(!self)
		return nil;
	
	m_pOverlays = [NSMutableArray new];
	
	GMSCameraPosition * c = [GMSCameraPosition cameraWithLatitude:43.3182200 longitude:11.3306400 zoom:10];
	
	m_pMapView = [GMSMapView mapWithFrame:CGRectZero camera:c];
	
	[self addView:m_pMapView row:0 column:0];
	
	return self;
}

- (void)removeAllOverlays
{
	for(GMSOverlay * o in m_pOverlays)
		o.map = nil;
	[m_pOverlays removeAllObjects];
}

- (void)addMarkerWithLatitude:(double)lat longitude:(double)lon title:(NSString *)szTitle andDescription:(NSString *)szDescription
{
	GMSMarker * m = [GMSMarker markerWithPosition:CLLocationCoordinate2DMake(lat,lon)];
	
	m.title = szTitle;
	m.snippet = szDescription;
	
	m.map = m_pMapView;
	
	[m_pOverlays addObject:m];
}

- (void)animateToLatitude:(double)lat longitude:(double)lon zoom:(double)z
{
	GMSCameraPosition * c = [GMSCameraPosition cameraWithLatitude:lat longitude:lon zoom:z];
	
	m_pMapView.camera = c;
}

- (void)animateTo:(GMSCoordinateBounds *)bnds
{
	GMSCameraPosition * c = [m_pMapView cameraForBounds:bnds insets:UIEdgeInsetsMake(20, 20, 20, 20)];
	
	m_pMapView.camera = c;
	
	//GMSCameraUpdate * up = [GMSCameraUpdate fitBounds:bnds withPadding:20.0];
	
	//[m_pMapView animateWithCameraUpdate:up];
}

- (void)animateToBoundingBox:(STSLatLongBoundingBox *)box
{
	GMSCoordinateBounds * bnds = [[GMSCoordinateBounds alloc] initWithCoordinate:CLLocationCoordinate2DMake(box.north,box.east) coordinate:CLLocationCoordinate2DMake(box.south,box.west)];
	[self animateTo:bnds];
}


- (void)createPathForPoints:(NSMutableArray<STSGeoCoordinate *> *)coords
{
	GMSMutablePath * mp = [GMSMutablePath new];

	for(STSGeoCoordinate * c in coords)
	{
		[mp addCoordinate:CLLocationCoordinate2DMake(c.latitude,c.longitude)];
	}
	
	GMSPolyline * pl = [GMSPolyline polylineWithPath:mp];
	pl.strokeColor = [UIColor blueColor];
	pl.strokeWidth = 2.0;
	pl.map = m_pMapView;

	[m_pOverlays addObject:pl];
}



@end
