//
//  NSAttributedString(Utilities).m
//  
//  Created by Szymon Tomasz Stefanek on 2/26/17.
//  Copyright © 2017 Szymon Tomasz Stefanek. All rights reserved.
//

#import "NSAttributedString+Utilities.h"

@implementation NSAttributedString(Utilities)

- (NSAttributedString *)attributedStringByTrimmingCharactersInSet:(NSCharacterSet *)set
{
	NSMutableAttributedString *newStr = [self mutableCopy];
	NSRange range;
	
	range = [[newStr string] rangeOfCharacterFromSet:set];
	while(range.length != 0 && range.location == 0)
	{
		[newStr replaceCharactersInRange:range withString:@""];
		range = [[newStr string] rangeOfCharacterFromSet:set];
	}
	
	range = [[newStr string] rangeOfCharacterFromSet:set options:NSBackwardsSearch];
	while (range.length != 0 && NSMaxRange(range) == [newStr length])
	{
		[newStr replaceCharactersInRange:range withString:@""];
		range = [[newStr string] rangeOfCharacterFromSet:set options:NSBackwardsSearch];
	}
	
	return [[NSAttributedString alloc] initWithAttributedString:newStr];
}

- (NSAttributedString *)attributedStringByTrimmingWhitespace
{
	return [self attributedStringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

@end


@implementation NSMutableAttributedString(Utilities)

- (NSMutableAttributedString *)attributedStringByTrimmingCharactersInSet:(NSCharacterSet *)set
{
	NSMutableAttributedString *newStr = [self mutableCopy];
	NSRange range;
	
	range = [[newStr string] rangeOfCharacterFromSet:set];
	while(range.length != 0 && range.location == 0)
	{
		[newStr replaceCharactersInRange:range withString:@""];
		range = [[newStr string] rangeOfCharacterFromSet:set];
	}
	
	range = [[newStr string] rangeOfCharacterFromSet:set options:NSBackwardsSearch];
	while (range.length != 0 && NSMaxRange(range) == [newStr length])
	{
		[newStr replaceCharactersInRange:range withString:@""];
		range = [[newStr string] rangeOfCharacterFromSet:set options:NSBackwardsSearch];
	}
	
	return [[NSMutableAttributedString alloc] initWithAttributedString:newStr];
}

- (NSMutableAttributedString *)attributedStringByTrimmingWhitespace
{
	return [self attributedStringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

@end

