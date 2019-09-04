//
//  STSImageAndTextButtonDelegate.h
//  
//  Created by Szymon Tomasz Stefanek on 2/8/17.
//  Copyright © 2017 Szymon Tomasz Stefanek. All rights reserved.
//

#import "STSGridLayoutView.h"

@class STSImageAndTextButton;

@protocol STSImageAndTextButtonDelegate

- (void)imageAndTextButtonTapped:(STSImageAndTextButton *)pButton;

@end
