//
//  GeoJSONMultiPoint.m
//  
//
//  Created by Szymon Tomasz Stefanek on 2/24/17.
//  Copyright © 2017 Szymon Tomasz Stefanek. All rights reserved.
//

#import "STSGeoJSONMultiPoint.h"

@implementation STSGeoJSONMultiPoint

- (STSGeoJSONObjectType)type
{
	return STSGeoJSONObjectTypeMultiPoint;
}

- (BOOL)decodeCoordinates:(NSArray *)pJSONArray
{
	if(!pJSONArray)
		return false;
	_points = [NSMutableArray new];
	for(id obj in pJSONArray)
	{
		if(![obj isKindOfClass:[NSArray class]])
			return false;
		STSGeoJSONPoint * p = [STSGeoJSONPoint new];
		if(![p decodeCoordinates:(NSArray *)obj])
			return false;
		[_points addObject:p];
	}
	return true;
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
	
	for(STSGeoJSONPoint * c in _points)
	{
		double la = c.coordinates.latitude;
		double lo = c.coordinates.longitude;
		
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
