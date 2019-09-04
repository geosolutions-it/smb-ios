//
//  STSModalDialogViewController.m
//  
//  Created by Szymon Tomasz Stefanek on 1/21/17.
//  Copyright © 2017 Szymon Tomasz Stefanek. All rights reserved.
//

#import "STSModalDialogViewController.h"

#import "STSCore.h"

@interface STSModalDialogViewControllerBackdropView : UIView
{
	STSModalDialogViewController * m_pController;
	UIView * m_pChild;
}

- (id)initWithFrame:(CGRect)rFrame controller:(STSModalDialogViewController *)pController andChildView:(UIView *)pChild;

@end

@implementation STSModalDialogViewControllerBackdropView

- (id)initWithFrame:(CGRect)rFrame controller:(STSModalDialogViewController *)pController andChildView:(UIView *)pChild
{
	self = [super initWithFrame:rFrame];
	if(!self)
		return nil;

	m_pChild = pChild;
	m_pController = pController;

	[self addSubview:pChild];
	return self;
}

- (void)layoutSubviews
{
	CGSize me = CGSizeMake(self.frame.size.width,self.frame.size.height - 20.0);
	CGSize s = [m_pController sizeForDialog:m_pChild inParentSize:me];

	m_pChild.frame = CGRectMake(
		(me.width - s.width) / 2.0,
		20.0 + (me.height - s.height) / 2.0,
		s.width,
		s.height
	);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
	[m_pController _backdropTouched];
}

@end

@interface STSModalDialogViewController ()
{
	UIView * m_pDialog;
	BOOL m_bShownAnimated;
	BOOL m_bAutoDismissOnBackgroundTouch;
	UIColor * m_pBackdropColor;
	BOOL m_bViewLoaded;
	__weak id<STSModalDialogViewControllerDismissDelegate> m_pDismissDelegate;
}
@end

@implementation STSModalDialogViewController

- (id)init
{
	self = [super init];
	if(!self)
		return nil;
	[self _initMDVC];
	
	return self;
}

- (id)initWithExistingDialog:(UIView *)pDialog
{
	self = [super init];
	if(!self)
		return nil;
	
	m_pDialog = pDialog;
	
	[self _initMDVC];
	
	return self;
}

- (void)_initMDVC
{
	m_bAutoDismissOnBackgroundTouch = false;
	m_pBackdropColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5];
	m_bViewLoaded = false;
}

- (void)setDismissDelegate:(__weak id<STSModalDialogViewControllerDismissDelegate>)pDelegate
{
	m_pDismissDelegate = pDelegate;
}

- (void)setAutoDismissOnBackdropTouch:(BOOL)bDismiss
{
	m_bAutoDismissOnBackgroundTouch = bDismiss;
}

- (void)setBackdropColor:(UIColor *)pColor
{
	m_pBackdropColor = pColor;
	if(m_bViewLoaded)
		self.view.backgroundColor = m_pBackdropColor;
}

- (void)loadView
{
	UIView * pDialog = [self loadDialog];
	if(!pDialog)
	{
		STS_CORE_LOG_ERROR(@"You must override loadDialog and return a UIView object from it");
	}
	
	m_pDialog = pDialog;

	self.view = [[STSModalDialogViewControllerBackdropView alloc] initWithFrame:[UIScreen mainScreen].bounds controller:self andChildView:pDialog];
	self.view.backgroundColor = m_pBackdropColor;
	
	if(pDialog && ([pDialog conformsToProtocol:@protocol(STSViewControllerDelegate)]))
		[self setDelegate:(NSObject<STSViewControllerDelegate> *)pDialog];
	
	m_bViewLoaded = true;
}

- (UIView *)loadDialog
{
	if(m_pDialog)
		return m_pDialog;
	STS_CORE_LOG_ERROR(@"You must either use initWithExistingDialog or override loadDialog");
	return nil;
}

- (void)_backdropTouched
{
	if(m_bAutoDismissOnBackgroundTouch)
	{
		if(m_pDismissDelegate)
		{
			if([m_pDismissDelegate respondsToSelector:@selector(modalDialogViewControllerWillDismissOnBackdropTouch:)])
			{
				bool bCancel = ![m_pDismissDelegate modalDialogViewControllerWillDismissOnBackdropTouch:self];
				if(bCancel)
					return;
			}
		}
		[self dismissViewControllerAnimated:m_bShownAnimated completion:nil];
	}
}

- (CGSize)sizeForDialog:(UIView *)pDialog inParentSize:(CGSize)sSize
{
	return [pDialog intrinsicContentSize];
}

- (void)presentFromController:(UIViewController *)pParentController
{
	m_bShownAnimated = true;
	[self presentFromController:pParentController animated:TRUE completion:nil];
}

- (void)presentFromController:(UIViewController *)pParentController animated:(BOOL)bAnimated
{
	m_bShownAnimated = bAnimated;
	[self presentFromController:pParentController animated:bAnimated completion:nil];
}

- (void)presentFromController:(UIViewController *)pParentController animated:(BOOL)bAnimated completion:(void (^)())fnCompletion;
{
	m_bShownAnimated = bAnimated;
	if([UIDevice currentDevice].systemVersion.integerValue >= 8)
	{
		pParentController.providesPresentationContextTransitionStyle = true;
		pParentController.definesPresentationContext = true;
		self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
	} else {
		self.modalPresentationStyle = UIModalPresentationCurrentContext;
	}
	
	[pParentController presentViewController:self animated:bAnimated completion:fnCompletion];
}

- (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion
{
	[super dismissViewControllerAnimated:flag completion:completion];
	if(m_pDismissDelegate)
		[m_pDismissDelegate modalDialogViewControllerDismissed:self];
}

@end
