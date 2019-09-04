//
//  ActiveCompetitionPage.m
//  SaveMyBike
//
//  Created by Szymon Tomasz Stefanek on 08/08/2019.
//  Copyright © 2019 GeoSolutions SaS. All rights reserved.
//

#import "CompetitionPage.h"

#import "STSImageView.h"
#import "STSLabel.h"
#import "STSDisplay.h"
#import "STSTextButton.h"
#import "BackendRequestParticipateInCompetition.h"
#import "BackendRequestCancelParticipationInCompetition.h"
#import "MainView.h"
#import "STSMessageBox.h"
#import "STSProgressDialog.h"
#import "STSI18n.h"

@interface CompetitionPage()<STSTextButtonDelegate,BackendRequestDelegate,STSMessageBoxDelegate>
{
	Competition * m_pCompetition;
	CompetitionParticipation * m_pParticipation;
	
	STSImageView * m_pImageView;
	STSLabel * m_pTitleLabel;
	STSLabel * m_pDescriptionLabel;
	
	STSTextButton * m_pParticipateButton;
	STSTextButton * m_pCancelParticipationButton;
	
	BackendRequestParticipateInCompetition * m_pParticipateRequest;
	BackendRequestCancelParticipationInCompetition * m_pCancelParticipationRequest;
	
	STSProgressDialog * m_pProgressDialog;
}

@end

@implementation CompetitionPage

- (id)initWithCompetition:(Competition *)cmp andParticipation:(CompetitionParticipation *)cp
{
	self = [super init];
	if(!self)
		return nil;
	
	STSDisplay * dpy = [STSDisplay instance];
	
	m_pCompetition = cmp;
	m_pParticipation = cp;
	
	m_pProgressDialog = nil;
	
	m_pImageView = [STSImageView new];
	if(cp)
	{
		if([cp.registrationStatus isEqualToString:@"approved"])
			m_pImageView.image = [UIImage imageNamed:@"competition_participating"];
		else
			m_pImageView.image = [UIImage imageNamed:@"competition_waiting"];
	} else {
		m_pImageView.image = [UIImage imageNamed:@"competition"];
	}
	[self addView:m_pImageView row:0 column:0];
	
	m_pTitleLabel = [STSLabel new];
	m_pTitleLabel.font = [UIFont boldSystemFontOfSize:[dpy centimetersToFontUnits:0.4]];
	m_pTitleLabel.text = cmp.name;
	[self addView:m_pTitleLabel row:0 column:1];
	
	m_pDescriptionLabel = [STSLabel new];
	m_pDescriptionLabel.text = cmp.description;
	[self addView:m_pDescriptionLabel row:1 column:0 rowSpan:1 columnSpan:2];
	
	
	[self setRow:7 expandWeight:1000];

	int iRow = 8;
	
	if(!m_pParticipation)
	{
		m_pParticipateButton = [STSTextButton new];
		m_pParticipateButton.payload = @"participate";
		m_pParticipateButton.text = __trCtx(@"Participate", @"CompetitionPage");
		[m_pParticipateButton setDelegate:self];
		[self addView:m_pParticipateButton row:iRow column:0 rowSpan:1 columnSpan:2];
		iRow++;
	}

	if(m_pParticipation)
	{
		m_pCancelParticipationButton = [STSTextButton new];
		m_pCancelParticipationButton.payload = @"cancelParticipation";
		m_pCancelParticipationButton.text = __trCtx(@"Cancel Participation", @"CompetitionPage");
		[m_pCancelParticipationButton setDelegate:self];
		[self addView:m_pCancelParticipationButton row:iRow column:0 rowSpan:1 columnSpan:2];
		iRow++;
	}

	[self setColumn:0 fixedWidth:[dpy minorScreenDimensionFractionToScreenUnits:0.3]];
	[self setRow:0 fixedHeight:[dpy minorScreenDimensionFractionToScreenUnits:0.3]];
	


	[self setMargin:[dpy centimetersToScreenUnits:0.2]];
	[self setSpacing:[dpy centimetersToScreenUnits:0.1]];

	return self;
}

- (void)showProgressDialog
{
	if(m_pProgressDialog)
		return;
	
	m_pProgressDialog = [STSProgressDialog new];
	
	m_pProgressDialog.hudBackgroundColor = [UIColor lightGrayColor];
	
	[m_pProgressDialog setIndeterminate:true];

	[m_pProgressDialog show:true];
}

- (void)hideProgressDialog
{
	if(!m_pProgressDialog)
		return;
	[m_pProgressDialog dismiss:true];
	m_pProgressDialog = nil;
}

- (void)onParticipateButtonClicked
{
	if(m_pParticipateRequest)
		return;

	[self showProgressDialog];
	
	m_pParticipateRequest = [BackendRequestParticipateInCompetition new];
	m_pParticipateRequest.competitionId = m_pCompetition.id;
	[m_pParticipateRequest setBackendRequestDelegate:self];
	[m_pParticipateRequest start];
}

- (void)onCancelParticipationButtonClicked
{
	if(m_pCancelParticipationRequest)
		return;
	
	STSMessageBoxParams * mp = [STSMessageBoxParams new];

	mp.tag = @"cancel";
	
	mp.message = __trCtx(@"Do you really want to cancel the participation in this competition?",@"CompetitionPage");
	mp.title = __trCtx(@"Cancel Participation", @"CompetitionPage");
	
	mp.button0Text = __tr(@"Yes");
	mp.button1Text = __tr(@"No");
	
	mp.delegate = self;
	
	[STSMessageBox show:mp];
}

- (void)messageBox:(STSMessageBoxParams *)pParams dismissedWithButton:(int)iIndex
{
	if([pParams.tag isEqualToString:@"cancel"])
	{
		if(iIndex == 0)
			[self onCancelParticipationConfirmed];
		return;
	}
}

- (void)onCancelParticipationConfirmed
{
	if(m_pCancelParticipationRequest)
		return;

	[self showProgressDialog];

	m_pCancelParticipationRequest = [BackendRequestCancelParticipationInCompetition new];
	m_pCancelParticipationRequest.participationId = m_pParticipation.id;
	[m_pCancelParticipationRequest setBackendRequestDelegate:self];
	[m_pCancelParticipationRequest start];
}

- (void)textButtonTapped:(STSTextButton *)pButton
{
	NSString * p = (NSString *)(pButton.payload);
	if(!p)
		return;
	
	if([p isEqualToString:@"participate"])
	{
		[self onParticipateButtonClicked];
		return;
	}
	
	if([p isEqualToString:@"cancelParticipation"])
	{
		[self onCancelParticipationButtonClicked];
		return;
	}
}

- (void)backendRequestCompleted:(BackendRequest *)pRequest
{
	if(pRequest == m_pParticipateRequest)
	{
		[self hideProgressDialog];
		if(!m_pParticipateRequest.succeeded)
		{
			[STSMessageBox showWithMessage:m_pParticipateRequest.error title:__trCtx(@"Join Request Failed",@"CompetitionPage")];
			return;
		}
		m_pParticipateRequest = nil;
		[[MainView instance] popCurrentPage];
		[STSMessageBox showWithMessage:__trCtx(@"Your request to participate in the competition has been received. It will appear in the \"Active\" tab once it is approved by our team.",@"CompetitionPage") title:__trCtx(@"Join Requested",@"CompetitionPage")];
		return;
	}
	
	if(pRequest == m_pCancelParticipationRequest)
	{
		[self hideProgressDialog];
		if(!m_pCancelParticipationRequest.succeeded)
		{
			[STSMessageBox showWithMessage:m_pCancelParticipationRequest.error title:__trCtx(@"Cancel Request Failed",@"CompetitionPage")];
			return;
		}
		m_pCancelParticipationRequest = nil;
		[[MainView instance] popCurrentPage];
		[STSMessageBox showWithMessage:__trCtx(@"Your participation has been canceled.",@"CompetitionPage") title:__trCtx(@"Participation Canceled",@"CompetitionPage")];
		return;
	}
}

@end
