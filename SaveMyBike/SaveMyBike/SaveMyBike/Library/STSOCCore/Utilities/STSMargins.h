//
//  STSMargins.h
//  
//  Created by Szymon Tomasz Stefanek on 2/25/17.
//  Copyright © 2017 Szymon Tomasz Stefanek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STSMargins : NSObject

@property(nonatomic) CGFloat left;
@property(nonatomic) CGFloat top;
@property(nonatomic) CGFloat right;
@property(nonatomic) CGFloat bottom;

+ (STSMargins *)marginsWithAllValues:(CGFloat)fVal;
+ (STSMargins *)marginsWithLeft:(CGFloat)l top:(CGFloat)t right:(CGFloat)r bottom:(CGFloat)b;

@end
