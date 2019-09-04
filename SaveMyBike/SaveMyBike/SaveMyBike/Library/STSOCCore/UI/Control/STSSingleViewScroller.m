//
//  STSSingleViewScroller.m
//
//  Created by Szymon Tomasz Stefanek on 2/26/17.
//  Copyright © 2017 Szymon Tomasz Stefanek. All rights reserved.
//

#import "STSSingleViewScroller.h"

@interface STSSingleViewScroller()
{
	UIView * m_pView;
	CGSize m_sLastLayoutSize;
	BOOL m_bFillViewport;
}

@end

@implementation STSSingleViewScroller

- (id)init
{
	self = [super init];
	if(!self)
		return nil;
	[self _initSingleViewScroller];
	return self;
}

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if(!self)
		return nil;
	[self _initSingleViewScroller];
	return self;
}

- (void)_initSingleViewScroller
{
	m_sLastLayoutSize = CGSizeMake(-1, -1);
	m_bFillViewport = false;
}

- (void)setView:(UIView *)pView
{
	m_pView = pView;
	[self addSubview:pView];
	[self setNeedsLayout];
}

- (void)setFillViewport:(BOOL)bFillViewport
{
	if(m_bFillViewport == bFillViewport)
		return;
	m_bFillViewport = bFillViewport;
	[self setNeedsLayout];
}

- (void)setNeedsLayout
{
	m_sLastLayoutSize = CGSizeMake(-1, -1);
	[super setNeedsLayout];
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	if(!m_pView)
		return;

	CGSize s = self.frame.size;
	if((s.width == m_sLastLayoutSize.width) && (s.height == m_sLastLayoutSize.height))
		return;

	m_sLastLayoutSize = s;
	
	CGSize b;
	
	if([[m_pView class] isSubclassOfClass:[UILabel class]])
	{
		CGRect r = m_pView.frame;
		r.size.width = s.width;
		r.size.height = s.height;
		m_pView.frame = r;
		[m_pView sizeToFit];
		b = m_pView.frame.size;
	} else {
		b = [m_pView sizeThatFits:s];
	}
	
	if(m_bFillViewport)
	{
		if(b.width < s.width)
			b.width = s.width;
		if(b.height < s.height)
			b.height = s.height;
	}
	
	m_pView.frame = CGRectMake(0,0,b.width,b.height);
	
	self.contentSize = b;
}

@end
