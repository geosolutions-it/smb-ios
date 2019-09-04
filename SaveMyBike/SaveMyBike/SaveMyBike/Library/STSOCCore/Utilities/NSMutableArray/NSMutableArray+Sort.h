//
//  NSMutableArray+Sort.h
//
//  Created by Szymon Tomasz Stefanek on 12/23/13.
//  Copyright © 2013 Szymon Tomasz Stefanek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray(Sort)

- (void)insertObject:(id)anObject sortedByComparator:(NSComparisonResult (^)(id obj1, id obj2))pComparator;

@end
