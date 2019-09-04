//  
//  Created by Szymon Tomasz Stefanek
//  Copyright © 2017 Szymon Tomasz Stefanek. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "STSSQLFieldInfo.h"
#import "STSSQLDataType.h"
#import "STSDBConnection.h"


@interface STSSQLCreateTableQueryBuilder : NSObject
{
}

- (id)initWithConnection:(STSDBConnection *)db;
- (void)setTableName:(NSString *)szTableName;
- (NSString *)tableName;
- (bool)isEmpty;
- (STSSQLFieldInfo *)addField:(NSString *)szName type:(STSSQLDataType)eType nullable:(bool)bNullable defaultValue:(id)vDefault length:(int)iLength;
- (STSSQLFieldInfo *)addField:(NSString *)szName type:(STSSQLDataType)eType nullable:(bool)bNullable defaultValue:(id)vDefault;
- (STSSQLFieldInfo *)addField:(NSString *)szName type:(STSSQLDataType)eType nullable:(bool)bNullable;
- (STSSQLFieldInfo *)addField:(NSString *)szName type:(STSSQLDataType)eType;
- (NSString *)build;


@end