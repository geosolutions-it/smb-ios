//
//  STSViewControllerDelegate.h
//  
//  Created by Szymon Tomasz Stefanek on 1/22/17.
//  Copyright © 2017 Szymon Tomasz Stefanek. All rights reserved.
//

#ifndef STSViewControllerDelegate_h
#define STSViewControllerDelegate_h

@protocol STSViewControllerDelegate

@optional

- (void)onViewLoaded;
- (void)onViewAboutToShow;
- (void)onViewShown;
- (void)onViewAboutToHide;
- (void)onViewHidden;
- (void)onMemoryWarning;

@end


#endif /* STSViewControllerDelegate_h */
