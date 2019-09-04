//
//  STSPopupMenu.m
//  
//  Created by Szymon Tomasz Stefanek on 3/4/17.
//  Copyright © 2017 Szymon Tomasz Stefanek. All rights reserved.
//

#import "STSPopupMenu.h"

#import "STSImageAndTextButton.h"
#import "STSModalDialogViewController.h"
#import "STSDisplay.h"

@interface STSPopupMenu()<STSImageAndTextButtonDelegate,STSModalDialogViewControllerDismissDelegate>
{
	__weak id<STSPopupMenuDelegate> m_pDelegate;
	int m_iRow;
	STSModalDialogViewController * m_pDialogController;
}
@end

@implementation STSPopupMenu

- (id)initWithDelegate:(__weak id<STSPopupMenuDelegate>)del
{
	self = [super init];
	if(!self)
		return nil;
	m_pDelegate = del;
	[self _initPopupMenu];
	return self;
}

- (id)init
{
	self = [super init];
	if(!self)
		return nil;
	[self _initPopupMenu];
	return self;
}

- (void)_initPopupMenu
{
	m_iRow = 0;
	[self setMargin:[[STSDisplay instance] millimetersToScreenUnits:1.5]];
	
	self.backgroundColor = [UIColor whiteColor];
	self.layer.cornerRadius = 4.0;
	self.layer.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5].CGColor;
	self.layer.shadowOffset = CGSizeMake(2.0,2.0);
	self.layer.shadowRadius = 5.0;
	//self.clipsToBounds = YES;
}

- (STSImageAndTextButton *)addItem:(NSString *)szText tag:(NSString *)szTag
{
	STSImageAndTextButton * btn = [STSImageAndTextButton new];
	
	[btn setText:szText];
	[btn setImageVisible:false];
	btn.payload = szTag;
	[btn setDelegate:self];
	
	[self addView:btn row:m_iRow column:0];
	
	m_iRow++;
	
	return btn;
}

- (STSImageAndTextButton *)addItem:(NSString *)szText icon:(NSString *)szIcon tag:(NSString *)szTag
{
	STSImageAndTextButton * btn = [STSImageAndTextButton new];
	
	[btn setText:szText];
	[btn setImage:[UIImage imageNamed:szIcon] forState:STSButtonStateNormal];
	btn.payload = szTag;
	[btn setDelegate:self];
	
	[self addView:btn row:m_iRow column:0];
	
	m_iRow++;
	
	return btn;
}

- (void)showAsDialogFromController:(UIViewController *)pController;
{
	m_pDialogController = [[STSModalDialogViewController alloc] initWithExistingDialog:self];
	[m_pDialogController setAutoDismissOnBackdropTouch:true];
	[m_pDialogController setDismissDelegate:self];
	[m_pDialogController setBackdropColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.1]];
	[m_pDialogController presentFromController:pController animated:NO completion:nil];
}

- (void)modalDialogViewControllerDismissed:(STSModalDialogViewController *)pControler
{
	if(m_pDialogController == pControler)
	{
		[m_pDialogController setDismissDelegate:nil];
		m_pDialogController = nil;
	}
}

- (void)close
{
	if(m_pDialogController)
	{
		[m_pDialogController dismissViewControllerAnimated:NO completion:nil];
		m_pDialogController = nil;
	}
}

- (void)imageAndTextButtonTapped:(STSImageAndTextButton *)pButton
{
	NSString * tag = (NSString *)pButton.payload;
	
	if(!m_pDelegate)
		return;

	[self close];
	
	[m_pDelegate popupMenu:self itemActivated:tag];
}

@end
