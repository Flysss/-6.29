//
//  HWGongGaoModel.m
//  SalesHelper_A
//
//  Created by 胡伟 on 16/3/8.
//  Copyright © 2016年 X. All rights reserved.
//

#import "HWGongGaoModel.h"
#import "MJExtension.h"
#import "HWGongGaoChildModel.h"
@implementation HWGongGaoModel

- (NSDictionary *)objectClassInArray
{
    
    
    return @{@"child":[HWGongGaoChildModel class]};
}

- (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"ID" : @"id"};
    
}

@end
