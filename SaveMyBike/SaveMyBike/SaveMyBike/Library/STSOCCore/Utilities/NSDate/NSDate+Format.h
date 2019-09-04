//
//  NSDate+Format.h
//
//  Created by Szymon Tomasz Stefanek on 11/14/13.
//  Copyright © 2013 Szymon Tomasz Stefanek. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum _DateTimeFormat
{
	// yyyyMMDD
	DateTimeFormatISODate,
	// yyyyMMDDHHmmss
	DateTimeFormatISODateTime,
	// yyyyMMDDHHmm
	DateTimeFormatISODateTimeWithNoSeconds,
	// yyyyMMDDHHmmssSSS
	DateTimeFormatISODateTimeWithMilliseconds,
	// yyyy/MM/DD
	DateTimeFormatVisibleDate,
	// yyyy/MM/DD HH:mm:ss
	DateTimeFormatVisibleDateTime,
	// yyyy/MM/DD HH:mm
	DateTimeFormatVisibleDateTimeWithNoSeconds,
	// yyyy/MM/DD HH:mm:ss.SSS
	DateTimeFormatVisibleDateTimeWithMilliseconds,
	// yyyy-MM-DD
	DateTimeFormatVisibleDate2,
	// yyyy-MM-DD HH:mm:ss
	DateTimeFormatVisibleDateTime2,
	// yyyy-MM-DD HH:mm
	DateTimeFormatVisibleDateTimeWithNoSeconds2,
	// yyyy-MM-DD HH:mm:ss.SSS
	DateTimeFormatVisibleDateTimeWithMilliseconds2,
	// HH:mm:ss
	DateTimeFormatVisibleTime,
	// HH:mm
	DateTimeFormatVisibleTimeWithNoSeconds,
	// HH:mm:ss.SSS
	DateTimeFormatVisibleTimeWithMilliseconds,


	// DD/MM/yyyy
	DateTimeFormatVisibleDateDayFirst,
	// DD-MM-yyyy
	DateTimeFormatVisibleDateDayFirst2,
	// DD/MM/yyyy HH:mm
	DateTimeFormatVisibleDateTimeWithoutSecondsDayFirst,
	// DD-MM-yyyy HH:mm
	DateTimeFormatVisibleDateTimeWithoutSecondsDayFirst2,
	// DD/MM/yyyy HH:mm:ss
	DateTimeFormatVisibleDateTimeWithoutMillisecondsDayFirst,
	// DD-MM-yyyy HH:mm:ss
	DateTimeFormatVisibleDateTimeWithoutMillisecondsDayFirst2,
	// DD/MM/yyyy HH:mm:ss.SSS
	DateTimeFormatVisibleDateTimeWithMillisecondsDayFirst,
	// DD-MM-yyyy HH:mm:ss.SSS
	DateTimeFormatVisibleDateTimeWithMillisecondsDayFirst2,

	// yyyy-MM-DDTHH:mm:ss.SSS
	DateTimeFormatISO8601DateTime,
	// yyyy-MM-DD
	DateTimeFormatISO8601Date = DateTimeFormatVisibleDate2,

	// yyyy-MM-DD
	DateTimeFormatDBDate = DateTimeFormatVisibleDate2,
	// yyyy-MM-DD HH:mm:ss
	DateTimeFormatDBDateTime = DateTimeFormatVisibleDateTime2,
	// yyyy-MM-DD HH:mm:ss
	DateTimeFormatDBDateTimeWithNoSeconds = DateTimeFormatVisibleDateTimeWithNoSeconds2,
	// yyyy-MM-DD HH:mm:ss.SSS
	DateTimeFormatDBDateTimeWithMilliseconds = DateTimeFormatVisibleDateTimeWithMilliseconds2,
	// HH:mm:ss
	DateTimeFormatDBTime = DateTimeFormatVisibleTime,
	// HH:mm
	DateTimeFormatDBTimeWithNoSeconds = DateTimeFormatVisibleTimeWithNoSeconds


} DateTimeFormat;

@interface NSDate (Format)

- (NSString *)stringWithFormat:(DateTimeFormat)eFormat;

+ (NSDateFormatter *)dateFormatterForFormat:(DateTimeFormat)eFormat;

+ (NSDate *)dateFromString:(NSString *)szString withFormat:(DateTimeFormat)eFormat;

+ (NSDate *)dateFromAnyFormatString:(NSString *)szString withDefault:(NSDate *)dtDefault;

@end
