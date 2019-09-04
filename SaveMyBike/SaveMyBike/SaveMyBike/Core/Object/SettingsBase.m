#import "STSJSONParser.h"
#import "STSJSONWriter.h"
#import "STSTypeConversion.h"
#import "SettingsBase.h"

@implementation SettingsBase
{
	NSString * m_sUniqueId;

	NSString * m_sLastFirebaseToken;

}

///////////////////////////////////////////////////////////////////////////////////////////////////////////
// Getters and Setters
///////////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSString *)uniqueId
{
	return m_sUniqueId;
}

- (void)setUniqueId:(NSString *)sUniqueId
{
	m_sUniqueId = sUniqueId;
}

- (NSString *)lastFirebaseToken
{
	return m_sLastFirebaseToken;
}

- (void)setLastFirebaseToken:(NSString *)sLastFirebaseToken
{
	m_sLastFirebaseToken = sLastFirebaseToken;
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

	id ob = [d objectForKey:@"uniqueId"];
	if(!ob)
	{
		m_sUniqueId = nil;
	} else {
		m_sUniqueId = [STSTypeConversion objectToString:ob withDefault:nil];
	}
	ob = [d objectForKey:@"lastFirebaseToken"];
	if(!ob)
	{
		m_sLastFirebaseToken = nil;
	} else {
		m_sLastFirebaseToken = [STSTypeConversion objectToString:ob withDefault:nil];
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
	[x setObject:(m_sUniqueId ? m_sUniqueId : [NSNull null]) forKey:@"uniqueId"];
	[x setObject:(m_sLastFirebaseToken ? m_sLastFirebaseToken : [NSNull null]) forKey:@"lastFirebaseToken"];
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

