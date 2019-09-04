#import <Foundation/Foundation.h>
#import "JSONConvertible.h"

@interface Emissions : NSObject<JSONConvertible>

	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	// Getters and Setters
	///////////////////////////////////////////////////////////////////////////////////////////////////////////

	- (double)so2;
	- (void)setSo2:(double)dSo2;
	- (double)so2_saved;
	- (void)setSo2_saved:(double)dSo2_saved;
	- (double)nox;
	- (void)setNox:(double)dNox;
	- (double)nox_saved;
	- (void)setNox_saved:(double)dNox_saved;
	- (double)co2;
	- (void)setCo2:(double)dCo2;
	- (double)co2_saved;
	- (void)setCo2_saved:(double)dCo2_saved;
	- (double)co;
	- (void)setCo:(double)dCo;
	- (double)co_saved;
	- (void)setCo_saved:(double)dCo_saved;
	- (double)pm10;
	- (void)setPm10:(double)dPm10;
	- (double)pm10_saved;
	- (void)setPm10_saved:(double)dPm10_saved;

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

