#import <Foundation/Foundation.h>
#import "JSONConvertible.h"

@class BikeObservationProperties;

@interface BikeObservationBase : NSObject<JSONConvertible>

	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	// Getters and Setters
	///////////////////////////////////////////////////////////////////////////////////////////////////////////

	- (NSString *)geometry;
	- (void)setGeometry:(NSString *)sGeometry;
	- (BikeObservationProperties *)properties;
	- (void)setProperties:(BikeObservationProperties *)oProperties;

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

