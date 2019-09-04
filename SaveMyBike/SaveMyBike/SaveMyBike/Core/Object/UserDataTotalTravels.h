#import <Foundation/Foundation.h>
#import "JSONConvertible.h"

@interface UserDataTotalTravels : NSObject<JSONConvertible>

	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	// Getters and Setters
	///////////////////////////////////////////////////////////////////////////////////////////////////////////

	- (int)motorcycle;
	- (void)setMotorcycle:(int)iMotorcycle;
	- (int)foot;
	- (void)setFoot:(int)iFoot;

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

