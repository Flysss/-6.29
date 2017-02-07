//
//  ZJMyPostBettomView.h
//  SalesHelper_A
//
//  Created by zhipu on 16/6/23.
//  Copyright © 2016年 X. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZJMyPostBettomView;
@class BHMyPostsModel;
@protocol ZJMyPostBettomViewDelegate <NSObject>

- (void)clickLikeButtonAction:(ZJMyPostBettomView *)ZJPostBodyView;
- (void)clickComButtonAction:(ZJMyPostBettomView *)ZJPostBodyView;

@end

@interface ZJMyPostBettomView : UIView

@property (nonatomic, strong) UILabel *lblTime;
@property (nonatomic, strong) UIButton *btnLike;
@property (nonatomic, strong) UIButton *btnReply;
@property (nonatomic, strong) UILabel *lblLine;
@property (nonatomic, weak) id<ZJMyPostBettomViewDelegate>delegate;
@property (nonatomic, strong) BHMyPostsModel *model;
@property (nonatomic, strong) NSIndexPath *indexpath;
+ (CGFloat)heightBodyView:(BHMyPostsModel *)model;

@end
