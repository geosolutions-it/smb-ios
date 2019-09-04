//
//  STSURLDownload.h
//
//  Created by Szymon Tomasz Stefanek on 9/1/18.
//  Copyright © 2018 Szymon Tomasz Stefanek. All rights reserved.
//

#import "STSDownload.h"

@class STSURLRequest;

@interface STSURLDownload : STSDownload

- (void)addHeader:(NSString *)szHeader withValue:(NSString *)szValue;

@property(nonatomic) NSString * URL;
@property(nonatomic) NSData * body;
@property(nonatomic) NSString * method;
@property(nonatomic) bool captureOutputInCaseOfError;

@property(nonatomic) int statusCode;

- (STSURLRequest *)_createRequest;


@end
