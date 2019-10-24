//
//  BackendRequestUploadFile.m
//  SaveMyBike
//
//  Created by Szymon Tomasz Stefanek on 17/08/2019.
//  Copyright © 2019 GeoSolutions SaS. All rights reserved.
//

#import "BackendRequestUploadFile.h"

#import "Config.h"

@implementation BackendRequestUploadFile

- (bool)start:(bool)bTriggerErrorInCaseOfFailure
{
	self.URL = [NSString stringWithFormat:@"%@/%@",[Config instance].fileUploadServerURL,self.fileName];
	self.method = @"PUT";
	self.acceptEmptyResponse = true;
	//self.captureOutputInCaseOfError = true;
	[self addHeader:@"Content-Type" withValue:@"application/zip"];
	//[self addHeader:@"Content-Length" withValue:[NSString stringWithFormat:@"%lu",self.file.length]];
	//[self addHeader:@"Authorization" withValue:@"crap"];
	self.body = self.file;
	
	return [super start:bTriggerErrorInCaseOfFailure];
}

- (void)onProcessObject:(id)ob
{
	// on success this one does not return a JSON object...
	
	self.succeeded = true;
}


@end
