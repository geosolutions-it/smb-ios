//
//  STSProgressDialog.m
//
//  Created by Szymon Tomasz Stefanek on 9/1/18.
//  Copyright © 2018 Szymon Tomasz Stefanek. All rights reserved.
//

#import "STSProgressDialog.h"

#import "M13ProgressViewRing.h"
#import "UIApplication+M13ProgressSuite.h"

@implementation STSProgressDialog

- (id)init
{
	self = [super initWithProgressView:[[M13ProgressViewRing alloc] init]];
	if(!self)
		return nil;
	
	self.progressViewSize = CGSizeMake(60.0, 60.0);
	self.animationPoint = CGPointMake([UIScreen mainScreen].bounds.size.width / 2, [UIScreen mainScreen].bounds.size.height / 2);

	//[self setIndeterminate:true];
	[self setMaskType:M13ProgressHUDMaskTypeSolidColor];

	UIWindow * window = ((id<UIApplicationDelegate>)[UIApplication safeM13SharedApplication].delegate).window;
	[window addSubview:self];

	return self;
}

- (void)showAsIndeterminate:(bool)bAnimated
{
	[self setIndeterminate:true];
	[self show:bAnimated];
}

- (void)showAsIndeterminate:(bool)bAnimated withText:(NSString *)szText
{
	[self setIndeterminate:true];
	self.status = szText;
	[self show:bAnimated];
}

- (void)close:(bool)bAnimated
{
	[self dismiss:bAnimated];
}

@end
