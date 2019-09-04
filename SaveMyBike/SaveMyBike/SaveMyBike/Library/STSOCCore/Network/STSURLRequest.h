//
//  STSURLRequest.h
//
//  Created by Szymon Tomasz Stefanek on 10/31/12.
//  Copyright (c) 2012 Szymon Tomasz Stefanek. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum _STSURLRequestResult
{
	STSURLRequestPending,
	STSURLRequestSucceeded,
	STSURLRequestCanceled,
	STSURLRequestFailed
	
} STSURLRequestResult;

typedef enum _STSURLRequestOutputMode
{
	STSURLRequestOutputToDelegateInChunks,
	STSURLRequestOutputToDelegate,
	STSURLRequestOutputToFile,
	STSURLRequestOutputIgnore

} STSURLRequestOutputMode;

@class STSURLRequest;

@protocol STSURLRequestCompletionHandlerDelegate
@required
- (void)requestDidComplete:(STSURLRequest *)pRequest;
@end

@protocol STSURLRequestDataHandlerDelegate
@required
- (void)request:(STSURLRequest *)pRequest didReceiveData:(NSData *)data;
@end

@interface STSURLRequest : NSObject<NSURLConnectionDelegate>

- (id)init;
- (void)dealloc;

//+ (STSURLRequest *)requestWithURL:(NSURL *)oURL;
//+ (STSURLRequest *)requestWithURLAsString:(NSString *)szURL;

- (void)setCompletionHandlerDelegate:(__weak id<STSURLRequestCompletionHandlerDelegate>)pDelegate;
- (void)setDataHandlerDelegate:(__weak id<STSURLRequestDataHandlerDelegate>)pDelegate;

- (NSURL *)targetURL;
- (void)setTargetURL:(NSURL *)oURL;
- (void)setTargetURLWithString:(NSString *)szURL;

- (void)setHttpMethod:(NSString *)szString;
- (void)setHttpBody:(NSData *)pData;

- (void)setOutputFileName:(NSString *)szFileName;

- (void)setHeaders:(NSMutableDictionary<NSString *,NSString *> *)pHeaders;
- (void)addHeader:(NSString *)szHeader withValue:(NSString *)szValue;

- (double)connectionTimeout;
- (void)setConnectionTimeout:(double)dTimeout;

- (STSURLRequestOutputMode)outputMode;
- (void)setOutputMode:(STSURLRequestOutputMode)eMode;

// continue capturing output in case of status >= 400 ?
- (void)setCaptureOutputInCaseOfError:(bool)bCapture;

- (bool)start;
- (void)cancel:(bool)bTriggerCompletionEvents;

- (STSURLRequestResult)result;
- (int)statusCode;
- (NSString *)failureReason;


@end
