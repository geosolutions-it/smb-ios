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
#import "TextButton.h"
#import "TitleImageAndDescriptionView.h"
#import "Prize.h"
#import "Sponsor.h"
#import "Config.h"
#import "STSSingleViewScroller.h"

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

- (id)initWithCompetition:(Competition *)cmp participation:(CompetitionParticipation *)cp isWon:(bool)bIsWon
{
	self = [super init];
	if(!self)
		return nil;
	
	STSSingleViewScroller * pScroller = [STSSingleViewScroller new];
	[self addView:pScroller row:0 column:0];
	
	STSGridLayoutView * g = [STSGridLayoutView new];
	
	STSDisplay * dpy = [STSDisplay instance];
	
	m_pCompetition = cmp;
	m_pParticipation = cp;
	
	m_pProgressDialog = nil;
	
	int r = 0;
	
	m_pImageView = [STSImageView new];
	if(bIsWon)
	{
		m_pImageView.image = [UIImage imageNamed:@"competition_won"];
	} else if(cp)
	{
		if([cp.registrationStatus isEqualToString:@"approved"])
			m_pImageView.image = [UIImage imageNamed:@"competition_participating"];
		else
			m_pImageView.image = [UIImage imageNamed:@"competition_waiting"];
	} else {
		m_pImageView.image = [UIImage imageNamed:@"competition"];
	}
	[g addView:m_pImageView row:r column:0 verticalSizePolicy:STSSizePolicyIgnore horizontalSizePolicy:STSSizePolicyIgnore];
	r++;
	
	m_pTitleLabel = [STSLabel new];
	m_pTitleLabel.font = [UIFont boldSystemFontOfSize:[dpy centimetersToFontUnits:0.4]];
	m_pTitleLabel.text = cmp.name;
	m_pTitleLabel.textColor = [Config instance].highlight1Color;
	m_pTitleLabel.textAlignment = NSTextAlignmentLeft;
	[g addView:m_pTitleLabel row:r column:0 rowSpan:1 columnSpan:2 verticalSizePolicy:STSSizePolicyCanExpand horizontalSizePolicy:STSSizePolicyIgnore];
	r++;
	
	m_pDescriptionLabel = [STSLabel new];
	m_pDescriptionLabel.text = cmp.description;
	m_pDescriptionLabel.lineBreakMode = NSLineBreakByWordWrapping;
	[g addView:m_pDescriptionLabel row:r column:0 rowSpan:1 columnSpan:2 verticalSizePolicy:STSSizePolicyCanExpand horizontalSizePolicy:STSSizePolicyIgnore];
	r++;
	
	if(bIsWon)
	{
		STSGridLayoutView * glv = [STSGridLayoutView new];
		
		glv.backgroundColor = [Config instance].highlight1Color;
		
		STSLabel * l = [STSLabel new];
		l.font = [UIFont boldSystemFontOfSize:[dpy centimetersToFontUnits:0.4]];
		l.text = __trCtx(@"Congratulations!\nYou Won This Competition!",@"CompetitionPage");
		l.numberOfLines = 2;
		l.textColor = [UIColor whiteColor];
		l.textAlignment = NSTextAlignmentCenter;
		[glv addView:l row:r column:0 verticalSizePolicy:STSSizePolicyCanExpand horizontalSizePolicy:STSSizePolicyIgnore];
		[glv setMargin:[dpy minorScreenDimensionFractionToScreenUnits:0.05]];

		glv.layer.cornerRadius = [dpy centimetersToScreenUnits:0.1];
		glv.layer.shadowColor = [[UIColor blackColor] CGColor];
		glv.layer.shadowOpacity = 0.5;
		glv.layer.shadowRadius = [dpy centimetersToScreenUnits:0.1];
		glv.layer.shadowOffset = CGSizeMake(0.0, [dpy centimetersToScreenUnits:0.1]);
		glv.clipsToBounds = true;
		glv.layer.masksToBounds = false;
		
		[g addView:glv row:r column:0 rowSpan:1 columnSpan:2 verticalSizePolicy:STSSizePolicyFixed horizontalSizePolicy:STSSizePolicyIgnore];
		r++;
	}
	
	if(cmp.prizes && (cmp.prizes.count > 0))
	{
		STSLabel * l = [STSLabel new];
		l.font = [UIFont boldSystemFontOfSize:[dpy centimetersToFontUnits:0.3]];
		l.text = __trCtx(@"Prizes",@"CompetitionPage");
		l.textColor = [Config instance].highlight1Color;
		[g addView:l row:r column:0 rowSpan:1 columnSpan:2 verticalSizePolicy:STSSizePolicyCanExpand horizontalSizePolicy:STSSizePolicyIgnore];
		r++;
		
		for(CompetitionPrize * cpr in cmp.prizes)
		{
			if(!cpr.prize)
				continue;
			if(!cpr.prize.name)
				continue;
			// FIXME: Sponsor?
			TitleImageAndDescriptionView * tid = [
					[TitleImageAndDescriptionView alloc]
						 	initWithTitle:cpr.prize.name
							imageURL:cpr.prize.image
							placeholder:@""
							description:cpr.prize.description
				];
			[g addView:tid row:r column:0 rowSpan:1 columnSpan:2];
			r++;
		}
	}
	
	if(cmp.sponsors && (cmp.sponsors.count > 0))
	{
		STSLabel * l = [STSLabel new];
		l.font = [UIFont boldSystemFontOfSize:[dpy centimetersToFontUnits:0.3]];
		l.text = __trCtx(@"Sponsors",@"CompetitionPage");
		l.textColor = [Config instance].highlight1Color;
		[g addView:l row:r column:0 rowSpan:1 columnSpan:2 verticalSizePolicy:STSSizePolicyCanExpand horizontalSizePolicy:STSSizePolicyIgnore];
		r++;
		
		for(Sponsor * spn in cmp.sponsors)
		{
			if(!spn.name)
				continue;

			TitleImageAndDescriptionView * tid = [
					  [TitleImageAndDescriptionView alloc]
							  initWithTitle:spn.name
							  imageURL:spn.logo
							  placeholder:@""
							  description:spn.url
				];
			tid.openURL = spn.url;
			[g addView:tid row:r column:0 rowSpan:1 columnSpan:2];
			r++;
		}
	}
	
	[g setRow:r expandWeight:1000];
	r++;

	if(!m_pParticipation)
	{
		m_pParticipateButton = [TextButton new];
		m_pParticipateButton.payload = @"participate";
		m_pParticipateButton.text = __trCtx(@"Participate", @"CompetitionPage");
		[m_pParticipateButton setDelegate:self];
		[g addView:m_pParticipateButton row:r column:0 rowSpan:1 columnSpan:2];
		r++;
	}

	if(m_pParticipation)
	{
		m_pCancelParticipationButton = [TextButton new];
		m_pCancelParticipationButton.payload = @"cancelParticipation";
		m_pCancelParticipationButton.text = __trCtx(@"Cancel Participation", @"CompetitionPage");
		[m_pCancelParticipationButton setDelegate:self];
		[g addView:m_pCancelParticipationButton row:r column:0 rowSpan:1 columnSpan:2];
		r++;
	}

	[g setColumn:0 fixedWidth:[dpy minorScreenDimensionFractionToScreenUnits:0.3]];
	[g setRow:0 fixedHeight:[dpy minorScreenDimensionFractionToScreenUnits:0.3]];

	[g setMargin:[dpy minorScreenDimensionFractionToScreenUnits:0.07]];
	[g setSpacing:[dpy minorScreenDimensionFractionToScreenUnits:0.04]];

	[pScroller setView:g];

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
