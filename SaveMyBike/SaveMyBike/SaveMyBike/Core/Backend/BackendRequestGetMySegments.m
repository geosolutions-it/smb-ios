//
//  BackendRequestGetMySegments.m
//  SaveMyBike
//
//  Created by Szymon Tomasz Stefanek on 06/07/2019.
//  Copyright © 2019 GeoSolutions SaS. All rights reserved.
//

#import "BackendRequestGetMySegments.h"

#import "Config.h"

@implementation BackendRequestGetMySegments

- (bool)start:(bool)bTriggerErrorInCaseOfFailure
{
	self.URL = [NSString stringWithFormat:@"%@/api/my-segments/?page=%d&page_size=%d",[Config instance].serverURL,self.page,self.page_size];
	self.method = @"GET";
	
	return [super start:bTriggerErrorInCaseOfFailure];
}

- (void)onProcessObject:(id)ob
{
	self.segments = (NSMutableArray<SegmentBrief *> *)[self decodePagedResult:ob arrayMember:@"results" itemClass:[SegmentBrief class]];
	if(!self.segments)
		return;
	self.succeeded = true;
}

@end
