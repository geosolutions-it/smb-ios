//  
//  Created by Szymon Tomasz Stefanek
//  Copyright © 2017 Szymon Tomasz Stefanek. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "STSSQLCondition.h"

@class STSDBConnection;

@interface STSSQLQueryConditionBuilder : NSObject
{
}

- (id)initWithConnection:(STSDBConnection *)db;

- (NSString *)build:(STSSQLCondition *)c;


@end

