//
//  STSNetworkAvailabilityChecker.m
//
//  Created by Szymon Tomasz Stefanek on 05/12/12.
//  Copyright (c) 2012 Szymon Tomasz Stefanek. All rights reserved.
//

#import "STSNetworkAvailabilityChecker.h"

//#define STS_CORE_ENABLE_NETWORK_AVAILABILITY_CHECK_LOGGING

static STSNetworkAvailabilityChecker * g_pChecker = nil;
static bool g_bNetworkAvailable = false;

@interface STSNetworkAvailabilityChecker()

- (id)init;
- (void)dealloc;

- (void)_startWithInterval:(int)iCheckIntervalInSeconds;
- (void)_stop;

- (void)_scheduleCheck;
- (void)_abortCheck;
- (void)_checkCompleted;

@end

@implementation STSNetworkAvailabilityChecker

- (id)init
{
	self = [super init];
	if(!self)
		return nil;
#ifdef STS_CORE_ENABLE_NETWORK_AVAILABILITY_CHECK_LOGGING
	STS_CORE_LOG(@"[STSNetworkAvailabilityChecker] init");
#endif //STS_CORE_ENABLE_NETWORK_AVAILABILITY_CHECK_LOGGING
	m_pHeartbeatTimer = nil;
	m_oNetworkReachabilityRef = NULL;
	g_pChecker = self;
	return self;
}

- (void)dealloc
{
	if(m_pHeartbeatTimer)
	{
		[m_pHeartbeatTimer invalidate];
		m_pHeartbeatTimer = nil;
	}

#ifdef STS_CORE_ENABLE_NETWORK_AVAILABILITY_CHECK_LOGGING
	STS_CORE_LOG(@"[STSNetworkAvailabilityChecker] dealloc");
#endif //STS_CORE_ENABLE_NETWORK_AVAILABILITY_CHECK_LOGGING

	if(g_pChecker == self)
		g_pChecker = nil;
}


- (void)_startWithInterval:(int)iCheckIntervalInSeconds
{
#ifdef STS_CORE_ENABLE_NETWORK_AVAILABILITY_CHECK_LOGGING
	STS_CORE_LOG(@"[STSNetworkAvailabilityChecker] _startWithInterval:%d",iCheckIntervalInSeconds);
#endif //STS_CORE_ENABLE_NETWORK_AVAILABILITY_CHECK_LOGGING

	m_iHeartbeatTimeout = iCheckIntervalInSeconds;

	[self _startCheck];
}


- (void)_stop
{
#ifdef STS_CORE_ENABLE_NETWORK_AVAILABILITY_CHECK_LOGGING
	STS_CORE_LOG(@"[STSNetworkAvailabilityChecker] _stop");
#endif //STS_CORE_ENABLE_NETWORK_AVAILABILITY_CHECK_LOGGING

	if(m_pHeartbeatTimer || m_oNetworkReachabilityRef)
		[self _abortCheck];

	g_pChecker = nil;
}


static void ReachabilityCallback(SCNetworkReachabilityRef target, SCNetworkReachabilityFlags flags, void* info)
{
#ifdef STS_CORE_ENABLE_NETWORK_AVAILABILITY_CHECK_LOGGING
	STS_CORE_LOG(@"[STSNetworkAvailabilityChecker] ReachabilityCheckCallback");
#endif //STS_CORE_ENABLE_NETWORK_AVAILABILITY_CHECK_LOGGING

    g_bNetworkAvailable = (flags & kSCNetworkFlagsReachable) && !(flags & kSCNetworkFlagsConnectionRequired);
	if(g_pChecker)
		[g_pChecker _checkCompleted];
}

- (void)_abortCheck
{
#ifdef STS_CORE_ENABLE_NETWORK_AVAILABILITY_CHECK_LOGGING
	STS_CORE_LOG(@"[STSNetworkAvailabilityChecker] _abortCheck");
#endif //STS_CORE_ENABLE_NETWORK_AVAILABILITY_CHECK_LOGGING

	if(m_pHeartbeatTimer)
	{
		[m_pHeartbeatTimer invalidate];
		m_pHeartbeatTimer = nil;
	}

    if(m_oNetworkReachabilityRef)
	{
        SCNetworkReachabilityUnscheduleFromRunLoop(m_oNetworkReachabilityRef, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
		CFRelease(m_oNetworkReachabilityRef);
		m_oNetworkReachabilityRef = NULL;
	}
}

- (void)_startCheck
{
#ifdef STS_CORE_ENABLE_NETWORK_AVAILABILITY_CHECK_LOGGING
	STS_CORE_LOG(@"[STSNetworkAvailabilityChecker] _startCheck");
#endif //STS_CORE_ENABLE_NETWORK_AVAILABILITY_CHECK_LOGGING

	if(m_pHeartbeatTimer || m_oNetworkReachabilityRef)
		[self _abortCheck];

    SCNetworkReachabilityContext context = {0, (__bridge void *)(self), NULL, NULL, NULL};

	m_oNetworkReachabilityRef = SCNetworkReachabilityCreateWithName(NULL, "google.com");

	if(!m_oNetworkReachabilityRef)
	{
		STS_CORE_LOG_ERROR(@"ERROR: Aaargh.. can't check online status?");
		g_bNetworkAvailable = NO;
		[self _scheduleCheck];
		return;
	}

    if(!SCNetworkReachabilitySetCallback(m_oNetworkReachabilityRef, ReachabilityCallback, &context))
	{
		STS_CORE_LOG_ERROR(@"ERROR: Aaargh.. can't check online status?");
		g_bNetworkAvailable = NO;
		[self _scheduleCheck];
		return;
	}

	if(!SCNetworkReachabilityScheduleWithRunLoop(m_oNetworkReachabilityRef, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode))
	{
		STS_CORE_LOG_ERROR(@"ERROR: Aaargh.. can't check online status?");
		g_bNetworkAvailable = NO;
		[self _scheduleCheck];
		return;
    }
}

- (void)_checkCompleted
{
#ifdef STS_CORE_ENABLE_NETWORK_AVAILABILITY_CHECK_LOGGING
	STS_CORE_LOG(@"[STSNetworkAvailabilityChecker] _checkCompleted");
#endif //STS_CORE_ENABLE_NETWORK_AVAILABILITY_CHECK_LOGGING

	if(m_pHeartbeatTimer || m_oNetworkReachabilityRef)
		[self _abortCheck];

	[self _scheduleCheck];
}

- (void)_scheduleCheck
{
#ifdef STS_CORE_ENABLE_NETWORK_AVAILABILITY_CHECK_LOGGING
	STS_CORE_LOG(@"[STSNetworkAvailabilityChecker] _scheduleCheck");
#endif //STS_CORE_ENABLE_NETWORK_AVAILABILITY_CHECK_LOGGING

	if(m_pHeartbeatTimer || m_oNetworkReachabilityRef)
		[self _abortCheck];

	m_pHeartbeatTimer = [NSTimer scheduledTimerWithTimeInterval:(double)m_iHeartbeatTimeout target:self selector:@selector(_startCheck) userInfo:nil repeats:NO];
}


+ (bool)networkAvailable
{
	return g_bNetworkAvailable;
}


+ (void)startWithInterval:(int)iCheckIntervalInSeconds
{
	if(!g_pChecker)
		g_pChecker = [[STSNetworkAvailabilityChecker alloc] init];
	
	[g_pChecker _startWithInterval:iCheckIntervalInSeconds];
}

+ (void)stop
{
	if(!g_pChecker)
		return;
	[g_pChecker _stop];
}

@end
