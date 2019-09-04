//  
//  Created by Szymon Tomasz Stefanek
//  Copyright © 2017 Szymon Tomasz Stefanek. All rights reserved.
//

#import "STSSQLCreateTableQueryBuilder.h"

@implementation STSSQLCreateTableQueryBuilder
{
	STSDBConnection * m_oDb;
	NSString * m_szTableName;
	NSMutableArray<STSSQLFieldInfo *> * m_lFields;
}

- (id)initWithConnection:(STSDBConnection *)db
{
	self = [super init];
	if(!self)
		return nil;

	m_oDb = db;
	m_lFields = [NSMutableArray new];

	return self;
}

- (void)setTableName:(NSString *)szTableName
{
	m_szTableName = szTableName;
}

- (NSString *)tableName
{
	return m_szTableName;
}

- (bool)isEmpty
{
	return m_lFields.count < 1;
}

- (STSSQLFieldInfo *)addField:(NSString *)szName type:(STSSQLDataType)eType nullable:(bool)bNullable defaultValue:(id)vDefault length:(int)iLength
{
	STSSQLFieldInfo * fi = [STSSQLFieldInfo new];
	[fi setName:szName];
	[fi setType:eType];
	[fi setNullable:bNullable];
	[fi setDefaultValue:vDefault];
	[fi setLength:iLength];
	[m_lFields addObject:fi];
	return fi;
}

- (STSSQLFieldInfo *)addField:(NSString *)szName type:(STSSQLDataType)eType nullable:(bool)bNullable defaultValue:(id)vDefault
{
	STSSQLFieldInfo * fi = [STSSQLFieldInfo new];
	[fi setName:szName];
	[fi setType:eType];
	[fi setNullable:bNullable];
	[fi setDefaultValue:vDefault];
	[m_lFields addObject:fi];
	return fi;
}

- (STSSQLFieldInfo *)addField:(NSString *)szName type:(STSSQLDataType)eType nullable:(bool)bNullable
{
	STSSQLFieldInfo * fi = [STSSQLFieldInfo new];
	[fi setName:szName];
	[fi setType:eType];
	[fi setNullable:bNullable];
	[m_lFields addObject:fi];
	return fi;
}

- (STSSQLFieldInfo *)addField:(NSString *)szName type:(STSSQLDataType)eType
{
	STSSQLFieldInfo * fi = [STSSQLFieldInfo new];
	[fi setName:szName];
	[fi setType:eType];
	[m_lFields addObject:fi];
	return fi;
}

- (NSString *)build
{
	if((!m_szTableName) || (m_szTableName.length < 1))
		return @"";
	
	if(m_lFields.count < 1)
		return @"";
	
	NSMutableString * szFields = [NSMutableString stringWithCapacity:80];
	
	NSMutableArray<NSString *> * lPrimaryKey = [NSMutableArray new];
	NSMutableDictionary<NSString *,NSMutableArray<NSString *> *> * hUniqueKeys = [NSMutableDictionary new];

	// Here we work mainly with SQLITE.
	
	int iKey = 0;
	bool bKeyIsInteger = true;
	bool bKeyIsAutoIncrement = false;
	
	for(STSSQLFieldInfo * fav in m_lFields)
	{
		if(fav.isPartOfPrimaryKey)
		{
			if((fav.type != STSSQLDataType_Int32) && (fav.type != STSSQLDataType_Int64))
				bKeyIsInteger = false;
			if(fav.isAutoIncrement)
				bKeyIsAutoIncrement = true;
			iKey++;
		}
	}

	for(STSSQLFieldInfo * fav in m_lFields)
	{
		if(szFields.length > 0)
			[szFields appendString:@","];
		
		// special syntax for the primary key autoincrement
		if((iKey == 1) && fav.isPartOfPrimaryKey && bKeyIsAutoIncrement && bKeyIsInteger)
		{
			[szFields appendFormat:@"%@ integer primary key autoincrement",fav.name];
		} else {
			[szFields appendFormat:@"%@ %@",fav.name,[m_oDb mapSQLType:fav]];

			if(fav.isAutoIncrement)
				[szFields appendString:@" autoincrement"];

			if(fav.isPartOfPrimaryKey)
				[lPrimaryKey addObject:fav.name];
		
			if(fav.isNullable)
				[szFields appendString:@" null"];
			else
				[szFields appendString:@" not null"];

			if(fav.defaultValue)
				[szFields appendFormat:@" default %@",[m_oDb formatSQLConstant:fav.defaultValue withType:fav.type]];
		}
		
		if(fav.uniqueKeyNames.count > 0)
		{
			for(NSString * kn in fav.uniqueKeyNames)
			{
				NSMutableArray<NSString *> * k = [hUniqueKeys objectForKey:kn];
				if(!k)
				{
					k = [NSMutableArray new];
					[hUniqueKeys setObject:k forKey:kn];
				}
				[k addObject:fav.name];
			}
		}
	}

	NSMutableString * sql = [NSMutableString stringWithCapacity:80];
	
	[sql appendFormat:@"create table %@(%@",m_szTableName,szFields];
	
	if(lPrimaryKey.count > 0)
	{
		NSMutableString * szKey = [NSMutableString stringWithCapacity:50];
		for(NSString * s in lPrimaryKey)
		{
			if(szKey.length > 0)
				[szKey appendString:@","];
			[szKey appendString:s];
		}
		
		[sql appendFormat:@",primary key(%@)",szKey];
	}
	
	for(NSString * kak in hUniqueKeys)
	{
		NSMutableArray<NSString *> * kkl = [hUniqueKeys objectForKey:kak];

		NSMutableString * szKey = [NSMutableString stringWithCapacity:50];
		for(NSString * s in kkl)
		{
			if(szKey.length > 0)
				[szKey appendString:@","];
			[szKey appendString:s];
		}
		
		[sql appendFormat:@",unique(%@)",szKey];
	}
	
	[sql appendString:@")"];
	
	return sql;
}


@end
