//
//  Created by Szymon Tomasz Stefanek on 20/06/2019.
//  Copyright © 2019 GeoSolutions SaS. All rights reserved.
//

#import "TopLevelViewController.h"
#import "MainPaneViewController.h"
#import "MenuPaneViewController.h"

#import "Config.h"

static TopLevelViewController * g_pTopLevelViewController = nil;

@interface TopLevelViewController()
{
	MainPaneViewController * m_pMainPaneViewController;
	MenuPaneViewController * m_pMenuPaneViewController;
}
@end

@implementation TopLevelViewController

- (id)init
{
	m_pMainPaneViewController = [MainPaneViewController new];
	m_pMenuPaneViewController = [MenuPaneViewController new];
	
	self = [super initWithCenterViewController:m_pMainPaneViewController leftDrawerViewController:m_pMenuPaneViewController];
	if(!self)
		return nil;
	
	self.openDrawerGestureModeMask = MMOpenDrawerGestureModeBezelPanningCenterView | MMOpenDrawerGestureModePanningCenterView;
	self.closeDrawerGestureModeMask = MMCloseDrawerGestureModePanningCenterView | MMCloseDrawerGestureModePanningDrawerView | MMCloseDrawerGestureModePanningNavigationBar;
	
	self.showsStatusBarBackgroundView = true;
	self.statusBarViewBackgroundColor = [Config instance].highlight1Color;
	
	g_pTopLevelViewController = self;
	
	return self;
}

+ (TopLevelViewController *)instance
{
	return g_pTopLevelViewController;
}

- (void)setCanOpenDrawer:(bool)b
{
	if(b)
	{
		self.openDrawerGestureModeMask = MMOpenDrawerGestureModeBezelPanningCenterView | MMOpenDrawerGestureModePanningCenterView;
	} else {
		self.openDrawerGestureModeMask = MMOpenDrawerGestureModeNone;
		[self closeDrawerAnimated:false completion:nil];
	}
}


@end
