#import <Foundation/Foundation.h>
#import "JSONConvertible.h"

@interface Costs : NSObject<JSONConvertible>

	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	// Getters and Setters
	///////////////////////////////////////////////////////////////////////////////////////////////////////////

	- (double)fuelCost;
	- (void)setFuelCost:(double)dFuelCost;
	- (double)timeCost;
	- (void)setTimeCost:(double)dTimeCost;
	- (double)totalCost;
	- (void)setTotalCost:(double)dTotalCost;
	- (double)operationCost;
	- (void)setOperationCost:(double)dOperationCost;
	- (double)depreciationCost;
	- (void)setDepreciationCost:(double)dDepreciationCost;

	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	// JSON Manipulation
	///////////////////////////////////////////////////////////////////////////////////////////////////////////

	- (NSString *)decodeJSON:(id)x;
	- (NSString *)decodeJSONString:(NSString *)szJSON;
	- (NSString *)decodeJSONData:(NSData *)oJSON;
	- (NSMutableDictionary *)encodeToJSON;
	- (NSString *)encodeToJSONString;
	- (NSString *)encodeToJSONStringHumanReadable:(bool)bHumanReadable;
	- (NSString *)encodeToJSONStringHumanReadable:(bool)bHumanReadable sortKeys:(bool)bSortKeys;
	- (NSData *)encodeToJSONData;
	- (NSData *)encodeToJSONDataHumanReadable:(bool)bHumanReadable;
	- (NSData *)encodeToJSONDataHumanReadable:(bool)bHumanReadable sortKeys:(bool)bSortKeys;

@end

