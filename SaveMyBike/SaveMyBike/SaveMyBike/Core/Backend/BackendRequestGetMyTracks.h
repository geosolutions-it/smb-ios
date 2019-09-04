//
//  BackendRequestGetMyTracks.h
//  SaveMyBike
//
//  Created by Szymon Tomasz Stefanek on 06/07/2019.
//  Copyright © 2019 GeoSolutions SaS. All rights reserved.
//
#import "BackendPagedRequest.h"

#import "Track.h"

@interface BackendRequestGetMyTracks : BackendPagedRequest

@property(nonatomic) NSMutableArray<Track *> * tracks;

@end

