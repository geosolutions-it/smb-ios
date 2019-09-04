//
//  STSCore.m
//
//  Created by Szymon Tomasz Stefanek on 5/31/18.
//  Copyright © 2018 Szymon Tomasz Stefanek. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "STSCore.h"


#ifdef STS_CORE_ENABLE_LOGGING

static NSString * g_szSTSCoreLogPrefix = @"";

@implementation STSCoreLog

+ (NSString *)logPrefix
{
	return g_szSTSCoreLogPrefix;
}

+ (void)logPush
{
	g_szSTSCoreLogPrefix = [g_szSTSCoreLogPrefix stringByAppendingString:@"  "];
}

+ (void)logPop
{
	if(g_szSTSCoreLogPrefix.length > 2)
		g_szSTSCoreLogPrefix = [g_szSTSCoreLogPrefix substringToIndex:g_szSTSCoreLogPrefix.length - 2];
	else
		g_szSTSCoreLogPrefix = @"";
}

@end


#endif
