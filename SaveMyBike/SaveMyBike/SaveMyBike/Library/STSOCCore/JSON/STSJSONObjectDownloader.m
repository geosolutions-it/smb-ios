//
//  STSJSONObjectDownloader.m
//
//  
//  Created by Szymon Tomasz Stefanek
//  Copyright (c) 2012 Szymon Tomasz Stefanek. All rights reserved.
//

#import "STSJSONObjectDownloader.h"

#import "STSURLRequest.h"
#import "STSJSONParser.h"

#import "STSCore.h"

#import "NSString+URL.h"

@implementation STSJSONObjectDownloader

- (bool)startWithURL:(NSString *)szUrl httpMethod:(NSString *)szMethod httpBody:(NSData *)pBody andDelegate:(__unsafe_unretained id<STSJSONObjectDownloaderDelegate>)pDelegate;
{
	assert(szUrl);
	assert(pDelegate);

	m_pDelegate = pDelegate;
	
	if(m_pRequest)
		[m_pRequest cancel:false];
	
	m_pRequest = [[STSURLRequest alloc] init];
	
	[m_pRequest setTargetURL:[szUrl toURL]];
	[m_pRequest setOutputMode:STSURLRequestOutputToDelegate];
	[m_pRequest setCompletionHandlerDelegate:self];
	[m_pRequest setDataHandlerDelegate:self];
	if(szMethod)
		[m_pRequest setHttpMethod:szMethod];
	if(pBody)
		[m_pRequest setHttpBody:pBody];

	#ifdef STS_CORE_ENABLE_LOGGING_JSON_ACTIVITY
		STS_CORE_LOG(@"Starting JSON request for %@",szUrl);
	#endif
	
	if(![m_pRequest start])
	{
		STS_CORE_LOG_ERROR(@"ERROR: Failed to start the JSON download request for url %@, error: %@",szUrl,[m_pRequest failureReason]);
		return false;
	}
	
	return true;
}

- (bool)startWithURL:(NSString *)szUrl andDelegate:(__unsafe_unretained id<STSJSONObjectDownloaderDelegate>)pDelegate
{
	return [self startWithURL:szUrl httpMethod:@"GET" httpBody:nil andDelegate:pDelegate];
}

- (void)cancel
{
	if(m_pRequest)
		[m_pRequest cancel:false];
	m_pRequest = nil;

	m_pDelegate = nil;
}

- (bool)isRunning
{
	return (m_pRequest != nil);
}


#pragma mark - STSURLRequestCompletionHandlerDelegate

- (void)requestDidComplete:(STSURLRequest *)pRequest
{
	if(!m_pRequest)
		return; // canceled
	if(!m_pDelegate)
		return; // failed early: nothing else to do here
	
	assert(m_pRequest == pRequest);
	
	switch([pRequest result])
	{
		case STSURLRequestSucceeded:
			// okz!
			break;
		case STSURLRequestFailed:
			if(m_pDelegate)
				[m_pDelegate downloadFailed:[pRequest failureReason]];
			break;
		case STSURLRequestCanceled:
			// this shouldn't happen.. but well.. we ignore this			
			break;
		default:
			if(m_pDelegate)
				[m_pDelegate downloadFailed:@"Unknown error"];
			break;
	}
	
	m_pRequest = nil;
}


#pragma mark - STSURLRequestDataHandlerDelegate

- (void)request:(STSURLRequest *)pRequest didReceiveData:(NSData *)data
{
	if(!m_pRequest)
		return; // canceled
	
	assert(m_pRequest == pRequest);
	
	#ifdef STS_CORE_ENABLE_LOGGING_JSON_ACTIVITY
		NSString * szJSON = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		STS_CORE_LOG(@"JSON Received:\n%@\n",szJSON);
	#endif // STS_CORE_ENABLE_LOGGING_JSON_ACTIVITY

	STSJSONParser * pJSONParser = [[STSJSONParser alloc] init];
	
	id ob = [pJSONParser objectWithData:data];
	if(!ob)
	{
		if(m_pDelegate)
		{
			[m_pDelegate downloadFailed:[NSString stringWithFormat:@"Document JSON parse error: %@",[pJSONParser error]]];
			m_pDelegate = nil;
		}
		[m_pRequest cancel:false];
		m_pRequest = nil;
		return;
	}
	
	if(m_pDelegate)
		[m_pDelegate downloadSucceeded:ob];

	pJSONParser = nil;
}

@end
