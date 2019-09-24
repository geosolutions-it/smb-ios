//==================================================================================
//
//  Created by Szymon Tomasz Stefanek
//  Copyright © 2017 Szymon Tomasz Stefanek. All rights reserved.
//
//==================================================================================


#import "STSGeoLocalizer.h"

#import "STSCore.h"
#import "STSDelegateArray.h"

static STSGeoLocalizer * g_pSTSGeoLocalizerSingleton = nil;

@interface STSGeoLocalizer()<CLLocationManagerDelegate>
{
	CLLocationManager * m_pManager;
	STSGeoLocalizerState m_eState;
	NSTimer * m_pTimer;
	bool m_bEnableBackgroundUpdates;
	STSDelegateArray * m_pDelegates;
}

@end


@implementation STSGeoLocalizer

- (id)init
{
	self = [super init];
	if(!self)
		return nil;
	
	return self;
}

- (void)_coreCreate;
{
	m_pManager = [CLLocationManager new];
	m_pManager.delegate = self;
	m_eState = STSGeoLocalizerStateInactive;
	m_pDelegates = [STSDelegateArray new];
	m_bEnableBackgroundUpdates = false;
}

- (void)_coreDestroy;
{
	[self deactivate];
	if(m_pDelegates)
	{
		[m_pDelegates removeAllDelegates];
		m_pDelegates = nil;
	}
	if(m_pTimer)
	{
		[m_pTimer invalidate];
		m_pTimer = nil;
	}
	m_pManager.delegate = nil;
	m_pManager = nil;
}

+ (STSGeoLocalizer *)instance;
{
	return g_pSTSGeoLocalizerSingleton;
}

+ (void)create
{
	if(g_pSTSGeoLocalizerSingleton)
	{
		return;
	}
	g_pSTSGeoLocalizerSingleton = [STSGeoLocalizer new];
	[g_pSTSGeoLocalizerSingleton _coreCreate];
}

+ (void)destroy;
{
	if(!g_pSTSGeoLocalizerSingleton)
	{
		return;
	}
	[g_pSTSGeoLocalizerSingleton _coreDestroy];
	g_pSTSGeoLocalizerSingleton = nil;
}

- (void)setMinimumInterEventDistance:(double)dMeters
{
	m_pManager.distanceFilter = dMeters;
}

- (void)setActivityType:(CLActivityType)eActivityType
{
	m_pManager.activityType = eActivityType;
}

- (void)setEnableBackgroundUpdates:(bool)bEnable
{
	m_bEnableBackgroundUpdates = bEnable;
}

- (void)addDelegate:(id<STSGeoLocalizerDelegate>)d
{
	[m_pDelegates addDelegate:d];
}

- (void)removeDelegate:(id<STSGeoLocalizerDelegate>)d
{
	[m_pDelegates removeDelegate:d];
}

- (void)tryActivate
{
	if(m_pTimer)
	{
		[m_pTimer invalidate];
		m_pTimer = nil;
	}
	
	if([CLLocationManager locationServicesEnabled])
	{
		switch([CLLocationManager authorizationStatus])
		{
			case kCLAuthorizationStatusAuthorizedAlways:
			case kCLAuthorizationStatusAuthorizedWhenInUse:
				// the application is able to use localization services
				STS_CORE_LOG(@"Location authorization status authorized");
				m_eState = STSGeoLocalizerStateActive;
				m_pManager.desiredAccuracy = kCLLocationAccuracyBest;
				if(m_bEnableBackgroundUpdates)
				{
					m_pManager.pausesLocationUpdatesAutomatically = false;
					m_pManager.allowsBackgroundLocationUpdates = true;
					m_pManager.showsBackgroundLocationIndicator = true;
				} else {
					m_pManager.pausesLocationUpdatesAutomatically = true;
					m_pManager.allowsBackgroundLocationUpdates = false;
					m_pManager.showsBackgroundLocationIndicator = false;
				}
				[m_pManager startUpdatingLocation];
				return;
			break;
			case kCLAuthorizationStatusDenied:
				// the user has choosen to deny the access to localization sevices
				STS_CORE_LOG(@"Location authorization status denied");
			break;
			case kCLAuthorizationStatusRestricted:
				// the localization services availability is restricted by (ie) parental control
				// the user is not asked to enable the services
				STS_CORE_LOG(@"Location authorization status restricted");
			break;
			case kCLAuthorizationStatusNotDetermined:
				// mostly liked caused by localization service not availble or user preference not expressed
				if(m_eState == STSGeoLocalizerStateActivating)
				{
					STS_CORE_LOG(@"Location authorization status not determined: asking user for permission");
					m_eState = STSGeoLocalizerStateRequestingPermission;
					[m_pManager requestWhenInUseAuthorization];
				} else {
					STS_CORE_LOG(@"Location authorization status not determined: already asked user for permission?");
				}
			break;
			default:
				STS_CORE_LOG(@"Location authorization status unhandled");
			break;
		}
	} else {
		STS_CORE_LOG(@"Location services disabled");
	}

	m_pTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(onTimeout:) userInfo:nil repeats:false];
}


- (void)activate
{
	switch(m_eState)
	{
		case STSGeoLocalizerStateInactive:
			m_eState = STSGeoLocalizerStateActivating;
			[self tryActivate];
		break;
		case STSGeoLocalizerStateActivating:
		case STSGeoLocalizerStateRequestingPermission:
			// wait.
		break;
		case STSGeoLocalizerStateActive:
			// already active
		break;
		default:
			// BUG
		break;
	}
}

- (void)deactivate
{
	if(m_pTimer)
	{
		[m_pTimer invalidate];
		m_pTimer = nil;
	}
	
	switch(m_eState)
	{
		case STSGeoLocalizerStateInactive:

		break;
		case STSGeoLocalizerStateActivating:
		case STSGeoLocalizerStateRequestingPermission:
			
		break;
		case STSGeoLocalizerStateActive:
			[m_pManager stopUpdatingLocation];
		break;
		default:
			// BUG
		break;
	}
	
	m_eState = STSGeoLocalizerStateInactive;
}

- (void)onTimeout:(id)crap
{
	switch(m_eState)
	{
		case STSGeoLocalizerStateInactive:
			// shouldn't be here!
		break;
		case STSGeoLocalizerStateActivating:
		case STSGeoLocalizerStateRequestingPermission:
			[self tryActivate];
		break;
		case STSGeoLocalizerStateActive:
			// nothing
		break;
		default:
			// BUG
		break;
	}
}

- (STSGeoLocalizerState)state
{
	return m_eState;
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
	STS_CORE_LOG_ERROR(@"Location manager failed: %@",[error localizedDescription]);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
	//STS_CORE_LOG(@"Manager did update location!");
	if(m_pDelegates.count < 1)
		return;
	[m_pDelegates performSelectorOnAllDelegates:@selector(onGeoLocalizer:didUpdateLocation:) withObject:self withObject:locations];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
	STS_CORE_LOG(@"Authorization status changed");
	[self tryActivate];
}

- (CLLocation *)lastKnownLocation
{
	switch(m_eState)
	{
		case STSGeoLocalizerStateActive:
			return m_pManager.location;
		break;
		case STSGeoLocalizerStateActivating:
		case STSGeoLocalizerStateRequestingPermission:
		case STSGeoLocalizerStateInactive:
		default:
			return nil;
		break;
	}
}

@end

