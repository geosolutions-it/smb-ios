//
//  STSImageButtonDelegate.h
//  
//  Created by Szymon Tomasz Stefanek on 1/28/17.
//  Copyright © 2017 Szymon Tomasz Stefanek. All rights reserved.
//

#ifndef STSImageButtonDelegate_h
#define STSImageButtonDelegate_h

#import <UIKit/UIKit.h>

@class STSImageButton;

@protocol STSImageButtonDelegate

@optional

- (void)imageButtonTapped:(STSImageButton *)pButton;

@end

#endif /* STSImageButtonDelegate_h */
