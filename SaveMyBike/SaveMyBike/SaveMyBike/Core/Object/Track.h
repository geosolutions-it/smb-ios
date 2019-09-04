#import <Foundation/Foundation.h>
#import "JSONConvertible.h"
#import "Segment.h"

@class Costs;
@class Emissions;
@class HealthBenefits;

@interface Track : NSObject<JSONConvertible>

	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	// Getters and Setters
	///////////////////////////////////////////////////////////////////////////////////////////////////////////

	- (int)id;
	- (void)setId:(int)iId;
	- (NSString *)url;
	- (void)setUrl:(NSString *)sUrl;
	- (long)sessionId;
	- (void)setSessionId:(long)iSessionId;
	- (NSString *)owner;
	- (void)setOwner:(NSString *)sOwner;
	- (NSString *)startDate;
	- (void)setStartDate:(NSString *)sStartDate;
	- (NSString *)endDate;
	- (void)setEndDate:(NSString *)sEndDate;
	- (double)durationMinutes;
	- (void)setDurationMinutes:(double)dDurationMinutes;
	- (double)lengthMeters;
	- (void)setLengthMeters:(double)dLengthMeters;
	- (NSMutableArray<NSString *> *)vehicleTypes;
	- (void)setVehicleTypes:(NSMutableArray<NSString *> *)lVehicleTypes;
	- (bool)isValid;
	- (void)setIsValid:(bool)bIsValid;
	- (NSString *)validationError;
	- (void)setValidationError:(NSString *)sValidationError;
	- (Emissions *)emissions;
	- (void)setEmissions:(Emissions *)oEmissions;
	- (HealthBenefits *)health;
	- (void)setHealth:(HealthBenefits *)oHealth;
	- (Costs *)costs;
	- (void)setCosts:(Costs *)oCosts;
	- (NSMutableArray<Segment *> *)segments;
	- (void)setSegments:(NSMutableArray<Segment *> *)lSegments;

	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	// JSON Manipulation
	///////////////////////////////////////////////////////////////////////////////////////////////////////////

	- (NSString *)decodeJSON:(id)x;
	- (NSString *)_decodeListOfString:(NSMutableArray<NSString *> *)lOut fromJSON:(NSArray *)lIn;
	- (NSString *)_decodeListOfSegment:(NSMutableArray<Segment *> *)lOut fromJSON:(NSArray *)lIn;
	- (NSString *)decodeJSONString:(NSString *)szJSON;
	- (NSString *)decodeJSONData:(NSData *)oJSON;
	- (NSMutableDictionary *)encodeToJSON;
	- (NSMutableArray *)_encodeListOfSegmentToJSON:(NSMutableArray<Segment *> *)lList;
	- (NSMutableArray *)_encodeListOfStringToJSON:(NSMutableArray<NSString *> *)lList;
	- (NSString *)encodeToJSONString;
	- (NSString *)encodeToJSONStringHumanReadable:(bool)bHumanReadable;
	- (NSString *)encodeToJSONStringHumanReadable:(bool)bHumanReadable sortKeys:(bool)bSortKeys;
	- (NSData *)encodeToJSONData;
	- (NSData *)encodeToJSONDataHumanReadable:(bool)bHumanReadable;
	- (NSData *)encodeToJSONDataHumanReadable:(bool)bHumanReadable sortKeys:(bool)bSortKeys;

@end

