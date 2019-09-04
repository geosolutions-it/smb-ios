//
//  STSURLDataDownloadToFileer.h
//  STSCore
//
//  Created by Szymon Tomasz Stefanek on 6/20/13.
//
//

#import <Foundation/Foundation.h>

#import "STSCore.h"

#import "STSURLDownload.h"
#import "STSURLRequest.h"

@class STSURLDataDownloadToFile;

@protocol STSURLDataDownloadToFileDelegate
- (void)onURLDataDownloadToFileCompleted:(STSURLDataDownloadToFile *)d;
@end

@interface STSURLDataDownloadToFile : STSURLDownload<STSURLRequestCompletionHandlerDelegate>

@property(nonatomic) NSString * savePath;
@property(nonatomic) NSString * temporaryPath;
@property(nonatomic,weak) id<STSURLDataDownloadToFileDelegate> delegate;

// You don't need to call this if you use addToQueue().
- (bool)start;
- (bool)start:(bool)bTriggerErrorInCaseOfFailure;

// This will also remove the download from queue.
- (void)cancel;
- (void)cancel:(bool)bTriggerCancellationError;

@end
