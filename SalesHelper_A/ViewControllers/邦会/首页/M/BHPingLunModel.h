//
//  BHPingLunModel.h
//  SalesHelper_A
//
//  Created by 曾杰 on 16/3/10.
//  Copyright © 2016年 X. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BHPingLunModel : NSObject
@property (nonatomic, strong)NSString *pingLunID;
@property (nonatomic, strong)NSString *uid;
@property (nonatomic, strong)NSString *contents;
@property (nonatomic, strong)NSString *is_praise;
@property (nonatomic, strong)NSString *iconpath;
@property (nonatomic, strong)NSString *name;
@property (nonatomic, assign)NSInteger hf_num;
@property (nonatomic, assign)NSInteger dz_num;
@property (nonatomic, strong)NSArray *child;
@property (nonatomic, strong)NSString *addtime;


@end
