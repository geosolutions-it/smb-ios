//
//  STSTextButtonDelegate.h
//  
//  Created by Szymon Tomasz Stefanek on 1/31/17.
//  Copyright © 2017 Szymon Tomasz Stefanek. All rights reserved.
//

#ifndef STSTextButtonDelegate_h
#define STSTextButtonDelegate_h

#import <UIKit/UIKit.h>

@class STSTextButton;

@protocol STSTextButtonDelegate

@optional

- (void)textButtonTapped:(STSTextButton *)pButton;

@end

#endif /* STSTextButtonDelegate_h */
