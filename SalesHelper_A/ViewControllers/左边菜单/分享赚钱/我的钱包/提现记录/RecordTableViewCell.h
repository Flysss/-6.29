//
//  RecordTableViewCell.h
//  SalesHelper_A
//
//  Created by ZhipuTech on 14/12/21.
//  Copyright (c) 2014年 X. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecordTableViewCell : UITableViewCell
/**
 *提现方式
 */
@property (weak, nonatomic) IBOutlet UILabel *drawMethods;
/**
 *提现金额
 */
@property (weak, nonatomic) IBOutlet UILabel *amount;
/**
 *提现时间
 */
@property (weak, nonatomic) IBOutlet UILabel *time;
/**
 *提现状态
 */
@property (weak, nonatomic) IBOutlet UILabel *state;

@end
