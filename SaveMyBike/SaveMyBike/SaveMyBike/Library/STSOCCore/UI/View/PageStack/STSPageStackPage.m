//
//  STSPageStackPage.m
//  
//  Created by Szymon Tomasz Stefanek on 2/18/17.
//  Copyright © 2017 Szymon Tomasz Stefanek. All rights reserved.
//

#import "STSPageStackPage.h"

@interface STSPageStackPage()
{
	NSMutableArray<STSPageStackAction *> * m_pLeftActions;
	NSMutableArray<STSPageStackAction *> * m_pRightActions;
}
@end

@implementation STSPageStackPage

- (id)init
{
	self = [super init];
	if(!self)
		return nil;
	[self _pageStackPageInit];
	return self;
}

- (id)initWithFrame:(CGRect)rFrame
{
	self = [super initWithFrame:rFrame];
	if(!self)
		return nil;
	[self _pageStackPageInit];
	return self;
}

- (void)_pageStackPageInit
{
	_actionBarMode = STSPageStackActionBarModeVisible;
	_inOutAnimationSideX = 1.0;
	_inOutAnimationSideY = 0.0;
	m_pLeftActions = nil;
	m_pRightActions = nil;
}

- (void)addLeftAction:(STSPageStackAction *)pAction
{
	if(!m_pLeftActions)
		m_pLeftActions = [NSMutableArray new];
	[m_pLeftActions addObject:pAction];
}

- (void)addRightAction:(STSPageStackAction *)pAction
{
	if(!m_pRightActions)
		m_pRightActions = [NSMutableArray new];
	[m_pRightActions addObject:pAction];
}

- (NSArray<STSPageStackAction *> *)leftActions
{
	return m_pLeftActions;
}

- (NSArray<STSPageStackAction *> *)rightActions
{
	return m_pRightActions;
}

- (void)onPageAttach
{
}

- (void)onPageActivate
{
}

- (void)onPageDeactivate
{
}

- (void)onPageDetach
{
}

- (bool)onPageBackButtonPressed
{
	return TRUE;
}

- (void)_internalSetPageStackView:(STSPageStackView *)pPageStackView
{
	_pageStackView = pPageStackView;
}

@end
