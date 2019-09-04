//
//  STSViewController.h
//  
//  Created by Szymon Tomasz Stefanek on 1/22/17.
//  Copyright © 2017 Szymon Tomasz Stefanek. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "STSViewControllerDelegate.h"

@interface STSViewController : UIViewController

- (void)setDelegate:(__weak NSObject<STSViewControllerDelegate> *)pDelegate;

- (void)presentFromController:(UIViewController *)pParentController;
- (void)presentFromController:(UIViewController *)pParentController animated:(BOOL)bAnimated;
- (void)presentFromController:(UIViewController *)pParentController animated:(BOOL)bAnimated completion:(void (^)())fnCompletion;

@end
