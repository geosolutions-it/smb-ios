//  
//  Created by Szymon Tomasz Stefanek
//  Copyright © 2017 Szymon Tomasz Stefanek. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "STSDBConnection.h"
#import "STSSQLCompoundCondition.h"

@interface STSSQLDeleteQueryBuilder : NSObject
{
}

- (id)initWithConnection:(STSDBConnection *)db;
- (void)setTableName:(NSString *)szTableName;
- (NSString *)tableName;
- (STSSQLCompoundCondition *)where;
- (NSString *)build;

@end
