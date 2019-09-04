#import <Foundation/Foundation.h>
#import "JSONConvertible.h"

@interface Device : NSObject<JSONConvertible>

	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	// Getters and Setters
	///////////////////////////////////////////////////////////////////////////////////////////////////////////

	- (int)id;
	- (void)setId:(int)iId;
	- (NSString *)name;
	- (void)setName:(NSString *)sName;
	- (NSString *)registrationId;
	- (void)setRegistrationId:(NSString *)sRegistrationId;
	- (NSString *)deviceId;
	- (void)setDeviceId:(NSString *)sDeviceId;
	- (bool)active;
	- (void)setActive:(bool)bActive;
	- (NSString *)dateCreated;
	- (void)setDateCreated:(NSString *)sDateCreated;
	- (NSString *)type;
	- (void)setType:(NSString *)sType;

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

