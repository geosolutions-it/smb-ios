//
//  BackendRequestSetBikeStatus.m
//  SaveMyBike
//
//  Created by Pragma on 25/10/2019.
//  Copyright © 2019 STS. All rights reserved.
//

#import "BackendRequestSetBikeStatus.h"

#import "Config.h"

@implementation BackendRequestSetBikeStatus


- (bool)start:(bool)bTriggerErrorInCaseOfFailure
{
	//NSData * oData = [_device encodeToJSONData];
	
	//NSString * sJSON = [_device encodeToJSONString];
	
	NSString * sJSON;
	
	if(self.position)
		sJSON = [NSString stringWithFormat:
				@"{ \"lost\": %@, \"url\": \"%@\", \"position\": \"%@\", \"bike\":\"%@/api/my-bikes/%@/\", \"details\":\"%@\"}",
				self.lost ? @"true" : @"false",
				self.url,
				self.position,
				[Config instance].serverURL,
				self.bikeUUID,
				self.details
		];
	else
		sJSON = [NSString stringWithFormat:
				 @"{ \"lost\": %@, \"url\": \"%@\", \"bike\":\"%@/api/my-bikes/%@/\", \"details\":\"%@\"}",
				 self.lost ? @"true" : @"false",
				 self.url,
				 [Config instance].serverURL,
				 self.bikeUUID,
				 self.details
			 ];

	NSData * oData = [sJSON dataUsingEncoding:NSUTF8StringEncoding];
	
	self.URL = [NSString stringWithFormat:@"%@/api/my-bike-statuses/",[Config instance].serverURL];
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
