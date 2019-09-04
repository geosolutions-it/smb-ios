//
//  GeoJSONLineString.m
//  
//
//  Created by Szymon Tomasz Stefanek on 2/24/17.
//  Copyright © 2017 Szymon Tomasz Stefanek. All rights reserved.
//

#import "STSGeoJSONLineString.h"

@implementation STSGeoJSONLineString

- (STSGeoJSONObjectType)type
{
	return STSGeoJSONObjectTypeLineString;
}

- (BOOL)decodeCoordinates:(NSArray *)pJSONArray
{
	if(!pJSONArray)
		return false;
	_points = [STSGeoCoordinate coordinateListFromLongLatJSONArray:pJSONArray];
	return _points != nil;
}

- (STSLatLongBoundingBox *)boundingBox
{
	if(!_points)
		return nil;
	if(_points.count < 1)
		return nil;
	double n = -999.9;
	double e = 0.0;
	double s = 0.0;
	double w = 0.0;
	
	for(STSGeoCoordinate * c in _points)
	{
		double la = c.latitude;
		double lo = c.longitude;
		
		if(n < -999.0)
		{
			n = la;
			e = lo;
			s = n;
			w = e;
		} else {
			if(n < la)
				n = la;
			if(s > la)
				s = la;
			if(e < lo)
				e = lo;
			if(w > lo)
				w = lo;
		}
	}

	return [[STSLatLongBoundingBox alloc] initWithNorth:n east:e south:s west:w];
}

@end
