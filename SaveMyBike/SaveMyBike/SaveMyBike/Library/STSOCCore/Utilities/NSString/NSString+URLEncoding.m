//
//  NSString+URLEncoding.m
//
//  Created by Szymon Tomasz Stefanek on 25/11/12.
//  Copyright © 2012 Szymon Tomasz Stefanek. All rights reserved.
//

#import "NSString+URLEncoding.h"

@implementation NSString(URLEncoding)

- (NSString *)URLEncodedString
{
	return CFBridgingRelease(
		CFURLCreateStringByAddingPercentEscapes(
				NULL,
				(__bridge CFStringRef)self,
				NULL,
				(CFStringRef)@";/?:@&=$+{}<>,",
				CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)
			)
		);
}

- (NSString *)URLDecodedString
{
	return CFBridgingRelease(
		CFURLCreateStringByReplacingPercentEscapesUsingEncoding(
				NULL,
				(__bridge CFStringRef)self,
				NULL,
				//(CFStringRef)@";/?:@&=$+{}<>,",
				CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)
			)
		);
}

@end
