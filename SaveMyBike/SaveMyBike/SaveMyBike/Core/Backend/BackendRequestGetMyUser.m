//
//  BackendRequestMyUser.m
//  SaveMyBike
//
//  Created by Szymon Tomasz Stefanek on 27/06/2019.
//  Copyright © 2019 GeoSolutions SaS. All rights reserved.
//

#import "BackendRequestGetMyUser.h"

#import "Config.h"

@implementation BackendRequestGetMyUser

- (bool)start:(bool)bTriggerErrorInCaseOfFailure
{
	self.URL = [NSString stringWithFormat:@"%@/api/my-user",[Config instance].serverURL];
	self.method = @"GET";

	return [super start:bTriggerErrorInCaseOfFailure];
}

- (void)onProcessObject:(id)ob
{
	self.userData = [self decodeObject:ob intoResult:[UserData new]];
	if(!self.userData)
		return;
	self.succeeded = true;
}

@end
