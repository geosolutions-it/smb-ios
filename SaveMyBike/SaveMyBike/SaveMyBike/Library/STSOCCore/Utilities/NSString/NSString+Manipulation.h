//
//  NSString+Manipulation.h
//
//  Copyright © 2012 Szymon Tomasz Stefanek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Manipulation)

- (bool)startsWithString:(NSString *)sPattern;
- (bool)containsString:(NSString *)sString;
- (bool)containsString:(NSString *)sString options:(NSStringCompareOptions)eOptions;
+ (BOOL)isNullOrEmpty:(NSString *)s;
- (bool)containsOnlyDigits;

@end
