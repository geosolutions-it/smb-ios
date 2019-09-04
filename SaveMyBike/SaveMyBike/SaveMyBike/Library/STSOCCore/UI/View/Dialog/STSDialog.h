//
//  STSDialog.h
//
//  Created by Szymon Tomasz Stefanek on 3/4/17.
//  Copyright © 2017 Szymon Tomasz Stefanek. All rights reserved.
//

#import "STSGridLayoutView.h"

#import "STSDialogDelegate.h"

@class STSImageAndTextButton;


@interface STSDialog : STSGridLayoutView

- (id)init;

- (void)setTitle:(NSString *)szTitle;
- (void)setShowsTitle:(BOOL)bShowsTitle;
- (STSImageAndTextButton *)addButton:(NSString *)szText tag:(NSString *)szTag;
- (STSImageAndTextButton *)addButton:(NSString *)szText icon:(NSString *)szIcon tag:(NSString *)szTag;
- (void)setCentralView:(UIView *)pView verticalSizePolicy:(STSSizePolicy)eVerticalSizePolicy horizontalSizePolicy:(STSSizePolicy)eHorizontalSizePolicy;
- (void)setCentralViewMinimumWidth:(CGFloat)fWidth;
- (void)setCentralViewMaximumWidth:(CGFloat)fWidth;
- (void)setCentralViewMinimumHeight:(CGFloat)fHeight;
- (void)setCentralViewFixedHeight:(CGFloat)fHeight;
- (void)setBackgroundTouchDismissTag:(NSString *)szTag;
- (void)setDelegate:(__weak id<STSDialogDelegate>)pDelegate;

- (void)showFromController:(UIViewController *)pController;

// internal
- (void)_buttonBarButtonTapped:(STSImageAndTextButton *)pButton;

@end
