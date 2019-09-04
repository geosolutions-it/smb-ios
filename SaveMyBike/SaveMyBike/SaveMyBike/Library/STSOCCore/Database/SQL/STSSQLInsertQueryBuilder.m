//  
//  Created by Szymon Tomasz Stefanek
//  Copyright © 2017 Szymon Tomasz Stefanek. All rights reserved.
//

#import "STSSQLInsertQueryBuilder.h"

@interface STSSQLInsertQueryBuilderFieldAndValue : NSObject
{
}

@property(nonatomic) NSString * field;
@property(nonatomic) STSSQLOperandType valueType;
@property(nonatomic) id value;


@end

@implementation STSSQLInsertQueryBuilderFieldAndValue
@end

@implementation STSSQLInsertQueryBuilder
{
	STSDBConnection * m_oDb;
	NSString * m_szTableName;
	NSString * m_szReturnAutoIncrementField;
	NSString * m_szReturnAutoIncrementFieldAlias;
	NSMutableArray<STSSQLInsertQueryBuilderFieldAndValue *> * m_lValues;

}

- (id)initWithConnection:(STSDBConnection *)db
{
	self = [super init];
	if(!self)
		return nil;
	
	m_oDb = db;
	m_lValues = [NSMutableArray new];
	
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

- (bool)isEmpty
{
	return m_lValues.count < 1;
}

- (void)setReturnAutoIncrementField:(NSString *)szFieldName withAlias:(NSString *)szAlias
{
	m_szReturnAutoIncrementField = szFieldName;
	m_szReturnAutoIncrementFieldAlias = szAlias;
}

- (void)addValue:(id)oValue forField:(NSString *)szField withType:(STSSQLOperandType)eType
{
	STSSQLInsertQueryBuilderFieldAndValue * v = [STSSQLInsertQueryBuilderFieldAndValue new];
	v.field = szField;
	v.valueType = eType;
	v.value = oValue;
	[m_lValues addObject:v];
}

- (void)addCharValue:(char)oValue forField:(NSString *)szField withType:(STSSQLOperandType)eType
{
	STSSQLInsertQueryBuilderFieldAndValue * v = [STSSQLInsertQueryBuilderFieldAndValue new];
	v.field = szField;
	v.valueType = eType;
	v.value = [NSNumber numberWithChar:oValue];
	[m_lValues addObject:v];
}

- (void)addShortValue:(short)oValue forField:(NSString *)szField withType:(STSSQLOperandType)eType
{
	STSSQLInsertQueryBuilderFieldAndValue * v = [STSSQLInsertQueryBuilderFieldAndValue new];
	v.field = szField;
	v.valueType = eType;
	v.value = [NSNumber numberWithShort:oValue];
	[m_lValues addObject:v];
}

- (void)addIntValue:(int)oValue forField:(NSString *)szField withType:(STSSQLOperandType)eType
{
	STSSQLInsertQueryBuilderFieldAndValue * v = [STSSQLInsertQueryBuilderFieldAndValue new];
	v.field = szField;
	v.valueType = eType;
	v.value = [NSNumber numberWithInt:oValue];
	[m_lValues addObject:v];
}

- (void)addLongValue:(long)oValue forField:(NSString *)szField withType:(STSSQLOperandType)eType
{
	STSSQLInsertQueryBuilderFieldAndValue * v = [STSSQLInsertQueryBuilderFieldAndValue new];
	v.field = szField;
	v.valueType = eType;
	v.value = [NSNumber numberWithLong:oValue];
	[m_lValues addObject:v];
}

- (void)addFloatValue:(float)oValue forField:(NSString *)szField withType:(STSSQLOperandType)eType
{
	STSSQLInsertQueryBuilderFieldAndValue * v = [STSSQLInsertQueryBuilderFieldAndValue new];
	v.field = szField;
	v.valueType = eType;
	v.value = [NSNumber numberWithFloat:oValue];
	[m_lValues addObject:v];
}

- (void)addDoubleValue:(double)oValue forField:(NSString *)szField withType:(STSSQLOperandType)eType
{
	STSSQLInsertQueryBuilderFieldAndValue * v = [STSSQLInsertQueryBuilderFieldAndValue new];
	v.field = szField;
	v.valueType = eType;
	v.value = [NSNumber numberWithDouble:oValue];
	[m_lValues addObject:v];
}

- (void)addBoolValue:(bool)oValue forField:(NSString *)szField withType:(STSSQLOperandType)eType
{
	STSSQLInsertQueryBuilderFieldAndValue * v = [STSSQLInsertQueryBuilderFieldAndValue new];
	v.field = szField;
	v.valueType = eType;
	v.value = [NSNumber numberWithBool:oValue];
	[m_lValues addObject:v];
}

- (void)addStringValue:(NSString *)oValue forField:(NSString *)szField withType:(STSSQLOperandType)eType
{
	STSSQLInsertQueryBuilderFieldAndValue * v = [STSSQLInsertQueryBuilderFieldAndValue new];
	v.field = szField;
	v.valueType = eType;
	v.value = oValue;
	[m_lValues addObject:v];
}

- (NSString *)build
{
	if((!m_szTableName) || (m_szTableName.length < 1))
		return @"";
	
	if(m_lValues.count < 1)
		return @"";

	NSMutableString * szFields = [NSMutableString stringWithCapacity:50];
	NSMutableString * szValues = [NSMutableString stringWithCapacity:50];

	for(STSSQLInsertQueryBuilderFieldAndValue * v in m_lValues)
	{
		if(szFields.length > 0)
		{
			[szFields appendString:@","];
			[szValues appendString:@","];
		}

		[szFields appendString:v.field];
		[szValues appendString:[m_oDb formatSQLOperand:v.value withType:v.valueType]];
	}
	
	NSMutableString * sql = [NSMutableString stringWithCapacity:100];
	
	[sql appendFormat:@"insert into %@ (%@) values (%@)",m_szTableName,szFields,szValues];


	//if(m_bReturnAutoIncrementField)
	//	[sql appendString:@"; select last_insert_rowid()"]; // FIXME: this is SQLITE!

	if(m_szReturnAutoIncrementField && m_szReturnAutoIncrementFieldAlias)
		[sql appendString:
				[NSString
						stringWithFormat:@"; select %@ as %@ from %@ order by %@ desc limit 1",
							m_szReturnAutoIncrementField,
							m_szReturnAutoIncrementFieldAlias,
							m_szTableName,
							m_szReturnAutoIncrementField
					]
			];


	return sql;
}

@end
