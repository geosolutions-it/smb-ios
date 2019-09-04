//
//  STSCachedFileDownloader.h
//
//  Created by Szymon Tomasz Stefanek on 1/23/17.
//  Copyright © 2017 Szymon Tomasz Stefanek. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

#import "STSCore.h"
#import "STSStaticContentDownload.h"

@class STSCachedFileDownloader;
@class STSCachedFileDownloaderRequest;

@protocol STSCachedFileDownloaderDelegate

@required

- (void)cachedFileDownloader:(STSCachedFileDownloader *)pDownloader receivedFile:(NSString *)szPath forCategory:(NSString *)szCategory andURL:(NSString *)szURL;

@optional

- (void)cachedFileDownloader:(STSCachedFileDownloader *)pDownloader failedToReceiveFileForCategory:(NSString *)szCategory URL:(NSString *)szURL withError:(NSString *)szError;

@end

@interface STSCachedFileDownloader : NSObject<STSStaticContentDownloadDelegate>

- (id)initWithCacheRoot:(NSString *)szRoot;

- (NSString *)cacheFileNameForCategory:(NSString *)szCategory andURL:(NSString *)szURL;
- (bool)addFile:(NSData *)pFile forCategory:(NSString *)szCategory andURL:(NSString *)szURL;
- (NSString *)cachedFileForCategory:(NSString *)szCategory andURL:(NSString *)szURL;

@property(nonatomic,readonly) NSString * cacheRoot;
// This is false by default!
@property(nonatomic) BOOL ignoreSchemeAndHostInCacheKeys;


- (NSUInteger)pendingRequests;

- (bool)requestFileForCategory:(NSString *)szCategory URL:(NSString *)szURL andDelegate:(id<STSCachedFileDownloaderDelegate>)pDelegate;

- (void)abortFileRequestForCategory:(NSString *)szCategory URL:(NSString *)szURL andDelegate:(id<STSCachedFileDownloaderDelegate>)pDelegate;

- (void)abortAllFileRequests;

- (void)cleanup;


// Internal subclassables for specialized file type downloaders
- (void)_abortFileRequest:(STSCachedFileDownloaderRequest *)pRequest withKey:(NSString *)szKey;
- (STSCachedFileDownloaderRequest *)_getRunningRequest:(NSString *)szKey;
- (BOOL)_downloaderRequestIsEmpty:(STSCachedFileDownloaderRequest *)pRequest;
- (bool)_setupRequestForCategory:(NSString *)szCategory URL:(NSString *)szURL key:(NSString *)szKey andRequest:(STSCachedFileDownloaderRequest *)pRequest;
- (STSCachedFileDownloaderRequest *)_createRequest;
- (void)_invokeSuccessDelegatesForRequest:(STSCachedFileDownloaderRequest *)pRequest;
- (void)_invokeFailureDelegatesForRequest:(STSCachedFileDownloaderRequest *)pRequest withError:(NSString *)szError;

@end
