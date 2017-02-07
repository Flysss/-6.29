//
//  ZJPostLikeView.h
//  SalesHelper_A
//
//  Created by zhipu on 16/3/20.
//  Copyright © 2016年 X. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BHFirstListModel;
@class ZJPostLikeView;
@class BHHuaTiModel;

@protocol ZJPostLikeViewDelegate <NSObject>

- (void)tapLikeHeadImgJumpPageAction:(ZJPostLikeView *)postLikeView;
- (void)clickJumpPageLikePeopleButtonAction:(ZJPostLikeView *)postLikeView;

@end

@interface ZJPostLikeView : UIView

@property (nonatomic, strong)BHFirstListModel *model;
@property (nonatomic, strong)NSMutableArray *zanCount;
@property (nonatomic, strong)UIButton *btnZanCount;
@property (nonatomic, weak)id<ZJPostLikeViewDelegate>delegate;
@property (nonatomic, strong)NSIndexPath *indexpath;
@property (nonatomic, assign)NSInteger n;
@property (nonatomic, strong)BHHuaTiModel *Hmodel;

@end
