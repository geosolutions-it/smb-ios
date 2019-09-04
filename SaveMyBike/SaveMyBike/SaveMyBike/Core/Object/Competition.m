#import "Competition.h"
#import "STSJSONParser.h"
#import "STSJSONWriter.h"
#import "STSTypeConversion.h"

@implementation Competition
{
	int m_iId;

	NSString * m_sUrl;

	NSString * m_sName;

	NSString * m_sDescription;

	NSMutableArray<NSString *> * m_lAgeGroups;

	NSString * m_sStartDate;

	NSString * m_sEndDate;

	NSMutableArray<NSString *> * m_lCriteria;

	int m_iWinnerThreshold;

	NSString * m_sScore;

	NSString * m_sLeaderboard;

	NSMutableArray<CompetitionPrize *> * m_lPrizes;

	NSMutableArray<Sponsor *> * m_lSponsors;

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

- (NSString *)description
{
	return m_sDescription;
}

- (void)setDescription:(NSString *)sDescription
{
	m_sDescription = sDescription;
}

- (NSMutableArray<NSString *> *)ageGroups
{
	return m_lAgeGroups;
}

- (void)setAgeGroups:(NSMutableArray<NSString *> *)lAgeGroups
{
	m_lAgeGroups = lAgeGroups;
}

- (NSString *)startDate
{
	return m_sStartDate;
}

- (void)setStartDate:(NSString *)sStartDate
{
	m_sStartDate = sStartDate;
}

- (NSString *)endDate
{
	return m_sEndDate;
}

- (void)setEndDate:(NSString *)sEndDate
{
	m_sEndDate = sEndDate;
}

- (NSMutableArray<NSString *> *)criteria
{
	return m_lCriteria;
}

- (void)setCriteria:(NSMutableArray<NSString *> *)lCriteria
{
	m_lCriteria = lCriteria;
}

- (int)winnerThreshold
{
	return m_iWinnerThreshold;
}

- (void)setWinnerThreshold:(int)iWinnerThreshold
{
	if(iWinnerThreshold == -0x7fffffff)
		m_iWinnerThreshold = 0;
	else
		m_iWinnerThreshold = iWinnerThreshold;
}

- (NSString *)score
{
	return m_sScore;
}

- (void)setScore:(NSString *)sScore
{
	m_sScore = sScore;
}

- (NSString *)leaderboard
{
	return m_sLeaderboard;
}

- (void)setLeaderboard:(NSString *)sLeaderboard
{
	m_sLeaderboard = sLeaderboard;
}

- (NSMutableArray<CompetitionPrize *> *)prizes
{
	return m_lPrizes;
}

- (void)setPrizes:(NSMutableArray<CompetitionPrize *> *)lPrizes
{
	m_lPrizes = lPrizes;
}

- (NSMutableArray<Sponsor *> *)sponsors
{
	return m_lSponsors;
}

- (void)setSponsors:(NSMutableArray<Sponsor *> *)lSponsors
{
	m_lSponsors = lSponsors;
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
	ob = [d objectForKey:@"description"];
	if(!ob)
	{
		m_sDescription = nil;
	} else {
		m_sDescription = [STSTypeConversion objectToString:ob withDefault:nil];
	}
	ob = [d objectForKey:@"age_groups"];
	if(!ob)
	{
		m_lAgeGroups = nil;
	} else {
		NSArray * xx = [STSTypeConversion objectToArray:ob withDefault:nil];
		if(!xx)
		{
			m_lAgeGroups = nil;
		} else {
			m_lAgeGroups = [NSMutableArray new];
			NSString * szErr = [self _decodeListOfString:m_lAgeGroups fromJSON:xx];
			if((szErr != nil) && (szErr.length > 0))
				return szErr;
		}
	}
	ob = [d objectForKey:@"start_date"];
	if(!ob)
	{
		m_sStartDate = nil;
	} else {
		m_sStartDate = [STSTypeConversion objectToString:ob withDefault:nil];
	}
	ob = [d objectForKey:@"end_date"];
	if(!ob)
	{
		m_sEndDate = nil;
	} else {
		m_sEndDate = [STSTypeConversion objectToString:ob withDefault:nil];
	}
	ob = [d objectForKey:@"criteria"];
	if(!ob)
	{
		m_lCriteria = nil;
	} else {
		NSArray * xx = [STSTypeConversion objectToArray:ob withDefault:nil];
		if(!xx)
		{
			m_lCriteria = nil;
		} else {
			m_lCriteria = [NSMutableArray new];
			NSString * szErr = [self _decodeListOfString:m_lCriteria fromJSON:xx];
			if((szErr != nil) && (szErr.length > 0))
				return szErr;
		}
	}
	ob = [d objectForKey:@"winner_threshold"];
	if(!ob)
	{
		m_iWinnerThreshold = 0;
	} else {
		m_iWinnerThreshold = [STSTypeConversion objectToInt:ob withDefault:0];
	}
	ob = [d objectForKey:@"score"];
	if(!ob)
	{
		m_sScore = nil;
	} else {
		m_sScore = [STSTypeConversion objectToString:ob withDefault:nil];
	}
	ob = [d objectForKey:@"leaderboard"];
	if(!ob)
	{
		m_sLeaderboard = nil;
	} else {
		m_sLeaderboard = [STSTypeConversion objectToString:ob withDefault:nil];
	}
	ob = [d objectForKey:@"prizes"];
	if(!ob)
	{
		m_lPrizes = nil;
	} else {
		NSArray * xx = [STSTypeConversion objectToArray:ob withDefault:nil];
		if(!xx)
		{
			m_lPrizes = nil;
		} else {
			m_lPrizes = [NSMutableArray new];
			NSString * szErr = [self _decodeListOfCompetitionPrize:m_lPrizes fromJSON:xx];
			if((szErr != nil) && (szErr.length > 0))
				return szErr;
		}
	}
	ob = [d objectForKey:@"sponsors"];
	if(!ob)
	{
		m_lSponsors = nil;
	} else {
		NSArray * xx = [STSTypeConversion objectToArray:ob withDefault:nil];
		if(!xx)
		{
			m_lSponsors = nil;
		} else {
			m_lSponsors = [NSMutableArray new];
			NSString * szErr = [self _decodeListOfSponsor:m_lSponsors fromJSON:xx];
			if((szErr != nil) && (szErr.length > 0))
				return szErr;
		}
	}
	return nil;
}

- (NSString *)_decodeListOfSponsor:(NSMutableArray<Sponsor *> *)lOut fromJSON:(NSArray *)lIn
{
	for(id ob in lIn)
	{
		NSDictionary * pDict = [STSTypeConversion objectToDictionary:ob withDefault:nil];
		if(!pDict)
			continue;
		Sponsor * pObj = [Sponsor new];
		NSString * szErr = [pObj decodeJSON:ob];
		if((szErr != nil) && (szErr.length > 0))
			return szErr;
		[lOut addObject:pObj];
	}
	return nil;
}

- (NSString *)_decodeListOfString:(NSMutableArray<NSString *> *)lOut fromJSON:(NSArray *)lIn
{
	for(id ob in lIn)
	{
		if(![ob isKindOfClass:[NSString class]])
			[lOut addObject:[STSTypeConversion objectToString:ob withDefault:nil]];
		else
			[lOut addObject:ob];
	}
	return nil;
}

- (NSString *)_decodeListOfCompetitionPrize:(NSMutableArray<CompetitionPrize *> *)lOut fromJSON:(NSArray *)lIn
{
	for(id ob in lIn)
	{
		NSDictionary * pDict = [STSTypeConversion objectToDictionary:ob withDefault:nil];
		if(!pDict)
			continue;
		CompetitionPrize * pObj = [CompetitionPrize new];
		NSString * szErr = [pObj decodeJSON:ob];
		if((szErr != nil) && (szErr.length > 0))
			return szErr;
		[lOut addObject:pObj];
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
	[x setObject:(m_sDescription ? m_sDescription : [NSNull null]) forKey:@"description"];
	[x setObject:(m_lAgeGroups ? [self _encodeListOfStringToJSON:m_lAgeGroups] : [NSNull null]) forKey:@"age_groups"];
	[x setObject:(m_sStartDate ? m_sStartDate : [NSNull null]) forKey:@"start_date"];
	[x setObject:(m_sEndDate ? m_sEndDate : [NSNull null]) forKey:@"end_date"];
	[x setObject:(m_lCriteria ? [self _encodeListOfStringToJSON:m_lCriteria] : [NSNull null]) forKey:@"criteria"];
	[x setObject:[NSNumber numberWithInt:m_iWinnerThreshold] forKey:@"winner_threshold"];
	[x setObject:(m_sScore ? m_sScore : [NSNull null]) forKey:@"score"];
	[x setObject:(m_sLeaderboard ? m_sLeaderboard : [NSNull null]) forKey:@"leaderboard"];
	[x setObject:(m_lPrizes ? [self _encodeListOfCompetitionPrizeToJSON:m_lPrizes] : [NSNull null]) forKey:@"prizes"];
	[x setObject:(m_lSponsors ? [self _encodeListOfSponsorToJSON:m_lSponsors] : [NSNull null]) forKey:@"sponsors"];
	return x;
}

- (NSMutableArray *)_encodeListOfSponsorToJSON:(NSMutableArray<Sponsor *> *)lList
{
	NSMutableArray * pOut = [NSMutableArray new];
	for(Sponsor * it in lList)
	{
		[pOut addObject:[it encodeToJSON]];
	}
	return pOut;
}

- (NSMutableArray *)_encodeListOfCompetitionPrizeToJSON:(NSMutableArray<CompetitionPrize *> *)lList
{
	NSMutableArray * pOut = [NSMutableArray new];
	for(CompetitionPrize * it in lList)
	{
		[pOut addObject:[it encodeToJSON]];
	}
	return pOut;
}

- (NSMutableArray *)_encodeListOfStringToJSON:(NSMutableArray<NSString *> *)lList
{
	NSMutableArray * pOut = [NSMutableArray new];
	for(NSString * it in lList)
	{
		[pOut addObject:it];
	}
	return pOut;
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

