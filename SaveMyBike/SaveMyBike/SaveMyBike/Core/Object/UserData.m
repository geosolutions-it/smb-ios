#import "Emissions.h"
#import "HealthBenefits.h"
#import "STSJSONParser.h"
#import "STSJSONWriter.h"
#import "STSTypeConversion.h"
#import "UserData.h"
#import "UserDataProfile.h"
#import "UserDataTotalDistanceKm.h"
#import "UserDataTotalTravels.h"

@implementation UserData
{
	bool m_bAcceptedTermsOfService;

	NSString * m_sUuid;

	NSString * m_sUsername;

	NSString * m_sEmail;

	NSString * m_sLanguagePreference;

	NSString * m_sFirstName;

	NSString * m_sLastName;

	NSString * m_sNickName;

	NSString * m_sProfileType;

	NSString * m_sAvatar;

	UserDataProfile * m_oProfile;

	NSMutableArray<UserDataBadge *> * m_lAcquiredBadges;

	NSMutableArray<UserDataBadge *> * m_lNextBadges;

	HealthBenefits * m_oTotalHealthBenefits;

	Emissions * m_oTotalEmissions;

	UserDataTotalDistanceKm * m_oTotalDistanceKm;

	UserDataTotalTravels * m_oTotalTravels;

}

///////////////////////////////////////////////////////////////////////////////////////////////////////////
// Getters and Setters
///////////////////////////////////////////////////////////////////////////////////////////////////////////

- (bool)acceptedTermsOfService
{
	return m_bAcceptedTermsOfService;
}

- (void)setAcceptedTermsOfService:(bool)bAcceptedTermsOfService
{
	m_bAcceptedTermsOfService = bAcceptedTermsOfService;
}

- (NSString *)uuid
{
	return m_sUuid;
}

- (void)setUuid:(NSString *)sUuid
{
	m_sUuid = sUuid;
}

- (NSString *)username
{
	return m_sUsername;
}

- (void)setUsername:(NSString *)sUsername
{
	m_sUsername = sUsername;
}

- (NSString *)email
{
	return m_sEmail;
}

- (void)setEmail:(NSString *)sEmail
{
	m_sEmail = sEmail;
}

- (NSString *)languagePreference
{
	return m_sLanguagePreference;
}

- (void)setLanguagePreference:(NSString *)sLanguagePreference
{
	m_sLanguagePreference = sLanguagePreference;
}

- (NSString *)firstName
{
	return m_sFirstName;
}

- (void)setFirstName:(NSString *)sFirstName
{
	m_sFirstName = sFirstName;
}

- (NSString *)lastName
{
	return m_sLastName;
}

- (void)setLastName:(NSString *)sLastName
{
	m_sLastName = sLastName;
}

- (NSString *)nickName
{
	return m_sNickName;
}

- (void)setNickName:(NSString *)sNickName
{
	m_sNickName = sNickName;
}

- (NSString *)profileType
{
	return m_sProfileType;
}

- (void)setProfileType:(NSString *)sProfileType
{
	m_sProfileType = sProfileType;
}

- (NSString *)avatar
{
	return m_sAvatar;
}

- (void)setAvatar:(NSString *)sAvatar
{
	m_sAvatar = sAvatar;
}

- (UserDataProfile *)profile
{
	return m_oProfile;
}

- (void)setProfile:(UserDataProfile *)oProfile
{
	m_oProfile = oProfile;
}

- (NSMutableArray<UserDataBadge *> *)acquiredBadges
{
	return m_lAcquiredBadges;
}

- (void)setAcquiredBadges:(NSMutableArray<UserDataBadge *> *)lAcquiredBadges
{
	m_lAcquiredBadges = lAcquiredBadges;
}

- (NSMutableArray<UserDataBadge *> *)nextBadges
{
	return m_lNextBadges;
}

- (void)setNextBadges:(NSMutableArray<UserDataBadge *> *)lNextBadges
{
	m_lNextBadges = lNextBadges;
}

- (HealthBenefits *)totalHealthBenefits
{
	return m_oTotalHealthBenefits;
}

- (void)setTotalHealthBenefits:(HealthBenefits *)oTotalHealthBenefits
{
	m_oTotalHealthBenefits = oTotalHealthBenefits;
}

- (Emissions *)totalEmissions
{
	return m_oTotalEmissions;
}

- (void)setTotalEmissions:(Emissions *)oTotalEmissions
{
	m_oTotalEmissions = oTotalEmissions;
}

- (UserDataTotalDistanceKm *)totalDistanceKm
{
	return m_oTotalDistanceKm;
}

- (void)setTotalDistanceKm:(UserDataTotalDistanceKm *)oTotalDistanceKm
{
	m_oTotalDistanceKm = oTotalDistanceKm;
}

- (UserDataTotalTravels *)totalTravels
{
	return m_oTotalTravels;
}

- (void)setTotalTravels:(UserDataTotalTravels *)oTotalTravels
{
	m_oTotalTravels = oTotalTravels;
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

	id ob = [d objectForKey:@"accepted_terms_of_service"];
	if(!ob)
	{
		m_bAcceptedTermsOfService = false;
	} else {
		m_bAcceptedTermsOfService = [STSTypeConversion objectToBool:ob withDefault:false];
	}
	ob = [d objectForKey:@"uuid"];
	if(!ob)
	{
		m_sUuid = nil;
	} else {
		m_sUuid = [STSTypeConversion objectToString:ob withDefault:nil];
	}
	ob = [d objectForKey:@"username"];
	if(!ob)
	{
		m_sUsername = nil;
	} else {
		m_sUsername = [STSTypeConversion objectToString:ob withDefault:nil];
	}
	ob = [d objectForKey:@"email"];
	if(!ob)
	{
		m_sEmail = nil;
	} else {
		m_sEmail = [STSTypeConversion objectToString:ob withDefault:nil];
	}
	ob = [d objectForKey:@"language_preference"];
	if(!ob)
	{
		m_sLanguagePreference = nil;
	} else {
		m_sLanguagePreference = [STSTypeConversion objectToString:ob withDefault:nil];
	}
	ob = [d objectForKey:@"first_name"];
	if(!ob)
	{
		m_sFirstName = nil;
	} else {
		m_sFirstName = [STSTypeConversion objectToString:ob withDefault:nil];
	}
	ob = [d objectForKey:@"last_name"];
	if(!ob)
	{
		m_sLastName = nil;
	} else {
		m_sLastName = [STSTypeConversion objectToString:ob withDefault:nil];
	}
	ob = [d objectForKey:@"nickname"];
	if(!ob)
	{
		m_sNickName = nil;
	} else {
		m_sNickName = [STSTypeConversion objectToString:ob withDefault:nil];
	}
	ob = [d objectForKey:@"profile_type"];
	if(!ob)
	{
		m_sProfileType = nil;
	} else {
		m_sProfileType = [STSTypeConversion objectToString:ob withDefault:nil];
	}
	ob = [d objectForKey:@"avatar"];
	if(!ob)
	{
		m_sAvatar = nil;
	} else {
		m_sAvatar = [STSTypeConversion objectToString:ob withDefault:nil];
	}
	ob = [d objectForKey:@"profile"];
	if(!ob)
	{
		m_oProfile = nil;
	} else {
		NSDictionary * pDict = [STSTypeConversion objectToDictionary:ob withDefault:nil];
		if(!pDict)
		{
			m_oProfile = nil;
		} else {
			m_oProfile = [UserDataProfile new];
			NSString * szErr = [m_oProfile decodeJSON:pDict];
			if((szErr != nil) && (szErr.length > 0))
				m_oProfile = nil;
		}
	}
	ob = [d objectForKey:@"acquired_badges"];
	if(!ob)
	{
		m_lAcquiredBadges = nil;
	} else {
		NSArray * xx = [STSTypeConversion objectToArray:ob withDefault:nil];
		if(!xx)
		{
			m_lAcquiredBadges = nil;
		} else {
			m_lAcquiredBadges = [NSMutableArray new];
			NSString * szErr = [self _decodeListOfUserDataBadge:m_lAcquiredBadges fromJSON:xx];
			if((szErr != nil) && (szErr.length > 0))
				return szErr;
		}
	}
	ob = [d objectForKey:@"next_badges"];
	if(!ob)
	{
		m_lNextBadges = nil;
	} else {
		NSArray * xx = [STSTypeConversion objectToArray:ob withDefault:nil];
		if(!xx)
		{
			m_lNextBadges = nil;
		} else {
			m_lNextBadges = [NSMutableArray new];
			NSString * szErr = [self _decodeListOfUserDataBadge:m_lNextBadges fromJSON:xx];
			if((szErr != nil) && (szErr.length > 0))
				return szErr;
		}
	}
	ob = [d objectForKey:@"total_health_benefits"];
	if(!ob)
	{
		m_oTotalHealthBenefits = nil;
	} else {
		NSDictionary * pDict = [STSTypeConversion objectToDictionary:ob withDefault:nil];
		if(!pDict)
		{
			m_oTotalHealthBenefits = nil;
		} else {
			m_oTotalHealthBenefits = [HealthBenefits new];
			NSString * szErr = [m_oTotalHealthBenefits decodeJSON:pDict];
			if((szErr != nil) && (szErr.length > 0))
				m_oTotalHealthBenefits = nil;
		}
	}
	ob = [d objectForKey:@"total_emissions"];
	if(!ob)
	{
		m_oTotalEmissions = nil;
	} else {
		NSDictionary * pDict = [STSTypeConversion objectToDictionary:ob withDefault:nil];
		if(!pDict)
		{
			m_oTotalEmissions = nil;
		} else {
			m_oTotalEmissions = [Emissions new];
			NSString * szErr = [m_oTotalEmissions decodeJSON:pDict];
			if((szErr != nil) && (szErr.length > 0))
				m_oTotalEmissions = nil;
		}
	}
	ob = [d objectForKey:@"total_distance_km"];
	if(!ob)
	{
		m_oTotalDistanceKm = nil;
	} else {
		NSDictionary * pDict = [STSTypeConversion objectToDictionary:ob withDefault:nil];
		if(!pDict)
		{
			m_oTotalDistanceKm = nil;
		} else {
			m_oTotalDistanceKm = [UserDataTotalDistanceKm new];
			NSString * szErr = [m_oTotalDistanceKm decodeJSON:pDict];
			if((szErr != nil) && (szErr.length > 0))
				m_oTotalDistanceKm = nil;
		}
	}
	ob = [d objectForKey:@"total_travels"];
	if(!ob)
	{
		m_oTotalTravels = nil;
	} else {
		NSDictionary * pDict = [STSTypeConversion objectToDictionary:ob withDefault:nil];
		if(!pDict)
		{
			m_oTotalTravels = nil;
		} else {
			m_oTotalTravels = [UserDataTotalTravels new];
			NSString * szErr = [m_oTotalTravels decodeJSON:pDict];
			if((szErr != nil) && (szErr.length > 0))
				m_oTotalTravels = nil;
		}
	}
	return nil;
}

- (NSString *)_decodeListOfUserDataBadge:(NSMutableArray<UserDataBadge *> *)lOut fromJSON:(NSArray *)lIn
{
	for(id ob in lIn)
	{
		NSDictionary * pDict = [STSTypeConversion objectToDictionary:ob withDefault:nil];
		if(!pDict)
			continue;
		UserDataBadge * pObj = [UserDataBadge new];
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
	[x setObject:[NSNumber numberWithBool:m_bAcceptedTermsOfService] forKey:@"accepted_terms_of_service"];
	[x setObject:(m_sUuid ? m_sUuid : [NSNull null]) forKey:@"uuid"];
	[x setObject:(m_sUsername ? m_sUsername : [NSNull null]) forKey:@"username"];
	[x setObject:(m_sEmail ? m_sEmail : [NSNull null]) forKey:@"email"];
	[x setObject:(m_sLanguagePreference ? m_sLanguagePreference : [NSNull null]) forKey:@"language_preference"];
	[x setObject:(m_sFirstName ? m_sFirstName : [NSNull null]) forKey:@"first_name"];
	[x setObject:(m_sLastName ? m_sLastName : [NSNull null]) forKey:@"last_name"];
	[x setObject:(m_sNickName ? m_sNickName : [NSNull null]) forKey:@"nickname"];
	[x setObject:(m_sProfileType ? m_sProfileType : [NSNull null]) forKey:@"profile_type"];
	[x setObject:(m_sAvatar ? m_sAvatar : [NSNull null]) forKey:@"avatar"];
	[x setObject:(m_oProfile ? [m_oProfile encodeToJSON] : [NSNull null]) forKey:@"profile"];
	[x setObject:(m_lAcquiredBadges ? [self _encodeListOfUserDataBadgeToJSON:m_lAcquiredBadges] : [NSNull null]) forKey:@"acquired_badges"];
	[x setObject:(m_lNextBadges ? [self _encodeListOfUserDataBadgeToJSON:m_lNextBadges] : [NSNull null]) forKey:@"next_badges"];
	[x setObject:(m_oTotalHealthBenefits ? [m_oTotalHealthBenefits encodeToJSON] : [NSNull null]) forKey:@"total_health_benefits"];
	[x setObject:(m_oTotalEmissions ? [m_oTotalEmissions encodeToJSON] : [NSNull null]) forKey:@"total_emissions"];
	[x setObject:(m_oTotalDistanceKm ? [m_oTotalDistanceKm encodeToJSON] : [NSNull null]) forKey:@"total_distance_km"];
	[x setObject:(m_oTotalTravels ? [m_oTotalTravels encodeToJSON] : [NSNull null]) forKey:@"total_travels"];
	return x;
}

- (NSMutableArray *)_encodeListOfUserDataBadgeToJSON:(NSMutableArray<UserDataBadge *> *)lList
{
	NSMutableArray * pOut = [NSMutableArray new];
	for(UserDataBadge * it in lList)
	{
		[pOut addObject:[it encodeToJSON]];
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

