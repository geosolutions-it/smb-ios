//
//  NSString+Hashing.h
//
//  Copyright © 2012 Szymon Tomasz Stefanek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Hashing)

- (NSString *)hashMD5;
- (NSString *)hashSHA1;
- (NSString *)hashSHA256;
- (NSString *)hashSHA512;

@end
