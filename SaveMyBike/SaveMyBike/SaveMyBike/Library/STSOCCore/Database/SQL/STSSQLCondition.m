//  
//  Created by Szymon Tomasz Stefanek
//  Copyright © 2017 Szymon Tomasz Stefanek. All rights reserved.
//

#import "STSSQLCondition.h"

@implementation STSSQLCondition
{
	STSSQLConditionType_ m_eType;
}

- (id)initWithType:(STSSQLConditionType_)eType
{
	self = [super init];
	if(!self)
		return nil;
	
	m_eType = eType;
	
	return self;
}

- (STSSQLConditionType_)type
{
	return m_eType;
}

@end