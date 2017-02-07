//
//  BaseViewController.h
//  SalesHelper_A
//
//  Created by ZhipuTech on 15/6/11.
//  Copyright (c) 2015年 X. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController
@property (nonatomic, strong) UIView * topView;
@property (nonatomic, strong) UIButton * backBtn;
@property (nonatomic, strong) UIButton * rightBtn;

//创建自定义的导航栏
-(void)CreateCustomNavigtionBarWith:(id)target leftItem:(SEL)leftAction rightItem:(SEL)rightAction;
@end
