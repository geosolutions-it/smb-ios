//
//  MainView.m
//  SaveMyBike
//
//  Created by Szymon Tomasz Stefanek on 1/6/19.
//  Copyright © 2018 Szymon Tomasz Stefanek. All rights reserved.
//

#import "MainView.h"

#import "STSPageStackView.h"
#import "STSDisplay.h"
#import "STSGridLayoutView.h"
#import "STSImageButton.h"
#import "STSImageView.h"

#import "TopLevelViewController.h"
#import "HomePage.h"
#import "AuthPage.h"
#import "BadgesPage.h"
#import "CompetitionsPage.h"
#import "TracksPage.h"
#import "BikesPage.h"
#import "AboutPage.h"
#import "CompetitionPage.h"
#import "TrackPage.h"
#import "BikePage.h"
#import "STSPopupMenu.h"
#import "Globals.h"
#import "Settings.h"
#import "STSI18n.h"
#import "BikeLostPage.h"
#import "Config.h"

@interface MainView()<STSImageButtonDelegate,STSPageStackViewDelegate,STSPageStackActionDelegate,STSPopupMenuDelegate>
{
	STSPageStackView * m_pPageStack;
	BOOL m_bShowButtonBar;
	CGFloat m_fButtonBarHeight;
	STSGridLayoutView * m_pButtonBar;
	STSImageButton * m_pButton[4];
}
@end

static MainView * g_pMainView = nil;

@implementation MainView

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if(!self)
		return nil;
	
	g_pMainView = self;
	
	m_bShowButtonBar = false;

	STSDisplay * dpy = [STSDisplay instance];
	
	m_pPageStack = [STSPageStackView new];
	m_pPageStack.backgroundColor = [Config instance].generalBackgroundColor;

	m_pPageStack.defaultActionBarBackgroundColor = [UIColor whiteColor];
	m_pPageStack.defaultActionBarForegroundColor = [Config instance].highlight1Color;

	STSGridLayoutView * header = [STSGridLayoutView new];
	
	STSImageView * img = [STSImageView new];
	img.contentMode = UIViewContentModeScaleAspectFit;
	img.image = [UIImage imageNamed:@"goodgo_logo"];
	
	[header addView:img row:0 column:0];
	[header setMargin:[dpy centimetersToScreenUnits:0.1]];
	
	m_pPageStack.defaultActionBarCenterView = header;
	m_pPageStack.defaultActionBarTitle = @"";
	m_pPageStack.showStatusBarBackground = false;
	m_pPageStack.delegate = self;
	
	STSPageStackAction * a = [STSPageStackAction new];
	a.identifier = @"drawer";
	a.icon = @"icon_drawer_menu";
	a.delegate = self;
	[m_pPageStack addPersistentLeftAction:a];

#ifdef SMB_DEVELOPER_VERSION
	a = [STSPageStackAction new];
	a.identifier = @"right";
	a.icon = @"icon_right_menu";
	a.delegate = self;
	[m_pPageStack addPersistentRightAction:a];
#endif
	
	[self addSubview:m_pPageStack];
	
	CGFloat s = [dpy centimetersToScreenUnits:[Config instance].separatorWidthCM];
	
	m_pButtonBar = [STSGridLayoutView new];
	m_pButtonBar.backgroundColor = [Config instance].generalBackgroundColor;
	[m_pButtonBar setSpacing:s];
	[m_pButtonBar setMarginLeft:0 top:s right:0 bottom:0];
	
	[self addSubview:m_pButtonBar];

	s = [dpy centimetersToScreenUnits:0.05];
	
	for(int i=0;i<4;i++)
	{
		m_pButton[i] = [STSImageButton new];
		//[UIUtils themeButtonBarButton:m_pButton[i]];
		[m_pButton[i] setDelegate:self];
		[m_pButton[i] setMargins:[STSMargins marginsWithAllValues:s]];
		[m_pButtonBar addView:m_pButton[i] row:0 column:i];
	}
	
	[m_pButton[0] setImage:[UIImage imageNamed:@"beacons"] forState:STSButtonStateNormal];
	[m_pButton[1] setImage:[UIImage imageNamed:@"lines"] forState:STSButtonStateNormal];
	[m_pButton[2] setImage:[UIImage imageNamed:@"keyboard"] forState:STSButtonStateNormal];
	[m_pButton[3] setImage:[UIImage imageNamed:@"home"] forState:STSButtonStateNormal];
	
	m_fButtonBarHeight = [dpy centimetersToScreenUnits:1.3];

	self.backgroundColor = [Config instance].generalBackgroundColor;
	
	return self;
}

+ (MainView *)instance
{
	return g_pMainView;
}

- (void)setShowButtonBar:(bool)bShowIt
{
	if(m_bShowButtonBar == bShowIt)
		return;
	
	m_bShowButtonBar = bShowIt;
	[self setNeedsLayout];
}

- (void)layoutSubviews
{
	CGSize s = self.frame.size;
	
	if(m_bShowButtonBar)
	{
		m_pPageStack.frame = CGRectMake(0,0,s.width,s.height - m_fButtonBarHeight);
		m_pButtonBar.frame = CGRectMake(0, s.height - m_fButtonBarHeight,s.width, m_fButtonBarHeight);
		m_pButtonBar.hidden = false;
	} else {
		m_pPageStack.frame = CGRectMake(0,0,s.width,s.height);
		m_pButtonBar.hidden = true;
	}
}

- (void)onPageStackActionActivated:(STSPageStackAction *)pAction
{
	if([pAction.identifier isEqualToString:@"drawer"])
	{
		[[TopLevelViewController instance] toggleDrawerSide:MMDrawerSideLeft animated:true completion:nil];
		return;
	}

	if([pAction.identifier isEqualToString:@"right"])
	{
		[self _showRightMenu];
		return;
	}
}

- (void)_showRightMenu
{
	STSPopupMenu * m = [[STSPopupMenu alloc] initWithDelegate:self];
	
	NSString * sText = [Globals instance].simulateGPS ? __trCtx(@"Disable GPS Simulation",@"MainView") : __trCtx(@"Enable GPS Simulation",@"MainView");
	
	[m addItem:sText tag:@"toggleSimulation"];
	
	[m showAsDialogFromController:[TopLevelViewController instance]];
}

- (void)popupMenu:(STSPopupMenu *)pMenu itemActivated:(NSString *)szTag
{
	if([szTag isEqualToString:@"toggleSimulation"])
	{
		[Globals instance].simulateGPS = ![Globals instance].simulateGPS;
		return;
	}
}


- (void)imageButtonTapped:(STSImageButton *)pButton
{
}

- (void)_pushPage:(Page *)p
{
	[self setupCurrentPage:p];
	[m_pPageStack pushPage:p];
	[[TopLevelViewController instance] closeDrawerAnimated:true completion:nil];
}

- (void)_switchToPage:(Page *)p
{
	[self setupCurrentPage:p];
	[m_pPageStack switchToPage:p];
	[[TopLevelViewController instance] closeDrawerAnimated:true completion:nil];
}

- (void)switchToHomePage
{
	[self _switchToPage:[HomePage new]];
}

- (void)switchToAuthPage
{
	[self _switchToPage:[AuthPage new]];
}

- (void)_switchToSecondLevelPageWithClass:(Class)oClass
{
	if((m_pPageStack.pageStack.count < 1) || (![[m_pPageStack.pageStack objectAtIndex:0] isKindOfClass:[HomePage class]]))
		[self switchToHomePage];

	while(m_pPageStack.pageStack.count > 2)
		[m_pPageStack popCurrentPage];
	if(m_pPageStack.pageStack.count == 2)
	{
		if([[m_pPageStack.pageStack objectAtIndex:1] isKindOfClass:oClass])
			return;
		[m_pPageStack popCurrentPage];
	}
	[self _pushPage:[oClass new]];
}

- (void)switchToBadgesPage
{
	[self _switchToSecondLevelPageWithClass:[BadgesPage class]];
	if((!m_pPageStack.currentPage) || (![m_pPageStack.currentPage isKindOfClass:[BadgesPage class]]))
		return;
	BadgesPage * bp = (BadgesPage *)m_pPageStack.currentPage;
	[bp switchToBadgesTab];
}

- (void)switchToCompetitionsPage
{
	[self _switchToSecondLevelPageWithClass:[CompetitionsPage class]];
}

- (void)switchToBikesPage
{
	[self _switchToSecondLevelPageWithClass:[BikesPage class]];
}

- (void)switchToTracksPage
{
	[self _switchToSecondLevelPageWithClass:[TracksPage class]];
}

- (void)switchToStatsPage
{
	[self _switchToSecondLevelPageWithClass:[TracksPage class]];
	if((!m_pPageStack.currentPage) || (![m_pPageStack.currentPage isKindOfClass:[TracksPage class]]))
		return;
	TracksPage * tp = (TracksPage *)m_pPageStack.currentPage;
	[tp switchToStatsTab];
}

- (void)switchToProfilePage
{
	[self _switchToSecondLevelPageWithClass:[BadgesPage class]];
	if((!m_pPageStack.currentPage) || (![m_pPageStack.currentPage isKindOfClass:[BadgesPage class]]))
		return;
	BadgesPage * bp = (BadgesPage *)m_pPageStack.currentPage;
	[bp switchToProfileTab];
}

- (void)pushBadgesPage
{
	BadgesPage * bp = [BadgesPage new];
	[self _pushPage:bp];
	[bp switchToBadgesTab];
}

- (void)pushCompetitionsPage
{
	[self _pushPage:[CompetitionsPage new]];
}

- (void)pushBikesPage
{
	[self _pushPage:[BikesPage new]];
}

- (void)pushBikeLostPage:(Bike *)bk
{
	[self _pushPage:[[BikeLostPage alloc] initWithBike:bk]];
}


- (void)pushTracksPage
{
	TracksPage * p = [TracksPage new];
	[self _pushPage:p];
}

- (void)pushCompetitionPage:(Competition *)cmp withParticipation:(CompetitionParticipation *)cp;
{
	[self _pushPage:[[CompetitionPage alloc] initWithCompetition:cmp participation:cp isWon:false]];
}

- (void)pushWonCompetitionPage:(Competition *)cmp withParticipation:(CompetitionParticipation *)cp;
{
	[self _pushPage:[[CompetitionPage alloc] initWithCompetition:cmp participation:cp isWon:true]];
}

- (void)pushTrackPage:(Track *)trk
{
	[self _pushPage:[[TrackPage alloc] initWithTrack:trk]];
}

- (void)pushBikePage:(Bike *)bk
{
	[self _pushPage:[[BikePage alloc] initWithBike:bk]];
}

- (void)switchToAboutPage
{
	[self _switchToPage:[AboutPage new]];
}

- (void)popCurrentPage
{
	NSArray<STSPageStackPage *> * pp = m_pPageStack.pageStack;
	if(pp && (pp.count > 1))
	{
		STSPageStackPage * psp = [pp objectAtIndex:pp.count - 2];
		if([psp isKindOfClass:[Page class]])
		{
			Page * p = (Page *)psp;
			[self setupCurrentPage:p];
		}
	}

	[m_pPageStack popCurrentPage];
}

- (void)pageStackView:(STSPageStackView *)pStackView pageActivated:(STSPageStackPage *)pPage
{
	if([pPage isKindOfClass:[Page class]])
		[self setupCurrentPage:(Page *)pPage];
}

- (void)setupCurrentPage:(Page *)p
{
	//[self setShowButtonBar:p.showButtonBar];
	//[self setActiveSection:p.appSection];
	
	[self layoutSubviews];
}

@end
