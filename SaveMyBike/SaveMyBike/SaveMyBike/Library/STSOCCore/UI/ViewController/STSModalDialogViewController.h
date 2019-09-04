//
//  STSModalDialogViewController.h
//  
//  Created by Szymon Tomasz Stefanek on 1/21/17.
//  Copyright © 2017 Szymon Tomasz Stefanek. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "STSViewController.h"

@class STSModalDialogViewController;

@protocol STSModalDialogViewControllerDismissDelegate<NSObject>

@optional
- (BOOL)modalDialogViewControllerWillDismissOnBackdropTouch:(STSModalDialogViewController *)pController;


@required
- (void)modalDialogViewControllerDismissed:(STSModalDialogViewController *)pControler;

@end

@interface STSModalDialogViewController : STSViewController

- (id)init;
- (id)initWithExistingDialog:(UIView *)pDialog;

- (UIView *)loadDialog;

- (void)presentFromController:(UIViewController *)pParentController;
- (void)presentFromController:(UIViewController *)pParentController animated:(BOOL)bAnimated;
- (void)presentFromController:(UIViewController *)pParentController animated:(BOOL)bAnimated completion:(void (^)())fnCompletion;

- (CGSize)sizeForDialog:(UIView *)pDialog inParentSize:(CGSize)sSize;

- (void)setBackdropColor:(UIColor *)pColor;
- (void)setAutoDismissOnBackdropTouch:(BOOL)bDismiss;

- (void)setDismissDelegate:(__weak id<STSModalDialogViewControllerDismissDelegate>)pDelegate;

@property(nonatomic) NSObject * payload;

// internal
- (void)_backdropTouched;

@end
