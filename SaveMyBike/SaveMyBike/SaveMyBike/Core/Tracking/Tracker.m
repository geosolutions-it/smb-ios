//
//  Tracker.m
//  SaveMyBike
//
//  Created by Szymon Tomasz Stefanek on 16/07/2019.
//  Copyright © 2019 GeoSolutions SaS. All rights reserved.
//

#import "Tracker.h"

#import "STSGeoLocalizer.h"
#import "Globals.h"
#import "TrackingSessionPoint.h"
#import "Database.h"
#import "STSDBConnection.h"
#import "STSErrorStack.h"
#import "STSSQLUpdateQueryBuilder.h"
#import "STSSQLSelectQueryBuilder.h"
#import "UploadManager.h"
#import "STSCore.h"
#import "Vehicle.h"

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>


static Tracker * g_pTracker = nil;

@interface Tracker()<STSGeoLocalizerDelegate>
{
	NSTimer * m_pSimulationTimer;
	CLLocation * m_pLastLocation;
	CMMotionManager * m_pMotionManager;
	long m_tLastLocationUpdate;
	long m_lMinimumLocationUpdateTime;
}

@end

@implementation Tracker

- (id)init
{
	self = [super init];
	if(!self)
		return nil;
	
	m_pSimulationTimer = nil;
	m_tLastLocationUpdate = 0;
	m_lMinimumLocationUpdateTime = 1000;
	
	m_pMotionManager = [CMMotionManager new];

	[STSGeoLocalizer create];
	[[STSGeoLocalizer instance] addDelegate:self];
		
	return self;
}

- (void)_coreDestroy
{
	if(_session)
		[self stopTrackingSession];

	if(m_pSimulationTimer)
	{
		[m_pSimulationTimer invalidate];
		m_pSimulationTimer = nil;
	}

	m_pMotionManager = nil;
	
	[[STSGeoLocalizer instance] removeDelegate:self];
	[STSGeoLocalizer destroy];
}

- (void)onGeoLocalizer:(id)l didUpdateLocation:(NSArray<CLLocation *> *)loc
{
	if(!_session)
	{
		[[STSGeoLocalizer instance] deactivate];
		return;
	}

	if(!loc)
		return; // ?
	
	
	for(CLLocation * l in loc)
	{
		double dTimestamp = [l.timestamp timeIntervalSince1970];
		
		long timeStamp = (long)(dTimestamp * 1000.0);
		
		if(timeStamp <= _currentPoint.timeStamp)
		{
			STS_CORE_LOG(@"Location update carries a timestamp that is the same as the last one or in the past (%ld < %ld)",timeStamp,_currentPoint.timeStamp);
			continue;
		}
		
		long lTimeDiff = timeStamp - m_tLastLocationUpdate;
		if(lTimeDiff < m_lMinimumLocationUpdateTime)
		{
			STS_CORE_LOG(@"Location update carries a timestamp that is less than a second from the last one (%ld < %ld)",timeStamp,m_tLastLocationUpdate);
			continue;
		}
		
		m_tLastLocationUpdate = timeStamp;
		
		if(
			(fabs(_currentPoint.latitude - l.coordinate.latitude) < 0.000001) &&
			(fabs(_currentPoint.longitude - l.coordinate.longitude) < 0.000001) &&
			(fabs(_currentPoint.elevation  - l.altitude) < 0.5) &&
			(fabs(_currentPoint.speed - l.speed) < 1.0) &&
			(fabs(_currentPoint.gps_bearing - l.course) < 1.0)
		)
		{
			STS_CORE_LOG(@"Location update didn't change location much: ignoring");
			continue;
		}
	
		if(m_pLastLocation)
		{
			double dDist = [m_pLastLocation distanceFromLocation:l];
			if(dDist < 0.0)
				dDist = -dDist; // ?
			_currentDistance += dDist;
		}
		
		m_pLastLocation = l;

		_currentPoint.timeStamp = timeStamp;
		_currentPoint.latitude = l.coordinate.latitude;
		_currentPoint.longitude = l.coordinate.longitude;
		_currentPoint.elevation = l.altitude;
		_currentPoint.speed = l.speed;
		_currentPoint.gps_bearing = l.course;
		
		[self _storePoint];
	}
	
}

- (void)onSimulationTimeout
{
	long timeStamp = (long)([[NSDate date] timeIntervalSince1970] * 1000.0);
	
	if(timeStamp <= _currentPoint.timeStamp)
	{
		// ????
		STS_CORE_LOG(@"Simulated location update carries a timestamp that is the same as the last one or in the past (%ld < %ld)",timeStamp,_currentPoint.timeStamp);
		return;
	}
	
	_currentPoint.timeStamp = timeStamp;

	double ra = ((double)((rand() % 1000) - 500)) / 1000.0;
	_currentPoint.elevation += ra;
	if(_currentPoint.elevation < 0.0)
		_currentPoint.elevation = 0.0;
	else if(_currentPoint.elevation > 3000.0)
		_currentPoint.elevation = 3000.0;

	double rs = ((double)((rand() % 1000) - 500)) / 1000.0;
	_currentPoint.speed += rs;
	if(_currentPoint.speed < 0.0)
		_currentPoint.speed = 0.0;
	else if(_currentPoint.speed > 100.0)
		_currentPoint.speed = 100.0;

	// lat -> 111111 m is 1 degree
	// lon -> 111111 m * cos(lat) is 1 degree
	
	// so 11111.1m is 0.1 degree
	// so 1111.11m is 0.01
	// so 111.111m is 0.001
	// so 11.1111m is 0.0001 deg
	
	double rlat = ((double)((rand() % 10000) - 5000)) / 10000000.0;
	_currentPoint.latitude += rlat;

	double rlon = ((double)((rand() % 10000) - 5000)) / 10000000.0;
	_currentPoint.longitude += rlon;
	
	CLLocation * l = [[CLLocation alloc] initWithLatitude:_currentPoint.latitude longitude:_currentPoint.longitude];
	
	if(m_pLastLocation)
	{
		double dDist = [m_pLastLocation distanceFromLocation:l];
		if(dDist < 0.0)
			dDist = -dDist; // ?
		_currentDistance += dDist;
	}
	
	m_pLastLocation = l;

	_currentPoint.proximity = 0.0;
	
	[self _storePoint];
}

- (void)setCurrentVehicleType:(VehicleType)eType
{
	if(!_session)
		return;
	
	if(_currentPoint.vehicleMode == (int)eType)
		return;
	
	_currentPoint.timeStamp = (long)([[NSDate date] timeIntervalSince1970] * 1000.0);
	_currentPoint.vehicleMode = eType;
	
	// reactivate
	[[STSGeoLocalizer instance] deactivate];
	[self _activateGeoLocalizer];
	
	[self _storePoint];
}

- (void)_activateGeoLocalizer
{
	VehicleType eType = (VehicleType)_currentPoint.vehicleMode;
	
	double dMinDistance = [Vehicle minimumGPSDistanceForVehicleType:eType];
	
	[[STSGeoLocalizer instance] setMinimumInterEventDistance:dMinDistance];
	[[STSGeoLocalizer instance] setEnableBackgroundUpdates:true];

	switch(eType)
	{
		case VehicleTypeCar:
			[[STSGeoLocalizer instance] setActivityType:CLActivityTypeAutomotiveNavigation];
			break;
		case VehicleTypeBus:
		case VehicleTypeTrain:
		case VehicleTypeMotorcycle:
			[[STSGeoLocalizer instance] setActivityType:CLActivityTypeOtherNavigation];
			break;
		case VehicleTypeFoot:
		case VehicleTypeBike:
			[[STSGeoLocalizer instance] setActivityType:CLActivityTypeFitness];
			break;
	}
	
	[[STSGeoLocalizer instance] activate];
}

- (void)_storePoint
{
	if(!m_pLastLocation)
	{
		STS_CORE_LOG(@"Have no location yet: cannot store point");
		return; // no location yet
	}
	
	_currentPoint.proximity = [UIDevice currentDevice].proximityState ? 0.0 : 100.0;

	if(m_pMotionManager.accelerometerData)
	{
		_currentPoint.accelerationX = m_pMotionManager.accelerometerData.acceleration.x * 9.8;
		_currentPoint.accelerationY = m_pMotionManager.accelerometerData.acceleration.y * 9.8;
		_currentPoint.accelerationZ = m_pMotionManager.accelerometerData.acceleration.z * 9.8;
	}

	STS_CORE_LOG(
				 @"Storing point time=%ld lat=%f, lon=%f, elev=%f, accelX=%f, accelY=%f, accelZ=%f",
				 _currentPoint.timeStamp,
				 _currentPoint.latitude,
				 _currentPoint.longitude,
				 _currentPoint.elevation,
				 _currentPoint.accelerationX,
				 _currentPoint.accelerationY,
				 _currentPoint.accelerationZ
		);
	
	if(![_currentPoint dbInsertToDatabase:[Database instance].connection])
	{
		// aargh
		STS_CORE_LOG(@"Failed to insert point: %@",[Database instance].connection.errorStack.buildMessage);
	}
}


- (TrackingSession *)startTrackingSessionWithVehicleType:(VehicleType)eType
{
	if(_session)
		return _session; // already tracking
	_session = [TrackingSession new];

	_session.userId = [Globals instance].userData.username;
	_session.startDateTime = [NSDate date];
	_session.state = TrackingSessionState_Running;
	_session.uploadAttempts = 0;
	
	_session.id = (long)([_session.startDateTime timeIntervalSince1970] * 1000.0);
	
	if(![_session dbInsertToDatabase:[Database instance].connection])
	{
		// aargh!
		STS_CORE_LOG_ERROR(@"Failed to insert session into db: %@",[Database instance].connection.errorStack.buildMessage);
		_session = nil;
		return nil;
	}
	
	_currentPoint = [TrackingSessionPoint new];

	_currentPoint.sessionId = _session.id;
	_currentPoint.vehicleMode = (int)eType;
	_currentPoint.accuracy = 15.0; // ?????
	
	m_pLastLocation = nil;
	m_tLastLocationUpdate = 0.0;

	[[UIDevice currentDevice] setProximityMonitoringEnabled:true];
	
	_currentDistance = 0.0;
	
	//_session.points = [NSMutableArray new];
	if([Globals instance].simulateGPS)
	{
		m_pSimulationTimer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(onSimulationTimeout) userInfo:nil repeats:true];

		_currentPoint.timeStamp = (long)([_session.startDateTime timeIntervalSince1970] * 1000.0);
		_currentPoint.latitude = 43.42215;
		_currentPoint.longitude = 10.384571;
		_currentPoint.elevation = 600;
		_currentPoint.speed = 0;
		_currentPoint.gps_bearing = 0;
		
		_currentPoint.accelerationX = 0.39840698;
		_currentPoint.accelerationY = -0.36653137;
		_currentPoint.accelerationZ = 9.870621;
		
		_currentPoint.deviceBearing = 211.27327;
		_currentPoint.devicePitch = 86.78082;
		_currentPoint.deviceRoll = 132.67207;

		m_pLastLocation = [[CLLocation alloc] initWithLatitude:_currentPoint.latitude longitude:_currentPoint.longitude];

		[self _storePoint];
	} else {
		[self _activateGeoLocalizer];
	}
	
	if([m_pMotionManager isAccelerometerAvailable])
	{
		m_pMotionManager.accelerometerUpdateInterval = 0.5; // 2Hz
		[m_pMotionManager startAccelerometerUpdates];
	}
	
	return _session;
}

- (TrackingSession *)stopTrackingSession
{
	if(!_session)
		return nil;

	[[STSGeoLocalizer instance] deactivate];

	[[UIDevice currentDevice] setProximityMonitoringEnabled:false];

	[m_pMotionManager stopAccelerometerUpdates];
	
	if(m_pSimulationTimer)
	{
		[m_pSimulationTimer invalidate];
		m_pSimulationTimer = nil;
	}

	_session.endDateTime = [NSDate date];
	_session.state = TrackingSessionState_Complete;

	if(![_session dbUpdateInDatabase:[Database instance].connection])
	{
		// aargh!
		STS_CORE_LOG_ERROR(@"Failed to insert session into db: %@",[Database instance].connection.errorStack.buildMessage);
		_session = nil;
		return nil;
	}

	[[UploadManager instance] startUploadIfNotRunning];
	
	TrackingSession * s = _session;
	_session = nil;
	return s;
}

+ (Tracker *)instance
{
	return g_pTracker;
}

+ (void)create
{
	if(g_pTracker)
		return;
	g_pTracker = [Tracker new];
}

+ (void)destroy
{
	if(!g_pTracker)
		return;
	[g_pTracker _coreDestroy];
	g_pTracker = nil;
}

@end
