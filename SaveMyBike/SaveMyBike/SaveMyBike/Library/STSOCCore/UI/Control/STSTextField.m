//
//  STSTextField.m
//  
//  Created by Szymon Tomasz Stefanek on 1/28/17.
//  Copyright © 2017 Szymon Tomasz Stefanek. All rights reserved.
//

#import "STSTextField.h"

@implementation STSTextField
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

- (void)setMargins:(CGFloat)fAllMargins
{
	m_oEdgeInsets = UIEdgeInsetsMake(fAllMargins, fAllMargins, fAllMargins, fAllMargins);
}

- (void)setMarginLeft:(CGFloat)l top:(CGFloat)t right:(CGFloat)r bottom:(CGFloat)b
{
	m_oEdgeInsets = UIEdgeInsetsMake(t,l,b,r);
}

- (CGRect)textRectForBounds:(CGRect)bounds
{
	if(self.rightView)
		bounds = CGRectMake(bounds.origin.x,bounds.origin.y,bounds.size.width - self.rightView.bounds.size.width,bounds.size.height);
	if(self.leftView)
		bounds = CGRectMake(bounds.origin.x + self.leftView.bounds.size.width,bounds.origin.y,bounds.size.width - self.leftView.bounds.size.width,bounds.size.height);
	return UIEdgeInsetsInsetRect(bounds,m_oEdgeInsets);
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds
{
	if(self.rightView)
		bounds = CGRectMake(bounds.origin.x,bounds.origin.y,bounds.size.width - self.rightView.bounds.size.width,bounds.size.height);
	if(self.leftView)
		bounds = CGRectMake(bounds.origin.x + self.leftView.bounds.size.width,bounds.origin.y,bounds.size.width - self.leftView.bounds.size.width,bounds.size.height);
	return UIEdgeInsetsInsetRect(bounds,m_oEdgeInsets);
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
	if(self.rightView)
		bounds = CGRectMake(bounds.origin.x,bounds.origin.y,bounds.size.width - self.rightView.bounds.size.width,bounds.size.height);
	if(self.leftView)
		bounds = CGRectMake(bounds.origin.x + self.leftView.bounds.size.width,bounds.origin.y,bounds.size.width - self.leftView.bounds.size.width,bounds.size.height);
	return UIEdgeInsetsInsetRect(bounds,m_oEdgeInsets);
}

@end
