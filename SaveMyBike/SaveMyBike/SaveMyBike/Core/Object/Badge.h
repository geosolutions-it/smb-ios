#import <Foundation/Foundation.h>
#import "JSONConvertible.h"

@interface Badge : NSObject<JSONConvertible>

	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	// Getters and Setters
	///////////////////////////////////////////////////////////////////////////////////////////////////////////

	- (int)id;
	- (void)setId:(int)iId;
	- (NSString *)url;
	- (void)setUrl:(NSString *)sUrl;
	- (NSString *)name;
	- (void)setName:(NSString *)sName;
	- (bool)acquired;
	- (void)setAcquired:(bool)bAcquired;
	- (NSString *)description;
	- (void)setDescription:(NSString *)sDescription;
	- (NSString *)category;
	- (void)setCategory:(NSString *)sCategory;

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

