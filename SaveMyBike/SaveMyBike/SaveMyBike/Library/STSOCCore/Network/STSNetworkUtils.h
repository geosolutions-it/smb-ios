//
//  STSNetworkUtils.h
//
//  Created by Szymon Tomasz Stefanek on 02/05/13.
//  Copyright (c) 2013 Szymon Tomasz Stefanek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STSNetworkUtils : NSObject

+ (NSString *)getMacAddress;

#if 0
// Don't enable unless really needed, otherwise Apple will complain
+ (NSString *)getDeviceIdfa;
#endif

@end
