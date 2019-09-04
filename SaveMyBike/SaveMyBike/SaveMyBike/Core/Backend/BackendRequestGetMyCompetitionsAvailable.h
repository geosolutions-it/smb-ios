//
//  BackendRequestGetMyCompetitionsAvailable.h
//  SaveMyBike
//
//  Created by Szymon Tomasz Stefanek on 06/08/2019.
//  Copyright © 2019 GeoSolutions SaS. All rights reserved.
//

#import "BackendPagedRequest.h"

#import "Competition.h"

@interface BackendRequestGetMyCompetitionsAvailable : BackendPagedRequest

@property(nonatomic) NSMutableArray<Competition *> * competitions;

@end

