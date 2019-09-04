//
//  STSTextButton.m
//  
//  Created by Szymon Tomasz Stefanek on 1/31/17.
//  Copyright © 2017 Szymon Tomasz Stefanek. All rights reserved.
//

#import "STSTextButton.h"
#import "STSDisplay.h"

@implementation STSTextButton
{
	UIColor * m_pBackgroundColors[_STSButtonStateCount];
	UIColor * m_pTextColors[_STSButtonStateCount];
	BOOL m_bEnabled;
	BOOL m_bPressed;
	BOOL m_bActive;
	__weak NSObject<STSTextButtonDelegate> * m_pDelegate;
}

- (id)init
{
	self = [super init];
	if (!self)
		return nil;
	[self _initTextButton];
	return self;
}

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (!self)
		return nil;
	[self _initTextButton];
	return self;
}

- (void)_initTextButton
{
	m_bEnabled = TRUE;
	m_bPressed = FALSE;
	m_pDelegate = nil;
	[self setTheme:STSButtonThemeDefault];
	STSDisplay * dpy = [STSDisplay instance];
	double vm = [dpy centimetersToScreenUnits:0.1];
	double hm = [dpy centimetersToScreenUnits:0.2];
	[self setMarginLeft:hm top:vm right:hm bottom:vm];
	self.textAlignment = NSTextAlignmentCenter;
	self.layer.masksToBounds = YES;
	self.userInteractionEnabled = TRUE;
}

- (void)setTheme:(STSButtonTheme)eTheme
{
	for(int i=0;i<_STSButtonStateCount;i++)
	{
		m_pBackgroundColors[i] = [STSButtonThemeInfo backgroundColorForTheme:eTheme andState:(STSButtonState)i];
		m_pTextColors[i] = [STSButtonThemeInfo foregroundColorForTheme:eTheme andState:(STSButtonState)i];
	}
	
	[self _updateColors];
}

- (void)setDelegate:(__weak NSObject<STSTextButtonDelegate> *)pDelegate
{
	m_pDelegate = pDelegate;
}

- (void)setBackgroundColor:(UIColor *)pColor forState:(STSButtonState)eState
{
	m_pBackgroundColors[eState] = pColor;
	[self _updateColors];
}

- (void)setTextColor:(UIColor *)pColor forState:(STSButtonState)eState
{
	m_pTextColors[eState] = pColor;
	[self _updateColors];
}

- (void)_updateColors
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

	UIColor * pBackground = nil;
	if(m_pBackgroundColors[eState])
		pBackground = m_pBackgroundColors[eState];
	else if(m_pBackgroundColors[eFallbackState])
		pBackground = m_pBackgroundColors[eFallbackState];
	else if(m_pBackgroundColors[STSButtonStateNormal])
		pBackground = m_pBackgroundColors[STSButtonStateNormal];
	
	if(pBackground)
		self.backgroundColor = pBackground;

	UIColor * pText = nil;
	if(m_pTextColors[eState])
		pText = m_pTextColors[eState];
	else if(m_pTextColors[eFallbackState])
		pText = m_pTextColors[eFallbackState];
	else if(m_pTextColors[STSButtonStateNormal])
		pText = m_pTextColors[STSButtonStateNormal];
	
	if(pText)
	{
		self.textColor = pText;
		if(self.layer.borderWidth > 0.0)
			self.layer.borderColor = [pText CGColor];
	}
}

- (void)setEnabled:(BOOL)bEnabled
{
	if(m_bEnabled == bEnabled)
		return;
	m_bEnabled = bEnabled;
	[self _updateColors];
}

- (void)setActive:(BOOL)bActive
{
	if(m_bActive == bActive)
		return;
	m_bActive = bActive;
	[self _updateColors];
}

- (void)toggleActive
{
	m_bActive = !m_bActive;
	[self _updateColors];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
	if(!m_bEnabled)
		return;
	m_bPressed = TRUE;
	[self _updateColors];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
	if(!m_bEnabled)
		return;
	m_bPressed = FALSE;
	[self _updateColors];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
	if(!m_bEnabled)
		return;
	m_bPressed = FALSE;
	[self _updateColors];

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

	if(m_pDelegate && [m_pDelegate respondsToSelector:@selector(textButtonTapped:)])
		[m_pDelegate textButtonTapped:self];
}


@end
