//
//  AuthPage.m
//  SaveMyBike
//
//  Created by Szymon Tomasz Stefanek on 17/06/2019.
//  Copyright © 2019 GeoSolutions SaS. All rights reserved.
//

#import "AuthPage.h"

#import "STSImageView.h"
#import "STSDisplay.h"
#import "TextButton.h"
#import "M13ProgressViewBar.h"
#import "STSI18N.h"
#import "Globals.h"
#import "Config.h"
#import "UIColorUtilities.h"
#import "STSLabel.h"
#import "AuthManager.h"
#import "TopLevelViewController.h"
#import "MainView.h"
#import "MenuView.h"
#import "BackendRequestGetMyUser.h"
#import "NotificationManager.h"

enum AuthState
{
	AuthStateIdle,
	AuthStateRefreshingToken,
	AuthStateLoggingIn,
	AuthStateError,
	AuthStateBusy
};

@interface AuthPage()<STSTextButtonDelegate,AuthManagerStateObserver,BackendRequestDelegate>
{
	STSImageView * m_pLogoImageView;
	M13ProgressViewBar * m_pProgressView;
	STSLabel * m_pLabel;
	NSString * m_sMessage;
	TextButton * m_pSignInButton;
	enum AuthState m_eAuthState;
	BackendRequestGetMyUser * m_pGetMyUserRequest;
}
@end

@implementation AuthPage

- (id)init
{
	self = [super init];
	if(!self)
		return nil;

	self.actionBarMode = STSPageStackActionBarModeHidden;

	m_eAuthState = AuthStateIdle;

	STSDisplay * dpy = [STSDisplay instance];
	
	m_pLogoImageView = [STSImageView new];
	m_pLogoImageView.contentMode = UIViewContentModeScaleAspectFit;
	if([[Globals instance].currentLanguage isEqualToString:@"it"])
		[m_pLogoImageView setImage:[UIImage imageNamed:@"auth_page_logo_it"]];
	else
		[m_pLogoImageView setImage:[UIImage imageNamed:@"auth_page_logo_en"]];
	
	[self addView:m_pLogoImageView row:0 column:0 rowSpan:1 columnSpan:3];
	[self setRow:0 fixedHeightPercent:0.4];

	[self setRow:1 fixedHeight:[dpy centimetersToScreenUnits:0.5]];

	m_pLabel = [STSLabel new];
	m_pLabel.textAlignment = NSTextAlignmentCenter;
	m_pLabel.textColor = [Config instance].generalForegroundColor;
	m_pLabel.text = @"-";
	m_pLabel.lineBreakMode = NSLineBreakByWordWrapping;
	m_pLabel.numberOfLines = 3;
	
	[self addView:m_pLabel row:2 column:0 rowSpan:1 columnSpan:3 verticalSizePolicy:STSSizePolicyCanExpand horizontalSizePolicy:STSSizePolicyIgnore];

	[self setRow:2 minimumHeight:[dpy centimetersToScreenUnits:1.5]];

	m_pProgressView = [M13ProgressViewBar new];
	m_pProgressView.indeterminate = true;
	m_pProgressView.showPercentage = false;
	m_pProgressView.backgroundColor = [[Config instance].highlight1Color withAlpha:127];
	m_pProgressView.primaryColor = [Config instance].highlight1Color;

	[self addView:m_pProgressView row:3 column:0 rowSpan:1 columnSpan:3];
	

	[self setRow:4 fixedHeight:[dpy centimetersToScreenUnits:0.5]];

	m_pSignInButton = [TextButton new];
	[m_pSignInButton setDelegate:self];
	m_pSignInButton.text = __trCtx(@"SIGN IN",@"AuthPage");
	
	[self addView:m_pSignInButton row:5 column:1 verticalSizePolicy:STSSizePolicyFixed horizontalSizePolicy:STSSizePolicyCanExpand];
	
	[self setRow:5 minimumHeight:[dpy centimetersToScreenUnits:1.0]];
	[self setColumn:1 minimumWidth:[dpy centimetersToScreenUnits:2.0]];
	[self setColumn:1 maximumWidth:[dpy minorScreenDimensionFractionToScreenUnits:0.6]];

	[self setRow:6 expandWeight:1000];
	[self setColumn:0 expandWeight:1000];
	[self setColumn:2 expandWeight:1000];

	[self setTopMargin:[dpy majorScreenDimensionFractionToScreenUnits:0.1]];
	[self setLeftMargin:[dpy minorScreenDimensionFractionToScreenUnits:0.1]];
	[self setRightMargin:[dpy minorScreenDimensionFractionToScreenUnits:0.1]];
	[self setBottomMargin:[dpy majorScreenDimensionFractionToScreenUnits:0.1]];
	[self setSpacing:[dpy centimetersToScreenUnits:0.5]];
	
	return self;
}

- (void)updateForState
{
	bool bShowProgress = false;
	NSString * sText = nil;
	bool bButtonEnabled = false;
	switch(m_eAuthState)
	{
		case AuthStateIdle:
			bButtonEnabled = true;
			sText = __trCtx(@"Ready to start your journey?",@"AuthPage");
			break;
		case AuthStateError:
			bButtonEnabled = true;
			sText = m_sMessage;
			break;
		case AuthStateBusy:
		case AuthStateLoggingIn:
		case AuthStateRefreshingToken:
			bShowProgress = true;
			sText = m_sMessage;
			break;
	}
	
	m_pProgressView.hidden = !bShowProgress;
	if(sText)
	{
		m_pLabel.text = sText;
		m_pLabel.hidden = false;
	} else {
		m_pLabel.hidden = true;
	}

	[m_pSignInButton setEnabled:bButtonEnabled];
}

- (void)onPageAttach
{
	[[AuthManager instance] addStateObserver:self];
	
	switch([AuthManager instance].state)
	{
		case AuthManagerStateLoggedIn:
		case AuthManagerStateError:
		case AuthManagerStateIdle:
			m_eAuthState = AuthStateIdle;
			if([[AuthManager instance] haveValidAuthState])
				[[AuthManager instance] startAuthStateCheck];
			[self updateForState];
			break;
		case AuthManagerStateNotConfigured:
			m_eAuthState = AuthStateIdle;
			[[AuthManager instance] startServiceDiscovery];
			[self updateForState];
			break;
		default:
			[self onAuthManagerStateChanged];
			break;
	}
	
	[[TopLevelViewController instance] setCanOpenDrawer:false];
}

- (void)onPageDetach
{	
	[[AuthManager instance] removeStateObserver:self];

	[[TopLevelViewController instance] setCanOpenDrawer:true];
}

- (void)onAuthManagerStateChanged
{
	switch([AuthManager instance].state)
	{
		case AuthManagerStateRefreshingTokens:
			//m_sMessage = __trCtx(@"Refreshing access tokens...",@"AuthPage");
			m_sMessage = __trCtx(@"Loading...", @"AuthPage");
			m_eAuthState = AuthStateBusy;
			break;
		case AuthManagerStateLoggedIn:
			m_pGetMyUserRequest = [BackendRequestGetMyUser new];
			m_pGetMyUserRequest.backendRequestDelegate = self;
			if([m_pGetMyUserRequest start])
			{
				//m_sMessage = __trCtx(@"Fetching user data...",@"AuthPage");
				m_sMessage = __trCtx(@"Loading...", @"AuthPage");
				m_eAuthState = AuthStateBusy;
			} else {
				m_sMessage = [NSString stringWithFormat:__trCtx(@"Failed to start user request: %@",@"AuthPage"),m_pGetMyUserRequest.error];
				m_eAuthState = AuthStateError;
			}
			break;
		case AuthManagerStateError:
		case AuthManagerStateDiscoveryFailed:
			m_sMessage = [AuthManager instance].error;
			m_eAuthState = AuthStateError;
			break;
		case AuthManagerStateDiscoveringService:
			//m_sMessage = __trCtx(@"Discovering services...",@"AuthPage");
			m_sMessage = __trCtx(@"Loading...", @"AuthPage");
			m_eAuthState = AuthStateBusy;
			break;
		case AuthManagerStateNotConfigured:
			m_sMessage = __trCtx(@"Authentication not configured",@"AuthPage");
			m_eAuthState = AuthStateError;
			break;
		case AuthManagerStateIdle:
			m_eAuthState = AuthStateIdle;
			if([[AuthManager instance] haveValidAuthState])
				[[AuthManager instance] startAuthStateCheck];
			break;
		case AuthManagerStateLoggingIn:
			//m_sMessage = __trCtx(@"Logging in...",@"AuthPage");
			m_sMessage = __trCtx(@"Loading...", @"AuthPage");
			m_eAuthState = AuthStateBusy;
			break;
		default:
			m_sMessage = __trCtx(@"Bad Auth State",@"AuthPage");
			m_eAuthState = AuthStateError;
			break;
	}
	
	[self updateForState];

}

- (void)backendRequestCompleted:(BackendRequest *)pRequest
{
	assert(m_pGetMyUserRequest == pRequest);
	if(!m_pGetMyUserRequest.succeeded)
	{
#ifdef SMB_IGNORE_ERRORS_IN_USER_UPDATE
		[[MainView instance] switchToHomePage];
#else
		m_sMessage = [NSString stringWithFormat:__trCtx(@"Fetching user data failed: %@",@"AuthPage"),m_pGetMyUserRequest.error];
		m_eAuthState = AuthStateError;
		m_pGetMyUserRequest = nil;
		[self updateForState];
#endif
		return;
	}

	assert(m_pGetMyUserRequest.userData);
	[Globals instance].userData = m_pGetMyUserRequest.userData;
	m_pGetMyUserRequest = nil;
	
	[[MenuView instance] userInfoUpdated];
	[[NotificationManager instance] maybeStartNotificationRegistration];
	[[MainView instance] switchToHomePage];
}

- (void)textButtonTapped:(STSTextButton *)pButton
{
	[[AuthManager instance] startAuthRequest];
}


@end
