#import "Emissions.h"
#import "STSJSONParser.h"
#import "STSJSONWriter.h"
#import "STSTypeConversion.h"

@implementation Emissions
{
	double m_dSo2;

	double m_dSo2_saved;

	double m_dNox;

	double m_dNox_saved;

	double m_dCo2;

	double m_dCo2_saved;

	double m_dCo;

	double m_dCo_saved;

	double m_dPm10;

	double m_dPm10_saved;

}

///////////////////////////////////////////////////////////////////////////////////////////////////////////
// Getters and Setters
///////////////////////////////////////////////////////////////////////////////////////////////////////////

- (double)so2
{
	return m_dSo2;
}

- (void)setSo2:(double)dSo2
{
	if(dSo2 == DBL_MIN)
		m_dSo2 = 0.0;
	else
		m_dSo2 = dSo2;
}

- (double)so2_saved
{
	return m_dSo2_saved;
}

- (void)setSo2_saved:(double)dSo2_saved
{
	if(dSo2_saved == DBL_MIN)
		m_dSo2_saved = 0.0;
	else
		m_dSo2_saved = dSo2_saved;
}

- (double)nox
{
	return m_dNox;
}

- (void)setNox:(double)dNox
{
	if(dNox == DBL_MIN)
		m_dNox = 0.0;
	else
		m_dNox = dNox;
}

- (double)nox_saved
{
	return m_dNox_saved;
}

- (void)setNox_saved:(double)dNox_saved
{
	if(dNox_saved == DBL_MIN)
		m_dNox_saved = 0.0;
	else
		m_dNox_saved = dNox_saved;
}

- (double)co2
{
	return m_dCo2;
}

- (void)setCo2:(double)dCo2
{
	if(dCo2 == DBL_MIN)
		m_dCo2 = 0.0;
	else
		m_dCo2 = dCo2;
}

- (double)co2_saved
{
	return m_dCo2_saved;
}

- (void)setCo2_saved:(double)dCo2_saved
{
	if(dCo2_saved == DBL_MIN)
		m_dCo2_saved = 0.0;
	else
		m_dCo2_saved = dCo2_saved;
}

- (double)co
{
	return m_dCo;
}

- (void)setCo:(double)dCo
{
	if(dCo == DBL_MIN)
		m_dCo = 0.0;
	else
		m_dCo = dCo;
}

- (double)co_saved
{
	return m_dCo_saved;
}

- (void)setCo_saved:(double)dCo_saved
{
	if(dCo_saved == DBL_MIN)
		m_dCo_saved = 0.0;
	else
		m_dCo_saved = dCo_saved;
}

- (double)pm10
{
	return m_dPm10;
}

- (void)setPm10:(double)dPm10
{
	if(dPm10 == DBL_MIN)
		m_dPm10 = 0.0;
	else
		m_dPm10 = dPm10;
}

- (double)pm10_saved
{
	return m_dPm10_saved;
}

- (void)setPm10_saved:(double)dPm10_saved
{
	if(dPm10_saved == DBL_MIN)
		m_dPm10_saved = 0.0;
	else
		m_dPm10_saved = dPm10_saved;
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

	id ob = [d objectForKey:@"so2"];
	if(!ob)
	{
		m_dSo2 = 0.0;
	} else {
		m_dSo2 = [STSTypeConversion objectToDouble:ob withDefault:0.0];
	}
	ob = [d objectForKey:@"so2_saved"];
	if(!ob)
	{
		m_dSo2_saved = 0.0;
	} else {
		m_dSo2_saved = [STSTypeConversion objectToDouble:ob withDefault:0.0];
	}
	ob = [d objectForKey:@"nox"];
	if(!ob)
	{
		m_dNox = 0.0;
	} else {
		m_dNox = [STSTypeConversion objectToDouble:ob withDefault:0.0];
	}
	ob = [d objectForKey:@"nox_saved"];
	if(!ob)
	{
		m_dNox_saved = 0.0;
	} else {
		m_dNox_saved = [STSTypeConversion objectToDouble:ob withDefault:0.0];
	}
	ob = [d objectForKey:@"co2"];
	if(!ob)
	{
		m_dCo2 = 0.0;
	} else {
		m_dCo2 = [STSTypeConversion objectToDouble:ob withDefault:0.0];
	}
	ob = [d objectForKey:@"co2_saved"];
	if(!ob)
	{
		m_dCo2_saved = 0.0;
	} else {
		m_dCo2_saved = [STSTypeConversion objectToDouble:ob withDefault:0.0];
	}
	ob = [d objectForKey:@"co"];
	if(!ob)
	{
		m_dCo = 0.0;
	} else {
		m_dCo = [STSTypeConversion objectToDouble:ob withDefault:0.0];
	}
	ob = [d objectForKey:@"co_saved"];
	if(!ob)
	{
		m_dCo_saved = 0.0;
	} else {
		m_dCo_saved = [STSTypeConversion objectToDouble:ob withDefault:0.0];
	}
	ob = [d objectForKey:@"pm10"];
	if(!ob)
	{
		m_dPm10 = 0.0;
	} else {
		m_dPm10 = [STSTypeConversion objectToDouble:ob withDefault:0.0];
	}
	ob = [d objectForKey:@"pm10_saved"];
	if(!ob)
	{
		m_dPm10_saved = 0.0;
	} else {
		m_dPm10_saved = [STSTypeConversion objectToDouble:ob withDefault:0.0];
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
	[x setObject:[NSNumber numberWithDouble:m_dSo2] forKey:@"so2"];
	[x setObject:[NSNumber numberWithDouble:m_dSo2_saved] forKey:@"so2_saved"];
	[x setObject:[NSNumber numberWithDouble:m_dNox] forKey:@"nox"];
	[x setObject:[NSNumber numberWithDouble:m_dNox_saved] forKey:@"nox_saved"];
	[x setObject:[NSNumber numberWithDouble:m_dCo2] forKey:@"co2"];
	[x setObject:[NSNumber numberWithDouble:m_dCo2_saved] forKey:@"co2_saved"];
	[x setObject:[NSNumber numberWithDouble:m_dCo] forKey:@"co"];
	[x setObject:[NSNumber numberWithDouble:m_dCo_saved] forKey:@"co_saved"];
	[x setObject:[NSNumber numberWithDouble:m_dPm10] forKey:@"pm10"];
	[x setObject:[NSNumber numberWithDouble:m_dPm10_saved] forKey:@"pm10_saved"];
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

