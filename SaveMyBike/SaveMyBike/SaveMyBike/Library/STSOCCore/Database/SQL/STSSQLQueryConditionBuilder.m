//  
//  Created by Szymon Tomasz Stefanek
//  Copyright © 2017 Szymon Tomasz Stefanek. All rights reserved.
//

#import "STSSQLQueryConditionBuilder.h"

#import "STSDBConnection.h"
#import "STSSQLCompoundCondition.h"
#import "STSSQLNegatedCondition.h"
#import "STSSQLBinaryCondition.h"

@implementation STSSQLQueryConditionBuilder
{
	STSDBConnection * m_oDb;
}

- (id)initWithConnection:(STSDBConnection *)db
{
	self = [super init];
	if(!self)
		return nil;
	m_oDb = db;
	return self;
}

- (NSString *)build:(STSSQLCondition *)c
{
	if(!c)
		return nil;
	
	switch(c.type)
	{
			case STSSQLConditionType_Compound:
				return [self _buildCompoundCondition:(STSSQLCompoundCondition *)c];
			case STSSQLConditionType_Not:
				return [self _buildNotCondition:(STSSQLNegatedCondition *)c];
			case STSSQLConditionType_Binary:
				return [self _buildBinaryCondition:(STSSQLBinaryCondition *)c];
	}
	
	return nil;
}


- (NSString *)_buildCompoundCondition:(STSSQLCompoundCondition *)c
{
	if(c.isEmpty)
		return @"";
		
	NSString * szOp = (c.operator == STSSQLCompoundConditionOperator_And) ? @" and " : @" or ";
		
	NSMutableString * s = [NSMutableString stringWithCapacity:50];
	NSMutableString * aux;
	NSMutableArray<STSSQLCondition *> * l = c.innerConditions;
		
	int idx = 0;
		
	for(STSSQLCondition * inner in l)
	{
		NSString * sub = [self build:inner];
		if(!sub)
			continue;
		if(sub.length < 1)
			continue;
		
		switch(idx)
		{
			case 0:
				// first no parenthesis
				[s appendString:sub];
				break;
			case 1:
				// at least two: need parentheses around all subconditions
				aux = [NSMutableString stringWithCapacity:50];
				[aux appendFormat:@"(%@)%@(%@)",s,szOp,sub];
				s = aux;
				break;
			default:
				// at least three: need parentheses around all subconditions, but the previous ones were already added
				aux = [NSMutableString stringWithCapacity:50];
				[aux appendFormat:@"%@%@(%@)",s,szOp,sub];
				s = aux;
				break;
		}
		
		idx++;
	}
	
	return s;
}

- (NSString *)_buildBinaryCondition:(STSSQLBinaryCondition *)b
{
	if(!b)
		return @"";
	
	NSMutableString * s = [NSMutableString stringWithCapacity:50];
	
	NSString * szOp = nil;

	bool bNeedRight = true;
	
	switch(b.operator)
	{
		case STSSQLOperator_IsEqualTo:
			szOp = @" = ";
			break;
		case STSSQLOperator_IsNotEqualTo:
			szOp = @" <> ";
			break;
		case STSSQLOperator_IsNull:
			szOp = @" is null";
			bNeedRight = false;
			break;
		case STSSQLOperator_IsNotNull:
			szOp = @" is not null";
			bNeedRight = false;
			break;
		case STSSQLOperator_IsGreaterThan:
			szOp = @" > ";
			break;
		case STSSQLOperator_IsGreaterOrEqualTo:
			szOp = @" >= ";
			break;
		case STSSQLOperator_IsLowerThan:
			szOp = @" < ";
			break;
		case STSSQLOperator_IsLowerOrEqualTo:
			szOp = @" <= ";
			break;
		case STSSQLOperator_In:
			szOp = @" in ";
			break;
		case STSSQLOperator_Like:
			szOp = @" like ";
			break;
		default:
			szOp = @" bug ";
			break;
	}
	
	[s appendString:[m_oDb formatSQLOperand:b.leftOperand withType:b.leftOperandType]];
	[s appendString:szOp];
	if(bNeedRight)
		[s appendString:[m_oDb formatSQLOperand:b.rightOperand withType:b.rightOperandType]];
	
	return s;
}

-(NSString *)_buildNotCondition:(STSSQLNegatedCondition *)n
{
	STSSQLCondition * inner = n.innerCondition;
	
	if(!inner)
		return @"";
	
	NSString * inx = [self build:inner];
	if(!inx || (inx.length < 1))
		return @"";
	return [NSString stringWithFormat:@"not (%@)",inx];
}

@end
