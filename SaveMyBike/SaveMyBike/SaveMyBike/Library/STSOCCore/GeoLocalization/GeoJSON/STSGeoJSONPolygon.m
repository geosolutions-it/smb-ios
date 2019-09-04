//
//  STSGeoJSONPolygon.m
//  
//  Created by Szymon Tomasz Stefanek on 2/24/17.
//  Copyright © 2017 Szymon Tomasz Stefanek. All rights reserved.
//

#import "STSGeoJSONPolygon.h"

@implementation STSGeoJSONPolygon

- (STSGeoJSONObjectType)type
{
	return STSGeoJSONObjectTypePolygon;
}

- (BOOL)decodeCoordinates:(NSArray *)pJSONArray
{
	if(!pJSONArray)
		return false;
	_contour = nil;
	for(id obj in pJSONArray)
	{
		if(![obj isKindOfClass:[NSArray class]])
			return false;
		NSMutableArray<STSGeoCoordinate *> * ll = [STSGeoCoordinate coordinateListFromLongLatJSONArray:(NSArray *)obj];
		if(!ll)
			return false;
		if(_contour == nil)
			_contour = ll;
		else
			[_contour addObjectsFromArray:ll];
	}
	return _contour != nil;
}

- (STSLatLongBoundingBox *)boundingBox
{
	if(!_contour)
		return nil;
	if(_contour.count < 1)
		return nil;
	double n = -999.9;
	double e = 0.0;
	double s = 0.0;
	double w = 0.0;
	
	for(STSGeoCoordinate * c in _contour)
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
