//
//  NSDate+Extension.m
//  iCnblogs
//
//  Created by poloby on 16/1/5.
//  Copyright © 2016年 poloby. All rights reserved.
//

#import "NSDate+Extension.h"

@implementation NSDate (Extension)

- (BOOL)isToday
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear;
    
    NSDateComponents *currentComponents = [calendar components:unit fromDate:[NSDate date]];
    
    NSDateComponents *selfComponents = [calendar components:unit fromDate:self];
    return (selfComponents.year == currentComponents.year) && (selfComponents.month == currentComponents.month) && (selfComponents.day == currentComponents.day);
}

- (BOOL)isYesterday
{
    NSDate *currentDate = [[NSDate date] dateWithYMD];
    NSDate *selfDate = [self dateWithYMD];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitDay fromDate:selfDate toDate:currentDate options:NSCalendarWrapComponents];
    return components.day == 1;
}

- (NSDate *)dateWithYMD
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    NSString *selfString = [dateFormatter stringFromDate:self];
    return [dateFormatter dateFromString:selfString];
}

- (BOOL)isThisYear
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitYear;
    
    NSDateComponents *currentComponents = [calendar components:unit fromDate:[NSDate date]];
    
    NSDateComponents *selfComponents = [calendar components:unit fromDate:self];
    return (selfComponents.year == currentComponents.year);
}

- (NSDateComponents *)deltaWithNow
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    return [calendar components:unit fromDate:self toDate:[NSDate date] options:NSCalendarWrapComponents];
}

@end
