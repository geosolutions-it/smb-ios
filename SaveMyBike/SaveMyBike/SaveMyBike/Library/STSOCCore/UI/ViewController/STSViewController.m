//
//  STSViewController.m
//
//  Created by Szymon Tomasz Stefanek on 1/22/17.
//  Copyright © 2017 Szymon Tomasz Stefanek. All rights reserved.
//

#import "STSViewController.h"


@interface STSViewController ()
{
	__weak NSObject<STSViewControllerDelegate> * m_pDelegate;
}

@end

@implementation STSViewController

- (id)init
{
	self = [super init];
	if(!self)
		return nil;
	
	m_pDelegate = nil;
	
	return self;
}

- (void)dealloc
{
	if(m_pDelegate)
		m_pDelegate = nil;
}

- (void)setDelegate:(__weak NSObject<STSViewControllerDelegate> *)pDelegate
{
	m_pDelegate = pDelegate;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	if(!m_pDelegate)
	{
		if([self.view conformsToProtocol:@protocol(STSViewControllerDelegate)])
			m_pDelegate = (NSObject<STSViewControllerDelegate> *)self.view;
	}
	if(m_pDelegate && [m_pDelegate respondsToSelector:@selector(onViewLoaded)])
		[m_pDelegate onViewLoaded];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	if(m_pDelegate && [m_pDelegate respondsToSelector:@selector(onViewAboutToShow)])
		[m_pDelegate onViewAboutToShow];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	if(m_pDelegate && [m_pDelegate respondsToSelector:@selector(onViewShown)])
		[m_pDelegate onViewShown];
}

- (void)viewWillDisappear:(BOOL)animated
{
	if(m_pDelegate && [m_pDelegate respondsToSelector:@selector(onViewAboutToHide)])
		[m_pDelegate onViewAboutToHide];
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	if(m_pDelegate && [m_pDelegate respondsToSelector:@selector(onViewHidden)])
		[m_pDelegate onViewHidden];
	[super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
	if(m_pDelegate && [m_pDelegate respondsToSelector:@selector(onMemoryWarning)])
		[m_pDelegate onMemoryWarning];
}

- (void)presentFromController:(UIViewController *)pParentController
{
	[self presentFromController:pParentController animated:TRUE completion:nil];
}

- (void)presentFromController:(UIViewController *)pParentController animated:(BOOL)bAnimated
{
	[self presentFromController:pParentController animated:bAnimated completion:nil];
}

- (void)presentFromController:(UIViewController *)pParentController animated:(BOOL)bAnimated completion:(void (^)())fnCompletion;
{
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

@end
