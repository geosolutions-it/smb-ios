//
//  Created by Szymon Tomasz Stefanek on 20/06/2019.
//  Copyright © 2019 GeoSolutions SaS. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "STSGridLayoutView.h"

@interface MenuView : STSGridLayoutView

+ (MenuView *)instance;

- (void)userInfoUpdated;

@end
