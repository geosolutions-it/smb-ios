//
//  NSData+Hashing.h
//
//  Copyright © 2016 Szymon Tomasz Stefanek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Hashing)

- (NSData *)hashMD5;
- (NSData *)hashSHA1;
- (NSData *)hashSHA256;
- (NSData *)hashSHA512;

@end
