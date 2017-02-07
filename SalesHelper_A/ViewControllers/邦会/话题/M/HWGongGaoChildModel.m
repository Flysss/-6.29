//
//  HWGongGaoChildModel.m
//  SalesHelper_A
//
//  Created by 胡伟 on 16/3/8.
//  Copyright © 2016年 X. All rights reserved.
//

#import "HWGongGaoChildModel.h"

@implementation HWGongGaoChildModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
-(void)setValue:(id)value forKey:(NSString *)key
{
    [super setValue:value forKey:key];
    if ([key isEqualToString:@"id"]) {
        _ID = value;
    }
}

@end
