//
//  BackendRequestGetMyBikeObservations.m
//  SaveMyBike
//
//  Created by Szymon Tomasz Stefanek on 06/07/2019.
//  Copyright © 2019 GeoSolutions SaS. All rights reserved.
//

#import "BackendRequestGetMyBikeObservations.h"

#import "Config.h"

@implementation BackendRequestGetMyBikeObservations

- (bool)start:(bool)bTriggerErrorInCaseOfFailure
{
	self.URL = [NSString stringWithFormat:@"%@/api/my-bike-observations/?bike=%@&page=%d&page_size=%d",[Config instance].serverURL,self.bike,self.page,self.page_size];
	self.method = @"GET";
	
	return [super start:bTriggerErrorInCaseOfFailure];
}

- (void)onProcessObject:(id)ob
{
	self.bikeObservations = (NSMutableArray<BikeObservation *> *)[self decodePagedResult:ob arrayMember:@"features" itemClass:[BikeObservation class]];
	if(!self.bikeObservations)
		return;
	self.succeeded = true;
}

@end
