//
//  HomePage.m
//  SaveMyBike
//
//  Created by Szymon Tomasz Stefanek on 1/6/19.
//  Copyright © 2019 GeoSolutions SaS. All rights reserved.
//

#import "HomePage.h"

#import "STSTextButton.h"
#import "STSImageButton.h"
#import "STSPatchView.h"

#import "STSDisplay.h"
#import "STSI18N.h"
#import "STSImageView.h"
#import "STSLabel.h"
#import "HomePagePatch.h"

#import "MainView.h"
#import "Config.h"
#import "Settings.h"

@interface HomePage()<STSTextButtonDelegate,STSImageButtonDelegate>
{
	STSPatchView * m_pPatchView;
}

@end

@implementation HomePage

- (id)init
{
	self = [super init];
	if(!self)
		return nil;

	STSDisplay * dpy = [STSDisplay instance];
	
	STSImageView * bck = [STSImageView new];
	bck.contentMode = UIViewContentModeScaleAspectFill;
	bck.image = [UIImage imageNamed:@"header_background"];
	bck.clipsToBounds = true;
	
	[self addView:bck row:0 column:0];
	
	STSLabel * lbl = [STSLabel new];
	lbl.font = [UIFont boldSystemFontOfSize:[dpy centimetersToFontUnits:0.6]];
	lbl.textAlignment = NSTextAlignmentCenter;
	lbl.text = __trCtx(@"Welcome",@"HomePage");

	[self addView:lbl row:0 column:0];

	[self setRow:0 fixedHeight:[dpy centimetersToScreenUnits:0.8]];
	
	m_pPatchView = [STSPatchView new];
	
	[self addView:m_pPatchView row:1 column:0];
	
	[m_pPatchView setColumnCount:2];
	[m_pPatchView setMargin:[dpy centimetersToScreenUnits:0.2]];
	[m_pPatchView setSpacing:[dpy centimetersToScreenUnits:0.1]];
	
	[self _createPatchWithIcon:@"section_icon_prizes" title:__trCtx(@"Prizes",@"HomePage") info:__trCtx(@"Compete with\nother users",@"HomePage") target:@"prizes" forceAllColumns:false bottomRowCount:2];
	[self _createPatchWithIcon:@"section_icon_tracks" title:__trCtx(@"Tracks",@"HomePage") info:__trCtx(@"Check your tracks\n",@"HomePage") target:@"tracks" forceAllColumns:false bottomRowCount:2];
	[self _createPatchWithIcon:@"section_icon_badges" title:__trCtx(@"Badges",@"HomePage") info:__trCtx(@"See your badges\n",@"HomePage") target:@"badges" forceAllColumns:false bottomRowCount:2];
	[self _createPatchWithIcon:@"section_icon_bikes" title:__trCtx(@"Bikes",@"HomePage") info:__trCtx(@"Manage your bikes\n",@"HomePage") target:@"bikes" forceAllColumns:false bottomRowCount:2];
	[self _createPatchWithIcon:@"section_icon_record" title:__trCtx(@"Record",@"HomePage") info:__trCtx(@"Record a new track\n",@"HomePage") target:@"tracks/record" forceAllColumns:true bottomRowCount:1];

	[self setRow:1 expandWeight:1000];
	
	self.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
	
	return self;
}

- (HomePagePatch *)_createPatchWithIcon:(NSString *)sIcon title:(NSString *)sTitle info:(NSString *)sInfo target:(NSString *)sTarget forceAllColumns:(BOOL)bForceAllColumns bottomRowCount:(int)iRowCount
{
	HomePagePatch * hpp = [[HomePagePatch alloc] initWithIcon:sIcon title:sTitle info:sInfo target:sTarget bottomRowCount:iRowCount];
	if(bForceAllColumns)
		[m_pPatchView addView:hpp withFlags:STSPatchViewPatchSpansAllColumns];
	else
		[m_pPatchView addView:hpp];
	return hpp;
}


@end
