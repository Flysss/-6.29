//
//  ForgetPassStep3ViewController.m
//  SalesHelper_A
//
//  Created by summer on 14/12/19.
//  Copyright (c) 2014年 X. All rights reserved.
//

#import "ForgetPassStep3ViewController.h"

@interface ForgetPassStep3ViewController ()<UIAlertViewDelegate>

@end

@implementation ForgetPassStep3ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutSubViews];
    [self CreateCustomNavigtionBarWith:self leftItem:@selector(backToView) rightItem:nil];
    //创建标题
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-200)/2, 27, 200, 30)];
    titleLabel.text = self.title;
    titleLabel.font = Default_Font_18;
    [titleLabel setTextColor:[UIColor whiteColor]];
    //    [titleLabel sizeToFit];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.topView addSubview: titleLabel];
}

-(void)layoutSubViews
{
//    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:21.0/255.0 green:159/255.0 blue:234/255.0 alpha:1]];
    
    
    //定制控件样式
    self.setPassBtn.layer.cornerRadius = 20.0f;
    self.setPassBtn.backgroundColor = [UIColor hexChangeFloat:KBlueColor];
    self.passField.keyboardType = UIKeyboardAppearanceAlert;
    self.rePassField.keyboardType = UIKeyboardAppearanceAlert;
    
    //回收键盘
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(recycleKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)backToView
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark 回收键盘
-(void)recycleKeyboard
{
    [self.view endEditing:YES];
}

#pragma mark - UITextFieldDelegate
//当用户按下return键或者按回车键，keyboard消失
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
    
    if ([toBeString length] > 16) { //如果输入框内容大于20则弹出警告
        textField.text = [toBeString substringToIndex:16];
        //            [self.view makeToast:@"超过最大字数(4位)不能输入了"];
        return NO;
    }

    return YES;
}

- (IBAction)resetBtnClick:(id)sender {
    
    [self.view endEditing:YES];
    
    if (self.passField.text.length == 0) {
        [self.view makeToast:@"新密码不能为空"];
        return;
    }else if (self.passField.text.length < 6 || self.passField.text.length >16) {
        [self.view makeToast:@"密码格式为6—16位字符"];
        return;
    }else if (self.rePassField.text.length == 0) {
        [self.view makeToast:@"确认密码不能为空"];
        return;
    }else if (![self.passField.text isEqualToString:self.rePassField.text]) {
        [self.view makeToast:@"两次密码输入不一致"];
        return;
    }
    
    if ([self.fromViewType isEqualToString:LOGIN_VC]) {
        [self requestReSetpwd];
    }else if ([self.fromViewType isEqualToString:DRAWAL_VC]) {
        [self requestSetWithdPwd];
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 接口请求
//重设登录密码  [ProjectUtil changeToStringToMd5String:self.passField.text]
- (void)requestReSetpwd
{
    
    
    NSDictionary *dict = @{@"userName":self.myPhoneNo,
                           @"code":self.identityCode,
                           @"pwd":self.passField.text
                           };
    [self.view makeProgressViewWithTitle:ProgressString];
    RequestInterface *requestOp = [[RequestInterface alloc] init];
    [requestOp requestSetpwdWithParam:dict];
    
    [requestOp getInterfaceRequestObject:^(id data) {
        [self.view hideProgressView];
        [ProjectUtil showLog:@"data = %@",data];
        if ([[data objectForKey:@"success"] boolValue]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"密码修改成功" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            alert.tag = 800;
            [alert show];
        }else {
            [self.view makeToast:data[@"error_remark"]];
        }
    } Fail:^(NSError *error) {
        [self.view hideProgressView];
        [self.view makeToast:HintWithNetError];
    }];
}

//重设提现密码  [ProjectUtil changeToStringToMd5String:self.passField.text]
- (void)requestSetWithdPwd
{
    NSDictionary *dict = @{@"token":self.login_user_token,
                         //  @"identity":@"0",
                           @"pwd":self.passField.text,
                        //   @"type":@"1",
                           @"code":self.identityCode,
                          // @"phone":self.myPhoneNo
                           };
    [self.view makeProgressViewWithTitle:ProgressString];
    RequestInterface *requestOp = [[RequestInterface alloc] init];
    [requestOp requestSetWithdPwdWithParam:dict];
    
    [requestOp getInterfaceRequestObject:^(id data) {
        [self.view hideProgressView];
        [ProjectUtil showLog:@"data = %@",data];
        if ([data[@"success"] boolValue]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"提现密码修改成功" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            alert.tag = 810;
            [alert show];
        }else {
            [self.view makeToast:data[@"message"]];
        }
    } Fail:^(NSError *error) {
        [self.view hideProgressView];
        [self.view makeToast:HintWithNetError];
    }];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 800 ) {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
    }else if (alertView.tag == 810) {
        NSInteger navCount = self.navigationController.viewControllers.count;
        if (navCount > 4) {
            
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:navCount-4] animated:YES];
        }else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    
}

@end
