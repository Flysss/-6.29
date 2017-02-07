//
//  ZJPostHead.h
//  SalesHelper_A
//
//  Created by zhipu on 16/3/20.
//  Copyright © 2016年 X. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BHFirstListModel;
@class BHHuaTiModel;
@class ZJPostHead;
@protocol ZJPostHeadDelegate <NSObject>

- (void)clikeGuanZhuButtonAction:(ZJPostHead *)postHead;
- (void)tapImgJumpPageAction:(ZJPostHead *)postHead;
- (void)clikeNameLabelAction:(ZJPostHead *)postHead;

@end


@interface ZJPostHead : UIView

@property (nonatomic, strong)UIImageView *imgHead;
@property (nonatomic, strong)UILabel *lblName;
@property (nonatomic, strong)UIButton *btnLV;
@property (nonatomic, strong)UILabel *lblOrgName;
//@property (nonatomic, strong)UILabel *lblLine;
@property (nonatomic, strong)UIButton *btnGuanZhu;
@property (nonatomic, strong)NSIndexPath *indexpath;
@property (nonatomic, strong)NSString *loginuid;
@property (nonatomic, strong)BHFirstListModel *model;
@property (nonatomic, strong)BHHuaTiModel *Hmodel;


@property (nonatomic, weak)id<ZJPostHeadDelegate>delegate;

@end
