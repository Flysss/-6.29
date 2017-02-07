//
//  BHListHuaTiCell.h
//  SalesHelper_A
//
//  Created by zhipu on 16/3/30.
//  Copyright © 2016年 X. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BHListHuaTiAndGongGaoModel;
#import "JoinHuaTiPlainImageView.h"

@interface BHListHuaTiCell : UITableViewCell

@property (nonatomic, strong)UILabel *lblTopic;//参与话题
@property (nonatomic, strong)UILabel *lblTitle;//话题标题
@property (nonatomic, strong)JoinHuaTiPlainImageView *imgTopic;
@property (nonatomic, strong)UIImageView *imgLeft;
@property (nonatomic, strong)UIImageView *imgRight;
@property (nonatomic, strong)UIImageView *imgLogo;
@property (nonatomic, strong)UILabel *lblHuaTi;

@property (nonatomic, strong)BHListHuaTiAndGongGaoModel *model;
@property (nonatomic, strong)NSString *isList;

@end
