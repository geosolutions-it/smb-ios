//
//  Created by Szymon Tomasz Stefanek on 2/8/17.
//  Copyright © 2017 Szymon Tomasz Stefanek. All rights reserved.
//

#import "UIView+Utilities.h"

@implementation UIView(Utilities)

- (UIView *)topmostAncestorView
{
	UIView * v = self;
	while(v.superview)
		v = v.superview;
	return v;
}

+ (UIViewController *)currentViewController
{
	UIApplication * app = [UIApplication sharedApplication];
	if(!app)
		return nil;
	UIWindow * win = app.keyWindow;
	if(!win)
		return nil;
	UIViewController * ctrl = win.rootViewController;
	if(!ctrl)
		return nil;
	while(ctrl.presentedViewController)
	{
		if(!ctrl.presentedViewController.isBeingPresented)
			break;
		ctrl = ctrl.presentedViewController;
	}
	return ctrl;
}

- (UIViewController *)presentAsPopupFromView:(UIView *)pSourceView
{
	return [self presentAsPopupFromView:pSourceView allowedArrowDirections:UIPopoverArrowDirectionAny];
}

- (UIViewController *)presentAsPopupFromView:(UIView *)pSourceView allowedArrowDirections:(UIPopoverArrowDirection)eDirection;
{
	[self sizeToFit];

	UIViewController * pPopoverController = [UIViewController new];
	
	pPopoverController.view.frame = self.bounds;
	[pPopoverController.view addSubview:self];
	
	[pPopoverController setModalPresentationStyle:UIModalPresentationPopover];
	
	UIPopoverPresentationController * pc = pPopoverController.popoverPresentationController;
	
	pc.sourceView = pSourceView;
	pc.sourceRect = pSourceView.bounds;
	pc.permittedArrowDirections = eDirection;

	pPopoverController.preferredContentSize = self.bounds.size;

	UIViewController * pCurrentController = [UIView currentViewController];

	if([UIDevice currentDevice].systemVersion.integerValue >= 8)
	{
		pCurrentController.providesPresentationContextTransitionStyle = true;
		pCurrentController.definesPresentationContext = true;
	}
	
	[pCurrentController presentViewController:pPopoverController animated:YES completion:nil];
	
	return pPopoverController;
}

@end
