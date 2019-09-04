#ifndef __STSGeoLocalizer_h__
#define __STSGeoLocalizer_h__
//==================================================================================
//
//  Created by Szymon Tomasz Stefanek
//  Copyright © 2017 Szymon Tomasz Stefanek. All rights reserved.
//
//==================================================================================

#import <Foundation/Foundation.h>

#import <CoreLocation/CoreLocation.h>

#import "STSGeoCoordinate.h"

@class STSGeoLocalizer;

typedef enum _STSGeoLocalizerState
{
	STSGeoLocalizerStateInactive,
	STSGeoLocalizerStateActivating,
	STSGeoLocalizerStateRequestingPermission,
	STSGeoLocalizerStateActive
} STSGeoLocalizerState;

@protocol STSGeoLocalizerDelegate

- (void)onGeoLocalizer:(STSGeoLocalizer *)l didUpdateLocation:(NSArray<CLLocation *> *)loc;

@end

@interface STSGeoLocalizer : NSObject

// Call create to create the localizer, destroy to destory it.
+ (void)create;
+ (void)destroy;

+ (STSGeoLocalizer *)instance;

// Call "activate" to attempt to activate it.
// It will ask the user for permission and start updating locations.
// Call "deactivate" to stop the process.

- (void)activate;
- (void)deactivate;

- (STSGeoLocalizerState)state;

- (CLLocation *)lastKnownLocation;

- (void)addDelegate:(id<STSGeoLocalizerDelegate>)d;
- (void)removeDelegate:(id<STSGeoLocalizerDelegate>)d;

@end

#endif //!__STSGeoLocalizer_h__
