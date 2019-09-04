//
//  GeoJSONObject.h
//  
//
//  Created by Szymon Tomasz Stefanek on 2/24/17.
//  Copyright © 2017 Szymon Tomasz Stefanek. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "STSLatLongBoundingBox.h"

typedef enum _STSGeoJSONObjectType
{
	STSGeoJSONObjectTypePoint,
	STSGeoJSONObjectTypeLineString,
	STSGeoJSONObjectTypePolygon,
	STSGeoJSONObjectTypeMultiPoint,
	STSGeoJSONObjectTypeMultiLineString,
	STSGeoJSONObjectTypeMultiPolygon
} STSGeoJSONObjectType;

@interface STSGeoJSONObject : NSObject

- (STSGeoJSONObjectType)type;
- (BOOL)decodeCoordinates:(NSArray *)pJSONArray;
- (STSLatLongBoundingBox *)boundingBox;
+ (STSGeoJSONObject *)decodeJSONObject:(id)oObject;
+ (STSGeoJSONObject *)decodeJSONString:(NSString *)sJSON;


@end
