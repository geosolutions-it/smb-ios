//
//  STSPageStackPage.h
//  
//  Created by Szymon Tomasz Stefanek on 2/18/17.
//  Copyright © 2017 Szymon Tomasz Stefanek. All rights reserved.
//

#import "STSGridLayoutView.h"
#import "STSPageStackAction.h"

@class STSPageStackView;

typedef enum _STSPageStackActionBarMode
{
	STSPageStackActionBarModeHidden,
	STSPageStackActionBarModeOverlappingView,
	STSPageStackActionBarModeVisible
} STSPageStackActionBarMode;

@interface STSPageStackPage : STSGridLayoutView

@property(nonatomic) STSPageStackActionBarMode actionBarMode;

- (id)init;
- (id)initWithFrame:(CGRect)rFrame;

- (void)addLeftAction:(STSPageStackAction *)pAction;
- (void)addRightAction:(STSPageStackAction *)pAction;

@property (nonatomic,readonly) NSArray<STSPageStackAction *> * leftActions;
@property (nonatomic,readonly) NSArray<STSPageStackAction *> * rightActions;
// if you're setting this after you might want to call [pageStackView updateActionBarTitle] or [pageStackView updateActionBar]
@property (nonatomic) UIColor * actionBarBackgroundColor;
@property (nonatomic) UIColor * actionBarForegroundColor;
@property (nonatomic) UIView * actionBarCenterView;
@property (nonatomic) NSString * actionBarTitle;
@property (nonatomic) UIColor * statusBarBackgroundColor;
@property (nonatomic) CGFloat inOutAnimationSideX; // 1 for right, 0 for no side, -1 for left side
@property (nonatomic) CGFloat inOutAnimationSideY; // 1 for bottom, 0 for no side, -1 for top

@property (nonatomic,readonly) STSPageStackView * pageStackView;

- (void)onPageAttach;
- (void)onPageActivate;
// Return false if you don't want to be popped
- (bool)onPageBackButtonPressed;
- (void)onPageDeactivate;
- (void)onPageDetach;

- (void)_internalSetPageStackView:(STSPageStackView *)pPageStackView;

@end
