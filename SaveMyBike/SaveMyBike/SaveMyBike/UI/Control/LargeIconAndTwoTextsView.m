//
//  LargeIconAndTwoTextsView.m
//  SaveMyBike
//
//  Created by Szymon Tomasz Stefanek on 08/07/2019.
//  Copyright © 2019 GeoSolutions SaS. All rights reserved.
//

#import "LargeIconAndTwoTextsView.h"

#import "STSImageView.h"
#import "STSLabel.h"
#import "STSDisplay.h"

#import "Config.h"

@interface LargeIconAndTwoTextsView()
{
	STSImageView * m_pIconView;
	STSLabel * m_pShortTextLabel;
	STSLabel * m_pLongTextLabel;
}

@end

@implementation LargeIconAndTwoTextsView

- (id)initWithIcon:(NSString *)sIcon shortText:(NSString *)sShortText longText:(NSString *)sLongText
{
	self = [super init];
	if(!self)
		return nil;
	
	STSDisplay * dpy = [STSDisplay instance];
	
	m_pIconView = [STSImageView new];
	[m_pIconView setTintColor:[UIColor lightGrayColor]];
	m_pIconView.contentMode = UIViewContentModeScaleAspectFit;
	
	[self addView:m_pIconView row:1 column:0];
	
	m_pShortTextLabel = [STSLabel new];
	m_pShortTextLabel.textAlignment = NSTextAlignmentCenter;
	m_pShortTextLabel.font = [UIFont boldSystemFontOfSize:m_pShortTextLabel.font.pointSize];
	m_pShortTextLabel.textColor = [UIColor lightGrayColor];
	
	[self addView:m_pShortTextLabel row:2 column:0 verticalSizePolicy:STSSizePolicyCanExpand horizontalSizePolicy:STSSizePolicyIgnore];
	
	m_pLongTextLabel = [STSLabel new];
	m_pLongTextLabel.textAlignment = NSTextAlignmentCenter;
	m_pLongTextLabel.textColor = [UIColor lightGrayColor];
	m_pLongTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
	
	[self addView:m_pLongTextLabel row:3 column:0 verticalSizePolicy:STSSizePolicyCanExpand horizontalSizePolicy:STSSizePolicyIgnore];
	
	[self setRow:0 minimumHeight:[dpy centimetersToScreenUnits:1.0]];
	[self setRow:0 expandWeight:600];

	[self setRow:1 fixedHeight:[dpy centimetersToScreenUnits:1.8]];
	 /*
	[self setRow:2 minimumHeightPercent:0.1];
	[self setRow:3 minimumHeightPercent:0.25];
	*/
	[self setRow:3 expandWeight:1000];
	
	[self setMargin:[dpy centimetersToScreenUnits:0.5]];
	[self setSpacing:[dpy centimetersToScreenUnits:0.2]];

	self.backgroundColor = [Config instance].generalBackgroundColor;
	
	[self setIcon:sIcon shortText:sShortText longText:sLongText];
	
	return self;
}

- (void)setIcon:(NSString *)sIcon shortText:(NSString *)sShortText longText:(NSString *)sLongText
{
	m_pIconView.image = [[UIImage imageNamed:sIcon] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
	m_pShortTextLabel.text = sShortText;
	m_pLongTextLabel.text = sLongText;
}


@end
