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
#import "TrackingSession.h"
#import "TrackingSessionPoint.h"

static NSMutableDictionary<NSString *,NSNumber *> * g_hTrackingSessionStateEnumIdToEnumCache = nil;

static NSMutableDictionary<NSNumber *,NSString *> * g_hTrackingSessionStateEnumEnumToIdCache = nil;

static NSMutableDictionary<NSString *,NSNumber *> * g_hTrackingSessionStateEnumNameToEnumCache = nil;

static NSMutableDictionary<NSNumber *,NSString *> * g_hTrackingSessionStateEnumEnumToNameCache = nil;

static NSMutableDictionary<NSString *,NSNumber *> * g_hTrackingSessionStateEnumDescriptionToEnumCache = nil;

static NSMutableDictionary<NSNumber *,NSString *> * g_hTrackingSessionStateEnumEnumToDescriptionCache = nil;

@implementation TrackingSessionStateEnumHelpers
{
}

+ (TrackingSessionStateEnum)enumFromId:(NSString *)szId withDefault:(TrackingSessionStateEnum)eDefault
{
	if(!g_hTrackingSessionStateEnumIdToEnumCache)
		[TrackingSessionStateEnumHelpers _enumFromIdBuildCache];
	NSNumber * n = [g_hTrackingSessionStateEnumIdToEnumCache objectForKey:szId];
	return n ? (TrackingSessionStateEnum)[n intValue] : eDefault;
}

+ (void)_enumFromIdBuildCache
{
	g_hTrackingSessionStateEnumIdToEnumCache = [NSMutableDictionary new];
	[g_hTrackingSessionStateEnumIdToEnumCache setObject:[NSNumber numberWithInt:(int)TrackingSessionState_Running] forKey:@"RN"];
	[g_hTrackingSessionStateEnumIdToEnumCache setObject:[NSNumber numberWithInt:(int)TrackingSessionState_Complete] forKey:@"CM"];
	[g_hTrackingSessionStateEnumIdToEnumCache setObject:[NSNumber numberWithInt:(int)TrackingSessionState_InUpload] forKey:@"IU"];
	[g_hTrackingSessionStateEnumIdToEnumCache setObject:[NSNumber numberWithInt:(int)TrackingSessionState_Uploaded] forKey:@"UL"];
	[g_hTrackingSessionStateEnumIdToEnumCache setObject:[NSNumber numberWithInt:(int)TrackingSessionState_Error] forKey:@"ER"];
}

+ (TrackingSessionStateEnum)enumFromId:(NSString *)szId
{
	return [TrackingSessionStateEnumHelpers enumFromId:szId withDefault:TrackingSessionState_Running];
}

+ (NSString *)idFromEnum:(TrackingSessionStateEnum)eVal
{
	if(!g_hTrackingSessionStateEnumEnumToIdCache)
		[TrackingSessionStateEnumHelpers _idFromEnumBuildCache];
	NSString * vRet = [g_hTrackingSessionStateEnumEnumToIdCache objectForKey:[NSNumber numberWithInt:(int)eVal]];
	return vRet ? vRet : @"RN";
}

+ (void)_idFromEnumBuildCache
{
	g_hTrackingSessionStateEnumEnumToIdCache = [NSMutableDictionary new];
	[g_hTrackingSessionStateEnumEnumToIdCache setObject:@"RN" forKey:[NSNumber numberWithInt:(int)TrackingSessionState_Running]];
	[g_hTrackingSessionStateEnumEnumToIdCache setObject:@"CM" forKey:[NSNumber numberWithInt:(int)TrackingSessionState_Complete]];
	[g_hTrackingSessionStateEnumEnumToIdCache setObject:@"IU" forKey:[NSNumber numberWithInt:(int)TrackingSessionState_InUpload]];
	[g_hTrackingSessionStateEnumEnumToIdCache setObject:@"UL" forKey:[NSNumber numberWithInt:(int)TrackingSessionState_Uploaded]];
	[g_hTrackingSessionStateEnumEnumToIdCache setObject:@"ER" forKey:[NSNumber numberWithInt:(int)TrackingSessionState_Error]];
}

+ (TrackingSessionStateEnum)enumFromName:(NSString *)szName withDefault:(TrackingSessionStateEnum)eDefault
{
	if(!g_hTrackingSessionStateEnumNameToEnumCache)
		[TrackingSessionStateEnumHelpers _enumFromNameBuildCache];
	NSNumber * n = [g_hTrackingSessionStateEnumNameToEnumCache objectForKey:szName];
	return n ? (TrackingSessionStateEnum)[n intValue] : eDefault;
}

+ (void)_enumFromNameBuildCache
{
	g_hTrackingSessionStateEnumNameToEnumCache = [NSMutableDictionary new];
	[g_hTrackingSessionStateEnumNameToEnumCache setObject:[NSNumber numberWithInt:(int)TrackingSessionState_Running] forKey:@"Running"];
	[g_hTrackingSessionStateEnumNameToEnumCache setObject:[NSNumber numberWithInt:(int)TrackingSessionState_Complete] forKey:@"Complete"];
	[g_hTrackingSessionStateEnumNameToEnumCache setObject:[NSNumber numberWithInt:(int)TrackingSessionState_InUpload] forKey:@"InUpload"];
	[g_hTrackingSessionStateEnumNameToEnumCache setObject:[NSNumber numberWithInt:(int)TrackingSessionState_Uploaded] forKey:@"Uploaded"];
	[g_hTrackingSessionStateEnumNameToEnumCache setObject:[NSNumber numberWithInt:(int)TrackingSessionState_Error] forKey:@"Error"];
}

+ (TrackingSessionStateEnum)enumFromName:(NSString *)szName
{
	return [TrackingSessionStateEnumHelpers enumFromName:szName withDefault:TrackingSessionState_Running];
}

+ (NSString *)nameFromEnum:(TrackingSessionStateEnum)eVal
{
	if(!g_hTrackingSessionStateEnumEnumToNameCache)
		[TrackingSessionStateEnumHelpers _nameFromEnumBuildCache];
	NSString * vRet = [g_hTrackingSessionStateEnumEnumToNameCache objectForKey:[NSNumber numberWithInt:(int)eVal]];
	return vRet ? vRet : @"Running";
}

+ (void)_nameFromEnumBuildCache
{
	g_hTrackingSessionStateEnumEnumToNameCache = [NSMutableDictionary new];
	[g_hTrackingSessionStateEnumEnumToNameCache setObject:@"Running" forKey:[NSNumber numberWithInt:(int)TrackingSessionState_Running]];
	[g_hTrackingSessionStateEnumEnumToNameCache setObject:@"Complete" forKey:[NSNumber numberWithInt:(int)TrackingSessionState_Complete]];
	[g_hTrackingSessionStateEnumEnumToNameCache setObject:@"InUpload" forKey:[NSNumber numberWithInt:(int)TrackingSessionState_InUpload]];
	[g_hTrackingSessionStateEnumEnumToNameCache setObject:@"Uploaded" forKey:[NSNumber numberWithInt:(int)TrackingSessionState_Uploaded]];
	[g_hTrackingSessionStateEnumEnumToNameCache setObject:@"Error" forKey:[NSNumber numberWithInt:(int)TrackingSessionState_Error]];
}

+ (TrackingSessionStateEnum)enumFromDescription:(NSString *)szDescription withDefault:(TrackingSessionStateEnum)eDefault
{
	if(!g_hTrackingSessionStateEnumDescriptionToEnumCache)
		[TrackingSessionStateEnumHelpers _enumFromDescriptionBuildCache];
	NSNumber * n = [g_hTrackingSessionStateEnumDescriptionToEnumCache objectForKey:szDescription];
	return n ? (TrackingSessionStateEnum)[n intValue] : eDefault;
}

+ (void)_enumFromDescriptionBuildCache
{
	g_hTrackingSessionStateEnumDescriptionToEnumCache = [NSMutableDictionary new];
	[g_hTrackingSessionStateEnumDescriptionToEnumCache setObject:[NSNumber numberWithInt:(int)TrackingSessionState_Running] forKey:@"Running"];
	[g_hTrackingSessionStateEnumDescriptionToEnumCache setObject:[NSNumber numberWithInt:(int)TrackingSessionState_Complete] forKey:@"Complete"];
	[g_hTrackingSessionStateEnumDescriptionToEnumCache setObject:[NSNumber numberWithInt:(int)TrackingSessionState_InUpload] forKey:@"Being Uploaded"];
	[g_hTrackingSessionStateEnumDescriptionToEnumCache setObject:[NSNumber numberWithInt:(int)TrackingSessionState_Uploaded] forKey:@"Uploaded"];
	[g_hTrackingSessionStateEnumDescriptionToEnumCache setObject:[NSNumber numberWithInt:(int)TrackingSessionState_Error] forKey:@"Error"];
}

+ (TrackingSessionStateEnum)enumFromDescription:(NSString *)szDescription
{
	return [TrackingSessionStateEnumHelpers enumFromDescription:szDescription withDefault:TrackingSessionState_Running];
}

+ (NSString *)descriptionFromEnum:(TrackingSessionStateEnum)eVal
{
	if(!g_hTrackingSessionStateEnumEnumToDescriptionCache)
		[TrackingSessionStateEnumHelpers _descriptionFromEnumBuildCache];
	NSString * vRet = [g_hTrackingSessionStateEnumEnumToDescriptionCache objectForKey:[NSNumber numberWithInt:(int)eVal]];
	return vRet ? vRet : @"Running";
}

+ (void)_descriptionFromEnumBuildCache
{
	g_hTrackingSessionStateEnumEnumToDescriptionCache = [NSMutableDictionary new];
	[g_hTrackingSessionStateEnumEnumToDescriptionCache setObject:@"Running" forKey:[NSNumber numberWithInt:(int)TrackingSessionState_Running]];
	[g_hTrackingSessionStateEnumEnumToDescriptionCache setObject:@"Complete" forKey:[NSNumber numberWithInt:(int)TrackingSessionState_Complete]];
	[g_hTrackingSessionStateEnumEnumToDescriptionCache setObject:@"Being Uploaded" forKey:[NSNumber numberWithInt:(int)TrackingSessionState_InUpload]];
	[g_hTrackingSessionStateEnumEnumToDescriptionCache setObject:@"Uploaded" forKey:[NSNumber numberWithInt:(int)TrackingSessionState_Uploaded]];
	[g_hTrackingSessionStateEnumEnumToDescriptionCache setObject:@"Error" forKey:[NSNumber numberWithInt:(int)TrackingSessionState_Error]];
}

+ (TrackingSessionStateEnum)enumFromIdOrName:(id)oVal withDefault:(TrackingSessionStateEnum)eDefault
{
	if(!oVal)
		return eDefault;
	if([oVal isKindOfClass:[NSString class]])
	{
		if(!g_hTrackingSessionStateEnumNameToEnumCache)
			[TrackingSessionStateEnumHelpers _enumFromNameBuildCache];
		NSNumber * n = [g_hTrackingSessionStateEnumNameToEnumCache objectForKey:(NSString *)oVal];
		if(n)
			return (TrackingSessionStateEnum)[n intValue];
		if(!g_hTrackingSessionStateEnumIdToEnumCache)
			[TrackingSessionStateEnumHelpers _enumFromIdBuildCache];
		n = [g_hTrackingSessionStateEnumIdToEnumCache objectForKey:(NSString *)oVal];
		if(n)
			return (TrackingSessionStateEnum)[n intValue];
		return eDefault;
	}
	return eDefault;
}

+ (TrackingSessionStateEnum)enumFromIdOrName:(id)oVal
{
	return [TrackingSessionStateEnumHelpers enumFromIdOrName:oVal withDefault:TrackingSessionState_Running];
}

@end

@implementation TrackingSession
{
	long m_iId;

	NSString * m_sUserId;

	TrackingSessionStateEnum m_eState;

	NSDate * m_dtStartDateTime;

	NSDate * m_dtEndDateTime;

	int m_iUploadAttempts;

	NSString * m_sError;

}

///////////////////////////////////////////////////////////////////////////////////////////////////////////
// Getters and Setters
///////////////////////////////////////////////////////////////////////////////////////////////////////////

- (long)id
{
	return m_iId;
}

- (void)setId:(long)iId
{
	if(iId == LONG_MIN)
		m_iId = 0L;
	else
		m_iId = iId;
}

- (NSString *)userId
{
	return m_sUserId;
}

- (void)setUserId:(NSString *)sUserId
{
	m_sUserId = sUserId;
}

- (TrackingSessionStateEnum)state
{
	return m_eState;
}

- (void)setState:(TrackingSessionStateEnum)eState
{
	m_eState = eState;
}

- (NSDate *)startDateTime
{
	return m_dtStartDateTime;
}

- (void)setStartDateTime:(NSDate *)dtStartDateTime
{
	m_dtStartDateTime = dtStartDateTime;
}

- (NSDate *)endDateTime
{
	return m_dtEndDateTime;
}

- (void)setEndDateTime:(NSDate *)dtEndDateTime
{
	m_dtEndDateTime = dtEndDateTime;
}

- (int)uploadAttempts
{
	return m_iUploadAttempts;
}

- (void)setUploadAttempts:(int)iUploadAttempts
{
	if(iUploadAttempts == -0x7fffffff)
		m_iUploadAttempts = 0;
	else
		m_iUploadAttempts = iUploadAttempts;
}

- (NSString *)error
{
	return m_sError;
}

- (void)setError:(NSString *)sError
{
	m_sError = sError;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////
// DB Access
///////////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSString *)dbFetchFromRecordset:(STSDBRecordset *)oRs
{
	if(!oRs)
		return @"null object";
	id ob = [oRs field:@"id"];
	if(!ob)
	{
		m_iId = 0L;
	} else {
		m_iId = [STSTypeConversion objectToLong:ob withDefault:0L];
		if(m_iId == LONG_MIN)
			m_iId = 0L;
	}
	ob = [oRs field:@"userId"];
	if(!ob)
	{
		m_sUserId = nil;
	} else {
		m_sUserId = [STSTypeConversion objectToString:ob withDefault:nil];
	}
	ob = [oRs field:@"state"];
	if(!ob)
	{
		m_eState = TrackingSessionState_Running;
	} else {
		m_eState = [TrackingSessionStateEnumHelpers enumFromIdOrName:ob withDefault:TrackingSessionState_Running];
	}
	ob = [oRs field:@"startDateTime"];
	if(!ob)
	{
		m_dtStartDateTime = nil;
	} else {
		m_dtStartDateTime = [STSTypeConversion objectToDateTime:ob withDefault:nil];
	}
	ob = [oRs field:@"endDateTime"];
	if(!ob)
	{
		m_dtEndDateTime = nil;
	} else {
		m_dtEndDateTime = [STSTypeConversion objectToDateTime:ob withDefault:nil];
	}
	ob = [oRs field:@"uploadAttempts"];
	if(!ob)
	{
		m_iUploadAttempts = 0;
	} else {
		m_iUploadAttempts = [STSTypeConversion objectToInt:ob withDefault:0];
		if(m_iUploadAttempts == -0x7fffffff)
			m_iUploadAttempts = 0;
	}
	ob = [oRs field:@"error"];
	if(!ob)
	{
		m_sError = nil;
	} else {
		m_sError = [STSTypeConversion objectToString:ob withDefault:nil];
	}
	return nil;
}

+ (NSMutableArray<TrackingSession *> *)dbFetchListBySQL:(NSString *)szSQL fromDatabase:(STSDBConnection *)oDb withInstancesOfClass:(Class)oClass
{
	STSDBRecordset * r = [oDb query:szSQL];
	if(!r)
		return nil;
	NSMutableArray<TrackingSession *> * l = [NSMutableArray new];
	while([r read])
	{
		TrackingSession * x = [[oClass alloc] init];
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

+ (NSMutableArray<TrackingSession *> *)dbFetchListBySQL:(NSString *)szSQL fromDatabase:(STSDBConnection *)oDb
{
	return [TrackingSession dbFetchListBySQL:szSQL fromDatabase:oDb withInstancesOfClass:[TrackingSession class]];
}

+ (NSMutableArray<TrackingSession *> *)dbFetchAllFromDatabase:(STSDBConnection *)oDb withInstancesOfClass:(Class)oClass
{
	return [TrackingSession dbFetchListBySQL:[self SQLScriptForSelectAll:oDb] fromDatabase:oDb withInstancesOfClass:oClass];
}

+ (NSMutableArray<TrackingSession *> *)dbFetchAllFromDatabase:(STSDBConnection *)oDb
{
	return [TrackingSession dbFetchAllFromDatabase:oDb withInstancesOfClass:[TrackingSession class]];
}

+ (TrackingSession *)dbFetchOneBySQL:(NSString *)szSQL fromDatabase:(STSDBConnection *)oDb asInstanceOfClass:(Class)oClass
{
	STSDBRecordset * r = [oDb query:szSQL];
	if(!r)
		return nil;
	if(![r read])
		return nil;
	TrackingSession * x = [[oClass alloc] init];
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

+ (TrackingSession *)dbFetchOneBySQL:(NSString *)szSQL fromDatabase:(STSDBConnection *)oDb
{
	return [TrackingSession dbFetchOneBySQL:szSQL fromDatabase:oDb asInstanceOfClass:[TrackingSession class]];
}

+ (TrackingSession *)dbFetchOneById:(long)iId fromDatabase:(STSDBConnection *)oDb asInstanceOfClass:(Class)oClass
{
	STSSQLSelectQueryBuilder * sb = [oDb createSelectQueryBuilder];
	[TrackingSession SQLConfigureSelectQueryBuilder:sb forSelectById:iId];
	[sb setLimit:1];
	return [TrackingSession dbFetchOneBySQL:[sb build] fromDatabase:oDb asInstanceOfClass:oClass];
}

+ (TrackingSession *)dbFetchOneById:(long)iId fromDatabase:(STSDBConnection *)oDb
{
	return [TrackingSession dbFetchOneById:iId fromDatabase:oDb asInstanceOfClass:[TrackingSession class]];
}

- (bool)dbInsertToDatabase:(STSDBConnection *)oDb
{
	STSSQLInsertQueryBuilder * qb = [oDb createInsertQueryBuilder];
	[qb setTableName:@"T_TrackingSession"];
	[qb addValue:[NSNumber numberWithLong:m_iId] forField:@"id" withType:STSSQLOperandType_Int64Constant];
	[qb addValue:m_sUserId forField:@"userId" withType:STSSQLOperandType_VarCharConstant];
	[qb addValue:[TrackingSessionStateEnumHelpers idFromEnum:m_eState] forField:@"state" withType:STSSQLOperandType_VarCharConstant];
	[qb addValue:m_dtStartDateTime forField:@"startDateTime" withType:STSSQLOperandType_DateTimeConstant];
	[qb addValue:m_dtEndDateTime forField:@"endDateTime" withType:STSSQLOperandType_DateTimeConstant];
	[qb addValue:[NSNumber numberWithInt:m_iUploadAttempts] forField:@"uploadAttempts" withType:STSSQLOperandType_Int32Constant];
	[qb addValue:m_sError forField:@"error" withType:STSSQLOperandType_VarCharConstant];
	return [oDb execute:[qb build]];
}

- (bool)dbUpdateInDatabase:(STSDBConnection *)oDb
{
	STSSQLUpdateQueryBuilder * qb = [oDb createUpdateQueryBuilder];
	[qb setTableName:@"T_TrackingSession"];
	[qb addValue:m_sUserId forField:@"userId" withType:STSSQLOperandType_VarCharConstant];
	[qb addValue:[TrackingSessionStateEnumHelpers idFromEnum:m_eState] forField:@"state" withType:STSSQLOperandType_VarCharConstant];
	[qb addValue:m_dtStartDateTime forField:@"startDateTime" withType:STSSQLOperandType_DateTimeConstant];
	[qb addValue:m_dtEndDateTime forField:@"endDateTime" withType:STSSQLOperandType_DateTimeConstant];
	[qb addValue:[NSNumber numberWithInt:m_iUploadAttempts] forField:@"uploadAttempts" withType:STSSQLOperandType_Int32Constant];
	[qb addValue:m_sError forField:@"error" withType:STSSQLOperandType_VarCharConstant];
	[qb.where addConditionWithField:@"id" operator:STSSQLOperator_IsEqualTo rightObject:[NSNumber numberWithLong:m_iId] rightType:STSSQLOperandType_Int64Constant];
	return [oDb execute:[qb build]];
}

+ (bool)dbDeleteById:(long)iId fromDatabase:(STSDBConnection *)oDb
{
	STSSQLDeleteQueryBuilder * sb = [oDb createDeleteQueryBuilder];
	[TrackingSession SQLConfigureDeleteQueryBuilder:sb forDeleteById:iId];
	return [oDb execute:[sb build]];
}

- (bool)dbDeleteFromDatabase:(STSDBConnection *)oDb
{
	return [TrackingSession dbDeleteById:m_iId fromDatabase:oDb];
}

+ (bool)dbDeleteAllFromDatabase:(STSDBConnection *)oDb
{
	return [oDb execute:[self SQLScriptForDeleteAll:oDb]];
}

- (NSMutableArray<TrackingSessionPoint *> *)dbFetchListOfTrackingSessionPointFromDatabase:(STSDBConnection *)oDb withInstancesOfClass:(Class)oXClass
{
	STSSQLSelectQueryBuilder * sb = [oDb createSelectQueryBuilder];
	[TrackingSessionPoint SQLConfigureSelectQueryBuilderForSelectAll:sb];
	[sb.where addConditionWithField:@"sessionId" operator:STSSQLOperator_IsEqualTo rightObject:[NSNumber numberWithLong:m_iId] rightType:STSSQLOperandType_Int64Constant];
	return [TrackingSessionPoint dbFetchListBySQL:[sb build] fromDatabase:oDb withInstancesOfClass:oXClass];
}

- (NSMutableArray<TrackingSessionPoint *> *)dbFetchListOfFromDatabaseTrackingSessionPoint:(STSDBConnection *)oDb
{
	return [self dbFetchListOfTrackingSessionPointFromDatabase:oDb withInstancesOfClass:[TrackingSessionPoint class]];
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////
// SQL Helpers
///////////////////////////////////////////////////////////////////////////////////////////////////////////

+ (NSString *)SQLTableName
{
	return @"T_TrackingSession";
}

+ (NSString *)SQLFieldIdName
{
	return @"id";
}

+ (NSString *)SQLFieldUserIdName
{
	return @"userId";
}

+ (NSString *)SQLFieldStateName
{
	return @"state";
}

+ (NSString *)SQLFieldStartDateTimeName
{
	return @"startDateTime";
}

+ (NSString *)SQLFieldEndDateTimeName
{
	return @"endDateTime";
}

+ (NSString *)SQLFieldUploadAttemptsName
{
	return @"uploadAttempts";
}

+ (NSString *)SQLFieldErrorName
{
	return @"error";
}

+ (void)SQLConfigureCreateTableQueryBuilder:(STSSQLCreateTableQueryBuilder *)qb
{
	[qb setTableName:@"T_TrackingSession"];
	STSSQLFieldInfo * fi;
	fi = [qb addField:@"id" type:STSSQLDataType_Int64 nullable:false defaultValue:[NSNumber numberWithLong:0]];
	[fi setIsPartOfPrimaryKey:true];
	fi = [qb addField:@"userId" type:STSSQLDataType_VarChar nullable:true defaultValue:nil length:256];
	fi = [qb addField:@"state" type:STSSQLDataType_VarChar nullable:true defaultValue:@"RN" length:2];
	fi = [qb addField:@"startDateTime" type:STSSQLDataType_DateTime nullable:true defaultValue:nil];
	fi = [qb addField:@"endDateTime" type:STSSQLDataType_DateTime nullable:true defaultValue:nil];
	fi = [qb addField:@"uploadAttempts" type:STSSQLDataType_Int32 nullable:false defaultValue:[NSNumber numberWithInt:0]];
	fi = [qb addField:@"error" type:STSSQLDataType_VarChar nullable:true defaultValue:nil length:1024];
}

+ (NSString *)SQLScriptForTableCreation:(STSDBConnection *)oDb
{
	STSSQLCreateTableQueryBuilder * qb = [oDb createCreateTableQueryBuilder];
	[TrackingSession SQLConfigureCreateTableQueryBuilder:qb];
	return [qb build];
}

+ (void)SQLConfigureDropTableQueryBuilder:(STSSQLDropTableQueryBuilder *)qb ignoreInexistingTable:(bool)bIgnoreInexistingTable
{
	[qb setTableName:@"T_TrackingSession"];
	[qb setIgnoreInexistingTable:bIgnoreInexistingTable];
}

+ (NSString *)SQLScriptForTableDropIfExists:(STSDBConnection *)oDb
{
	STSSQLDropTableQueryBuilder * qb = [oDb createDropTableQueryBuilder];
	[TrackingSession SQLConfigureDropTableQueryBuilder:qb ignoreInexistingTable:true];
	return [qb build];
}

+ (void)SQLConfigureSelectQueryBuilderForSelectAll:(STSSQLSelectQueryBuilder *)sb
{
	[sb setTableName:@"T_TrackingSession"];
}

+ (NSString *)SQLScriptForSelectAll:(STSDBConnection *)oDb
{
	STSSQLSelectQueryBuilder * sb = [oDb createSelectQueryBuilder];
	[TrackingSession SQLConfigureSelectQueryBuilderForSelectAll:sb];
	return [sb build];
}

+ (void)SQLConfigureSelectQueryBuilder:(STSSQLSelectQueryBuilder *)sb forSelectById:(long)iId
{
	[sb setTableName:@"T_TrackingSession"];
	[sb.where addConditionWithField:@"id" operator:STSSQLOperator_IsEqualTo rightObject:[NSNumber numberWithLong:iId] rightType:STSSQLOperandType_Int64Constant];
}

+ (NSString *)SQLScriptForSelectBy:(STSDBConnection *)oDb Id:(long)iId
{
	STSSQLSelectQueryBuilder * sb = [oDb createSelectQueryBuilder];
	[TrackingSession SQLConfigureSelectQueryBuilder:sb forSelectById:iId];
	return [sb build];
}

+ (void)SQLConfigureDeleteQueryBuilderForDeleteAll:(STSSQLDeleteQueryBuilder *)sb
{
	[sb setTableName:@"T_TrackingSession"];
}

+ (NSString *)SQLScriptForDeleteAll:(STSDBConnection *)oDb
{
	STSSQLDeleteQueryBuilder * sb = [oDb createDeleteQueryBuilder];
	[TrackingSession SQLConfigureDeleteQueryBuilderForDeleteAll:sb];
	return [sb build];
}

+ (void)SQLConfigureDeleteQueryBuilder:(STSSQLDeleteQueryBuilder *)sb forDeleteById:(long)iId
{
	[sb setTableName:@"T_TrackingSession"];
	[sb.where addConditionWithField:@"id" operator:STSSQLOperator_IsEqualTo rightObject:[NSNumber numberWithLong:iId] rightType:STSSQLOperandType_Int64Constant];
}

+ (NSString *)SQLScriptForDeleteBy:(STSDBConnection *)oDb Id:(long)iId
{
	STSSQLDeleteQueryBuilder * sb = [oDb createDeleteQueryBuilder];
	[TrackingSession SQLConfigureDeleteQueryBuilder:sb forDeleteById:iId];
	return [sb build];
}

@end

