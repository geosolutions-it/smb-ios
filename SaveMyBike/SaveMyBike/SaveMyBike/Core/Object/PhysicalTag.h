#import <Foundation/Foundation.h>
#import "JSONConvertible.h"

@interface PhysicalTag : NSObject<JSONConvertible>

	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	// Getters and Setters
	///////////////////////////////////////////////////////////////////////////////////////////////////////////

	- (NSString *)epc;
	- (void)setEpc:(NSString *)sEpc;
	- (NSString *)bike;
	- (void)setBike:(NSString *)sBike;
	- (NSString *)bikerUrl;
	- (void)setBikerUrl:(NSString *)sBikerUrl;
	- (NSString *)url;
	- (void)setUrl:(NSString *)sUrl;
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

