#import <Foundation/Foundation.h>
#import "JSONConvertible.h"

@class Competition;

@interface CompetitionParticipation : NSObject<JSONConvertible>

	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	// Getters and Setters
	///////////////////////////////////////////////////////////////////////////////////////////////////////////

	- (int)id;
	- (void)setId:(int)iId;
	- (NSString *)url;
	- (void)setUrl:(NSString *)sUrl;
	- (NSString *)registrationStatus;
	- (void)setRegistrationStatus:(NSString *)sRegistrationStatus;
	- (NSString *)score;
	- (void)setScore:(NSString *)sScore;
	- (Competition *)competition;
	- (void)setCompetition:(Competition *)oCompetition;

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

