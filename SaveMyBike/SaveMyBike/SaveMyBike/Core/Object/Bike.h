#import <Foundation/Foundation.h>
#import "JSONConvertible.h"

@class BikeStatus;

@interface Bike : NSObject<JSONConvertible>

	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	// Getters and Setters
	///////////////////////////////////////////////////////////////////////////////////////////////////////////

	- (NSString *)url;
	- (void)setUrl:(NSString *)sUrl;
	- (NSString *)shortUUID;
	- (void)setShortUUID:(NSString *)sShortUUID;
	- (bool)owner;
	- (void)setOwner:(bool)bOwner;
	- (NSMutableArray<NSString *> *)pictures;
	- (void)setPictures:(NSMutableArray<NSString *> *)lPictures;
	- (NSMutableArray<NSString *> *)tags;
	- (void)setTags:(NSMutableArray<NSString *> *)lTags;
	- (NSString *)lastUpdate;
	- (void)setLastUpdate:(NSString *)sLastUpdate;
	- (NSString *)bikeType;
	- (void)setBikeType:(NSString *)sBikeType;
	- (NSString *)gear;
	- (void)setGear:(NSString *)sGear;
	- (NSString *)brake;
	- (void)setBrake:(NSString *)sBrake;
	- (NSString *)nickname;
	- (void)setNickname:(NSString *)sNickname;
	- (NSString *)brand;
	- (void)setBrand:(NSString *)sBrand;
	- (NSString *)model;
	- (void)setModel:(NSString *)sModel;
	- (NSString *)color;
	- (void)setColor:(NSString *)sColor;
	- (NSString *)saddle;
	- (void)setSaddle:(NSString *)sSaddle;
	- (bool)hasBasket;
	- (void)setHasBasket:(bool)bHasBasket;
	- (bool)hasCargoRack;
	- (void)setHasCargoRack:(bool)bHasCargoRack;
	- (bool)hasBags;
	- (void)setHasBags:(bool)bHasBags;
	- (NSString *)otherDetails;
	- (void)setOtherDetails:(NSString *)sOtherDetails;
	- (BikeStatus *)currentStatus;
	- (void)setCurrentStatus:(BikeStatus *)oCurrentStatus;

	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	// JSON Manipulation
	///////////////////////////////////////////////////////////////////////////////////////////////////////////

	- (NSString *)decodeJSON:(id)x;
	- (NSString *)_decodeListOfString:(NSMutableArray<NSString *> *)lOut fromJSON:(NSArray *)lIn;
	- (NSString *)decodeJSONString:(NSString *)szJSON;
	- (NSString *)decodeJSONData:(NSData *)oJSON;
	- (NSMutableDictionary *)encodeToJSON;
	- (NSMutableArray *)_encodeListOfStringToJSON:(NSMutableArray<NSString *> *)lList;
	- (NSString *)encodeToJSONString;
	- (NSString *)encodeToJSONStringHumanReadable:(bool)bHumanReadable;
	- (NSString *)encodeToJSONStringHumanReadable:(bool)bHumanReadable sortKeys:(bool)bSortKeys;
	- (NSData *)encodeToJSONData;
	- (NSData *)encodeToJSONDataHumanReadable:(bool)bHumanReadable;
	- (NSData *)encodeToJSONDataHumanReadable:(bool)bHumanReadable sortKeys:(bool)bSortKeys;

@end

