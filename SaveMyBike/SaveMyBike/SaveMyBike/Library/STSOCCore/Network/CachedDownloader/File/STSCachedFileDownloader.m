//
//  STSCachedFileDownloader.m
//
//  Created by Szymon Tomasz Stefanek on 23/01/17.
//  Copyright © 2017 Szymon Tomasz Stefanek. All rights reserved.
//
#import "STSCachedFileDownloader.h"

#import "STSDownloadQueue.h"
#import "STSStaticContentDownload.h"
#import "STSFile.h"
#import "STSDelegateArray.h"
#import "NSString+Hashing.h"
#import "NSString+URL.h"
#import "STSCachedFileDownloaderRequest.h"

@interface STSCachedFileDownloader()
{
	STSDownloadQueue * m_pDownloadQueue;
	NSMutableDictionary * m_pRunningRequests;
	NSString * m_szCacheRoot;
	BOOL m_bIgnoreSchemeAndHostInCacheKeys;
}

@end

@implementation STSCachedFileDownloader

@synthesize ignoreSchemeAndHostInCacheKeys = m_bIgnoreSchemeAndHostInCacheKeys;
@synthesize cacheRoot = m_szCacheRoot;

- (id)initWithCacheRoot:(NSString *)szRoot
{
	self = [super init];
	if(!self)
		return nil;
	
	m_szCacheRoot = szRoot;
	m_bIgnoreSchemeAndHostInCacheKeys = FALSE;
	
	[[NSFileManager defaultManager] createDirectoryAtPath:m_szCacheRoot withIntermediateDirectories:YES attributes:nil error:nil];
	// Make sure that the directory is not backed up by iCloud or the apple reviewers will reject the app
	[STSFile addSkipBackupAttributeToFileAtPath:m_szCacheRoot];

	m_pRunningRequests = [NSMutableDictionary new];
	
	m_pDownloadQueue = [STSDownloadQueue new];
	m_pDownloadQueue.parallelDownloadCount = 5; // FIXME: Make this configurable
	
	return self;
}

- (void)dealloc
{
	[self cleanup];
}

- (void)cleanup
{
	if(m_pDownloadQueue)
	{
		[m_pDownloadQueue cancelAllDownloads:true];
		m_pDownloadQueue = nil;
	}
	
	if(m_pRunningRequests)
	{
		[m_pRunningRequests removeAllObjects];
		m_pRunningRequests = nil;
	}
}

- (NSUInteger)pendingRequests
{
	return m_pRunningRequests.count;
}

- (void)abortAllFileRequests
{
	[m_pDownloadQueue cancelAllDownloads:true];
	[m_pRunningRequests removeAllObjects];
}

- (NSString *)cacheFileNameForCategory:(NSString *)szCategory andURL:(NSString *)szURL
{
	NSURL * pURL = [szURL toURL];
	
	NSString * szBaseFileName;
 
	if(m_bIgnoreSchemeAndHostInCacheKeys)
	{
		NSString * szPath = [pURL path];
		if(!szPath)
			szPath = @"";
		NSString * szQuery = [pURL query];
		if(!szQuery)
			szQuery = @"";
		NSString * szParams = [pURL parameterString];
		if(!szParams)
			szParams = @"";
		szBaseFileName = [[NSString stringWithFormat:@"-%@:%@:%@:%@-----",szCategory,szPath,szQuery,szParams] hashSHA512];
	} else {
		szBaseFileName = [[NSString stringWithFormat:@"-%@:%@-----",szCategory,szURL] hashSHA512];
	}
	
	NSString * szExt = [[pURL path] pathExtension];
	if(!szExt)
		szExt = @"dat";
	
	return [NSString stringWithFormat:@"%@.%@",szBaseFileName,szExt];
}

- (bool)addFile:(NSData *)pFile forCategory:(NSString *)szCategory andURL:(NSString *)szURL
{
	NSString * szFileName = [self cacheFileNameForCategory:szCategory andURL:szURL];
	
	NSFileManager * fm = [NSFileManager defaultManager];
	
	NSString * szDir = [self.cacheRoot stringByAppendingPathComponent:szCategory];
	
	BOOL bDummy;
	
	if(![fm fileExistsAtPath:szDir isDirectory:&bDummy])
	{
		[fm createDirectoryAtPath:szDir withIntermediateDirectories:YES attributes:nil error:nil];
		// Make sure that the directory is not backed up by iCloud or the apple reviewers will reject the app
		[STSFile addSkipBackupAttributeToFileAtPath:szDir];
	}
	
	NSString * szFullPath = [szDir stringByAppendingPathComponent:szFileName];
	
	return [pFile writeToFile:szFullPath atomically:YES];
}

- (NSString *)cachedFileForCategory:(NSString *)szCategory andURL:(NSString *)szURL
{
	NSString * szFileName = [self cacheFileNameForCategory:szCategory andURL:szURL];
	
	NSFileManager * fm = [NSFileManager defaultManager];
	
	NSString * szDir = [self.cacheRoot stringByAppendingPathComponent:szCategory];
	
	BOOL bDummy;
	
	if(![fm fileExistsAtPath:szDir isDirectory:&bDummy])
		return nil;
	
	if(!bDummy)
		return nil; // is not directory!!!
	
	NSString * szFullPath = [szDir stringByAppendingPathComponent:szFileName];
	
	if(![fm fileExistsAtPath:szFullPath isDirectory:&bDummy])
		return nil;
	
	if(bDummy)
		return nil; // is directory!!!!
	
	return szFullPath;
}

- (bool)_setupRequestForCategory:(NSString *)szCategory URL:(NSString *)szURL key:(NSString *)szKey andRequest:(STSCachedFileDownloaderRequest *)pRequest
{
	pRequest.category = szCategory;
	pRequest.URL = szURL;
	
	NSString * szFileName = [self cacheFileNameForCategory:szCategory andURL:szURL];
	
	NSFileManager * fm = [NSFileManager defaultManager];
	
	NSString * szDir = [self.cacheRoot stringByAppendingPathComponent:szCategory];
	
	BOOL bDummy;
	
	if(![fm fileExistsAtPath:szDir isDirectory:&bDummy])
	{
		[fm createDirectoryAtPath:szDir withIntermediateDirectories:YES attributes:nil error:nil];
		// Make sure that the directory is not backed up by iCloud or the apple reviewers will reject the app
		[STSFile addSkipBackupAttributeToFileAtPath:szDir];
	}
	
	pRequest.fullFilePath = [szDir stringByAppendingPathComponent:szFileName];
	pRequest.temporaryFilePath = [pRequest.fullFilePath stringByAppendingString:@".tmp"];
	
	pRequest.download = [STSStaticContentDownload new];
	[pRequest.download setupWithURL:szURL savePath:pRequest.fullFilePath temporaryPath:pRequest.temporaryFilePath andDelegate:self];
	pRequest.download.payload = szKey;
	
	[m_pRunningRequests setObject:pRequest forKey:szKey];
	
	[pRequest.download addToQueue:m_pDownloadQueue];
	
	return true;
}

- (STSCachedFileDownloaderRequest *)_createRequest
{
	return [STSCachedFileDownloaderRequest new];
}

- (bool)requestFileForCategory:(NSString *)szCategory URL:(NSString *)szURL andDelegate:(id<STSCachedFileDownloaderDelegate>)pDelegate
{
	NSString * szKey = [NSString stringWithFormat:@"%@.%@",szCategory,szURL];
	
	STSCachedFileDownloaderRequest * pRequest = [m_pRunningRequests objectForKey:szKey];
	if(pRequest)
	{
		// already running
		if(!pRequest.fileDelegateArray)
			pRequest.fileDelegateArray = [STSDelegateArray new];
		[pRequest.fileDelegateArray addDelegate:pDelegate];
		return true;
	}
	
	pRequest = [self _createRequest];
	
	pRequest.fileDelegateArray = [STSDelegateArray new];
	[pRequest.fileDelegateArray addDelegate:pDelegate];

	return [self _setupRequestForCategory:szCategory URL:szURL key:szKey andRequest:pRequest];
}

- (void)abortFileRequestForCategory:(NSString *)szCategory URL:(NSString *)szURL andDelegate:(id<STSCachedFileDownloaderDelegate>)pDelegate
{
	NSString * szKey = [NSString stringWithFormat:@"%@.%@",szCategory,szURL];
	
	STSCachedFileDownloaderRequest * pRequest = [m_pRunningRequests objectForKey:szKey];
	if(!pRequest)
		return; // not running
	
	if(pRequest.fileDelegateArray)
	{
		[pRequest.fileDelegateArray removeDelegate:pDelegate];
		if(pRequest.fileDelegateArray.count < 1)
			pRequest.fileDelegateArray = nil;
	}
	
	if(![self _downloaderRequestIsEmpty:pRequest])
		return; // other delegates are waiting on it
	
	[self _abortFileRequest:pRequest withKey:szKey];
}

- (void)_abortFileRequest:(STSCachedFileDownloaderRequest *)pRequest withKey:(NSString *)szKey
{
	[pRequest.download cancel:false];
	
	[m_pRunningRequests removeObjectForKey:szKey];
}

- (STSCachedFileDownloaderRequest *)_getRunningRequest:(NSString *)szKey
{
	return [m_pRunningRequests objectForKey:szKey];
}

- (BOOL)_downloaderRequestIsEmpty:(STSCachedFileDownloaderRequest *)pRequest
{
	if(!pRequest.fileDelegateArray)
		return true;
	if(pRequest.fileDelegateArray.count < 1)
		return true;
	return false;
}

- (void)_invokeSuccessDelegatesForRequest:(STSCachedFileDownloaderRequest *)pRequest
{
	if(!pRequest.fileDelegateArray)
		return;
	[pRequest.fileDelegateArray
			performSelectorOnAllDelegates:@selector(cachedFileDownloader:receivedFile:forCategory:andURL:)
		 withObject:self
		 withObject:pRequest.fullFilePath
		 withObject:pRequest.category
		 withObject:pRequest.URL
			];
}

- (void)_invokeFailureDelegatesForRequest:(STSCachedFileDownloaderRequest *)pRequest withError:(NSString *)szError
{
	if(!pRequest.fileDelegateArray)
		return;
	[pRequest.fileDelegateArray
			performSelectorOnAllDelegates:@selector(cachedFileDownloader:failedToReceiveFileForCategory:URL:withError:)
		 withObject:self
		 withObject:pRequest.category
		 withObject:pRequest.URL
		 withObject:szError
		 ];
}

- (void)onStaticContentDownloadCompleted:(STSStaticContentDownload *)d
{
	if(d.succeeded)
		[self staticContentDownload:d succeededWithPath:d.savePath];
	else
		[self staticContentDownload:d failedWithError:d.error];;
}

- (void)staticContentDownload:(STSStaticContentDownload *)pDownloader succeededWithPath:(NSString *)szPath
{
	id<NSObject> oKey = pDownloader.payload;
	
	if((!oKey) || (![oKey isKindOfClass:[NSString class]]))
	{
		STS_CORE_LOG_ERROR(@"A download has completed but it has no payload");
		return;
	}
	
	NSString * szKey = (NSString *)pDownloader.payload;
	
	STSCachedFileDownloaderRequest * pRequest = [m_pRunningRequests objectForKey:szKey];
	if(!pRequest)
	{
		STS_CORE_LOG_ERROR(@"A download has completed but I have no running request for it");
		return;
	}
	
	[m_pRunningRequests removeObjectForKey:szKey];
	
	[STSFile addSkipBackupAttributeToFileAtPath:pRequest.fullFilePath];
	
	[self _invokeSuccessDelegatesForRequest:pRequest];
}

- (void)staticContentDownload:(STSStaticContentDownload *)pDownloader failedWithError:(NSString *)szError
{
	id<NSObject> oKey = pDownloader.payload;
	
	if((!oKey) || (![oKey isKindOfClass:[NSString class]]))
	{
		STS_CORE_LOG_ERROR(@"A download has completed but it has no payload");
		return;
	}
	
	NSString * szKey = (NSString *)pDownloader.payload;
	
	STSCachedFileDownloaderRequest * pRequest = [m_pRunningRequests objectForKey:szKey];
	if(!pRequest)
	{
		STS_CORE_LOG_ERROR(@"A download has completed but I have no running request for it");
		return;
	}
	
	[m_pRunningRequests removeObjectForKey:szKey];
	
	[self _invokeFailureDelegatesForRequest:pRequest withError:szError];
}



@end
