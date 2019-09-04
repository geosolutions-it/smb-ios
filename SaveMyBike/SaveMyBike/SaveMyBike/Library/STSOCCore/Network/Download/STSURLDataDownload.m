//
//  STSURLDataDownload.m
//
//  Created by Szymon Tomasz Stefanek on 9/1/18.
//  Copyright © 2018 Szymon Tomasz Stefanek. All rights reserved.
//

#import "STSURLDataDownload.h"

#import "STSURLRequest.h"
#import "STSJSONParser.h"

#import "NSString+URL.h"


@interface STSURLDataDownload()
{
	STSURLRequest * m_pRequest;
}

- (void)requestDidComplete:(STSURLRequest *)pRequest;
- (void)request:(STSURLRequest *)pRequest didReceiveData:(NSData *)data;

@end

@implementation STSURLDataDownload

- (NSString *)dataAsString
{
	if(!self.data)
		return @"";

	NSString * r = [[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding];
	if(!r)
	{
		r = [[NSString alloc] initWithData:self.data encoding:NSISOLatin1StringEncoding];
		if(!r)
		{
			r = [[NSString alloc] initWithData:self.data encoding:NSASCIIStringEncoding];
			if(!r)
				return @"";
		}
	}

	return [r stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
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
	
	[m_pRequest setCompletionHandlerDelegate:self];
	[m_pRequest setDataHandlerDelegate:self];

	[m_pRequest setOutputMode:STSURLRequestOutputToDelegate];
	
	if(![m_pRequest start])
	{
		STS_CORE_LOG_ERROR(@"ERROR: Failed to start the URL data download request for url %@, error: %@",self.URL,[m_pRequest failureReason]);
		self.error = m_pRequest.failureReason;
		self.succeeded = false;
		if(bTriggerErrorInCaseOfFailure && self.delegate)
			[self.delegate onURLDataDownloadCompleted:self];
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
		self.error = @"canceled";
		self.succeeded = false;
		if(bTriggerCancellationError && self.delegate)
			[self.delegate onURLDataDownloadCompleted:self];
		m_pRequest = nil;
	}
	[self removeFromQueue];
}

- (void)requestDidComplete:(STSURLRequest *)pRequest
{
	if(m_pRequest && self.delegate)
	{
		self.statusCode = pRequest.statusCode;

		assert(m_pRequest == pRequest);
	
		switch([pRequest result])
		{
			case STSURLRequestSucceeded:
				// okz!
				break;
			case STSURLRequestFailed:
				self.error = pRequest.failureReason;
				self.succeeded = false;
				if(self.delegate)
					[self.delegate onURLDataDownloadCompleted:self];
				break;
			case STSURLRequestCanceled:
				// this shouldn't happen.. but well.. we ignore this
				break;
			default:
				self.error = @"unknown error";
				self.succeeded = false;
				if(self.delegate)
					[self.delegate onURLDataDownloadCompleted:self];
				break;
		}
	
		m_pRequest = nil;
	}

	[self removeFromQueue];
}

- (void)request:(STSURLRequest *)pRequest didReceiveData:(NSData *)data
{
	if(!m_pRequest)
		return; // canceled
	
	assert(m_pRequest == pRequest);
	
	self.data = data;
	self.error = nil;
	self.succeeded = true;
	
	if(self.delegate)
		[self.delegate onURLDataDownloadCompleted:self];
}


@end
