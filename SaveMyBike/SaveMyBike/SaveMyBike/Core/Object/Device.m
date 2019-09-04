#import "Device.h"
#import "STSJSONParser.h"
#import "STSJSONWriter.h"
#import "STSTypeConversion.h"

@implementation Device
{
	int m_iId;

	NSString * m_sName;

	NSString * m_sRegistrationId;

	NSString * m_sDeviceId;

	bool m_bActive;

	NSString * m_sDateCreated;

	NSString * m_sType;

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

- (NSString *)name
{
	return m_sName;
}

- (void)setName:(NSString *)sName
{
	m_sName = sName;
}

- (NSString *)registrationId
{
	return m_sRegistrationId;
}

- (void)setRegistrationId:(NSString *)sRegistrationId
{
	m_sRegistrationId = sRegistrationId;
}

- (NSString *)deviceId
{
	return m_sDeviceId;
}

- (void)setDeviceId:(NSString *)sDeviceId
{
	m_sDeviceId = sDeviceId;
}

- (bool)active
{
	return m_bActive;
}

- (void)setActive:(bool)bActive
{
	m_bActive = bActive;
}

- (NSString *)dateCreated
{
	return m_sDateCreated;
}

- (void)setDateCreated:(NSString *)sDateCreated
{
	m_sDateCreated = sDateCreated;
}

- (NSString *)type
{
	return m_sType;
}

- (void)setType:(NSString *)sType
{
	m_sType = sType;
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
	ob = [d objectForKey:@"name"];
	if(!ob)
	{
		m_sName = nil;
	} else {
		m_sName = [STSTypeConversion objectToString:ob withDefault:nil];
	}
	ob = [d objectForKey:@"registration_id"];
	if(!ob)
	{
		m_sRegistrationId = nil;
	} else {
		m_sRegistrationId = [STSTypeConversion objectToString:ob withDefault:nil];
	}
	ob = [d objectForKey:@"device_id"];
	if(!ob)
	{
		m_sDeviceId = nil;
	} else {
		m_sDeviceId = [STSTypeConversion objectToString:ob withDefault:nil];
	}
	ob = [d objectForKey:@"active"];
	if(!ob)
	{
		m_bActive = false;
	} else {
		m_bActive = [STSTypeConversion objectToBool:ob withDefault:false];
	}
	ob = [d objectForKey:@"date_created"];
	if(!ob)
	{
		m_sDateCreated = nil;
	} else {
		m_sDateCreated = [STSTypeConversion objectToString:ob withDefault:nil];
	}
	ob = [d objectForKey:@"type"];
	if(!ob)
	{
		m_sType = nil;
	} else {
		m_sType = [STSTypeConversion objectToString:ob withDefault:nil];
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
	[x setObject:(m_sName ? m_sName : [NSNull null]) forKey:@"name"];
	[x setObject:(m_sRegistrationId ? m_sRegistrationId : [NSNull null]) forKey:@"registration_id"];
	[x setObject:(m_sDeviceId ? m_sDeviceId : [NSNull null]) forKey:@"device_id"];
	[x setObject:[NSNumber numberWithBool:m_bActive] forKey:@"active"];
	[x setObject:(m_sDateCreated ? m_sDateCreated : [NSNull null]) forKey:@"date_created"];
	[x setObject:(m_sType ? m_sType : [NSNull null]) forKey:@"type"];
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

