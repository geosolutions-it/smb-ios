#import "BikeStatus.h"
#import "STSJSONParser.h"
#import "STSJSONWriter.h"
#import "STSTypeConversion.h"

@implementation BikeStatus
{
	int m_iId;

	NSString * m_sBike;

	NSString * m_sUrl;

	bool m_bLost;

	NSString * m_sDetails;

	NSString * m_sPosition;

	NSString * m_sCreationDate;

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

- (NSString *)bike
{
	return m_sBike;
}

- (void)setBike:(NSString *)sBike
{
	m_sBike = sBike;
}

- (NSString *)url
{
	return m_sUrl;
}

- (void)setUrl:(NSString *)sUrl
{
	m_sUrl = sUrl;
}

- (bool)lost
{
	return m_bLost;
}

- (void)setLost:(bool)bLost
{
	m_bLost = bLost;
}

- (NSString *)details
{
	return m_sDetails;
}

- (void)setDetails:(NSString *)sDetails
{
	m_sDetails = sDetails;
}

- (NSString *)position
{
	return m_sPosition;
}

- (void)setPosition:(NSString *)sPosition
{
	m_sPosition = sPosition;
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

	id ob = [d objectForKey:@"id"];
	if(!ob)
	{
		m_iId = 0;
	} else {
		m_iId = [STSTypeConversion objectToInt:ob withDefault:0];
	}
	ob = [d objectForKey:@"bike"];
	if(!ob)
	{
		m_sBike = nil;
	} else {
		m_sBike = [STSTypeConversion objectToString:ob withDefault:nil];
	}
	ob = [d objectForKey:@"url"];
	if(!ob)
	{
		m_sUrl = nil;
	} else {
		m_sUrl = [STSTypeConversion objectToString:ob withDefault:nil];
	}
	ob = [d objectForKey:@"lost"];
	if(!ob)
	{
		m_bLost = false;
	} else {
		m_bLost = [STSTypeConversion objectToBool:ob withDefault:false];
	}
	ob = [d objectForKey:@"details"];
	if(!ob)
	{
		m_sDetails = nil;
	} else {
		m_sDetails = [STSTypeConversion objectToString:ob withDefault:nil];
	}
	ob = [d objectForKey:@"position"];
	if(!ob)
	{
		m_sPosition = nil;
	} else {
		m_sPosition = [STSTypeConversion objectToString:ob withDefault:nil];
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
	[x setObject:[NSNumber numberWithInt:m_iId] forKey:@"id"];
	[x setObject:(m_sBike ? m_sBike : [NSNull null]) forKey:@"bike"];
	[x setObject:(m_sUrl ? m_sUrl : [NSNull null]) forKey:@"url"];
	[x setObject:[NSNumber numberWithBool:m_bLost] forKey:@"lost"];
	[x setObject:(m_sDetails ? m_sDetails : [NSNull null]) forKey:@"details"];
	[x setObject:(m_sPosition ? m_sPosition : [NSNull null]) forKey:@"position"];
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

