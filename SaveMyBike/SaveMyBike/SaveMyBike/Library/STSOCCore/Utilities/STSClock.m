//
//  STSClock.m
//
//  Created by Szymon Tomasz Stefanek on 12/27/17.
//  Copyright © 2017 Szymon Tomasz Stefanek. All rights reserved.
//

#import "STSClock.h"

#import <mach/mach_time.h>

static mach_timebase_info_data_t g_timeBaseInfo;
static bool g_bTimeBaseInfoInited = false;

@implementation STSClock

+ (long long)elapsedTimeMillis
{
	if(!g_bTimeBaseInfoInited)
	{
		mach_timebase_info(&g_timeBaseInfo);
		g_bTimeBaseInfoInited = true;
	}
	uint64_t elapsedTimeNano = mach_absolute_time() * g_timeBaseInfo.numer / g_timeBaseInfo.denom;
	return (long long)(elapsedTimeNano / 1000000LL);
}

@end
