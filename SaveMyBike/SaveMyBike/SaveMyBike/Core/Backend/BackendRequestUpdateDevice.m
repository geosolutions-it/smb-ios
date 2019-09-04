//
//  BackendRequestUpdateDevice.m
//  SaveMyBike
//
//  Created by Szymon Tomasz Stefanek on 02/09/2019.
//  Copyright © 2019 GeoSolutions SaS. All rights reserved.
//

#import "BackendRequestUpdateDevice.h"

#import "Config.h"

@implementation BackendRequestUpdateDevice

- (bool)start:(bool)bTriggerErrorInCaseOfFailure
{
	NSData * oData = [_device encodeToJSONData];
	
	self.URL = [NSString stringWithFormat:@"%@/api/my-devices/",[Config instance].serverURL];
	self.method = @"POST";
	self.captureOutputInCaseOfError = true;
	
	[self addHeader:@"Content-Type" withValue:@"application/json"];
	[self setBody:oData];
	
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
