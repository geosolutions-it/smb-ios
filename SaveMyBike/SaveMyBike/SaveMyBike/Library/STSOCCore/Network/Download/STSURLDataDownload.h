//
//  STSURLDataDownload.h
//
//  Created by Szymon Tomasz Stefanek on 9/1/18.
//  Copyright © 2018 Szymon Tomasz Stefanek. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "STSURLDownload.h"
#import "STSURLRequest.h"

@class STSURLDataDownload;

@protocol STSURLDataDownloadDelegate
- (void)onURLDataDownloadCompleted:(STSURLDataDownload *)d;
@end

@interface STSURLDataDownload : STSURLDownload<STSURLRequestCompletionHandlerDelegate,STSURLRequestDataHandlerDelegate>

@property(nonatomic) NSData * data;
@property(nonatomic,weak) id<STSURLDataDownloadDelegate> delegate;


- (NSString *)dataAsString;

// You don't need to call this if you use addToQueue().
- (bool)start;
- (bool)start:(bool)bTriggerErrorInCaseOfFailure;

// This will also remove the download from queue.
- (void)cancel;
- (void)cancel:(bool)bTriggerCancellationError;

@end
