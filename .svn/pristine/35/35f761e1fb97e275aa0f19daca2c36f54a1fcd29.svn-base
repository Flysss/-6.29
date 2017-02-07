//
//  NSDate+HW.m
//  HW_微博
//
//  Created by 胡伟 on 16/1/23.
//  Copyright © 2016年 胡伟. All rights reserved.
//

#import "NSDate+HW.h"

@implementation NSDate (HW)
/**
 *  是否为今天
 */
- (BOOL)isToday
{
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    int unit = NSCalendarUnitDay | NSCalendarUnitMonth |  NSCalendarUnitYear;
//    
//    // 1.获得当前时间的年月日
//    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
//    
//    // 2.获得self的年月日
//    NSDateComponents *selfCmps = [calendar components:unit fromDate:self];
//    return
//    (selfCmps.year == nowCmps.year) &&
//    (selfCmps.month == nowCmps.month) &&
//    (selfCmps.day == nowCmps.day);
    
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSInteger unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *nowcomps = [calendar components:unit fromDate:[NSDate date]];
    
    
    NSDateComponents *selfcomps = [calendar components:unit fromDate:self];
    
    return selfcomps.year == nowcomps.year && selfcomps.month == nowcomps.month && selfcomps.day == nowcomps.day;
    

    
}

/**
 *  是否为昨天
 */
- (BOOL)isYesterday
{
    // 2014-05-01
    NSDate *nowDate = [[NSDate date] dateWithYMD];
    
    // 2014-04-30
    NSDate *selfDate = [self dateWithYMD];
    
    // 获得nowDate和selfDate的差距
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *cmps = [calendar components:NSCalendarUnitDay fromDate:selfDate toDate:nowDate options:0];
    return cmps.day == 1;
    
    
    
    
    
}

- (NSDate *)dateWithYMD
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSString *selfStr = [fmt stringFromDate:self];
    return [fmt dateFromString:selfStr];
}

/**
 *  是否为今年
 */
- (BOOL)isThisYear
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitYear;
    
    // 1.获得当前时间的年月日
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    
    // 2.获得self的年月日
    NSDateComponents *selfCmps = [calendar components:unit fromDate:self];
    
    return nowCmps.year == selfCmps.year;
}

- (NSDateComponents *)deltaWithNow
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    return [calendar components:unit fromDate:self toDate:[NSDate date] options:0];
}

@end
