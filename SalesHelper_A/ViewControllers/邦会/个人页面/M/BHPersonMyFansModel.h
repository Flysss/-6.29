//
//  BHPersonMyFansModel.h
//  SalesHelper_A
//
//  Created by zhipu on 16/3/3.
//  Copyright © 2016年 X. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BHPersonMyFansModel : NSObject

@property (nonatomic, strong)NSString *name;//姓名
@property (nonatomic, strong)NSString *remark;//等级
@property (nonatomic, strong)NSString *iconpath;//头像
@property (nonatomic, strong)NSString *praise_num;//被赞的次数
@property (nonatomic, strong)NSString *isfocus;//关注的状态
@property (nonatomic, strong)NSString *uid;//粉丝的id

@end
