//
//  NSString+URL.h
//  
//  Created by Szymon Tomasz Stefanek on 2/24/17.
//  Copyright © 2017 Szymon Tomasz Stefanek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString(URL)

// Will encode spaces and stuff, if needed
- (NSURL *)toURL;

@end
