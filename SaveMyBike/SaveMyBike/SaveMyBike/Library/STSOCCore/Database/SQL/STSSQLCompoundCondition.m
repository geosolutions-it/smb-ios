//  
//  Created by Szymon Tomasz Stefanek
//  Copyright © 2017 Szymon Tomasz Stefanek. All rights reserved.
//

#import "STSSQLCompoundCondition.h"

#import "STSSQLNegatedCondition.h"
#import "STSSQLBinaryCondition.h"

@implementation STSSQLCompoundCondition
{
	STSSQLCompoundConditionOperator m_eOperator;
	NSMutableArray<STSSQLCondition *> * m_lExpressions;
}

- (id)init
{
	self = [super initWithType:STSSQLConditionType_Compound];
	if(!self)
		return nil;
	m_eOperator = STSSQLCompoundConditionOperator_And;
	m_lExpressions = [NSMutableArray new];
	return self;
}

- (bool)isEmpty
{
	return m_lExpressions.count < 1;
}

- (NSMutableArray<STSSQLCondition *> *)innerConditions
{
	return m_lExpressions;
}

- (STSSQLCompoundConditionOperator)operator
{
	return m_eOperator;
}

- (void)setOperator:(STSSQLCompoundConditionOperator)op
{
	m_eOperator = op;
}

- (void)changeOperatorToAnd
{
	m_eOperator = STSSQLCompoundConditionOperator_And;
}

- (void)changeOperatorToOr
{
	m_eOperator = STSSQLCompoundConditionOperator_Or;
}

- (STSSQLCompoundCondition *)addAndCompoundCondition
{
	STSSQLCompoundCondition * c = [STSSQLCompoundCondition new];
	[c changeOperatorToAnd];
	[m_lExpressions addObject:c];
	return c;
}

- (STSSQLCompoundCondition *)addOrCompoundCondition
{
	STSSQLCompoundCondition * c = [STSSQLCompoundCondition new];
	[c changeOperatorToOr];
	[m_lExpressions addObject:c];
	return c;
}

- (STSSQLNegatedCondition *)addNegatedCondition
{
	STSSQLNegatedCondition * c = [STSSQLNegatedCondition new];
	[m_lExpressions addObject:c];
	return c;
}

- (STSSQLBinaryCondition *)addConditionWithLeftObject:(id)lob leftType:(STSSQLOperandType)lt operator:(STSSQLOperator)op rightObject:(id)rob rightType:(STSSQLOperandType)rt
{
	STSSQLBinaryCondition * c = [STSSQLBinaryCondition new];
	[c setLeftObject:lob leftType:lt operator:op rightObject:rob rightType:rt];
	[m_lExpressions addObject:c];
	return c;
}

- (STSSQLBinaryCondition *)addConditionWithField:(NSString *)szField operator:(STSSQLOperator)op rightObject:(id)rob rightType:(STSSQLOperandType)rt
{
	return [self addConditionWithLeftObject:szField leftType:STSSQLOperandType_Field operator:op rightObject:rob rightType:rt];
}

- (STSSQLBinaryCondition *)addIsEqualToConditionWithField:(NSString *)szField andStringConstant:(NSString *)szConstant
{
	return [self addConditionWithLeftObject:szField leftType:STSSQLOperandType_Field operator:STSSQLOperator_IsEqualTo rightObject:szConstant rightType:STSSQLOperandType_VarCharConstant];
}

- (STSSQLBinaryCondition *)addIsNotEqualToConditionWithField:(NSString *)szField andStringConstant:(NSString *)szConstant
{
	return [self addConditionWithLeftObject:szField leftType:STSSQLOperandType_Field operator:STSSQLOperator_IsNotEqualTo rightObject:szConstant rightType:STSSQLOperandType_VarCharConstant];
}

- (STSSQLBinaryCondition *)addIsLikeConditionWithField:(NSString *)szField andStringConstant:(NSString *)szConstant
{
	return [self addConditionWithLeftObject:szField leftType:STSSQLOperandType_Field operator:STSSQLOperator_Like rightObject:szConstant rightType:STSSQLOperandType_VarCharConstant];
}

- (STSSQLBinaryCondition *)addIsNullConditionWithField:(NSString *)szField
{
	return [self addConditionWithLeftObject:szField leftType:STSSQLOperandType_Field operator:STSSQLOperator_IsNull rightObject:nil rightType:STSSQLOperandType_VarCharConstant];
}

- (STSSQLBinaryCondition *)addIsNotNullConditionWithField:(NSString *)szField
{
	return [self addConditionWithLeftObject:szField leftType:STSSQLOperandType_Field operator:STSSQLOperator_IsNotNull rightObject:nil rightType:STSSQLOperandType_VarCharConstant];
}



@end
