//
//  HWQuanZiCell.h
//  SalesHelper_A
//
//  Created by 胡伟 on 16/3/21.
//  Copyright © 2016年 X. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BHLeftModel;
@interface HWQuanZiCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *bottomLine;

+ (instancetype)quanZiCellWithTableView:(UITableView *)tableView;
@property (nonatomic, strong)BHLeftModel *model;
@end
