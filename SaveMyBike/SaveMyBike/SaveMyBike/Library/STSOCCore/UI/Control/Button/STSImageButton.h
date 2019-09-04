//
//  STSImageButton.h
//  
//  Created by Szymon Tomasz Stefanek on 1/28/17.
//  Copyright © 2017 Szymon Tomasz Stefanek. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "STSImageButtonDelegate.h"
#import "STSButtonState.h"
#import "STSButtonTheme.h"
#import "STSMargins.h"

@interface STSImageButton : UIView

@property(nonatomic) NSObject * payload;

- (id)init;
- (id)initWithFrame:(CGRect)frame;

- (void)setMargins:(STSMargins *)pMargins;
- (void)setDelegate:(__weak NSObject<STSImageButtonDelegate> *)pDelegate;
- (void)setImage:(UIImage *)pImage forState:(STSButtonState)eState;
- (void)setBackgroundColor:(UIColor *)pColor forState:(STSButtonState)eState;
- (void)setTintColor:(UIColor *)pColor forState:(STSButtonState)eState;
- (void)setAlpha:(CGFloat)a forState:(STSButtonState)eState;
// Call this BEFORE setting the images
- (void)setImageUsesTintColor:(BOOL)bUseIt;
- (void)setTheme:(STSButtonTheme)eTheme;
- (void)setEnabled:(BOOL)bEnabled;
- (void)setActive:(BOOL)bActive;
- (BOOL)active;
- (void)toggleActive;

- (void)onTapped;

@end
