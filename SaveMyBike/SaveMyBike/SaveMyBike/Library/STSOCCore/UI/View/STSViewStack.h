//
//  STSViewStack.h
//
//  Created by Szymon Tomasz Stefanek on 12/27/17.
//  Copyright © 2017 Szymon Tomasz Stefanek. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol STSViewStackView<NSObject>

@optional

- (void)onActivate;
- (void)onDeactivate;

@end

@interface STSViewStack : UIView

- (id)init;
- (id)initWithFrame:(CGRect)frame;

- (NSMutableArray<UIView *> *)views;
- (void)addView:(UIView *)pView;
- (void)removeView:(UIView *)pView;
- (int)viewCount;
- (UIView *)viewAtIndex:(int)iIdx;
- (UIView *)currentView;
- (int)currentIndex;
- (void)setCurrentView:(UIView *)pView;
- (void)setCurrentIndex:(int)iIdx;

- (CGSize)intrinsicContentSize;
- (CGSize)sizeThatFits:(CGSize)size;

@end
