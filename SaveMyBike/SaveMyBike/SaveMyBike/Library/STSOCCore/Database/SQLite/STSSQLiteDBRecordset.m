//
//  STSSQLiteDBRecordset.m
//
//  Created by Szymon Tomasz Stefanek on 10/30/12.
//  Copyright (c) 2012 Szymon Tomasz Stefanek. All rights reserved.
//

#import "STSSQLiteDBRecordset.h"

@interface STSSQLiteDBRecordsetColumnInfo : NSObject

@property(nonatomic) NSString * name;
@property(nonatomic) int index;
//@property(nonatomic) int type;

@end

@implementation STSSQLiteDBRecordsetColumnInfo
@end

@implementation STSSQLiteDBRecordset
{
	sqlite3_stmt * m_pStatement;
	int m_iColumnCount;
	NSMutableDictionary<NSString *,STSSQLiteDBRecordsetColumnInfo *> * m_pColumnsByName;
	NSMutableArray<STSSQLiteDBRecordsetColumnInfo *> * m_pColumnsByIndex;
}


- (id)initWithSQLiteStatement:(sqlite3_stmt *)pStatement;
{
	self = [super init];
	if(!self)
		return nil;

	m_pStatement = pStatement;
	m_iColumnCount = sqlite3_column_count(m_pStatement);
	
	return self;
}

- (void)setupMaps
{
	m_pColumnsByName = [NSMutableDictionary new];
	m_pColumnsByIndex = [NSMutableArray new];

	for(int i=0;i < m_iColumnCount;i++)
	{
		const char * szColumnName = sqlite3_column_name(m_pStatement,i);

		STSSQLiteDBRecordsetColumnInfo * inf = [STSSQLiteDBRecordsetColumnInfo new];
		inf.name = szColumnName ? [NSString stringWithUTF8String:szColumnName] : [NSString stringWithFormat:@"BUG%d",i];
		inf.index = i;
		// TYPE IN SQLITE CAN'T BE CACHED BECAUSE IT'S TAKEN ON THE CURRENT ROW AND SQLITE SOMETIMES DOES "MAGIC"
		//inf.type = sqlite3_column_type(m_pStatement,i);

		[m_pColumnsByName setValue:inf forKey:inf.name];
		[m_pColumnsByIndex addObject:inf];
	}
}

- (void)dealloc
{
	if(m_pColumnsByName)
	{
		[m_pColumnsByName removeAllObjects];
		m_pColumnsByName = nil;
	}

	if(m_pStatement)
	{
		sqlite3_finalize(m_pStatement);
		m_pStatement = NULL;
	}
}

- (void)close
{
	if(m_pColumnsByName)
	{
		[m_pColumnsByName removeAllObjects];
		m_pColumnsByName = nil;
	}

	if(m_pStatement)
	{
		sqlite3_finalize(m_pStatement);
		m_pStatement = NULL;
	}
}

- (bool)isOpen
{
	return m_pStatement != NULL;
}

- (bool)read
{
	if(!m_pStatement)
		return false;

	int ret = sqlite3_step(m_pStatement);
	
	if(ret != SQLITE_ROW)
	{
		
		return false;
	}

	if(!m_pColumnsByName)
		[self setupMaps];
	
	return true;
}

- (id)field:(NSString *)szColumnName withDefault:(id)vDefault
{
	if(!m_pStatement)
		return vDefault;
	if(!szColumnName)
		return vDefault;

	STSSQLiteDBRecordsetColumnInfo * inf = [m_pColumnsByName valueForKey:szColumnName];
	if(!inf)
		return vDefault;
	
	int t = sqlite3_column_type(m_pStatement,inf.index);

	switch(t)
	{
		case SQLITE_INTEGER:
			return [NSNumber numberWithLong:sqlite3_column_int64(m_pStatement,inf.index)];
		break;
		case SQLITE_FLOAT:
			return [NSNumber numberWithDouble:sqlite3_column_double(m_pStatement,inf.index)];
		break;
		case SQLITE_TEXT:
		{
			const char * szText = (const char *)sqlite3_column_text(m_pStatement,inf.index);
			if(!szText)
				return vDefault;
			return [NSString stringWithUTF8String:szText];
		}
		break;
		//case SQLITE_BLOB: // FIXME?
		//case SQLITE_NULL:
		default:
			// fall down
		break;
	}

	return vDefault;
}

- (id)field:(NSString *)szColumnName
{
	return [self field:szColumnName withDefault:nil];
}

- (id)fieldByColumnIndex:(int)iColumnIndex withDefault:(id)vDefault
{
	if(!m_pStatement)
		return vDefault;

	STSSQLiteDBRecordsetColumnInfo * inf = [m_pColumnsByIndex objectAtIndex:iColumnIndex];
	if(!inf)
		return vDefault;
	
	int t = sqlite3_column_type(m_pStatement,inf.index);
	
	switch(t)
	{
		case SQLITE_INTEGER:
			return [NSNumber numberWithLong:sqlite3_column_int64(m_pStatement,inf.index)];
		break;
		case SQLITE_FLOAT:
			return [NSNumber numberWithDouble:sqlite3_column_double(m_pStatement,inf.index)];
		break;
		case SQLITE_TEXT:
		{
			const char * szText = (const char *)sqlite3_column_text(m_pStatement,inf.index);
			if(!szText)
				return vDefault;
			return [NSString stringWithUTF8String:szText];
		}
		break;
		//case SQLITE_BLOB: // FIXME?
		//case SQLITE_NULL:
		default:
			// fall down
		break;
	}

	return vDefault;
}

- (id)fieldByColumnIndex:(int)iColumnIndex
{
	return [self fieldByColumnIndex:iColumnIndex withDefault:nil];
}

- (int)columnIndexForColumnName:(NSString *)szColumnName;
{
	if(!m_pStatement)
		return -1;

	STSSQLiteDBRecordsetColumnInfo * inf = [m_pColumnsByName valueForKey:szColumnName];
	if(!inf)
		return -1;
	
	return inf.index;
}

- (long)longField:(NSString *)szColumnName withDefault:(long)lDefault
{
	if(!m_pStatement)
		return lDefault;
	if(!szColumnName)
		return lDefault;

	STSSQLiteDBRecordsetColumnInfo * inf = [m_pColumnsByName valueForKey:szColumnName];
	if(!inf)
		return lDefault;
	
	return sqlite3_column_int64(m_pStatement,inf.index);
}

- (int)intField:(NSString *)szColumnName withDefault:(int)iDefault
{
	if(!m_pStatement)
		return iDefault;
	if(!szColumnName)
		return iDefault;

	STSSQLiteDBRecordsetColumnInfo * inf = [m_pColumnsByName valueForKey:szColumnName];
	if(!inf)
		return iDefault;
	
	return sqlite3_column_int(m_pStatement,inf.index);
}


@end
