//
//  BackendRequestGetMyBikeStatuses.h
//  SaveMyBike
//
//  Created by Szymon Tomasz Stefanek on 06/07/2019.
//  Copyright © 2019 GeoSolutions SaS. All rights reserved.
//

#import "BackendPagedRequest.h"

#import "BikeStatus.h"

@interface BackendRequestGetMyBikeStatuses : BackendPagedRequest

@property(nonatomic) NSMutableArray<BikeStatus *> * bikeStatuses;

@end


