#import "Bike.h"
#import "BikeStatus.h"
#import "STSJSONParser.h"
#import "STSJSONWriter.h"
#import "STSTypeConversion.h"

@implementation Bike
{
	NSString * m_sUrl;

	NSString * m_sShortUUID;

	bool m_bOwner;

	NSMutableArray<NSString *> * m_lPictures;

	NSMutableArray<NSString *> * m_lTags;

	NSString * m_sLastUpdate;

	NSString * m_sBikeType;

	NSString * m_sGear;

	NSString * m_sBrake;

	NSString * m_sNickname;

	NSString * m_sBrand;

	NSString * m_sModel;

	NSString * m_sColor;

	NSString * m_sSaddle;

	bool m_bHasBasket;

	bool m_bHasCargoRack;

	bool m_bHasBags;

	NSString * m_sOtherDetails;

	BikeStatus * m_oCurrentStatus;

}

///////////////////////////////////////////////////////////////////////////////////////////////////////////
// Getters and Setters
///////////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSString *)url
{
	return m_sUrl;
}

- (void)setUrl:(NSString *)sUrl
{
	m_sUrl = sUrl;
}

- (NSString *)shortUUID
{
	return m_sShortUUID;
}

- (void)setShortUUID:(NSString *)sShortUUID
{
	m_sShortUUID = sShortUUID;
}

- (bool)owner
{
	return m_bOwner;
}

- (void)setOwner:(bool)bOwner
{
	m_bOwner = bOwner;
}

- (NSMutableArray<NSString *> *)pictures
{
	return m_lPictures;
}

- (void)setPictures:(NSMutableArray<NSString *> *)lPictures
{
	m_lPictures = lPictures;
}

- (NSMutableArray<NSString *> *)tags
{
	return m_lTags;
}

- (void)setTags:(NSMutableArray<NSString *> *)lTags
{
	m_lTags = lTags;
}

- (NSString *)lastUpdate
{
	return m_sLastUpdate;
}

- (void)setLastUpdate:(NSString *)sLastUpdate
{
	m_sLastUpdate = sLastUpdate;
}

- (NSString *)bikeType
{
	return m_sBikeType;
}

- (void)setBikeType:(NSString *)sBikeType
{
	m_sBikeType = sBikeType;
}

- (NSString *)gear
{
	return m_sGear;
}

- (void)setGear:(NSString *)sGear
{
	m_sGear = sGear;
}

- (NSString *)brake
{
	return m_sBrake;
}

- (void)setBrake:(NSString *)sBrake
{
	m_sBrake = sBrake;
}

- (NSString *)nickname
{
	return m_sNickname;
}

- (void)setNickname:(NSString *)sNickname
{
	m_sNickname = sNickname;
}

- (NSString *)brand
{
	return m_sBrand;
}

- (void)setBrand:(NSString *)sBrand
{
	m_sBrand = sBrand;
}

- (NSString *)model
{
	return m_sModel;
}

- (void)setModel:(NSString *)sModel
{
	m_sModel = sModel;
}

- (NSString *)color
{
	return m_sColor;
}

- (void)setColor:(NSString *)sColor
{
	m_sColor = sColor;
}

- (NSString *)saddle
{
	return m_sSaddle;
}

- (void)setSaddle:(NSString *)sSaddle
{
	m_sSaddle = sSaddle;
}

- (bool)hasBasket
{
	return m_bHasBasket;
}

- (void)setHasBasket:(bool)bHasBasket
{
	m_bHasBasket = bHasBasket;
}

- (bool)hasCargoRack
{
	return m_bHasCargoRack;
}

- (void)setHasCargoRack:(bool)bHasCargoRack
{
	m_bHasCargoRack = bHasCargoRack;
}

- (bool)hasBags
{
	return m_bHasBags;
}

- (void)setHasBags:(bool)bHasBags
{
	m_bHasBags = bHasBags;
}

- (NSString *)otherDetails
{
	return m_sOtherDetails;
}

- (void)setOtherDetails:(NSString *)sOtherDetails
{
	m_sOtherDetails = sOtherDetails;
}

- (BikeStatus *)currentStatus
{
	return m_oCurrentStatus;
}

- (void)setCurrentStatus:(BikeStatus *)oCurrentStatus
{
	m_oCurrentStatus = oCurrentStatus;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////
// JSON Manipulation
///////////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSString *)decodeJSON:(id)x
{
	if(!x)
		return @"null object";

	NSDictionary * d = [STSTypeConversion objectToDictionary:x withDefault:nil];
	if(!d)
		return @"Bad dictionary object";

	id ob = [d objectForKey:@"url"];
	if(!ob)
	{
		m_sUrl = nil;
	} else {
		m_sUrl = [STSTypeConversion objectToString:ob withDefault:nil];
	}
	ob = [d objectForKey:@"short_uuid"];
	if(!ob)
	{
		m_sShortUUID = nil;
	} else {
		m_sShortUUID = [STSTypeConversion objectToString:ob withDefault:nil];
	}
	ob = [d objectForKey:@"owner"];
	if(!ob)
	{
		m_bOwner = false;
	} else {
		m_bOwner = [STSTypeConversion objectToBool:ob withDefault:false];
	}
	ob = [d objectForKey:@"pictures"];
	if(!ob)
	{
		m_lPictures = nil;
	} else {
		NSArray * xx = [STSTypeConversion objectToArray:ob withDefault:nil];
		if(!xx)
		{
			m_lPictures = nil;
		} else {
			m_lPictures = [NSMutableArray new];
			NSString * szErr = [self _decodeListOfString:m_lPictures fromJSON:xx];
			if((szErr != nil) && (szErr.length > 0))
				return szErr;
		}
	}
	ob = [d objectForKey:@"tags"];
	if(!ob)
	{
		m_lTags = nil;
	} else {
		NSArray * xx = [STSTypeConversion objectToArray:ob withDefault:nil];
		if(!xx)
		{
			m_lTags = nil;
		} else {
			m_lTags = [NSMutableArray new];
			NSString * szErr = [self _decodeListOfString:m_lTags fromJSON:xx];
			if((szErr != nil) && (szErr.length > 0))
				return szErr;
		}
	}
	ob = [d objectForKey:@"last_update"];
	if(!ob)
	{
		m_sLastUpdate = nil;
	} else {
		m_sLastUpdate = [STSTypeConversion objectToString:ob withDefault:nil];
	}
	ob = [d objectForKey:@"bike_type"];
	if(!ob)
	{
		m_sBikeType = nil;
	} else {
		m_sBikeType = [STSTypeConversion objectToString:ob withDefault:nil];
	}
	ob = [d objectForKey:@"gear"];
	if(!ob)
	{
		m_sGear = nil;
	} else {
		m_sGear = [STSTypeConversion objectToString:ob withDefault:nil];
	}
	ob = [d objectForKey:@"brake"];
	if(!ob)
	{
		m_sBrake = nil;
	} else {
		m_sBrake = [STSTypeConversion objectToString:ob withDefault:nil];
	}
	ob = [d objectForKey:@"nickname"];
	if(!ob)
	{
		m_sNickname = nil;
	} else {
		m_sNickname = [STSTypeConversion objectToString:ob withDefault:nil];
	}
	ob = [d objectForKey:@"brand"];
	if(!ob)
	{
		m_sBrand = nil;
	} else {
		m_sBrand = [STSTypeConversion objectToString:ob withDefault:nil];
	}
	ob = [d objectForKey:@"model"];
	if(!ob)
	{
		m_sModel = nil;
	} else {
		m_sModel = [STSTypeConversion objectToString:ob withDefault:nil];
	}
	ob = [d objectForKey:@"color"];
	if(!ob)
	{
		m_sColor = nil;
	} else {
		m_sColor = [STSTypeConversion objectToString:ob withDefault:nil];
	}
	ob = [d objectForKey:@"saddle"];
	if(!ob)
	{
		m_sSaddle = nil;
	} else {
		m_sSaddle = [STSTypeConversion objectToString:ob withDefault:nil];
	}
	ob = [d objectForKey:@"has_basket"];
	if(!ob)
	{
		m_bHasBasket = false;
	} else {
		m_bHasBasket = [STSTypeConversion objectToBool:ob withDefault:false];
	}
	ob = [d objectForKey:@"has_cargo_rack"];
	if(!ob)
	{
		m_bHasCargoRack = false;
	} else {
		m_bHasCargoRack = [STSTypeConversion objectToBool:ob withDefault:false];
	}
	ob = [d objectForKey:@"has_bags"];
	if(!ob)
	{
		m_bHasBags = false;
	} else {
		m_bHasBags = [STSTypeConversion objectToBool:ob withDefault:false];
	}
	ob = [d objectForKey:@"other_details"];
	if(!ob)
	{
		m_sOtherDetails = nil;
	} else {
		m_sOtherDetails = [STSTypeConversion objectToString:ob withDefault:nil];
	}
	ob = [d objectForKey:@"current_status"];
	if(!ob)
	{
		m_oCurrentStatus = nil;
	} else {
		NSDictionary * pDict = [STSTypeConversion objectToDictionary:ob withDefault:nil];
		if(!pDict)
		{
			m_oCurrentStatus = nil;
		} else {
			m_oCurrentStatus = [BikeStatus new];
			NSString * szErr = [m_oCurrentStatus decodeJSON:pDict];
			if((szErr != nil) && (szErr.length > 0))
				m_oCurrentStatus = nil;
		}
	}
	return nil;
}

- (NSString *)_decodeListOfString:(NSMutableArray<NSString *> *)lOut fromJSON:(NSArray *)lIn
{
	for(id ob in lIn)
	{
		if(![ob isKindOfClass:[NSString class]])
			[lOut addObject:[STSTypeConversion objectToString:ob withDefault:nil]];
		else
			[lOut addObject:ob];
	}
	return nil;
}

- (NSString *)decodeJSONString:(NSString *)szJSON
{
	if(!szJSON)
		return @"Null json input";
	STSJSONParser * p = [STSJSONParser new];
	p.maxDepth = 256;
	id obj = [p objectWithString:szJSON];
	if(!obj)
		return p.error ? p.error : @"Failed to decode JSON";
	return [self decodeJSON:obj];
}

- (NSString *)decodeJSONData:(NSData *)oJSON
{
	if(!oJSON)
		return @"Null json input";
	STSJSONParser * p = [STSJSONParser new];
	p.maxDepth = 256;
	id obj = [p objectWithData:oJSON];
	if(!obj)
		return p.error ? p.error : @"Failed to decode JSON";
	return [self decodeJSON:obj];
}

- (NSMutableDictionary *)encodeToJSON
{
	NSMutableDictionary * x = [NSMutableDictionary new];
	[x setObject:(m_sUrl ? m_sUrl : [NSNull null]) forKey:@"url"];
	[x setObject:(m_sShortUUID ? m_sShortUUID : [NSNull null]) forKey:@"short_uuid"];
	[x setObject:[NSNumber numberWithBool:m_bOwner] forKey:@"owner"];
	[x setObject:(m_lPictures ? [self _encodeListOfStringToJSON:m_lPictures] : [NSNull null]) forKey:@"pictures"];
	[x setObject:(m_lTags ? [self _encodeListOfStringToJSON:m_lTags] : [NSNull null]) forKey:@"tags"];
	[x setObject:(m_sLastUpdate ? m_sLastUpdate : [NSNull null]) forKey:@"last_update"];
	[x setObject:(m_sBikeType ? m_sBikeType : [NSNull null]) forKey:@"bike_type"];
	[x setObject:(m_sGear ? m_sGear : [NSNull null]) forKey:@"gear"];
	[x setObject:(m_sBrake ? m_sBrake : [NSNull null]) forKey:@"brake"];
	[x setObject:(m_sNickname ? m_sNickname : [NSNull null]) forKey:@"nickname"];
	[x setObject:(m_sBrand ? m_sBrand : [NSNull null]) forKey:@"brand"];
	[x setObject:(m_sModel ? m_sModel : [NSNull null]) forKey:@"model"];
	[x setObject:(m_sColor ? m_sColor : [NSNull null]) forKey:@"color"];
	[x setObject:(m_sSaddle ? m_sSaddle : [NSNull null]) forKey:@"saddle"];
	[x setObject:[NSNumber numberWithBool:m_bHasBasket] forKey:@"has_basket"];
	[x setObject:[NSNumber numberWithBool:m_bHasCargoRack] forKey:@"has_cargo_rack"];
	[x setObject:[NSNumber numberWithBool:m_bHasBags] forKey:@"has_bags"];
	[x setObject:(m_sOtherDetails ? m_sOtherDetails : [NSNull null]) forKey:@"other_details"];
	[x setObject:(m_oCurrentStatus ? [m_oCurrentStatus encodeToJSON] : [NSNull null]) forKey:@"current_status"];
	return x;
}

- (NSMutableArray *)_encodeListOfStringToJSON:(NSMutableArray<NSString *> *)lList
{
	NSMutableArray * pOut = [NSMutableArray new];
	for(NSString * it in lList)
	{
		[pOut addObject:it];
	}
	return pOut;
}

- (NSString *)encodeToJSONString
{
	return [self encodeToJSONStringHumanReadable:false sortKeys:false];
}

- (NSString *)encodeToJSONStringHumanReadable:(bool)bHumanReadable
{
	return [self encodeToJSONStringHumanReadable:bHumanReadable sortKeys:false];
}

- (NSString *)encodeToJSONStringHumanReadable:(bool)bHumanReadable sortKeys:(bool)bSortKeys
{
	STSJSONWriter * w = [STSJSONWriter new];
	w.humanReadable = bHumanReadable;
	w.sortKeys = bSortKeys;
	w.maxDepth = 256;
	return [w stringWithObject:[self encodeToJSON]];
}

- (NSData *)encodeToJSONData
{
	return [self encodeToJSONDataHumanReadable:false sortKeys:false];
}

- (NSData *)encodeToJSONDataHumanReadable:(bool)bHumanReadable
{
	return [self encodeToJSONDataHumanReadable:bHumanReadable sortKeys:false];
}

- (NSData *)encodeToJSONDataHumanReadable:(bool)bHumanReadable sortKeys:(bool)bSortKeys
{
	STSJSONWriter * w = [STSJSONWriter new];
	w.humanReadable = bHumanReadable;
	w.sortKeys = bSortKeys;
	w.maxDepth = 256;
	return [w dataWithObject:[self encodeToJSON]];
}

@end

