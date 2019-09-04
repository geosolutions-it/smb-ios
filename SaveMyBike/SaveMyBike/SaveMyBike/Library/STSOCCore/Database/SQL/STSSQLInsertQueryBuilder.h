//  
//  Created by Szymon Tomasz Stefanek
//  Copyright © 2017 Szymon Tomasz Stefanek. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "STSSQLOperandType.h"
#import "STSDBConnection.h"

@interface STSSQLInsertQueryBuilder : NSObject
{
}

- (id)initWithConnection:(STSDBConnection *)db;
- (void)setTableName:(NSString *)szTableName;
- (NSString *)tableName;
- (bool)isEmpty;
- (void)setReturnAutoIncrementField:(NSString *)szFieldName withAlias:(NSString *)szAlias;

- (void)addValue:(id)oValue forField:(NSString *)szField withType:(STSSQLOperandType)eType;

- (void)addCharValue:(char)oValue forField:(NSString *)szField withType:(STSSQLOperandType)eType;
- (void)addShortValue:(short)oValue forField:(NSString *)szField withType:(STSSQLOperandType)eType;
- (void)addIntValue:(int)oValue forField:(NSString *)szField withType:(STSSQLOperandType)eType;
- (void)addLongValue:(long)oValue forField:(NSString *)szField withType:(STSSQLOperandType)eType;
- (void)addFloatValue:(float)oValue forField:(NSString *)szField withType:(STSSQLOperandType)eType;
- (void)addDoubleValue:(double)oValue forField:(NSString *)szField withType:(STSSQLOperandType)eType;
- (void)addBoolValue:(bool)oValue forField:(NSString *)szField withType:(STSSQLOperandType)eType;
- (void)addStringValue:(NSString *)oValue forField:(NSString *)szField withType:(STSSQLOperandType)eType;

- (NSString *)build;


@end
