//
//  BikeLostPage.m
//  SaveMyBike
//
//  Created by Pragma on 24/10/2019.
//  Copyright © 2019 STS. All rights reserved.
//

#import "BikeLostPage.h"

#import "Bike.h"

#import "STSLabel.h"
#import "STSTextField.h"
#import "STSImageButton.h"
#import "STSProgressDialog.h"

#import "BackendRequestSetBikeStatus.h"
#import "MainView.h"

#import "Config.h"

#import "STSI18n.h"
#import "STSMessageBox.h"
#import "STSGeoCoordinate.h"

#import "STSDisplay.h"
#import "MapDisplay.h"

@interface BikeLostPage()<STSImageButtonDelegate,BackendRequestDelegate,GMSMapViewDelegate>
{
	Bike * m_pBike;
	MapDisplay * m_pMapDisplay;
	STSTextField * m_pDetailsField;
	STSImageButton * m_pProceedButton;
	STSProgressDialog * m_pProgressDialog;
	BackendRequestSetBikeStatus * m_pSetBikeStatusRequest;
	STSGeoCoordinate * m_pLastCoordinate;
}
@end

@implementation BikeLostPage

- (id)initWithBike:(Bike *)bk
{
	self = [super init];
	if(!self)
		return nil;
	
	STSDisplay * dpy = [STSDisplay instance];
	
	m_pBike = bk;
	
	STSLabel * l = [STSLabel new];
	l.text = __tr(@"You are about to report your bike as 'lost', please add some details.");
	l.lineBreakMode = NSLineBreakByWordWrapping;
	l.textColor = [Config instance].highlight1Color;
	[self addView:l row:0 column:0 rowSpan:1 columnSpan:2];
	
	l = [STSLabel new];
	l.text = __tr(@"Tap on the map or search for a location to indicate where you've seen the bike last time");
	l.lineBreakMode = NSLineBreakByWordWrapping;
	[self addView:l row:1 column:0 rowSpan:1 columnSpan:2];
	
	m_pMapDisplay = [MapDisplay new];
	m_pMapDisplay.mapView.delegate = self;
	[m_pMapDisplay enableMyLocationButton];
	//[m_pMapDisplay enableSearchBox];

	[self addView:m_pMapDisplay row:2 column:0 rowSpan:1 columnSpan:2];
	
	l = [STSLabel new];
	l.text = __tr(@"additional info (optional):");
	[self addView:l row:3 column:0 rowSpan:1 columnSpan:1];

	m_pDetailsField = [STSTextField new];
	m_pDetailsField.placeholder = __tr(@"additional info");
	[self addView:m_pDetailsField row:4 column:0];
	
	m_pProceedButton = [STSImageButton new];
	[m_pProceedButton setDelegate:self];
	[m_pProceedButton setImage:[UIImage imageNamed:@"icon_proceed"] forState:STSButtonStateNormal];
	[m_pProceedButton setBackgroundColor:[Config instance].highlight1Color forState:STSButtonStateNormal];
	[m_pProceedButton setBackgroundColor:[UIColor lightGrayColor] forState:STSButtonStatePressed];
	[m_pProceedButton setMargins:[STSMargins marginsWithAllValues:[dpy centimetersToScreenUnits:0.2]]];
	m_pProceedButton.layer.shadowColor = [[UIColor blackColor] CGColor];
	m_pProceedButton.layer.shadowOpacity = 0.5;
	m_pProceedButton.layer.cornerRadius = [dpy centimetersToScreenUnits:0.2];
	m_pProceedButton.layer.shadowRadius = [dpy centimetersToScreenUnits:0.1];
	m_pProceedButton.layer.shadowOffset = CGSizeMake(0.0, [dpy centimetersToScreenUnits:0.1]);
	m_pProceedButton.clipsToBounds = true;
	m_pProceedButton.layer.masksToBounds = false;


	[self addView:m_pProceedButton row:3 column:1 rowSpan:2 columnSpan:1];
	
	[self setColumn:1 fixedWidth:[dpy centimetersToScreenUnits:1.0]];
	[self setRow:4 minimumHeight:[dpy centimetersToScreenUnits:0.6]];
	[self setColumn:0 expandWeight:1000.0];
	[self setRow:2 expandWeight:1000.0];
	[self setSpacing:[dpy centimetersToScreenUnits:0.1]];
	[self setMargin:[dpy centimetersToScreenUnits:0.3]];

	return self;
}

- (void)imageButtonTapped:(STSImageButton *)pButton
{
	if(m_pSetBikeStatusRequest)
		return;
	
	m_pSetBikeStatusRequest = [BackendRequestSetBikeStatus new];
	m_pSetBikeStatusRequest.lost = true;
	m_pSetBikeStatusRequest.details = m_pDetailsField.text;
	m_pSetBikeStatusRequest.url = @"";
	m_pSetBikeStatusRequest.bikeUUID = m_pBike.shortUUID;
	if(m_pLastCoordinate)
		m_pSetBikeStatusRequest.position = [NSString stringWithFormat:@"POINT (%f %f)",m_pLastCoordinate.latitude,m_pLastCoordinate.longitude];
	[m_pSetBikeStatusRequest setBackendRequestDelegate:self];
	
	if(![m_pSetBikeStatusRequest start])
	{
		[STSMessageBox showWithMessage:__tr(@"Failed to start request")];
		return;
	}
	
	[self showProgressDialog];

}

- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate
{
	[m_pMapDisplay removeAllOverlays];
	[m_pMapDisplay addMarkerWithLatitude:coordinate.latitude longitude:coordinate.longitude title:@"" andDescription:@""];
	m_pLastCoordinate = [STSGeoCoordinate new];
	m_pLastCoordinate.latitude = coordinate.latitude;
	m_pLastCoordinate.longitude = coordinate.longitude;
}

- (void)showProgressDialog
{
	if(m_pProgressDialog)
		return;
	m_pProgressDialog = [STSProgressDialog new];
	[m_pProgressDialog showAsIndeterminate:true];
}

- (void)hideProgressDialog
{
	if(!m_pProgressDialog)
		return;
	[m_pProgressDialog close:true];
	m_pProgressDialog = nil;
}


- (void)backendRequestCompleted:(BackendRequest *)pRequest
{
	if(pRequest == m_pSetBikeStatusRequest)
	{
		[self hideProgressDialog];
		if(!m_pSetBikeStatusRequest.succeeded)
			[STSMessageBox showWithMessage:m_pSetBikeStatusRequest.error];
		m_pSetBikeStatusRequest = nil;
		[[MainView instance] popCurrentPage];
		return;
	}

}


@end
