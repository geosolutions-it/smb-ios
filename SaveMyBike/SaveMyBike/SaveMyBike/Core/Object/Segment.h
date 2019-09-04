#import <Foundation/Foundation.h>
#import "JSONConvertible.h"

@interface Segment : NSObject<JSONConvertible>

	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	// Getters and Setters
	///////////////////////////////////////////////////////////////////////////////////////////////////////////

	- (int)id;
	- (void)setId:(int)iId;
	- (NSString *)url;
	- (void)setUrl:(NSString *)sUrl;
	- (NSString *)track;
	- (void)setTrack:(NSString *)sTrack;
	- (NSString *)geom;
	- (void)setGeom:(NSString *)sGeom;
	- (NSString *)startDate;
	- (void)setStartDate:(NSString *)sStartDate;
	- (NSString *)endDate;
	- (void)setEndDate:(NSString *)sEndDate;
	- (NSString *)vehicleType;
	- (void)setVehicleType:(NSString *)sVehicleType;
	- (NSString *)vehicleId;
	- (void)setVehicleId:(NSString *)sVehicleId;
	- (NSString *)emissions;
	- (void)setEmissions:(NSString *)sEmissions;
	- (NSString *)costs;
	- (void)setCosts:(NSString *)sCosts;
	- (NSString *)health;
	- (void)setHealth:(NSString *)sHealth;

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

