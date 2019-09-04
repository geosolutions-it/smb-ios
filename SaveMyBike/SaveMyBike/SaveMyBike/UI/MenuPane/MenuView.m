//
//  Created by Szymon Tomasz Stefanek on 20/06/2019.
//  Copyright © 2019 GeoSolutions SaS. All rights reserved.
//

#import "MenuView.h"

#import "STSGridLayoutView.h"
#import "STSImageView.h"
#import "STSLabel.h"
#import "STSImageAndTextButton.h"
#import "STSDisplay.h"
#import "STSI18N.h"
#import "UIColorUtilities.h"
#import "MainView.h"
#import "AuthManager.h"
#import "Globals.h"
#import "Config.h"
#import "NotificationManager.h"

static MenuView * g_pMenuView = nil;

@interface MenuView()<STSImageAndTextButtonDelegate>
{
	STSLabel * m_pNameLabel;
	STSLabel * m_pEMailLabel;
}

@end

@implementation MenuView

- (id)init
{
	self = [super init];
	if(!self)
		return nil;

	g_pMenuView = self;
	
	STSDisplay * dpy = [STSDisplay instance];
	
	STSGridLayoutView * topGrid = [STSGridLayoutView new];
	UIGestureRecognizer * gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTopGridTap:)];
	[topGrid addGestureRecognizer:gr];
	
	STSImageView * topHeader = [STSImageView new];
	topHeader.contentMode = UIViewContentModeScaleAspectFill;
	topHeader.image = [UIImage imageNamed:@"header_background"];
	topHeader.clipsToBounds = true;
	
	[topGrid addView:topHeader row:0 column:0 rowSpan:4 columnSpan:3];


	m_pNameLabel = [STSLabel new];
	m_pNameLabel.text = @"NAME";
	m_pNameLabel.textColor = [UIColor whiteColor];
	[topGrid addView:m_pNameLabel row:1 column:1];

	m_pEMailLabel = [STSLabel new];
	m_pEMailLabel.text = @"name@email";
	m_pEMailLabel.textColor = [[UIColor whiteColor] withAlpha:128];
	[topGrid addView:m_pEMailLabel row:2 column:1];

	[topGrid setRow:0 expandWeight:1000];
	[topGrid setRow:3 fixedHeight:[dpy centimetersToScreenUnits:0.1]];
	[topGrid setColumn:0 fixedWidth:[dpy centimetersToScreenUnits:0.1]];
	[topGrid setColumn:2 fixedWidth:[dpy centimetersToScreenUnits:0.1]];
	
	[self addView:topGrid row:0 column:0 verticalSizePolicy:STSSizePolicyIgnore horizontalSizePolicy:STSSizePolicyIgnore];
	[self setRow:0 fixedHeight:[dpy majorScreenDimensionFractionToScreenUnits:0.2]];
	//[self setRow:0 fixedHeight:[dpy centimetersToScreenUnits:1.0]];
	
	///////////////////////

	[self setRow:1 fixedHeight:[dpy centimetersToScreenUnits:0.1]];
	
	///////////////////////

	[self _addButtonWithId:@"home" text:__trCtx(@"Home",@"MenuView") inRow:2];
	[self _addButtonWithId:@"record" text:__trCtx(@"Record",@"MenuView") inRow:3];
	[self _addButtonWithId:@"stats" text:__trCtx(@"Stats",@"MenuView") inRow:4];
	[self _addButtonWithId:@"bikes" text:__trCtx(@"Bikes",@"MenuView") inRow:5];
	[self _addButtonWithId:@"badges" text:__trCtx(@"Badges",@"MenuView") inRow:6];
	[self _addButtonWithId:@"trophy" text:__trCtx(@"Prizes",@"MenuView") inRow:7];
	[self _addButtonWithId:@"about" text:__trCtx(@"About",@"MenuView") inRow:8];

	///////////////////////
	
	UIView * sep = [UIView new];
	sep.backgroundColor = [[Config instance].generalForegroundColor withAlpha:127];
	[self addView:sep row:9 column:0];
	[self setRow:9 fixedHeight:1];

	///////////////////////

	// Quit is forbidden by apple policies
	//[self _addButtonWithId:@"quit" text:__trCtx(@"Quit",@"MenuView") inRow:10];
	[self _addButtonWithId:@"sign_out" text:__trCtx(@"Sign Out",@"MenuView") inRow:10];

	///////////////////////
	
	sep = [UIView new];
	sep.backgroundColor = [[Config instance].generalForegroundColor withAlpha:127];
	[self addView:sep row:11 column:0];
	[self setRow:11 fixedHeight:1];
	
	///////////////////////

	STSGridLayoutView * versionGrid = [STSGridLayoutView new];
	
	STSLabel * version = [STSLabel new];
	version.text = [NSString stringWithFormat:@"v %@ rel %@",[Config instance].versionString,[Config instance].releaseDate];
	version.textColor = [[Config instance].generalForegroundColor withAlpha:127];
	
	[versionGrid addView:version row:0 column:0];
	[versionGrid setMargin:[dpy centimetersToScreenUnits:0.2]];
	
	[self addView:versionGrid row:12 column:0];
	
	///////////////////////

	[self setRow:13 expandWeight:1000];
	
	///////////////////////

	
	self.backgroundColor = [UIColor whiteColor];
	
	return self;
}

+ (MenuView *)instance
{
	return g_pMenuView;
}

- (void)onTopGridTap:(id)sender
{
	[[MainView instance] switchToProfilePage];
}

- (void)userInfoUpdated
{
	if([Globals instance].userData.firstName)
	{
		if([Globals instance].userData.lastName)
			m_pNameLabel.text = [NSString stringWithFormat:@"%@ %@",[Globals instance].userData.firstName,[Globals instance].userData.lastName];
		else
			m_pNameLabel.text = [Globals instance].userData.firstName;
	} else {
		m_pNameLabel.text = [Globals instance].userData.nickName ? [Globals instance].userData.nickName : @"?";
	}
	
	m_pEMailLabel.text = [Globals instance].userData.email;	
}

- (STSImageAndTextButton *)_addButtonWithId:(NSString *)sId text:(NSString *)sText inRow:(int)iRow
{
	STSImageAndTextButton * b = [STSImageAndTextButton new];
	
	NSString * sIcon = [NSString stringWithFormat:@"drawer_icon_%@",sId];
	
	[b setImageUsesTextColorAsTint:true];
	[b setTheme:STSButtonThemeWhiteBackgroundGrayForeground];
	[b setText:sText];
	[b setTextColor:[Config instance].generalForegroundColor forState:STSButtonStateNormal];
	[b setTextColor:[Config instance].highlight1Color forState:STSButtonStateActive];
	[b setTextColor:[Config instance].generalBackgroundColor forState:STSButtonStatePressed];
	[b setImage:[UIImage imageNamed:sIcon] forState:STSButtonStateNormal];
	[b setMargin:[[STSDisplay instance] centimetersToScreenUnits:0.1]];
	[b setDelegate:self];
	b.payload = sId;
	
	[self addView:b row:iRow column:0];

	return b;
}

- (void)imageAndTextButtonTapped:(STSImageAndTextButton *)pButton
{
	if(!pButton.payload)
		return;

	NSString * sId = (NSString *)pButton.payload;
	if(!sId)
		return;
	
	if([sId isEqualToString:@"home"])
	{
		[[MainView instance] switchToHomePage];
		return;
	}

	if([sId isEqualToString:@"trophy"])
	{
		[[MainView instance] switchToPrizesPage];
		return;
	}
	
	if([sId isEqualToString:@"about"])
	{
		[[MainView instance] switchToAboutPage];
		return;
	}
	
	if([sId isEqualToString:@"bikes"])
	{
		[[MainView instance] switchToBikesPage];
		return;
	}
	
	if([sId isEqualToString:@"stats"])
	{
		[[MainView instance] switchToStatsPage];
		return;
	}
	
	if([sId isEqualToString:@"badges"])
	{
		[[MainView instance] switchToBadgesPage];
		return;
	}
	
	if([sId isEqualToString:@"record"])
	{
		[[MainView instance] switchToTracksPage];
		return;
	}
	
	if([sId isEqualToString:@"prizes"])
	{
		[[MainView instance] switchToPrizesPage];
		return;
	}
	
	if([sId isEqualToString:@"sign_out"])
	{
		// We ignore the result of the request: if it fails we'll not be *really* logged
		// out until the auth token expires, but not much can be done about it anyway
		[[NotificationManager instance] startNotificationUnregistration];
		[[AuthManager instance] startLogoutRequest];
		[[MainView instance] switchToAuthPage];
		return;
	}

	//if([sId isEqualToString:@"quit"])
	//{
		// Quit is forbidden by apple policy
	//	return;
	//}

}

@end
