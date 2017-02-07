//
//  ZJPostFirstLikeView.h
//  SalesHelper_A
//
//  Created by zhipu on 16/5/16.
//  Copyright © 2016年 X. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BHFirstListModel;
@class ZJPostFirstLikeView;
@class BHHuaTiModel;

@protocol ZJPostFirstLikeViewDelegate <NSObject>

- (void)tapLikeHeadImgJumpPageAction:(ZJPostFirstLikeView *)postLikeView;
- (void)clickJumpPageLikePeopleButtonAction:(ZJPostFirstLikeView *)postLikeView;

@end

@interface ZJPostFirstLikeView : UIView

@property (nonatomic, strong)BHFirstListModel *model;
@property (nonatomic, strong)NSMutableArray *zanCount;
@property (nonatomic, strong)UIButton *btnZanCount;
@property (nonatomic, weak)id<ZJPostFirstLikeViewDelegate>delegate;
@property (nonatomic, strong)NSIndexPath *indexpath;
@property (nonatomic, assign)NSInteger n;
@property (nonatomic, strong)BHHuaTiModel *Hmodel;

+ (CGFloat)heightForView:(NSArray *)zanArr;


@end
