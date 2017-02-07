//
//  ZJFirstDetailHeaderView.h
//  SalesHelper_A
//
//  Created by zhipu on 16/3/24.
//  Copyright © 2016年 X. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZJFirstDetailHeaderView;
@class BHDetailTopModel;
@protocol ZJFirstDetailHeaderViewDelegate <NSObject>

- (void)clikeGuanZhuButtonAction:(ZJFirstDetailHeaderView *)firstHead;
- (void)tapImgJumpPageAction:(ZJFirstDetailHeaderView *)firstHead;

@end

@interface ZJFirstDetailHeaderView : UIView

@property (nonatomic, strong)UIImageView *imgHead;
@property (nonatomic, strong)UILabel *lblName;
@property (nonatomic, strong)UIButton *btnLV;
@property (nonatomic, strong)UILabel *lblOrgName;
//@property (nonatomic, strong)UILabel *lblLine;
@property (nonatomic, strong)UIButton *btnGuanZhu;

@property (nonatomic, strong)BHDetailTopModel *model;

@property (nonatomic, weak)id<ZJFirstDetailHeaderViewDelegate>delegate;
@property (nonatomic, strong)NSString *loginuid;

@end
