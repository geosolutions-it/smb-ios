//
//  BackendRequestGetMySegments.h
//  SaveMyBike
//
//  Created by Szymon Tomasz Stefanek on 06/07/2019.
//  Copyright © 2019 GeoSolutions SaS. All rights reserved.
//

#import "BackendPagedRequest.h"

#import "SegmentBrief.h"

@interface BackendRequestGetMySegments : BackendPagedRequest

@property(nonatomic) NSMutableArray<SegmentBrief *> * segments;

@end

