//
//  STSLabel.h
//
//  Created by Szymon Tomasz Stefanek on 1/21/17.
//  Copyright © 2017 Szymon Tomasz Stefanek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STSLabel : UILabel

@property(nonatomic) NSObject * payload;

- (void)setMargins:(CGFloat)fAllMargins;
- (void)setMarginLeft:(CGFloat)fLeft top:(CGFloat)fTop right:(CGFloat)fRight bottom:(CGFloat)fBottom;

- (void)setLineBreakMode:(NSLineBreakMode)lineBreakMode;

- (CGSize)intrinsicContentSize;

@end
