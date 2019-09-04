//
//  BackendRequestUpdateDevice.h
//  SaveMyBike
//
//  Created by Szymon Tomasz Stefanek on 02/09/2019.
//  Copyright © 2019 GeoSolutions SaS. All rights reserved.
//

#import "BackendRequest.h"

#import "Device.h"

@interface BackendRequestUpdateDevice : BackendRequest

@property(nonatomic,strong) Device * device;

@end

