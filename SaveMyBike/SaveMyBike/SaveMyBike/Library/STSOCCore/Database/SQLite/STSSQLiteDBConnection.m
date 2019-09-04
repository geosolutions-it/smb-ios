//
//  STSSQLiteDBConnection.m
//
//  Created by Szymon Tomasz Stefanek on 10/30/12.
//  Copyright (c) 2012 Szymon Tomasz Stefanek. All rights reserved.
//

#import "STSSQLiteDBConnection.h"
#import "STSSQLDataTypeInfo.h"
#import "STSSQLiteDBRecordset.h"
#import "STSCore.h"
#import "NSDate+Format.h"

@implementation STSSQLiteDBConnection
{
	sqlite3 * m_pDb;
}

- (id)init
{
	self = [super init];
	if(self)
	{
		m_pDb = NULL;
	}
	return self;
}

- (void)dealloc
{
	if(m_pDb)
	{
		sqlite3_close(m_pDb);
		m_pDb = NULL;
	}
}

- (bool)open:(NSString *)szConnectionString
{
	if([self isOpen])
		[self close];
	
	[self.errorStack clear];
	
	NSMutableDictionary * hParams = [self parseConnectionString:szConnectionString];
	if(!hParams)
	{
		[self.errorStack pushError:@"Missing connection string"];
		return false;
	}

	NSString * szFileName = [hParams objectForKey:@"filename"];
	if(!szFileName)
	{
		szFileName = [hParams objectForKey:@"file"];
		if(!szFileName)
		{
			szFileName = [hParams objectForKey:@"database"];
			if(!szFileName)
			{
				[self.errorStack pushError:@"Bad connection string: missing database filename"];
				return false; // hopeless
			}
		}
	}

	m_pDb = NULL;

	int iRet = sqlite3_open([szFileName UTF8String],&m_pDb);
		
	if(iRet != SQLITE_OK)
	{
		if(m_pDb) // may be not nil also in case of error
		{
			const char * szErrMsg = sqlite3_errmsg(m_pDb);
			if(szErrMsg)
				[self.errorStack pushError:[NSString stringWithUTF8String:szErrMsg]]; 
			else
				[self.errorStack pushError:[NSString stringWithFormat:@"SQLite error code %d", iRet]];
			sqlite3_close(m_pDb);
			m_pDb = NULL;
		} else {
			[self.errorStack pushError:[NSString stringWithFormat:@"SQLite error code %d", iRet]];
		}
		return false;
	}
		
	return true;
}

- (bool)isOpen
{
	return m_pDb != NULL;
}

- (void)close
{
	if(m_pDb != NULL)
	{
		sqlite3_close(m_pDb);
		m_pDb = NULL;
	}
}

- (STSDBRecordset *)query:(NSString *)szSql
{
	[self.errorStack clear];

	if(!szSql)
	{
		[self.errorStack pushError:@"Invalid parameter"];
		return nil;
	}

	if(!m_pDb)
	{
		[self.errorStack pushError:@"Database not open"];
		return nil;
	}
	
	sqlite3_stmt * pStatement = NULL;
	
#if 0
	int iRet = sqlite3_prepare_v2(m_pDb,[szSql UTF8String],-1,&pStatement,NULL);
	
	if(iRet != SQLITE_OK)
	{
		const char * szErrMsg = sqlite3_errmsg(m_pDb);
		if(szErrMsg)
		{
			[self.errorStack pushError:[NSString stringWithUTF8String:szErrMsg]]; 
			STS_CORE_LOG_ERROR(@"Statement prepare failed: %s",szErrMsg);
		} else {
			[self.errorStack pushError:[NSString stringWithFormat:@"SQLite error code %d", iRet]];
			STS_CORE_LOG_ERROR(@"Statement prepare failed: error code %d",iRet);
		}

		return false;
	}
#else

	const char * p = [szSql UTF8String];
	
	for(;;)
	{
		const char * pzTail = NULL;
		
		//cc_debug("QUERY SQL PART: %s",p);
		
		pStatement = NULL;
		
		int iRet = sqlite3_prepare_v2(m_pDb,p,-1,&pStatement,&pzTail);
		
		if(iRet != SQLITE_OK)
		{
			const char * szErrMsg = sqlite3_errmsg(m_pDb);
			if(szErrMsg)
			{
				[self.errorStack pushError:[NSString stringWithUTF8String:szErrMsg]];
				STS_CORE_LOG_ERROR(@"Statement prepare failed: %s",szErrMsg);
			} else {
				[self.errorStack pushError:[NSString stringWithFormat:@"SQLite error code %d", iRet]];
				STS_CORE_LOG_ERROR(@"Statement prepare failed: error code %d",iRet);
			}
			return NULL;
		}
		
		if(pzTail == NULL)
			break;

		while(*pzTail && (*pzTail == ' '))
			pzTail++;
		
		if(!(*pzTail))
			break;

		// multiple statements!
		// we step all of them up to the last one.

		iRet = sqlite3_step(pStatement);
		if(iRet != SQLITE_DONE)
		{
			const char * szErrMsg = sqlite3_errmsg(m_pDb);
			if(szErrMsg)
			{
				[self.errorStack pushError:[NSString stringWithUTF8String:szErrMsg]];
				STS_CORE_LOG_ERROR(@"Statement prepare failed: %s",szErrMsg);
			} else {
				[self.errorStack pushError:[NSString stringWithFormat:@"SQLite error code %d", iRet]];
				STS_CORE_LOG_ERROR(@"Statement prepare failed: error code %d",iRet);
			}
			return NULL;
		}

		sqlite3_finalize(pStatement);

		p = pzTail;
	}

#endif
	
	return [[STSSQLiteDBRecordset alloc] initWithSQLiteStatement:pStatement];
}

- (bool)execute:(NSString *)szSql
{
	[self.errorStack clear];

	if(!szSql)
	{
		[self.errorStack pushError:@"Invalid parameter"];
		return nil;
	}
	
	if(!m_pDb)
	{
		[self.errorStack pushError:@"Database not open"];
		return nil;
	}
	
	sqlite3_stmt * pStatement = NULL;
	
	int iRet = sqlite3_prepare_v2(m_pDb,[szSql UTF8String],-1,&pStatement,NULL);
	
	if(iRet != SQLITE_OK)
	{
		const char * szErrMsg = sqlite3_errmsg(m_pDb);
		if(szErrMsg)
		{
			[self.errorStack pushError:[NSString stringWithUTF8String:szErrMsg]]; 
			STS_CORE_LOG_ERROR(@"Statement prepare failed: %s",szErrMsg);
		} else {
			[self.errorStack pushError:[NSString stringWithFormat:@"SQLite error code %d", iRet]];
			STS_CORE_LOG_ERROR(@"Statement prepare failed: error code %d",iRet);
		}
		
		return false;
	}
	
	iRet = sqlite3_step(pStatement);
	if(iRet != SQLITE_DONE)
	{
		[self.errorStack pushError:[NSString stringWithFormat:@"Query is not executable: SQLite error code %d", iRet]];

		const char * szErrMsg = sqlite3_errmsg(m_pDb);
		if(szErrMsg)
		{
			[self.errorStack pushError:[NSString stringWithUTF8String:szErrMsg]]; 
			STS_CORE_LOG_ERROR(@"Query is not executable: %s",szErrMsg);
		} else {
			[self.errorStack pushError:[NSString stringWithFormat:@"SQLite error code %d", iRet]];
			STS_CORE_LOG_ERROR(@"Query is not executable: error code %d",iRet);
		}

		sqlite3_finalize(pStatement);
		return false;
	}

	sqlite3_finalize(pStatement);
	return true;
}

#if 0
- (int)userVersion
{
	STSDBRecordset * pRecordset = [self query:@"PRAGMA user_version"];
	if(!pRecordset)
		return -1;

	if(![pRecordset read])
	{
		[self.errorStack pushError:@"Szymon Tomasz Stefanek user_version query did not return any records"];
		[pRecordset close];
		return -1;
	}

	int iVersion = [pRecordset intFieldForColumnIndex:0 withDefaultValue:-1];

	[pRecordset close];
	return iVersion;
}

- (bool)setUserVersion:(int)iVersion
{
	return [self execute:[NSString stringWithFormat:@"PRAGMA user_version=%d",iVersion]];
}
#endif

- (long long)lastInsertRowId
{
	STSDBRecordset * pRecordset = [self query:@"select last_insert_rowid() as last_id"];
	if(!pRecordset)
		return -1;

	if(![pRecordset read])
	{
		[pRecordset close];
		return -1;
	}

	long lLastId = [pRecordset longField:@"last_id" withDefault:-1];

	[pRecordset close];
	return lLastId;
}

- (bool)beginTransaction
{
	return [self execute:@"begin transaction"];
}

- (bool)rollbackTransaction
{
	return [self execute:@"rollback transaction"];
}

- (bool)commitTransaction
{
	return [self execute:@"commit transaction"];
}

- (NSString *)quote:(NSString *)s
{
	if(!s)
		return s;
	return [s stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
}


- (NSString *)mapSQLType:(STSSQLDataTypeInfo *)inf
{
	switch(inf.type)
	{
		case STSSQLDataType_Bit:
			return @"tinyint";
		case STSSQLDataType_Int8:
			return @"tinyint";
		case STSSQLDataType_Int16:
			return @"smallint";
		case STSSQLDataType_Int32:
			return @"int";
		case STSSQLDataType_Int64:
			return @"bigint";
		case STSSQLDataType_Float32:
			return @"float";
		case STSSQLDataType_Float64:
			return @"double";
		case STSSQLDataType_FixedNumeric:
			return @"double";
		case STSSQLDataType_VarChar:
			if(inf.length > 0)
				return [NSString stringWithFormat:@"varchar(%d)",inf.length];
			return @"varchar";
		case STSSQLDataType_Text:
			return @"text";
		case STSSQLDataType_DateTime:
			return @"varchar(23)"; // 2018-10-10 16:32:43.890
		case STSSQLDataType_Date:
			return @"varchar(10)"; // 2018-10-10
		case STSSQLDataType_Time:
			return @"varchar(12)"; // 16:32:43.890
		break;
		default:
			// fall down - bug
		break;
	}

	return @"UNMAPPED_TYPE";
}

- (NSString *)formatSQLConstant:(id)val withType:(STSSQLDataType)eType
{
	if(!val)
		return @"nil";

	switch(eType)
	{
		case STSSQLDataType_Bit:
		case STSSQLDataType_Int8:
			if([val isKindOfClass:[NSNumber class]])
				return [NSString stringWithFormat:@"%d",[((NSNumber *)val) charValue]];
			if([val isKindOfClass:[NSString class]])
				return (NSString *)val;
		break;
		case STSSQLDataType_Int16:
			if([val isKindOfClass:[NSNumber class]])
				return [NSString stringWithFormat:@"%d",[((NSNumber *)val) shortValue]];
			if([val isKindOfClass:[NSString class]])
				return (NSString *)val;
		break;
		case STSSQLDataType_Int32:
			if([val isKindOfClass:[NSNumber class]])
				return [NSString stringWithFormat:@"%d",[((NSNumber *)val) intValue]];
			if([val isKindOfClass:[NSString class]])
				return (NSString *)val;
		break;
		case STSSQLDataType_Int64:
			if([val isKindOfClass:[NSNumber class]])
				return [NSString stringWithFormat:@"%ld",[((NSNumber *)val) longValue]];
			if([val isKindOfClass:[NSString class]])
				return (NSString *)val;
		break;
		case STSSQLDataType_Float32:
			if([val isKindOfClass:[NSNumber class]])
				return [NSString stringWithFormat:@"%f",[((NSNumber *)val) floatValue]];
			if([val isKindOfClass:[NSString class]])
				return (NSString *)val;
		break;
		case STSSQLDataType_Float64:
			if([val isKindOfClass:[NSNumber class]])
				return [NSString stringWithFormat:@"%f",[((NSNumber *)val) doubleValue]];
			if([val isKindOfClass:[NSString class]])
				return (NSString *)val;
		break;
		case STSSQLDataType_FixedNumeric:
			if([val isKindOfClass:[NSNumber class]])
				return [NSString stringWithFormat:@"%f",[((NSNumber *)val) doubleValue]];
			if([val isKindOfClass:[NSString class]])
				return (NSString *)val;
		break;
		case STSSQLDataType_VarChar:
		case STSSQLDataType_Text:
			if([val isKindOfClass:[NSString class]])
				return [NSString stringWithFormat:@"'%@'",[self quote:(NSString *)val]];
			if([val isKindOfClass:[NSNumber class]])
				return [NSString stringWithFormat:@"'%f'",[((NSNumber *)val) doubleValue]];
		break;
		case STSSQLDataType_DateTime:
			if([val isKindOfClass:[NSString class]])
				return [NSString stringWithFormat:@"'%@'",[self quote:(NSString *)val]];
			if([val isKindOfClass:[NSDate class]])
			{
				NSDate * d = (NSDate *)val;
				return [NSString stringWithFormat:@"'%@'",[d stringWithFormat:DateTimeFormatDBDateTimeWithMilliseconds]];
			}
		break;
		case STSSQLDataType_Date:
			if([val isKindOfClass:[NSString class]])
				return [NSString stringWithFormat:@"'%@'",[self quote:(NSString *)val]];
			if([val isKindOfClass:[NSDate class]])
			{
				NSDate * d = (NSDate *)val;
				return [NSString stringWithFormat:@"'%@'",[d stringWithFormat:DateTimeFormatDBDate]];
			}
		break;
		case STSSQLDataType_Time:
			if([val isKindOfClass:[NSString class]])
				return [NSString stringWithFormat:@"'%@'",[self quote:(NSString *)val]];
			if([val isKindOfClass:[NSDate class]])
			{
				NSDate * d = (NSDate *)val;
				return [NSString stringWithFormat:@"'%@'",[d stringWithFormat:DateTimeFormatDBTime]];
			}
		break;
		default:
			// fall down - bug
		break;
	}

	return @"?";
}

@end
