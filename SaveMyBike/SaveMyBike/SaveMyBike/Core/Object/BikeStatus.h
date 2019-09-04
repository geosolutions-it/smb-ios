#import <Foundation/Foundation.h>
#import "JSONConvertible.h"

@interface BikeStatus : NSObject<JSONConvertible>

	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	// Getters and Setters
	///////////////////////////////////////////////////////////////////////////////////////////////////////////

	- (int)id;
	- (void)setId:(int)iId;
	- (NSString *)bike;
	- (void)setBike:(NSString *)sBike;
	- (NSString *)url;
	- (void)setUrl:(NSString *)sUrl;
	- (bool)lost;
	- (void)setLost:(bool)bLost;
	- (NSString *)details;
	- (void)setDetails:(NSString *)sDetails;
	- (NSString *)position;
	- (void)setPosition:(NSString *)sPosition;
	- (NSString *)creationDate;
	- (void)setCreationDate:(NSString *)sCreationDate;

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

