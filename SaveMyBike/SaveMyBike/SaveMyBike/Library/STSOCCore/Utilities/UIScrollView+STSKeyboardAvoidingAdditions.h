//
//  UIScrollView+STSKeyboardAvoidingAdditions.h
//  STSKeyboardAvoiding
//
//  Created by Michael Tyson on 30/09/2013.
//  Copyright 2015 A Tasty Pixel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (STSKeyboardAvoidingAdditions)
- (BOOL)STSKeyboardAvoiding_focusNextTextField;
- (void)STSKeyboardAvoiding_scrollToActiveTextField;

- (void)STSKeyboardAvoiding_keyboardWillShow:(NSNotification*)notification;
- (void)STSKeyboardAvoiding_keyboardWillHide:(NSNotification*)notification;
- (void)STSKeyboardAvoiding_updateContentInset;
- (void)STSKeyboardAvoiding_updateFromContentSizeChange;
- (void)STSKeyboardAvoiding_assignTextDelegateForViewsBeneathView:(UIView*)view;
- (UIView*)STSKeyboardAvoiding_findFirstResponderBeneathView:(UIView*)view;
-(CGSize)STSKeyboardAvoiding_calculatedContentSizeFromSubviewFrames;
@end
