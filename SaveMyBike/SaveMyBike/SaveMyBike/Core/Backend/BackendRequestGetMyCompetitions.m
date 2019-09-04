//
//  BackendRequestGetMyCurrentCompetitions.m
//  SaveMyBike
//
//  Created by Szymon Tomasz Stefanek on 06/07/2019.
//  Copyright © 2019 GeoSolutions SaS. All rights reserved.
//

#import "BackendRequestGetMyCompetitions.h"

#import "Config.h"

@interface BackendRequestGetMyCompetitions()
{
	NSString * m_sURLPart;
}

@end

@implementation BackendRequestGetMyCompetitions

- (id)initWithUrlPart:(NSString *)sURLPart
{
	self = [super init];
	if(!self)
		return nil;
	m_sURLPart = sURLPart;
	return self;
}

- (bool)start:(bool)bTriggerErrorInCaseOfFailure
{
	self.URL = [NSString stringWithFormat:@"%@/api/%@/?page=%d&page_size=%d",[Config instance].serverURL,m_sURLPart,self.page,self.page_size];
	self.method = @"GET";
	
	return [super start:bTriggerErrorInCaseOfFailure];
}

- (void)onProcessObject:(id)ob
{
	self.competitions = (NSMutableArray<CompetitionParticipation *> *)[self decodePagedResult:ob arrayMember:@"results" itemClass:[CompetitionParticipation class]];
	if(!self.competitions)
		return;
	self.succeeded = true;
}

@end
