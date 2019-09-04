//
//  Created by Szymon Tomasz Stefanek on 20/06/2019.
//  Copyright © 2019 GeoSolutions SaS. All rights reserved.
//

#import "MMDrawerController.h"

@interface TopLevelViewController : MMDrawerController

+ (TopLevelViewController *)instance;

- (void)setCanOpenDrawer:(bool)b;

@end
