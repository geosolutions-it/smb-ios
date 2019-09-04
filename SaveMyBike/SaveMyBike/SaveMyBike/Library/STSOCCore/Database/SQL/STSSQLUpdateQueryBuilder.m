//
//  Created by Szymon Tomasz Stefanek
//  Copyright © 2017 Szymon Tomasz Stefanek. All rights reserved.
//

#import "STSSQLUpdateQueryBuilder.h"
#import "STSSQLQueryConditionBuilder.h"

@interface STSSQLUpdateQueryBuilderFieldAndValue : NSObject
{
}

@property(nonatomic) NSString * field;
@property(nonatomic) STSSQLOperandType valueType;
@property(nonatomic) id value;


@end

@implementation STSSQLUpdateQueryBuilderFieldAndValue
@end

@implementation STSSQLUpdateQueryBuilder
{
	STSDBConnection * m_oDb;
	NSString * m_szTableName;
	NSMutableArray<STSSQLUpdateQueryBuilderFieldAndValue *> * m_lValues;
	STSSQLCompoundCondition * m_oWhere;
}

- (id)initWithConnection:(STSDBConnection *)db
{
	self = [super init];
	if(!self)
		return nil;
	
	m_oDb = db;
	m_lValues = [NSMutableArray new];
	m_oWhere = [STSSQLCompoundCondition new];
	
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

- (STSSQLCompoundCondition *)where
{
	return m_oWhere;
}

- (void)addValue:(id)oValue forField:(NSString *)szField withType:(STSSQLOperandType)eType
{
	STSSQLUpdateQueryBuilderFieldAndValue * v = [STSSQLUpdateQueryBuilderFieldAndValue new];
	v.field = szField;
	v.valueType = eType;
	v.value = oValue;
	[m_lValues addObject:v];
}

- (void)addCharValue:(char)oValue forField:(NSString *)szField withType:(STSSQLOperandType)eType
{
	STSSQLUpdateQueryBuilderFieldAndValue * v = [STSSQLUpdateQueryBuilderFieldAndValue new];
	v.field = szField;
	v.valueType = eType;
	v.value = [NSNumber numberWithChar:oValue];
	[m_lValues addObject:v];
}

- (void)addShortValue:(short)oValue forField:(NSString *)szField withType:(STSSQLOperandType)eType
{
	STSSQLUpdateQueryBuilderFieldAndValue * v = [STSSQLUpdateQueryBuilderFieldAndValue new];
	v.field = szField;
	v.valueType = eType;
	v.value = [NSNumber numberWithShort:oValue];
	[m_lValues addObject:v];
}

- (void)addIntValue:(int)oValue forField:(NSString *)szField withType:(STSSQLOperandType)eType
{
	STSSQLUpdateQueryBuilderFieldAndValue * v = [STSSQLUpdateQueryBuilderFieldAndValue new];
	v.field = szField;
	v.valueType = eType;
	v.value = [NSNumber numberWithInt:oValue];
	[m_lValues addObject:v];
}

- (void)addLongValue:(long)oValue forField:(NSString *)szField withType:(STSSQLOperandType)eType
{
	STSSQLUpdateQueryBuilderFieldAndValue * v = [STSSQLUpdateQueryBuilderFieldAndValue new];
	v.field = szField;
	v.valueType = eType;
	v.value = [NSNumber numberWithLong:oValue];
	[m_lValues addObject:v];
}

- (void)addFloatValue:(float)oValue forField:(NSString *)szField withType:(STSSQLOperandType)eType
{
	STSSQLUpdateQueryBuilderFieldAndValue * v = [STSSQLUpdateQueryBuilderFieldAndValue new];
	v.field = szField;
	v.valueType = eType;
	v.value = [NSNumber numberWithFloat:oValue];
	[m_lValues addObject:v];
}

- (void)addDoubleValue:(double)oValue forField:(NSString *)szField withType:(STSSQLOperandType)eType
{
	STSSQLUpdateQueryBuilderFieldAndValue * v = [STSSQLUpdateQueryBuilderFieldAndValue new];
	v.field = szField;
	v.valueType = eType;
	v.value = [NSNumber numberWithDouble:oValue];
	[m_lValues addObject:v];
}

- (void)addBoolValue:(bool)oValue forField:(NSString *)szField withType:(STSSQLOperandType)eType
{
	STSSQLUpdateQueryBuilderFieldAndValue * v = [STSSQLUpdateQueryBuilderFieldAndValue new];
	v.field = szField;
	v.valueType = eType;
	v.value = [NSNumber numberWithBool:oValue];
	[m_lValues addObject:v];
}

- (void)addStringValue:(NSString *)oValue forField:(NSString *)szField withType:(STSSQLOperandType)eType
{
	STSSQLUpdateQueryBuilderFieldAndValue * v = [STSSQLUpdateQueryBuilderFieldAndValue new];
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

	NSMutableString * szFieldsAndValues = [NSMutableString stringWithCapacity:50];

	for(STSSQLUpdateQueryBuilderFieldAndValue * v in m_lValues)
	{
		if(szFieldsAndValues.length > 0)
			[szFieldsAndValues appendString:@","];

		[szFieldsAndValues appendFormat:@"%@=%@",v.field,[m_oDb formatSQLOperand:v.value withType:v.valueType]];
	}

	NSMutableString * sql = [NSMutableString stringWithCapacity:100];
	
	[sql appendFormat:@"update %@ set %@",m_szTableName,szFieldsAndValues];

	if(!m_oWhere.isEmpty)
	{
		STSSQLQueryConditionBuilder * eb = [m_oDb createQueryConditionBuilder];
		NSString * c = [eb build:m_oWhere];
		if(c && (c.length > 0))
			[sql appendFormat:@" where %@",c];
	}
	
	return sql;
}

@end
