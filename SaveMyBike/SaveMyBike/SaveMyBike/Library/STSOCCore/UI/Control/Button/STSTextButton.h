//
//  STSTextButton.h
//  
//  Created by Szymon Tomasz Stefanek on 1/31/17.
//  Copyright © 2017 Szymon Tomasz Stefanek. All rights reserved.
//

#import "STSLabel.h"

#import "STSTextButtonDelegate.h"
#import "STSButtonState.h"
#import "STSButtonTheme.h"

@interface STSTextButton : STSLabel

- (id)init;
- (id)initWithFrame:(CGRect)frame;

- (void)setTheme:(STSButtonTheme)eTheme;
- (void)setDelegate:(__weak NSObject<STSTextButtonDelegate> *)pDelegate;
- (void)setBackgroundColor:(UIColor *)pColor forState:(STSButtonState)eState;
- (void)setTextColor:(UIColor *)pColor forState:(STSButtonState)eState;
- (void)setEnabled:(BOOL)bEnabled;
- (void)setActive:(BOOL)bActive;
- (void)toggleActive;

@end
