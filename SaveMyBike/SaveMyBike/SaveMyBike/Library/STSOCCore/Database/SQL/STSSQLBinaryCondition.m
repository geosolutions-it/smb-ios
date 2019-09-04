//  
//  Created by Szymon Tomasz Stefanek
//  Copyright © 2017 Szymon Tomasz Stefanek. All rights reserved.
//

#import "STSSQLBinaryCondition.h"

@implementation STSSQLBinaryCondition
{
	STSSQLOperandType m_eLeftOperandType;
	id m_oLeftOperand;
	STSSQLOperandType m_eRightOperandType;
	id m_oRightOperand;
	STSSQLOperator m_eOperator;
}

- (id)init
{
	self = [super initWithType:STSSQLConditionType_Binary];
	if(!self)
		return nil;
	
	return self;
}

- (STSSQLOperator)operator
{
	return m_eOperator;
}

- (void)setOperator:(STSSQLOperator)op
{
	m_eOperator = op;
}

- (STSSQLOperandType)leftOperandType
{
	return m_eLeftOperandType;
}

- (id)leftOperand
{
	return m_oLeftOperand;
}

- (void)setLeftOperand:(id)op withType:(STSSQLOperandType)t
{
	m_oLeftOperand = op;
	m_eLeftOperandType = t;
}

- (STSSQLOperandType)rightOperandType
{
	return m_eRightOperandType;
}

- (id)rightOperand
{
	return m_oRightOperand;
}

- (void)setRightOperand:(id)op withType:(STSSQLOperandType)t
{
	m_oRightOperand = op;
	m_eRightOperandType = t;
}

- (void)setLeftObject:(id)lob leftType:(STSSQLOperandType)lt operator:(STSSQLOperator)op rightObject:(id)rob  rightType:(STSSQLOperandType)rt
{
	m_oLeftOperand = lob;
	m_eLeftOperandType = lt;
	m_eOperator = op;
	m_oRightOperand = rob;
	m_eRightOperandType = rt;
}

@end
