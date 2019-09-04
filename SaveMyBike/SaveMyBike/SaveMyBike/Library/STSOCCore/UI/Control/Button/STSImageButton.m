//
//  STSImageButton.m
//  
//  Created by Szymon Tomasz Stefanek on 1/28/17.
//  Copyright © 2017 Szymon Tomasz Stefanek. All rights reserved.
//

#import "STSImageButton.h"

@implementation STSImageButton
{
	UIImageView * m_pImageView;
	UIImage * m_aImages[_STSButtonStateCount];
	UIColor * m_pBackgroundColors[_STSButtonStateCount];
	UIColor * m_pTintColors[_STSButtonStateCount];
	CGFloat m_aAlpha[_STSButtonStateCount];
	BOOL m_bEnabled;
	BOOL m_bPressed;
	BOOL m_bActive;
	BOOL m_bImageUsesTintColorAsTint;
	STSMargins * m_pMargins;
	__weak NSObject<STSImageButtonDelegate> * m_pDelegate;
}

- (id)init
{
	self = [super init];
	if (!self)
		return nil;
	[self _initImageButton];
	return self;
}

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (!self)
		return nil;
	[self _initImageButton];
	return self;
}

- (void)_initImageButton
{
	m_bEnabled = TRUE;
	m_bPressed = FALSE;
	m_bActive = FALSE;
	m_pDelegate = nil;
	m_bImageUsesTintColorAsTint = FALSE;
	m_pImageView = [UIImageView new];
	[self addSubview:m_pImageView];

	for(int i=0;i<_STSButtonStateCount;i++)
		m_aAlpha[i] = 1.0;

	m_pImageView.contentMode = UIViewContentModeScaleAspectFit;
	self.userInteractionEnabled = TRUE;
	m_pImageView.clipsToBounds = TRUE;

	[self setTheme:STSButtonThemeDefault];
}

- (void)layoutSubviews
{
	if(m_pMargins)
	{
		CGRect r = CGRectMake(
			m_pMargins.left,
			m_pMargins.top,
			self.bounds.size.width - m_pMargins.left - m_pMargins.right,
			self.bounds.size.height - m_pMargins.top - m_pMargins.bottom
		);
		m_pImageView.frame = r;
		return;
	}
	m_pImageView.frame = self.bounds;
}

- (void)setMargins:(STSMargins *)pMargins
{
	m_pMargins = pMargins;
	[self setNeedsLayout];
}

- (void)setDelegate:(__weak NSObject<STSImageButtonDelegate> *)pDelegate
{
	m_pDelegate = pDelegate;
}

- (void)setImage:(UIImage *)pImage forState:(STSButtonState)eState;
{
	if(m_bImageUsesTintColorAsTint)
		m_aImages[eState] = pImage ? [pImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] : nil;
	else
		m_aImages[eState] = pImage;
	[self _updateButtonState];
}

- (void)setBackgroundColor:(UIColor *)pColor forState:(STSButtonState)eState
{
	m_pBackgroundColors[eState] = pColor;
	[self _updateButtonState];
}

- (void)setTintColor:(UIColor *)pColor forState:(STSButtonState)eState
{
	m_pTintColors[eState] = pColor;
	[self _updateButtonState];
}

- (void)setAlpha:(CGFloat)a forState:(STSButtonState)eState
{
	m_aAlpha[eState] = a;
	[self _updateButtonState];
}

- (void)setTheme:(STSButtonTheme)eTheme
{
	for(int i=0;i<_STSButtonStateCount;i++)
	{
		m_pBackgroundColors[i] = [STSButtonThemeInfo backgroundColorForTheme:eTheme andState:(STSButtonState)i];
		m_pTintColors[i] = [STSButtonThemeInfo foregroundColorForTheme:eTheme andState:(STSButtonState)i];
		m_aAlpha[i] = 1.0; // all themes have alpha 1.0 for now
	}
	
	[self _updateButtonState];
	
}

- (void)setImageUsesTintColor:(BOOL)bUseIt
{
	if(m_bImageUsesTintColorAsTint == bUseIt)
		return;
	m_bImageUsesTintColorAsTint = bUseIt;
	if(m_bImageUsesTintColorAsTint)
	{
		for(int i=0;i<_STSButtonStateCount;i++)
		{
			if(!m_aImages[i])
				continue;
			if(m_aImages[i].renderingMode == UIImageRenderingModeAlwaysTemplate)
				continue;
			m_aImages[i] = [m_aImages[i] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
		}
	}
	[self _updateButtonState];
}

// WARNING: Do NOT rename this to "_updateState" as it collides with some function of UIImageView
- (void)_updateButtonState
{
	STSButtonState eState = STSButtonStateNormal;
	STSButtonState eFallbackState = STSButtonStateNormal;
	
	if(!m_bEnabled)
	{
		eState = STSButtonStateDisabled;
		eFallbackState = STSButtonStateNormal;
	} else if(m_bActive)
	{
		if(m_bPressed)
		{
			eState = STSButtonStateActivePressed;
			eFallbackState = STSButtonStatePressed;
		} else {
			eState = STSButtonStateActive;
			eFallbackState = STSButtonStateNormal;
		}
	} else if(m_bPressed)
	{
		eState = STSButtonStatePressed;
		eFallbackState = STSButtonStateNormal;
	}

	self.backgroundColor = m_pBackgroundColors[eState];
	if(m_bImageUsesTintColorAsTint)
	{
		m_pImageView.tintColor = m_pTintColors[eState];
	} else {
		m_pImageView.tintColor = nil;
	}
	self.alpha = m_aAlpha[eState];
	m_pImageView.image = m_aImages[eState] ? m_aImages[eState] : (m_aImages[eFallbackState] ? m_aImages[eFallbackState] : m_aImages[STSButtonStateNormal]);
}

- (void)setEnabled:(BOOL)bEnabled
{
	if(m_bEnabled == bEnabled)
		return;
	m_bEnabled = bEnabled;
	[self _updateButtonState];
}

- (void)setActive:(BOOL)bActive
{
	if(m_bActive == bActive)
		return;
	m_bActive = bActive;
	[self _updateButtonState];
}

- (BOOL)active
{
	return m_bActive;
}

- (void)toggleActive
{
	m_bActive = !m_bActive;
	[self _updateButtonState];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
	m_bPressed = TRUE;
	[self _updateButtonState];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
	m_bPressed = FALSE;
	[self _updateButtonState];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
	m_bPressed = FALSE;
	[self _updateButtonState];
	
	bool bInside = false;
	
	for(UITouch * t in touches.allObjects)
	{
		CGPoint p = [t locationInView:self];
		if(CGRectContainsPoint(self.bounds,p))
		{
			bInside = true;
			break;
		}
	}
	
	if(!bInside)
		return;
	
	[self onTapped];
	
	if(m_pDelegate && [m_pDelegate respondsToSelector:@selector(imageButtonTapped:)])
		[m_pDelegate imageButtonTapped:self];
}

- (void)onTapped
{
}

@end
