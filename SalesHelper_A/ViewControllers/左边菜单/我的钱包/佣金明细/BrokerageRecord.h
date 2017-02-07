//
//  BrokerageRecord.h
//  SalesHelper_A
//
//  Created by ZhipuTech on 14/12/22.
//  Copyright (c) 2014年 X. All rights reserved.
//佣金记录模型

#import <Foundation/Foundation.h>
#import "BrokerageRecordList.h"
@interface BrokerageRecord : NSObject
/**count = 1;
 module = GetRewardDByR;
 record =     (
 {
 
 }
 );
 request = "2000.0";
 result = success;
 sumcount = 0;*/

/**
 *当月成交套数
 */
@property (nonatomic,copy) NSString *count;
/**
 *当月佣金总金额
 */
@property (nonatomic,copy) NSString *request;

/**
 *当月记录明细
 */
@property (nonatomic,copy) NSArray *record;
@end
