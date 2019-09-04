//
//  STSPageStackView.h
//  
//  Created by Szymon Tomasz Stefanek on 2/18/17.
//  Copyright © 2017 Szymon Tomasz Stefanek. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "STSPageStackPage.h"
#import "STSPageStackAction.h"
#import "STSImageButtonDelegate.h"

@class STSPageStackView;

@protocol STSPageStackViewDelegate<NSObject>

@optional

- (void)pageStackView:(STSPageStackView *)pStackView pageDeactivated:(STSPageStackPage *)pPage;
- (void)pageStackView:(STSPageStackView *)pStackView pageActivated:(STSPageStackPage *)pPage;

@end

@interface STSPageStackView : UIView<STSImageButtonDelegate>

// The page stack. Topmost page at end.
@property (nonatomic, readonly) NSArray<STSPageStackPage *> * pageStack;
@property (nonatomic, readonly) STSPageStackPage * currentPage;

// After setting these at late time you might want to call updateActionBar or updateActionBarTitle (if title only)
@property (nonatomic) UIColor * defaultActionBarBackgroundColor;
@property (nonatomic) UIColor * defaultActionBarForegroundColor;
@property (nonatomic) UIView * defaultActionBarCenterView;
@property (nonatomic) NSString * defaultActionBarTitle;
@property (nonatomic) UIColor * defaultStatusBarBackgroundColor;

@property (nonatomic) BOOL showStatusBarBackground;

@property (nonatomic,weak) id<STSPageStackViewDelegate> delegate;

- (id)initWithFrame:(CGRect)rFrame;

- (void)addPersistentLeftAction:(STSPageStackAction *)pAction;
- (void)addPersistentRightAction:(STSPageStackAction *)pAction;

- (void)setBackButtonImageName:(NSString *)szImageName;

- (int)indexOfPage:(STSPageStackPage *)pPage;

- (void)switchToPage:(STSPageStackPage * )pPage;

- (void)pushPage:(STSPageStackPage *)pPage;
- (void)pushPage:(STSPageStackPage *)pPage numberOfUnderlyingViewsToRemove:(int)iNumberOfUnderlyingViewsToRemove;
- (void)pushPage:(STSPageStackPage *)pPage numberOfUnderlyingViewsToRemove:(int)iNumberOfUnderlyingViewsToRemove withAnimation:(bool)bAnimation;
- (void)popCurrentPage;

- (void)onBackButtonPressed;

- (void)updateActionBarTitle;
- (void)updateActionBar;

- (void)triggerUpdateActionBar;

- (void)setStatusBarBackgroundColor:(UIColor *)clr;

@end
