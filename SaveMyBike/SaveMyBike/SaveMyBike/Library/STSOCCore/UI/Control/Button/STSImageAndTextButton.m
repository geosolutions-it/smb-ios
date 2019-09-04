//
//  STSImageAndTextButton.m
//  
//  Created by Szymon Tomasz Stefanek on 2/8/17.
//  Copyright © 2017 Szymon Tomasz Stefanek. All rights reserved.
//

#import "STSImageAndTextButton.h"

#import "STSLabel.h"
#import "STSDisplay.h"
#import "STSCachedImageDownloader.h"
#import "STSRemoteImageView.h"

@implementation STSImageAndTextButton
{
	UIImage * m_aImages[_STSButtonStateCount];
	UIColor * m_pBackgroundColors[_STSButtonStateCount];
	UIColor * m_pTextColors[_STSButtonStateCount];
	UIImageView * m_pImageView;
	STSLabel * m_pLabel;
	STSLabel * m_pSecondaryLabel;
	BOOL m_bTextBelowImage;
	BOOL m_bEnabled;
	BOOL m_bPressed;
	BOOL m_bActive;
	BOOL m_bImageUsesTextColorAsTint;
	BOOL m_bImageVisible;
	BOOL m_bClickable;
	__weak NSObject<STSImageAndTextButtonDelegate> * m_pDelegate;
}

- (id)init
{
	self = [super init];
	if (!self)
		return nil;
	m_bTextBelowImage = false;
	[self _initInternal];
	return self;
}

- (id)initWithTextBelowImage
{
	self = [super init];
	if (!self)
		return nil;
	m_bTextBelowImage = true;
	[self _initInternal];
	return self;
}

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (!self)
		return nil;
	m_bTextBelowImage = false;
	[self _initInternal];
	return self;
}


- (void)_initInternal
{
	m_bClickable = TRUE;
	m_bEnabled = TRUE;
	m_bPressed = FALSE;
	m_bActive = FALSE;
	m_pDelegate = nil;
	m_bImageUsesTextColorAsTint = FALSE;
	m_bImageVisible = TRUE;
	
	m_pImageView = [UIImageView new];
	m_pImageView.contentMode = UIViewContentModeScaleAspectFit;
	m_pImageView.userInteractionEnabled = YES;
	m_pImageView.clipsToBounds = YES;
	[self addView:m_pImageView row:0 column:0];

	//m_pImageView.backgroundColor = [UIColor redColor];
	
	m_pLabel = [STSLabel new];
	m_pLabel.userInteractionEnabled = YES;
	if(m_bTextBelowImage)
	{
		m_pLabel.textAlignment = NSTextAlignmentCenter;
		[self addView:m_pLabel row:1 column:0];
	} else {
		m_pLabel.textAlignment = NSTextAlignmentLeft;
		[self addView:m_pLabel row:0 column:1];
	}

	STSDisplay * dpy = [STSDisplay instance];
	
	[self setSpacing:[dpy millimetersToScreenUnits:1.0]];
	[self setMargin:[dpy millimetersToScreenUnits:1.0]];

	if(!m_bTextBelowImage)
	{
		[self setColumn:1 minimumWidth:[dpy millimetersToScreenUnits:7.0]];
		[self setColumn:0 fixedWidth:[dpy millimetersToScreenUnits:7.0]];
	}

	[self setRow:0 fixedHeight:[dpy millimetersToScreenUnits:7.0]];
	
	[self setTheme:STSButtonThemeDefault];
	
	self.userInteractionEnabled = TRUE;
	
	_imageView = m_pImageView;
	_label = m_pLabel;
}

- (void)_resetConstraints
{
}

- (void)setImageVisible:(BOOL)bVisible
{
	if(m_bImageVisible == bVisible)
		return;
	m_bImageVisible = bVisible;
	if(m_bImageVisible)
	{
		[self addView:m_pImageView row:0 column:0];
		[self setSpacing:[[STSDisplay instance] millimetersToScreenUnits:1.0]];
		[self setColumn:0 fixedWidth:[[STSDisplay instance] millimetersToScreenUnits:7.0]];
	} else {
		[self removeView:m_pImageView];
		[self setColumn:0 fixedWidth:0];
		[self setSpacing:0];
	}
	[self setNeedsLayout];
}

- (void)setImageViewMargins:(STSMargins *)pMargins
{
	[self setView:_imageView margins:pMargins];
}

- (void)setLabelMargins:(STSMargins *)pMargins
{
	[self setView:_label margins:pMargins];
}

- (NSString *)text
{
	return m_pLabel.text;
}

- (void)setText:(NSString *)szText
{
	m_pLabel.text = szText;
}

- (void)setSecondaryText:(NSString *)szSecondaryText
{
	if(!m_pSecondaryLabel)
	{
		m_pSecondaryLabel = [STSLabel new];
		[self addView:m_pSecondaryLabel row:1 column:1];
		[self _updateState];
	}
	
	m_pSecondaryLabel.text = szSecondaryText;
}

- (void)setImageUsesTextColorAsTint:(BOOL)bUseIt
{
	if(m_bImageUsesTextColorAsTint == bUseIt)
		return;
	m_bImageUsesTextColorAsTint = bUseIt;
	[self _updateState];
}


- (void)setDelegate:(__weak NSObject<STSImageAndTextButtonDelegate> *)pDelegate
{
	m_pDelegate = pDelegate;
}

- (void)setImage:(UIImage *)pImage forState:(STSButtonState)eState;
{
	if(m_bImageUsesTextColorAsTint)
		m_aImages[eState] = pImage ? [pImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] : nil;
	else
		m_aImages[eState] = pImage;
	[self _updateState];
}

- (void)setBackgroundColor:(UIColor *)pColor forState:(STSButtonState)eState
{
	m_pBackgroundColors[eState] = pColor;
	[self _updateState];
}

- (void)setTextColor:(UIColor *)pColor forState:(STSButtonState)eState
{
	m_pTextColors[eState] = pColor;
	[self _updateState];
}

- (void)_updateState
{
	STSButtonState eState = STSButtonStateNormal;
	STSButtonState eFallbackState = STSButtonStateNormal;
	
	CGFloat a = 1.0;
	
	if(!m_bEnabled)
	{
		eState = STSButtonStateDisabled;
		eFallbackState = STSButtonStateNormal;
		a = 0.6;
	} else if(m_bActive)
	{
		if(m_bPressed)
		{
			eState = STSButtonStateActivePressed;
			eFallbackState = STSButtonStatePressed;
			a = 0.5;
		} else {
			eState = STSButtonStateActive;
			eFallbackState = STSButtonStateNormal;
		}
	} else if(m_bPressed)
	{
		eState = STSButtonStatePressed;
		eFallbackState = STSButtonStateNormal;
		a = 0.5;
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
		m_pLabel.textColor = pText;
		if(m_pSecondaryLabel)
			m_pSecondaryLabel.textColor = pText;
		if(self.layer.borderWidth > 0.0)
			self.layer.borderColor = [pText CGColor];

	}

	m_pImageView.image = m_aImages[eState] ? m_aImages[eState] : (m_aImages[eFallbackState] ? m_aImages[eFallbackState] : m_aImages[STSButtonStateNormal]);

	if(m_pImageView.image)
	{
		if(m_bImageUsesTextColorAsTint)
		{
			m_pImageView.tintColor = pText;
			self.alpha = 1;
		} else {
			m_pImageView.tintColor = nil;
			self.alpha = a;
		}
	} else {
		// alpha?
		self.alpha = a;
	}
}

- (void)setTheme:(STSButtonTheme)eTheme
{
	for(int i=0;i<_STSButtonStateCount;i++)
	{
		m_pBackgroundColors[i] = [STSButtonThemeInfo backgroundColorForTheme:eTheme andState:(STSButtonState)i];
		m_pTextColors[i] = [STSButtonThemeInfo foregroundColorForTheme:eTheme andState:(STSButtonState)i];
	}
	
	[self _updateState];
}

- (void)setClickable:(BOOL)bClickable
{
	m_bClickable = bClickable;
}


- (void)setEnabled:(BOOL)bEnabled
{
	if(m_bEnabled == bEnabled)
		return;
	m_bEnabled = bEnabled;
	[self _updateState];
}

- (void)setActive:(BOOL)bActive
{
	if(m_bActive == bActive)
		return;
	m_bActive = bActive;
	[self _updateState];
}

- (void)toggleActive
{
	m_bActive = !m_bActive;
	[self _updateState];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
	if(!m_bClickable)
		return;
	m_bPressed = TRUE;
	[self _updateState];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
	if(!m_bClickable)
		return;
	m_bPressed = FALSE;
	[self _updateState];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
	if(!m_bClickable)
		return;
	m_bPressed = FALSE;
	[self _updateState];
	if(m_pDelegate && [m_pDelegate respondsToSelector:@selector(imageAndTextButtonTapped:)])
		[m_pDelegate imageAndTextButtonTapped:self];
}

@end
