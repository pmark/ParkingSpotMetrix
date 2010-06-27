//
//  NSDate+Utilities.m
//
//  Created by P. Mark Anderson on 5/12/10.
//  Copyright 2010 Spot Metrix, Inc. All rights reserved.
//

#import "NSDate+Utilities.h"
#import "Constants.h"

#define STR_DATE_TODAY			@"Today"
#define STR_DATE_YESTERDAY		@"Yesterday"
#define STR_DATE_2_DAYS_AGO		@"Two days ago"
#define STR_DATE_3_DAYS_AGO		@"Three days ago"
#define STR_DATE_4_DAYS_AGO		@"Four days ago"

@implementation NSDate (Utilities)

+ (NSDate*) dateWithToday
{
    NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
    formatter.dateFormat = @"yyyy-d-M";
    
    NSString* time = [formatter stringFromDate:[NSDate date]];
    NSDate* date = [formatter dateFromString:time];
    return date;
}

- (NSDate*) dateAtMidnight
{
    NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
    formatter.dateFormat = @"yyyy-d-M";
    
    NSString* time = [formatter stringFromDate:self];
    NSDate* date = [formatter dateFromString:time];
    return date;
}

- (BOOL) isToday
{
    NSDate *today = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *weekdayComponents = [gregorian components:(NSDayCalendarUnit | NSMonthCalendarUnit |NSYearCalendarUnit) fromDate:today];
    NSInteger todayDay = [weekdayComponents day];
    NSInteger todayMonth = [weekdayComponents month];
    NSInteger todayYear = [weekdayComponents year];
    
    BOOL b = NO;
    
    weekdayComponents = [gregorian components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit)fromDate:self];
    [gregorian release];
    
    NSInteger cday = [weekdayComponents day];
    NSInteger month = [weekdayComponents month];
    NSInteger year = [weekdayComponents year];
    
    if (cday == todayDay &&
        month == todayMonth &&
        year == todayYear){
        b = YES;
    }
    
    return b;    
}

- (NSInteger) calendarDaysAgo
{
    // today or future, return 0
    if ([self isToday])
        return 0;
    
    NSDate *today = [NSDate dateWithToday];
    
    return ([today timeIntervalSinceDate:self] / 86400) + 1;
}

- (NSString*) formattedString
{    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	NSString *tstamp = nil;    
    NSString *when = @"";
    NSInteger daysOld = [self calendarDaysAgo];
    
    dateFormatter.dateFormat = @"h:mm a";
    NSString *timeString = [dateFormatter stringFromDate:self];
    
    if (daysOld == 0)
    {
        when = STR_DATE_TODAY;
    }
    else if (daysOld < 5)
    {
        switch (daysOld) {
            case 1:
                when = STR_DATE_YESTERDAY;
                break;
            case 2:
                when = STR_DATE_2_DAYS_AGO;
                break;
            case 3:
                when = STR_DATE_3_DAYS_AGO;
                break;
            case 4:
                when = STR_DATE_4_DAYS_AGO;
                break;
        }
    }
    else
    {        
        dateFormatter.dateFormat = @"E MMM d";
        when = [dateFormatter stringFromDate:self];
    }
    
    [dateFormatter release];
    tstamp = [NSString stringWithFormat:@"%@ at %@", when, timeString];
    
    return tstamp;
}

@end
