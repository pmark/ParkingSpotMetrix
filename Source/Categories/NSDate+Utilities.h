//
//  NSDate+Utilities.h
//
//  Created by P. Mark Anderson on 5/12/10.
//  Copyright 2010 Spot Metrix, Inc. All rights reserved.
//


@interface NSDate (Utilities)

+ (NSDate*) dateWithToday;
- (NSDate*) dateAtMidnight;
- (BOOL) isToday;
- (NSInteger) calendarDaysAgo;
- (NSString*) formattedString;

@end
