//
//  STSNetworkAvailabilityChecker.h
//
//  Created by Szymon Tomasz Stefanek on 05/12/12.
//  Copyright (c) 2012 Szymon Tomasz Stefanek. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <SystemConfiguration/SystemConfiguration.h>

#import "STSCore.h"

@interface STSNetworkAvailabilityChecker : NSObject
{
	@private
		int m_iHeartbeatTimeout;
		NSTimer * m_pHeartbeatTimer;
		SCNetworkReachabilityRef m_oNetworkReachabilityRef;
}

+ (void)startWithInterval:(int)iCheckIntervalInSeconds;
+ (void)stop;

+ (bool)networkAvailable;

@end
