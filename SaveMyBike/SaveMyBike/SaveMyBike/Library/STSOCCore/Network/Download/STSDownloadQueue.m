//
//  STSDownloaderQueue.m
//
//  Created by Szymon Tomasz Stefanek on 6/20/13.
//  Copyright © 2013 Szymon Tomasz Stefanek. All rights reserved.
//

#import "STSDownloadQueue.h"

#import "STSDownload.h"

@interface STSDownloadQueue()
{
	NSMutableArray * m_pWaitingQueue;
	NSMutableArray * m_pRunningQueue;
}

- (void)dealloc;

- (void)_handleQueue;

@end

@implementation STSDownloadQueue

@synthesize parallelDownloadCount;

- (id)init
{
	self = [super init];
	if(!self)
		return nil;
	m_pWaitingQueue = [NSMutableArray array];
	m_pRunningQueue = [NSMutableArray array];
	self.parallelDownloadCount = 1;
	return self;
}

- (void)dealloc
{
	[self cancelAllDownloads:false];
	m_pRunningQueue = nil;
	m_pWaitingQueue = nil;
}

- (void)cancelAllDownloads:(bool)bTriggerCancellationErrors
{
	if(m_pWaitingQueue)
	{
		while(m_pWaitingQueue.count > 0)
			[((STSDownload *)[m_pWaitingQueue objectAtIndex:0]) cancel:bTriggerCancellationErrors];
		[m_pWaitingQueue removeAllObjects];
	}
	if(m_pRunningQueue)
	{
		while(m_pRunningQueue.count > 0)
			[((STSDownload *)[m_pRunningQueue objectAtIndex:0]) cancel:bTriggerCancellationErrors];
		[m_pRunningQueue removeAllObjects];
	}
}

- (void)_addDownload:(STSDownload *)pDownloader
{
    int i = 0;
    int c = [m_pWaitingQueue count];
    
    while(i < c)
    {
        STSDownload * pExistingDownload = [m_pWaitingQueue objectAtIndex:i];
        if(pExistingDownload.priority < pDownloader.priority)
        {
            [m_pWaitingQueue insertObject:pDownloader atIndex:i];
            break;
        }
        i++;
    }

    if(i >= c)
        [m_pWaitingQueue addObject:pDownloader];
	[self _handleQueue];
}

- (void)_removeDownload:(STSDownload *)pDownloader
{
	[m_pWaitingQueue removeObject:pDownloader];
	[m_pRunningQueue removeObject:pDownloader];
	[self _handleQueue];
}

- (void)_handleQueue
{
	while([m_pRunningQueue count] < self.parallelDownloadCount)
	{
		if([m_pWaitingQueue count] < 1)
			return;

		STSDownload * pDownloader = [m_pWaitingQueue objectAtIndex:0];
		[m_pWaitingQueue removeObjectAtIndex:0];
	
		if([pDownloader start:true])
			[m_pRunningQueue addObject:pDownloader];
	}
}

@end
