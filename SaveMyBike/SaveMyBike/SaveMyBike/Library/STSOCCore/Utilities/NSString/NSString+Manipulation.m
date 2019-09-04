//
//  NSString+Manipulation.m
//
//  Copyright © 2012 Szymon Tomasz Stefanek. All rights reserved.
//

#import "NSString+Manipulation.h"

@implementation NSString (Manipulation)

+ (BOOL)isNullOrEmpty:(NSString *)s
{
	if(!s)
		return true;
	if(s.length < 1)
		return true;
	return false;
}

- (bool)startsWithString:(NSString*)sPattern
{
    if(!sPattern)
        return false;

    if([sPattern length] > [self length])
        return false;

    NSRange rRange;
    rRange.location = 0;
    rRange.length = [sPattern length];

    return [[self substringWithRange:rRange] isEqualToString:sPattern];
}

- (bool)containsString:(NSString *)sString
{
	return ([self rangeOfString:sString].location != NSNotFound);
}

- (bool)containsString:(NSString *)sString options:(NSStringCompareOptions)eOptions
{
	return ([self rangeOfString:sString options:eOptions].location != NSNotFound);
}

- (bool)containsOnlyDigits
{
    NSCharacterSet * nonNumbers = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    NSRange r = [self rangeOfCharacterFromSet:nonNumbers];
    return r.location == NSNotFound;
}

@end
