//  
//  Created by Szymon Tomasz Stefanek
//  Copyright © 2017 Szymon Tomasz Stefanek. All rights reserved.
//

#import "STSSQLNegatedCondition.h"

@implementation STSSQLNegatedCondition
{
	STSSQLCondition * m_pInnerCondition;
}


- (STSSQLCondition *)innerCondition
{
	return m_pInnerCondition;
}

- (void)setInnerCondition:(STSSQLCondition *)c
{
	m_pInnerCondition = c;
}

@end
