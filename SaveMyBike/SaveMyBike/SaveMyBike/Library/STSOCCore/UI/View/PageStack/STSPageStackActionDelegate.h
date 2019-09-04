//
//  STSPageStackActionDelegate.h
//  
//  Created by Szymon Tomasz Stefanek on 2/18/17.
//  Copyright © 2017 Szymon Tomasz Stefanek. All rights reserved.
//

#ifndef STSPageStackActionDelegate_h
#define STSPageStackActionDelegate_h

@class STSPageStackAction;

@protocol STSPageStackActionDelegate<NSObject>

- (void)onPageStackActionActivated:(STSPageStackAction *)pAction;

@end

#endif /* STSPageStackActionDelegate_h */
