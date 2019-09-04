#import "PhysicalTag.h"
#import "STSJSONParser.h"
#import "STSJSONWriter.h"
#import "STSTypeConversion.h"

@implementation PhysicalTag
{
	NSString * m_sEpc;

	NSString * m_sBike;

	NSString * m_sBikerUrl;

	NSString * m_sUrl;

	NSString * m_sCreationDate;

}

///////////////////////////////////////////////////////////////////////////////////////////////////////////
// Getters and Setters
///////////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSString *)epc
{
	return m_sEpc;
}

- (void)setEpc:(NSString *)sEpc
{
	m_sEpc = sEpc;
}

- (NSString *)bike
{
	return m_sBike;
}

- (void)setBike:(NSString *)sBike
{
	m_sBike = sBike;
}

- (NSString *)bikerUrl
{
	return m_sBikerUrl;
}

- (void)setBikerUrl:(NSString *)sBikerUrl
{
	m_sBikerUrl = sBikerUrl;
}

- (NSString *)url
{
	return m_sUrl;
}

- (void)setUrl:(NSString *)sUrl
{
	m_sUrl = sUrl;
}

- (NSString *)creationDate
{
	return m_sCreationDate;
}

- (void)setCreationDate:(NSString *)sCreationDate
{
	m_sCreationDate = sCreationDate;
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

	id ob = [d objectForKey:@"epc"];
	if(!ob)
	{
		m_sEpc = nil;
	} else {
		m_sEpc = [STSTypeConversion objectToString:ob withDefault:nil];
	}
	ob = [d objectForKey:@"bike"];
	if(!ob)
	{
		m_sBike = nil;
	} else {
		m_sBike = [STSTypeConversion objectToString:ob withDefault:nil];
	}
	ob = [d objectForKey:@"bike_url"];
	if(!ob)
	{
		m_sBikerUrl = nil;
	} else {
		m_sBikerUrl = [STSTypeConversion objectToString:ob withDefault:nil];
	}
	ob = [d objectForKey:@"url"];
	if(!ob)
	{
		m_sUrl = nil;
	} else {
		m_sUrl = [STSTypeConversion objectToString:ob withDefault:nil];
	}
	ob = [d objectForKey:@"creation_date"];
	if(!ob)
	{
		m_sCreationDate = nil;
	} else {
		m_sCreationDate = [STSTypeConversion objectToString:ob withDefault:nil];
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
	[x setObject:(m_sEpc ? m_sEpc : [NSNull null]) forKey:@"epc"];
	[x setObject:(m_sBike ? m_sBike : [NSNull null]) forKey:@"bike"];
	[x setObject:(m_sBikerUrl ? m_sBikerUrl : [NSNull null]) forKey:@"bike_url"];
	[x setObject:(m_sUrl ? m_sUrl : [NSNull null]) forKey:@"url"];
	[x setObject:(m_sCreationDate ? m_sCreationDate : [NSNull null]) forKey:@"creation_date"];
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

