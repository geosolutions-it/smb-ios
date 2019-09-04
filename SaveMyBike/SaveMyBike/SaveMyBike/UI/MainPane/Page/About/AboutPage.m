//
//  Created by Szymon Tomasz Stefanek on 18/06/2019.
//  Copyright © 2019 GeoSolutions SaS. All rights reserved.
//

#import "AboutPage.h"

#import "STSPatchView.h"
#import "STSLabel.h"
#import "STSDisplay.h"
#import "STSI18N.h"
#import "STSImageView.h"
#import "GridPatch.h"

#import "Config.h"
#import "Globals.h"

@interface AboutPage()
{
	STSPatchView * m_pPatchView;
}

@end

@implementation AboutPage

- (id)init
{
	self = [super init];
	if(!self)
		return nil;
	
	STSDisplay * dpy = [STSDisplay instance];

	
	m_pPatchView = [STSPatchView new];
	
	[self addView:m_pPatchView row:0 column:0];
	
	[m_pPatchView setColumnCount:1];
	[m_pPatchView setMargin:[dpy centimetersToScreenUnits:0.2]];
	[m_pPatchView setSpacing:[dpy centimetersToScreenUnits:0.1]];

	STSImageView * pLogoView = [STSImageView new];;
	pLogoView.image = [UIImage imageNamed:@"goodgo_logo"];
	pLogoView.contentMode = UIViewContentModeScaleAspectFit;
	[m_pPatchView addView:pLogoView];
	//[m_pPatchView setView:pLogoView margins:[STSMargins marginsWithAllValues:[dpy centimetersToScreenUnits:0.3]]];

	STSLabel * l = [STSLabel new];
	l.textAlignment = NSTextAlignmentCenter;
	l.textColor = [Config instance].generalForegroundColor;
	l.lineBreakMode = NSLineBreakByWordWrapping;
	l.text = [NSString stringWithFormat:__trCtx(@"v %@ rel %@\n\nCopyright @ 2018 GeoSolutions SaS",@"AboutPage"),[Config instance].versionString,[Config instance].releaseDate];
	l.numberOfLines = 4;
	[m_pPatchView addView:l];
	//[m_pPatchView setView:pLogoView margins:[STSMargins marginsWithAllValues:[dpy centimetersToScreenUnits:0.3]]];

	pLogoView = [STSImageView new];
	pLogoView.image = [UIImage imageNamed:@"geosolutions_logo"];
	pLogoView.contentMode = UIViewContentModeScaleAspectFit;
	[m_pPatchView addView:pLogoView];

	self.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];

	return self;
}

@end
