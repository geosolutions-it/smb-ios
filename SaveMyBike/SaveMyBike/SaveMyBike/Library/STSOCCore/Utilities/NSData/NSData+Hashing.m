//
//  NSData+Hashing.m
//
//  Copyright © 2016 Szymon Tomasz Stefanek. All rights reserved.
//

#import "NSData+Hashing.h"

#import <CommonCrypto/CommonDigest.h>

@implementation NSData (Hashing)

- (NSData *)hashMD5
{
	unsigned char hash[CC_MD5_DIGEST_LENGTH];
    if(CC_MD5([self bytes], [self length], hash))
	{
        NSData *md5 = [NSData dataWithBytes:hash length:CC_MD5_DIGEST_LENGTH];
        return md5;
    }
	return nil;
}

- (NSData *)hashSHA1
{
	unsigned char hash[CC_SHA1_DIGEST_LENGTH];
    if(CC_SHA1([self bytes], [self length], hash))
	{
        NSData *sha1 = [NSData dataWithBytes:hash length:CC_SHA1_DIGEST_LENGTH];
        return sha1;
    }
	return nil;
}

- (NSData *)hashSHA256
{
	unsigned char hash[CC_SHA256_DIGEST_LENGTH];
    if(CC_SHA256([self bytes], [self length], hash))
	{
        NSData *sha256 = [NSData dataWithBytes:hash length:CC_SHA256_DIGEST_LENGTH];
        return sha256;
    }
	return nil;
}

- (NSData *)hashSHA512
{
	unsigned char hash[CC_SHA512_DIGEST_LENGTH];
    if(CC_SHA512([self bytes], [self length], hash))
	{
        NSData *sha512 = [NSData dataWithBytes:hash length:CC_SHA512_DIGEST_LENGTH];
        return sha512;
    }
	return nil;
}

@end
