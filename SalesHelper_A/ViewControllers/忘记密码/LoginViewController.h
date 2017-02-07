//
//  LoginViewController.h
//  SalesHelper_A
//
//  Created by summer on 14/12/18.
//  Copyright (c) 2014年 X. All rights reserved.
//
#import "ModelViewController.h"

@protocol requestLogin <NSObject>
- (void)sendRequestWithToken:(NSString *)token;
@end

@interface LoginViewController : ModelViewController

@property (weak, nonatomic) IBOutlet UIView *accoutInputView;//账户view
@property (weak, nonatomic) IBOutlet UIView *passInputView;//密码view

@property (weak, nonatomic) IBOutlet UITextField *accountField;//账户名输入框

@property (weak, nonatomic) IBOutlet UITextField *passField;//账户密码输入框

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;//登录按钮

@property (weak, nonatomic) IBOutlet UIImageView *headimageview;

@property (assign,nonatomic)id <requestLogin>delegate;

@end
