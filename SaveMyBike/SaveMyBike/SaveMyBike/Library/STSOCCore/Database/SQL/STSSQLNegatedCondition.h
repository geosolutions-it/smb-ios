//  
//  Created by Szymon Tomasz Stefanek
//  Copyright © 2017 Szymon Tomasz Stefanek. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "STSSQLCondition.h"

@interface STSSQLNegatedCondition : STSSQLCondition
{
}

- (STSSQLCondition *)innerCondition;
- (void)setInnerCondition:(STSSQLCondition *)c;

@end
