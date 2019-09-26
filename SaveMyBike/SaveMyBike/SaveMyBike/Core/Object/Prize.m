#import "Prize.h"
#import "STSJSONParser.h"
#import "STSJSONWriter.h"
#import "STSTypeConversion.h"
#import "Sponsor.h"

@implementation Prize
{
	NSString * m_sName;

	NSString * m_sDescription;

	NSString * m_sImage;

	Sponsor * m_oSponsor;

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

- (NSString *)description
{
	return m_sDescription;
}

- (void)setDescription:(NSString *)sDescription
{
	m_sDescription = sDescription;
}

- (NSString *)image
{
	return m_sImage;
}

- (void)setImage:(NSString *)sImage
{
	m_sImage = sImage;
}

- (Sponsor *)sponsor
{
	return m_oSponsor;
}

- (void)setSponsor:(Sponsor *)oSponsor
{
	m_oSponsor = oSponsor;
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
	ob = [d objectForKey:@"description"];
	if(!ob)
	{
		m_sDescription = nil;
	} else {
		m_sDescription = [STSTypeConversion objectToString:ob withDefault:nil];
	}
	ob = [d objectForKey:@"image"];
	if(!ob)
	{
		m_sImage = nil;
	} else {
		m_sImage = [STSTypeConversion objectToString:ob withDefault:nil];
	}
	ob = [d objectForKey:@"sponsor"];
	if(!ob)
	{
		m_oSponsor = nil;
	} else {
		NSDictionary * pDict = [STSTypeConversion objectToDictionary:ob withDefault:nil];
		if(!pDict)
		{
			m_oSponsor = nil;
		} else {
			m_oSponsor = [Sponsor new];
			NSString * szErr = [m_oSponsor decodeJSON:pDict];
			if((szErr != nil) && (szErr.length > 0))
				m_oSponsor = nil;
		}
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
	[x setObject:(m_sDescription ? m_sDescription : [NSNull null]) forKey:@"description"];
	[x setObject:(m_sImage ? m_sImage : [NSNull null]) forKey:@"image"];
	[x setObject:(m_oSponsor ? [m_oSponsor encodeToJSON] : [NSNull null]) forKey:@"sponsor"];
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

