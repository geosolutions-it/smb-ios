#import "Competition.h"
#import "CompetitionParticipation.h"
#import "STSJSONParser.h"
#import "STSJSONWriter.h"
#import "STSTypeConversion.h"

@implementation CompetitionParticipation
{
	int m_iId;

	NSString * m_sUrl;

	NSString * m_sRegistrationStatus;

	NSString * m_sScore;

	Competition * m_oCompetition;

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

- (NSString *)registrationStatus
{
	return m_sRegistrationStatus;
}

- (void)setRegistrationStatus:(NSString *)sRegistrationStatus
{
	m_sRegistrationStatus = sRegistrationStatus;
}

- (NSString *)score
{
	return m_sScore;
}

- (void)setScore:(NSString *)sScore
{
	m_sScore = sScore;
}

- (Competition *)competition
{
	return m_oCompetition;
}

- (void)setCompetition:(Competition *)oCompetition
{
	m_oCompetition = oCompetition;
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
	ob = [d objectForKey:@"registration_status"];
	if(!ob)
	{
		m_sRegistrationStatus = nil;
	} else {
		m_sRegistrationStatus = [STSTypeConversion objectToString:ob withDefault:nil];
	}
	ob = [d objectForKey:@"score"];
	if(!ob)
	{
		m_sScore = nil;
	} else {
		m_sScore = [STSTypeConversion objectToString:ob withDefault:nil];
	}
	ob = [d objectForKey:@"competition"];
	if(!ob)
	{
		m_oCompetition = nil;
	} else {
		NSDictionary * pDict = [STSTypeConversion objectToDictionary:ob withDefault:nil];
		if(!pDict)
		{
			m_oCompetition = nil;
		} else {
			m_oCompetition = [Competition new];
			NSString * szErr = [m_oCompetition decodeJSON:pDict];
			if((szErr != nil) && (szErr.length > 0))
				m_oCompetition = nil;
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
	[x setObject:[NSNumber numberWithInt:m_iId] forKey:@"id"];
	[x setObject:(m_sUrl ? m_sUrl : [NSNull null]) forKey:@"url"];
	[x setObject:(m_sRegistrationStatus ? m_sRegistrationStatus : [NSNull null]) forKey:@"registration_status"];
	[x setObject:(m_sScore ? m_sScore : [NSNull null]) forKey:@"score"];
	[x setObject:(m_oCompetition ? [m_oCompetition encodeToJSON] : [NSNull null]) forKey:@"competition"];
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

