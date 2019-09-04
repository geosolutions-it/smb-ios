#import "STSJSONParser.h"
#import "STSJSONWriter.h"
#import "STSTypeConversion.h"
#import "Segment.h"

@implementation Segment
{
	int m_iId;

	NSString * m_sUrl;

	NSString * m_sTrack;

	NSString * m_sGeom;

	NSString * m_sStartDate;

	NSString * m_sEndDate;

	NSString * m_sVehicleType;

	NSString * m_sVehicleId;

	NSString * m_sEmissions;

	NSString * m_sCosts;

	NSString * m_sHealth;

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

- (NSString *)track
{
	return m_sTrack;
}

- (void)setTrack:(NSString *)sTrack
{
	m_sTrack = sTrack;
}

- (NSString *)geom
{
	return m_sGeom;
}

- (void)setGeom:(NSString *)sGeom
{
	m_sGeom = sGeom;
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

- (NSString *)vehicleType
{
	return m_sVehicleType;
}

- (void)setVehicleType:(NSString *)sVehicleType
{
	m_sVehicleType = sVehicleType;
}

- (NSString *)vehicleId
{
	return m_sVehicleId;
}

- (void)setVehicleId:(NSString *)sVehicleId
{
	m_sVehicleId = sVehicleId;
}

- (NSString *)emissions
{
	return m_sEmissions;
}

- (void)setEmissions:(NSString *)sEmissions
{
	m_sEmissions = sEmissions;
}

- (NSString *)costs
{
	return m_sCosts;
}

- (void)setCosts:(NSString *)sCosts
{
	m_sCosts = sCosts;
}

- (NSString *)health
{
	return m_sHealth;
}

- (void)setHealth:(NSString *)sHealth
{
	m_sHealth = sHealth;
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
	ob = [d objectForKey:@"track"];
	if(!ob)
	{
		m_sTrack = nil;
	} else {
		m_sTrack = [STSTypeConversion objectToString:ob withDefault:nil];
	}
	ob = [d objectForKey:@"geom"];
	if(!ob)
	{
		m_sGeom = nil;
	} else {
		m_sGeom = [STSTypeConversion objectToString:ob withDefault:nil];
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
	ob = [d objectForKey:@"vehicle_type"];
	if(!ob)
	{
		m_sVehicleType = nil;
	} else {
		m_sVehicleType = [STSTypeConversion objectToString:ob withDefault:nil];
	}
	ob = [d objectForKey:@"vehicle_id"];
	if(!ob)
	{
		m_sVehicleId = nil;
	} else {
		m_sVehicleId = [STSTypeConversion objectToString:ob withDefault:nil];
	}
	ob = [d objectForKey:@"emissions"];
	if(!ob)
	{
		m_sEmissions = nil;
	} else {
		m_sEmissions = [STSTypeConversion objectToString:ob withDefault:nil];
	}
	ob = [d objectForKey:@"costs"];
	if(!ob)
	{
		m_sCosts = nil;
	} else {
		m_sCosts = [STSTypeConversion objectToString:ob withDefault:nil];
	}
	ob = [d objectForKey:@"health"];
	if(!ob)
	{
		m_sHealth = nil;
	} else {
		m_sHealth = [STSTypeConversion objectToString:ob withDefault:nil];
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
	[x setObject:(m_sTrack ? m_sTrack : [NSNull null]) forKey:@"track"];
	[x setObject:(m_sGeom ? m_sGeom : [NSNull null]) forKey:@"geom"];
	[x setObject:(m_sStartDate ? m_sStartDate : [NSNull null]) forKey:@"start_date"];
	[x setObject:(m_sEndDate ? m_sEndDate : [NSNull null]) forKey:@"end_date"];
	[x setObject:(m_sVehicleType ? m_sVehicleType : [NSNull null]) forKey:@"vehicle_type"];
	[x setObject:(m_sVehicleId ? m_sVehicleId : [NSNull null]) forKey:@"vehicle_id"];
	[x setObject:(m_sEmissions ? m_sEmissions : [NSNull null]) forKey:@"emissions"];
	[x setObject:(m_sCosts ? m_sCosts : [NSNull null]) forKey:@"costs"];
	[x setObject:(m_sHealth ? m_sHealth : [NSNull null]) forKey:@"health"];
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

