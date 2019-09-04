//
//  MainViewController.m
//  Szymon Tomasz Stefanek
//
//  Created by Szymon Tomasz Stefanek on 4/12/17.
//  Copyright © 2017 s.stefanek. All rights reserved.
//

#import "MainPaneViewController.h"

#import "MainView.h"

static MainPaneViewController * g_pMainPaneViewController = nil;

@interface MainPaneViewController ()
{
}
@end

@implementation MainPaneViewController

- (id)init
{
	self = [super init];
	if(!self)
		return nil;

	g_pMainPaneViewController = self;
	
	return self;
}

- (void)loadView
{
	self.view = [[MainView alloc] initWithFrame:[UIScreen mainScreen].bounds];
}

+ (MainPaneViewController *)instance
{
	return g_pMainPaneViewController;
}

@end
