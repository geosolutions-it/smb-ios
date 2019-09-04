//
//  STSDownloader.h
//
//  Created by Szymon Tomasz Stefanek on 6/20/13.
//  Copyright © 2013 Szymon Tomasz Stefanek. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "STSCore.h"

@class STSDownloadQueue;

@interface STSDownload : NSObject

@property(nonatomic) bool succeeded;
@property(nonatomic) NSString * error;

- (id)init;

- (void)addToQueue:(STSDownloadQueue *)pQueue;
- (void)removeFromQueue;

- (bool)start;
- (bool)start:(bool)bTriggerErrorInCaseOfFailure;

- (void)cancel;
- (void)cancel:(bool)bTriggerCancellationError;

//
// The priority of this download. The higher, this number
// the higher the priority.
//
@property (nonatomic) int priority;

//
// A simple numeric tag. User definable.
//
@property (nonatomic) int tag;

//
// Generic data, associated with the current instance
//
@property (nonatomic, strong) id<NSObject> payload;



@end
