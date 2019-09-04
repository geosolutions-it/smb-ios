//
//  GeoJSONPoint.m
//  
//
//  Created by Szymon Tomasz Stefanek on 2/24/17.
//  Copyright © 2017 Szymon Tomasz Stefanek. All rights reserved.
//

#import "STSGeoJSONPoint.h"

@implementation STSGeoJSONPoint

- (STSGeoJSONObjectType)type
{
	return STSGeoJSONObjectTypePoint;
}

- (BOOL)decodeCoordinates:(NSArray *)pJSONArray
{
	if(!pJSONArray)
		return false;
	_coordinates = [STSGeoCoordinate coordinateFromLongLatJSONArray:pJSONArray];
	return _coordinates != nil;
}

- (STSLatLongBoundingBox *)boundingBox
{
	if(!_coordinates)
		return nil;
	return [[STSLatLongBoundingBox alloc] initWithNorth:_coordinates.latitude east:_coordinates.longitude south:_coordinates.latitude west:_coordinates.longitude];
}

@end
