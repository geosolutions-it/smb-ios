//
//  STSDialog.m
//
//  Created by Szymon Tomasz Stefanek on 3/4/17.
//  Copyright © 2017 Szymon Tomasz Stefanek. All rights reserved.
//

#import "STSDialog.h"

#import "STSImageAndTextButton.h"
#import "STSLabel.h"
#import "STSDisplay.h"
#import "STSModalDialogViewController.h"

@interface STSDialogHiddenDelegate : NSObject<STSImageAndTextButtonDelegate>

@property(nonatomic) STSDialog * dialog;

@end

@implementation STSDialogHiddenDelegate

- (void)imageAndTextButtonTapped:(STSImageAndTextButton *)pButton
{
	[self.dialog _buttonBarButtonTapped:pButton];
}

@end

@interface STSDialog()<STSModalDialogViewControllerDismissDelegate>
{
	BOOL m_bShowsTitle;
	STSLabel * m_pTitleLabel;
	UIView * m_pTitleSeparator;
	UIView * m_pCentralView;
	NSString * m_szTitle;
	UIView * m_pButtonBarSeparator;
	int m_iButtonBarColumn;
	STSGridLayoutView * m_pButtonBar;
	NSString * m_szBackgroundTouchDismissTag;
	STSModalDialogViewController * m_pController;
	__weak id<STSDialogDelegate> m_pDelegate;
	NSString * m_szResultTag;
	STSDialogHiddenDelegate * m_pHiddenDelegate;
}
@end

@implementation STSDialog

- (id)init
{
	self = [super init];
	if(!self)
		return nil;
	[self _initDialog];
	return self;
}

- (void)_initDialog
{
	m_bShowsTitle = false;
	
	m_pHiddenDelegate = [STSDialogHiddenDelegate new];
	m_pHiddenDelegate.dialog = self;
	
	m_pTitleLabel = [STSLabel new];
	m_pTitleSeparator = [UIView new];
	m_pTitleSeparator.backgroundColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1.0];
	[self setRow:0 fixedHeight:0];
	[self setRow:1 fixedHeight:0];

	m_pButtonBarSeparator = [UIView new];
	m_pButtonBarSeparator.backgroundColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1.0];
	[self addView:m_pButtonBarSeparator row:3 column:0];
	[self setRow:3 fixedHeight:1.0 /[UIScreen mainScreen].scale];
	
	m_pButtonBar = [STSGridLayoutView new];
	
	m_iButtonBarColumn = 0;
	
	[self addView:m_pButtonBar row:4 column:0 verticalSizePolicy:STSSizePolicyFixed horizontalSizePolicy:STSSizePolicyIgnore];
	
	[self setMargin:[[STSDisplay instance] millimetersToScreenUnits:1.5]];
	
	self.backgroundColor = [UIColor whiteColor];
	self.layer.cornerRadius = 4.0;
	self.layer.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5].CGColor;
	self.layer.shadowOffset = CGSizeMake(2.0,2.0);
	self.layer.shadowRadius = 5.0;
	self.layer.shadowOpacity = 1.0;
	//self.clipsToBounds = YES;
}

- (void)setDelegate:(__weak id<STSDialogDelegate>)pDelegate
{
	m_pDelegate = pDelegate;
}

- (void)setBackgroundTouchDismissTag:(NSString *)szTag
{
	m_szBackgroundTouchDismissTag = szTag;
}

- (void)setShowsTitle:(BOOL)bShowsTitle
{
	if(m_bShowsTitle == bShowsTitle)
		return;
	m_bShowsTitle = bShowsTitle;
	
	if(m_bShowsTitle)
	{
		m_pTitleLabel.text = m_szTitle ? m_szTitle : @"";
		m_pTitleLabel.font = [UIFont boldSystemFontOfSize:[[STSDisplay instance] centimetersToFontUnits:0.4]];
		m_pTitleLabel.textAlignment = NSTextAlignmentCenter;
		[self addView:m_pTitleLabel row:0 column:0];
		[self addView:m_pTitleSeparator row:1 column:0];
		[self setRow:0 fixedHeight:[[STSDisplay instance] centimetersToScreenUnits:0.7]];
		[self setRow:1 fixedHeight:1.0 / [UIScreen mainScreen].scale];
	} else {
		[m_pTitleLabel removeFromSuperview];
		[m_pTitleSeparator removeFromSuperview];
		[self setRow:0 fixedHeight:0];
		[self setRow:1 fixedHeight:0];
	}
}

- (void)setTitle:(NSString *)szTitle
{
	m_szTitle = szTitle;
	[self setShowsTitle:YES];
}

- (void)setCentralView:(UIView *)pView verticalSizePolicy:(STSSizePolicy)eVerticalSizePolicy horizontalSizePolicy:(STSSizePolicy)eHorizontalSizePolicy;
{
	[self addView:pView row:2 column:0 verticalSizePolicy:eVerticalSizePolicy horizontalSizePolicy:eHorizontalSizePolicy];
}

- (void)setCentralViewMinimumWidth:(CGFloat)fWidth
{
	[self setColumn:0 minimumWidth:fWidth];
}

- (void)setCentralViewMaximumWidth:(CGFloat)fWidth
{
	[self setColumn:0 maximumWidth:fWidth];
}

- (void)setCentralViewMinimumHeight:(CGFloat)fHeight
{
	[self setRow:2 minimumHeight:fHeight];
}

- (void)setCentralViewFixedHeight:(CGFloat)fHeight
{
	[self setRow:2 fixedHeight:fHeight];
}


- (STSImageAndTextButton *)addButton:(NSString *)szText tag:(NSString *)szTag
{
	STSImageAndTextButton * btn = [STSImageAndTextButton new];
	
	[btn setText:szText];
	[btn setImageVisible:false];
	btn.payload = szTag;
	[btn setDelegate:m_pHiddenDelegate];
	[btn.label setTextAlignment:NSTextAlignmentCenter];
	btn.label.font = [UIFont boldSystemFontOfSize:[[STSDisplay instance] centimetersToFontUnits:0.4]];
	
	[m_pButtonBar addView:btn row:0 column:m_iButtonBarColumn];
	
	m_iButtonBarColumn++;
	
	return btn;
}

- (STSImageAndTextButton *)addButton:(NSString *)szText icon:(NSString *)szIcon tag:(NSString *)szTag
{
	STSImageAndTextButton * btn = [STSImageAndTextButton new];
	
	[btn setText:szText];
	[btn setImageVisible:false];
	[btn setImage:[UIImage imageNamed:szIcon] forState:STSButtonStateNormal];
	btn.payload = szTag;
	[btn setDelegate:m_pHiddenDelegate];
	btn.label.font = [UIFont boldSystemFontOfSize:[[STSDisplay instance] centimetersToFontUnits:0.4]];
	
	[m_pButtonBar addView:btn row:0 column:m_iButtonBarColumn];
	
	m_iButtonBarColumn++;
	
	return btn;
}

- (void)_buttonBarButtonTapped:(STSImageAndTextButton *)pButton;
{
	if(!pButton)
		return;
	if(!pButton.payload)
		return;
	if(pButton.superview != m_pButtonBar)
		return;
	NSString * s = (NSString *)pButton.payload;
	if(!m_pController)
		return;
	
	if(m_pDelegate)
	{
		if([m_pDelegate respondsToSelector:@selector(dialog:willDismissWithTag:)])
		{
			BOOL bCancel = ![m_pDelegate dialog:self willDismissWithTag:s];
			if(bCancel)
				return;
		}
	}
	
	m_szResultTag = s;
	
	[m_pController dismissViewControllerAnimated:YES completion:nil];
}

- (void)showFromController:(UIViewController *)pController
{
	m_pController = [[STSModalDialogViewController alloc] initWithExistingDialog:self];
	[m_pController setAutoDismissOnBackdropTouch:true];
	[m_pController setDismissDelegate:self];
	[m_pController setBackdropColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5]];
	[m_pController presentFromController:pController animated:YES completion:nil];
}

- (BOOL)modalDialogViewControllerWillDismissOnBackdropTouch:(STSModalDialogViewController *)pController
{
	if(!m_szBackgroundTouchDismissTag)
		return false;
	m_szResultTag = m_szBackgroundTouchDismissTag;
	return true;
}

- (void)modalDialogViewControllerDismissed:(STSModalDialogViewController *)pControler
{
	if(pControler != m_pController)
		return;

	if(m_pDelegate)
	{
		if([m_pDelegate respondsToSelector:@selector(dialog:didDismissWithTag:)])
			[m_pDelegate dialog:self didDismissWithTag:m_szResultTag];
	}
}

@end
