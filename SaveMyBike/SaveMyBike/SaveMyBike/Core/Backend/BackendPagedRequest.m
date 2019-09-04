//
//  BackendPagedRequest.m
//  SaveMyBike
//
//  Created by Szymon Tomasz Stefanek on 06/07/2019.
//  Copyright © 2019 GeoSolutions SaS. All rights reserved.
//

#import "BackendPagedRequest.h"

#import "STSTypeConversion.h"
#import "STSI18N.h"

@implementation BackendPagedRequest

- (id)init
{
	self = [super init];
	if(!self)
		return nil;
	
	self.page = 1;
	self.page_size = 1000;
	
	return self;
}

- (NSMutableArray<id<JSONConvertible>> *)decodePagedResult:(id)ob arrayMember:(NSString *)sArrayMember itemClass:(Class)oClass
{
	NSDictionary * d = [STSTypeConversion objectToDictionary:ob withDefault:nil];
	if(!d)
	{
		self.error = __trCtx(@"Bad result",@"BackendPagedRequest");
		return nil;
	}
	
	self.count = [STSTypeConversion objectInDictionaryToInt:d key:@"count" defaultValue:-1];
	if(self.count < 0)
	{
		self.error = __trCtx(@"Bad result",@"BackendPagedRequest");
		return nil;
	}
	
	id prev = [d objectForKey:@"prev"];
	if(prev)
		self.prev = [STSTypeConversion objectToString:prev withDefault:nil];

	id next = [d objectForKey:@"next"];
	if(next)
		self.next = [STSTypeConversion objectToString:next withDefault:nil];
	
	id arry = [d objectForKey:sArrayMember];
	if(!arry)
	{
		self.error = __trCtx(@"No results present",@"BackendPagedRequest");
		return nil;
	}
	
	NSArray * a = [STSTypeConversion objectToArray:arry withDefault:nil];
	if(!a)
	{
		self.error = __trCtx(@"No results present",@"BackendPagedRequest");
		return nil;
	}

	NSMutableArray<id<JSONConvertible>> * arryx = [NSMutableArray new];

	for(id ao in a)
	{
		id<JSONConvertible> member = [[oClass alloc] init];
		NSString * sErr = [member decodeJSON:ao];
		if(sErr)
		{
			self.error = [NSString stringWithFormat:__trCtx(@"Failed to decode one of the results: %s",@"BackendPagedRequest"),sErr];
			return nil;
		}
		[arryx addObject:member];
	}
	
	return arryx;
}

@end
