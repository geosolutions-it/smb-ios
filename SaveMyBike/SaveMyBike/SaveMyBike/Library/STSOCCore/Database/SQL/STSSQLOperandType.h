//  
//  Created by Szymon Tomasz Stefanek
//  Copyright © 2017 Szymon Tomasz Stefanek. All rights reserved.
//


typedef enum _SQLOperandType
{
	STSSQLOperandType_Field,
	STSSQLOperandType_SQL,
	STSSQLOperandType_BitConstant,
	STSSQLOperandType_Int8Constant,
	STSSQLOperandType_Int16Constant,
	STSSQLOperandType_Int32Constant,
	STSSQLOperandType_Int64Constant,
	STSSQLOperandType_Float32Constant,
	STSSQLOperandType_Float64Constant,
	STSSQLOperandType_FixedNumericConstant,
	STSSQLOperandType_VarCharConstant,
	STSSQLOperandType_TextConstant,
	STSSQLOperandType_DateTimeConstant,
	STSSQLOperandType_DateConstant,
	STSSQLOperandType_TimeConstant

} STSSQLOperandType;
