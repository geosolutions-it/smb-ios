//
//  BackendRequestGetMyTracks.m
//  SaveMyBike
//
//  Created by Szymon Tomasz Stefanek on 06/07/2019.
//  Copyright © 2019 GeoSolutions SaS. All rights reserved.
//

#import "BackendRequestGetMyTracks.h"

#import "Config.h"

@implementation BackendRequestGetMyTracks

- (bool)start:(bool)bTriggerErrorInCaseOfFailure
{
	self.URL = [NSString stringWithFormat:@"%@/api/my-tracks/?page=%d&page_size=%d",[Config instance].serverURL,self.page,self.page_size];
	self.method = @"GET";
	
	return [super start:bTriggerErrorInCaseOfFailure];
}

- (void)onProcessObject:(id)ob
{
	self.tracks = (NSMutableArray<Track *> *)[self decodePagedResult:ob arrayMember:@"results" itemClass:[Track class]];
	if(!self.tracks)
		return;
	self.succeeded = true;
}

@end
