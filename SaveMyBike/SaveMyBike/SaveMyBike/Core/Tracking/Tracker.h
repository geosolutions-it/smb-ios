//
//  Tracker.h
//  SaveMyBike
//
//  Created by Szymon Tomasz Stefanek on 16/07/2019.
//  Copyright © 2019 GeoSolutions SaS. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TrackingSession.h"
#import "VehicleType.h"

typedef enum _TrackerState
{
	TrackerStateRunning,
	TrackerStateError,
	TrackerStateStopped
} TrackerState;

@interface Tracker : NSObject

+ (Tracker *)instance;

+ (void)create;
+ (void)destroy;

@property(nonatomic) TrackingSession * session;
@property(nonatomic) TrackingSessionPoint * currentPoint;
@property(nonatomic) double currentDistance; // m

- (void)setCurrentVehicleType:(VehicleType)eType;

- (TrackingSession *)startTrackingSessionWithVehicleType:(VehicleType)eType;
- (TrackingSession *)stopTrackingSession;

@end

