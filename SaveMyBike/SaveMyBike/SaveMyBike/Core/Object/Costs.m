#import "Costs.h"
#import "STSJSONParser.h"
#import "STSJSONWriter.h"
#import "STSTypeConversion.h"

@implementation Costs
{
	double m_dFuelCost;

	double m_dTimeCost;

	double m_dTotalCost;

	double m_dOperationCost;

	double m_dDepreciationCost;

}

///////////////////////////////////////////////////////////////////////////////////////////////////////////
// Getters and Setters
///////////////////////////////////////////////////////////////////////////////////////////////////////////

- (double)fuelCost
{
	return m_dFuelCost;
}

- (void)setFuelCost:(double)dFuelCost
{
	if(dFuelCost == DBL_MIN)
		m_dFuelCost = 0.0;
	else
		m_dFuelCost = dFuelCost;
}

- (double)timeCost
{
	return m_dTimeCost;
}

- (void)setTimeCost:(double)dTimeCost
{
	if(dTimeCost == DBL_MIN)
		m_dTimeCost = 0.0;
	else
		m_dTimeCost = dTimeCost;
}

- (double)totalCost
{
	return m_dTotalCost;
}

- (void)setTotalCost:(double)dTotalCost
{
	if(dTotalCost == DBL_MIN)
		m_dTotalCost = 0.0;
	else
		m_dTotalCost = dTotalCost;
}

- (double)operationCost
{
	return m_dOperationCost;
}

- (void)setOperationCost:(double)dOperationCost
{
	if(dOperationCost == DBL_MIN)
		m_dOperationCost = 0.0;
	else
		m_dOperationCost = dOperationCost;
}

- (double)depreciationCost
{
	return m_dDepreciationCost;
}

- (void)setDepreciationCost:(double)dDepreciationCost
{
	if(dDepreciationCost == DBL_MIN)
		m_dDepreciationCost = 0.0;
	else
		m_dDepreciationCost = dDepreciationCost;
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

	id ob = [d objectForKey:@"fuel_cost"];
	if(!ob)
	{
		m_dFuelCost = 0.0;
	} else {
		m_dFuelCost = [STSTypeConversion objectToDouble:ob withDefault:0.0];
	}
	ob = [d objectForKey:@"time_cost"];
	if(!ob)
	{
		m_dTimeCost = 0.0;
	} else {
		m_dTimeCost = [STSTypeConversion objectToDouble:ob withDefault:0.0];
	}
	ob = [d objectForKey:@"total_cost"];
	if(!ob)
	{
		m_dTotalCost = 0.0;
	} else {
		m_dTotalCost = [STSTypeConversion objectToDouble:ob withDefault:0.0];
	}
	ob = [d objectForKey:@"operation_cost"];
	if(!ob)
	{
		m_dOperationCost = 0.0;
	} else {
		m_dOperationCost = [STSTypeConversion objectToDouble:ob withDefault:0.0];
	}
	ob = [d objectForKey:@"depreciation_cost"];
	if(!ob)
	{
		m_dDepreciationCost = 0.0;
	} else {
		m_dDepreciationCost = [STSTypeConversion objectToDouble:ob withDefault:0.0];
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
	[x setObject:[NSNumber numberWithDouble:m_dFuelCost] forKey:@"fuel_cost"];
	[x setObject:[NSNumber numberWithDouble:m_dTimeCost] forKey:@"time_cost"];
	[x setObject:[NSNumber numberWithDouble:m_dTotalCost] forKey:@"total_cost"];
	[x setObject:[NSNumber numberWithDouble:m_dOperationCost] forKey:@"operation_cost"];
	[x setObject:[NSNumber numberWithDouble:m_dDepreciationCost] forKey:@"depreciation_cost"];
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

