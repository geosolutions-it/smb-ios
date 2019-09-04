//
//  BackendRequestGetMyBikes.m
//  SaveMyBike
//
//  Created by Szymon Tomasz Stefanek on 06/07/2019.
//  Copyright © 2019 GeoSolutions SaS. All rights reserved.
//

#import "BackendRequestGetMyBikes.h"

#import "Config.h"

@implementation BackendRequestGetMyBikes

- (bool)start:(bool)bTriggerErrorInCaseOfFailure
{
	self.URL = [NSString stringWithFormat:@"%@/api/my-bikes/?page=%d&page_size=%d",[Config instance].serverURL,self.page,self.page_size];
	self.method = @"GET";
	
	return [super start:bTriggerErrorInCaseOfFailure];
}

- (void)onProcessObject:(id)ob
{
	self.bikes = (NSMutableArray<Bike *> *)[self decodePagedResult:ob arrayMember:@"results" itemClass:[Bike class]];
	if(!self.bikes)
		return;
	self.succeeded = true;
}

@end
