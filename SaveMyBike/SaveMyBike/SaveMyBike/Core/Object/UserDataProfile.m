#import "STSJSONParser.h"
#import "STSJSONWriter.h"
#import "STSTypeConversion.h"
#import "UserDataProfile.h"

@implementation UserDataProfile
{
	NSString * m_sGender;

	NSString * m_sAge;

	NSString * m_sPhoneNumber;

	NSString * m_sBio;

	NSString * m_sOccupation;

}

///////////////////////////////////////////////////////////////////////////////////////////////////////////
// Getters and Setters
///////////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSString *)gender
{
	return m_sGender;
}

- (void)setGender:(NSString *)sGender
{
	m_sGender = sGender;
}

- (NSString *)age
{
	return m_sAge;
}

- (void)setAge:(NSString *)sAge
{
	m_sAge = sAge;
}

- (NSString *)phoneNumber
{
	return m_sPhoneNumber;
}

- (void)setPhoneNumber:(NSString *)sPhoneNumber
{
	m_sPhoneNumber = sPhoneNumber;
}

- (NSString *)bio
{
	return m_sBio;
}

- (void)setBio:(NSString *)sBio
{
	m_sBio = sBio;
}

- (NSString *)occupation
{
	return m_sOccupation;
}

- (void)setOccupation:(NSString *)sOccupation
{
	m_sOccupation = sOccupation;
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

	id ob = [d objectForKey:@"gender"];
	if(!ob)
	{
		m_sGender = nil;
	} else {
		m_sGender = [STSTypeConversion objectToString:ob withDefault:nil];
	}
	ob = [d objectForKey:@"age"];
	if(!ob)
	{
		m_sAge = nil;
	} else {
		m_sAge = [STSTypeConversion objectToString:ob withDefault:nil];
	}
	ob = [d objectForKey:@"phone_number"];
	if(!ob)
	{
		m_sPhoneNumber = nil;
	} else {
		m_sPhoneNumber = [STSTypeConversion objectToString:ob withDefault:nil];
	}
	ob = [d objectForKey:@"bio"];
	if(!ob)
	{
		m_sBio = nil;
	} else {
		m_sBio = [STSTypeConversion objectToString:ob withDefault:nil];
	}
	ob = [d objectForKey:@"occupation"];
	if(!ob)
	{
		m_sOccupation = nil;
	} else {
		m_sOccupation = [STSTypeConversion objectToString:ob withDefault:nil];
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
	[x setObject:(m_sGender ? m_sGender : [NSNull null]) forKey:@"gender"];
	[x setObject:(m_sAge ? m_sAge : [NSNull null]) forKey:@"age"];
	[x setObject:(m_sPhoneNumber ? m_sPhoneNumber : [NSNull null]) forKey:@"phone_number"];
	[x setObject:(m_sBio ? m_sBio : [NSNull null]) forKey:@"bio"];
	[x setObject:(m_sOccupation ? m_sOccupation : [NSNull null]) forKey:@"occupation"];
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

