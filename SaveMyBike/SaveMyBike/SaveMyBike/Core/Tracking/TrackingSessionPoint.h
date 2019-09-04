#import <Foundation/Foundation.h>

@class STSDBConnection;
@class STSDBRecordset;
@class STSSQLCreateTableQueryBuilder;
@class STSSQLDeleteQueryBuilder;
@class STSSQLDropTableQueryBuilder;
@class STSSQLFieldInfo;
@class STSSQLInsertQueryBuilder;
@class STSSQLSelectQueryBuilder;
@class STSSQLUpdateQueryBuilder;

@interface TrackingSessionPoint : NSObject

	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	// Getters and Setters
	///////////////////////////////////////////////////////////////////////////////////////////////////////////

	- (long)sessionId;
	- (void)setSessionId:(long)iSessionId;
	- (int)vehicleMode;
	- (void)setVehicleMode:(int)iVehicleMode;
	- (long)timeStamp;
	- (void)setTimeStamp:(long)iTimeStamp;
	- (double)latitude;
	- (void)setLatitude:(double)dLatitude;
	- (double)longitude;
	- (void)setLongitude:(double)dLongitude;
	- (double)elevation;
	- (void)setElevation:(double)dElevation;
	- (double)speed;
	- (void)setSpeed:(double)dSpeed;
	- (double)gps_bearing;
	- (void)setGps_bearing:(double)dGps_bearing;
	- (double)accuracy;
	- (void)setAccuracy:(double)dAccuracy;
	- (int)batteryLevel;
	- (void)setBatteryLevel:(int)iBatteryLevel;
	- (double)batteryConsumptionPerHour;
	- (void)setBatteryConsumptionPerHour:(double)dBatteryConsumptionPerHour;
	- (double)accelerationX;
	- (void)setAccelerationX:(double)dAccelerationX;
	- (double)accelerationY;
	- (void)setAccelerationY:(double)dAccelerationY;
	- (double)accelerationZ;
	- (void)setAccelerationZ:(double)dAccelerationZ;
	- (double)humidity;
	- (void)setHumidity:(double)dHumidity;
	- (double)proximity;
	- (void)setProximity:(double)dProximity;
	- (double)lumen;
	- (void)setLumen:(double)dLumen;
	- (double)deviceBearing;
	- (void)setDeviceBearing:(double)dDeviceBearing;
	- (double)deviceRoll;
	- (void)setDeviceRoll:(double)dDeviceRoll;
	- (double)devicePitch;
	- (void)setDevicePitch:(double)dDevicePitch;
	- (double)temperature;
	- (void)setTemperature:(double)dTemperature;
	- (double)pressure;
	- (void)setPressure:(double)dPressure;

	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	// DB Access
	///////////////////////////////////////////////////////////////////////////////////////////////////////////

	- (NSString *)dbFetchFromRecordset:(STSDBRecordset *)oRs;
	+ (NSMutableArray<TrackingSessionPoint *> *)dbFetchListBySQL:(NSString *)szSQL fromDatabase:(STSDBConnection *)oDb withInstancesOfClass:(Class)oClass;
	+ (NSMutableArray<TrackingSessionPoint *> *)dbFetchListBySQL:(NSString *)szSQL fromDatabase:(STSDBConnection *)oDb;
	+ (NSMutableArray<TrackingSessionPoint *> *)dbFetchAllFromDatabase:(STSDBConnection *)oDb withInstancesOfClass:(Class)oClass;
	+ (NSMutableArray<TrackingSessionPoint *> *)dbFetchAllFromDatabase:(STSDBConnection *)oDb;
	+ (TrackingSessionPoint *)dbFetchOneBySQL:(NSString *)szSQL fromDatabase:(STSDBConnection *)oDb asInstanceOfClass:(Class)oClass;
	+ (TrackingSessionPoint *)dbFetchOneBySQL:(NSString *)szSQL fromDatabase:(STSDBConnection *)oDb;
	+ (TrackingSessionPoint *)dbFetchOneBySessionId:(long)iSessionId andTimeStamp:(long)iTimeStamp fromDatabase:(STSDBConnection *)oDb asInstanceOfClass:(Class)oClass;
	+ (TrackingSessionPoint *)dbFetchOneBySessionId:(long)iSessionId andTimeStamp:(long)iTimeStamp fromDatabase:(STSDBConnection *)oDb;
	+ (NSMutableArray<TrackingSessionPoint *> *)dbFetchListBySessionId:(long)iSessionId fromDatabase:(STSDBConnection *)oDb withInstancesOfClass:(Class)oClass;
	+ (NSMutableArray<TrackingSessionPoint *> *)dbFetchListBySessionId:(long)iSessionId fromDatabase:(STSDBConnection *)oDb;
	- (bool)dbInsertToDatabase:(STSDBConnection *)oDb;
	- (bool)dbUpdateInDatabase:(STSDBConnection *)oDb;
	+ (bool)dbDeleteBySessionId:(long)iSessionId andTimeStamp:(long)iTimeStamp fromDatabase:(STSDBConnection *)oDb;
	+ (bool)dbDeleteBySessionId:(long)iSessionId fromDatabase:(STSDBConnection *)oDb;
	- (bool)dbDeleteFromDatabase:(STSDBConnection *)oDb;
	+ (bool)dbDeleteAllFromDatabase:(STSDBConnection *)oDb;

	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	// SQL Helpers
	///////////////////////////////////////////////////////////////////////////////////////////////////////////

	+ (NSString *)SQLTableName;
	+ (NSString *)SQLFieldSessionIdName;
	+ (NSString *)SQLFieldVehicleModeName;
	+ (NSString *)SQLFieldTimeStampName;
	+ (NSString *)SQLFieldLatitudeName;
	+ (NSString *)SQLFieldLongitudeName;
	+ (NSString *)SQLFieldElevationName;
	+ (NSString *)SQLFieldSpeedName;
	+ (NSString *)SQLFieldGps_bearingName;
	+ (NSString *)SQLFieldAccuracyName;
	+ (NSString *)SQLFieldBatteryLevelName;
	+ (NSString *)SQLFieldBatteryConsumptionPerHourName;
	+ (NSString *)SQLFieldAccelerationXName;
	+ (NSString *)SQLFieldAccelerationYName;
	+ (NSString *)SQLFieldAccelerationZName;
	+ (NSString *)SQLFieldHumidityName;
	+ (NSString *)SQLFieldProximityName;
	+ (NSString *)SQLFieldLumenName;
	+ (NSString *)SQLFieldDeviceBearingName;
	+ (NSString *)SQLFieldDeviceRollName;
	+ (NSString *)SQLFieldDevicePitchName;
	+ (NSString *)SQLFieldTemperatureName;
	+ (NSString *)SQLFieldPressureName;
	+ (void)SQLConfigureCreateTableQueryBuilder:(STSSQLCreateTableQueryBuilder *)qb;
	+ (NSString *)SQLScriptForTableCreation:(STSDBConnection *)oDb;
	+ (void)SQLConfigureDropTableQueryBuilder:(STSSQLDropTableQueryBuilder *)qb ignoreInexistingTable:(bool)bIgnoreInexistingTable;
	+ (NSString *)SQLScriptForTableDropIfExists:(STSDBConnection *)oDb;
	+ (void)SQLConfigureSelectQueryBuilderForSelectAll:(STSSQLSelectQueryBuilder *)sb;
	+ (NSString *)SQLScriptForSelectAll:(STSDBConnection *)oDb;
	+ (void)SQLConfigureSelectQueryBuilder:(STSSQLSelectQueryBuilder *)sb forSelectBySessionId:(long)iSessionId andTimeStamp:(long)iTimeStamp;
	+ (NSString *)SQLScriptForSelectBy:(STSDBConnection *)oDb SessionId:(long)iSessionId timeStamp:(long)iTimeStamp;
	+ (void)SQLConfigureSelectQueryBuilder:(STSSQLSelectQueryBuilder *)sb forSelectBySessionId:(long)iSessionId;
	+ (NSString *)SQLScriptForSelectBy:(STSDBConnection *)oDb SessionId:(long)iSessionId;
	+ (void)SQLConfigureDeleteQueryBuilderForDeleteAll:(STSSQLDeleteQueryBuilder *)sb;
	+ (NSString *)SQLScriptForDeleteAll:(STSDBConnection *)oDb;
	+ (void)SQLConfigureDeleteQueryBuilder:(STSSQLDeleteQueryBuilder *)sb forDeleteBySessionId:(long)iSessionId andTimeStamp:(long)iTimeStamp;
	+ (NSString *)SQLScriptForDeleteBy:(STSDBConnection *)oDb SessionId:(long)iSessionId timeStamp:(long)iTimeStamp;
	+ (void)SQLConfigureDeleteQueryBuilder:(STSSQLDeleteQueryBuilder *)sb forDeleteBySessionId:(long)iSessionId;
	+ (NSString *)SQLScriptForDeleteBy:(STSDBConnection *)oDb SessionId:(long)iSessionId;

@end

