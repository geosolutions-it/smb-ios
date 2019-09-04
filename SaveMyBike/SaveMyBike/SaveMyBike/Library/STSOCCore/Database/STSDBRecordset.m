//
//  STSDBRecordset.m
//
//  Created by Szymon Tomasz Stefanek on 10/30/12.
//  Copyright (c) 2012 Szymon Tomasz Stefanek. All rights reserved.
//

#import "STSDBRecordset.h"

@implementation STSDBRecordset

- (void)close
{
	
}

- (bool)isOpen
{
	return false;
}

- (bool)read
{
	return false;
}

- (id)field:(NSString *)szColumnName withDefault:(id)vDefault
{
	return vDefault;
}

- (id)field:(NSString *)szColumnName
{
	return [self field:szColumnName withDefault:nil];
}

- (id)fieldByColumnIndex:(int)iColumnIndex withDefault:(id)vDefault
{
	return vDefault;
}

- (id)fieldByColumnIndex:(int)iColumnIndex
{
	return [self fieldByColumnIndex:iColumnIndex withDefault:nil];
}


- (int)columnIndexForColumnName:(NSString *)szColumnName
{
	return -1;
}

- (long)longField:(NSString *)szColumnName withDefault:(long)lDefault
{
	return lDefault;
}

- (long)longField:(NSString *)szColumnName
{
	return [self longField:szColumnName withDefault:LONG_MIN];
}

- (int)intField:(NSString *)szColumnName withDefault:(int)lDefault
{
	return lDefault;
}

- (int)intField:(NSString *)szColumnName
{
	return [self intField:szColumnName withDefault:INT_MIN];
}


@end
