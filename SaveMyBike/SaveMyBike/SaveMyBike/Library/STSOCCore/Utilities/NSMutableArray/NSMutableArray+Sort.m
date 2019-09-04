//
//  NSMutableArray+Sort.m
//
//  Created by Szymon Tomasz Stefanek on 12/23/13.
//  Copyright © 2013 Szymon Tomasz Stefanek. All rights reserved.
//

#import "NSMutableArray+Sort.h"

@implementation NSMutableArray(Sort)

	
- (void)insertObject:(id)anObject sortedByComparator:(NSComparisonResult (^)(id obj1, id obj2))pComparator;
{
	if(self.count < 1)
	{
		[self insertObject:anObject atIndex:0];
		return;
	}
	
	int iIdx = [self indexOfObject:anObject inSortedRange:(NSRange){ 0, self.count } options:NSBinarySearchingInsertionIndex usingComparator:pComparator];
	
	[self insertObject:anObject atIndex:iIdx];
}

@end
