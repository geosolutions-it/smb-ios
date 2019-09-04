//
//  STSTypeConversion.m
//
//  Created by Szymon Tomasz Stefanek on 01/11/12.
//  Copyright (c) 2012 Szymon Tomasz Stefanek. All rights reserved.
//

#import "STSTypeConversion.h"

#import "NSDate+Format.h"

@implementation STSTypeConversion

//
// Object
//

+ (NSDictionary *)objectToDictionary:(id)obj withDefault:(NSDictionary *)pDefault
{
	if((!obj) || (![obj isKindOfClass:[NSDictionary class]]))
		return pDefault;
	return (NSDictionary *)obj;
}

+ (NSArray *)objectToArray:(id)obj withDefault:(NSArray *)pDefault
{
	if((!obj) || (![obj isKindOfClass:[NSArray class]]))
		return pDefault;
	return (NSArray *)obj;
}

+ (NSDate *)objectToDateTime:(id)obj withDefault:(NSDate *)dtDefault
{
	if(!obj || [obj isKindOfClass:[NSNull class]])
		return dtDefault;
	
	if([obj isKindOfClass:[NSDate class]])
		return (NSDate *)obj;
	
	if([obj isKindOfClass:[NSString class]])
		return [NSDate dateFromAnyFormatString:(NSString *)obj withDefault:dtDefault];

	return dtDefault;
}

+ (NSDate *)objectToDate:(id)obj withDefault:(NSDate *)dtDefault
{
	return [self objectToDateTime:obj withDefault:dtDefault];
}

+ (NSDate *)objectToTime:(id)obj withDefault:(NSDate *)dtDefault
{
	return [self objectToDateTime:obj withDefault:dtDefault];
}

+ (NSString *)objectToString:(id)obj withDefault:(NSString *)pDefault
{
	if(!obj || [obj isKindOfClass:[NSNull class]])
		return pDefault;

	if([obj isKindOfClass:[NSString class]])
		return (NSString *)obj;
	
	if([obj isKindOfClass:[NSNumber class]])
		return [((NSNumber *)obj) stringValue];

	return pDefault;
}

+ (double)objectToDouble:(id)obj withDefault:(double)dDefault
{
	if(!obj || [obj isKindOfClass:[NSNull class]])
		return dDefault;

	if([obj isKindOfClass:[NSNumber class]])
	{
		NSNumber * n = (NSNumber *)obj;
		return [n doubleValue];
	}
	
	if([obj isKindOfClass:[NSString class]])
	{
		NSString * s = (NSString *)obj;
		if([s length] < 1)
			return dDefault;
		NSScanner * sc = [NSScanner scannerWithString:s];
		double d;
		if(![sc scanDouble:&d])
			return dDefault;
		return d;
	}

	return dDefault;	
}

+ (NSNumber *)objectToFloatOrNull:(id)obj
{
	if(!obj || [obj isKindOfClass:[NSNull class]])
		return nil;
	
	if([obj isKindOfClass:[NSNumber class]])
	{
		NSNumber * n = (NSNumber *)obj;
		return n;
	}
	
	if([obj isKindOfClass:[NSString class]])
	{
		NSString * s = (NSString *)obj;
		if([s length] < 1)
			return nil;
		NSScanner * sc = [NSScanner scannerWithString:s];
		float f;
		if(![sc scanFloat:&f])
			return nil;
		return [NSNumber numberWithFloat:f];
	}
	
	return nil;
}

+ (NSNumber *)objectToIntOrNull:(id)obj
{
	if(!obj || [obj isKindOfClass:[NSNull class]])
		return nil;
	
	if([obj isKindOfClass:[NSNumber class]])
	{
		NSNumber * n = (NSNumber *)obj;
		return n;
	}
	
	if([obj isKindOfClass:[NSString class]])
	{
		NSString * s = (NSString *)obj;
		if([s length] < 1)
			return nil;
		NSScanner * sc = [NSScanner scannerWithString:s];
		int f;
		if(![sc scanInt:&f])
			return nil;
		return [NSNumber numberWithInt:f];
	}
	
	return nil;
}

+ (NSNumber *)objectToLongOrNull:(id)obj
{
	if(!obj || [obj isKindOfClass:[NSNull class]])
		return nil;
	
	if([obj isKindOfClass:[NSNumber class]])
	{
		NSNumber * n = (NSNumber *)obj;
		return n;
	}
	
	if([obj isKindOfClass:[NSString class]])
	{
		NSString * s = (NSString *)obj;
		if([s length] < 1)
			return nil;
		NSScanner * sc = [NSScanner scannerWithString:s];
		long long f;
		if(![sc scanLongLong:&f])
			return nil;
		return [NSNumber numberWithLong:(long)f];
	}
	
	return nil;
}


+ (float)objectToFloat:(id)obj withDefault:(float)fDefault
{
	if(!obj || [obj isKindOfClass:[NSNull class]])
		return fDefault;
	
	if([obj isKindOfClass:[NSNumber class]])
	{
		NSNumber * n = (NSNumber *)obj;
		return [n floatValue];
	}
	
	if([obj isKindOfClass:[NSString class]])
	{
		NSString * s = (NSString *)obj;
		if([s length] < 1)
			return fDefault;
		NSScanner * sc = [NSScanner scannerWithString:s];
		float f;
		if(![sc scanFloat:&f])
			return fDefault;
		return f;
	}
	
	return fDefault;
}

+ (int)objectToInt:(id)obj withDefault:(int)iDefault
{
	if(!obj || [obj isKindOfClass:[NSNull class]])
		return iDefault;

	if([obj isKindOfClass:[NSNumber class]])
	{
		NSNumber * n = (NSNumber *)obj;
		return [n intValue];
	}
	
	if([obj isKindOfClass:[NSString class]])
	{
		NSString * s = (NSString *)obj;
		if([s length] < 1)
			return iDefault;
		NSScanner * sc = [NSScanner scannerWithString:s];
		int d;
		if(![sc scanInt:&d])
			return iDefault;
		return d;
	}
	
	return iDefault;	
}

+ (NSInteger)objectToInteger:(id)obj withDefault:(NSInteger)iDefault
{
	if(!obj || [obj isKindOfClass:[NSNull class]])
		return iDefault;

	if([obj isKindOfClass:[NSNumber class]])
	{
		NSNumber * n = (NSNumber *)obj;
		return [n integerValue];
	}

	if([obj isKindOfClass:[NSString class]])
	{
		NSString * s = (NSString *)obj;
		if([s length] < 1)
			return iDefault;
		NSScanner * sc = [NSScanner scannerWithString:s];
		NSInteger d;
		if(![sc scanInteger:&d])
			return iDefault;
		return d;
	}

	return iDefault;
}

+ (short)objectToShort:(id)obj withDefault:(short)sDefault
{
	if(!obj || [obj isKindOfClass:[NSNull class]])
		return sDefault;
	
	if([obj isKindOfClass:[NSNumber class]])
	{
		NSNumber * n = (NSNumber *)obj;
		return [n shortValue];
	}
	
	if([obj isKindOfClass:[NSString class]])
	{
		NSString * s = (NSString *)obj;
		if([s length] < 1)
			return sDefault;
		NSScanner * sc = [NSScanner scannerWithString:s];
		int d;
		if(![sc scanInt:&d])
			return sDefault;
		return (short)d;
	}
	
	return sDefault;
}

+ (char)objectToChar:(id)obj withDefault:(char)cDefault
{
	if(!obj || [obj isKindOfClass:[NSNull class]])
		return cDefault;
	
	if([obj isKindOfClass:[NSNumber class]])
	{
		NSNumber * n = (NSNumber *)obj;
		return [n charValue];
	}
	
	if([obj isKindOfClass:[NSString class]])
	{
		NSString * s = (NSString *)obj;
		if([s length] < 1)
			return cDefault;
		NSScanner * sc = [NSScanner scannerWithString:s];
		int d;
		if(![sc scanInt:&d])
			return cDefault;
		return (char)d;
	}
	
	return cDefault;
}

+ (long)objectToLong:(id)obj withDefault:(long)sDefault
{
	if(!obj || [obj isKindOfClass:[NSNull class]])
		return sDefault;
	
	if([obj isKindOfClass:[NSNumber class]])
	{
		NSNumber * n = (NSNumber *)obj;
		return [n longValue];
	}
	
	if([obj isKindOfClass:[NSString class]])
	{
		NSString * s = (NSString *)obj;
		if([s length] < 1)
			return sDefault;
		NSScanner * sc = [NSScanner scannerWithString:s];
		long long d;
		if(![sc scanLongLong:&d])
			return sDefault;
		return (long)d;
	}
	
	return sDefault;
}


+ (bool)objectToBool:(id)obj withDefault:(bool)bDefault
{
	if(!obj || [obj isKindOfClass:[NSNull class]])
		return bDefault;

	if([obj isKindOfClass:[NSNumber class]])
	{
		NSNumber * n = (NSNumber *)obj;
		return [n intValue] != 0;
	}
	
	if([obj isKindOfClass:[NSString class]])
	{
		NSString * s = (NSString *)obj;
		if([s length] < 1)
			return bDefault;
		NSString * low = [s lowercaseString];

		if([low isEqualToString:@"true"] || [low isEqualToString:@"yes"] || [low isEqualToString:@"y"])
			return true;

		if([low isEqualToString:@"false"] || [low isEqualToString:@"no"] || [low isEqualToString:@"n"])
			return false;
	
		NSScanner * sc = [NSScanner scannerWithString:s];
		int d;
		if(![sc scanInt:&d])
			return bDefault;
		return d != 0;
	}

	return bDefault;
}


//
// Dictionary
//

+ (NSString *)dictionaryToString:(NSDictionary *)hDict key:(NSString *)sKey defaultValue:(NSString *)sDefault
{
	if(!hDict || !sKey)
		return sDefault;

	return [STSTypeConversion objectToString:[hDict objectForKey:sKey]
								withDefault:sDefault];
}

+ (double)dictionaryToDouble:(NSDictionary *)hDict key:(NSString *)sKey defaultValue:(double)dDefault
{
	if(!hDict || !sKey)
		return dDefault;

	return [STSTypeConversion objectToDouble:[hDict objectForKey:sKey]
								withDefault:dDefault];
}

+ (int)dictionaryToInt:(NSDictionary *)hDict key:(NSString *)sKey defaultValue:(int)iDefault
{
	if(!hDict || !sKey)
		return iDefault;

	return [STSTypeConversion objectToInt:[hDict objectForKey:sKey]
							 withDefault:iDefault];
}


+ (NSString *)objectInDictionaryToString:(NSDictionary *)hDict key:(NSString *)sKey defaultValue:(NSString *)sDefault
{
	if(!hDict || !sKey)
		return sDefault;

	return [STSTypeConversion objectToString:[hDict objectForKey:sKey]
								withDefault:sDefault];
}

+ (double)objectInDictionaryToDouble:(NSDictionary *)hDict key:(NSString *)sKey defaultValue:(double)dDefault
{
	if(!hDict || !sKey)
		return dDefault;

	return [STSTypeConversion objectToDouble:[hDict objectForKey:sKey]
								withDefault:dDefault];
}

+ (float)objectInDictionaryToFloat:(NSDictionary *)hDict key:(NSString *)sKey defaultValue:(float)fDefault
{
	if(!hDict || !sKey)
		return fDefault;
	
	return [STSTypeConversion objectToFloat:[hDict objectForKey:sKey]
								withDefault:fDefault];
}

+ (int)objectInDictionaryToInt:(NSDictionary *)hDict key:(NSString *)sKey defaultValue:(int)iDefault
{
	if(!hDict || !sKey)
		return iDefault;

	return [STSTypeConversion objectToInt:[hDict objectForKey:sKey]
							 withDefault:iDefault];
}

+ (short)objectInDictionaryToShort:(NSDictionary *)hDict key:(NSString *)sKey defaultValue:(short)sDefault
{
	if(!hDict || !sKey)
		return sDefault;
	
	return [STSTypeConversion objectToShort:[hDict objectForKey:sKey]
							 withDefault:sDefault];
}

+ (char)objectInDictionaryToChar:(NSDictionary *)hDict key:(NSString *)sKey defaultValue:(char)cDefault
{
	if(!hDict || !sKey)
		return cDefault;
	
	return [STSTypeConversion objectToChar:[hDict objectForKey:sKey]
							 withDefault:cDefault];
}

+ (long)objectInDictionaryToLong:(NSDictionary *)hDict key:(NSString *)sKey defaultValue:(long)lDefault
{
	if(!hDict || !sKey)
		return lDefault;
	
	return [STSTypeConversion objectToLong:[hDict objectForKey:sKey]
							 withDefault:lDefault];
}

+ (bool)objectInDictionaryToBool:(NSDictionary *)hDict key:(NSString *)sKey defaultValue:(bool)bDefault
{
	if(!hDict || !sKey)
		return bDefault;
	
	return [STSTypeConversion objectToBool:[hDict objectForKey:sKey] withDefault:bDefault];
}

+ (NSDictionary *)objectInDictionaryToDictionary:(NSDictionary *)hDict key:(NSString *)sKey defaultValue:(NSDictionary *)pDefault
{
	if(!hDict || !sKey)
		return pDefault;
	
	return [STSTypeConversion objectToDictionary:[hDict objectForKey:sKey] withDefault:pDefault];
}

+ (NSArray *)objectInDictionaryToArray:(NSDictionary *)hDict key:(NSString *)sKey defaultValue:(NSArray *)pDefault
{
	if(!hDict || !sKey)
		return pDefault;
	
	return [STSTypeConversion objectToArray:[hDict objectForKey:sKey] withDefault:pDefault];
}

//
// Double
//

+ (NSString *)doubleToString:(double)dValue;
{
    return [self doubleToString:dValue withMaxDecimals:2];
}

+ (NSString *)doubleToString:(double)dValue withMaxDecimals:(int)iDecimals;
{
    NSNumberFormatter *pFormatter = [NSNumberFormatter new];
    [pFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [pFormatter setDecimalSeparator:@","];
    [pFormatter setGroupingSeparator:@"."];
    if(iDecimals > -1)
        [pFormatter setMaximumFractionDigits:iDecimals];

    return [pFormatter stringFromNumber:[NSNumber numberWithDouble:dValue]];
}

@end
