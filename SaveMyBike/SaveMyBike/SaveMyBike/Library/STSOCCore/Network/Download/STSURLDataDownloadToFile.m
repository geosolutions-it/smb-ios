//
//  STSURLDataDownloadToFileer.m
//
//  Created by Szymon Tomasz Stefanek on 6/20/13.
//  Copyright (c) 2013 Szymon Tomasz Stefanek. All rights reserved.
//

#import "STSURLDataDownloadToFile.h"

#import "STSFile.h"

#import "NSString+URL.h"

@interface STSURLDataDownloadToFile()
{
	STSURLRequest * m_pRequest;
}

- (void)requestDidComplete:(STSURLRequest *)pRequest;

@end

@implementation STSURLDataDownloadToFile


- (void)setDelegate:(NSObject<STSURLDataDownloadToFileDelegate> *__weak)pDelegate
{
	self.delegate = pDelegate;
}

- (bool)start
{
	return [self start:false];
}

- (bool)start:(bool)bTriggerErrorInCaseOfFailure;
{
	if(m_pRequest)
		[m_pRequest cancel:false];
	
	m_pRequest = [self _createRequest];
	
	[m_pRequest setOutputMode:STSURLRequestOutputToFile];

	[m_pRequest setOutputFileName:self.temporaryPath];
	[m_pRequest setCompletionHandlerDelegate:self];

	if(![m_pRequest start])
	{
		STS_CORE_LOG_ERROR(@"ERROR: Failed to start the image download request for url %@, error: %@",self.URL,[m_pRequest failureReason]);
		self.succeeded = false;
		self.error = m_pRequest.failureReason;
		
		if(bTriggerErrorInCaseOfFailure && self.delegate)
			[self.delegate onURLDataDownloadToFileCompleted:self];
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
		if(bTriggerCancellationError && self.delegate)
			[self.delegate onURLDataDownloadToFileCompleted:self];
		m_pRequest = nil;
	}
	[self removeFromQueue];
}

- (void)requestDidComplete:(STSURLRequest *)pRequest
{
	NSString * szError = nil;
	bool bCanceled = false;
	
	self.statusCode = pRequest.statusCode;
	
	switch([pRequest result])
	{
		case STSURLRequestFailed:
			// umphf
			szError = [pRequest failureReason];
		break;
		case STSURLRequestSucceeded:
		{
			// kill the output file
			[[NSFileManager defaultManager] removeItemAtPath:self.savePath error:NULL];

			// create the output directory, if needed
			NSString * szDir = [self.savePath stringByDeletingLastPathComponent];
			if(szDir)
				[[NSFileManager defaultManager] createDirectoryAtPath:szDir withIntermediateDirectories:YES attributes:nil error:nil];
			
			NSError * pError = nil;
			
			// move the temporary file to the target save path
			if(![[NSFileManager defaultManager] moveItemAtPath:self.temporaryPath toPath:self.savePath error:&pError])
			{
				if(pError)
				{
					STS_CORE_LOG_ERROR(@"ERROR: Failed to move file %@ to %@: %@",self.temporaryPath,self.savePath,[pError localizedDescription]);
					szError = [NSString stringWithFormat:@"Failed to move the file: %@", [pError localizedDescription]];
				} else {
					STS_CORE_LOG_ERROR(@"ERROR: Failed to move file %@ to %@: Unknown error",self.temporaryPath,self.savePath);
					szError = @"Failed to move the file";
				}
			} else {
				// Mark the file as "skip iCloud backup" otherwise the apple reviewers will reject the app
				[STSFile addSkipBackupAttributeToFileAtPath:self.savePath];
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
	[[NSFileManager defaultManager] removeItemAtPath:self.temporaryPath error:NULL];

	if(bCanceled)
	{
		self.succeeded = false;
		self.error = @"canceled";
	} else if(szError)
	{
		self.succeeded = false;
		self.error = szError;
		if(self.delegate)
			[self.delegate onURLDataDownloadToFileCompleted:self];
	} else {
		self.succeeded = true;
		self.error = nil;
		if(self.delegate)
			[self.delegate onURLDataDownloadToFileCompleted:self];
	}

	[self removeFromQueue];
}


@end
