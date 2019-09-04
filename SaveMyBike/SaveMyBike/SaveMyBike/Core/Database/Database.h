#ifndef __Database_h__
#define __Database_h__

#import <Foundation/Foundation.h>

#import "STSDBConnection.h"

@interface Database : NSObject

+ (Database *)instance;

+ (void)create;
+ (void)destroy;

- (bool)attachToPath:(NSString *)szPath;
- (void)cleanup;

- (void)close;

- (STSDBConnection *)connection;

@end

#endif //!__Database_h__
