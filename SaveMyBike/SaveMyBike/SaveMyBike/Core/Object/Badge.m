#import "Badge.h"
#import "STSJSONParser.h"
#import "STSJSONWriter.h"
#import "STSTypeConversion.h"

@implementation Badge
{
	int m_iId;

	NSString * m_sUrl;

	NSString * m_sName;

	bool m_bAcquired;

	NSString * m_sDescription;

	NSString * m_sCategory;

}

///////////////////////////////////////////////////////////////////////////////////////////////////////////
// Getters and Setters
///////////////////////////////////////////////////////////////////////////////////////////////////////////

- (int)id
{
	return m_iId;
}

- (void)setId:(int)iId
{
	if(iId == -0x7fffffff)
		m_iId = 0;
	else
		m_iId = iId;
}

- (NSString *)url
{
	return m_sUrl;
}

- (void)setUrl:(NSString *)sUrl
{
	m_sUrl = sUrl;
}

- (NSString *)name
{
	return m_sName;
}

- (void)setName:(NSString *)sName
{
	m_sName = sName;
}

- (bool)acquired
{
	return m_bAcquired;
}

- (void)setAcquired:(bool)bAcquired
{
	m_bAcquired = bAcquired;
}

- (NSString *)description
{
	return m_sDescription;
}

- (void)setDescription:(NSString *)sDescription
{
	m_sDescription = sDescription;
}

- (NSString *)category
{
	return m_sCategory;
}

- (void)setCategory:(NSString *)sCategory
{
	m_sCategory = sCategory;
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

	id ob = [d objectForKey:@"id"];
	if(!ob)
	{
		m_iId = 0;
	} else {
		m_iId = [STSTypeConversion objectToInt:ob withDefault:0];
	}
	ob = [d objectForKey:@"url"];
	if(!ob)
	{
		m_sUrl = nil;
	} else {
		m_sUrl = [STSTypeConversion objectToString:ob withDefault:nil];
	}
	ob = [d objectForKey:@"name"];
	if(!ob)
	{
		m_sName = nil;
	} else {
		m_sName = [STSTypeConversion objectToString:ob withDefault:nil];
	}
	ob = [d objectForKey:@"acquired"];
	if(!ob)
	{
		m_bAcquired = false;
	} else {
		m_bAcquired = [STSTypeConversion objectToBool:ob withDefault:false];
	}
	ob = [d objectForKey:@"description"];
	if(!ob)
	{
		m_sDescription = nil;
	} else {
		m_sDescription = [STSTypeConversion objectToString:ob withDefault:nil];
	}
	ob = [d objectForKey:@"category"];
	if(!ob)
	{
		m_sCategory = nil;
	} else {
		m_sCategory = [STSTypeConversion objectToString:ob withDefault:nil];
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
	[x setObject:[NSNumber numberWithInt:m_iId] forKey:@"id"];
	[x setObject:(m_sUrl ? m_sUrl : [NSNull null]) forKey:@"url"];
	[x setObject:(m_sName ? m_sName : [NSNull null]) forKey:@"name"];
	[x setObject:[NSNumber numberWithBool:m_bAcquired] forKey:@"acquired"];
	[x setObject:(m_sDescription ? m_sDescription : [NSNull null]) forKey:@"description"];
	[x setObject:(m_sCategory ? m_sCategory : [NSNull null]) forKey:@"category"];
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

