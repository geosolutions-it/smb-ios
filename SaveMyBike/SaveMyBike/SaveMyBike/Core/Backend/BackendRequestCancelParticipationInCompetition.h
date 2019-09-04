//
//  BackendRequestCancelParticipationInCompetition.h
//  SaveMyBike
//
//  Created by Szymon Tomasz Stefanek on 08/08/2019.
//  Copyright © 2019 GeoSolutions SaS. All rights reserved.
//

#import "BackendRequest.h"


@interface BackendRequestCancelParticipationInCompetition : BackendRequest

@property(nonatomic) int participationId;

@end

