//  
//  Created by Szymon Tomasz Stefanek
//  Copyright © 2017 Szymon Tomasz Stefanek. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "STSSQLCondition.h"
#import "STSSQLOperandType.h"
#import "STSSQLOperator.h"

@class STSSQLNegatedCondition;
@class STSSQLBinaryCondition;

typedef enum _SQLCompoundConditionOperator
{
	STSSQLCompoundConditionOperator_And,
	STSSQLCompoundConditionOperator_Or
} STSSQLCompoundConditionOperator;

@interface STSSQLCompoundCondition : STSSQLCondition
{
}

- (id)init;
- (bool)isEmpty;
- (NSMutableArray<STSSQLCondition *> *)innerConditions;
- (STSSQLCompoundConditionOperator)operator;
- (void)setOperator:(STSSQLCompoundConditionOperator)op;
- (void)changeOperatorToAnd;
- (void)changeOperatorToOr;
- (STSSQLCompoundCondition *)addAndCompoundCondition;
- (STSSQLCompoundCondition *)addOrCompoundCondition;
- (STSSQLNegatedCondition *)addNegatedCondition;

- (STSSQLBinaryCondition *)addConditionWithLeftObject:(id)lob leftType:(STSSQLOperandType)lt operator:(STSSQLOperator)op rightObject:(id)rob rightType:(STSSQLOperandType)rt;
- (STSSQLBinaryCondition *)addConditionWithField:(NSString *)szField operator:(STSSQLOperator)op rightObject:(id)rob rightType:(STSSQLOperandType)rt;
- (STSSQLBinaryCondition *)addIsEqualToConditionWithField:(NSString *)szField andStringConstant:(NSString *)szConstant;
- (STSSQLBinaryCondition *)addIsNotEqualToConditionWithField:(NSString *)szField andStringConstant:(NSString *)szConstant;
- (STSSQLBinaryCondition *)addIsLikeConditionWithField:(NSString *)szField andStringConstant:(NSString *)szConstant;
- (STSSQLBinaryCondition *)addIsNullConditionWithField:(NSString *)szField;
- (STSSQLBinaryCondition *)addIsNotNullConditionWithField:(NSString *)szField;

@end


