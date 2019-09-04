//  
//  Created by Szymon Tomasz Stefanek
//  Copyright © 2017 Szymon Tomasz Stefanek. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "STSDBConnection.h"

@interface STSSQLDropTableQueryBuilder : NSObject
{
}

- (id)initWithConnection:(STSDBConnection *)db;
- (void)setTableName:(NSString *)szTableName;
- (NSString *)tableName;
- (bool)ignoreInexistingTable;
- (void)setIgnoreInexistingTable:(bool)bIgn;
- (NSString *)build;

@end

