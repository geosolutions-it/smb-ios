//
//  STSDBConnection.h
//
//  Created by Szymon Tomasz Stefanek on 10/30/12.
//  Copyright (c) 2012 Szymon Tomasz Stefanek. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "STSErrorStack.h"
#import "STSDBRecordset.h"
#import "STSSQLDataType.h"
#import "STSSQLOperandType.h"

@class STSSQLDataTypeInfo;
@class STSSQLQueryConditionBuilder;
@class STSSQLCreateTableQueryBuilder;
@class STSSQLDropTableQueryBuilder;
@class STSSQLDeleteQueryBuilder;
@class STSSQLInsertQueryBuilder;
@class STSSQLSelectQueryBuilder;
@class STSSQLUpdateQueryBuilder;

@interface STSDBConnection : NSObject
{
}


- (id)init;

/**
 * Open a database connection with the specified connection string.
 *
 * The connection string format is key=value,key=value,key=value...
 * and the key=value pairs depend on the actual database implementation.
 * A database that works over a network may require something like
 * "database=dbname,host=host.name.com,port=2100,user=xxx,..."
 * while a simple db like SQLite might be fine with a "file=filename.db"
 */
- (bool)open:(NSString *)szConnectionString;
- (bool)isOpen;
- (void)close;

- (STSDBRecordset *)query:(NSString *)szSql;
- (bool)execute:(NSString *)szSql;

- (bool)beginTransaction;
- (bool)commitTransaction;
- (bool)rollbackTransaction;

- (NSString *)quote:(NSString *)szString;

- (NSString *)mapSQLType:(STSSQLDataTypeInfo *)inf;
- (NSString *)formatSQLConstant:(id)val withType:(STSSQLDataType)eType;
- (NSString *)formatSQLOperand:(id)val withType:(STSSQLOperandType)eType;


- (STSErrorStack *)errorStack;

- (STSSQLQueryConditionBuilder *)createQueryConditionBuilder;
- (STSSQLCreateTableQueryBuilder *)createCreateTableQueryBuilder;
- (STSSQLDropTableQueryBuilder *)createDropTableQueryBuilder;
- (STSSQLDeleteQueryBuilder *)createDeleteQueryBuilder;
- (STSSQLInsertQueryBuilder *)createInsertQueryBuilder;
- (STSSQLSelectQueryBuilder *)createSelectQueryBuilder;
- (STSSQLUpdateQueryBuilder *)createUpdateQueryBuilder;


// PROTECTED STUFF

- (NSMutableDictionary *)parseConnectionString:(NSString *)szConnectionString;

@end
