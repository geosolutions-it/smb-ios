#import <Foundation/Foundation.h>
#import "CompetitionPrize.h"
#import "JSONConvertible.h"
#import "Sponsor.h"

@interface Competition : NSObject<JSONConvertible>

	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	// Getters and Setters
	///////////////////////////////////////////////////////////////////////////////////////////////////////////

	- (int)id;
	- (void)setId:(int)iId;
	- (NSString *)url;
	- (void)setUrl:(NSString *)sUrl;
	- (NSString *)name;
	- (void)setName:(NSString *)sName;
	- (NSString *)description;
	- (void)setDescription:(NSString *)sDescription;
	- (NSMutableArray<NSString *> *)ageGroups;
	- (void)setAgeGroups:(NSMutableArray<NSString *> *)lAgeGroups;
	- (NSString *)startDate;
	- (void)setStartDate:(NSString *)sStartDate;
	- (NSString *)endDate;
	- (void)setEndDate:(NSString *)sEndDate;
	- (NSMutableArray<NSString *> *)criteria;
	- (void)setCriteria:(NSMutableArray<NSString *> *)lCriteria;
	- (int)winnerThreshold;
	- (void)setWinnerThreshold:(int)iWinnerThreshold;
	- (NSString *)score;
	- (void)setScore:(NSString *)sScore;
	- (NSString *)leaderboard;
	- (void)setLeaderboard:(NSString *)sLeaderboard;
	- (NSMutableArray<CompetitionPrize *> *)prizes;
	- (void)setPrizes:(NSMutableArray<CompetitionPrize *> *)lPrizes;
	- (NSMutableArray<Sponsor *> *)sponsors;
	- (void)setSponsors:(NSMutableArray<Sponsor *> *)lSponsors;

	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	// JSON Manipulation
	///////////////////////////////////////////////////////////////////////////////////////////////////////////

	- (NSString *)decodeJSON:(id)x;
	- (NSString *)_decodeListOfSponsor:(NSMutableArray<Sponsor *> *)lOut fromJSON:(NSArray *)lIn;
	- (NSString *)_decodeListOfString:(NSMutableArray<NSString *> *)lOut fromJSON:(NSArray *)lIn;
	- (NSString *)_decodeListOfCompetitionPrize:(NSMutableArray<CompetitionPrize *> *)lOut fromJSON:(NSArray *)lIn;
	- (NSString *)decodeJSONString:(NSString *)szJSON;
	- (NSString *)decodeJSONData:(NSData *)oJSON;
	- (NSMutableDictionary *)encodeToJSON;
	- (NSMutableArray *)_encodeListOfSponsorToJSON:(NSMutableArray<Sponsor *> *)lList;
	- (NSMutableArray *)_encodeListOfCompetitionPrizeToJSON:(NSMutableArray<CompetitionPrize *> *)lList;
	- (NSMutableArray *)_encodeListOfStringToJSON:(NSMutableArray<NSString *> *)lList;
	- (NSString *)encodeToJSONString;
	- (NSString *)encodeToJSONStringHumanReadable:(bool)bHumanReadable;
	- (NSString *)encodeToJSONStringHumanReadable:(bool)bHumanReadable sortKeys:(bool)bSortKeys;
	- (NSData *)encodeToJSONData;
	- (NSData *)encodeToJSONDataHumanReadable:(bool)bHumanReadable;
	- (NSData *)encodeToJSONDataHumanReadable:(bool)bHumanReadable sortKeys:(bool)bSortKeys;

@end

