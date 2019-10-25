//
//  BackendRequestSetBikeStatus.h
//  SaveMyBike
//
//  Created by Pragma on 25/10/2019.
//  Copyright © 2019 STS. All rights reserved.
//

#import "BackendRequest.h"

@interface BackendRequestSetBikeStatus : BackendRequest

@property(nonatomic) bool lost;
@property(nonatomic) NSString * url;
@property(nonatomic) NSString * details;
@property(nonatomic) NSString * bikeUUID;
@property(nonatomic) NSString * position;

@end
