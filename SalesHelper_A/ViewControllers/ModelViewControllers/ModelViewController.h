//
//  ModelViewController.h
//  SalesHelper_C
//
//  Created by summer on 14-10-10.
//  Copyright (c) 2014年 X. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+Extend.h"

typedef void (^MButtonBlock)(NSInteger tag);

typedef NS_ENUM(NSInteger, MNavigationItemType){
    MNavigationItemTypeTitle,
    MNavigationItemTypeLeft,
    MNavigationItemTypeRight =3,
};

typedef NS_ENUM(NSInteger, PushType){
    Present=101,
    Push=102,
};

@interface ModelViewController : UIViewController
{
    MButtonBlock mbuttonBlock;
    NSString *_login_User_name;

}

@property (nonatomic, strong) UIView * topView;
@property (nonatomic, strong) UIButton * backBtn;
@property (nonatomic, strong) UIButton * rightBtn;


//创建自定义的导航栏
-(void)CreateCustomNavigtionBarWith:(id)target leftItem:(SEL)leftAction rightItem:(SEL)rightAction;

-(void)layoutSubViews;
//创建返回按钮
-(void)creatBackButtonWithPushType:(PushType)pushType With:(NSString *)leftBtnTitle Action:(SEL)action;
//创建NavigationItem 
-(void)creatNavigationItemWithMNavigationItem:(MNavigationItemType)itemType ItemName:(NSString *)imageName;
//block
-(void)setMButtonAction:(MButtonBlock)ablock;
//跳入主界面
-(void)presentToMainViewController:(BOOL)flag;

-(UIButton *)creatUIButtonWithFrame:(CGRect)frame BackgroundColor:(UIColor *)backgroundColor Title:(NSString *)title TitleColor:(UIColor *)titleColor Action:(SEL)action;
-(UIBarButtonItem *)creatNegativeSpacerButton;

//获取月份和年份
-(NSAttributedString *)getDateWithYear:(NSInteger)year Month:(NSInteger)month Index:(NSInteger)index;

//创建特定button
-(UIButton *)creatSpecialButtonWithFrame:(CGRect)frame Title:(NSString *)title WithImage:(NSString *)imageName Action:(SEL)action;

//更新特定button的样式
- (void)updateThreeBtnTitle:(UIButton *)button BtnTitle:(NSString *)title BtnFont:(UIFont *)font;

- (void)modifySearchBarCancelBtn:(UISearchBar *)searchBar Color:(UIColor *)color;

//保存数据时插入页面传送过来的数据
- (void)insertZhipuDBAllInfo:(NSArray *)dataArray WithReqName:(NSString *)requestName;

//查询所有的存储的信息
-(id)doQueryZhipuDBAllInfo:(NSString *)requestName;

//检测网络情况
- (NSInteger)netWorkReachable;

-(UIImage *)imageWithBgColor:(UIColor *)color;

//请求机构码审核状态
-(void)requestOrgCodeState;

@property (nonatomic, strong) NSString *login_user_token;

@end
