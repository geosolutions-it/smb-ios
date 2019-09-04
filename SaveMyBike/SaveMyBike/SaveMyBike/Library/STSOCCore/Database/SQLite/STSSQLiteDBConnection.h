//
//  STSSQLiteDBConnection.h
//
//  Created by Szymon Tomasz Stefanek on 10/30/12.
//  Copyright (c) 2012 Szymon Tomasz Stefanek. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "STSDBConnection.h"

#import <sqlite3.h>


@interface STSSQLiteDBConnection : STSDBConnection
{
}

- (id)init;
- (void)dealloc;

- (bool)open:(NSString *)szConnectionString;
- (void)close;

- (STSDBRecordset *)query:(NSString *)szSql;
- (bool)execute:(NSString *)szSql;

- (bool)beginTransaction;
- (bool)rollbackTransaction;
- (bool)commitTransaction;

- (NSString *)mapSQLType:(STSSQLDataTypeInfo *)inf;
- (NSString *)formatSQLConstant:(id)val withType:(STSSQLDataType)eType;

- (NSString *)quote:(NSString *)szString;

//- (int)userVersion;
//- (bool)setUserVersion:(int)iVersion;

- (long long)lastInsertRowId;

@end
			
