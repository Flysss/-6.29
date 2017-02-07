//
//  HWGongGaoCell.h
//  SalesHelper_A
//
//  Created by 胡伟 on 16/3/9.
//  Copyright © 2016年 X. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HWGongGaoFrame;
@interface HWGongGaoCell : UITableViewCell


+ (instancetype)gongGaoCellWithTableView:(UITableView *)tableView;

@property (nonatomic,strong) HWGongGaoFrame *gongGaoFrame;

@end
