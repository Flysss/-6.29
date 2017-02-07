//
//  HWMessageCell.h
//  SalesHelper_A
//
//  Created by 胡伟 on 16/3/18.
//  Copyright © 2016年 X. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HWMessageModel;
@interface HWMessageCell : UITableViewCell

+ (instancetype)messageCellWithTableView:(UITableView *)tableView;

@property (nonatomic,strong) HWMessageModel *model;

@end
