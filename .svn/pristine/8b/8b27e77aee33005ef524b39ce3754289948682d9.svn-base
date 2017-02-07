//
//  UIView+Five.h
//  WXMedia
//
//  Created by User on 14-8-5.
//  Copyright (c) 2014年 User. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import <objc/runtime.h>
#import "TableView_HUD.h"

@interface UIView (Five)

#pragma mark 属性

/**信息提示框*/
@property(strong, nonatomic) MBProgressHUD * hud;

/**弹出容器*/
@property(strong, nonatomic) UIView * uv_Panel;

#pragma mark 方法

/**提示信息*/
- (void)Message:(NSString *)message;

/**提示信息，N秒后关闭*/
- (void)Message:(NSString *)message HiddenAfterDelay:(NSTimeInterval)delay;

/**自定义提示框位置*/
- (void)Message:(NSString *)message YOffset:(float)yoffset HiddenAfterDelay:(NSTimeInterval)delay;

/**展示Loading标示*/
- (void)Loading:(NSString *)message;

- (void)Loading_0314;

/**隐藏*/
- (void)HiddenAfterDelay:(NSTimeInterval)delay;

/**隐藏*/
- (void)Hidden;

/*是否Loading中*/
- (BOOL)IsLoading;

/*用UIAlertView弹出提示信息*/
- (void)AlertMessage:(NSString *)message withTitile:(NSString *)title;

/*用UIAlertView弹出提示信息*/
- (void)AlertMessage:(NSString *)message withTitile:(NSString *)title withDelegate:(id)target;

/*展示列表数据*/
- (void)ShowData:(NSArray *)data Height:(CGFloat)height CellSelected:(void(^)(NSDictionary * dic))cellSelectedBlock;

//关闭弹出层For Data
- (void)HiddenData;

@end
