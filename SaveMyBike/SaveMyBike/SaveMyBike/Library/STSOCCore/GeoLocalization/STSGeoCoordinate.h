//
//  STSGeoCoordinate.h
//
//  Created by Szymon Tomasz Stefanek
//  Copyright © 2017 Szymon Tomasz Stefanek. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CLLocation;

@interface STSGeoCoordinate : NSObject

@property (nonatomic) double latitude;
@property (nonatomic) double longitude;

+ (STSGeoCoordinate *)coordinateFromLocationCoordinate:(CLLocation *)pLocation;
+ (STSGeoCoordinate *)coordinateWithLatitude:(double)dLatitude longitude:(double)dLongitude;
// INVERTED!
+ (STSGeoCoordinate *)coordinateFromLongLatJSONArray:(NSArray *)pArray;

+ (NSMutableArray<STSGeoCoordinate *> *)coordinateListFromLongLatJSONArray:(NSArray *)pArray;

// This is in meters
- (double)distanceFromCoordinate:(STSGeoCoordinate *)pCoordinate;

+ (NSString *)formatApproximateDistance:(double)dDistanceInMeters;

@end
