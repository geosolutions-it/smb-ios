//
//  STSMessageBox.m
//  
//  Created by Szymon Tomasz Stefanek on 1/24/17.
//  Copyright © 2017 Szymon Tomasz Stefanek. All rights reserved.
//

#import "STSMessageBox.h"

#import "UIView+Utilities.h"
#import "STSGridLayoutView.h"
#import "STSDisplay.h"

#import "STSCore.h"

@implementation STSMessageBoxParams


@end

@implementation STSMessageBox

+ (void)showWithMessage:(NSString *)szMessage
{
	[STSMessageBox showFromController:[UIView currentViewController] message:szMessage];
}

+ (void)showWithMessage:(NSString *)szMessage title:(NSString *)szTitle
{
	[STSMessageBox showFromController:[UIView currentViewController] message:szMessage title:szTitle];
}

+ (void)showWithMessage:(NSString *)szMessage title:(NSString *)szTitle buttonText:(NSString *)szButtonText
{
	[STSMessageBox showFromController:[UIView currentViewController] message:szMessage title:szTitle buttonText:szButtonText];
}



+ (void)showFromController:(UIViewController *)pController message:(NSString *)szMessage
{
	STSMessageBoxParams * pParams = [STSMessageBoxParams new];
	pParams.message = szMessage;
	pParams.controller = pController;
	
	[STSMessageBox show:pParams];
}

+ (void)showFromController:(UIViewController *)pController message:(NSString *)szMessage title:(NSString *)szTitle
{
	STSMessageBoxParams * pParams = [STSMessageBoxParams new];

	pParams.message = szMessage;
	pParams.title = szTitle;
	pParams.controller = pController;
	
	[STSMessageBox show:pParams];
}


+ (void)showFromController:(UIViewController *)pController message:(NSString *)szMessage title:(NSString *)szTitle buttonText:(NSString *)szButtonText
{
	STSMessageBoxParams * pParams = [STSMessageBoxParams new];
	pParams.message = szMessage;
	pParams.title = szTitle;
	pParams.button0Text = szButtonText;
	pParams.controller = pController;
	
	[STSMessageBox show:pParams];
}


+ (void)show:(STSMessageBoxParams *)pParams
{
	UIAlertController * alert = [
			UIAlertController
			alertControllerWithTitle:(pParams.title ? pParams.title : @"")
			message:(pParams.message ? pParams.message : @"")
			preferredStyle:UIAlertControllerStyleAlert
		];
 
 
 	if(pParams.image)
	{
		// this uses a non-public API
		
		STSDisplay * dpy = [STSDisplay instance];
		
		STSGridLayoutView * gv = [STSGridLayoutView new];
		
		UIImageView * iv = [UIImageView new];
		iv.contentMode = UIViewContentModeScaleAspectFit;
		iv.image = pParams.image;
		
		[gv addView:iv row:0 column:0];
		
		CGFloat m = [dpy centimetersToScreenUnits:0.2];
		
		[gv setMarginLeft:0.0 top:0.0 right:0.0 bottom:m];
		
		UIViewController *v = [[UIViewController alloc] init];
		v.view = gv;
	
		@try {
			[alert setValue:v forKey:@"contentViewController"];
		}
		@catch(NSException * ex)
		{
			STS_CORE_LOG_ERROR(@"Setting content view controller for UIAlertController doesn't seem to be supported on this platform");
		}
	}
 
 
	pParams.alertController = alert;
	
	NSString * b0 = (pParams.button0Text && pParams.button0Text.length) ? pParams.button0Text : @"OK";
	
	UIAlertAction * a0 = [
			UIAlertAction
			actionWithTitle:b0
			style:UIAlertActionStyleDefault
			handler:^(UIAlertAction * action) {
				if(pParams.delegate)
					[pParams.delegate messageBox:pParams dismissedWithButton:0];
				else if(pParams.callback)
					pParams.callback(pParams,0);
			}
		];
 
	[alert addAction:a0];
	
	if(pParams.button1Text && pParams.button1Text.length)
	{
		UIAlertAction * a1 = [
							  UIAlertAction
							  actionWithTitle:pParams.button1Text
							  style:UIAlertActionStyleDefault
							  handler:^(UIAlertAction * action) {
								  if(pParams.delegate)
									  [pParams.delegate messageBox:pParams dismissedWithButton:1];
								  else if(pParams.callback)
									  pParams.callback(pParams,1);
							  }
							  ];
		
		[alert addAction:a1];
	}

	if(pParams.button2Text && pParams.button2Text.length)
	{
		UIAlertAction * a2 = [
							  UIAlertAction
							  actionWithTitle:pParams.button2Text
							  style:UIAlertActionStyleDefault
							  handler:^(UIAlertAction * action) {
								  if(pParams.delegate)
									  [pParams.delegate messageBox:pParams dismissedWithButton:2];
								  else if(pParams.callback)
									  pParams.callback(pParams,2);
							  }
							  ];
		
		[alert addAction:a2];
	}

	if(pParams.button3Text && pParams.button3Text.length)
	{
		UIAlertAction * a3 = [
							  UIAlertAction
							  actionWithTitle:pParams.button3Text
							  style:UIAlertActionStyleDefault
							  handler:^(UIAlertAction * action) {
								  if(pParams.delegate)
									  [pParams.delegate messageBox:pParams dismissedWithButton:3];
								  else if(pParams.callback)
									  pParams.callback(pParams,3);
							  }
							  ];
		
		[alert addAction:a3];
	}

	if(!pParams.controller)
		pParams.controller = [UIView currentViewController];
	
	[pParams.controller presentViewController:alert animated:YES completion:nil];
}

@end
