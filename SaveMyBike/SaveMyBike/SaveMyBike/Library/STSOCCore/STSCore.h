//
//  STSCore.h
//
//  Created by Szymon Tomasz Stefanek on 10/30/12.
//  Copyright (c) 2012 Szymon Tomasz Stefanek. All rights reserved.
//

#import <Foundation/Foundation.h>

#define STS_CORE_ENABLE_ASSERTS

#ifdef STS_CORE_ENABLE_ASSERTS
	#define STS_CORE_ASSERT(__condition) \
		do { \
			if(!(__condition)) \
			{ \
				NSString * __msg = [NSString stringWithFormat:@"ASSERTION FAILED at %s:%d", __FILE__,__LINE__]; \
				NSLog(@"[%@] %@",NSStringFromClass([self class]),__msg); \
				NSException * __exc = [NSException exceptionWithName:@"AssertionFailedException" reason:__msg userInfo:nil]; \
				[__exc raise]; \
			} \
		} while(0)
#else //!STS_CORE_ENABLE_ASSERTS
	#define STS_CORE_ASSERT(__condition) \
		do { } while(0)
#endif //!STS_CORE_ENABLE_ASSERTS

//
// Define this to enable logging at all
//
#define STS_CORE_ENABLE_LOGGING

#ifdef STS_CORE_ENABLE_LOGGING

	@interface STSCoreLog : NSObject

		+ (void)logPush;
		+ (void)logPop;
		+ (NSString *)logPrefix;

	@end

	#define STS_CORE_LOG_ENTER(__ftm,...) do { \
			NSLog(@"%@[%s:%x] >> %@", [STSCoreLog logPrefix], __func__,(unsigned int)self, [NSString stringWithFormat:__ftm, ## __VA_ARGS__]); \
			[STSCoreLog logPush]; \
		} while(0)

	#define STS_CORE_LOG_LEAVE(__ftm,...) do { \
			[STSCoreLog logPop]; \
			NSLog(@"%@[%s:%x] << %@", [STSCoreLog logPrefix], __func__,(unsigned int)self, [NSString stringWithFormat:__ftm, ## __VA_ARGS__]); \
		} while(0)

	#define STS_CORE_LOG(__ftm,...)     NSLog(@"%@[%s:%x] %@", [STSCoreLog logPrefix], __func__,(unsigned int)self, [NSString stringWithFormat:__ftm, ## __VA_ARGS__])
	#define STS_CORE_LOG_CGRect(t, s)   NSLog(@"[%s:%x] %@ %@", __func__,(unsigned int)self, t, NSStringFromCGRect(s))
	#define STS_CORE_LOG_CGSize(t, s)   NSLog(@"[%s:%x] %@ %@", __func__,(unsigned int)self, t, NSStringFromCGSize(s))

#else // !STS_CORE_ENABLE_LOGGING

	#define STS_CORE_LOG(__fmt,...)   do { } while(0)
	#define STS_CORE_LOG_ENTER(__fmt,...)   do { } while(0)
	#define STS_CORE_LOG_LEAVE(__fmt,...)   do { } while(0)
	#define STS_CORE_LOG_CGRect(t, s) do { } while(0)
	#define STS_CORE_LOG_CGSize(t, s) do { } while(0)

#endif // !STS_CORE_ENABLE_LOGGING

// Log errors anyway (unless you REALLY want it silent...)
#define STS_CORE_LOG_ERROR(__ftm,...) NSLog(@"[%@] %@", NSStringFromClass([self class]), [NSString stringWithFormat:__ftm, ## __VA_ARGS__])


#define STS_CORE_ENABLE_LOGGING_FOR_RECEIVED_JSON 1

//
// Utils
//
#define CGRectGetBottom(rect) (rect.origin.y + rect.size.height)
#define CGRectGetRight(rect) (rect.origin.x + rect.size.width)

