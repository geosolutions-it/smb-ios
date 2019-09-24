//
//  UploadManager.m
//  SaveMyBike
//
//  Created by Szymon Tomasz Stefanek on 16/08/2019.
//  Copyright © 2019 GeoSolutions SaS. All rights reserved.
//

#import "UploadManager.h"

#import "Config.h"
#import "STSCore.h"
#import "STSDelegateArray.h"
#import "Tracker.h"
#import "TrackingSession.h"
#import "TrackingSessionPoint.h"
#import "STSSQLSelectQueryBuilder.h"
#import "STSSQLUpdateQueryBuilder.h"
#import "STSDBConnection.h"
#import "Database.h"
#import "AuthManager.h"
#import "BackendRequestUploadFile.h"
#import "Globals.h"
#import "SSZipArchive.h"
#import "STSFile.h"
#import "STSNetworkAvailabilityChecker.h"
#import "STSI18n.h"

static UploadManager * g_pUploadManager = nil;

@interface UploadManager()<BackendRequestDelegate>
{
	NSString * m_sDataRoot;
	STSDelegateArray * m_pStateObservers;
	NSTimer * m_pTimer;
	NSString * m_sCurrentZipFile;
	TrackingSession * m_pSessionBeingUploaded;
	BackendRequestUploadFile * m_pUploadFileRequest;
}
@end

@implementation UploadManager

- (void)initializeWithDataPath:(NSString *)sPath
{
	m_sDataRoot = sPath;
	if(![STSFile createDirectoryIfMissing:m_sDataRoot])
	{
		STS_CORE_LOG_ERROR(@"Failed to create root directory at %@: expect trouble",m_sDataRoot);
	}
	m_pStateObservers = [STSDelegateArray new];
	m_pTimer = nil;
	m_pUploadFileRequest = nil;
	
	// FIXME: Cleanup directory for stale *zip and *csv files?
	
	[self _cleanupDatabase];
	[self _restartTimerWithTimeout:30.0];
}

- (void)cleanup
{
	[m_pTimer invalidate];
	m_pTimer = nil;
	[m_pStateObservers removeAllDelegates];

	m_pStateObservers = nil;
}

+ (void)createWithDataPath:(NSString *)sPath
{
	g_pUploadManager = [UploadManager new];
	[g_pUploadManager initializeWithDataPath:sPath];
}

+ (void)destroy
{
	if(g_pUploadManager)
		[g_pUploadManager cleanup];
	g_pUploadManager = nil;
}

- (void)_triggerDelegates
{
	if(m_pStateObservers.count < 1)
		return;

	[m_pStateObservers performSelectorOnAllDelegates:@selector(onUploadManagerChangedSessionState)];
}

- (void)_cleanupDatabase
{
	// Fail running sessions
	STSSQLUpdateQueryBuilder * qb = [[Database instance].connection createUpdateQueryBuilder];

	[qb setTableName:[TrackingSession SQLTableName]];

	[qb addValue:[TrackingSessionStateEnumHelpers idFromEnum:TrackingSessionState_Error] forField:[TrackingSession SQLFieldStateName] withType:STSSQLOperandType_VarCharConstant];
	[qb addValue:@"Data gathering aborted" forField:[TrackingSession SQLFieldStateName] withType:STSSQLOperandType_TextConstant];
	
	[qb.where
		 	addConditionWithField:[TrackingSession SQLFieldStateName]
		 		operator:STSSQLOperator_IsEqualTo
	 			rightObject:[TrackingSessionStateEnumHelpers idFromEnum:TrackingSessionState_Running]
	 			rightType:STSSQLOperandType_VarCharConstant
		];
	
	[[Database instance].connection execute:[qb build]];
	

	// Restore sessions with interrupted uploads
	qb = [[Database instance].connection createUpdateQueryBuilder];
	
	[qb setTableName:[TrackingSession SQLTableName]];
	
	[qb addValue:[TrackingSessionStateEnumHelpers idFromEnum:TrackingSessionState_Complete] forField:[TrackingSession SQLFieldStateName] withType:STSSQLOperandType_VarCharConstant];
	
	[qb.where
			addConditionWithField:[TrackingSession SQLFieldStateName]
				operator:STSSQLOperator_IsEqualTo
				rightObject:[TrackingSessionStateEnumHelpers idFromEnum:TrackingSessionState_InUpload]
				rightType:STSSQLOperandType_VarCharConstant
		];
	
	[[Database instance].connection execute:[qb build]];


	
	// FIXME: Remove also sessions that have been uploaded quite long time ago
	// FIXME: Remove also sessions that are in error and have been started long time ago
	
	[self _triggerDelegates];
}

+ (UploadManager *)instance
{
	return g_pUploadManager;
}

- (void)addStateObserver:(__weak id<UploadManagerStateObserver>)pObserver
{
	[m_pStateObservers addDelegate:pObserver];
}

- (void)removeStateObserver:(__weak id<UploadManagerStateObserver>)pObserver
{
	[m_pStateObservers removeDelegate:pObserver];
}

- (void)_restartTimerWithTimeout:(double)dSecs
{
	if(m_pTimer)
		[m_pTimer invalidate];
	m_pTimer = [NSTimer scheduledTimerWithTimeInterval:dSecs target:self selector:@selector(_onTimeout) userInfo:nil repeats:true];
}

- (TrackingSession *)_fetchFirstTrackingSessionToUpload
{
	STSSQLSelectQueryBuilder * qb = [[Database instance].connection createSelectQueryBuilder];

	[qb setTableName:[TrackingSession SQLTableName]];
	[qb.where
	 		addConditionWithField:[TrackingSession SQLFieldStateName]
	 		operator:STSSQLOperator_IsEqualTo
	 		rightObject:[TrackingSessionStateEnumHelpers idFromEnum:TrackingSessionState_Complete]
	 		rightType:STSSQLOperandType_VarCharConstant
		];
	[qb addOrderBy:[TrackingSession SQLFieldEndDateTimeName]];

	qb.limit = 1;
	
	return [TrackingSession dbFetchOneBySQL:[qb build] fromDatabase:[Database instance].connection];
}

- (NSString *)_createZip:(TrackingSession *)pSession
{
	STSSQLSelectQueryBuilder * qb = [[Database instance].connection createSelectQueryBuilder];
	
	[qb setTableName:[TrackingSessionPoint SQLTableName]];
	[qb.where
		addConditionWithField:[TrackingSessionPoint SQLFieldSessionIdName]
			operator:STSSQLOperator_IsEqualTo
			rightObject:[NSNumber numberWithLong:pSession.id]
			rightType:STSSQLOperandType_Int64Constant
		];
	[qb addOrderBy:[TrackingSessionPoint SQLFieldTimeStampName]];

	NSMutableArray<TrackingSessionPoint *> * pPoints = [TrackingSessionPoint dbFetchListBySQL:qb.build fromDatabase:[Database instance].connection];
	if(!pPoints)
	{
		STS_CORE_LOG_ERROR(@"Failed to load session points: %@",[Database instance].connection.errorStack.buildMessage);
		return [NSString stringWithFormat:@"Failed to load session: %@",[Database instance].connection.errorStack.buildMessage];
	}
	
	if(pPoints.count < 1)
		return @"Session has no data points";
	
	[STSFile createDirectoryIfMissing:m_sDataRoot];
	
	NSString * sCSVPath = [m_sDataRoot stringByAppendingPathComponent:[NSString stringWithFormat:@"dataPoints_%ld.txt",pSession.id]];
	
	// OH-MY-GOD-API
	[[NSFileManager defaultManager] createFileAtPath:sCSVPath contents:nil attributes:nil];
	
	NSFileHandle * fh = [NSFileHandle fileHandleForWritingAtPath:sCSVPath];
	if(!fh)
	{
		[STSFile removeFile:sCSVPath];
		return [NSString stringWithFormat:@"Failed to create file at %@",sCSVPath];
	}
	
	// WRITE CSV
	
	/*

	 Android generates this:
	 
	 accelerationX,accelerationY,accelerationZ,accuracy,batConsumptionPerHour,batteryLevel,deviceBearing,devicePitch,deviceRoll,elevation,gps_bearing,humidity,latitude,longitude,lumen,pressure,proximity,sessionId,speed,temperature,timeStamp,vehicleMode,serialVersionUID,
	 2.5332336,7.8583527,5.2761536,15.0,0.0,0.0,9.594292,32.679016,18.247766,0.0,0.0,0.0,43.71035385131836,10.403990745544434,96.0,0.0,5.000305,1566359551464,6.0,0.0,1566359554521,1,0,
	 2.2834473,7.804886,5.1931458,15.0,0.0,0.0,9.254437,30.579226,18.913109,0.0,0.0,0.0,43.71065139770508,10.404191017150879,96.0,0.0,5.000305,1566359551464,6.0,0.0,1566359555323,1,0,
	 2.5819244,7.86792,4.74942,15.0,0.0,0.0,9.485145,32.333965,19.593266,0.0,0.0,0.0,43.71095275878906,10.404391288757324,96.0,0.0,5.000305,1566359551464,6.0,0.0,1566359556125,1,0,
	 2.7982025,7.87352,5.227463,15.0,0.0,0.0,9.564074,31.452843,19.538626,0.0,0.0,0.0,43.71125411987305,10.404590606689453,96.0,0.0,5.000305,1566359551464,6.0,0.0,1566359556927,1,0,
	 2.6489716,7.778549,5.3056793,15.0,0.0,0.0,9.7032175,32.779224,19.246,0.0,0.0,0.0,43.71185302734375,10.404991149902344,96.0,0.0,5.000305,1566359551464,6.0,0.0,1566359558529,1,0,
	 2.5763397,7.796097,5.448532,15.0,0.0,0.0,9.9510565,33.25166,18.224228,0.0,0.0,0.0,43.712154388427734,10.405191421508789,96.0,0.0,5.000305,1566359551464,6.0,0.0,1566359559331,1,0,
	 
	 ...so do we.
	 
	 */
	
	NSString * sData = @"accelerationX,accelerationY,accelerationZ,accuracy,batConsumptionPerHour,batteryLevel,deviceBearing,devicePitch,deviceRoll,elevation,gps_bearing,humidity,latitude,longitude,lumen,pressure,proximity,sessionId,speed,temperature,timeStamp,vehicleMode,serialVersionUID,\n";
	NSData * pData = [sData dataUsingEncoding:NSUTF8StringEncoding];
	
	@try {
		[fh writeData:pData];
	}
	@catch(NSException * e)
	{
		// OH-MY-GOD
		[fh closeFile];
		[STSFile removeFile:sCSVPath];
		return [NSString stringWithFormat:@"Failed to write to file at %@",sCSVPath];
	}

	for(TrackingSessionPoint * pnt in pPoints)
	{
		sData = [NSString stringWithFormat:@"%f,%f,%f,%f,%f,%d.0,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%ld,%f,%f,%ld,%d,%d,\n",
				pnt.accelerationX,
				pnt.accelerationY,
				pnt.accelerationZ,
				pnt.accuracy,
				pnt.batteryConsumptionPerHour,
				pnt.batteryLevel,
				pnt.deviceBearing,
				pnt.devicePitch,
				pnt.deviceRoll,
				pnt.elevation,
				pnt.gps_bearing,
				pnt.humidity,
				pnt.latitude,
				pnt.longitude,
				pnt.lumen,
				pnt.pressure,
				pnt.proximity,
				pnt.sessionId,
				pnt.speed,
				pnt.temperature,
				pnt.timeStamp,
				pnt.vehicleMode,
				0
			];

		pData = [sData dataUsingEncoding:NSUTF8StringEncoding];
	
		@try {
			[fh writeData:pData];
		}
		@catch(NSException * e)
		{
			// OH-MY-GOD
			[fh closeFile];
			[STSFile removeFile:sCSVPath];
			return [NSString stringWithFormat:@"Failed to write to file at %@",sCSVPath];
		}
	}

	[fh closeFile];

	NSString * sZIPPath = [m_sDataRoot stringByAppendingPathComponent:[NSString stringWithFormat:@"data_%ld.zip",pSession.id]];
	
	NSMutableArray * aFiles = [NSMutableArray new];
	[aFiles addObject:sCSVPath];
	
	if(![SSZipArchive createZipFileAtPath:sZIPPath withFilesAtPaths:aFiles])
	{
		[STSFile removeFile:sCSVPath];
		[STSFile removeFile:sZIPPath];
		return [NSString stringWithFormat:@"Failed to create zip file at %@",sZIPPath];
	}

	[STSFile removeFile:sCSVPath];

	m_sCurrentZipFile = sZIPPath;

	return nil;
}

- (void)startUploadIfNotRunning
{
	if(m_pTimer)
	{
		[m_pTimer invalidate];
		m_pTimer = nil;
	}

	STS_CORE_LOG(@"Start upload if not running...");
	
	if([AuthManager instance].state != AuthManagerStateLoggedIn)
	{
		STS_CORE_LOG(@"Not logged in");
		[self _restartTimerWithTimeout:10.0];
		return;
	}
	
	if(m_pUploadFileRequest)
	{
		STS_CORE_LOG(@"Request already pending");
		[self _restartTimerWithTimeout:30.0];
		return;
	}
	
	if(![STSNetworkAvailabilityChecker networkAvailable])
	{
		STS_CORE_LOG(@"Network not avaialble");
		[self _restartTimerWithTimeout:10.0];
		return;
	}
	
	TrackingSession * pSession = [self _fetchFirstTrackingSessionToUpload];
	if(!pSession)
	{
		if([[Database instance].connection.errorStack isEmpty])
		{
			STS_CORE_LOG_ERROR(@"No sessions to upload");
			// do NOT restart the timer. It will be restarted at startup or when a new session is completed.
		} else {
			STS_CORE_LOG_ERROR(@"Failed to load session: %@",[Database instance].connection.errorStack.buildMessage);
			[self _restartTimerWithTimeout:30.0];
		}
		return;
	}
	
	// This can be made async if it turns out to be slow
	NSString * sError = [self _createZip:pSession];
	
	if(sError)
	{
		STS_CORE_LOG_ERROR(@"Failed to create zip: %@",sError);
		[self _sessionUploadFailed:pSession withError:sError isCritical:false];
		[self _restartTimerWithTimeout:30.0];
		[self _triggerDelegates];
		return;
	}

	//m_sCurrentZipFile = [[m_sCurrentZipFile stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"data_1566401768913.zip"];
	
	NSData * oData = [NSData dataWithContentsOfFile:m_sCurrentZipFile];
	if(!oData)
	{
		STS_CORE_LOG_ERROR(@"Failed to load zip contents");
		[self _sessionUploadFailed:pSession withError:@"Failed to load zip" isCritical:false];
		[STSFile removeFile:m_sCurrentZipFile];
		m_sCurrentZipFile = nil;
		[self _restartTimerWithTimeout:30.0];
		[self _triggerDelegates];
		return;
	}

	m_pUploadFileRequest = [BackendRequestUploadFile new];
	m_pUploadFileRequest.fileName = [m_sCurrentZipFile lastPathComponent];
	m_pUploadFileRequest.file = oData;
	[m_pUploadFileRequest setBackendRequestDelegate:self];
	
	m_pSessionBeingUploaded = pSession;
	
	if(![m_pUploadFileRequest start])
	{
		STS_CORE_LOG_ERROR(@"Failed to start upload request");
		[self _sessionUploadFailed:pSession withError:@"Failed to start upload" isCritical:false];
		[STSFile removeFile:m_sCurrentZipFile];
		m_sCurrentZipFile = nil;
		m_pUploadFileRequest = nil;
		[self _restartTimerWithTimeout:30.0];
		[self _triggerDelegates];
		return;
	}

	m_pSessionBeingUploaded.state = TrackingSessionState_InUpload;
	if(![m_pSessionBeingUploaded dbUpdateInDatabase:[Database instance].connection])
	{
		// not critical... attempt to continue
		STS_CORE_LOG_ERROR(@"Failed to mark session as being uploaded: %@",[Database instance].connection.errorStack.buildMessage);
	}

	[self _triggerDelegates];
}

- (void)backendRequestCompleted:(BackendRequest *)pRequest
{
	if(m_pUploadFileRequest != pRequest)
	{
		STS_CORE_LOG_ERROR(@"Wrong upload request?");
		return;
	}
	
	if(m_pUploadFileRequest.succeeded)
	{
		STS_CORE_LOG_ERROR(@"Session upload succeeded");
		m_pSessionBeingUploaded.state = TrackingSessionState_Uploaded;
		if(![m_pSessionBeingUploaded dbUpdateInDatabase:[Database instance].connection])
		{
			STS_CORE_LOG_ERROR(@"Failed to mark session as uploaded: %@",[Database instance].connection.errorStack.buildMessage);
			// Try to mark it as error or delete it, to avoid re-uploading
			[self _sessionUploadFailed:m_pSessionBeingUploaded withError:@"Failed to mark session as uploaded" isCritical:true];
		}

		[self _restartTimerWithTimeout:1.0];
	} else {
		STS_CORE_LOG_ERROR(@"Session upload failed: %@",m_pUploadFileRequest.error);

		// First of all re-mark as complete
		m_pSessionBeingUploaded.state = TrackingSessionState_Complete;
		if(![m_pSessionBeingUploaded dbUpdateInDatabase:[Database instance].connection])
		{
			// not critical... attempt to continue
			STS_CORE_LOG_ERROR(@"Failed to mark session as being uploaded: %@",[Database instance].connection.errorStack.buildMessage);
		}
	
		// This one will mark the session as failed if the upload attempt count is too high
		[self _sessionUploadFailed:m_pSessionBeingUploaded withError:m_pUploadFileRequest.error isCritical:false];
		[self _restartTimerWithTimeout:60.0];
	}
	
	[STSFile removeFile:m_sCurrentZipFile];
	
	m_sCurrentZipFile = nil;
	m_pSessionBeingUploaded = nil;
	m_pUploadFileRequest = nil;
	[self _triggerDelegates];
}

- (void)_sessionUploadFailed:(TrackingSession *)pSession withError:(NSString *)sError isCritical:(BOOL)bCritical
{
	if((pSession.uploadAttempts < 10) && (!bCritical))
	{
		STS_CORE_LOG_ERROR(@"Error is not critical and upload attempts are less than 10: will retry");
		
		pSession.uploadAttempts = pSession.uploadAttempts + 1;
		pSession.error = __tr(@"upload failed - will rery");
		
		if([pSession dbUpdateInDatabase:[Database instance].connection])
			return;
	
		STS_CORE_LOG_ERROR(@"Failed to update broken session: %@",[Database instance].connection.errorStack.buildMessage);
		return;
	}
	
	STS_CORE_LOG_ERROR(@"Marking session as broken");
	
	pSession.state = TrackingSessionState_Error;
	pSession.error = sError;

	if(![pSession dbUpdateInDatabase:[Database instance].connection])
	{
		STS_CORE_LOG_ERROR(@"Failed to update broken session: %@",[Database instance].connection.errorStack.buildMessage);
		// This is kind of critical!
		
		if(![pSession dbDeleteFromDatabase:[Database instance].connection])
		{
			// Super critical... 
			STS_CORE_LOG_ERROR(@"Failed to delete session: %@",[Database instance].connection.errorStack.buildMessage);
		} else {
			if(![TrackingSessionPoint dbDeleteBySessionId:pSession.id fromDatabase:[Database instance].connection])
			{
				STS_CORE_LOG_ERROR(@"Failed to delete session data points, db will remain dirty: %@",[Database instance].connection.errorStack.buildMessage);
			}
		}
	}
}

- (void)_onTimeout
{
	[self startUploadIfNotRunning];
}



@end
