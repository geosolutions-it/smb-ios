//
//  STSCachedImageDownloader.h
//
//  Created by Szymon Tomasz Stefanek on 10/21/13.
//  Copyright © 2013 Szymon Tomasz Stefanek. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

#import "STSCore.h"
#import "STSCachedFileDownloader.h"
#import "STSStaticContentDownload.h"

@class STSCachedImageDownloader;


@protocol STSCachedImageDownloaderDelegate

@required

- (void)cachedImageDownloader:(STSCachedImageDownloader *)pDownloader receivedImage:(UIImage *)pImage forCategory:(NSString *)szCategory andURL:(NSString *)szURL;

@optional

- (void)cachedImageDownloader:(STSCachedImageDownloader *)pDownloader failedToReceiveImageForCategory:(NSString *)szCategory URL:(NSString *)szURL withError:(NSString *)szError;

@end

@interface STSCachedImageDownloader : STSCachedFileDownloader<STSStaticContentDownloadDelegate>

- (id)initWithCacheRoot:(NSString *)szRoot;

- (UIImage *)cachedImageForCategory:(NSString *)szCategory andURL:(NSString *)szURL;

- (bool)addImage:(UIImage *)pImage forCategory:(NSString *)szCategory andURL:(NSString *)szURL;

- (bool)requestImageForCategory:(NSString *)szCategory URL:(NSString *)szURL andDelegate:(id<STSCachedImageDownloaderDelegate>)pDelegate;

- (void)abortImageRequestForCategory:(NSString *)szCategory URL:(NSString *)szURL andDelegate:(id<STSCachedImageDownloaderDelegate>)pDelegate;

@end
