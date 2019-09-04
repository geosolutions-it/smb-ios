//
//  STSDownloader.m
//
//  Created by Szymon Tomasz Stefanek on 6/20/13.
//  Copyright © 2013 Szymon Tomasz Stefanek. All rights reserved.
//

#import "STSDownload.h"
#import "STSDownloadQueue.h"

@interface STSDownload()
{
	__weak STSDownloadQueue * m_pQueue;
}

@end

@implementation STSDownload

@synthesize priority;
@synthesize tag;
@synthesize payload;

- (id)init
{
	self = [super init];
	if(!self)
		return nil;
	m_pQueue = nil;
    self.priority = 1;
	self.tag = -1;
	self.payload = nil;
	return self;
}

- (void)dealloc
{
	if(m_pQueue)
		[m_pQueue _removeDownload:self];

	self.payload = nil; // forget it, in case it's set
}

- (void)addToQueue:(STSDownloadQueue *)pQueue
{
	m_pQueue = pQueue;
	if(m_pQueue)
		[m_pQueue _addDownload:self];
}

- (void)removeFromQueue
{
	if(m_pQueue)
	{
		[m_pQueue _removeDownload:self];
		m_pQueue = nil;
	}
}

- (bool)start
{
	STS_CORE_LOG_ERROR(@"[STSDownloader] ERROR: start called on pure STSDownloader class");
	return false;
}

- (bool)start:(bool)bTriggerErrorInCaseOfFailure
{
	STS_CORE_LOG_ERROR(@"[STSDownloader] ERROR: start called on pure STSDownloader class");
	return false;
}

- (void)cancel
{
	STS_CORE_LOG_ERROR(@"[STSDownloader] ERROR: cancel called on pure STSDownloader class");
}

- (void)cancel:(bool)bTriggerCancellationError
{
	STS_CORE_LOG_ERROR(@"[STSDownloader] ERROR: cancel called on pure STSDownloader class");
}


@end
