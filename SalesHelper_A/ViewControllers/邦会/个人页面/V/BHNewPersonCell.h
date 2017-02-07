//
//  BHNewPersonCell.h
//  SalesHelper_A
//
//  Created by zhipu on 16/3/19.
//  Copyright © 2016年 X. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZJCellHeadView;
@class BHMyPostsModel;
@class ZJPostBodyView;
@class ZJForwardView;
@class HWContentsLabel;
@class ZJMyPostBettomView;

@interface BHNewPersonCell : UITableViewCell

@property (nonatomic, strong)ZJCellHeadView *headView;

@property (nonatomic, strong)ZJPostBodyView *postBodyView;

@property (nonatomic, strong)ZJForwardView *forwardView;

@property (nonatomic, strong)BHMyPostsModel *model;

@property (nonatomic, strong) ZJMyPostBettomView *MyPostBettomView;

@property (nonatomic, strong)HWContentsLabel *lblBody;

+ (CGFloat)heightforCell:(BHMyPostsModel *)model;


@end
