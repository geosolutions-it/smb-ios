//
//  STSGeoCoordinate.m
//
//  Created by Szymon Tomasz Stefanek
//  Copyright © 2017 Szymon Tomasz Stefanek. All rights reserved.
//

#import "STSGeoCoordinate.h"
#import <CoreLocation/CoreLocation.h>
#import "STSTypeConversion.h"

@implementation STSGeoCoordinate

+ (STSGeoCoordinate *)coordinateFromLocationCoordinate:(CLLocation *)pLocation
{
	if(!pLocation)
		return nil;

	CLLocationCoordinate2D rCoordinate = [pLocation coordinate];
	if(!CLLocationCoordinate2DIsValid(rCoordinate))
		return nil;

	return [STSGeoCoordinate coordinateWithLatitude:rCoordinate.latitude longitude:rCoordinate.longitude];
}

+ (STSGeoCoordinate *)coordinateWithLatitude:(double)dLatitude longitude:(double)dLongitude
{
	STSGeoCoordinate *pCoord = [STSGeoCoordinate new];
	pCoord.latitude = dLatitude;
	pCoord.longitude = dLongitude;

	return pCoord;
}

+ (STSGeoCoordinate *)coordinateFromLongLatJSONArray:(NSArray *)pArray
{
	if(!pArray)
		return nil;
	if(pArray.count < 2)
		return nil;
	double longitude = [STSTypeConversion objectToDouble:[pArray objectAtIndex:0] withDefault:-1000.0];
	if(longitude < -900.0)
		return nil;
	double latitude = [STSTypeConversion objectToDouble:[pArray objectAtIndex:1] withDefault:-1000.0];
	if(latitude < -900.0)
		return nil;
	STSGeoCoordinate * c = [STSGeoCoordinate new];
	c.longitude = longitude;
	c.latitude = latitude;
	return c;
}

+ (NSMutableArray<STSGeoCoordinate *> *)coordinateListFromLongLatJSONArray:(NSArray *)pArray
{
	if(!pArray)
		return nil;
	NSMutableArray<STSGeoCoordinate *> * r = [NSMutableArray new];
	for(id obj in pArray)
	{
		if(![obj isKindOfClass:[NSArray class]])
			return nil;
		STSGeoCoordinate * c = [STSGeoCoordinate coordinateFromLongLatJSONArray:(NSArray *)obj];
		if(c)
			[r addObject:c];
	}
	return r;
}

- (double)distanceFromCoordinate:(STSGeoCoordinate *)pCoordinate
{
	if(!pCoordinate)
		return 0;

	CLLocation *pLocA = [[CLLocation alloc] initWithLatitude:self.latitude longitude:self.longitude];
	CLLocation *pLocB = [[CLLocation alloc] initWithLatitude:pCoordinate.latitude longitude:pCoordinate.longitude];

	return [pLocA distanceFromLocation:pLocB];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"STSGeoCoordinate: { latitude: %f, longitude: %f }",
			self.latitude,
			self.longitude];
}

+ (NSString *)formatApproximateDistance:(double)dDistanceInMeters
{
	if(dDistanceInMeters < 1.0)
		return @"0 m";
	if(dDistanceInMeters < 10.0)
		return [NSString stringWithFormat:@"%.0f m",dDistanceInMeters];
	if(dDistanceInMeters < 100.0)
		return [NSString stringWithFormat:@"%.0f m",round(dDistanceInMeters / 5.0) * 5.0];
	if(dDistanceInMeters < 1000.0)
		return [NSString stringWithFormat:@"%.0f m",round(dDistanceInMeters / 10.0) * 10.0];
	if(dDistanceInMeters < 10000.0)
		return [NSString stringWithFormat:@"%.1f km",dDistanceInMeters / 1000.0];
	return [NSString stringWithFormat:@"%.0f km",dDistanceInMeters / 1000.0];
}


@end
