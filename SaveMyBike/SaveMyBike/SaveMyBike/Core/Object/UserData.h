#import <Foundation/Foundation.h>
#import "JSONConvertible.h"
#import "UserDataBadge.h"

@class Emissions;
@class HealthBenefits;
@class UserDataProfile;
@class UserDataTotalDistanceKm;
@class UserDataTotalTravels;

@interface UserData : NSObject<JSONConvertible>

	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	// Getters and Setters
	///////////////////////////////////////////////////////////////////////////////////////////////////////////

	- (bool)acceptedTermsOfService;
	- (void)setAcceptedTermsOfService:(bool)bAcceptedTermsOfService;
	- (NSString *)uuid;
	- (void)setUuid:(NSString *)sUuid;
	- (NSString *)username;
	- (void)setUsername:(NSString *)sUsername;
	- (NSString *)email;
	- (void)setEmail:(NSString *)sEmail;
	- (NSString *)languagePreference;
	- (void)setLanguagePreference:(NSString *)sLanguagePreference;
	- (NSString *)firstName;
	- (void)setFirstName:(NSString *)sFirstName;
	- (NSString *)lastName;
	- (void)setLastName:(NSString *)sLastName;
	- (NSString *)nickName;
	- (void)setNickName:(NSString *)sNickName;
	- (NSString *)profileType;
	- (void)setProfileType:(NSString *)sProfileType;
	- (NSString *)avatar;
	- (void)setAvatar:(NSString *)sAvatar;
	- (UserDataProfile *)profile;
	- (void)setProfile:(UserDataProfile *)oProfile;
	- (NSMutableArray<UserDataBadge *> *)acquiredBadges;
	- (void)setAcquiredBadges:(NSMutableArray<UserDataBadge *> *)lAcquiredBadges;
	- (NSMutableArray<UserDataBadge *> *)nextBadges;
	- (void)setNextBadges:(NSMutableArray<UserDataBadge *> *)lNextBadges;
	- (HealthBenefits *)totalHealthBenefits;
	- (void)setTotalHealthBenefits:(HealthBenefits *)oTotalHealthBenefits;
	- (Emissions *)totalEmissions;
	- (void)setTotalEmissions:(Emissions *)oTotalEmissions;
	- (UserDataTotalDistanceKm *)totalDistanceKm;
	- (void)setTotalDistanceKm:(UserDataTotalDistanceKm *)oTotalDistanceKm;
	- (UserDataTotalTravels *)totalTravels;
	- (void)setTotalTravels:(UserDataTotalTravels *)oTotalTravels;

	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	// JSON Manipulation
	///////////////////////////////////////////////////////////////////////////////////////////////////////////

	- (NSString *)decodeJSON:(id)x;
	- (NSString *)_decodeListOfUserDataBadge:(NSMutableArray<UserDataBadge *> *)lOut fromJSON:(NSArray *)lIn;
	- (NSString *)decodeJSONString:(NSString *)szJSON;
	- (NSString *)decodeJSONData:(NSData *)oJSON;
	- (NSMutableDictionary *)encodeToJSON;
	- (NSMutableArray *)_encodeListOfUserDataBadgeToJSON:(NSMutableArray<UserDataBadge *> *)lList;
	- (NSString *)encodeToJSONString;
	- (NSString *)encodeToJSONStringHumanReadable:(bool)bHumanReadable;
	- (NSString *)encodeToJSONStringHumanReadable:(bool)bHumanReadable sortKeys:(bool)bSortKeys;
	- (NSData *)encodeToJSONData;
	- (NSData *)encodeToJSONDataHumanReadable:(bool)bHumanReadable;
	- (NSData *)encodeToJSONDataHumanReadable:(bool)bHumanReadable sortKeys:(bool)bSortKeys;

@end

