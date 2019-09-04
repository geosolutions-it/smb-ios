//
//  Created by Szymon Tomasz Stefanek
//  Copyright (c) 2018 Szymon Tomasz Stefanek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STSErrorStack : NSObject
{
}

- (id)init;

- (void)pushError:(NSString *)szError;
- (void)setError:(NSString *)szError;
- (void)clear;
- (bool)isEmpty;

- (NSString *)buildMessage:(NSString *)szTopLevel;
- (NSString *)buildMessage;

@end
