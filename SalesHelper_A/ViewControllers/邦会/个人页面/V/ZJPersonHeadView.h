//
//  ZJPersonHeadView.h
//  SalesHelper_A
//
//  Created by zhipu on 16/3/18.
//  Copyright © 2016年 X. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZJPersonHeadView;
@protocol ZJPersonHeadDelegate <NSObject>

- (void)clickMessageButtonAction:(ZJPersonHeadView *)ZJPersonHeadView;
- (void)clickGuanZhuButtonAction:(ZJPersonHeadView *)ZJPersonHeadView;
- (void)clickPostButtonAction:(ZJPersonHeadView *)ZJPersonHeadView;
- (void)clickReplyButtonAction:(ZJPersonHeadView *)ZJPersonHeadView;
- (void)clickJumpPriVCAction:(ZJPersonHeadView *)ZJPersonHeadView;
- (void)clickJumpFansVCAction:(ZJPersonHeadView *)ZJPersonHeadView;

@end

@interface ZJPersonHeadView : UIView

@property (nonatomic, strong)UIImageView *imgHead;
@property (nonatomic, strong)UIButton *btnMessage;
@property (nonatomic, strong)UIButton *btnGuanZhu;
@property (nonatomic, strong)UILabel *lblAddress;
@property (nonatomic, strong)UILabel *lblGuanZhuNum;
@property (nonatomic, strong)UILabel *lblFansNum;
@property (nonatomic, strong)UIImageView *imgBac;
@property (nonatomic, strong)UIButton *btnPost;
@property (nonatomic, strong)UIButton *btnReply;


@property (nonatomic, strong)NSDictionary *dic;

@property (nonatomic, weak) id<ZJPersonHeadDelegate>delegate;

@end
