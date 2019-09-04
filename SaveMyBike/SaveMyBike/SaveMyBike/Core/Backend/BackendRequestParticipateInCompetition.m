//
//  BackendRequestParticipateInCompetition.m
//  SaveMyBike
//
//  Created by Szymon Tomasz Stefanek on 08/08/2019.
//  Copyright © 2019 GeoSolutions SaS. All rights reserved.
//

#import "BackendRequestParticipateInCompetition.h"

#include "STSCore.h"
#import "Config.h"

@implementation BackendRequestParticipateInCompetition

- (id)init
{
	self = [super init];
	if(!self)
		return nil;
	
	return self;
}

- (bool)start:(bool)bTriggerErrorInCaseOfFailure
{
	NSString * sBody = [NSString stringWithFormat:@"{ \"competition_id\": %d }", self.competitionId];
	
	self.URL = [NSString stringWithFormat:@"%@/api/my-competitions-current/",[Config instance].serverURL];
	self.method = @"POST";
	self.captureOutputInCaseOfError = true;

	[self addHeader:@"Content-Type" withValue:@"application/json"];
	[self setBody:[sBody dataUsingEncoding:NSUTF8StringEncoding]];
	
	STS_CORE_LOG(@"Request body: %@",sBody);

	return [super start:bTriggerErrorInCaseOfFailure];
}

- (void)onProcessObject:(id)ob
{
	// assume it succeeded
	//self.competitions = (NSMutableArray<Competition *> *)[self decodePagedResult:ob arrayMember:@"results" itemClass:[Competition class]];
	//if(!self.competitions)
	//	return;
	self.succeeded = true;
}


@end
