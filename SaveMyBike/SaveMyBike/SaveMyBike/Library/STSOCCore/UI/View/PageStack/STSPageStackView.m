//
//  STSPageStackView.m
//  
//  Created by Szymon Tomasz Stefanek on 2/18/17.
//  Copyright © 2017 Szymon Tomasz Stefanek. All rights reserved.
//

#import "STSPageStackView.h"
#import "STSPageStackPage.h"
#import "STSImageButton.h"
#import "STSPageStackAction.h"
#import "STSDisplay.h"
#import "STSLabel.h"
#import "STSPageStackViewActionButton.h"

#define ANIMATION_DURATION 0.35

typedef enum _STSPageStackViewAnimation
{
	STSPageStackViewAnimationNone,
	STSPageStackViewAnimationPop,
	STSPageStackViewAnimationPush
} STSPageStackViewAnimation;

@interface STSPageStackView ()
{
	NSMutableArray<STSPageStackPage *> * m_pPageStack;
	NSMutableArray<STSPageStackAction *> * m_pActiveActions;
	STSPageStackPage * m_pCurrentPage;
	STSImageButton * m_pBackButton;
	STSGridLayoutView * m_pActionBar;
	UIView * m_pStatusBarBackground;
	CGFloat m_fActionBarHeight;
	CGFloat m_fButtonWidth;
	int m_iActionBarColumn;
	NSTimer * m_pActionBarUpdateTimer;
	STSLabel * m_pActionBarTitleLabel; // may be null if overridden

	STSPageStackViewAnimation m_eCurrentAnimation;
	STSPageStackPage * m_pAnimationOtherPage;
	int m_iPushAnimationNumberOfViewsToPop;

	NSMutableArray<STSPageStackAction *> * m_pPersistentLeftActions;
	NSMutableArray<STSPageStackAction *> * m_pPersistentRightActions;
	
	CGFloat m_fStatusBarHeight;
	
	BOOL m_bAppGoneBackground;
}

@end

@implementation STSPageStackView

- (id)initWithFrame:(CGRect)rFrame
{
	self = [super initWithFrame:rFrame];
	if(!self)
		return nil;
	
	[self _initPageStackView];
	
	return self;
}

#define MMIN(a,b) ((a < b) ? a : b)

- (void)_initPageStackView
{
	m_pPageStack = [NSMutableArray new];
	m_pCurrentPage = nil;
	
	STSDisplay * dpy = [STSDisplay instance];
	m_fActionBarHeight = [dpy centimetersToScreenUnits:0.95];
	m_fButtonWidth = [dpy centimetersToScreenUnits:0.85];

	m_fStatusBarHeight = MMIN([UIApplication sharedApplication].statusBarFrame.size.height,[UIApplication sharedApplication].statusBarFrame.size.width);
	if(m_fStatusBarHeight < 20.0)
		m_fStatusBarHeight = 20.0;
	
	m_pActionBarUpdateTimer = nil;
	
	_showStatusBarBackground = true;

	m_pActionBar = [STSGridLayoutView new];
	[m_pActionBar setMargin:0.0];
	[m_pActionBar setSpacing:0.0];
	
	m_pStatusBarBackground = [UIView new];
	[self addSubview:m_pStatusBarBackground];
	m_pStatusBarBackground.backgroundColor = _defaultStatusBarBackgroundColor ? _defaultStatusBarBackgroundColor : [UIColor lightGrayColor];
	
	m_pPersistentLeftActions = nil;
	m_pPersistentRightActions = nil;
	
	m_pBackButton = [STSImageButton new];
	[self _setupActionButton:m_pBackButton];
	[m_pBackButton setImage:[UIImage imageNamed:@"STSCore_leftArrow"] forState:STSButtonStateNormal];
	
	m_eCurrentAnimation = STSPageStackViewAnimationNone;
	m_iPushAnimationNumberOfViewsToPop = 0;
	
	m_pActiveActions = [NSMutableArray new];
	
	[self addSubview:m_pActionBar];
	
	//[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
	//[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)removeFromSuperview
{
	if(m_pActionBarUpdateTimer)
	{
		[m_pActionBarUpdateTimer invalidate];
		m_pActionBarUpdateTimer = nil;
	}
	[super removeFromSuperview];
}

- (void)setStatusBarBackgroundColor:(UIColor *)clr
{
	if(m_pStatusBarBackground)
		m_pStatusBarBackground.backgroundColor = clr;
}

- (void)setBackButtonImageName:(NSString *)szImageName
{
	UIImage * pImage = [UIImage imageNamed:szImageName];
	if(pImage)
		pImage = [pImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
	[m_pBackButton setImage:pImage forState:STSButtonStateNormal];
}

- (void)addPersistentLeftAction:(STSPageStackAction *)pAction
{
	if(!m_pPersistentLeftActions)
		m_pPersistentLeftActions = [NSMutableArray new];
	[m_pPersistentLeftActions addObject:pAction];
}

- (void)addPersistentRightAction:(STSPageStackAction *)pAction
{
	if(!m_pPersistentRightActions)
		m_pPersistentRightActions = [NSMutableArray new];
	[m_pPersistentRightActions addObject:pAction];
}

- (NSArray<STSPageStackPage *> *)pageStack
{
	return m_pPageStack;
}

- (STSPageStackPage *)currentPage
{
	return m_pCurrentPage;
}

- (void)_setupActionButton:(STSImageButton *)b
{
	[b setDelegate:self];
	[b setBackgroundColor:[UIColor clearColor] forState:STSButtonStatePressed];
	[b setBackgroundColor:[UIColor clearColor] forState:STSButtonStateNormal];
	[b setBackgroundColor:[UIColor clearColor] forState:STSButtonStateDisabled];
	[b setAlpha:0.6 forState:STSButtonStatePressed];
	[b setAlpha:0.4 forState:STSButtonStateDisabled];
	[b setImageUsesTintColor:true];
}

- (void)_setupActionBarForCurrentPage_addActions:(NSArray<STSPageStackAction *> *)pActions
{
	if(!pActions)
		return;

	CGFloat mh = [[STSDisplay instance] centimetersToScreenUnits:0.1];
	CGFloat mv = [[STSDisplay instance] centimetersToScreenUnits:0.2];
	
	for(STSPageStackAction * a in pActions)
	{
		if((!a.button) || (a.changed))
		{
			a.button = [STSPageStackViewActionButton new];
			[self _setupActionButton:a.button];
			[a.button setImage:[UIImage imageNamed:a.icon] forState:STSButtonStateNormal];
			//[a.button setImage:[UIImage imageNamed:@"STSCore_leftArrow"] forState:STSButtonStateNormal];
			a.button.action = a;
		}
		
		a.stackView = self;
		a.changed = false;
		[a.button setEnabled:a.enabled];
		
		[m_pActionBar addView:a.button row:0 column:m_iActionBarColumn];
		[m_pActionBar setColumn:m_iActionBarColumn fixedWidth:(a.width) > 0.0 ? a.width : m_fButtonWidth];
		[m_pActionBar setView:a.button margins:[STSMargins marginsWithLeft:mh top:mv right:mh bottom:mv]];
		m_iActionBarColumn++;
		
		a.stackView = self;
		[m_pActiveActions addObject:a];
	}
}

- (void)_setupActionBarForCurrentPage
{
	[m_pActionBar removeAllViews];
	[m_pActionBar removeAllConstraints];

	for(STSPageStackAction * act in m_pActiveActions)
		act.stackView = nil;

	[m_pActiveActions removeAllObjects];
	
	
	m_iActionBarColumn = 0;
	if(m_pPageStack.count > 1)
	{
		[m_pActionBar addView:m_pBackButton row:0 column:0];
		[m_pActionBar setColumn:0 fixedWidth:m_fButtonWidth];
		m_iActionBarColumn++;
	}

	if(m_pPersistentLeftActions)
		[self _setupActionBarForCurrentPage_addActions:m_pPersistentLeftActions];

	UIView * pCenterView = nil;

	if(m_pCurrentPage)
	{
		NSArray<STSPageStackAction *> * pActions = m_pCurrentPage.leftActions;
		if(pActions)
			[self _setupActionBarForCurrentPage_addActions:pActions];

		pCenterView = m_pCurrentPage.actionBarCenterView;
	}
	
	if(!pCenterView)
	{
		pCenterView = self.defaultActionBarCenterView;
		if(!pCenterView)
		{
			if(!m_pActionBarTitleLabel)
			{
				STSDisplay * dpy = [STSDisplay instance];
				
				CGFloat mmm = [dpy millimetersToFontUnits:1.0];
				
				m_pActionBarTitleLabel = [STSLabel new];
				[m_pActionBarTitleLabel setFont:[UIFont boldSystemFontOfSize:[dpy millimetersToFontUnits:3.2]]];
				[m_pActionBarTitleLabel setMarginLeft:mmm + mmm top:mmm right:mmm + mmm bottom:mmm];
			}
			pCenterView = m_pActionBarTitleLabel;
		}
	}

	[m_pActionBar addView:pCenterView row:0 column:m_iActionBarColumn verticalSizePolicy:STSSizePolicyIgnore horizontalSizePolicy:STSSizePolicyIgnore];
	[m_pActionBar setColumn:m_iActionBarColumn expandWeight:1500.0];
	m_iActionBarColumn++;

	if(m_pCurrentPage)
	{
		NSArray<STSPageStackAction *> * pActions = m_pCurrentPage.rightActions;
		if(pActions)
			[self _setupActionBarForCurrentPage_addActions:pActions];
	}

	if(m_pPersistentRightActions)
		[self _setupActionBarForCurrentPage_addActions:m_pPersistentRightActions];
	
	[self updateActionBarTitle];
}

- (void)layoutSubviews
{
	if(m_eCurrentAnimation == STSPageStackViewAnimationNone)
		[self _layoutWithActionBarPositionReferencePage:m_pCurrentPage centerPage:m_pCurrentPage otherPage:nil otherPageOnRight:NO actionBarOnRight:NO];
}

- (void)_setupActionBarColorsForPage:(STSPageStackPage *)pPage
{
	UIColor * pBackground;
	UIColor * pForeground;
	
	if(pPage)
	{
		pBackground = pPage.actionBarBackgroundColor;
		pForeground = pPage.actionBarForegroundColor;
	}

	if(!pBackground)
	{
		pBackground = self.defaultActionBarBackgroundColor;
		if(!pBackground)
			pBackground = [UIColor redColor];
	}
		
	if(!pForeground)
	{
		pForeground = self.defaultActionBarForegroundColor;
		if(!pForeground)
			pForeground = [UIColor whiteColor];
	}
	
	m_pActionBar.backgroundColor = pBackground;
	
	[m_pBackButton setTintColor:pForeground forState:STSButtonStateNormal];
	[m_pBackButton setTintColor:pForeground forState:STSButtonStatePressed];
	[m_pBackButton setTintColor:pForeground forState:STSButtonStateDisabled];
	
	for(STSPageStackAction * a in m_pActiveActions)
	{
		if(!a.button)
			continue;
		[a.button setTintColor:pForeground forState:STSButtonStateNormal];
		[a.button setTintColor:pForeground forState:STSButtonStatePressed];
		[a.button setTintColor:pForeground forState:STSButtonStateDisabled];
	}
	
	if(m_pActionBarTitleLabel)
		m_pActionBarTitleLabel.textColor = pForeground;
	
	pBackground = pPage ? pPage.statusBarBackgroundColor : self.defaultStatusBarBackgroundColor;
	if(!pBackground)
		pBackground = [UIColor lightGrayColor];
	
	m_pStatusBarBackground.backgroundColor = pBackground;
}

- (void)_layoutWithActionBarPositionReferencePage:(STSPageStackPage *)pActionBarPage centerPage:(STSPageStackPage *)pCenterPage otherPage:(STSPageStackPage *)pOtherPage otherPageOnRight:(BOOL)bOtherPageIsOutside actionBarOnRight:(BOOL)bActionBarOnRight
{
	STSPageStackActionBarMode eActionBarMode = pActionBarPage ? pActionBarPage.actionBarMode : STSPageStackActionBarModeHidden;
	
	CGRect rActionBar;
	
	CGFloat y;
	CGSize s;
	
	if(_showStatusBarBackground)
	{
		y = m_fStatusBarHeight;
		s = CGSizeMake(self.bounds.size.width,self.bounds.size.height - m_fStatusBarHeight);
		m_pStatusBarBackground.frame = CGRectMake(0,0,s.width,m_fStatusBarHeight);
		m_pStatusBarBackground.hidden = false;
	} else {
		y = 0;
		s = self.bounds.size;
		m_pStatusBarBackground.frame = CGRectMake(0,-m_fStatusBarHeight-10.0,s.width,m_fStatusBarHeight);
		m_pStatusBarBackground.hidden = true;
	}
	
	switch(eActionBarMode)
	{
		case STSPageStackActionBarModeVisible:
		case STSPageStackActionBarModeOverlappingView:
			rActionBar = CGRectMake(bActionBarOnRight ? s.width : 0.0,y,s.width,m_fActionBarHeight);
			break;
		//case STSPageStackActionBarModeHidden:
		default:
			rActionBar = CGRectMake(s.width,y,s.width,m_fActionBarHeight);
			break;
	}

	m_pActionBar.frame = rActionBar;

	if(pCenterPage)
	{
		eActionBarMode = pCenterPage.actionBarMode;
	
		CGRect rPage;
		switch(eActionBarMode)
		{
			case STSPageStackActionBarModeVisible:
				rPage = CGRectMake(0,y + m_fActionBarHeight,s.width,s.height - m_fActionBarHeight);
				break;
			case STSPageStackActionBarModeOverlappingView:
				rPage = CGRectMake(0,y,s.width,s.height);
				break;
				//case STSPageStackActionBarModeHidden:
			default:
				rPage = CGRectMake(0,y,s.width,s.height);
				break;
		}

		pCenterPage.frame = rPage;
	}

	if(pOtherPage)
	{
		eActionBarMode = pOtherPage.actionBarMode;
		
		float xOffset = bOtherPageIsOutside ? (s.width * pOtherPage.inOutAnimationSideX) : 0;
		float yOffset = bOtherPageIsOutside ? (s.height * pOtherPage.inOutAnimationSideY) : 0;
		
		CGRect rPage;
		switch(eActionBarMode)
		{
			case STSPageStackActionBarModeVisible:
				rPage = CGRectMake(xOffset,y + yOffset + m_fActionBarHeight,s.width,s.height - m_fActionBarHeight);
				break;
			case STSPageStackActionBarModeOverlappingView:
				rPage = CGRectMake(xOffset,y + yOffset,s.width,s.height);
				break;
				//case STSPageStackActionBarModeHidden:
			default:
				rPage = CGRectMake(xOffset,y + yOffset,s.width,s.height);
				break;
		}
		
		pOtherPage.frame = rPage;
	}
	
	[self bringSubviewToFront:m_pActionBar];
	[self bringSubviewToFront:m_pStatusBarBackground];
}

- (int)indexOfPage:(STSPageStackPage *)pPage
{
	int idx = 0;
	for(STSPageStackPage * p in m_pPageStack)
	{
		if(p == pPage)
			return idx;
		idx++;
	}
	return -1;
}

- (void)_completeAnimations
{
	switch(m_eCurrentAnimation)
	{
		case STSPageStackViewAnimationPop:
			if(m_pAnimationOtherPage)
			{
				[m_pAnimationOtherPage onPageDetach];
				[m_pAnimationOtherPage removeFromSuperview];
			}
			break;
		case STSPageStackViewAnimationPush:
			if(m_pAnimationOtherPage)
				[m_pAnimationOtherPage removeFromSuperview];
			break;
		default:
			break;
	}
	
	while(m_iPushAnimationNumberOfViewsToPop > 0)
	{
		if(m_pPageStack.count < 2)
			break;

		STSPageStackPage * p = [m_pPageStack objectAtIndex:m_pPageStack.count - 2];
		[p onPageDetach];
		[p _internalSetPageStackView:nil];
		[p removeFromSuperview];
		[m_pPageStack removeObjectAtIndex:m_pPageStack.count - 2];
		
		m_iPushAnimationNumberOfViewsToPop--;
	}
	
	m_pAnimationOtherPage = nil;
	m_eCurrentAnimation = STSPageStackViewAnimationNone;
}

- (void)switchToPage:(STSPageStackPage * )pPage
{
	if(pPage == m_pCurrentPage)
		return;
	
	[self _completeAnimations];
	
	bool bFoundInTheStack = false;
	
	if(m_pCurrentPage)
		[self _triggerPageDeactivate:m_pCurrentPage];
	
	for(STSPageStackPage * p in m_pPageStack)
	{
		if(p == pPage)
		{
			// found in the stack (so superview should be already correct)
			bFoundInTheStack = false;
			break;
		}
		
		[p onPageDetach];
		[p _internalSetPageStackView:nil];
		[p removeFromSuperview];
	}

	[m_pPageStack removeAllObjects];
	
	m_pCurrentPage = pPage;

	if(!pPage)
	{
		// nothing to do
		[self _layoutWithActionBarPositionReferencePage:nil centerPage:nil otherPage:nil otherPageOnRight:NO actionBarOnRight:NO];
		return;
	}
	
	if(!bFoundInTheStack)
	{
		[self addSubview:pPage];
		[pPage _internalSetPageStackView:self];
		[pPage onPageAttach];
	}
	
	[m_pPageStack removeAllObjects];
	[m_pPageStack addObject:pPage];
	[self updateActionBar];
	
	[self _layoutWithActionBarPositionReferencePage:m_pCurrentPage centerPage:m_pCurrentPage otherPage:nil otherPageOnRight:NO actionBarOnRight:NO];
	[self _triggerPageActivate:pPage];
}


- (void)updateActionBarTitle
{
	if(!m_pActionBarTitleLabel)
		return;
	NSString * title = m_pCurrentPage ? m_pCurrentPage.actionBarTitle : self.defaultActionBarTitle;
	[m_pActionBarTitleLabel setText:title ? title : @""];
}

- (void)updateActionBar
{
	if(m_pActionBarUpdateTimer)
	{
		[m_pActionBarUpdateTimer invalidate];
		m_pActionBarUpdateTimer = nil;
	}
	[self _setupActionBarForCurrentPage];
	[self _setupActionBarColorsForPage:m_pCurrentPage];
}

- (void)onUpdateActionBarTimer:(id)crap
{
	[self updateActionBar];
}

- (void)triggerUpdateActionBar
{
	if(m_pActionBarUpdateTimer)
		return;
	m_pActionBarUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:0.0 target:self selector:@selector(onUpdateActionBarTimer:) userInfo:nil repeats:false];
}

- (void)pushPage:(STSPageStackPage *)pPage
{
	[self pushPage:pPage numberOfUnderlyingViewsToRemove:0];
}

- (void)pushPage:(STSPageStackPage *)pPage numberOfUnderlyingViewsToRemove:(int)iNumberOfUnderlyingViewsToRemove
{
	[self pushPage:pPage numberOfUnderlyingViewsToRemove:0 withAnimation:true];
}


- (void)pushPage:(STSPageStackPage *)pPage numberOfUnderlyingViewsToRemove:(int)iNumberOfUnderlyingViewsToRemove withAnimation:(bool)bAnimation
{
	if(!pPage)
		return;
	
	if(pPage == m_pCurrentPage)
		return;

	[self _completeAnimations];

	m_iPushAnimationNumberOfViewsToPop = iNumberOfUnderlyingViewsToRemove;
	
	if(m_pCurrentPage)
		[self _triggerPageDeactivate:m_pCurrentPage];
	
	m_pAnimationOtherPage = m_pCurrentPage;
	
	m_pCurrentPage = pPage;

	int iIdx = [self indexOfPage:pPage];

	if(iIdx < 0)
	{
		[pPage _internalSetPageStackView:self];
		[pPage onPageAttach];
	} else {
		[m_pPageStack removeObjectAtIndex:iIdx];
	}

	[self addSubview:pPage];
	[m_pPageStack addObject:pPage];
	[self _setupActionBarForCurrentPage];
	[self _setupActionBarColorsForPage:m_pAnimationOtherPage];

	if(m_pAnimationOtherPage)
		[self bringSubviewToFront:m_pAnimationOtherPage];
	[self bringSubviewToFront:pPage];

	bool bAnimateActionBar = bAnimation &&
		m_pAnimationOtherPage &&
		(
			(m_pCurrentPage.actionBarMode == STSPageStackActionBarModeVisible) ||
			(m_pCurrentPage.actionBarMode == STSPageStackActionBarModeOverlappingView)
		) && (
			m_pAnimationOtherPage.actionBarMode == STSPageStackActionBarModeHidden
		);

	[self _layoutWithActionBarPositionReferencePage:m_pCurrentPage centerPage:m_pAnimationOtherPage otherPage:m_pCurrentPage otherPageOnRight:YES actionBarOnRight:bAnimateActionBar];
	[self _triggerPageActivate:pPage];

	m_eCurrentAnimation = STSPageStackViewAnimationPush;
	
	if(bAnimation)
	{
		[UIView
			animateWithDuration:ANIMATION_DURATION
			delay:0.0
			options:UIViewAnimationOptionCurveLinear
			animations:^(void)
			{
				[self _layoutWithActionBarPositionReferencePage:m_pCurrentPage centerPage:m_pCurrentPage otherPage:m_pAnimationOtherPage otherPageOnRight:NO actionBarOnRight:NO];
				[self _setupActionBarColorsForPage:m_pCurrentPage];
			}
			completion:^(BOOL finished)
			{
				[self _completeAnimations];
			}
		 ];
	} else {
		[self _completeAnimations];
	}
}

- (void)_triggerPageActivate:(STSPageStackPage *)pPage
{
	[pPage onPageActivate];
	if(self.delegate && [self.delegate respondsToSelector:@selector(pageStackView:pageActivated:)])
		[self.delegate pageStackView:self pageActivated:pPage];
}

- (void)_triggerPageDeactivate:(STSPageStackPage *)pPage
{
	[pPage onPageDeactivate];
	if(self.delegate && [self.delegate respondsToSelector:@selector(pageStackView:pageDeactivated:)])
		[self.delegate pageStackView:self pageDeactivated:pPage];
}

- (void)popCurrentPage
{
	if(!m_pCurrentPage)
		return;

	[self _completeAnimations];

	m_pAnimationOtherPage = m_pCurrentPage;
	
	[self _triggerPageDeactivate:m_pCurrentPage];
	
	[m_pPageStack removeLastObject];
	m_pCurrentPage = [m_pPageStack lastObject];

	[self _setupActionBarForCurrentPage];
	m_eCurrentAnimation = STSPageStackViewAnimationPop;

	[self _setupActionBarColorsForPage:m_pAnimationOtherPage];


	bool bAnimateActionBar = m_pAnimationOtherPage &&
		(
			(m_pAnimationOtherPage.actionBarMode == STSPageStackActionBarModeVisible) ||
			(m_pAnimationOtherPage.actionBarMode == STSPageStackActionBarModeOverlappingView)
		) && (
			m_pCurrentPage.actionBarMode == STSPageStackActionBarModeHidden
		);

	if(m_pCurrentPage)
	{
		[self addSubview:m_pCurrentPage];
		[self bringSubviewToFront:m_pCurrentPage];
		[self bringSubviewToFront:m_pAnimationOtherPage];
		[self _layoutWithActionBarPositionReferencePage:bAnimateActionBar ? m_pAnimationOtherPage : m_pCurrentPage centerPage:m_pCurrentPage otherPage:m_pAnimationOtherPage otherPageOnRight:NO actionBarOnRight:NO];
		[self _triggerPageActivate:m_pCurrentPage];
	} else {
		[self _layoutWithActionBarPositionReferencePage:bAnimateActionBar ? m_pAnimationOtherPage : m_pCurrentPage centerPage:m_pCurrentPage otherPage:m_pAnimationOtherPage otherPageOnRight:NO actionBarOnRight:NO];
	}
	
	[UIView
		animateWithDuration:ANIMATION_DURATION
		delay:0.0
		options:UIViewAnimationOptionCurveLinear
		animations:^(void)
		{
			[self _layoutWithActionBarPositionReferencePage:m_pCurrentPage centerPage:m_pCurrentPage otherPage:m_pAnimationOtherPage otherPageOnRight:YES actionBarOnRight:bAnimateActionBar];
			[self _setupActionBarColorsForPage:m_pCurrentPage];
		}
		completion:^(BOOL finished)
		{
			[self _completeAnimations];
		}
	];
}

// Animation rules:
// - the page stack is always set at the beginning of the animation
// - the current view changes at the beginning of the animation


- (void)onBackButtonPressed
{
	if(!m_pCurrentPage)
		return;
	
	if(![m_pCurrentPage onPageBackButtonPressed])
		return;

	[self popCurrentPage];
}

- (void)imageButtonTapped:(STSImageButton *)pButton
{
	if(!pButton)
		return;
	
	if(pButton == m_pBackButton)
	{
		[self onBackButtonPressed];
		return;
	}

	if(![pButton isKindOfClass:[STSPageStackViewActionButton class]])
		return;
	
	STSPageStackViewActionButton * b = (STSPageStackViewActionButton *)pButton;
	
	STSPageStackAction * a = b.action;
	if(!a)
		return;
	
	if(!a.delegate)
		return;
	
	if(!a.enabled)
		return;
	
	[a.delegate onPageStackActionActivated:a];
}



@end
