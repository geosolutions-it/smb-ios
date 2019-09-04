//
//  STSImageAndTextButton.h
//  
//  Created by Szymon Tomasz Stefanek on 2/8/17.
//  Copyright © 2017 Szymon Tomasz Stefanek. All rights reserved.
//

#import "STSGridLayoutView.h"

#import "STSImageAndTextButtonDelegate.h"
#import "STSButtonState.h"
#import "STSButtonTheme.h"

@class STSLabel;


@interface STSImageAndTextButton : STSGridLayoutView

- (id)init;
- (id)initWithTextBelowImage;
- (id)initWithFrame:(CGRect)frame;

@property(nonatomic,readonly) UIImageView * imageView;
@property(nonatomic,readonly) STSLabel * label;
@property(nonatomic) NSObject * payload;

- (void)setTheme:(STSButtonTheme)eTheme;
- (void)setDelegate:(__weak NSObject<STSImageAndTextButtonDelegate> *)pDelegate;
- (void)setBackgroundColor:(UIColor *)pColor forState:(STSButtonState)eState;
- (void)setTextColor:(UIColor *)pColor forState:(STSButtonState)eState;
- (void)setImage:(UIImage *)pImage forState:(STSButtonState)eState;
- (void)setImageVisible:(BOOL)bVisible;
- (void)setEnabled:(BOOL)bEnabled;
- (void)setActive:(BOOL)bActive;
- (void)setClickable:(BOOL)bClickable;
- (void)toggleActive;
- (NSString *)text;
- (void)setText:(NSString *)szText;
- (void)setSecondaryText:(NSString *)szSecondaryText;
// Call this BEFORE setting the images
- (void)setImageUsesTextColorAsTint:(BOOL)bUseIt;
- (void)setImageViewMargins:(STSMargins *)pMargins;
- (void)setLabelMargins:(STSMargins *)pMargins;

@end
