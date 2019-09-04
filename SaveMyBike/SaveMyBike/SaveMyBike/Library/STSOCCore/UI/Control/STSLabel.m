//
//  STSLabel.m
//
//  Created by Szymon Tomasz Stefanek on 1/21/17.
//  Copyright © 2017 Szymon Tomasz Stefanek. All rights reserved.
//

#import "STSLabel.h"

@implementation STSLabel
{
	UIEdgeInsets m_oEdgeInsets;
}

- (id)init
{
	self = [super init];
	if (!self)
		return nil;
	[self _init];
	return self;
}

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (!self)
		return nil;
	[self _init];
	return self;
}

- (void)_init
{
	m_oEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)setLineBreakMode:(NSLineBreakMode)lbm
{
	[super setLineBreakMode:lbm];
	
	switch(lbm)
	{
		case NSLineBreakByCharWrapping:
		case NSLineBreakByWordWrapping:
			self.numberOfLines = 0;
			break;
		default:
			break;
	}
}


- (void)setMargins:(CGFloat)fAllMargins
{
	m_oEdgeInsets = UIEdgeInsetsMake(fAllMargins, fAllMargins, fAllMargins, fAllMargins);
	[self setNeedsLayout];
}

- (void)setMarginLeft:(CGFloat)fLeft top:(CGFloat)fTop right:(CGFloat)fRight bottom:(CGFloat)fBottom
{
	m_oEdgeInsets = UIEdgeInsetsMake(fTop,fLeft,fBottom,fRight);
	[self setNeedsLayout];
}


- (void)drawTextInRect:(CGRect)rect
{
	[super drawTextInRect:UIEdgeInsetsInsetRect(rect,m_oEdgeInsets)];
}

- (CGSize)intrinsicContentSize
{
	CGSize size = [super intrinsicContentSize];
	if(size.height <= 0)
		size.height = [@"X" sizeWithFont:self.font].height;
	size.width  += m_oEdgeInsets.left + m_oEdgeInsets.right;
	size.height += m_oEdgeInsets.top + m_oEdgeInsets.bottom;
	return size;
}

- (CGSize)sizeThatFits:(CGSize)size
{
	CGSize s = [super sizeThatFits:size];
	if(s.height <= 0)
		s.height = [@"X" sizeWithFont:self.font].height;
	s.width  += m_oEdgeInsets.left + m_oEdgeInsets.right;
	if(s.width > size.width)
		s.width = size.width;
	if(s.height > size.height)
		s.height = size.height;
	s.height += m_oEdgeInsets.top + m_oEdgeInsets.bottom;
	return s;
}

@end
