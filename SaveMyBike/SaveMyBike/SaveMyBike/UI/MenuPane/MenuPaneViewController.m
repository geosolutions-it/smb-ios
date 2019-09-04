//
//  Created by Szymon Tomasz Stefanek on 20/06/2019.
//  Copyright © 2019 GeoSolutions SaS. All rights reserved.
//

#import "MenuPaneViewController.h"
#import "STSSingleViewScroller.h"
#import "MenuView.h"

static MenuPaneViewController * g_pMenuPaneViewController = nil;

@interface MenuPaneViewController ()
{
}
@end

@implementation MenuPaneViewController

- (id)init
{
	self = [super init];
	if(!self)
		return nil;
	
	g_pMenuPaneViewController = self;
	
	return self;
}

- (void)loadView
{
	STSSingleViewScroller * scr = [STSSingleViewScroller new];
	MenuView * mv = [MenuView new];
	[scr setView:mv];
	[scr setFillViewport:true];
	self.view = scr;
}

+ (MenuPaneViewController *)instance
{
	return g_pMenuPaneViewController;
}

@end
