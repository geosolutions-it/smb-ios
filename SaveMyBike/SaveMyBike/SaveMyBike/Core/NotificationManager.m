//
//  NotificationManager.m
//  SaveMyBike
//
//  Created by Szymon Tomasz Stefanek on 02/09/2019.
//  Copyright © 2019 GeoSolutions SaS. All rights reserved.
//

#import "NotificationManager.h"

#import "Globals.h"
#import "Settings.h"

#import "Device.h"

#import "STSCore.h"

#import "BackendRequestUpdateDevice.h"
#import "BackendRequestDeleteDevice.h"

static NotificationManager * g_pNotificationManager = nil;

@interface NotificationManager()<BackendRequestDelegate>
{
	NSString * m_sUpdateFirebaseToken;
	BackendRequestUpdateDevice * m_pUpdateDeviceRequest;
	BackendRequestDeleteDevice * m_pDeleteDeviceRequest;
}

@end

@implementation NotificationManager

+ (NotificationManager *)instance
{
	return g_pNotificationManager;
}

+ (void)create
{
	g_pNotificationManager = [NotificationManager new];
}

+ (void)destroy
{
	g_pNotificationManager = nil;
}

- (void)startNotificationRegistration
{
	if(m_pUpdateDeviceRequest)
		return; // already pending
	
	BackendRequestUpdateDevice * d = [BackendRequestUpdateDevice new];
	
	m_sUpdateFirebaseToken = [Globals instance].firebaseToken;
	
	Device * dev = [Device new];
	
	dev.registrationId = m_sUpdateFirebaseToken;
	dev.deviceId = [Settings instance].uniqueId;
	dev.type = @"ios";
	
	d.device = dev;
	
	m_pUpdateDeviceRequest = d;
	
	[d setBackendRequestDelegate:self];
	[d start];
}

- (void)startNotificationUnregistration
{
	if(m_pDeleteDeviceRequest)
		return;
	
	if(![Globals instance].authToken)
		return;
	if(![Globals instance].firebaseToken)
		return;

	BackendRequestDeleteDevice * d = [BackendRequestDeleteDevice new];
	
	d.token = [Globals instance].firebaseToken;

	m_pDeleteDeviceRequest = d;
	
	[d setBackendRequestDelegate:self];
	[d start];
}

- (void)maybeStartNotificationRegistration
{
	if(m_pUpdateDeviceRequest)
		return;
	if(![Globals instance].authToken)
		return;
	if(![Globals instance].firebaseToken)
		return;

	if([Settings instance].lastFirebaseToken && [[Settings instance].lastFirebaseToken isEqualToString:[Globals instance].firebaseToken])
		return;

	[self startNotificationRegistration];
}

- (void)backendRequestCompleted:(BackendRequest *)pRequest
{
	if(m_pUpdateDeviceRequest == pRequest)
	{
		if(pRequest.succeeded)
		{
			[Settings instance].lastFirebaseToken = m_sUpdateFirebaseToken;
			[[Settings instance] save];
		} else {
			STS_CORE_LOG_ERROR(@"Failed to register device for notifications: %@",pRequest.error);
		}
			
		m_pUpdateDeviceRequest = nil;
		return;
	}
	
	if(m_pDeleteDeviceRequest == pRequest)
	{
		if(pRequest.succeeded)
		{
			[Settings instance].lastFirebaseToken = nil;
			[[Settings instance] save];
		} else {
			STS_CORE_LOG_ERROR(@"Failed to unregister device from notifications: %@",pRequest.error);
		}
		
		m_pDeleteDeviceRequest = nil;
		return;
	}
}

@end
