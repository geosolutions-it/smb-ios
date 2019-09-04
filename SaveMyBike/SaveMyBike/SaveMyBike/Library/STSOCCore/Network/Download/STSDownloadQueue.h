//
//  STSDownloaderQueue.h
//
//  Created by Szymon Tomasz Stefanek on 6/20/13.
//  Copyright © 2013 Szymon Tomasz Stefanek. All rights reserved.
//

#import <Foundation/Foundation.h>

@class STSDownload;

@interface STSDownloadQueue : NSObject

- (void)cancelAllDownloads:(bool)bTriggerCancellationErrors;

// DO NOT CALL THESE. THESE ARE CALLED AUTOMATICALLY BY STSDownload.
// Use STSDownload addToQueue and STSDownload removeFromQueue
- (void)_addDownload:(STSDownload *)pDownloader;
- (void)_removeDownload:(STSDownload *)pDownloader;

@property (nonatomic) NSUInteger parallelDownloadCount;

@end
