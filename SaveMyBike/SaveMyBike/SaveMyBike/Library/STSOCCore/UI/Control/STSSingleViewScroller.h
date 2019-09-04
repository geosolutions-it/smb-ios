//
//  STSSingleViewScroller.h
//  
//  Created by Szymon Tomasz Stefanek on 2/26/17.
//  Copyright © 2017 Szymon Tomasz Stefanek. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "STSKeyboardAvoidingScrollView.h"

@interface STSSingleViewScroller : STSKeyboardAvoidingScrollView

- (id)init;
- (id)initWithFrame:(CGRect)frame;

- (void)setView:(UIView *)pView;

- (void)setFillViewport:(BOOL)bFillViewport;

@end
