//
//  NSDate+HW.h
//  HW_微博
//
//  Created by 胡伟 on 16/1/23.
//  Copyright © 2016年 胡伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (HW)

/**
 *  是否为今天
 */
- (BOOL)isToday;
/**
 *  是否为昨天
 */
- (BOOL)isYesterday;
/**
 *  是否为今年
 */
- (BOOL)isThisYear;

/**
 *  返回一个只有年月日的时间
 */
- (NSDate *)dateWithYMD;

/**
 *  获得与当前时间的差距
 */
- (NSDateComponents *)deltaWithNow;


@end
