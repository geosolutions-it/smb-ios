//
//  GeoJSONObject.m
//  
//
//  Created by Szymon Tomasz Stefanek on 2/24/17.
//  Copyright © 2017 Szymon Tomasz Stefanek. All rights reserved.
//

#import "STSGeoJSONObject.h"

#import "STSGeoJSONPoint.h"
#import "STSGeoJSONLineString.h"
#import "STSGeoJSONPolygon.h"
#import "STSGeoJSONMultiPoint.h"
#import "STSGeoJSONMultiLineString.h"
#import "STSGeoJSONMultiPolygon.h"

#import "STSTypeConversion.h"
#import "NSString+Manipulation.h"
#import "NSObject+STSJSON.h"

@implementation STSGeoJSONObject

- (STSGeoJSONObjectType)type
{
	return STSGeoJSONObjectTypePoint;
}

- (BOOL)decodeCoordinates:(NSArray *)pJSONArray;
{
	return false;
}

- (STSLatLongBoundingBox *)boundingBox
{
	return nil;
}

+ (STSGeoJSONObject *)decodeJSONObject:(id)oObject
{
	if(!oObject)
		return nil;
	if(![oObject isKindOfClass:[NSDictionary class]])
		return nil;
	NSDictionary * d = (NSDictionary *)oObject;
	
	NSString * szType = [STSTypeConversion objectInDictionaryToString:d key:@"type" defaultValue:nil];
	if([NSString isNullOrEmpty:szType])
		return nil;
	
	NSArray * coords = [STSTypeConversion objectInDictionaryToArray:d key:@"coordinates" defaultValue:nil];
	if(!coords)
		return nil;
	
	STSGeoJSONObject * ob = nil;
	if([szType isEqualToString:@"Point"])
		ob = [STSGeoJSONPoint new];
	else if([szType isEqualToString:@"LineString"])
		ob = [STSGeoJSONLineString new];
	else if([szType isEqualToString:@"Polygon"])
		ob = [STSGeoJSONPolygon new];
	else if([szType isEqualToString:@"MultiPoint"])
		ob = [STSGeoJSONMultiPoint new];
	else if([szType isEqualToString:@"MultiLineString"])
		ob = [STSGeoJSONMultiLineString new];
	else if([szType isEqualToString:@"MultiPolygon"])
		ob = [STSGeoJSONMultiPolygon new];
	else
		return nil;
	
	if(![ob decodeCoordinates:coords])
		return nil;
	
	return ob;
}

+ (STSGeoJSONObject *)decodeJSONString:(NSString *)sJSON
{
	id ob = [sJSON JSONValue];
	if(!ob)
		return nil;
	return [STSGeoJSONObject decodeJSONObject:ob];
}

@end
