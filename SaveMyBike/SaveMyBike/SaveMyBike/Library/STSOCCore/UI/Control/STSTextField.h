//
//  STSTextField.h
//  
//  Created by Szymon Tomasz Stefanek on 1/28/17.
//  Copyright © 2017 Szymon Tomasz Stefanek. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "STSTextFieldDelegate.h"

@interface STSTextField : UITextField

- (void)setMargins:(CGFloat)fAllMargins;
- (void)setMarginLeft:(CGFloat)l top:(CGFloat)t right:(CGFloat)r bottom:(CGFloat)b;


@end
