//
//  Created by Szymon Tomasz Stefanek on 02/06/19.
//  Copyright © 2019 GeoSolutions SaS. All rights reserved.
//

#import "SettingsBase.h"

@interface Settings : SettingsBase


+ (Settings *)instance;

+ (void)create:(NSString *)szPath;
+ (void)destroy;

- (bool)load;
- (bool)save;



@end
