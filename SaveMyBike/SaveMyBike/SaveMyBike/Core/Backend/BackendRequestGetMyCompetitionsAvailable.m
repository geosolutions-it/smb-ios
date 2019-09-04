//
//  BackendRequestGetMyCompetitionsAvailable.m
//  SaveMyBike
//
//  Created by Szymon Tomasz Stefanek on 01/08/2019.
//  Copyright © 2019 GeoSolutions SaS. All rights reserved.
//

#import "BackendRequestGetMyCompetitionsAvailable.h"

#import "Config.h"

@implementation BackendRequestGetMyCompetitionsAvailable

- (bool)start:(bool)bTriggerErrorInCaseOfFailure
{
	self.URL = [NSString stringWithFormat:@"%@/api/my-competitions-available/?page=%d&page_size=%d",[Config instance].serverURL,self.page,self.page_size];
	self.method = @"GET";
	
	return [super start:bTriggerErrorInCaseOfFailure];
}

- (void)onProcessObject:(id)ob
{
	self.competitions = (NSMutableArray<Competition *> *)[self decodePagedResult:ob arrayMember:@"results" itemClass:[Competition class]];
	if(!self.competitions)
		return;
	self.succeeded = true;
}


@end
