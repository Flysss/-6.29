//
//  MyComplainTableViewCell.h
//  SalesHelper_A
//
//  Created by ZhipuTech on 14/12/21.
//  Copyright (c) 2014年 X. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyComplainTableViewCell : UITableViewCell
/**
 *申诉标题
 */
@property (weak, nonatomic) IBOutlet UILabel *complainTitle;
/**
 *申请时间
 */
@property (weak, nonatomic) IBOutlet UILabel *time;
/**
 *推荐人
 */
@property (weak, nonatomic) IBOutlet UILabel *name;
/**
 *推荐楼盘
 */
@property (weak, nonatomic) IBOutlet UILabel *houseName;

/**
 *进度
 */
@property (weak, nonatomic) IBOutlet UILabel *progress;

@end
