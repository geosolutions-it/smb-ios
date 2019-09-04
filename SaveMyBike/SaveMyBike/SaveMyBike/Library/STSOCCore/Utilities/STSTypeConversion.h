//
//  STSTypeConversion.h
//
//  Created by Szymon Tomasz Stefanek on 01/11/12.
//  Copyright (c) 2012 Szymon Tomasz Stefanek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STSTypeConversion : NSObject

+ (NSDictionary *)objectToDictionary:(id)obj withDefault:(NSDictionary *)pDefault;
+ (NSArray *)objectToArray:(id)obj withDefault:(NSArray *)pDefault;
+ (NSString *)objectToString:(id)obj withDefault:(NSString *)pDefault;
+ (double)objectToDouble:(id)obj withDefault:(double)dDefault;
+ (float)objectToFloat:(id)obj withDefault:(float)fDefault;
+ (int)objectToInt:(id)obj withDefault:(int)iDefault;
+ (NSInteger)objectToInteger:(id)obj withDefault:(NSInteger)iDefault;
+ (short)objectToShort:(id)obj withDefault:(short)sDefault;
+ (char)objectToChar:(id)obj withDefault:(char)cDefault;
+ (long)objectToLong:(id)obj withDefault:(long)lDefault;
+ (bool)objectToBool:(id)obj withDefault:(bool)bDefault;

+ (NSDate *)objectToDate:(id)obj withDefault:(NSDate *)dtDefault;
+ (NSDate *)objectToDateTime:(id)obj withDefault:(NSDate *)dtDefault;
+ (NSDate *)objectToTime:(id)obj withDefault:(NSDate *)dtDefault;

+ (NSNumber *)objectToFloatOrNull:(id)obj;
+ (NSNumber *)objectToIntOrNull:(id)obj;
+ (NSNumber *)objectToLongOrNull:(id)obj;

// DEPRECATED NAME: use objectInDictionaryToString
+ (NSString *)dictionaryToString:(NSDictionary *)hDict key:(NSString *)sKey defaultValue:(NSString *)sDefault;
// DEPRECATED NAME: use objectInDictionaryToDouble
+ (double)dictionaryToDouble:(NSDictionary *)hDict key:(NSString *)sKey defaultValue:(double)dDefault;
// DEPRECATED NAME: use objectInDictionaryToInt
+ (int)dictionaryToInt:(NSDictionary *)hDict key:(NSString *)sKey defaultValue:(int)iDefault;

+ (NSString *)objectInDictionaryToString:(NSDictionary *)hDict key:(NSString *)sKey defaultValue:(NSString *)sDefault;
+ (double)objectInDictionaryToDouble:(NSDictionary *)hDict key:(NSString *)sKey defaultValue:(double)dDefault;
+ (float)objectInDictionaryToFloat:(NSDictionary *)hDict key:(NSString *)sKey defaultValue:(float)fDefault;
+ (int)objectInDictionaryToInt:(NSDictionary *)hDict key:(NSString *)sKey defaultValue:(int)iDefault;
+ (short)objectInDictionaryToShort:(NSDictionary *)hDict key:(NSString *)sKey defaultValue:(short)sDefault;
+ (char)objectInDictionaryToChar:(NSDictionary *)hDict key:(NSString *)sKey defaultValue:(char)cDefault;
+ (long)objectInDictionaryToLong:(NSDictionary *)hDict key:(NSString *)sKey defaultValue:(long)lDefault;
+ (bool)objectInDictionaryToBool:(NSDictionary *)hDict key:(NSString *)sKey defaultValue:(bool)bDefault;
+ (NSDictionary *)objectInDictionaryToDictionary:(NSDictionary *)hDict key:(NSString *)sKey defaultValue:(NSDictionary *)pDefault;
+ (NSArray *)objectInDictionaryToArray:(NSDictionary *)hDict key:(NSString *)sKey defaultValue:(NSArray *)pDefault;

+ (NSString *)doubleToString:(double)dValue;
+ (NSString *)doubleToString:(double)dValue withMaxDecimals:(int)iDecimals;

@end
