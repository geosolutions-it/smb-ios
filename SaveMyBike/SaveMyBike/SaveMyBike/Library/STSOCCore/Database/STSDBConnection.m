//
//  STSDBConnection.m
//
//  Created by Szymon Tomasz Stefanek on 10/30/12.
//  Copyright (c) 2012 Szymon Tomasz Stefanek. All rights reserved.
//

#import "STSDBConnection.h"

#import "STSSQLQueryConditionBuilder.h"
#import "STSSQLCreateTableQueryBuilder.h"
#import "STSSQLDropTableQueryBuilder.h"
#import "STSSQLDeleteQueryBuilder.h"
#import "STSSQLInsertQueryBuilder.h"
#import "STSSQLSelectQueryBuilder.h"
#import "STSSQLUpdateQueryBuilder.h"

@implementation STSDBConnection
{
	STSErrorStack * m_pErrorStack;
	
}

- (id)init
{
	self = [super init];
	if(!self)
		return nil;

	m_pErrorStack = [STSErrorStack new];

	return self;
}

- (STSErrorStack *)errorStack
{
	return m_pErrorStack;
}

- (bool)open:(NSString *)szConnectionString
{
	[NSException raise:@"Not Implemented" format:@"method not implemented"];
	return false;
}

- (bool)isOpen
{
	return false;	
}

- (void)close
{
	
}

- (bool)beginTransaction
{
	[NSException raise:@"Not Implemented" format:@"method not implemented"];
	return false;
}

- (bool)commitTransaction
{
	[NSException raise:@"Not Implemented" format:@"method not implemented"];
	return false;
}

- (bool)rollbackTransaction
{
	[NSException raise:@"Not Implemented" format:@"method not implemented"];
	return false;
}

- (NSString *)mapSQLType:(STSSQLDataTypeInfo *)inf
{
	return @"NOTIMPLEMENTED";
}

- (NSString *)formatSQLConstant:(id)val withType:(STSSQLDataType)eType
{
	return @"NOTIMPLEMENTED";
}

- (NSString *)formatSQLOperand:(id)val withType:(STSSQLOperandType)eType
{
	if(!val)
		return @"NULL";
	switch(eType)
	{
		case STSSQLOperandType_BitConstant:
			return [self formatSQLConstant:val withType:STSSQLDataType_Bit];
		break;
		case STSSQLOperandType_DateConstant:
			return [self formatSQLConstant:val withType:STSSQLDataType_Date];
		break;
		case STSSQLOperandType_Int8Constant:
			return [self formatSQLConstant:val withType:STSSQLDataType_Int8];
		break;
		case STSSQLOperandType_TextConstant:
			return [self formatSQLConstant:val withType:STSSQLDataType_Text];
		break;
		case STSSQLOperandType_TimeConstant:
			return [self formatSQLConstant:val withType:STSSQLDataType_Time];
		break;
		case STSSQLOperandType_Int16Constant:
			return [self formatSQLConstant:val withType:STSSQLDataType_Int16];
		break;
		case STSSQLOperandType_Int32Constant:
			return [self formatSQLConstant:val withType:STSSQLDataType_Int32];
		break;
		case STSSQLOperandType_Int64Constant:
			return [self formatSQLConstant:val withType:STSSQLDataType_Int64];
		break;
		case STSSQLOperandType_Float32Constant:
			return [self formatSQLConstant:val withType:STSSQLDataType_Float32];
		break;
		case STSSQLOperandType_Float64Constant:
			return [self formatSQLConstant:val withType:STSSQLDataType_Float64];
		break;
		case STSSQLOperandType_VarCharConstant:
			return [self formatSQLConstant:val withType:STSSQLDataType_VarChar];
		break;
		case STSSQLOperandType_DateTimeConstant:
			return [self formatSQLConstant:val withType:STSSQLDataType_DateTime];
		break;
		case STSSQLOperandType_FixedNumericConstant:
			return [self formatSQLConstant:val withType:STSSQLDataType_FixedNumeric];
		break;
		case STSSQLOperandType_SQL:
		case STSSQLOperandType_Field:
		default:
			// fall down
		break;
	}
	
	if([val isKindOfClass:[NSString class]])
		return (NSString *)val;
	if([val isKindOfClass:[NSNumber class]])
		return [NSString stringWithFormat:@"%d", [((NSNumber *)val) intValue]];
	return @"?";
}


- (NSString *)quote:(NSString *)s
{
	if(!s)
		return s;
	return [s stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
}

- (STSDBRecordset *)query:(NSString *)szSql
{
	[NSException raise:@"Not Implemented" format:@"method not implemented"];
	return nil;
}

- (bool)execute:(NSString *)szSql
{
	[NSException raise:@"Not Implemented" format:@"method not implemented"];
	return false;
}

- (NSMutableDictionary *)parseConnectionString:(NSString *)szConnectionString
{
	if(!szConnectionString)
		return nil;
	
	NSArray * pComponents = [szConnectionString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]];
	if(!pComponents)
		return nil;
	
	NSMutableDictionary * hResult = [NSMutableDictionary dictionary];
	if(!hResult)
		return nil;
	
	for(NSString * szComponent in pComponents)
	{
		if(!szComponent)
			continue;
		
		NSString * szTrimmedComponent = [szComponent stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"	 "]];
		
		if(!szTrimmedComponent)
			continue;
		
		if(szTrimmedComponent.length < 1)
			continue;
		
		
		
		NSRange r = [szTrimmedComponent rangeOfString:@"="];
		if(r.location == NSNotFound)
		{
			// assume key=1
			[hResult setObject: @"1" forKey:szTrimmedComponent];			
		} else {
			// key=value
			NSString * szKey = [szTrimmedComponent substringWithRange:NSMakeRange(0,r.location)];
			NSString * szValue = [szTrimmedComponent substringFromIndex:r.location+1];
			[hResult setObject: szValue forKey:szKey];			
		}
	}
	
	return hResult;
}

- (STSSQLQueryConditionBuilder *)createQueryConditionBuilder
{
	return [[STSSQLQueryConditionBuilder alloc] initWithConnection:self];
}

- (STSSQLCreateTableQueryBuilder *)createCreateTableQueryBuilder
{
	return [[STSSQLCreateTableQueryBuilder alloc] initWithConnection:self];
}

- (STSSQLDropTableQueryBuilder *)createDropTableQueryBuilder
{
	return [[STSSQLDropTableQueryBuilder alloc] initWithConnection:self];
}

- (STSSQLDeleteQueryBuilder *)createDeleteQueryBuilder
{
	return [[STSSQLDeleteQueryBuilder alloc] initWithConnection:self];
}

- (STSSQLInsertQueryBuilder *)createInsertQueryBuilder
{
	return [[STSSQLInsertQueryBuilder alloc] initWithConnection:self];
}

- (STSSQLSelectQueryBuilder *)createSelectQueryBuilder
{
	return [[STSSQLSelectQueryBuilder alloc] initWithConnection:self];
}

- (STSSQLUpdateQueryBuilder *)createUpdateQueryBuilder
{
	return [[STSSQLUpdateQueryBuilder alloc] initWithConnection:self];
}

@end
