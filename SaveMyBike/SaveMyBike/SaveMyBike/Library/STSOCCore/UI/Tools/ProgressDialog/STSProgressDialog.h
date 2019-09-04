//
//  STSProgressDialog.h
//
//  Created by Szymon Tomasz Stefanek on 9/1/18.
//  Copyright © 2018 Szymon Tomasz Stefanek. All rights reserved.
//

#import "M13ProgressHUD.h"

@interface STSProgressDialog : M13ProgressHUD

// DEPRECATED: use setIndeterminate
- (void)showAsIndeterminate:(bool)bAnimated;


- (void)close:(bool)bAnimated;

@end
