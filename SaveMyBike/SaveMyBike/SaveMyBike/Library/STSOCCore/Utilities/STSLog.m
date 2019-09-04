//
//  STSLog.m
//
//  Copyright © 2013 Szymon Tomasz Stefanek. All rights reserved.
//

#import "STSLog.h"

@interface STSLog ()
{
	NSString * m_sTag;
}
@end

@implementation STSLog

- (id)initWithTag:(NSString *)sTag
{
	self = [super init];
	if(self)
	{
		m_sTag = sTag;
	}
	return self;
}

- (void)log:(NSString *)sLog, ...
{
	va_list args;
	va_start(args, sLog);

	NSLog(@"[%@] %@", m_sTag, [[NSString alloc] initWithFormat:sLog arguments:args]);

	va_end(args);
}

- (void)log:(NSString *)sWhere message:(NSString *)sLog, ...
{
	va_list args;
	va_start(args, sLog);

	NSLog(@"[%@] %@ %@", m_sTag, sWhere, [[NSString alloc] initWithFormat:sLog arguments:args]);

	va_end(args);
}

- (void)logError:(NSString *)sLog, ...
{
	va_list args;
	va_start(args, sLog);

	NSLog(@"[ERROR] [%@] %@", m_sTag, [[NSString alloc] initWithFormat:sLog arguments:args]);

	va_end(args);
}

- (void)logError:(NSString *)sWhere message:(NSString *)sLog, ...
{
	va_list args;
	va_start(args, sLog);

	NSLog(@"[ERROR] [%@] %@ %@", m_sTag, sWhere, [[NSString alloc] initWithFormat:sLog arguments:args]);

	va_end(args);
}

@end
