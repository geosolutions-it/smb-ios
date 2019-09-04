//
//  STSDialogDelegate.h
//
//  Created by Szymon Tomasz Stefanek on 3/4/17.
//  Copyright © 2017 Szymon Tomasz Stefanek. All rights reserved.
//

#ifndef STSDialogDelegate_h
#define STSDialogDelegate_h

@class STSDialog;

@protocol STSDialogDelegate<NSObject>

@optional

- (BOOL)dialog:(STSDialog *)pDialog willDismissWithTag:(NSString *)szTag;
- (void)dialog:(STSDialog *)pDialog didDismissWithTag:(NSString *)szTag;

@end

#endif /* STSDialogDelegate_h */
