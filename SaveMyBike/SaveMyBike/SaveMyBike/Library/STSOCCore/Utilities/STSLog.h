//
//  STSLog.h
//
//  Copyright © 2013 Szymon Tomasz Stefanek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STSLog : NSObject

- (id)initWithTag:(NSString *)sTag;

- (void)log:(NSString *)sLog, ...;
- (void)log:(NSString *)sWhere message:(NSString *)sLog, ...;
- (void)logError:(NSString *)sLog, ...;
- (void)logError:(NSString *)sWhere message:(NSString *)sLog, ...;

@end
