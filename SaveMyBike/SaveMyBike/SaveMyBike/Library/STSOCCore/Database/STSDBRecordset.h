//
//  STSDBRecordset.h
//
//  Created by Szymon Tomasz Stefanek on 10/30/12.
//  Copyright (c) 2012 Szymon Tomasz Stefanek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STSDBRecordset : NSObject

- (bool)read;
- (bool)isOpen;
- (void)close;

- (id)field:(NSString *)szColumnName withDefault:(id)vDefault;
- (id)field:(NSString *)szColumnName;

- (id)fieldByColumnIndex:(int)iColumnIndex withDefault:(id)vDefault;
- (id)fieldByColumnIndex:(int)iColumnIndex;

- (int)columnIndexForColumnName:(NSString *)szColumnName;

- (long)longField:(NSString *)szColumnName withDefault:(long)lDefault;
- (long)longField:(NSString *)szColumnName;

- (int)intField:(NSString *)szColumnName withDefault:(int)iDefault;
- (int)intField:(NSString *)szColumnName;

@end
