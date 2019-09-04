//
//  STSSQLiteDBRecordset.h
//
//  Created by Szymon Tomasz Stefanek on 10/30/12.
//  Copyright (c) 2012 Szymon Tomasz Stefanek. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "STSDBRecordset.h"

#import <sqlite3.h>

@interface STSSQLiteDBRecordset : STSDBRecordset
{
}

- (void)close;
- (bool)isOpen;
- (bool)read;
- (void)dealloc;

- (int)columnIndexForColumnName:(NSString *)szColumnName;

- (id)field:(NSString *)szColumnName withDefault:(id)vDefault;
- (id)field:(NSString *)szColumnName;

- (id)fieldByColumnIndex:(int)iColumnIndex withDefault:(id)vDefault;
- (id)fieldByColumnIndex:(int)iColumnIndex;

- (long)longField:(NSString *)szColumnName withDefault:(long)lDefault;
- (int)intField:(NSString *)szColumnName withDefault:(int)iDefault;


// PROTECTED

- (id)initWithSQLiteStatement:(sqlite3_stmt *)pStatement;


@end
