//
//  ZJShareView.h
//  SalesHelper_A
//
//  Created by zhipu on 16/6/16.
//  Copyright © 2016年 X. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZJShareView;
@protocol ZJShareViewDelegate <NSObject>

//删除帖子
- (void)ZJShareViewRemovePost:(ZJShareView *)shareView;

- (void)ZJShareViewRefreshView:(ZJShareView *)shareView;


@end


@interface ZJShareView : UIView
@property (nonatomic, assign)BOOL isReport;//是否隐藏举报

@property (nonatomic, strong)UIView *topView;
@property (nonatomic, strong)NSDictionary *shareDic;//分享参数

@property (nonatomic, weak)id<ZJShareViewDelegate>delegate;

@property (nonatomic, strong)UIView *bgView;

@property (nonatomic, assign)CGFloat shareViewHeight;

@property (nonatomic, assign)BOOL isDelete;//是否隐藏举报



+ (ZJShareView *)share;



@end
