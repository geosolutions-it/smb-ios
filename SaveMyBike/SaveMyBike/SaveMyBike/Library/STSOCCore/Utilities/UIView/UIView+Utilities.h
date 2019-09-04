//
//  UIView+Utilities.h
//  
//  Created by Szymon Tomasz Stefanek on 2/8/17.
//  Copyright © 2017 Szymon Tomasz Stefanek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView(Utilities)

- (UIView *)topmostAncestorView;

// A method that *SHOULD* be present in the Cocoa API from the begining.
// Find out the damn current view controller.
+ (UIViewController *)currentViewController;

// Present THIS view as a popup attached to the specified source view.
// THIS view must not be attached to a superview.
// WARNING: These work ONLY ON iPad. On iPhone you must use something different as Apple said that popup menus are no good.
- (UIViewController *)presentAsPopupFromView:(UIView *)pSourceView;
- (UIViewController *)presentAsPopupFromView:(UIView *)pSourceView allowedArrowDirections:(UIPopoverArrowDirection)eDirection;

@end
