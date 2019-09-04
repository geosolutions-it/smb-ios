#import "CompetitionPrize.h"
#import "Prize.h"
#import "STSJSONParser.h"
#import "STSJSONWriter.h"
#import "STSTypeConversion.h"

@implementation CompetitionPrize
{
	NSString * m_sWinnerDescription;

	int m_iUserRank;

	Prize * m_oPrize;

}

///////////////////////////////////////////////////////////////////////////////////////////////////////////
// Getters and Setters
///////////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSString *)winnerDescription
{
	return m_sWinnerDescription;
}

- (void)setWinnerDescription:(NSString *)sWinnerDescription
{
	m_sWinnerDescription = sWinnerDescription;
}

- (int)userRank
{
	return m_iUserRank;
}

- (void)setUserRank:(int)iUserRank
{
	if(iUserRank == -0x7fffffff)
		m_iUserRank = 0;
	else
		m_iUserRank = iUserRank;
}

- (Prize *)prize
{
	return m_oPrize;
}

- (void)setPrize:(Prize *)oPrize
{
	m_oPrize = oPrize;
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

	id ob = [d objectForKey:@"winner_description"];
	if(!ob)
	{
		m_sWinnerDescription = nil;
	} else {
		m_sWinnerDescription = [STSTypeConversion objectToString:ob withDefault:nil];
	}
	ob = [d objectForKey:@"user_rank"];
	if(!ob)
	{
		m_iUserRank = 0;
	} else {
		m_iUserRank = [STSTypeConversion objectToInt:ob withDefault:0];
	}
	ob = [d objectForKey:@"prize"];
	if(!ob)
	{
		m_oPrize = nil;
	} else {
		NSDictionary * pDict = [STSTypeConversion objectToDictionary:ob withDefault:nil];
		if(!pDict)
		{
			m_oPrize = nil;
		} else {
			m_oPrize = [Prize new];
			NSString * szErr = [m_oPrize decodeJSON:pDict];
			if((szErr != nil) && (szErr.length > 0))
				m_oPrize = nil;
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
	[x setObject:(m_sWinnerDescription ? m_sWinnerDescription : [NSNull null]) forKey:@"winner_description"];
	[x setObject:[NSNumber numberWithInt:m_iUserRank] forKey:@"user_rank"];
	[x setObject:(m_oPrize ? [m_oPrize encodeToJSON] : [NSNull null]) forKey:@"prize"];
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

