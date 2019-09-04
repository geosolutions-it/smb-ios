//  
//  Created by Szymon Tomasz Stefanek
//  Copyright © 2017 Szymon Tomasz Stefanek. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum _SQLConditionType_
{
	STSSQLConditionType_Compound,
	STSSQLConditionType_Not,
	STSSQLConditionType_Binary
} STSSQLConditionType_;

@interface STSSQLCondition : NSObject
{
}

- (id)initWithType:(STSSQLConditionType_)eType;

- (STSSQLConditionType_)type;

@end
