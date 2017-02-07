//
//  ZJDetailReplyHeaderView.h
//  SalesHelper_A
//
//  Created by zhipu on 16/3/26.
//  Copyright © 2016年 X. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BHPingLunModel;
@class ZJDetailReplyHeaderView;

@protocol ZJDetailReplyHeaderViewDelegate <NSObject>

- (void)tapSendReplyAction:(ZJDetailReplyHeaderView *)replyHeaderView;
- (void)clickDeletReplyAction:(ZJDetailReplyHeaderView *)replyHeaderView;
- (void)clickZanReplyAction:(ZJDetailReplyHeaderView *)replyHeaderView;

@end

@interface ZJDetailReplyHeaderView : UIView

@property (nonatomic, strong)BHPingLunModel *model;
@property (nonatomic, strong)UIImageView *headImage;
@property (nonatomic, strong)UILabel *timeLabel;
@property (nonatomic, strong)UILabel *nameLabel;
@property (nonatomic, strong)UIButton *deletButton;
@property (nonatomic, strong)UILabel *bodyLabel;
@property (nonatomic, assign)CGFloat viewHeight;
@property (nonatomic, strong)NSString *loginuid;
@property (nonatomic, strong)UIButton *btnZan;
@property (nonatomic, strong)UILabel *lblLine;

@property (nonatomic, strong)id<ZJDetailReplyHeaderViewDelegate>delegate;

- (void)btnstate:(NSInteger)count;

@end
