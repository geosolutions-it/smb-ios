//
//  STSMargins.m
//  
//  Created by Szymon Tomasz Stefanek on 2/25/17.
//  Copyright © 2017 Szymon Tomasz Stefanek. All rights reserved.
//

#import "STSMargins.h"

@implementation STSMargins

+ (STSMargins *)marginsWithAllValues:(CGFloat)fVal
{
	STSMargins * m = [STSMargins new];
	m.left = fVal;
	m.top = fVal;
	m.right = fVal;
	m.bottom = fVal;
	return m;
}

+ (STSMargins *)marginsWithLeft:(CGFloat)l top:(CGFloat)t right:(CGFloat)r bottom:(CGFloat)b
{
	STSMargins * m = [STSMargins new];
	m.left = l;
	m.top = t;
	m.right = r;
	m.bottom = b;
	return m;
}

@end
