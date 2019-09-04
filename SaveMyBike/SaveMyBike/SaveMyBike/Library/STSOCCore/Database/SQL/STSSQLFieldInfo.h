//  
//  Created by Szymon Tomasz Stefanek
//  Copyright © 2017 Szymon Tomasz Stefanek. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "STSSQLDataTypeInfo.h"

@interface STSSQLFieldInfo : STSSQLDataTypeInfo
{
}

- (id)init;

- (void)setIsPartOfPrimaryKey:(bool)b;
- (bool)isPartOfPrimaryKey;
- (NSString *)name;
- (void)setName:(NSString *)field;
- (bool)isNullable;
- (void)setNullable:(bool)nullable;
- (bool)isAutoIncrement;
- (void)setAutoIncrement:(bool)autoIncrement;
- (void)setIsAutoIncrement:(bool)autoIncrement; // synonym
- (id)defaultValue;
- (void)setDefaultValue:(id)aDefault;
- (NSMutableArray<NSString *> *)uniqueKeyNames;
- (void)addUniqueKeyName:(NSString *)kn;

@end
