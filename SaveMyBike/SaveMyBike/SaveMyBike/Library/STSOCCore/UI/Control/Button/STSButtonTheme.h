//
//  STSButtonTheme.h
//
//  Created by Szymon Tomasz Stefanek on 1/6/18.
//  Copyright © 2018 Szymon Tomasz Stefanek. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "STSButtonState.h"

typedef enum _STSButtonTheme
{
	STSButtonThemeWhiteBackgroundBlackForeground = 0,
	STSButtonThemeWhiteBackgroundGrayForeground = 1,
	STSButtonThemeDarkGrayBackgroundWhiteForeground = 2,
	STSButtonThemeBlackBackgroundWhiteForeground = 3,
	STSButtonThemeNoBackgroundWhiteForeground = 4,
	STSButtonThemeNoBackgroundBlackForeground = 5,

	STSButtonThemeDefault = STSButtonThemeDarkGrayBackgroundWhiteForeground
} STSButtonTheme;

@interface STSButtonThemeInfo : NSObject

+ (UIColor *)foregroundColorForTheme:(STSButtonTheme)eTheme andState:(STSButtonState)eState;
+ (UIColor *)backgroundColorForTheme:(STSButtonTheme)eTheme andState:(STSButtonState)eState;

@end
