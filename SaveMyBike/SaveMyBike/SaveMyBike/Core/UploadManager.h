//
//  UploadManager.h
//  SaveMyBike
//
//  Created by Szymon Tomasz Stefanek on 17/08/2019.
//  Copyright © 2019 GeoSolutions SaS. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UploadManagerStateObserver<NSObject>

- (void)onUploadManagerChangedSessionState;

@end


@interface UploadManager : NSObject

+ (void)createWithDataPath:(NSString *)sPath;
+ (void)destroy;

+ (UploadManager *)instance;

- (void)addStateObserver:(__weak id<UploadManagerStateObserver>)pObserver;
- (void)removeStateObserver:(__weak id<UploadManagerStateObserver>)pObserver;

- (void)startUploadIfNotRunning;

@end

