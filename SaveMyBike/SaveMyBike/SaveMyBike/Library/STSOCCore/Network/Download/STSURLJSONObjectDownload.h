//
//  STSURLJSONObjectDownload.h
//
//  Created by Szymon Tomasz Stefanek on 9/1/18.
//  Copyright © 2018 Szymon Tomasz Stefanek. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "STSURLDownload.h"
#import "STSURLRequest.h"

@class STSURLJSONObjectDownload;

@protocol STSURLJSONObjectDownloadDelegate
- (void)onURLJSONObjectDownloadCompleted:(STSURLJSONObjectDownload *)d;
@end

@interface STSURLJSONObjectDownload : STSURLDownload<STSURLRequestCompletionHandlerDelegate,STSURLRequestDataHandlerDelegate>

@property(nonatomic,weak) id<STSURLJSONObjectDownloadDelegate> delegate;
@property(nonatomic) id object;
@property(nonatomic) bool acceptEmptyResponse;

// You don't need to call this if you use addToQueue().
- (bool)start;
- (bool)start:(bool)bTriggerErrorInCaseOfFailure;

// This will also remove the download from queue.
- (void)cancel;
- (void)cancel:(bool)bTriggerCancellationError;

@end
