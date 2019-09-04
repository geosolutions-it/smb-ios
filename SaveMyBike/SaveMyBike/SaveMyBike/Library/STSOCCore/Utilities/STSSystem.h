//
//  STSSystem.h
//
//  Created by Szymon Tomasz Stefanek on 6/12/13.
//  Copyright (c) 2013 Szymon Tomasz Stefanek. All rights reserved.
//

#import <Foundation/Foundation.h>

// Use as STS_SYSTEM_VERSION_EQUAL_TO(@"5.0")
// or STS_SYSTEM_VERSION_LESS_THAN(@"5.0.1")

#define STS_SYSTEM_VERSION_EQUAL_TO(v) \
	([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)

#define STS_SYSTEM_VERSION_GREATER_THAN(v) \
	([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)

#define STS_SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) \
	([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

#define STS_SYSTEM_VERSION_LESS_THAN(v) \
	([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

#define STS_SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v) \
	([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)


@interface STSSystem : NSObject

@end
