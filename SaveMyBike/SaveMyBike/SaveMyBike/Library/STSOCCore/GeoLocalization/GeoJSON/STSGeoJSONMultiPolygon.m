//
//  STSGeoJSONMultiPolygon.m
//  
//
//  Created by Szymon Tomasz Stefanek on 2/24/17.
//  Copyright © 2017 Szymon Tomasz Stefanek. All rights reserved.
//

#import "STSGeoJSONMultiPolygon.h"

@implementation STSGeoJSONMultiPolygon

- (STSGeoJSONObjectType)type
{
	return STSGeoJSONObjectTypeMultiPolygon;
}

- (BOOL)decodeCoordinates:(NSArray *)pJSONArray
{
	if(!pJSONArray)
		return false;
	_polygons = [NSMutableArray new];
	for(id obj in pJSONArray)
	{
		if(![obj isKindOfClass:[NSArray class]])
			return false;
		STSGeoJSONPolygon* s = [STSGeoJSONPolygon new];
		if(![s decodeCoordinates:(NSArray *)obj])
			return false;
		[_polygons addObject:s];
	}
	return true;
}

- (STSLatLongBoundingBox *)boundingBox
{
	if(!_polygons)
		return nil;
	if(_polygons.count < 1)
		return nil;
	
	STSLatLongBoundingBox * bb = nil;
	for(STSGeoJSONPolygon * s in _polygons)
	{
		STSLatLongBoundingBox * bb2 = [s boundingBox];
		if(bb == nil)
			bb = bb2;
		else
			[bb extend:bb2];
	}
	
	return bb;
}

@end
