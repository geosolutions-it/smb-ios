//
//  STSStaticContentDownloader.h
//
//  Created by Szymon Tomasz Stefanek on 6/20/13.
//  Copyright © 2013 Szymon Tomasz Stefanek. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "STSCore.h"

#import "STSDownload.h"
#import "STSURLRequest.h"

@class STSStaticContentDownload;

__attribute__ ((deprecated))
@protocol STSStaticContentDownloadDelegate
- (void)onStaticContentDownloadCompleted:(STSStaticContentDownload *)d;
@end

__attribute__ ((deprecated))
@interface STSStaticContentDownload : STSDownload<STSURLRequestCompletionHandlerDelegate>

- (void)setupWithURL:(NSString *)szUrl 
			savePath:(NSString *)szSavePath
			temporaryPath:(NSString *)szTemporaryPath
			andDelegate:(__weak NSObject<STSStaticContentDownloadDelegate> *)pDelegate;

- (NSString *)targetUrl;
- (NSString *)savePath;
- (NSString *)temporaryPath;

// You don't need to call this if you use addToQueue().
- (bool)start;
- (bool)start:(bool)bTriggerErrorInCaseOfFailure;

// This will also remove the download from queue.
- (void)cancel;
- (void)cancel:(bool)bTriggerCancellationError;

@end
