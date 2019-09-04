//
//  Created by Szymon Tomasz Stefanek
//  Copyright © 2017 Szymon Tomasz Stefanek. All rights reserved.
//

#import "STSSQLSelectQueryBuilder.h"
#import "STSDBConnection.h"
#import "STSSQLQueryConditionBuilder.h"

@implementation STSSQLSelectQueryBuilderOrderByEntry
@end

@implementation STSSQLSelectQueryBuilderJoin
{
	NSString * m_szTableName;
	STSSQLSelectQueryBuilderJoinType m_eType;
	STSSQLCompoundCondition * m_pCondition;
}

- (id)initWithTable:(NSString *)szTableName andType:(STSSQLSelectQueryBuilderJoinType)eType
{
	self = [super init];
	if(!self)
		return nil;
	
	m_szTableName = szTableName;
	m_eType = eType;
	m_pCondition = [STSSQLCompoundCondition new];
	
	return self;
}

- (STSSQLCompoundCondition *)condition
{
	return m_pCondition;
}

- (STSSQLSelectQueryBuilderJoinType)type
{
	return m_eType;
}

- (NSString *)tableName
{
	return m_szTableName;
}

@end


@implementation STSSQLSelectQueryBuilder
{
	STSDBConnection * m_oDb;
	NSString * m_szTableName;
	STSSQLCompoundCondition * m_oWhere;
	NSMutableArray<NSString *> * m_lSelectFields;
	NSMutableArray<STSSQLSelectQueryBuilderOrderByEntry *> * m_lOrderBy;
	NSMutableArray<STSSQLSelectQueryBuilderJoin *> * m_lJoins;
	int m_iOffset;
	int m_iLimit;
}

- (id)initWithConnection:(STSDBConnection *)db
{
	self = [super init];
	if(!self)
		return nil;
	
	m_oDb = db;
	m_oWhere = [STSSQLCompoundCondition new];
	m_iOffset = -1;
	m_iLimit = -1;
	
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

- (void)addSelectField:(NSString *)szField
{
	if(!m_lSelectFields)
		m_lSelectFields = [NSMutableArray new];
	[m_lSelectFields addObject:szField];
}

- (NSMutableArray<NSString *> *)selectFields
{
	return m_lSelectFields;
}

- (STSSQLSelectQueryBuilderJoin *)addJoinWithTable:(NSString *)szTableName andType:(STSSQLSelectQueryBuilderJoinType)eType
{
	STSSQLSelectQueryBuilderJoin * j = [[STSSQLSelectQueryBuilderJoin alloc] initWithTable:szTableName andType:eType];
	
	if(!m_lJoins)
		m_lJoins = [NSMutableArray new];

	[m_lJoins addObject:j];
	
	return j;
}

- (STSSQLSelectQueryBuilderJoin *)addJoinWithTable:(NSString *)szTableName
{
	return [self addJoinWithTable:szTableName andType:STSSQLSelectQueryBuilderJoinType_Left];
}

- (void)addOrderBy:(NSString *)szByWhat withDirection:(STSSQLSelectQueryBuilderOrderByDirection)eDirection
{
	STSSQLSelectQueryBuilderOrderByEntry * e = [STSSQLSelectQueryBuilderOrderByEntry new];
	e.item = szByWhat;
	e.direction = eDirection;
	
	if(!m_lOrderBy)
		m_lOrderBy = [NSMutableArray new];
	
	[m_lOrderBy addObject:e];
}

- (void)addOrderBy:(NSString *)szByWhat
{
	[self addOrderBy:szByWhat withDirection:STSSQLSelectQueryBuilderOrderByDirection_Default];
}

- (NSMutableArray<STSSQLSelectQueryBuilderOrderByEntry *> *)orderBy
{
	return m_lOrderBy;
}

- (void)setLimit:(int)iLimit
{
	m_iLimit = iLimit;
}

- (int)limit
{
	return m_iLimit;
}

- (void)setOffet:(int)iOffset
{
	m_iOffset = iOffset;
}

- (int)offset
{
	return m_iOffset;
}

- (NSString *)build
{
	if((!m_szTableName) || (m_szTableName.length < 1))
		return @"";

	NSMutableString * sql = [NSMutableString stringWithCapacity:50];

	[sql appendString:@"select "];

	if((!m_lSelectFields) || (m_lSelectFields.count < 1))
	{
		[sql appendString:@"*"];
	} else {
		NSMutableString * flds = [NSMutableString stringWithCapacity:50];
		for(NSString * fld in m_lSelectFields)
		{
			if(flds.length > 0)
				[flds appendString:@","];
			[flds appendString:fld];
		}
		[sql appendString:flds];
	}
	
	[sql appendFormat:@" from %@",m_szTableName];
	
	if(m_lJoins && (m_lJoins.count > 0))
	{
		for(STSSQLSelectQueryBuilderJoin * j in m_lJoins)
		{
			NSMutableString * js = [NSMutableString stringWithCapacity:50];

			switch(j.type)
			{
				case STSSQLSelectQueryBuilderJoinType_Left:
					[js appendString:@" left join "];
					break;
				case STSSQLSelectQueryBuilderJoinType_Inner:
					[js appendString:@" inner join "];
					break;
				case STSSQLSelectQueryBuilderJoinType_Outer:
					[js appendString:@" outer join "];
					break;
				case STSSQLSelectQueryBuilderJoinType_Right:
					[js appendString:@" right join "];
					break;
				default:
					//throw new Error("Internal error");
					[js appendString:@" left join "];
			}
			
			[js appendString:j.tableName];
			
			STSSQLQueryConditionBuilder * eb = [m_oDb createQueryConditionBuilder];
			[js appendFormat:@" on (%@)",[eb build:j.condition]];
			
			[sql appendString:js];
		}
	}
	
	if(!m_oWhere.isEmpty)
	{
		STSSQLQueryConditionBuilder * eb = [m_oDb createQueryConditionBuilder];
		NSString * c = [eb build:m_oWhere];
		if(c && (c.length > 0))
			[sql appendFormat:@" where %@",c];
	}
	
	if(m_lOrderBy && (m_lOrderBy.count > 0))
	{
		NSMutableString * flds = [NSMutableString stringWithCapacity:50];
		for(STSSQLSelectQueryBuilderOrderByEntry * obe in m_lOrderBy)
		{
			if(flds.length > 0)
				[flds appendString:@","];

			[flds appendString:obe.item];

			switch(obe.direction)
			{
				case STSSQLSelectQueryBuilderOrderByDirection_Default:
					break;
				case STSSQLSelectQueryBuilderOrderByDirection_Ascending:
					[flds appendString:@" asc"];
					break;
				case STSSQLSelectQueryBuilderOrderByDirection_Descending:
					[flds appendString:@" desc"];
					break;
			}
		}
		[sql appendFormat:@" order by %@",flds];
	}
	
	if(m_iOffset > 0)
		[sql appendFormat:@" offset %d",m_iOffset];

	if(m_iLimit > 0)
		[sql appendFormat:@" limit %d",m_iLimit];
	
	return sql;

}

@end

