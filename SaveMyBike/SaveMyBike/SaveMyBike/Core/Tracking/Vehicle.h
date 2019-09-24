//
//  Vehicle.h
//  SaveMyBike
//
//  Created by Pragma on 23/09/2019.
//  Copyright © 2019 STS. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "VehicleType.h"

@interface Vehicle : NSObject

+ (double)minimumGPSDistanceForVehicleType:(VehicleType)eType;
+ (long)minimumGPSTimeForVehicleType:(VehicleType)eType; // msecs

@end

