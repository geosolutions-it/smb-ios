//
//  BackendRequestCancelParticipationInCompetition.m
//  SaveMyBike
//
//  Created by Szymon Tomasz Stefanek on 08/08/2019.
//  Copyright © 2019 GeoSolutions SaS. All rights reserved.
//

#import "BackendRequestCancelParticipationInCompetition.h"

#import "Config.h"

@implementation BackendRequestCancelParticipationInCompetition

- (bool)start:(bool)bTriggerErrorInCaseOfFailure
{
	self.URL = [NSString stringWithFormat:@"%@/api/my-competitions-current/%d/",[Config instance].serverURL,self.participationId];
	self.method = @"DELETE";
	self.acceptEmptyResponse = true;
	//self.captureOutputInCaseOfError = true;
	
	return [super start:bTriggerErrorInCaseOfFailure];
}

- (void)onProcessObject:(id)ob
{
	// on success this one does not return a JSON object...
	
	// assume it succeeded
	//self.competitions = (NSMutableArray<Competition *> *)[self decodePagedResult:ob arrayMember:@"results" itemClass:[Competition class]];
	//if(!self.competitions)
	//	return;
	self.succeeded = true;
}

@end
