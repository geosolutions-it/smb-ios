//
//  BackendRequestGetMyBikeStatuses.m
//  SaveMyBike
//
//  Created by Szymon Tomasz Stefanek on 06/07/2019.
//  Copyright © 2019 GeoSolutions SaS. All rights reserved.
//

#import "BackendRequestGetMyBikeStatuses.h"

#import "Config.h"

@implementation BackendRequestGetMyBikeStatuses

- (bool)start:(bool)bTriggerErrorInCaseOfFailure
{
	self.URL = [NSString stringWithFormat:@"%@/api/my-bike-statuses/?page=%d&page_size=%d",[Config instance].serverURL,self.page,self.page_size];
	self.method = @"GET";
	
	return [super start:bTriggerErrorInCaseOfFailure];
}

- (void)onProcessObject:(id)ob
{
	self.bikeStatuses = (NSMutableArray<BikeStatus *> *)[self decodePagedResult:ob arrayMember:@"results" itemClass:[BikeStatus class]];
	if(!self.bikeStatuses)
		return;
	self.succeeded = true;
}

@end
