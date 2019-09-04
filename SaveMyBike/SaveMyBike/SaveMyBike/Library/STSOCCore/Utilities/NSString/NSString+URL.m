//
//  NSString+URL.m
//  
//  Created by Szymon Tomasz Stefanek on 2/24/17.
//  Copyright © 2017 Szymon Tomasz Stefanek. All rights reserved.
//

#import "NSString+URL.h"

@implementation NSString(URL)

- (NSURL *)toURL
{
	NSURL * u = [NSURL URLWithString:self];
	if(u)
		return u;
	NSString * tmp = [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
	u = [NSURL URLWithString:tmp];
	return u;
}

@end
