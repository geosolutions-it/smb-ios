//
//  STSStaticContentDownloader.m
//
//  Created by Szymon Tomasz Stefanek on 6/20/13.
//  Copyright © 2013 Szymon Tomasz Stefanek. All rights reserved.
//

#import "STSStaticContentDownload.h"

#import "STSFile.h"

#import "NSString+URL.h"

@interface STSStaticContentDownload()
{
	STSURLRequest * m_pRequest;
	NSString * m_szTargetUrl;
	NSString * m_szSavePath;
	NSString * m_szTemporaryPath;
	__weak NSObject<STSStaticContentDownloadDelegate> * m_pDelegate;
}

- (void)requestDidComplete:(STSURLRequest *)pRequest;


@end

@implementation STSStaticContentDownload


- (void)setupWithURL:(NSString *)szUrl 
		savePath:(NSString *)szSavePath
		temporaryPath:(NSString *)szTemporaryPath
		andDelegate:(__weak NSObject<STSStaticContentDownloadDelegate> *)pDelegate
{
	assert(szUrl);
	assert(szSavePath);
	assert(szTemporaryPath);
	assert(pDelegate);

	m_pDelegate = pDelegate;
	
	m_szTargetUrl = szUrl;
	m_szSavePath = szSavePath;
	m_szTemporaryPath = szTemporaryPath;
	
	m_pRequest = nil;
}

- (NSString *)savePath
{
	return m_szSavePath;
}

- (NSString *)temporaryPath
{
	return m_szTemporaryPath;
}

- (NSString *)targetUrl
{
	return m_szTargetUrl;
}

- (bool)start
{
	return [self start:false];
}

- (bool)start:(bool)bTriggerErrorInCaseOfFailure;
{
	if(m_pRequest)
		[m_pRequest cancel:false];
	
	m_pRequest = [[STSURLRequest alloc] init];
	
	[m_pRequest setTargetURL:[m_szTargetUrl toURL]];
	[m_pRequest setOutputMode:STSURLRequestOutputToFile];
	[m_pRequest setOutputFileName:m_szTemporaryPath];
	[m_pRequest setCompletionHandlerDelegate:self];

	if(![m_pRequest start])
	{
		STS_CORE_LOG_ERROR(@"ERROR: Failed to start the image download request for url %@, error: %@",m_szTargetUrl,[m_pRequest failureReason]);
		self.succeeded = false;
		self.error = m_pRequest.failureReason;
		
		if(bTriggerErrorInCaseOfFailure && m_pDelegate)
			[m_pDelegate onStaticContentDownloadCompleted:self];
		return false;
	}
	
	return true;
}

- (void)cancel
{
	[self cancel:false];
}

- (void)cancel:(bool)bTriggerCancellationError
{
	if(m_pRequest)
	{
		[m_pRequest cancel:false];
		self.succeeded = false;
		self.error = @"canceled";
		if(bTriggerCancellationError && m_pDelegate)
			[m_pDelegate onStaticContentDownloadCompleted:self];
		m_pRequest = nil;
	}
	[self removeFromQueue];
}

- (void)requestDidComplete:(STSURLRequest *)pRequest
{
	NSString * szError = nil;
	bool bCanceled = false;
	
	switch([pRequest result])
	{
		case STSURLRequestFailed:
			// umphf
			szError = [pRequest failureReason];
		break;
		case STSURLRequestSucceeded:
		{
			// kill the output file
			[[NSFileManager defaultManager] removeItemAtPath:m_szSavePath error:NULL];

			// create the output directory, if needed
			NSString * szDir = [m_szSavePath stringByDeletingLastPathComponent];
			if(szDir)
				[[NSFileManager defaultManager] createDirectoryAtPath:szDir withIntermediateDirectories:YES attributes:nil error:nil];
			
			NSError * pError = nil;
			
			// move the temporary file to the target save path
			if(![[NSFileManager defaultManager] moveItemAtPath:m_szTemporaryPath toPath:m_szSavePath error:&pError])
			{
				if(pError)
				{
					STS_CORE_LOG_ERROR(@"ERROR: Failed to move file %@ to %@: %@",m_szTemporaryPath,m_szSavePath,[pError localizedDescription]);
					szError = [NSString stringWithFormat:@"Failed to move the file: %@", [pError localizedDescription]];
				} else {
					STS_CORE_LOG_ERROR(@"ERROR: Failed to move file %@ to %@: Unknown error",m_szTemporaryPath,m_szSavePath);
					szError = @"Failed to move the file";
				}
			} else {
				// Mark the file as "skip iCloud backup" otherwise the apple reviewers will reject the app
				[STSFile addSkipBackupAttributeToFileAtPath:m_szSavePath];
			}
		}
		break;
		case STSURLRequestCanceled:
			// well...
			bCanceled = true;
		break;
		default:
			// aargh
			assert(false); // this shouldn't happen
			szError = @"Internal error";
		break;
	}

	m_pRequest = nil;

	// kill the temporary file anyway
	[[NSFileManager defaultManager] removeItemAtPath:m_szTemporaryPath error:NULL];

	if(bCanceled)
	{
		self.succeeded = false;
		self.error = @"canceled";
	} else if(szError)
	{
		self.succeeded = false;
		self.error = szError;
		if(m_pDelegate)
			[m_pDelegate onStaticContentDownloadCompleted:self];
	} else {
		self.succeeded = true;
		self.error = nil;
		if(m_pDelegate)
			[m_pDelegate onStaticContentDownloadCompleted:self];
	}

	[self removeFromQueue];
}


@end
