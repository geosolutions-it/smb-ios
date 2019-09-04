//
//  BackendRequestGetMyBikes.h
//  SaveMyBike
//
//  Created by Szymon Tomasz Stefanek on 06/07/2019.
//  Copyright © 2019 GeoSolutions SaS. All rights reserved.
//

#import "BackendPagedRequest.h"

#import "Bike.h"

@interface BackendRequestGetMyBikes : BackendPagedRequest

@property(nonatomic) NSString * shortUUID;

@property(nonatomic) NSMutableArray<Bike *> * bikes;

@end

