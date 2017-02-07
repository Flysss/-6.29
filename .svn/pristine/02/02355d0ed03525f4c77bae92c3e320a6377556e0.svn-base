//
//  RecommentViewController.h
//  SalesHelper_A
//
//  Created by ZhipuTech on 15/6/11.
//  Copyright (c) 2015年 X. All rights reserved.
//

#import "BaseTableViewController.h"
#import "BaseViewController.h"
#import "ModelViewController.h"
#import "RecommendPropertyViewController.h"


@interface RecommendViewController : ModelViewController <recommendPropertyVCDelegate>
// 数据源
@property(nonatomic,retain)NSMutableArray * info;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;
@property (nonatomic, strong) NSMutableArray *selectedRealestate;   //推荐的房型信息
@property (nonatomic , copy)NSString * ArchName;
@property (nonatomic,assign)NSInteger backVCIndex;

@property (nonatomic,retain)NSDictionary * customerInfo;

@property (nonatomic,copy)NSString* flotName;//楼盘名
@end
