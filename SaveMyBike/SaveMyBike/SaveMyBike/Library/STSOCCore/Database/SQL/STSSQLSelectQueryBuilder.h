//
//  Created by Szymon Tomasz Stefanek
//  Copyright © 2017 Szymon Tomasz Stefanek. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "STSSQLCompoundCondition.h"

@class STSDBConnection;

typedef enum _SQLSelectQueryBuilderOrderByDirection
{
	STSSQLSelectQueryBuilderOrderByDirection_Default,
	STSSQLSelectQueryBuilderOrderByDirection_Ascending,
	STSSQLSelectQueryBuilderOrderByDirection_Descending
} STSSQLSelectQueryBuilderOrderByDirection;

typedef enum _SQLSelectQueryBuilderJoinType
{
	STSSQLSelectQueryBuilderJoinType_Left,
	STSSQLSelectQueryBuilderJoinType_Inner,
	STSSQLSelectQueryBuilderJoinType_Outer,
	STSSQLSelectQueryBuilderJoinType_Right
} STSSQLSelectQueryBuilderJoinType;


@interface STSSQLSelectQueryBuilderOrderByEntry : NSObject
{
}

@property(nonatomic) NSString * item;
@property(nonatomic) STSSQLSelectQueryBuilderOrderByDirection direction;

@end

@interface STSSQLSelectQueryBuilderJoin : NSObject
{
}

- (id)initWithTable:(NSString *)szTableName andType:(STSSQLSelectQueryBuilderJoinType)eType;

- (STSSQLCompoundCondition *)condition;
- (STSSQLSelectQueryBuilderJoinType)type;
- (NSString *)tableName;

@end

	
@interface STSSQLSelectQueryBuilder : NSObject
{
}

- (id)initWithConnection:(STSDBConnection *)db;
- (void)setTableName:(NSString *)szTableName;
- (NSString *)tableName;
- (void)addSelectField:(NSString *)szField;
- (NSMutableArray<NSString *> *)selectFields;
- (STSSQLSelectQueryBuilderJoin *)addJoinWithTable:(NSString *)szTableName andType:(STSSQLSelectQueryBuilderJoinType)eType;
- (STSSQLSelectQueryBuilderJoin *)addJoinWithTable:(NSString *)szTableName;
- (void)addOrderBy:(NSString *)szByWhat withDirection:(STSSQLSelectQueryBuilderOrderByDirection)eDirection;
- (void)addOrderBy:(NSString *)szByWhat;
- (NSMutableArray<STSSQLSelectQueryBuilderOrderByEntry *> *)orderBy;
- (void)setLimit:(int)iLimit;
- (int)limit;
- (void)setOffet:(int)iOffset;
- (int)offset;
- (STSSQLCompoundCondition *)where;

- (NSString *)build;

@end
