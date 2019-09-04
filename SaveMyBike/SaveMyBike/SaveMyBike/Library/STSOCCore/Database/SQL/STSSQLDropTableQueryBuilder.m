//  
//  Created by Szymon Tomasz Stefanek
//  Copyright © 2017 Szymon Tomasz Stefanek. All rights reserved.
//

#import "STSSQLDropTableQueryBuilder.h"

@implementation STSSQLDropTableQueryBuilder
{
	STSDBConnection * m_oDb;
	NSString * m_szTableName;
	bool m_bIgnoreInexistingTable;
}

- (id)initWithConnection:(STSDBConnection *)db
{
	self = [super init];
	if(!self)
		return nil;
	
	m_oDb = db;
	m_bIgnoreInexistingTable = false;
	
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

- (bool)ignoreInexistingTable
{
	return m_bIgnoreInexistingTable;
}

- (void)setIgnoreInexistingTable:(bool)bIgn
{
	m_bIgnoreInexistingTable = bIgn;
}

- (NSString *)build
{
	if((!m_szTableName) || (m_szTableName.length < 1))
		return @"";
	
	if(m_bIgnoreInexistingTable)
		return [NSString stringWithFormat:@"drop table if exists %@",m_szTableName];
	
	return [NSString stringWithFormat:@"drop table %@",m_szTableName];
}

@end
