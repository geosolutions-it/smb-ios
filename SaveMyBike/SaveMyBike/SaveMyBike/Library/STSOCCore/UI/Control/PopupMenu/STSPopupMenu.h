//
//  STSPopupMenu.h
//  
//  Created by Szymon Tomasz Stefanek on 3/4/17.
//  Copyright © 2017 Szymon Tomasz Stefanek. All rights reserved.
//

#import "STSGridLayoutView.h"

#import "STSPopupMenuDelegate.h"

@class STSImageAndTextButton;

@interface STSPopupMenu : STSGridLayoutView

- (id)initWithDelegate:(__weak id<STSPopupMenuDelegate>)del;

- (STSImageAndTextButton *)addItem:(NSString *)szText tag:(NSString *)szTag;
- (STSImageAndTextButton *)addItem:(NSString *)szText icon:(NSString *)szIcon tag:(NSString *)szTag;

- (void)close;

- (void)showAsDialogFromController:(UIViewController *)pController;

@end
