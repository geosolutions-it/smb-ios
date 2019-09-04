//
//  NSString+Hashing.m
//
//  Copyright © 2012 Szymon Tomasz Stefanek. All rights reserved.
//

#import "NSString+Hashing.h"
#import "NSData+Hashing.h"

@interface NSString (Hashing_Private)
- (NSString *)_convertToStringHashFromDataHash:(NSData *)pHash;
@end

@implementation NSString (Hashing)

- (NSString *)_convertToStringHashFromDataHash:(NSData *)pHash
{
	if(!pHash)
		return nil;

	NSUInteger uHashLength = pHash.length;
	const uint8_t *pDigest = [pHash bytes];

	NSMutableString *sHash = [NSMutableString stringWithCapacity:uHashLength * 2];

    for(int i = 0; i < uHashLength; i++)
        [sHash appendFormat:@"%02x", pDigest[i]];

    return sHash;
}

- (NSString *)hashMD5
{
	NSData *pData = [NSData dataWithBytes:[self cStringUsingEncoding:NSUTF8StringEncoding] length:self.length];
	return [self _convertToStringHashFromDataHash:[pData hashMD5]];
}

- (NSString *)hashSHA1
{
	NSData *pData = [NSData dataWithBytes:[self cStringUsingEncoding:NSUTF8StringEncoding] length:self.length];
	return [self _convertToStringHashFromDataHash:[pData hashSHA1]];
}

- (NSString *)hashSHA256
{
	NSData *pData = [NSData dataWithBytes:[self cStringUsingEncoding:NSUTF8StringEncoding] length:self.length];
	return [self _convertToStringHashFromDataHash:[pData hashSHA256]];
}

- (NSString *)hashSHA512
{
	NSData *pData = [NSData dataWithBytes:[self cStringUsingEncoding:NSUTF8StringEncoding] length:self.length];
	return [self _convertToStringHashFromDataHash:[pData hashSHA512]];
}

@end
