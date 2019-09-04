//
//  BackendRequestGetMyBadges.m
//  SaveMyBike
//
//  Created by Szymon Tomasz Stefanek on 06/07/2019.
//  Copyright © 2019 GeoSolutions SaS. All rights reserved.
//

#import "BackendRequestGetMyBadges.h"

#import "Config.h"

@implementation BackendRequestGetMyBadges

- (bool)start:(bool)bTriggerErrorInCaseOfFailure
{
	self.URL = [NSString stringWithFormat:@"%@/api/my-badges/?page=%d&page_size=%d",[Config instance].serverURL,self.page,self.page_size];
	self.method = @"GET";
	
	return [super start:bTriggerErrorInCaseOfFailure];
}

- (void)onProcessObject:(id)ob
{
	self.badges = (NSMutableArray<Badge *> *)[self decodePagedResult:ob arrayMember:@"results" itemClass:[Badge class]];
	if(!self.badges)
		return;
	self.succeeded = true;
}

@end
