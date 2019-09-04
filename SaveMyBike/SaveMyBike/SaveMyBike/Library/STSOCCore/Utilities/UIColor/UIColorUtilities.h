//
//  Created by Szymon Tomasz Stefanek on 20/06/2019.
//  Copyright © 2019 Szymon Tomasz Stefanek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor(STSUtilities)

// this is 0xAARRGGBB
+ (UIColor *)colorWithIntValue:(uint32_t)value;

- (uint32_t)getIntValue;

- (UIColor *)withAlpha:(uint8_t)uAlpha;


@end

