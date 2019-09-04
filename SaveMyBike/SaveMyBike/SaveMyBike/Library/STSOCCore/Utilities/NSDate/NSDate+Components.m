//
//  NSDate+Components.m
//
//  Created by Szymon Tomasz Stefanek on 11/28/13.
//  Copyright © 2013 Szymon Tomasz Stefanek. All rights reserved.
//

#import "NSDate+Components.h"

@implementation NSDate (Components)

+ (NSDate *)dateWithYear:(NSInteger)iYear month:(NSInteger)iMonth day:(NSInteger)iDay
{
	NSDateComponents * c = [[NSDateComponents alloc] init];
	[c setYear:iYear];
	[c setMonth:iMonth];
	[c setDay:iDay];

	return [[NSCalendar currentCalendar] dateFromComponents:c];
}

- (NSDateComponents *)dateComponentsForYearMonthAndDay
{
	[[NSCalendar currentCalendar] setLocale:[NSLocale currentLocale]];
	return [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:self];
}

- (NSDateComponents *)dateComponentsForYearMonthDayHourMinuteAndSecond
{
	[[NSCalendar currentCalendar] setLocale:[NSLocale currentLocale]];
	return [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:self];
}


- (NSDateComponents *)dateComponentsForYearMonthDayHourMinuteSecondAndWeekday
{
	[[NSCalendar currentCalendar] setLocale:[NSLocale currentLocale]];
	return [[NSCalendar currentCalendar] components:NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:self];
}


- (NSInteger)year
{
	[[NSCalendar currentCalendar] setLocale:[NSLocale currentLocale]];
	return [[[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:self] year];
}

- (NSInteger)month
{
	[[NSCalendar currentCalendar] setLocale:[NSLocale currentLocale]];
	return [[[NSCalendar currentCalendar] components:NSCalendarUnitMonth fromDate:self] month];
}

- (NSInteger)day
{
	[[NSCalendar currentCalendar] setLocale:[NSLocale currentLocale]];
	return [[[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:self] day];
}

- (NSInteger)hour
{
	[[NSCalendar currentCalendar] setLocale:[NSLocale currentLocale]];
	return [[[NSCalendar currentCalendar] components:NSCalendarUnitHour fromDate:self] hour];
}

- (NSInteger)minute
{
	[[NSCalendar currentCalendar] setLocale:[NSLocale currentLocale]];
	return [[[NSCalendar currentCalendar] components:NSCalendarUnitMinute fromDate:self] minute];
}

- (NSInteger)second
{
	[[NSCalendar currentCalendar] setLocale:[NSLocale currentLocale]];
	return [[[NSCalendar currentCalendar] components:NSCalendarUnitSecond fromDate:self] second];
}

- (NSInteger)milliseconds
{
	NSTimeInterval secs = [self timeIntervalSinceReferenceDate];
	return (NSInteger)(fmod(secs,1.0) * 1000.0);
}

@end
