//
//  BackendRequestGetMyBadges.h
//  SaveMyBike
//
//  Created by Szymon Tomasz Stefanek on 06/07/2019.
//  Copyright © 2019 GeoSolutions SaS. All rights reserved.
//

#import "BackendPagedRequest.h"

#import "Badge.h"

@interface BackendRequestGetMyBadges : BackendPagedRequest

@property(nonatomic) NSMutableArray<Badge *> * badges;

@end

