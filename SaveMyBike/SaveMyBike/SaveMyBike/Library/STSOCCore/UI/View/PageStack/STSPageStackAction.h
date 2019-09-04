//
//  STSPageStackAction.h
//  
//  Created by Szymon Tomasz Stefanek on 2/18/17.
//  Copyright © 2017 Szymon Tomasz Stefanek. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "STSPageStackActionDelegate.h"

@class STSPageStackViewActionButton;
@class STSPageStackView;

@interface STSPageStackAction : NSObject

@property (nonatomic) NSString * identifier;

// To change an icon after it has been displayed you must call [STSPageStackView updateActionBar] after setting this property
@property (nonatomic) NSString * icon;
// To change the enabled property after it has been displayed you must call [STSPageStackView updateActionBar] after setting this property
@property (nonatomic) BOOL enabled;
@property (nonatomic) __weak id<STSPageStackActionDelegate> delegate;

@property (nonatomic) CGFloat width; // 0.0 means default

// Internal, do not touch
@property (nonatomic) STSPageStackViewActionButton * button;
@property (nonatomic) BOOL changed;
@property (nonatomic) STSPageStackView * stackView; // only when attached!

@end
