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
@class TrackingSessionPoint;

typedef enum _TrackingSessionStateEnum
{
	// Running
	TrackingSessionState_Running,
	// Complete
	TrackingSessionState_Complete,
	// Being Uploaded
	TrackingSessionState_InUpload,
	// Uploaded
	TrackingSessionState_Uploaded,
	// Error
	TrackingSessionState_Error
} TrackingSessionStateEnum;

@interface TrackingSessionStateEnumHelpers : NSObject

	+ (TrackingSessionStateEnum)enumFromId:(NSString *)szId withDefault:(TrackingSessionStateEnum)eDefault;
	+ (void)_enumFromIdBuildCache;
	+ (TrackingSessionStateEnum)enumFromId:(NSString *)szId;
	+ (NSString *)idFromEnum:(TrackingSessionStateEnum)eVal;
	+ (void)_idFromEnumBuildCache;
	+ (TrackingSessionStateEnum)enumFromName:(NSString *)szName withDefault:(TrackingSessionStateEnum)eDefault;
	+ (void)_enumFromNameBuildCache;
	+ (TrackingSessionStateEnum)enumFromName:(NSString *)szName;
	+ (NSString *)nameFromEnum:(TrackingSessionStateEnum)eVal;
	+ (void)_nameFromEnumBuildCache;
	+ (TrackingSessionStateEnum)enumFromDescription:(NSString *)szDescription withDefault:(TrackingSessionStateEnum)eDefault;
	+ (void)_enumFromDescriptionBuildCache;
	+ (TrackingSessionStateEnum)enumFromDescription:(NSString *)szDescription;
	+ (NSString *)descriptionFromEnum:(TrackingSessionStateEnum)eVal;
	+ (void)_descriptionFromEnumBuildCache;
	+ (TrackingSessionStateEnum)enumFromIdOrName:(id)oVal withDefault:(TrackingSessionStateEnum)eDefault;
	+ (TrackingSessionStateEnum)enumFromIdOrName:(id)oVal;
@end

@interface TrackingSession : NSObject

	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	// Getters and Setters
	///////////////////////////////////////////////////////////////////////////////////////////////////////////

	- (long)id;
	- (void)setId:(long)iId;
	- (NSString *)userId;
	- (void)setUserId:(NSString *)sUserId;
	- (TrackingSessionStateEnum)state;
	- (void)setState:(TrackingSessionStateEnum)eState;
	- (NSDate *)startDateTime;
	- (void)setStartDateTime:(NSDate *)dtStartDateTime;
	- (NSDate *)endDateTime;
	- (void)setEndDateTime:(NSDate *)dtEndDateTime;
	- (int)uploadAttempts;
	- (void)setUploadAttempts:(int)iUploadAttempts;
	- (NSString *)error;
	- (void)setError:(NSString *)sError;

	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	// DB Access
	///////////////////////////////////////////////////////////////////////////////////////////////////////////

	- (NSString *)dbFetchFromRecordset:(STSDBRecordset *)oRs;
	+ (NSMutableArray<TrackingSession *> *)dbFetchListBySQL:(NSString *)szSQL fromDatabase:(STSDBConnection *)oDb withInstancesOfClass:(Class)oClass;
	+ (NSMutableArray<TrackingSession *> *)dbFetchListBySQL:(NSString *)szSQL fromDatabase:(STSDBConnection *)oDb;
	+ (NSMutableArray<TrackingSession *> *)dbFetchAllFromDatabase:(STSDBConnection *)oDb withInstancesOfClass:(Class)oClass;
	+ (NSMutableArray<TrackingSession *> *)dbFetchAllFromDatabase:(STSDBConnection *)oDb;
	+ (TrackingSession *)dbFetchOneBySQL:(NSString *)szSQL fromDatabase:(STSDBConnection *)oDb asInstanceOfClass:(Class)oClass;
	+ (TrackingSession *)dbFetchOneBySQL:(NSString *)szSQL fromDatabase:(STSDBConnection *)oDb;
	+ (TrackingSession *)dbFetchOneById:(long)iId fromDatabase:(STSDBConnection *)oDb asInstanceOfClass:(Class)oClass;
	+ (TrackingSession *)dbFetchOneById:(long)iId fromDatabase:(STSDBConnection *)oDb;
	- (bool)dbInsertToDatabase:(STSDBConnection *)oDb;
	- (bool)dbUpdateInDatabase:(STSDBConnection *)oDb;
	+ (bool)dbDeleteById:(long)iId fromDatabase:(STSDBConnection *)oDb;
	- (bool)dbDeleteFromDatabase:(STSDBConnection *)oDb;
	+ (bool)dbDeleteAllFromDatabase:(STSDBConnection *)oDb;
	- (NSMutableArray<TrackingSessionPoint *> *)dbFetchListOfTrackingSessionPointFromDatabase:(STSDBConnection *)oDb withInstancesOfClass:(Class)oXClass;
	- (NSMutableArray<TrackingSessionPoint *> *)dbFetchListOfFromDatabaseTrackingSessionPoint:(STSDBConnection *)oDb;

	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	// SQL Helpers
	///////////////////////////////////////////////////////////////////////////////////////////////////////////

	+ (NSString *)SQLTableName;
	+ (NSString *)SQLFieldIdName;
	+ (NSString *)SQLFieldUserIdName;
	+ (NSString *)SQLFieldStateName;
	+ (NSString *)SQLFieldStartDateTimeName;
	+ (NSString *)SQLFieldEndDateTimeName;
	+ (NSString *)SQLFieldUploadAttemptsName;
	+ (NSString *)SQLFieldErrorName;
	+ (void)SQLConfigureCreateTableQueryBuilder:(STSSQLCreateTableQueryBuilder *)qb;
	+ (NSString *)SQLScriptForTableCreation:(STSDBConnection *)oDb;
	+ (void)SQLConfigureDropTableQueryBuilder:(STSSQLDropTableQueryBuilder *)qb ignoreInexistingTable:(bool)bIgnoreInexistingTable;
	+ (NSString *)SQLScriptForTableDropIfExists:(STSDBConnection *)oDb;
	+ (void)SQLConfigureSelectQueryBuilderForSelectAll:(STSSQLSelectQueryBuilder *)sb;
	+ (NSString *)SQLScriptForSelectAll:(STSDBConnection *)oDb;
	+ (void)SQLConfigureSelectQueryBuilder:(STSSQLSelectQueryBuilder *)sb forSelectById:(long)iId;
	+ (NSString *)SQLScriptForSelectBy:(STSDBConnection *)oDb Id:(long)iId;
	+ (void)SQLConfigureDeleteQueryBuilderForDeleteAll:(STSSQLDeleteQueryBuilder *)sb;
	+ (NSString *)SQLScriptForDeleteAll:(STSDBConnection *)oDb;
	+ (void)SQLConfigureDeleteQueryBuilder:(STSSQLDeleteQueryBuilder *)sb forDeleteById:(long)iId;
	+ (NSString *)SQLScriptForDeleteBy:(STSDBConnection *)oDb Id:(long)iId;

@end

