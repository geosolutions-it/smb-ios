//  
//  Created by Szymon Tomasz Stefanek
//  Copyright © 2017 Szymon Tomasz Stefanek. All rights reserved.
//

#import "STSSQLDeleteQueryBuilder.h"
#import "STSSQLQueryConditionBuilder.h"

@implementation STSSQLDeleteQueryBuilder
{
	STSDBConnection * m_oDb;
	NSString * m_szTableName;
	STSSQLCompoundCondition * m_oWhere;
}

- (id)initWithConnection:(STSDBConnection *)db
{
	self = [super init];
	if(!self)
		return nil;
	
	m_oDb = db;
	m_oWhere = [STSSQLCompoundCondition new];
	
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

- (STSSQLCompoundCondition *)where
{
	return m_oWhere;
}

- (NSString *)build
{
	if((!m_szTableName) || (m_szTableName.length < 1))
		return @"";
	
	NSMutableString * szSql = [NSMutableString stringWithCapacity:80];
	
	[szSql appendFormat:@"delete from %@",m_szTableName];
	
	if(![m_oWhere isEmpty])
	{
		STSSQLQueryConditionBuilder * eb = [m_oDb createQueryConditionBuilder];
		NSString * c = [eb build:m_oWhere];
		if(c && (c.length > 0))
			[szSql appendFormat:@" where %@",c];
	}
	
	return szSql;
}

@end
