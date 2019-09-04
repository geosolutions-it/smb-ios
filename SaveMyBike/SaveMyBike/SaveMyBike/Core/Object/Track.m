#import "Costs.h"
#import "Emissions.h"
#import "HealthBenefits.h"
#import "STSJSONParser.h"
#import "STSJSONWriter.h"
#import "STSTypeConversion.h"
#import "Track.h"

@implementation Track
{
	int m_iId;

	NSString * m_sUrl;

	long m_iSessionId;

	NSString * m_sOwner;

	NSString * m_sStartDate;

	NSString * m_sEndDate;

	double m_dDurationMinutes;

	double m_dLengthMeters;

	NSMutableArray<NSString *> * m_lVehicleTypes;

	bool m_bIsValid;

	NSString * m_sValidationError;

	Emissions * m_oEmissions;

	HealthBenefits * m_oHealth;

	Costs * m_oCosts;

	NSMutableArray<Segment *> * m_lSegments;

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

- (long)sessionId
{
	return m_iSessionId;
}

- (void)setSessionId:(long)iSessionId
{
	if(iSessionId == LONG_MIN)
		m_iSessionId = 0L;
	else
		m_iSessionId = iSessionId;
}

- (NSString *)owner
{
	return m_sOwner;
}

- (void)setOwner:(NSString *)sOwner
{
	m_sOwner = sOwner;
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

- (double)durationMinutes
{
	return m_dDurationMinutes;
}

- (void)setDurationMinutes:(double)dDurationMinutes
{
	if(dDurationMinutes == DBL_MIN)
		m_dDurationMinutes = 0.0;
	else
		m_dDurationMinutes = dDurationMinutes;
}

- (double)lengthMeters
{
	return m_dLengthMeters;
}

- (void)setLengthMeters:(double)dLengthMeters
{
	if(dLengthMeters == DBL_MIN)
		m_dLengthMeters = 0.0;
	else
		m_dLengthMeters = dLengthMeters;
}

- (NSMutableArray<NSString *> *)vehicleTypes
{
	return m_lVehicleTypes;
}

- (void)setVehicleTypes:(NSMutableArray<NSString *> *)lVehicleTypes
{
	m_lVehicleTypes = lVehicleTypes;
}

- (bool)isValid
{
	return m_bIsValid;
}

- (void)setIsValid:(bool)bIsValid
{
	m_bIsValid = bIsValid;
}

- (NSString *)validationError
{
	return m_sValidationError;
}

- (void)setValidationError:(NSString *)sValidationError
{
	m_sValidationError = sValidationError;
}

- (Emissions *)emissions
{
	return m_oEmissions;
}

- (void)setEmissions:(Emissions *)oEmissions
{
	m_oEmissions = oEmissions;
}

- (HealthBenefits *)health
{
	return m_oHealth;
}

- (void)setHealth:(HealthBenefits *)oHealth
{
	m_oHealth = oHealth;
}

- (Costs *)costs
{
	return m_oCosts;
}

- (void)setCosts:(Costs *)oCosts
{
	m_oCosts = oCosts;
}

- (NSMutableArray<Segment *> *)segments
{
	return m_lSegments;
}

- (void)setSegments:(NSMutableArray<Segment *> *)lSegments
{
	m_lSegments = lSegments;
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
	ob = [d objectForKey:@"session_id"];
	if(!ob)
	{
		m_iSessionId = 0L;
	} else {
		m_iSessionId = [STSTypeConversion objectToLong:ob withDefault:0L];
	}
	ob = [d objectForKey:@"owner"];
	if(!ob)
	{
		m_sOwner = nil;
	} else {
		m_sOwner = [STSTypeConversion objectToString:ob withDefault:nil];
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
	ob = [d objectForKey:@"duration_minutes"];
	if(!ob)
	{
		m_dDurationMinutes = 0.0;
	} else {
		m_dDurationMinutes = [STSTypeConversion objectToDouble:ob withDefault:0.0];
	}
	ob = [d objectForKey:@"length_meters"];
	if(!ob)
	{
		m_dLengthMeters = 0.0;
	} else {
		m_dLengthMeters = [STSTypeConversion objectToDouble:ob withDefault:0.0];
	}
	ob = [d objectForKey:@"vehicle_types"];
	if(!ob)
	{
		m_lVehicleTypes = nil;
	} else {
		NSArray * xx = [STSTypeConversion objectToArray:ob withDefault:nil];
		if(!xx)
		{
			m_lVehicleTypes = nil;
		} else {
			m_lVehicleTypes = [NSMutableArray new];
			NSString * szErr = [self _decodeListOfString:m_lVehicleTypes fromJSON:xx];
			if((szErr != nil) && (szErr.length > 0))
				return szErr;
		}
	}
	ob = [d objectForKey:@"is_valid"];
	if(!ob)
	{
		m_bIsValid = false;
	} else {
		m_bIsValid = [STSTypeConversion objectToBool:ob withDefault:false];
	}
	ob = [d objectForKey:@"validation_error"];
	if(!ob)
	{
		m_sValidationError = nil;
	} else {
		m_sValidationError = [STSTypeConversion objectToString:ob withDefault:nil];
	}
	ob = [d objectForKey:@"emissions"];
	if(!ob)
	{
		m_oEmissions = nil;
	} else {
		NSDictionary * pDict = [STSTypeConversion objectToDictionary:ob withDefault:nil];
		if(!pDict)
		{
			m_oEmissions = nil;
		} else {
			m_oEmissions = [Emissions new];
			NSString * szErr = [m_oEmissions decodeJSON:pDict];
			if((szErr != nil) && (szErr.length > 0))
				m_oEmissions = nil;
		}
	}
	ob = [d objectForKey:@"health"];
	if(!ob)
	{
		m_oHealth = nil;
	} else {
		NSDictionary * pDict = [STSTypeConversion objectToDictionary:ob withDefault:nil];
		if(!pDict)
		{
			m_oHealth = nil;
		} else {
			m_oHealth = [HealthBenefits new];
			NSString * szErr = [m_oHealth decodeJSON:pDict];
			if((szErr != nil) && (szErr.length > 0))
				m_oHealth = nil;
		}
	}
	ob = [d objectForKey:@"costs"];
	if(!ob)
	{
		m_oCosts = nil;
	} else {
		NSDictionary * pDict = [STSTypeConversion objectToDictionary:ob withDefault:nil];
		if(!pDict)
		{
			m_oCosts = nil;
		} else {
			m_oCosts = [Costs new];
			NSString * szErr = [m_oCosts decodeJSON:pDict];
			if((szErr != nil) && (szErr.length > 0))
				m_oCosts = nil;
		}
	}
	ob = [d objectForKey:@"segments"];
	if(!ob)
	{
		m_lSegments = nil;
	} else {
		NSArray * xx = [STSTypeConversion objectToArray:ob withDefault:nil];
		if(!xx)
		{
			m_lSegments = nil;
		} else {
			m_lSegments = [NSMutableArray new];
			NSString * szErr = [self _decodeListOfSegment:m_lSegments fromJSON:xx];
			if((szErr != nil) && (szErr.length > 0))
				return szErr;
		}
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

- (NSString *)_decodeListOfSegment:(NSMutableArray<Segment *> *)lOut fromJSON:(NSArray *)lIn
{
	for(id ob in lIn)
	{
		NSDictionary * pDict = [STSTypeConversion objectToDictionary:ob withDefault:nil];
		if(!pDict)
			continue;
		Segment * pObj = [Segment new];
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
	[x setObject:[NSNumber numberWithLong:m_iSessionId] forKey:@"session_id"];
	[x setObject:(m_sOwner ? m_sOwner : [NSNull null]) forKey:@"owner"];
	[x setObject:(m_sStartDate ? m_sStartDate : [NSNull null]) forKey:@"start_date"];
	[x setObject:(m_sEndDate ? m_sEndDate : [NSNull null]) forKey:@"end_date"];
	[x setObject:[NSNumber numberWithDouble:m_dDurationMinutes] forKey:@"duration_minutes"];
	[x setObject:[NSNumber numberWithDouble:m_dLengthMeters] forKey:@"length_meters"];
	[x setObject:(m_lVehicleTypes ? [self _encodeListOfStringToJSON:m_lVehicleTypes] : [NSNull null]) forKey:@"vehicle_types"];
	[x setObject:[NSNumber numberWithBool:m_bIsValid] forKey:@"is_valid"];
	[x setObject:(m_sValidationError ? m_sValidationError : [NSNull null]) forKey:@"validation_error"];
	[x setObject:(m_oEmissions ? [m_oEmissions encodeToJSON] : [NSNull null]) forKey:@"emissions"];
	[x setObject:(m_oHealth ? [m_oHealth encodeToJSON] : [NSNull null]) forKey:@"health"];
	[x setObject:(m_oCosts ? [m_oCosts encodeToJSON] : [NSNull null]) forKey:@"costs"];
	[x setObject:(m_lSegments ? [self _encodeListOfSegmentToJSON:m_lSegments] : [NSNull null]) forKey:@"segments"];
	return x;
}

- (NSMutableArray *)_encodeListOfSegmentToJSON:(NSMutableArray<Segment *> *)lList
{
	NSMutableArray * pOut = [NSMutableArray new];
	for(Segment * it in lList)
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

