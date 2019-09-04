#import "STSJSONParser.h"
#import "STSJSONWriter.h"
#import "STSTypeConversion.h"
#import "UserDataBadge.h"

@implementation UserDataBadge
{
	NSString * m_sName;

	NSString * m_sUrl;

	bool m_bAcquired;

}

///////////////////////////////////////////////////////////////////////////////////////////////////////////
// Getters and Setters
///////////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSString *)name
{
	return m_sName;
}

- (void)setName:(NSString *)sName
{
	m_sName = sName;
}

- (NSString *)url
{
	return m_sUrl;
}

- (void)setUrl:(NSString *)sUrl
{
	m_sUrl = sUrl;
}

- (bool)acquired
{
	return m_bAcquired;
}

- (void)setAcquired:(bool)bAcquired
{
	m_bAcquired = bAcquired;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////
// JSON Manipulation
///////////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSString *)decodeJSON:(id)x
{
	if(!x)
		return @"null object";

	NSDictionary * d = [STSTypeConversion objectToDictionary:x withDefault:nil];
	if(!d)
		return @"Bad dictionary object";

	id ob = [d objectForKey:@"name"];
	if(!ob)
	{
		m_sName = nil;
	} else {
		m_sName = [STSTypeConversion objectToString:ob withDefault:nil];
	}
	ob = [d objectForKey:@"url"];
	if(!ob)
	{
		m_sUrl = nil;
	} else {
		m_sUrl = [STSTypeConversion objectToString:ob withDefault:nil];
	}
	ob = [d objectForKey:@"acquired"];
	if(!ob)
	{
		m_bAcquired = false;
	} else {
		m_bAcquired = [STSTypeConversion objectToBool:ob withDefault:false];
	}
	return nil;
}

- (NSString *)decodeJSONString:(NSString *)szJSON
{
	if(!szJSON)
		return @"Null json input";
	STSJSONParser * p = [STSJSONParser new];
	p.maxDepth = 256;
	id obj = [p objectWithString:szJSON];
	if(!obj)
		return p.error ? p.error : @"Failed to decode JSON";
	return [self decodeJSON:obj];
}

- (NSString *)decodeJSONData:(NSData *)oJSON
{
	if(!oJSON)
		return @"Null json input";
	STSJSONParser * p = [STSJSONParser new];
	p.maxDepth = 256;
	id obj = [p objectWithData:oJSON];
	if(!obj)
		return p.error ? p.error : @"Failed to decode JSON";
	return [self decodeJSON:obj];
}

- (NSMutableDictionary *)encodeToJSON
{
	NSMutableDictionary * x = [NSMutableDictionary new];
	[x setObject:(m_sName ? m_sName : [NSNull null]) forKey:@"name"];
	[x setObject:(m_sUrl ? m_sUrl : [NSNull null]) forKey:@"url"];
	[x setObject:[NSNumber numberWithBool:m_bAcquired] forKey:@"acquired"];
	return x;
}

- (NSString *)encodeToJSONString
{
	return [self encodeToJSONStringHumanReadable:false sortKeys:false];
}

- (NSString *)encodeToJSONStringHumanReadable:(bool)bHumanReadable
{
	return [self encodeToJSONStringHumanReadable:bHumanReadable sortKeys:false];
}

- (NSString *)encodeToJSONStringHumanReadable:(bool)bHumanReadable sortKeys:(bool)bSortKeys
{
	STSJSONWriter * w = [STSJSONWriter new];
	w.humanReadable = bHumanReadable;
	w.sortKeys = bSortKeys;
	w.maxDepth = 256;
	return [w stringWithObject:[self encodeToJSON]];
}

- (NSData *)encodeToJSONData
{
	return [self encodeToJSONDataHumanReadable:false sortKeys:false];
}

- (NSData *)encodeToJSONDataHumanReadable:(bool)bHumanReadable
{
	return [self encodeToJSONDataHumanReadable:bHumanReadable sortKeys:false];
}

- (NSData *)encodeToJSONDataHumanReadable:(bool)bHumanReadable sortKeys:(bool)bSortKeys
{
	STSJSONWriter * w = [STSJSONWriter new];
	w.humanReadable = bHumanReadable;
	w.sortKeys = bSortKeys;
	w.maxDepth = 256;
	return [w dataWithObject:[self encodeToJSON]];
}

@end

