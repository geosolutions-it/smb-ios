//  
//  Created by Szymon Tomasz Stefanek
//  Copyright © 2017 Szymon Tomasz Stefanek. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "STSSQLCondition.h"
#import "STSSQLOperator.h"
#import "STSSQLOperandType.h"

@interface STSSQLBinaryCondition : STSSQLCondition

- (id)init;

- (STSSQLOperator)operator;
- (void)setOperator:(STSSQLOperator)op;
- (STSSQLOperandType)leftOperandType;
- (id)leftOperand;
- (void)setLeftOperand:(id)op withType:(STSSQLOperandType)t;
- (STSSQLOperandType)rightOperandType;
- (id)rightOperand;
- (void)setRightOperand:(id)op withType:(STSSQLOperandType)t;
- (void)setLeftObject:(id)lob leftType:(STSSQLOperandType)lt operator:(STSSQLOperator)op rightObject:(id)rob  rightType:(STSSQLOperandType)rt;


@end