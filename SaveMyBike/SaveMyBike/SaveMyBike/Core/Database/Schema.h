#ifndef __Schema_h__
#define __Schema_h__

#import <Foundation/Foundation.h>

#import "STSDBSchema.h"

@interface Schema : STSDBSchema

- (bool)updateDatabase:(STSDBConnection *)db fromVersion:(int)iCurrentVersion;

@end

#endif //!__Schema_h__
