//
//  STSCachedImageDownloader.m
//
//  Created by Szymon Tomasz Stefanek on 10/21/13.
//  Copyright © 2013 Szymon Tomasz Stefanek. All rights reserved.
//

#import "STSCachedImageDownloader.h"

#import "STSDownloadQueue.h"
#import "STSStaticContentDownload.h"
#import "STSFile.h"
//#import "UIImage+Utilities.h"
#import "STSDelegateArray.h"
#import "NSString+Hashing.h"
#import "NSString+URL.h"
#import "STSCachedFileDownloaderRequest.h"

@interface STSCachedImageDownloaderRequest : STSCachedFileDownloaderRequest
{
}

@property (nonatomic,strong) STSDelegateArray * imageDelegateArray;

@end

@implementation STSCachedImageDownloaderRequest
@end

@interface STSCachedImageDownloader()
{
}


@end

@implementation STSCachedImageDownloader

- (id)initWithCacheRoot:(NSString *)szRoot
{
	self = [super initWithCacheRoot:szRoot];
	if(!self)
		return nil;
	return self;
}

- (bool)addImage:(UIImage *)pImage forCategory:(NSString *)szCategory andURL:(NSString *)szURL
{
	if(!pImage)
		return false;
	
	NSURL * pURL = [szURL toURL];
	NSString * szExt = [[[pURL path] pathExtension] lowercaseString];
	if(!szExt)
		szExt = @"png";
	
	NSData * dat;
	
	if([szExt isEqualToString:@"jpg"] || [szExt isEqualToString:@"jpeg"])
		dat = UIImageJPEGRepresentation(pImage, 1.0);
	else
		dat = UIImagePNGRepresentation(pImage);

	return [self addFile:dat forCategory:szCategory andURL:szURL];
}

- (UIImage *)cachedImageForCategory:(NSString *)szCategory andURL:(NSString *)szURL
{
	NSString * szFullPath = [self cachedFileForCategory:szCategory andURL:szURL];
	if(!szFullPath)
		return nil;

	return [UIImage imageWithContentsOfFile:szFullPath];
}

- (STSCachedFileDownloaderRequest *)_createRequest
{
	return [STSCachedImageDownloaderRequest new];
}

- (bool)requestImageForCategory:(NSString *)szCategory URL:(NSString *)szURL andDelegate:(id<STSCachedImageDownloaderDelegate>)pDelegate
{
	NSString * szKey = [NSString stringWithFormat:@"%@.%@",szCategory,szURL];

	STSCachedImageDownloaderRequest * pRequest = (STSCachedImageDownloaderRequest *)[self _getRunningRequest:szKey];
	if(pRequest)
	{
		// already running
		if(!pRequest.imageDelegateArray)
			pRequest.imageDelegateArray = [STSDelegateArray new];
		[pRequest.imageDelegateArray addDelegate:pDelegate];
		return true;
	}
	
	pRequest = (STSCachedImageDownloaderRequest *)[self _createRequest];
	
	pRequest.imageDelegateArray = [STSDelegateArray new];
	[pRequest.imageDelegateArray addDelegate:pDelegate];
	
	return [self _setupRequestForCategory:szCategory URL:szURL key:szKey andRequest:pRequest];
}

- (void)abortImageRequestForCategory:(NSString *)szCategory URL:(NSString *)szURL andDelegate:(id<STSCachedImageDownloaderDelegate>)pDelegate
{
	NSString * szKey = [NSString stringWithFormat:@"%@.%@",szCategory,szURL];

	STSCachedImageDownloaderRequest * pRequest = (STSCachedImageDownloaderRequest *)[self _getRunningRequest:szKey];
	if(!pRequest)
		return; // not running

	if(pRequest.imageDelegateArray)
	{
		[pRequest.imageDelegateArray removeDelegate:pDelegate];
		if(pRequest.imageDelegateArray.count < 1)
			pRequest.imageDelegateArray = nil;
	}

	[self _abortFileRequest:pRequest withKey:szKey];
}

- (BOOL)_downloaderRequestIsEmpty:(STSCachedFileDownloaderRequest *)pRequest
{
	if(![super _downloaderRequestIsEmpty:pRequest])
		return false;
	
	STSCachedImageDownloaderRequest * pReq = (STSCachedImageDownloaderRequest *)pRequest;
	if(!pReq.imageDelegateArray)
		return true;
	if(pReq.imageDelegateArray.count < 1)
		return true;
	
	return false;
}

- (void)_invokeSuccessDelegatesForRequest:(STSCachedFileDownloaderRequest *)pRequest
{
	[super _invokeSuccessDelegatesForRequest:pRequest];
	
	STSCachedImageDownloaderRequest * pReq = (STSCachedImageDownloaderRequest *)pRequest;
	if(!pReq.imageDelegateArray)
		return;
	
	UIImage * pImage = [UIImage imageWithContentsOfFile:pRequest.fullFilePath];
	if(!pImage)
	{
		[pReq.imageDelegateArray
				performSelectorOnAllDelegates:@selector(cachedImageDownloader:failedToReceiveImageForCategory:URL:withError:)
				 withObject:self
				 withObject:pRequest.category
				 withObject:pRequest.URL
				 withObject:@"The image downloaded succesfully but loading of the contents failed"
			];
		return;
	}
	
	[pReq.imageDelegateArray
	 performSelectorOnAllDelegates:@selector(cachedImageDownloader:receivedImage:forCategory:andURL:)
		 withObject:self
		 withObject:pImage
		 withObject:pRequest.category
		 withObject:pRequest.URL
		];
}

- (void)_invokeFailureDelegatesForRequest:(STSCachedFileDownloaderRequest *)pRequest withError:(NSString *)szError
{
	[super _invokeFailureDelegatesForRequest:pRequest withError:szError];

	STSCachedImageDownloaderRequest * pReq = (STSCachedImageDownloaderRequest *)pRequest;
	if(!pReq.imageDelegateArray)
		return;

	[pReq.imageDelegateArray
		performSelectorOnAllDelegates:@selector(cachedImageDownloader:failedToReceiveImageForCategory:URL:withError:)
			 withObject:self
			 withObject:pRequest.category
			 withObject:pRequest.URL
			 withObject:szError
		];
}

@end
