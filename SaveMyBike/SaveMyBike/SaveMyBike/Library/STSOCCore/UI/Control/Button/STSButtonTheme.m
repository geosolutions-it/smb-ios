//
//  STSButtonTheme.m
//
//  Created by Szymon Tomasz Stefanek on 1/6/18.
//  Copyright © 2018 Szymon Tomasz Stefanek. All rights reserved.
//

#import "STSButtonTheme.h"

@implementation STSButtonThemeInfo

+ (UIColor *)foregroundColorForTheme:(STSButtonTheme)eTheme andState:(STSButtonState)eState;
{
	switch(eTheme)
	{
		case STSButtonThemeWhiteBackgroundBlackForeground:
			switch(eState)
			{
				case STSButtonStateNormal:
					return [UIColor blackColor];
				break;
				case STSButtonStateActive:
					return [UIColor whiteColor];
				break;
				case STSButtonStatePressed:
					return [UIColor darkGrayColor];
				break;
				case STSButtonStateDisabled:
					return [UIColor lightGrayColor];
				break;
				case STSButtonStateActivePressed:
					return [UIColor darkGrayColor];
				break;
				default:
					// fall down
				break;
			}
		break;
		case STSButtonThemeWhiteBackgroundGrayForeground:
			switch(eState)
			{
				case STSButtonStateNormal:
					return [UIColor darkGrayColor];
				break;
				case STSButtonStateActive:
					return [UIColor whiteColor];
				break;
				case STSButtonStatePressed:
					return [UIColor lightGrayColor];
				break;
				case STSButtonStateDisabled:
					return [UIColor lightGrayColor];
				break;
				case STSButtonStateActivePressed:
					return [UIColor lightGrayColor];
				break;
				default:
					// fall down
				break;
			}
		break;
		case STSButtonThemeDarkGrayBackgroundWhiteForeground:
			switch(eState)
			{
				case STSButtonStateNormal:
					return [UIColor whiteColor];
				break;
				case STSButtonStateActive:
					return [UIColor blackColor];
				break;
				case STSButtonStatePressed:
					return [UIColor grayColor];
				break;
				case STSButtonStateDisabled:
					return [UIColor darkGrayColor];
				break;
				case STSButtonStateActivePressed:
					return [UIColor grayColor];
				break;
				default:
					// fall down
				break;
			}
		break;
		case STSButtonThemeBlackBackgroundWhiteForeground:
			switch(eState)
			{
				case STSButtonStateNormal:
					return [UIColor whiteColor];
				break;
				case STSButtonStateActive:
					return [UIColor blackColor];
				break;
				case STSButtonStatePressed:
					return [UIColor lightGrayColor];
				break;
				case STSButtonStateDisabled:
					return [UIColor lightGrayColor];
				break;
				case STSButtonStateActivePressed:
					return [UIColor darkGrayColor];
				break;
				default:
					// fall down
				break;
			}
		break;
		case STSButtonThemeNoBackgroundBlackForeground:
			switch(eState)
			{
				case STSButtonStateNormal:
					return [UIColor blackColor];
				break;
				case STSButtonStateActive:
					return [UIColor whiteColor];
				break;
				case STSButtonStatePressed:
					return [UIColor darkGrayColor];
				break;
				case STSButtonStateDisabled:
					return [UIColor lightGrayColor];
				break;
				case STSButtonStateActivePressed:
					return [UIColor darkGrayColor];
				break;
				default:
					// fall down
				break;
			}
		break;
		case STSButtonThemeNoBackgroundWhiteForeground:
			switch(eState)
			{
				case STSButtonStateNormal:
					return [UIColor whiteColor];
				break;
				case STSButtonStateActive:
					return [UIColor blackColor];
				break;
				case STSButtonStatePressed:
					return [UIColor lightGrayColor];
				break;
				case STSButtonStateDisabled:
					return [UIColor darkGrayColor];
				break;
				case STSButtonStateActivePressed:
					return [UIColor lightGrayColor];
				break;
				default:
					// fall down
				break;
			}
		break;
	}

	return [UIColor greenColor]; // BUG
}


+ (UIColor *)backgroundColorForTheme:(STSButtonTheme)eTheme andState:(STSButtonState)eState;
{
	switch(eTheme)
	{
		case STSButtonThemeWhiteBackgroundBlackForeground:
			switch(eState)
			{
				case STSButtonStateNormal:
					return [UIColor whiteColor];
				break;
				case STSButtonStateActive:
					return [UIColor blackColor];
				break;
				case STSButtonStatePressed:
					return [UIColor lightGrayColor];
				break;
				case STSButtonStateDisabled:
					return [UIColor whiteColor];
				break;
				case STSButtonStateActivePressed:
					return [UIColor lightGrayColor];
				break;
				default:
					// fall down
				break;
			}
		break;
		case STSButtonThemeWhiteBackgroundGrayForeground:
			switch(eState)
			{
				case STSButtonStateNormal:
					return [UIColor whiteColor];
				break;
				case STSButtonStateActive:
					return [UIColor blackColor];
				break;
				case STSButtonStatePressed:
					return [UIColor lightGrayColor];
				break;
				case STSButtonStateDisabled:
					return [UIColor whiteColor];
				break;
				case STSButtonStateActivePressed:
					return [UIColor lightGrayColor];
				break;
				default:
					// fall down
				break;
			}
		break;
		case STSButtonThemeDarkGrayBackgroundWhiteForeground:
			switch(eState)
			{
				case STSButtonStateNormal:
					return [UIColor darkGrayColor];
				break;
				case STSButtonStateActive:
					return [UIColor whiteColor];
				break;
				case STSButtonStatePressed:
					return [UIColor lightGrayColor];
				break;
				case STSButtonStateDisabled:
					return [UIColor lightGrayColor];
				break;
				case STSButtonStateActivePressed:
					return [UIColor lightGrayColor];
				break;
				default:
					// fall down
				break;
			}
		break;
		case STSButtonThemeBlackBackgroundWhiteForeground:
			switch(eState)
			{
				case STSButtonStateNormal:
					return [UIColor blackColor];
				break;
				case STSButtonStateActive:
					return [UIColor lightGrayColor];
				break;
				case STSButtonStatePressed:
					return [UIColor darkGrayColor];
				break;
				case STSButtonStateDisabled:
					return [UIColor darkGrayColor];
				break;
				case STSButtonStateActivePressed:
					return [UIColor darkGrayColor];
				break;
				default:
					// fall down
				break;
			}
		break;
		case STSButtonThemeNoBackgroundBlackForeground:
			switch(eState)
			{
				case STSButtonStateNormal:
					return [UIColor clearColor];
				break;
				case STSButtonStateActive:
					return [UIColor darkGrayColor];
				break;
				case STSButtonStatePressed:
					return [UIColor lightGrayColor];
				break;
				case STSButtonStateDisabled:
					return [UIColor clearColor];
				break;
				case STSButtonStateActivePressed:
					return [UIColor lightGrayColor];
				break;
				default:
					// fall down
				break;
			}
		break;
		case STSButtonThemeNoBackgroundWhiteForeground:
			switch(eState)
			{
				case STSButtonStateNormal:
					return [UIColor clearColor];
				break;
				case STSButtonStateActive:
					return [UIColor lightGrayColor];
				break;
				case STSButtonStatePressed:
					return [UIColor darkGrayColor];
				break;
				case STSButtonStateDisabled:
					return [UIColor clearColor];
				break;
				case STSButtonStateActivePressed:
					return [UIColor darkGrayColor];
				break;
				default:
					// fall down
				break;
			}
		break;
	}

	return [UIColor redColor]; // BUG
}


@end
