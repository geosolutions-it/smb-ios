//
//  STSPageStackViewActionButton.h
//  
//  Created by Szymon Tomasz Stefanek on 2/27/17.
//  Copyright © 2017 Szymon Tomasz Stefanek. All rights reserved.
//

#import "STSImageButton.h"

@class STSPageStackAction;

@interface STSPageStackViewActionButton : STSImageButton
	@property (nonatomic) __weak STSPageStackAction * action;
@end
