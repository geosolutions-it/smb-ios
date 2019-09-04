//
//  BackendRequestGetMyDevices.m
//  SaveMyBike
//
//  Created by Szymon Tomasz Stefanek on 06/07/2019.
//  Copyright © 2019 GeoSolutions SaS. All rights reserved.
//

#import "BackendRequestGetMyDevices.h"

#import "Config.h"

@implementation BackendRequestGetMyDevices

- (bool)start:(bool)bTriggerErrorInCaseOfFailure
{
	self.URL = [NSString stringWithFormat:@"%@/api/my-devices/?page=%d&page_size=%d",[Config instance].serverURL,self.page,self.page_size];
	self.method = @"GET";
	
	return [super start:bTriggerErrorInCaseOfFailure];
}

- (void)onProcessObject:(id)ob
{
	self.devices = (NSMutableArray<Device *> *)[self decodePagedResult:ob arrayMember:@"results" itemClass:[Device class]];
	if(!self.devices)
		return;
	self.succeeded = true;
}

@end
