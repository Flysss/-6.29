//
//  HWGongGaoToolBar.h
//  SalesHelper_A
//
//  Created by 胡伟 on 16/3/9.
//  Copyright © 2016年 X. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BHPingLunModel.h"
@class HWGongGaoModel;

@interface HWGongGaoToolBar : UIView
//@property (nonatomic,weak) UIButton *commentsButton;
@property (nonatomic,weak) UIButton *attitudesButton;
@property (nonatomic,strong) BHPingLunModel *model;
@property (nonatomic, assign) NSInteger section;
@end
