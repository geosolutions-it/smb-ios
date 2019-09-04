//
//  STSURLJSONObjectDownload.m
//
//  Created by Szymon Tomasz Stefanek on 9/1/18.
//  Copyright © 2018 Szymon Tomasz Stefanek
//

#import "STSURLJSONObjectDownload.h"

#import "STSURLRequest.h"
#import "STSJSONParser.h"

#import "NSString+URL.h"


@interface STSURLJSONObjectDownload()
{
	STSURLRequest * m_pRequest;
}

- (void)requestDidComplete:(STSURLRequest *)pRequest;
- (void)request:(STSURLRequest *)pRequest didReceiveData:(NSData *)data;

@end

@implementation STSURLJSONObjectDownload

- (id)init
{
	self = [super init];
	if(!self)
		return nil;
	
	self.acceptEmptyResponse = false;
	
	return self;
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
	
	[m_pRequest setOutputMode:STSURLRequestOutputToDelegate];

	[m_pRequest setCompletionHandlerDelegate:self];
	[m_pRequest setDataHandlerDelegate:self];

	STS_CORE_LOG(@"Starting JSON request for %@",self.URL);
	
	if(![m_pRequest start])
	{
		STS_CORE_LOG_ERROR(@"ERROR: Failed to start the JSON download request for url %@, error: %@",self.URL,[m_pRequest failureReason]);
		self.error = m_pRequest.failureReason;
		self.succeeded = false;
		if(bTriggerErrorInCaseOfFailure && self.delegate)
			[self.delegate onURLJSONObjectDownloadCompleted:self];
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
			[self.delegate onURLJSONObjectDownloadCompleted:self];
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
					[self.delegate onURLJSONObjectDownloadCompleted:self];
				break;
			case STSURLRequestCanceled:
				// this shouldn't happen.. but well.. we ignore this
				break;
			default:
				self.error = @"unknown error";
				self.succeeded = false;
				if(self.delegate)
					[self.delegate onURLJSONObjectDownloadCompleted:self];
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
	STS_CORE_LOG(@"[STSURLJSONObjectDownload] JSON Received:\n%@\n",szJSON);
#endif // STS_CORE_ENABLE_LOGGING_FOR_RECEIVED_JSON

	STSJSONParser * pJSONParser = [[STSJSONParser alloc] init];
	
	id ob = [pJSONParser objectWithData:data];
	if(!ob)
	{
		if(self.acceptEmptyResponse && (data.length < 1))
		{
			// epmty object
			ob = [NSMutableDictionary new];
		} else {
			if(self.delegate)
			{
				self.error = [NSString stringWithFormat:@"Document JSON parse error: %@",[pJSONParser error]];
				self.succeeded = false;
				[self.delegate onURLJSONObjectDownloadCompleted:self];
				self.delegate = nil;
			}
			[m_pRequest cancel:false];
			m_pRequest = nil;
			return;
		}
	}
	
	self.object = ob;
	self.error = nil;
	self.succeeded = true;
	
	if(self.delegate)
		[self.delegate onURLJSONObjectDownloadCompleted:self];

	pJSONParser = nil;
}


@end

