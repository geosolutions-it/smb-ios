//  
//  Created by Szymon Tomasz Stefanek
//  Copyright © 2017 Szymon Tomasz Stefanek. All rights reserved.
//

typedef enum _SQLOperator
{
	STSSQLOperator_IsEqualTo,
	STSSQLOperator_IsNotEqualTo,
	STSSQLOperator_IsNull,
	STSSQLOperator_IsNotNull,
	STSSQLOperator_IsGreaterThan,
	STSSQLOperator_IsGreaterOrEqualTo,
	STSSQLOperator_IsLowerThan,
	STSSQLOperator_IsLowerOrEqualTo,
	STSSQLOperator_In,
	STSSQLOperator_Like

} STSSQLOperator;
