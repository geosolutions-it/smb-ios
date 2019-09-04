#import <Foundation/Foundation.h>
#import "JSONConvertible.h"

@interface UserDataProfile : NSObject<JSONConvertible>

	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	// Getters and Setters
	///////////////////////////////////////////////////////////////////////////////////////////////////////////

	- (NSString *)gender;
	- (void)setGender:(NSString *)sGender;
	- (NSString *)age;
	- (void)setAge:(NSString *)sAge;
	- (NSString *)phoneNumber;
	- (void)setPhoneNumber:(NSString *)sPhoneNumber;
	- (NSString *)bio;
	- (void)setBio:(NSString *)sBio;
	- (NSString *)occupation;
	- (void)setOccupation:(NSString *)sOccupation;

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

