#import <Foundation/Foundation.h>
#import "JSONConvertible.h"

@interface BikeObservationProperties : NSObject<JSONConvertible>

	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	// Getters and Setters
	///////////////////////////////////////////////////////////////////////////////////////////////////////////

	- (int)id;
	- (void)setId:(int)iId;
	- (NSString *)bike;
	- (void)setBike:(NSString *)sBike;
	- (NSString *)bikeUrl;
	- (void)setBikeUrl:(NSString *)sBikeUrl;
	- (NSString *)reporterId;
	- (void)setReporterId:(NSString *)sReporterId;
	- (NSString *)reporterType;
	- (void)setReporterType:(NSString *)sReporterType;
	- (NSString *)reporterName;
	- (void)setReporterName:(NSString *)sReporterName;
	- (NSString *)address;
	- (void)setAddress:(NSString *)sAddress;
	- (NSString *)details;
	- (void)setDetails:(NSString *)sDetails;
	- (NSString *)position;
	- (void)setPosition:(NSString *)sPosition;
	- (NSString *)createdAt;
	- (void)setCreatedAt:(NSString *)sCreatedAt;
	- (NSString *)observedAt;
	- (void)setObservedAt:(NSString *)sObservedAt;

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

