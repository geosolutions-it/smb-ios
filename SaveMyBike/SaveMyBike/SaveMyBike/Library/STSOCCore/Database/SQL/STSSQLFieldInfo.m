//  
//  Created by Szymon Tomasz Stefanek
//  Copyright © 2017 Szymon Tomasz Stefanek. All rights reserved.
//

#import "STSSQLFieldInfo.h"

@implementation STSSQLFieldInfo
{
	NSString * m_szName;
	bool m_bNullable;
	bool m_bAutoIncrement;
	id m_vDefaultValue;
	bool m_bIsPartOfPrimaryKey;
	NSMutableArray<NSString *> * m_lUniqueKeyNames;
}

- (id)init
{
	self = [super init];
	if(!self)
		return nil;
	
	m_lUniqueKeyNames = [NSMutableArray new];
	
	return self;
}

- (void)setIsPartOfPrimaryKey:(bool)b
{
	m_bIsPartOfPrimaryKey = b;
}

- (bool)isPartOfPrimaryKey
{
	return m_bIsPartOfPrimaryKey;
}

- (NSString *)name
{
	return m_szName;
}

- (void)setName:(NSString *)field
{
	m_szName = field;
}

- (bool)isNullable
{
	return m_bNullable;
}

- (void)setNullable:(bool)nullable
{
	m_bNullable = nullable;
}

- (bool)isAutoIncrement
{
	return m_bAutoIncrement;
}

- (void)setAutoIncrement:(bool)autoIncrement
{
	m_bAutoIncrement = autoIncrement;
}

- (void)setIsAutoIncrement:(bool)autoIncrement
{
	m_bAutoIncrement = autoIncrement;
}

- (id)defaultValue
{
	return m_vDefaultValue;
}

- (void)setDefaultValue:(id)aDefault
{
	m_vDefaultValue = aDefault;
}

- (NSMutableArray<NSString *> *)uniqueKeyNames
{
	return m_lUniqueKeyNames;
}

- (void)addUniqueKeyName:(NSString *)kn
{
	[m_lUniqueKeyNames addObject:kn];
}


@end
