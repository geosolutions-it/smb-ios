//
//  STSViewStack.m
//
//  Created by Szymon Tomasz Stefanek on 12/27/17.
//  Copyright © 2017 Szymon Tomasz Stefanek. All rights reserved.
//

#import "STSViewStack.h"

#import "STSCore.h"

@interface STSViewStack()
{
	NSMutableArray<UIView *> * m_pViews;
	UIView * m_pCurrentView;
	int m_iCurrentView;
}

@end

@implementation STSViewStack

- (id)init
{
	self = [super init];
	if(!self)
		return nil;
	
	m_pViews = [NSMutableArray new];
	m_iCurrentView = -1;
	
	return self;
}

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if(!self)
		return nil;
	
	m_pViews = [NSMutableArray new];

	return self;
}

- (NSMutableArray<UIView *> *)views
{
	return m_pViews;
}

- (void)addView:(UIView *)pView
{
	[self addSubview:pView];
	[m_pViews addObject:pView];
}

- (void)removeView:(UIView *)pView
{
	[m_pViews removeObject:pView];
	[pView removeFromSuperview];
	
	if(pView == m_pCurrentView)
	{
		if(m_pViews.count > 0)
		{
			m_pCurrentView = [m_pViews objectAtIndex:0];
			m_iCurrentView = 0;
		} else {
			m_pCurrentView = nil;
			m_iCurrentView = -1;
		}
	}
}

- (int)viewCount
{
	return (int)m_pViews.count;
}

- (UIView *)viewAtIndex:(int)iIdx
{
	if(iIdx < 0)
		return nil;
	if(iIdx >= m_pViews.count)
		return nil;
	return [m_pViews objectAtIndex:iIdx];
}

- (UIView *)currentView
{
	return m_pCurrentView;
}

- (int)currentIndex
{
	return m_iCurrentView;
}

- (void)layoutSubviews
{
	if(!m_pCurrentView)
		return;
	m_pCurrentView.frame = self.bounds;
}

- (void)didMoveToWindow
{
	if((!self.window) && m_pCurrentView)
		[self setCurrentView:nil];
}

- (void)_activateView:(UIView *)pView
{
	for(UIView * v in m_pViews)
	{
		if(v == pView)
		{
			v.frame = self.bounds;
			v.hidden = false;
		} else {
			v.hidden = true;
		}
	}
}

- (void)setCurrentView:(UIView *)pView
{
	if(m_pCurrentView == pView)
		return;
	
	if(m_pCurrentView)
	{
		if([m_pCurrentView conformsToProtocol:@protocol(STSViewStackView)])
		{
			if([m_pCurrentView respondsToSelector:@selector(onDeactivate)])
			{
				id<STSViewStackView> p = (id<STSViewStackView>)m_pCurrentView;
				[p onDeactivate];
			}
		}
	}
	
	NSUInteger uCrap = [m_pViews indexOfObject:pView];
	if(uCrap == NSNotFound)
	{
		STS_CORE_LOG_ERROR(@"Trying to set view %x as current, but the view is not in the stack",(unsigned int)pView);
		return; // BUG!
	}
	
	m_pCurrentView = pView;
	m_iCurrentView = (int)uCrap;
	
	[self _activateView:m_pCurrentView];

	if(m_pCurrentView)
	{
		if([m_pCurrentView conformsToProtocol:@protocol(STSViewStackView)])
		{
			if([m_pCurrentView respondsToSelector:@selector(onActivate)])
			{
				id<STSViewStackView> p = (id<STSViewStackView>)m_pCurrentView;
				[p onActivate];
			}
		}
	}
}

- (void)setCurrentIndex:(int)iIdx
{
	if(iIdx < 0)
		return;
	if(iIdx >= m_pViews.count)
		return;
	
	UIView * pView = [m_pViews objectAtIndex:iIdx];
	[self setCurrentView:pView];
}

- (CGSize)intrinsicContentSize
{
	CGSize s = CGSizeMake(0, 0);
	
	for(UIView * v in m_pViews)
	{
		CGSize ss = [v intrinsicContentSize];
		if(ss.width > s.width)
			s.width = ss.width;
		if(ss.height > s.height)
			s.height = ss.height;
	}
	
	return s;
}

- (CGSize)sizeThatFits:(CGSize)size
{
	CGSize s = CGSizeMake(0, 0);
	
	for(UIView * v in m_pViews)
	{
		CGSize ss = [v sizeThatFits:size];
		if(ss.width > s.width)
			s.width = ss.width;
		if(ss.height > s.height)
			s.height = ss.height;
	}
	
	return s;
}

@end
