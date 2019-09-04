//
//  Created by Szymon Tomasz Stefanek
//  Copyright (c) 2018 Szymon Tomasz Stefanek. All rights reserved.
//

#import "STSErrorStack.h"

@implementation STSErrorStack
{
	NSMutableArray<NSString *> * m_lErrors;
}

- (id)init
{
	self = [super init];
	if(!self)
		return nil;
	
	m_lErrors = [NSMutableArray new];
	
	return self;
}

- (void)pushError:(NSString *)szError
{
	[m_lErrors addObject:szError];
}

- (void)setError:(NSString *)szError
{
	[m_lErrors removeAllObjects];
	[m_lErrors addObject:szError];
}

- (void)clear
{
	[m_lErrors removeAllObjects];
}

- (bool)isEmpty
{
	return m_lErrors.count == 0;
}

- (NSString *)buildMessage:(NSString *)szTopLevel
{
	NSMutableString * s = [NSMutableString stringWithCapacity:200];
	
	if(szTopLevel)
		[s appendString:szTopLevel];

	for(NSString * ss in m_lErrors)
	{
		if(s.length > 0)
			[s appendString:@"\n"];
		[s appendString:ss];
	}
	
	return s;
}

- (NSString *)buildMessage
{
	return [self buildMessage:nil];
}

@end
