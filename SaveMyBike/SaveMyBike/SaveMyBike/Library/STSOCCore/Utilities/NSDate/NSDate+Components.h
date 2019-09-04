//
//  NSDate+Components.h
//
//  Created by Szymon Tomasz Stefanek on 11/28/13.
//  Copyright © 2013 Szymon Tomasz Stefanek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Components)

+ (NSDate *)dateWithYear:(NSInteger)iYear month:(NSInteger)iMonth day:(NSInteger)iDay;

- (NSDateComponents *)dateComponentsForYearMonthAndDay;
- (NSDateComponents *)dateComponentsForYearMonthDayHourMinuteAndSecond;
- (NSDateComponents *)dateComponentsForYearMonthDayHourMinuteSecondAndWeekday;

@property (nonatomic, readonly) NSInteger year;
@property (nonatomic, readonly) NSInteger month;
@property (nonatomic, readonly) NSInteger day;
@property (nonatomic, readonly) NSInteger hour;
@property (nonatomic, readonly) NSInteger minute;
@property (nonatomic, readonly) NSInteger second;
@property (nonatomic, readonly) NSInteger milliseconds;

@end
