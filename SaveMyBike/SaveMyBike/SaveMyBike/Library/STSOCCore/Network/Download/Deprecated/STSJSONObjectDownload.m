//
//  STSJSONObjectDownload.m
//
//  Created by Szymon Tomasz Stefanek on 6/20/13.
//  Copyright © 2013 Szymon Tomasz Stefanek. All rights reserved.
//


#import "STSJSONObjectDownload.h"

#import "STSURLRequest.h"
#import "STSJSONParser.h"

#import "NSString+URL.h"


@interface STSJSONObjectDownload()
{
	NSString * m_szMethod;
	NSString * m_szUrl;
	NSMutableDictionary<NSString *,NSString *> * m_pHeaders;
	NSData * m_pBody;
	STSURLRequest * m_pRequest;
	__weak NSObject<STSJSONObjectDownloadDelegate> * m_pDelegate;
}

- (void)requestDidComplete:(STSURLRequest *)pRequest;
- (void)request:(STSURLRequest *)pRequest didReceiveData:(NSData *)data;

@end

@implementation STSJSONObjectDownload

- (void)setURL:(NSString *)szURL
{
	m_szUrl = szURL;
}

- (void)setBody:(NSData *)pBody
{
	m_pBody = pBody;
}

- (void)setMethod:(NSString *)szMethod
{
	m_szMethod = szMethod;
}

- (void)setDelegate:(__weak NSObject<STSJSONObjectDownloadDelegate> *)pDelegate
{
	m_pDelegate = pDelegate;
}

- (void)addHeader:(NSString *)szHeader withValue:(NSString *)szValue
{
	if(!m_pHeaders)
		m_pHeaders = [NSMutableDictionary new];
	[m_pHeaders setObject:szValue forKey:szHeader];
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
	
	[m_pRequest setTargetURL:[m_szUrl toURL]];
	[m_pRequest setOutputMode:STSURLRequestOutputToDelegate];
	[m_pRequest setCompletionHandlerDelegate:self];
	[m_pRequest setDataHandlerDelegate:self];
	if(m_szMethod)
		[m_pRequest setHttpMethod:m_szMethod];
	if(m_pBody)
		[m_pRequest setHttpBody:m_pBody];
	if(m_pHeaders)
		[m_pRequest setHeaders:m_pHeaders];

	STS_CORE_LOG(@"Starting JSON request for %@",m_szUrl);
	
	if(![m_pRequest start])
	{
		STS_CORE_LOG_ERROR(@"ERROR: Failed to start the JSON download request for url %@, error: %@",m_szUrl,[m_pRequest failureReason]);
		self.error = m_pRequest.failureReason;
		self.succeeded = false;
		if(bTriggerErrorInCaseOfFailure && m_pDelegate)
			[m_pDelegate onJSONObjectDownloadCompleted:self];
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
		if(bTriggerCancellationError && m_pDelegate)
			[m_pDelegate onJSONObjectDownloadCompleted:self];
		m_pRequest = nil;
	}
	[self removeFromQueue];
}

- (void)requestDidComplete:(STSURLRequest *)pRequest
{
	if(m_pRequest && m_pDelegate)
	{
		assert(m_pRequest == pRequest);
	
		switch([pRequest result])
		{
			case STSURLRequestSucceeded:
				// okz!
				break;
			case STSURLRequestFailed:
				self.error = pRequest.failureReason;
				self.succeeded = false;
				if(m_pDelegate)
					[m_pDelegate onJSONObjectDownloadCompleted:self];
				break;
			case STSURLRequestCanceled:
				// this shouldn't happen.. but well.. we ignore this
				break;
			default:
				self.error = @"unknown error";
				self.succeeded = false;
				if(m_pDelegate)
					[m_pDelegate onJSONObjectDownloadCompleted:self];
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
	
#ifdef STS_CORE_ENABLE_LOGGING_FOR_RECEIVED_JSON
	NSString * szJSON = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	STS_CORE_LOG(@"[STSJSONObjectDownload] JSON Received:\n%@\n",szJSON);
#endif // STS_CORE_ENABLE_LOGGING_FOR_RECEIVED_JSON

	STSJSONParser * pJSONParser = [[STSJSONParser alloc] init];
	
	id ob = [pJSONParser objectWithData:data];
	if(!ob)
	{
		if(m_pDelegate)
		{
			self.error = [NSString stringWithFormat:@"Document JSON parse error: %@",[pJSONParser error]];
			self.succeeded = false;
			[m_pDelegate onJSONObjectDownloadCompleted:self];
			m_pDelegate = nil;
		}
		[m_pRequest cancel:false];
		m_pRequest = nil;
		return;
	}
	
	self.object = ob;
	self.error = nil;
	self.succeeded = true;
	
	if(m_pDelegate)
		[m_pDelegate onJSONObjectDownloadCompleted:self];

	pJSONParser = nil;
}


@end
