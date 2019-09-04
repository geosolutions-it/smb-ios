//
//  NSDate+Format.m
//
//  Created by Szymon Tomasz Stefanek on 11/14/13.
//  Copyright © 2013 Szymon Tomasz Stefanek. All rights reserved.
//

#import "NSDate+Format.h"

@implementation NSDate (Format)

static NSDateFormatter * g_pISODateFormatter = nil;
static NSDateFormatter * g_pISODateTimeFormatter = nil;
static NSDateFormatter * g_pISODateTimeWithNoSecondsFormatter = nil;
static NSDateFormatter * g_pISODateTimeWithMillisecondsFormatter = nil;
static NSDateFormatter * g_pVisibleDateFormatter = nil;
static NSDateFormatter * g_pVisibleDateTimeFormatter = nil;
static NSDateFormatter * g_pVisibleDateTimeWithNoSecondsFormatter = nil;
static NSDateFormatter * g_pVisibleDateTimeWithMillisecondsFormatter = nil;
static NSDateFormatter * g_pVisibleDateFormatter2 = nil;
static NSDateFormatter * g_pVisibleDateTimeFormatter2 = nil;
static NSDateFormatter * g_pVisibleDateTimeWithNoSecondsFormatter2 = nil;
static NSDateFormatter * g_pVisibleDateTimeWithMillisecondsFormatter2 = nil;
static NSDateFormatter * g_pVisibleTimeFormatter = nil;
static NSDateFormatter * g_pVisibleTimeWithNoSecondsFormatter = nil;
static NSDateFormatter * g_pVisibleDateDayFirstFormatter = nil;
static NSDateFormatter * g_pVisibleDateDayFirstFormatter2 = nil;
static NSDateFormatter * g_pISO8601DateTimeFormatter = nil;
static NSDateFormatter * g_pVisibleTimeWithMillisecondsFormatter = nil;
static NSDateFormatter * g_pVisibleDateTimeWithoutSecondsDayFirstFormatter = nil;
static NSDateFormatter * g_pVisibleDateTimeWithoutSecondsDayFirstFormatter2 = nil;
static NSDateFormatter * g_pVisibleDateTimeWithoutMillisecondsDayFirstFormatter = nil;
static NSDateFormatter * g_pVisibleDateTimeWithoutMillisecondsDayFirstFormatter2 = nil;
static NSDateFormatter * g_pVisibleDateTimeWithMillisecondsDayFirstFormatter = nil;
static NSDateFormatter * g_pVisibleDateTimeWithMillisecondsDayFirstFormatter2 = nil;


+ (NSDateFormatter *)dateFormatterForFormat:(DateTimeFormat)eFormat
{
	NSDateFormatter * fmt;
	switch(eFormat)
	{
		case DateTimeFormatISODateTime:
		{
			if(!g_pISODateTimeFormatter)
			{
				g_pISODateTimeFormatter = [[NSDateFormatter alloc] init];
				[g_pISODateTimeFormatter setDateFormat:@"yyyyMMddHHmmss"];
				[g_pISODateTimeFormatter setLocale:[NSLocale currentLocale]];
			}
			
			fmt = g_pISODateTimeFormatter;
		}
		break;
		case DateTimeFormatISODateTimeWithNoSeconds:
		{
			if(!g_pISODateTimeWithNoSecondsFormatter)
			{
				g_pISODateTimeWithNoSecondsFormatter = [[NSDateFormatter alloc] init];
				[g_pISODateTimeWithNoSecondsFormatter setDateFormat:@"yyyyMMddHHmm"];
				[g_pISODateTimeWithNoSecondsFormatter setLocale:[NSLocale currentLocale]];
			}
			
			fmt = g_pISODateTimeWithNoSecondsFormatter;
		}
		break;
		case DateTimeFormatISODateTimeWithMilliseconds:
			if(!g_pISODateTimeWithMillisecondsFormatter)
			{
				g_pISODateTimeWithMillisecondsFormatter = [[NSDateFormatter alloc] init];
				[g_pISODateTimeWithMillisecondsFormatter setDateFormat:@"yyyyMMddHHmmssSSS"];
				[g_pISODateTimeWithMillisecondsFormatter setLocale:[NSLocale currentLocale]];
			}
			
			fmt = g_pISODateTimeWithMillisecondsFormatter;
		break;
		
		case DateTimeFormatVisibleDate:
			if(!g_pVisibleDateFormatter)
			{
				g_pVisibleDateFormatter = [[NSDateFormatter alloc] init];
				[g_pVisibleDateFormatter setDateFormat:@"yyyy/MM/dd"];
				[g_pVisibleDateFormatter setLocale:[NSLocale currentLocale]];
			}
			
			fmt = g_pVisibleDateFormatter;
		break;
		case DateTimeFormatVisibleDateTime:
			if(!g_pVisibleDateTimeFormatter)
			{
				g_pVisibleDateTimeFormatter = [[NSDateFormatter alloc] init];
				[g_pVisibleDateTimeFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
				[g_pVisibleDateTimeFormatter setLocale:[NSLocale currentLocale]];
			}
			
			fmt = g_pVisibleDateTimeFormatter;
		break;
		case DateTimeFormatVisibleDateTimeWithNoSeconds:
			if(!g_pVisibleDateTimeWithNoSecondsFormatter)
			{
				g_pVisibleDateTimeWithNoSecondsFormatter = [[NSDateFormatter alloc] init];
				[g_pVisibleDateTimeWithNoSecondsFormatter setDateFormat:@"yyyy/MM/dd HH:mm"];
				[g_pVisibleDateTimeWithNoSecondsFormatter setLocale:[NSLocale currentLocale]];
			}
			
			fmt = g_pVisibleDateTimeFormatter;
		break;
		case DateTimeFormatVisibleDateTimeWithMilliseconds:
			if(!g_pVisibleDateTimeWithMillisecondsFormatter)
			{
				g_pVisibleDateTimeWithMillisecondsFormatter = [[NSDateFormatter alloc] init];
				[g_pVisibleDateTimeWithMillisecondsFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss.SSS"];
				[g_pVisibleDateTimeWithMillisecondsFormatter setLocale:[NSLocale currentLocale]];
			}
			
			fmt = g_pVisibleDateTimeWithMillisecondsFormatter;
		break;
		
		case DateTimeFormatVisibleDate2:
			if(!g_pVisibleDateFormatter2)
			{
				g_pVisibleDateFormatter2 = [[NSDateFormatter alloc] init];
				[g_pVisibleDateFormatter2 setDateFormat:@"yyyy-MM-dd"];
				[g_pVisibleDateFormatter2 setLocale:[NSLocale currentLocale]];
			}
			
			fmt = g_pVisibleDateFormatter2;
		break;
		case DateTimeFormatVisibleDateTime2:
			if(!g_pVisibleDateTimeFormatter2)
			{
				g_pVisibleDateTimeFormatter2 = [[NSDateFormatter alloc] init];
				[g_pVisibleDateTimeFormatter2 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
				[g_pVisibleDateTimeFormatter2 setLocale:[NSLocale currentLocale]];
			}
			
			fmt = g_pVisibleDateTimeFormatter2;
		break;
		case DateTimeFormatVisibleDateTimeWithNoSeconds2:
			if(!g_pVisibleDateTimeWithNoSecondsFormatter2)
			{
				g_pVisibleDateTimeWithNoSecondsFormatter2 = [[NSDateFormatter alloc] init];
				[g_pVisibleDateTimeWithNoSecondsFormatter2 setDateFormat:@"yyyy-MM-dd HH:mm"];
				[g_pVisibleDateTimeWithNoSecondsFormatter2 setLocale:[NSLocale currentLocale]];
			}
			
			fmt = g_pVisibleDateTimeFormatter2;
		break;
		case DateTimeFormatVisibleDateTimeWithMilliseconds2:
			if(!g_pVisibleDateTimeWithMillisecondsFormatter2)
			{
				g_pVisibleDateTimeWithMillisecondsFormatter2 = [[NSDateFormatter alloc] init];
				[g_pVisibleDateTimeWithMillisecondsFormatter2 setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
				[g_pVisibleDateTimeWithMillisecondsFormatter2 setLocale:[NSLocale currentLocale]];
			}
			
			fmt = g_pVisibleDateTimeWithMillisecondsFormatter2;
		break;
		case DateTimeFormatISO8601DateTime:
			if(!g_pISO8601DateTimeFormatter)
			{
				g_pISO8601DateTimeFormatter = [[NSDateFormatter alloc] init];
				[g_pISO8601DateTimeFormatter setDateFormat:@"yyyy-MM-ddTHH:mm:ss.SSS"];
				[g_pISO8601DateTimeFormatter setLocale:[NSLocale currentLocale]];
			}
			
			fmt = g_pISO8601DateTimeFormatter;
		break;
		case DateTimeFormatVisibleTime:
			if(!g_pVisibleTimeFormatter)
			{
				g_pVisibleTimeFormatter = [[NSDateFormatter alloc] init];
				[g_pVisibleTimeFormatter setDateFormat:@"HH:mm:ss"];
				[g_pVisibleTimeFormatter setLocale:[NSLocale currentLocale]];
			}
			
			fmt = g_pVisibleTimeFormatter;
		break;
		case DateTimeFormatVisibleTimeWithMilliseconds:
			if(!g_pVisibleTimeWithMillisecondsFormatter)
			{
				g_pVisibleTimeWithMillisecondsFormatter = [[NSDateFormatter alloc] init];
				[g_pVisibleTimeWithMillisecondsFormatter setDateFormat:@"HH:mm:ss.SSS"];
				[g_pVisibleTimeWithMillisecondsFormatter setLocale:[NSLocale currentLocale]];
			}
			
			fmt = g_pVisibleTimeWithMillisecondsFormatter;
		break;
		case DateTimeFormatVisibleTimeWithNoSeconds:
			if(!g_pVisibleTimeWithNoSecondsFormatter)
			{
				g_pVisibleTimeWithNoSecondsFormatter = [[NSDateFormatter alloc] init];
				[g_pVisibleTimeWithNoSecondsFormatter setDateFormat:@"HH:mm"];
				[g_pVisibleTimeWithNoSecondsFormatter setLocale:[NSLocale currentLocale]];
			}
			
			fmt = g_pVisibleTimeWithNoSecondsFormatter;
		break;
		case DateTimeFormatVisibleDateDayFirst:
			if(!g_pVisibleDateDayFirstFormatter)
			{
				g_pVisibleDateDayFirstFormatter = [[NSDateFormatter alloc] init];
				[g_pVisibleDateDayFirstFormatter setDateFormat:@"dd/MM/yyyy"];
				[g_pVisibleDateDayFirstFormatter setLocale:[NSLocale currentLocale]];
			}

			fmt = g_pVisibleDateDayFirstFormatter;
			break;
		case DateTimeFormatVisibleDateDayFirst2:
			if(!g_pVisibleDateDayFirstFormatter2)
			{
				g_pVisibleDateDayFirstFormatter2 = [[NSDateFormatter alloc] init];
				[g_pVisibleDateDayFirstFormatter2 setDateFormat:@"dd-MM-yyyy"];
				[g_pVisibleDateDayFirstFormatter2 setLocale:[NSLocale currentLocale]];
			}

			fmt = g_pVisibleDateDayFirstFormatter2;
			break;
		case DateTimeFormatVisibleDateTimeWithoutSecondsDayFirst:
			if(!g_pVisibleDateTimeWithoutSecondsDayFirstFormatter)
			{
				g_pVisibleDateTimeWithoutSecondsDayFirstFormatter = [[NSDateFormatter alloc] init];
				[g_pVisibleDateTimeWithoutSecondsDayFirstFormatter setDateFormat:@"dd/MM/yyyy HH:mm"];
				[g_pVisibleDateTimeWithoutSecondsDayFirstFormatter setLocale:[NSLocale currentLocale]];
			}

			fmt = g_pVisibleDateTimeWithoutSecondsDayFirstFormatter;
			break;
		case DateTimeFormatVisibleDateTimeWithoutSecondsDayFirst2:
			if(!g_pVisibleDateTimeWithoutSecondsDayFirstFormatter2)
			{
				g_pVisibleDateTimeWithoutSecondsDayFirstFormatter2 = [[NSDateFormatter alloc] init];
				[g_pVisibleDateTimeWithoutSecondsDayFirstFormatter2 setDateFormat:@"dd-MM-yyyy HH:mm"];
				[g_pVisibleDateTimeWithoutSecondsDayFirstFormatter2 setLocale:[NSLocale currentLocale]];
			}

			fmt = g_pVisibleDateTimeWithoutSecondsDayFirstFormatter2;
			break;
		case DateTimeFormatVisibleDateTimeWithoutMillisecondsDayFirst:
			if(!g_pVisibleDateTimeWithoutMillisecondsDayFirstFormatter)
			{
				g_pVisibleDateTimeWithoutMillisecondsDayFirstFormatter = [[NSDateFormatter alloc] init];
				[g_pVisibleDateTimeWithoutMillisecondsDayFirstFormatter setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
				[g_pVisibleDateTimeWithoutMillisecondsDayFirstFormatter setLocale:[NSLocale currentLocale]];
			}

			fmt = g_pVisibleDateTimeWithoutMillisecondsDayFirstFormatter;
			break;
		case DateTimeFormatVisibleDateTimeWithoutMillisecondsDayFirst2:
			if(!g_pVisibleDateTimeWithoutMillisecondsDayFirstFormatter2)
			{
				g_pVisibleDateTimeWithoutMillisecondsDayFirstFormatter2 = [[NSDateFormatter alloc] init];
				[g_pVisibleDateTimeWithoutMillisecondsDayFirstFormatter2 setDateFormat:@"dd-MM-yyyy HH:mm:ss"];
				[g_pVisibleDateTimeWithoutMillisecondsDayFirstFormatter2 setLocale:[NSLocale currentLocale]];
			}

			fmt = g_pVisibleDateTimeWithoutMillisecondsDayFirstFormatter2;
			break;
		case DateTimeFormatVisibleDateTimeWithMillisecondsDayFirst:
			if(!g_pVisibleDateTimeWithMillisecondsDayFirstFormatter)
			{
				g_pVisibleDateTimeWithMillisecondsDayFirstFormatter = [[NSDateFormatter alloc] init];
				[g_pVisibleDateTimeWithMillisecondsDayFirstFormatter setDateFormat:@"dd/MM/yyyy HH:mm:ss.SSS"];
				[g_pVisibleDateTimeWithMillisecondsDayFirstFormatter setLocale:[NSLocale currentLocale]];
			}

			fmt = g_pVisibleDateTimeWithMillisecondsDayFirstFormatter;
			break;
		case DateTimeFormatVisibleDateTimeWithMillisecondsDayFirst2:
			if(!g_pVisibleDateTimeWithMillisecondsDayFirstFormatter2)
			{
				g_pVisibleDateTimeWithMillisecondsDayFirstFormatter2 = [[NSDateFormatter alloc] init];
				[g_pVisibleDateTimeWithMillisecondsDayFirstFormatter2 setDateFormat:@"dd-MM-yyyy HH:mm:ss.SSS"];
				[g_pVisibleDateTimeWithMillisecondsDayFirstFormatter2 setLocale:[NSLocale currentLocale]];
			}

			fmt = g_pVisibleDateTimeWithMillisecondsDayFirstFormatter2;
			break;
		//case DateTimeFormatISODate:
		default:
			if(!g_pISODateFormatter)
			{
				g_pISODateFormatter = [[NSDateFormatter alloc] init];
				[g_pISODateFormatter setDateFormat:@"yyyyMMdd"];
				[g_pISODateFormatter setLocale:[NSLocale currentLocale]];
			}
			
			fmt = g_pISODateFormatter;
		break;
	}

	return fmt;
}

- (NSString *)stringWithFormat:(DateTimeFormat)eFormat
{
	return [[NSDate dateFormatterForFormat:eFormat] stringFromDate:self];
}

+ (NSDate *)dateFromString:(NSString *)szString withFormat:(DateTimeFormat)eFormat
{
	return [[NSDate dateFormatterForFormat:eFormat] dateFromString:szString];
}

+ (NSDate *)dateFromAnyFormatString:(NSString *)szString withDefault:(NSDate *)dtDefault
{
	if(!szString)
		return dtDefault;
	
	int l = (int)szString.length;
	
	if(l < 1)
		return dtDefault;

	NSDate * d;

	if([szString containsString:@"/"])
	{
		if(l >= 17)
		{
			d = [NSDate dateFromString:szString withFormat:DateTimeFormatVisibleDateTimeWithMilliseconds];
			if(d)
				return d;
		}
		
		if(l >= 11)
		{
			d = [NSDate dateFromString:szString withFormat:DateTimeFormatVisibleDateTime];
			if(d)
				return d;
		}
		
		if(l >= 9)
		{
			d = [NSDate dateFromString:szString withFormat:DateTimeFormatVisibleDateTimeWithNoSeconds];
			if(d)
				return d;
		}

		if(l >= 8)
		{
			NSRange rng = [szString rangeOfString:@"/"];
			
			if(rng.location < 4)
			{
				d = [NSDate dateFromString:szString withFormat:DateTimeFormatVisibleDateDayFirst];
				if(d)
					return d;

				d = [NSDate dateFromString:szString withFormat:DateTimeFormatVisibleDate];
				if(d)
					return d;

			} else {
				d = [NSDate dateFromString:szString withFormat:DateTimeFormatVisibleDate];
				if(d)
					return d;


				d = [NSDate dateFromString:szString withFormat:DateTimeFormatVisibleDateDayFirst];
				if(d)
					return d;

			}
		}
	
		
		// FIXME: The inverted dates?
		
		return dtDefault;
	}
	
	if([szString containsString:@"-"])
	{
		// FIXME: Real ISO dates?
		
		if(l >= 17)
		{
			if([szString containsString:@"T"])
			{
				NSISO8601DateFormatter * fmt = [NSISO8601DateFormatter new];
				//[fmt setTimeZone:[NSTimeZone localTimeZone]];
				d = [fmt dateFromString:szString];
				if(d)
					return d;
				
				d = [NSDate dateFromString:szString withFormat:DateTimeFormatISO8601DateTime];
				if(d)
					return d;
			} else {
				d = [NSDate dateFromString:szString withFormat:DateTimeFormatVisibleDateTimeWithMilliseconds2];
				if(d)
					return d;
			}
		}
		
		if(l >= 11)
		{
			d = [NSDate dateFromString:szString withFormat:DateTimeFormatVisibleDateTime2];
			if(d)
				return d;
		}
		
		if(l >= 9)
		{
			d = [NSDate dateFromString:szString withFormat:DateTimeFormatVisibleDateTimeWithNoSeconds2];
			if(d)
				return d;
		}

		if(l >= 8)
		{
			NSRange rng = [szString rangeOfString:@"/"];
			
			if(rng.location < 4)
			{
				d = [NSDate dateFromString:szString withFormat:DateTimeFormatVisibleDateDayFirst2];
				if(d)
					return d;

				d = [NSDate dateFromString:szString withFormat:DateTimeFormatVisibleDate2];
				if(d)
					return d;
			} else {
				d = [NSDate dateFromString:szString withFormat:DateTimeFormatVisibleDate2];
				if(d)
					return d;

				d = [NSDate dateFromString:szString withFormat:DateTimeFormatVisibleDateDayFirst2];
				if(d)
					return d;
			}
		}
		
		return dtDefault;
	}
	
	
	// FIXME: Time values?
	
	
	
	if(l >= 17)
	{
		d = [NSDate dateFromString:szString withFormat:DateTimeFormatISODateTimeWithMilliseconds];
		return d ? d : dtDefault;
	}
	
	if(l >= 14)
	{
		d = [NSDate dateFromString:szString withFormat:DateTimeFormatISODateTime];
		return d ? d : dtDefault;
	}

	if(l >= 12)
	{
		d = [NSDate dateFromString:szString withFormat:DateTimeFormatISODateTimeWithNoSeconds];
		return d ? d : dtDefault;
	}

	if(l >= 8)
	{
		d = [NSDate dateFromString:szString withFormat:DateTimeFormatISODate];
		return d ? d : dtDefault;
	}
	
	return dtDefault;
}

@end
