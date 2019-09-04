//
//  GeoJSONMultiLineString.m
//  
//
//  Created by Szymon Tomasz Stefanek on 2/24/17.
//  Copyright © 2017 Szymon Tomasz Stefanek. All rights reserved.
//

#import "STSGeoJSONMultiLineString.h"

@implementation STSGeoJSONMultiLineString

- (STSGeoJSONObjectType)type
{
	return STSGeoJSONObjectTypeMultiLineString;
}

- (BOOL)decodeCoordinates:(NSArray *)pJSONArray
{
	if(!pJSONArray)
		return false;
	_lineStrings = [NSMutableArray new];
	for(id obj in pJSONArray)
	{
		if(![obj isKindOfClass:[NSArray class]])
			return false;
		STSGeoJSONLineString * s = [STSGeoJSONLineString new];
		if(![s decodeCoordinates:(NSArray *)obj])
			return false;
		[_lineStrings addObject:s];
	}
	return true;
}

- (STSLatLongBoundingBox *)boundingBox
{
	if(!_lineStrings)
		return nil;
	if(_lineStrings.count < 1)
		return nil;
	
	STSLatLongBoundingBox * bb = nil;
	for(STSGeoJSONLineString * s in _lineStrings)
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
