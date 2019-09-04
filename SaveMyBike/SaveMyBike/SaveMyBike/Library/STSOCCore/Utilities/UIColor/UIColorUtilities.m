//
//  UIColorUtilities.m
//
//  Created by Szymon Tomasz Stefanek on 20/06/2019.
//  Copyright © 2019 Szymon Tomasz Stefanek. All rights reserved.
//

#import "UIColorUtilities.h"

@implementation UIColor(STSUtilities)

+ (UIColor *)colorWithIntValue:(uint32_t)value
{
	uint8_t alpha = (value & 0xff000000) >> 24;
	uint8_t red = (value & 0x00ff0000) >> 16;
	uint8_t green = (value & 0x0000ff00) >> 8;
	uint8_t blue = (value & 0x000000ff);
	
	return [UIColor colorWithRed:((double)red / 255.0)
						   green:((double)green / 255.0)
							blue:((double)blue / 255.0)
						   alpha:((double)alpha / 255.0)];
}

- (uint32_t)getIntValue
{
	CGFloat fAlpha, fRed, fGreen, fBlue;
	[self getRed:&fRed green:&fGreen blue:&fBlue alpha:&fAlpha];
	
	uint32_t value = (((uint8_t)(fAlpha * 255)) << 24) |
	(((uint8_t)(fRed * 255)) << 16) |
	(((uint8_t)(fGreen * 255)) << 8) |
	(((uint8_t)(fBlue * 255)));
	return value;
}

- (UIColor *)withAlpha:(uint8_t)uAlpha
{
	CGFloat fAlpha, fRed, fGreen, fBlue;
	[self getRed:&fRed green:&fGreen blue:&fBlue alpha:&fAlpha];
	return [UIColor colorWithRed:fRed green:fGreen blue:fBlue alpha:((double)(uAlpha) / 255.0)];
}

@end
