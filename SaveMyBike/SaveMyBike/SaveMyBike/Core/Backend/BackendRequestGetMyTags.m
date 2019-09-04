//
//  BackendRequestGetMyTags.m
//  SaveMyBike
//
//  Created by Szymon Tomasz Stefanek on 06/07/2019.
//  Copyright © 2019 GeoSolutions SaS. All rights reserved.
//

#import "BackendRequestGetMyTags.h"

#import "Config.h"

@implementation BackendRequestGetMyTags

- (bool)start:(bool)bTriggerErrorInCaseOfFailure
{
	self.URL = [NSString stringWithFormat:@"%@/api/my-tags/?page=%d&page_size=%d",[Config instance].serverURL,self.page,self.page_size];
	self.method = @"GET";
	
	return [super start:bTriggerErrorInCaseOfFailure];
}

- (void)onProcessObject:(id)ob
{
	self.tags = (NSMutableArray<PhysicalTag *> *)[self decodePagedResult:ob arrayMember:@"results" itemClass:[PhysicalTag class]];
	if(!self.tags)
		return;
	self.succeeded = true;
}

@end
