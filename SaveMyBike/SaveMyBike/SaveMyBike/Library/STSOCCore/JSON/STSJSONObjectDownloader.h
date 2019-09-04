//
//  STSJSONObjectDownloader.h
//  STSCore
//
//  Copyright (c) 2012 Szymon Tomasz Stefanek. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "STSURLRequest.h"

@protocol STSJSONObjectDownloaderDelegate
	- (void)downloadFailed:(NSString *)szError;
	- (void)downloadSucceeded:(id)oJSONObject;
@end

@interface STSJSONObjectDownloader : NSObject<STSURLRequestCompletionHandlerDelegate,STSURLRequestDataHandlerDelegate>
{
@private
	STSURLRequest * m_pRequest;
	__unsafe_unretained id<STSJSONObjectDownloaderDelegate> m_pDelegate;
}

- (bool)startWithURL:(NSString *)szUrl andDelegate:(__unsafe_unretained id<STSJSONObjectDownloaderDelegate>)pDelegate;
- (bool)startWithURL:(NSString *)szUrl httpMethod:(NSString *)szMethod httpBody:(NSData *)pBody andDelegate:(__unsafe_unretained id<STSJSONObjectDownloaderDelegate>)pDelegate;

- (bool)isRunning;
- (void)cancel;

@end
