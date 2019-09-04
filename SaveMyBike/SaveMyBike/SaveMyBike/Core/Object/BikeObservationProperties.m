#import "BikeObservationProperties.h"
#import "STSJSONParser.h"
#import "STSJSONWriter.h"
#import "STSTypeConversion.h"

@implementation BikeObservationProperties
{
	int m_iId;

	NSString * m_sBike;

	NSString * m_sBikeUrl;

	NSString * m_sReporterId;

	NSString * m_sReporterType;

	NSString * m_sReporterName;

	NSString * m_sAddress;

	NSString * m_sDetails;

	NSString * m_sPosition;

	NSString * m_sCreatedAt;

	NSString * m_sObservedAt;

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

- (NSString *)bikeUrl
{
	return m_sBikeUrl;
}

- (void)setBikeUrl:(NSString *)sBikeUrl
{
	m_sBikeUrl = sBikeUrl;
}

- (NSString *)reporterId
{
	return m_sReporterId;
}

- (void)setReporterId:(NSString *)sReporterId
{
	m_sReporterId = sReporterId;
}

- (NSString *)reporterType
{
	return m_sReporterType;
}

- (void)setReporterType:(NSString *)sReporterType
{
	m_sReporterType = sReporterType;
}

- (NSString *)reporterName
{
	return m_sReporterName;
}

- (void)setReporterName:(NSString *)sReporterName
{
	m_sReporterName = sReporterName;
}

- (NSString *)address
{
	return m_sAddress;
}

- (void)setAddress:(NSString *)sAddress
{
	m_sAddress = sAddress;
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

- (NSString *)createdAt
{
	return m_sCreatedAt;
}

- (void)setCreatedAt:(NSString *)sCreatedAt
{
	m_sCreatedAt = sCreatedAt;
}

- (NSString *)observedAt
{
	return m_sObservedAt;
}

- (void)setObservedAt:(NSString *)sObservedAt
{
	m_sObservedAt = sObservedAt;
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
	ob = [d objectForKey:@"bike_url"];
	if(!ob)
	{
		m_sBikeUrl = nil;
	} else {
		m_sBikeUrl = [STSTypeConversion objectToString:ob withDefault:nil];
	}
	ob = [d objectForKey:@"reporter_id"];
	if(!ob)
	{
		m_sReporterId = nil;
	} else {
		m_sReporterId = [STSTypeConversion objectToString:ob withDefault:nil];
	}
	ob = [d objectForKey:@"reporter_type"];
	if(!ob)
	{
		m_sReporterType = nil;
	} else {
		m_sReporterType = [STSTypeConversion objectToString:ob withDefault:nil];
	}
	ob = [d objectForKey:@"reporter_name"];
	if(!ob)
	{
		m_sReporterName = nil;
	} else {
		m_sReporterName = [STSTypeConversion objectToString:ob withDefault:nil];
	}
	ob = [d objectForKey:@"address"];
	if(!ob)
	{
		m_sAddress = nil;
	} else {
		m_sAddress = [STSTypeConversion objectToString:ob withDefault:nil];
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
	ob = [d objectForKey:@"created_at"];
	if(!ob)
	{
		m_sCreatedAt = nil;
	} else {
		m_sCreatedAt = [STSTypeConversion objectToString:ob withDefault:nil];
	}
	ob = [d objectForKey:@"observed_at"];
	if(!ob)
	{
		m_sObservedAt = nil;
	} else {
		m_sObservedAt = [STSTypeConversion objectToString:ob withDefault:nil];
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
	[x setObject:(m_sBikeUrl ? m_sBikeUrl : [NSNull null]) forKey:@"bike_url"];
	[x setObject:(m_sReporterId ? m_sReporterId : [NSNull null]) forKey:@"reporter_id"];
	[x setObject:(m_sReporterType ? m_sReporterType : [NSNull null]) forKey:@"reporter_type"];
	[x setObject:(m_sReporterName ? m_sReporterName : [NSNull null]) forKey:@"reporter_name"];
	[x setObject:(m_sAddress ? m_sAddress : [NSNull null]) forKey:@"address"];
	[x setObject:(m_sDetails ? m_sDetails : [NSNull null]) forKey:@"details"];
	[x setObject:(m_sPosition ? m_sPosition : [NSNull null]) forKey:@"position"];
	[x setObject:(m_sCreatedAt ? m_sCreatedAt : [NSNull null]) forKey:@"created_at"];
	[x setObject:(m_sObservedAt ? m_sObservedAt : [NSNull null]) forKey:@"observed_at"];
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

