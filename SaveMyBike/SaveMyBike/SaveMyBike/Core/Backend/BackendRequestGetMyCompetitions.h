//
//  BackendRequestGetMyCurrentCompetitions.h
//  SaveMyBike
//
//  Created by Szymon Tomasz Stefanek on 06/07/2019.
//  Copyright © 2019 GeoSolutions SaS. All rights reserved.
//

#import "BackendPagedRequest.h"

#import "CompetitionParticipation.h"

@interface BackendRequestGetMyCompetitions : BackendPagedRequest

@property(nonatomic) NSMutableArray<CompetitionParticipation *> * competitions;

- (id)initWithUrlPart:(NSString *)sURLPart;


@end

