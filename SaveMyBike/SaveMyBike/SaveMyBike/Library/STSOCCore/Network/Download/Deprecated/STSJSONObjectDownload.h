//
//  Created by Szymon Tomasz Stefanek on 6/20/13.
//

#import <Foundation/Foundation.h>

#import "STSDownload.h"
#import "STSURLRequest.h"

@class STSJSONObjectDownload;

__attribute__ ((deprecated))
@protocol STSJSONObjectDownloadDelegate
- (void)onJSONObjectDownloadCompleted:(STSJSONObjectDownload *)d;
@end

__attribute__ ((deprecated))
@interface STSJSONObjectDownload : STSDownload<STSURLRequestCompletionHandlerDelegate,STSURLRequestDataHandlerDelegate>

@property(nonatomic) id object;

- (void)addHeader:(NSString *)szHeader withValue:(NSString *)szValue;

- (void)setURL:(NSString *)szURL;
- (void)setBody:(NSData *)pBody;
- (void)setMethod:(NSString *)szMethod;
- (void)setDelegate:(__weak NSObject<STSJSONObjectDownloadDelegate> *)pDelegate;

// You don't need to call this if you use addToQueue().
- (bool)start;
- (bool)start:(bool)bTriggerErrorInCaseOfFailure;

// This will also remove the download from queue.
- (void)cancel;
- (void)cancel:(bool)bTriggerCancellationError;

@end
