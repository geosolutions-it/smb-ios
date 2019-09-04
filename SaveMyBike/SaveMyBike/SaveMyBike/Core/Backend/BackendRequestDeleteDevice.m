//
//  BackendRequestDeleteDevice.m
//  SaveMyBike
//
//  Created by Szymon Tomasz Stefanek on 02/09/2019.
//  Copyright © 2019 GeoSolutions SaS. All rights reserved.
//

#import "BackendRequestDeleteDevice.h"

#import "Config.h"

@implementation BackendRequestDeleteDevice

- (bool)start:(bool)bTriggerErrorInCaseOfFailure
{
	self.URL = [NSString stringWithFormat:@"%@/api/my-devices/?token=%@",[Config instance].serverURL,self.token];
	self.method = @"DELETE";
	self.captureOutputInCaseOfError = true;
	
	[self addHeader:@"Content-Type" withValue:@"application/json"];
	
	return [super start:bTriggerErrorInCaseOfFailure];
}

- (void)onProcessObject:(id)ob
{
	// assume it succeeded
	//self.competitions = (NSMutableArray<Competition *> *)[self decodePagedResult:ob arrayMember:@"results" itemClass:[Competition class]];
	//if(!self.competitions)
	//	return;
	self.succeeded = self.statusCode < 400;
}

@end
