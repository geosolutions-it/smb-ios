#import "STSDBConnection.h"
#import "STSDBRecordset.h"
#import "STSSQLCreateTableQueryBuilder.h"
#import "STSSQLDeleteQueryBuilder.h"
#import "STSSQLDropTableQueryBuilder.h"
#import "STSSQLFieldInfo.h"
#import "STSSQLInsertQueryBuilder.h"
#import "STSSQLSelectQueryBuilder.h"
#import "STSSQLUpdateQueryBuilder.h"
#import "STSTypeConversion.h"
#import "TrackingSessionPoint.h"

@implementation TrackingSessionPoint
{
	long m_iSessionId;

	int m_iVehicleMode;

	long m_iTimeStamp;

	double m_dLatitude;

	double m_dLongitude;

	double m_dElevation;

	double m_dSpeed;

	double m_dGps_bearing;

	double m_dAccuracy;

	int m_iBatteryLevel;

	double m_dBatteryConsumptionPerHour;

	double m_dAccelerationX;

	double m_dAccelerationY;

	double m_dAccelerationZ;

	double m_dHumidity;

	double m_dProximity;

	double m_dLumen;

	double m_dDeviceBearing;

	double m_dDeviceRoll;

	double m_dDevicePitch;

	double m_dTemperature;

	double m_dPressure;

}

///////////////////////////////////////////////////////////////////////////////////////////////////////////
// Getters and Setters
///////////////////////////////////////////////////////////////////////////////////////////////////////////

- (long)sessionId
{
	return m_iSessionId;
}

- (void)setSessionId:(long)iSessionId
{
	if(iSessionId == LONG_MIN)
		m_iSessionId = 0L;
	else
		m_iSessionId = iSessionId;
}

- (int)vehicleMode
{
	return m_iVehicleMode;
}

- (void)setVehicleMode:(int)iVehicleMode
{
	if(iVehicleMode == -0x7fffffff)
		m_iVehicleMode = 0;
	else
		m_iVehicleMode = iVehicleMode;
}

- (long)timeStamp
{
	return m_iTimeStamp;
}

- (void)setTimeStamp:(long)iTimeStamp
{
	if(iTimeStamp == LONG_MIN)
		m_iTimeStamp = 0L;
	else
		m_iTimeStamp = iTimeStamp;
}

- (double)latitude
{
	return m_dLatitude;
}

- (void)setLatitude:(double)dLatitude
{
	if(dLatitude == DBL_MIN)
		m_dLatitude = 0.0;
	else
		m_dLatitude = dLatitude;
}

- (double)longitude
{
	return m_dLongitude;
}

- (void)setLongitude:(double)dLongitude
{
	if(dLongitude == DBL_MIN)
		m_dLongitude = 0.0;
	else
		m_dLongitude = dLongitude;
}

- (double)elevation
{
	return m_dElevation;
}

- (void)setElevation:(double)dElevation
{
	if(dElevation == DBL_MIN)
		m_dElevation = 0.0;
	else
		m_dElevation = dElevation;
}

- (double)speed
{
	return m_dSpeed;
}

- (void)setSpeed:(double)dSpeed
{
	if(dSpeed == DBL_MIN)
		m_dSpeed = 0.0;
	else
		m_dSpeed = dSpeed;
}

- (double)gps_bearing
{
	return m_dGps_bearing;
}

- (void)setGps_bearing:(double)dGps_bearing
{
	if(dGps_bearing == DBL_MIN)
		m_dGps_bearing = 0.0;
	else
		m_dGps_bearing = dGps_bearing;
}

- (double)accuracy
{
	return m_dAccuracy;
}

- (void)setAccuracy:(double)dAccuracy
{
	if(dAccuracy == DBL_MIN)
		m_dAccuracy = 0.0;
	else
		m_dAccuracy = dAccuracy;
}

- (int)batteryLevel
{
	return m_iBatteryLevel;
}

- (void)setBatteryLevel:(int)iBatteryLevel
{
	if(iBatteryLevel == -0x7fffffff)
		m_iBatteryLevel = 0;
	else
		m_iBatteryLevel = iBatteryLevel;
}

- (double)batteryConsumptionPerHour
{
	return m_dBatteryConsumptionPerHour;
}

- (void)setBatteryConsumptionPerHour:(double)dBatteryConsumptionPerHour
{
	if(dBatteryConsumptionPerHour == DBL_MIN)
		m_dBatteryConsumptionPerHour = 0.0;
	else
		m_dBatteryConsumptionPerHour = dBatteryConsumptionPerHour;
}

- (double)accelerationX
{
	return m_dAccelerationX;
}

- (void)setAccelerationX:(double)dAccelerationX
{
	if(dAccelerationX == DBL_MIN)
		m_dAccelerationX = 0.0;
	else
		m_dAccelerationX = dAccelerationX;
}

- (double)accelerationY
{
	return m_dAccelerationY;
}

- (void)setAccelerationY:(double)dAccelerationY
{
	if(dAccelerationY == DBL_MIN)
		m_dAccelerationY = 0.0;
	else
		m_dAccelerationY = dAccelerationY;
}

- (double)accelerationZ
{
	return m_dAccelerationZ;
}

- (void)setAccelerationZ:(double)dAccelerationZ
{
	if(dAccelerationZ == DBL_MIN)
		m_dAccelerationZ = 0.0;
	else
		m_dAccelerationZ = dAccelerationZ;
}

- (double)humidity
{
	return m_dHumidity;
}

- (void)setHumidity:(double)dHumidity
{
	if(dHumidity == DBL_MIN)
		m_dHumidity = 0.0;
	else
		m_dHumidity = dHumidity;
}

- (double)proximity
{
	return m_dProximity;
}

- (void)setProximity:(double)dProximity
{
	if(dProximity == DBL_MIN)
		m_dProximity = 0.0;
	else
		m_dProximity = dProximity;
}

- (double)lumen
{
	return m_dLumen;
}

- (void)setLumen:(double)dLumen
{
	if(dLumen == DBL_MIN)
		m_dLumen = 0.0;
	else
		m_dLumen = dLumen;
}

- (double)deviceBearing
{
	return m_dDeviceBearing;
}

- (void)setDeviceBearing:(double)dDeviceBearing
{
	if(dDeviceBearing == DBL_MIN)
		m_dDeviceBearing = 0.0;
	else
		m_dDeviceBearing = dDeviceBearing;
}

- (double)deviceRoll
{
	return m_dDeviceRoll;
}

- (void)setDeviceRoll:(double)dDeviceRoll
{
	if(dDeviceRoll == DBL_MIN)
		m_dDeviceRoll = 0.0;
	else
		m_dDeviceRoll = dDeviceRoll;
}

- (double)devicePitch
{
	return m_dDevicePitch;
}

- (void)setDevicePitch:(double)dDevicePitch
{
	if(dDevicePitch == DBL_MIN)
		m_dDevicePitch = 0.0;
	else
		m_dDevicePitch = dDevicePitch;
}

- (double)temperature
{
	return m_dTemperature;
}

- (void)setTemperature:(double)dTemperature
{
	if(dTemperature == DBL_MIN)
		m_dTemperature = 0.0;
	else
		m_dTemperature = dTemperature;
}

- (double)pressure
{
	return m_dPressure;
}

- (void)setPressure:(double)dPressure
{
	if(dPressure == DBL_MIN)
		m_dPressure = 0.0;
	else
		m_dPressure = dPressure;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////
// DB Access
///////////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSString *)dbFetchFromRecordset:(STSDBRecordset *)oRs
{
	if(!oRs)
		return @"null object";
	id ob = [oRs field:@"sessionId"];
	if(!ob)
	{
		m_iSessionId = 0L;
	} else {
		m_iSessionId = [STSTypeConversion objectToLong:ob withDefault:0L];
		if(m_iSessionId == LONG_MIN)
			m_iSessionId = 0L;
	}
	ob = [oRs field:@"vehicleMode"];
	if(!ob)
	{
		m_iVehicleMode = 0;
	} else {
		m_iVehicleMode = [STSTypeConversion objectToInt:ob withDefault:0];
		if(m_iVehicleMode == -0x7fffffff)
			m_iVehicleMode = 0;
	}
	ob = [oRs field:@"timeStamp"];
	if(!ob)
	{
		m_iTimeStamp = 0L;
	} else {
		m_iTimeStamp = [STSTypeConversion objectToLong:ob withDefault:0L];
		if(m_iTimeStamp == LONG_MIN)
			m_iTimeStamp = 0L;
	}
	ob = [oRs field:@"latitude"];
	if(!ob)
	{
		m_dLatitude = 0.0;
	} else {
		m_dLatitude = [STSTypeConversion objectToDouble:ob withDefault:0.0];
		if(m_dLatitude == DBL_MIN)
			m_dLatitude = 0.0;
	}
	ob = [oRs field:@"longitude"];
	if(!ob)
	{
		m_dLongitude = 0.0;
	} else {
		m_dLongitude = [STSTypeConversion objectToDouble:ob withDefault:0.0];
		if(m_dLongitude == DBL_MIN)
			m_dLongitude = 0.0;
	}
	ob = [oRs field:@"elevation"];
	if(!ob)
	{
		m_dElevation = 0.0;
	} else {
		m_dElevation = [STSTypeConversion objectToDouble:ob withDefault:0.0];
		if(m_dElevation == DBL_MIN)
			m_dElevation = 0.0;
	}
	ob = [oRs field:@"speed"];
	if(!ob)
	{
		m_dSpeed = 0.0;
	} else {
		m_dSpeed = [STSTypeConversion objectToDouble:ob withDefault:0.0];
		if(m_dSpeed == DBL_MIN)
			m_dSpeed = 0.0;
	}
	ob = [oRs field:@"gps_bearing"];
	if(!ob)
	{
		m_dGps_bearing = 0.0;
	} else {
		m_dGps_bearing = [STSTypeConversion objectToDouble:ob withDefault:0.0];
		if(m_dGps_bearing == DBL_MIN)
			m_dGps_bearing = 0.0;
	}
	ob = [oRs field:@"accuracy"];
	if(!ob)
	{
		m_dAccuracy = 0.0;
	} else {
		m_dAccuracy = [STSTypeConversion objectToDouble:ob withDefault:0.0];
		if(m_dAccuracy == DBL_MIN)
			m_dAccuracy = 0.0;
	}
	ob = [oRs field:@"batteryLevel"];
	if(!ob)
	{
		m_iBatteryLevel = 0;
	} else {
		m_iBatteryLevel = [STSTypeConversion objectToInt:ob withDefault:0];
		if(m_iBatteryLevel == -0x7fffffff)
			m_iBatteryLevel = 0;
	}
	ob = [oRs field:@"batteryConsumptionPerHour"];
	if(!ob)
	{
		m_dBatteryConsumptionPerHour = 0.0;
	} else {
		m_dBatteryConsumptionPerHour = [STSTypeConversion objectToDouble:ob withDefault:0.0];
		if(m_dBatteryConsumptionPerHour == DBL_MIN)
			m_dBatteryConsumptionPerHour = 0.0;
	}
	ob = [oRs field:@"accelerationX"];
	if(!ob)
	{
		m_dAccelerationX = 0.0;
	} else {
		m_dAccelerationX = [STSTypeConversion objectToDouble:ob withDefault:0.0];
		if(m_dAccelerationX == DBL_MIN)
			m_dAccelerationX = 0.0;
	}
	ob = [oRs field:@"accelerationY"];
	if(!ob)
	{
		m_dAccelerationY = 0.0;
	} else {
		m_dAccelerationY = [STSTypeConversion objectToDouble:ob withDefault:0.0];
		if(m_dAccelerationY == DBL_MIN)
			m_dAccelerationY = 0.0;
	}
	ob = [oRs field:@"accelerationZ"];
	if(!ob)
	{
		m_dAccelerationZ = 0.0;
	} else {
		m_dAccelerationZ = [STSTypeConversion objectToDouble:ob withDefault:0.0];
		if(m_dAccelerationZ == DBL_MIN)
			m_dAccelerationZ = 0.0;
	}
	ob = [oRs field:@"humidity"];
	if(!ob)
	{
		m_dHumidity = 0.0;
	} else {
		m_dHumidity = [STSTypeConversion objectToDouble:ob withDefault:0.0];
		if(m_dHumidity == DBL_MIN)
			m_dHumidity = 0.0;
	}
	ob = [oRs field:@"proximity"];
	if(!ob)
	{
		m_dProximity = 0.0;
	} else {
		m_dProximity = [STSTypeConversion objectToDouble:ob withDefault:0.0];
		if(m_dProximity == DBL_MIN)
			m_dProximity = 0.0;
	}
	ob = [oRs field:@"lumen"];
	if(!ob)
	{
		m_dLumen = 0.0;
	} else {
		m_dLumen = [STSTypeConversion objectToDouble:ob withDefault:0.0];
		if(m_dLumen == DBL_MIN)
			m_dLumen = 0.0;
	}
	ob = [oRs field:@"deviceBearing"];
	if(!ob)
	{
		m_dDeviceBearing = 0.0;
	} else {
		m_dDeviceBearing = [STSTypeConversion objectToDouble:ob withDefault:0.0];
		if(m_dDeviceBearing == DBL_MIN)
			m_dDeviceBearing = 0.0;
	}
	ob = [oRs field:@"deviceRoll"];
	if(!ob)
	{
		m_dDeviceRoll = 0.0;
	} else {
		m_dDeviceRoll = [STSTypeConversion objectToDouble:ob withDefault:0.0];
		if(m_dDeviceRoll == DBL_MIN)
			m_dDeviceRoll = 0.0;
	}
	ob = [oRs field:@"devicePitch"];
	if(!ob)
	{
		m_dDevicePitch = 0.0;
	} else {
		m_dDevicePitch = [STSTypeConversion objectToDouble:ob withDefault:0.0];
		if(m_dDevicePitch == DBL_MIN)
			m_dDevicePitch = 0.0;
	}
	ob = [oRs field:@"temperature"];
	if(!ob)
	{
		m_dTemperature = 0.0;
	} else {
		m_dTemperature = [STSTypeConversion objectToDouble:ob withDefault:0.0];
		if(m_dTemperature == DBL_MIN)
			m_dTemperature = 0.0;
	}
	ob = [oRs field:@"pressure"];
	if(!ob)
	{
		m_dPressure = 0.0;
	} else {
		m_dPressure = [STSTypeConversion objectToDouble:ob withDefault:0.0];
		if(m_dPressure == DBL_MIN)
			m_dPressure = 0.0;
	}
	return nil;
}

+ (NSMutableArray<TrackingSessionPoint *> *)dbFetchListBySQL:(NSString *)szSQL fromDatabase:(STSDBConnection *)oDb withInstancesOfClass:(Class)oClass
{
	STSDBRecordset * r = [oDb query:szSQL];
	if(!r)
		return nil;
	NSMutableArray<TrackingSessionPoint *> * l = [NSMutableArray new];
	while([r read])
	{
		TrackingSessionPoint * x = [[oClass alloc] init];
		if(!x)
		{
			[oDb.errorStack pushError:@"Failed to instantiate object"];
			return nil;
		}
		NSString * szErr = [x dbFetchFromRecordset:r];
		if(szErr && (szErr.length > 0))
		{
			[oDb.errorStack pushError:szErr];
			return nil;
		}
		[l addObject:x];
	}
	[r close];
	return l;
}

+ (NSMutableArray<TrackingSessionPoint *> *)dbFetchListBySQL:(NSString *)szSQL fromDatabase:(STSDBConnection *)oDb
{
	return [TrackingSessionPoint dbFetchListBySQL:szSQL fromDatabase:oDb withInstancesOfClass:[TrackingSessionPoint class]];
}

+ (NSMutableArray<TrackingSessionPoint *> *)dbFetchAllFromDatabase:(STSDBConnection *)oDb withInstancesOfClass:(Class)oClass
{
	return [TrackingSessionPoint dbFetchListBySQL:[self SQLScriptForSelectAll:oDb] fromDatabase:oDb withInstancesOfClass:oClass];
}

+ (NSMutableArray<TrackingSessionPoint *> *)dbFetchAllFromDatabase:(STSDBConnection *)oDb
{
	return [TrackingSessionPoint dbFetchAllFromDatabase:oDb withInstancesOfClass:[TrackingSessionPoint class]];
}

+ (TrackingSessionPoint *)dbFetchOneBySQL:(NSString *)szSQL fromDatabase:(STSDBConnection *)oDb asInstanceOfClass:(Class)oClass
{
	STSDBRecordset * r = [oDb query:szSQL];
	if(!r)
		return nil;
	if(![r read])
		return nil;
	TrackingSessionPoint * x = [[oClass alloc] init];
	if(!x)
	{
		[oDb.errorStack pushError:@"Failed to instantiate class"];
		return nil;
	}
	NSString * szErr = [x dbFetchFromRecordset:r];
	if(szErr && (szErr.length > 0))
	{
		[oDb.errorStack pushError:szErr];
		return nil;
	}
	return x;
}

+ (TrackingSessionPoint *)dbFetchOneBySQL:(NSString *)szSQL fromDatabase:(STSDBConnection *)oDb
{
	return [TrackingSessionPoint dbFetchOneBySQL:szSQL fromDatabase:oDb asInstanceOfClass:[TrackingSessionPoint class]];
}

+ (TrackingSessionPoint *)dbFetchOneBySessionId:(long)iSessionId andTimeStamp:(long)iTimeStamp fromDatabase:(STSDBConnection *)oDb asInstanceOfClass:(Class)oClass
{
	STSSQLSelectQueryBuilder * sb = [oDb createSelectQueryBuilder];
	[TrackingSessionPoint SQLConfigureSelectQueryBuilder:sb forSelectBySessionId:iSessionId andTimeStamp:iTimeStamp];
	[sb setLimit:1];
	return [TrackingSessionPoint dbFetchOneBySQL:[sb build] fromDatabase:oDb asInstanceOfClass:oClass];
}

+ (TrackingSessionPoint *)dbFetchOneBySessionId:(long)iSessionId andTimeStamp:(long)iTimeStamp fromDatabase:(STSDBConnection *)oDb
{
	return [TrackingSessionPoint dbFetchOneBySessionId:iSessionId andTimeStamp:iTimeStamp fromDatabase:oDb asInstanceOfClass:[TrackingSessionPoint class]];
}

+ (NSMutableArray<TrackingSessionPoint *> *)dbFetchListBySessionId:(long)iSessionId fromDatabase:(STSDBConnection *)oDb withInstancesOfClass:(Class)oClass
{
	STSSQLSelectQueryBuilder * sb = [oDb createSelectQueryBuilder];
	[TrackingSessionPoint SQLConfigureSelectQueryBuilder:sb forSelectBySessionId:iSessionId];
	return [TrackingSessionPoint dbFetchListBySQL:[sb build] fromDatabase:oDb withInstancesOfClass:oClass];
}

+ (NSMutableArray<TrackingSessionPoint *> *)dbFetchListBySessionId:(long)iSessionId fromDatabase:(STSDBConnection *)oDb
{
	return [TrackingSessionPoint dbFetchListBySessionId:iSessionId fromDatabase:oDb withInstancesOfClass:[TrackingSessionPoint class]];
}

- (bool)dbInsertToDatabase:(STSDBConnection *)oDb
{
	STSSQLInsertQueryBuilder * qb = [oDb createInsertQueryBuilder];
	[qb setTableName:@"T_TrackingSessionPoint"];
	[qb addValue:[NSNumber numberWithLong:m_iSessionId] forField:@"sessionId" withType:STSSQLOperandType_Int64Constant];
	[qb addValue:[NSNumber numberWithInt:m_iVehicleMode] forField:@"vehicleMode" withType:STSSQLOperandType_Int32Constant];
	[qb addValue:[NSNumber numberWithLong:m_iTimeStamp] forField:@"timeStamp" withType:STSSQLOperandType_Int64Constant];
	[qb addValue:[NSNumber numberWithDouble:m_dLatitude] forField:@"latitude" withType:STSSQLOperandType_Float64Constant];
	[qb addValue:[NSNumber numberWithDouble:m_dLongitude] forField:@"longitude" withType:STSSQLOperandType_Float64Constant];
	[qb addValue:[NSNumber numberWithDouble:m_dElevation] forField:@"elevation" withType:STSSQLOperandType_Float64Constant];
	[qb addValue:[NSNumber numberWithDouble:m_dSpeed] forField:@"speed" withType:STSSQLOperandType_Float64Constant];
	[qb addValue:[NSNumber numberWithDouble:m_dGps_bearing] forField:@"gps_bearing" withType:STSSQLOperandType_Float64Constant];
	[qb addValue:[NSNumber numberWithDouble:m_dAccuracy] forField:@"accuracy" withType:STSSQLOperandType_Float64Constant];
	[qb addValue:[NSNumber numberWithInt:m_iBatteryLevel] forField:@"batteryLevel" withType:STSSQLOperandType_Int32Constant];
	[qb addValue:[NSNumber numberWithDouble:m_dBatteryConsumptionPerHour] forField:@"batteryConsumptionPerHour" withType:STSSQLOperandType_Float64Constant];
	[qb addValue:[NSNumber numberWithDouble:m_dAccelerationX] forField:@"accelerationX" withType:STSSQLOperandType_Float64Constant];
	[qb addValue:[NSNumber numberWithDouble:m_dAccelerationY] forField:@"accelerationY" withType:STSSQLOperandType_Float64Constant];
	[qb addValue:[NSNumber numberWithDouble:m_dAccelerationZ] forField:@"accelerationZ" withType:STSSQLOperandType_Float64Constant];
	[qb addValue:[NSNumber numberWithDouble:m_dHumidity] forField:@"humidity" withType:STSSQLOperandType_Float64Constant];
	[qb addValue:[NSNumber numberWithDouble:m_dProximity] forField:@"proximity" withType:STSSQLOperandType_Float64Constant];
	[qb addValue:[NSNumber numberWithDouble:m_dLumen] forField:@"lumen" withType:STSSQLOperandType_Float64Constant];
	[qb addValue:[NSNumber numberWithDouble:m_dDeviceBearing] forField:@"deviceBearing" withType:STSSQLOperandType_Float64Constant];
	[qb addValue:[NSNumber numberWithDouble:m_dDeviceRoll] forField:@"deviceRoll" withType:STSSQLOperandType_Float64Constant];
	[qb addValue:[NSNumber numberWithDouble:m_dDevicePitch] forField:@"devicePitch" withType:STSSQLOperandType_Float64Constant];
	[qb addValue:[NSNumber numberWithDouble:m_dTemperature] forField:@"temperature" withType:STSSQLOperandType_Float64Constant];
	[qb addValue:[NSNumber numberWithDouble:m_dPressure] forField:@"pressure" withType:STSSQLOperandType_Float64Constant];
	return [oDb execute:[qb build]];
}

- (bool)dbUpdateInDatabase:(STSDBConnection *)oDb
{
	STSSQLUpdateQueryBuilder * qb = [oDb createUpdateQueryBuilder];
	[qb setTableName:@"T_TrackingSessionPoint"];
	[qb addValue:[NSNumber numberWithInt:m_iVehicleMode] forField:@"vehicleMode" withType:STSSQLOperandType_Int32Constant];
	[qb addValue:[NSNumber numberWithDouble:m_dLatitude] forField:@"latitude" withType:STSSQLOperandType_Float64Constant];
	[qb addValue:[NSNumber numberWithDouble:m_dLongitude] forField:@"longitude" withType:STSSQLOperandType_Float64Constant];
	[qb addValue:[NSNumber numberWithDouble:m_dElevation] forField:@"elevation" withType:STSSQLOperandType_Float64Constant];
	[qb addValue:[NSNumber numberWithDouble:m_dSpeed] forField:@"speed" withType:STSSQLOperandType_Float64Constant];
	[qb addValue:[NSNumber numberWithDouble:m_dGps_bearing] forField:@"gps_bearing" withType:STSSQLOperandType_Float64Constant];
	[qb addValue:[NSNumber numberWithDouble:m_dAccuracy] forField:@"accuracy" withType:STSSQLOperandType_Float64Constant];
	[qb addValue:[NSNumber numberWithInt:m_iBatteryLevel] forField:@"batteryLevel" withType:STSSQLOperandType_Int32Constant];
	[qb addValue:[NSNumber numberWithDouble:m_dBatteryConsumptionPerHour] forField:@"batteryConsumptionPerHour" withType:STSSQLOperandType_Float64Constant];
	[qb addValue:[NSNumber numberWithDouble:m_dAccelerationX] forField:@"accelerationX" withType:STSSQLOperandType_Float64Constant];
	[qb addValue:[NSNumber numberWithDouble:m_dAccelerationY] forField:@"accelerationY" withType:STSSQLOperandType_Float64Constant];
	[qb addValue:[NSNumber numberWithDouble:m_dAccelerationZ] forField:@"accelerationZ" withType:STSSQLOperandType_Float64Constant];
	[qb addValue:[NSNumber numberWithDouble:m_dHumidity] forField:@"humidity" withType:STSSQLOperandType_Float64Constant];
	[qb addValue:[NSNumber numberWithDouble:m_dProximity] forField:@"proximity" withType:STSSQLOperandType_Float64Constant];
	[qb addValue:[NSNumber numberWithDouble:m_dLumen] forField:@"lumen" withType:STSSQLOperandType_Float64Constant];
	[qb addValue:[NSNumber numberWithDouble:m_dDeviceBearing] forField:@"deviceBearing" withType:STSSQLOperandType_Float64Constant];
	[qb addValue:[NSNumber numberWithDouble:m_dDeviceRoll] forField:@"deviceRoll" withType:STSSQLOperandType_Float64Constant];
	[qb addValue:[NSNumber numberWithDouble:m_dDevicePitch] forField:@"devicePitch" withType:STSSQLOperandType_Float64Constant];
	[qb addValue:[NSNumber numberWithDouble:m_dTemperature] forField:@"temperature" withType:STSSQLOperandType_Float64Constant];
	[qb addValue:[NSNumber numberWithDouble:m_dPressure] forField:@"pressure" withType:STSSQLOperandType_Float64Constant];
	[qb.where addConditionWithField:@"sessionId" operator:STSSQLOperator_IsEqualTo rightObject:[NSNumber numberWithLong:m_iSessionId] rightType:STSSQLOperandType_Int64Constant];
	[qb.where addConditionWithField:@"timeStamp" operator:STSSQLOperator_IsEqualTo rightObject:[NSNumber numberWithLong:m_iTimeStamp] rightType:STSSQLOperandType_Int64Constant];
	return [oDb execute:[qb build]];
}

+ (bool)dbDeleteBySessionId:(long)iSessionId andTimeStamp:(long)iTimeStamp fromDatabase:(STSDBConnection *)oDb
{
	STSSQLDeleteQueryBuilder * sb = [oDb createDeleteQueryBuilder];
	[TrackingSessionPoint SQLConfigureDeleteQueryBuilder:sb forDeleteBySessionId:iSessionId andTimeStamp:iTimeStamp];
	return [oDb execute:[sb build]];
}

+ (bool)dbDeleteBySessionId:(long)iSessionId fromDatabase:(STSDBConnection *)oDb
{
	STSSQLDeleteQueryBuilder * sb = [oDb createDeleteQueryBuilder];
	[TrackingSessionPoint SQLConfigureDeleteQueryBuilder:sb forDeleteBySessionId:iSessionId];
	return [oDb execute:[sb build]];
}

- (bool)dbDeleteFromDatabase:(STSDBConnection *)oDb
{
	return [TrackingSessionPoint dbDeleteBySessionId:m_iSessionId andTimeStamp:m_iTimeStamp fromDatabase:oDb];
}

+ (bool)dbDeleteAllFromDatabase:(STSDBConnection *)oDb
{
	return [oDb execute:[self SQLScriptForDeleteAll:oDb]];
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////
// SQL Helpers
///////////////////////////////////////////////////////////////////////////////////////////////////////////

+ (NSString *)SQLTableName
{
	return @"T_TrackingSessionPoint";
}

+ (NSString *)SQLFieldSessionIdName
{
	return @"sessionId";
}

+ (NSString *)SQLFieldVehicleModeName
{
	return @"vehicleMode";
}

+ (NSString *)SQLFieldTimeStampName
{
	return @"timeStamp";
}

+ (NSString *)SQLFieldLatitudeName
{
	return @"latitude";
}

+ (NSString *)SQLFieldLongitudeName
{
	return @"longitude";
}

+ (NSString *)SQLFieldElevationName
{
	return @"elevation";
}

+ (NSString *)SQLFieldSpeedName
{
	return @"speed";
}

+ (NSString *)SQLFieldGps_bearingName
{
	return @"gps_bearing";
}

+ (NSString *)SQLFieldAccuracyName
{
	return @"accuracy";
}

+ (NSString *)SQLFieldBatteryLevelName
{
	return @"batteryLevel";
}

+ (NSString *)SQLFieldBatteryConsumptionPerHourName
{
	return @"batteryConsumptionPerHour";
}

+ (NSString *)SQLFieldAccelerationXName
{
	return @"accelerationX";
}

+ (NSString *)SQLFieldAccelerationYName
{
	return @"accelerationY";
}

+ (NSString *)SQLFieldAccelerationZName
{
	return @"accelerationZ";
}

+ (NSString *)SQLFieldHumidityName
{
	return @"humidity";
}

+ (NSString *)SQLFieldProximityName
{
	return @"proximity";
}

+ (NSString *)SQLFieldLumenName
{
	return @"lumen";
}

+ (NSString *)SQLFieldDeviceBearingName
{
	return @"deviceBearing";
}

+ (NSString *)SQLFieldDeviceRollName
{
	return @"deviceRoll";
}

+ (NSString *)SQLFieldDevicePitchName
{
	return @"devicePitch";
}

+ (NSString *)SQLFieldTemperatureName
{
	return @"temperature";
}

+ (NSString *)SQLFieldPressureName
{
	return @"pressure";
}

+ (void)SQLConfigureCreateTableQueryBuilder:(STSSQLCreateTableQueryBuilder *)qb
{
	[qb setTableName:@"T_TrackingSessionPoint"];
	STSSQLFieldInfo * fi;
	fi = [qb addField:@"sessionId" type:STSSQLDataType_Int64 nullable:false defaultValue:[NSNumber numberWithLong:0]];
	[fi setIsPartOfPrimaryKey:true];
	fi = [qb addField:@"vehicleMode" type:STSSQLDataType_Int32 nullable:true defaultValue:nil];
	fi = [qb addField:@"timeStamp" type:STSSQLDataType_Int64 nullable:false defaultValue:[NSNumber numberWithLong:0]];
	[fi setIsPartOfPrimaryKey:true];
	fi = [qb addField:@"latitude" type:STSSQLDataType_Float64 nullable:true defaultValue:nil];
	fi = [qb addField:@"longitude" type:STSSQLDataType_Float64 nullable:true defaultValue:nil];
	fi = [qb addField:@"elevation" type:STSSQLDataType_Float64 nullable:true defaultValue:nil];
	fi = [qb addField:@"speed" type:STSSQLDataType_Float64 nullable:true defaultValue:nil];
	fi = [qb addField:@"gps_bearing" type:STSSQLDataType_Float64 nullable:true defaultValue:nil];
	fi = [qb addField:@"accuracy" type:STSSQLDataType_Float64 nullable:true defaultValue:nil];
	fi = [qb addField:@"batteryLevel" type:STSSQLDataType_Int32 nullable:true defaultValue:nil];
	fi = [qb addField:@"batteryConsumptionPerHour" type:STSSQLDataType_Float64 nullable:true defaultValue:nil];
	fi = [qb addField:@"accelerationX" type:STSSQLDataType_Float64 nullable:true defaultValue:nil];
	fi = [qb addField:@"accelerationY" type:STSSQLDataType_Float64 nullable:true defaultValue:nil];
	fi = [qb addField:@"accelerationZ" type:STSSQLDataType_Float64 nullable:true defaultValue:nil];
	fi = [qb addField:@"humidity" type:STSSQLDataType_Float64 nullable:true defaultValue:nil];
	fi = [qb addField:@"proximity" type:STSSQLDataType_Float64 nullable:true defaultValue:nil];
	fi = [qb addField:@"lumen" type:STSSQLDataType_Float64 nullable:true defaultValue:nil];
	fi = [qb addField:@"deviceBearing" type:STSSQLDataType_Float64 nullable:true defaultValue:nil];
	fi = [qb addField:@"deviceRoll" type:STSSQLDataType_Float64 nullable:true defaultValue:nil];
	fi = [qb addField:@"devicePitch" type:STSSQLDataType_Float64 nullable:true defaultValue:nil];
	fi = [qb addField:@"temperature" type:STSSQLDataType_Float64 nullable:true defaultValue:nil];
	fi = [qb addField:@"pressure" type:STSSQLDataType_Float64 nullable:true defaultValue:nil];
}

+ (NSString *)SQLScriptForTableCreation:(STSDBConnection *)oDb
{
	STSSQLCreateTableQueryBuilder * qb = [oDb createCreateTableQueryBuilder];
	[TrackingSessionPoint SQLConfigureCreateTableQueryBuilder:qb];
	return [qb build];
}

+ (void)SQLConfigureDropTableQueryBuilder:(STSSQLDropTableQueryBuilder *)qb ignoreInexistingTable:(bool)bIgnoreInexistingTable
{
	[qb setTableName:@"T_TrackingSessionPoint"];
	[qb setIgnoreInexistingTable:bIgnoreInexistingTable];
}

+ (NSString *)SQLScriptForTableDropIfExists:(STSDBConnection *)oDb
{
	STSSQLDropTableQueryBuilder * qb = [oDb createDropTableQueryBuilder];
	[TrackingSessionPoint SQLConfigureDropTableQueryBuilder:qb ignoreInexistingTable:true];
	return [qb build];
}

+ (void)SQLConfigureSelectQueryBuilderForSelectAll:(STSSQLSelectQueryBuilder *)sb
{
	[sb setTableName:@"T_TrackingSessionPoint"];
}

+ (NSString *)SQLScriptForSelectAll:(STSDBConnection *)oDb
{
	STSSQLSelectQueryBuilder * sb = [oDb createSelectQueryBuilder];
	[TrackingSessionPoint SQLConfigureSelectQueryBuilderForSelectAll:sb];
	return [sb build];
}

+ (void)SQLConfigureSelectQueryBuilder:(STSSQLSelectQueryBuilder *)sb forSelectBySessionId:(long)iSessionId andTimeStamp:(long)iTimeStamp
{
	[sb setTableName:@"T_TrackingSessionPoint"];
	[sb.where addConditionWithField:@"sessionId" operator:STSSQLOperator_IsEqualTo rightObject:[NSNumber numberWithLong:iSessionId] rightType:STSSQLOperandType_Int64Constant];
	[sb.where addConditionWithField:@"timeStamp" operator:STSSQLOperator_IsEqualTo rightObject:[NSNumber numberWithLong:iTimeStamp] rightType:STSSQLOperandType_Int64Constant];
}

+ (NSString *)SQLScriptForSelectBy:(STSDBConnection *)oDb SessionId:(long)iSessionId timeStamp:(long)iTimeStamp
{
	STSSQLSelectQueryBuilder * sb = [oDb createSelectQueryBuilder];
	[TrackingSessionPoint SQLConfigureSelectQueryBuilder:sb forSelectBySessionId:iSessionId andTimeStamp:iTimeStamp];
	return [sb build];
}

+ (void)SQLConfigureSelectQueryBuilder:(STSSQLSelectQueryBuilder *)sb forSelectBySessionId:(long)iSessionId
{
	[sb setTableName:@"T_TrackingSessionPoint"];
	[sb.where addConditionWithField:@"sessionId" operator:STSSQLOperator_IsEqualTo rightObject:[NSNumber numberWithLong:iSessionId] rightType:STSSQLOperandType_Int64Constant];
}

+ (NSString *)SQLScriptForSelectBy:(STSDBConnection *)oDb SessionId:(long)iSessionId
{
	STSSQLSelectQueryBuilder * sb = [oDb createSelectQueryBuilder];
	[TrackingSessionPoint SQLConfigureSelectQueryBuilder:sb forSelectBySessionId:iSessionId];
	return [sb build];
}

+ (void)SQLConfigureDeleteQueryBuilderForDeleteAll:(STSSQLDeleteQueryBuilder *)sb
{
	[sb setTableName:@"T_TrackingSessionPoint"];
}

+ (NSString *)SQLScriptForDeleteAll:(STSDBConnection *)oDb
{
	STSSQLDeleteQueryBuilder * sb = [oDb createDeleteQueryBuilder];
	[TrackingSessionPoint SQLConfigureDeleteQueryBuilderForDeleteAll:sb];
	return [sb build];
}

+ (void)SQLConfigureDeleteQueryBuilder:(STSSQLDeleteQueryBuilder *)sb forDeleteBySessionId:(long)iSessionId andTimeStamp:(long)iTimeStamp
{
	[sb setTableName:@"T_TrackingSessionPoint"];
	[sb.where addConditionWithField:@"sessionId" operator:STSSQLOperator_IsEqualTo rightObject:[NSNumber numberWithLong:iSessionId] rightType:STSSQLOperandType_Int64Constant];
	[sb.where addConditionWithField:@"timeStamp" operator:STSSQLOperator_IsEqualTo rightObject:[NSNumber numberWithLong:iTimeStamp] rightType:STSSQLOperandType_Int64Constant];
}

+ (NSString *)SQLScriptForDeleteBy:(STSDBConnection *)oDb SessionId:(long)iSessionId timeStamp:(long)iTimeStamp
{
	STSSQLDeleteQueryBuilder * sb = [oDb createDeleteQueryBuilder];
	[TrackingSessionPoint SQLConfigureDeleteQueryBuilder:sb forDeleteBySessionId:iSessionId andTimeStamp:iTimeStamp];
	return [sb build];
}

+ (void)SQLConfigureDeleteQueryBuilder:(STSSQLDeleteQueryBuilder *)sb forDeleteBySessionId:(long)iSessionId
{
	[sb setTableName:@"T_TrackingSessionPoint"];
	[sb.where addConditionWithField:@"sessionId" operator:STSSQLOperator_IsEqualTo rightObject:[NSNumber numberWithLong:iSessionId] rightType:STSSQLOperandType_Int64Constant];
}

+ (NSString *)SQLScriptForDeleteBy:(STSDBConnection *)oDb SessionId:(long)iSessionId
{
	STSSQLDeleteQueryBuilder * sb = [oDb createDeleteQueryBuilder];
	[TrackingSessionPoint SQLConfigureDeleteQueryBuilder:sb forDeleteBySessionId:iSessionId];
	return [sb build];
}

@end

