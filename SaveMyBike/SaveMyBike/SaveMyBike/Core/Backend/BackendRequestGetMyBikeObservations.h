//
//  BackendRequestGetMyBikeObservations.h
//  SaveMyBike
//
//  Created by Szymon Tomasz Stefanek on 06/07/2019.
//  Copyright © 2019 GeoSolutions SaS. All rights reserved.
//

#import "BackendPagedRequest.h"
#import "BikeObservation.h"

@interface BackendRequestGetMyBikeObservations : BackendPagedRequest

@property(nonatomic) NSString * bike;

@property(nonatomic) NSMutableArray<BikeObservation *> * bikeObservations;

@end

