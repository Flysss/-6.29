//
//  HWMessageModel.m
//  SalesHelper_A
//
//  Created by 胡伟 on 16/3/21.
//  Copyright © 2016年 X. All rights reserved.
//

#import "HWMessageModel.h"
#import "MJExtension.h"
#import "NSDate+HW.h"

@implementation HWMessageModel

- (NSDictionary *)replacedKeyFromPropertyName
{
    
    return @{@"ID":@"id"};
}


- (NSString *)addtime
{
    
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"EEE MMM dd HH:mm:ss Z yyyy";
#warning 真机调试必须加上这句
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    
    // 获得微博发布的具体时间
    NSTimeInterval timer = [_addtime doubleValue];
    NSDate *createDate = [NSDate dateWithTimeIntervalSince1970:timer];
    
    // 判断是否为今年
    if (createDate.isThisYear) {
        if (createDate.isToday) { // 今天
            NSDateComponents *cmps = [createDate deltaWithNow];
            if (cmps.hour >= 1) { // 至少是1小时前发的
                return [NSString stringWithFormat:@"%ld小时前", (long)cmps.hour];
            } else if (cmps.minute >= 1) { // 1~59分钟之前发的
                return [NSString stringWithFormat:@"%ld分钟前", (long)cmps.minute];
            } else { // 1分钟内发的
                return @"刚刚";
            }
        } else if (createDate.isYesterday) { // 昨天
            fmt.dateFormat = @"昨天 HH:mm";
            return [fmt stringFromDate:createDate];
        } else { // 至少是前天
            fmt.dateFormat = @"MM-dd HH:mm";
            return [fmt stringFromDate:createDate];
        }
    } else { // 非今年
        fmt.dateFormat = @"yyyy-MM-dd";
        return [fmt stringFromDate:createDate];;
    }
    
    
}



@end
