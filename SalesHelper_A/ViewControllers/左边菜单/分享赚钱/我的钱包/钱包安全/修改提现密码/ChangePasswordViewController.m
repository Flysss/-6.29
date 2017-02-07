//
//  ChangePasswordViewController.m
//  SalesHelper_A
//
//  Created by zhipu on 14/10/24.
//  Copyright (c) 2014年 zhipu. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "LoginViewController.h"

@interface ChangePasswordViewController ()<UITextFieldDelegate,UIAlertViewDelegate>
{
    UITextField *editingTextField;
}

@end

@implementation ChangePasswordViewController



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:23.0/255.0 green:183/255.0 blue:242/255.0 alpha:1]];
    
    self.confirmBtn.layer.cornerRadius = 20.0f;
    self.confirmBtn.backgroundColor = [UIColor colorWithRed:23/255.0 green:183/255.0 blue:242/255.0 alpha:1.0];
    self.oldPassword.keyboardType = UIKeyboardAppearanceAlert;
    self.password.keyboardType = UIKeyboardAppearanceAlert;
    self.confirmPassword.keyboardType = UIKeyboardAppearanceAlert;

    self.oldPassword.delegate = self;
    self.password.delegate = self;
    self.confirmPassword.delegate = self;
    
    
//    //设置触摸非输入框 键盘隐藏
//    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(recycleKeyBoard)];
//    tapRecognizer.cancelsTouchesInView = NO;
//    [self.view addGestureRecognizer:tapRecognizer];
    
    UITapGestureRecognizer*  tapGester=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(recycleKeyBoard)];
    tapGester.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGester];
    
    [self CreateCustomNavigtionBarWith:self leftItem:@selector(backlastView) rightItem:nil];
    //创建标题
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-120)/2, 27, 120, 30)];
    titleLabel.text = self.title;
    titleLabel.font = Default_Font_20;
    [titleLabel setTextColor:[UIColor whiteColor]];
    //    [titleLabel sizeToFit];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.topView addSubview: titleLabel];
    
    
    
}
//-(void)recycleKeyBoard
//{
//    [self.view endEditing:YES];
//}
-(void)backlastView
{
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)viewDidDisappear:(BOOL)paramAnimated
{
    [self.view endEditing:YES];
    [super viewDidDisappear:paramAnimated];
}

#pragma mark - clickBtnAction
-(void)recycleKeyBoard {
    [self.view endEditing:YES];
}


- (IBAction)confirmBtnClick:(id)sender {
    
//    [self.view endEditing:YES];
    [self.oldPassword resignFirstResponder];
    [self.password resignFirstResponder];
    [self.confirmPassword resignFirstResponder];

    
    
    if ([self.oldPassword.text isEqualToString:StringEmpty] || self.oldPassword.text == nil) {
        [self.view makeToast:@"旧密码不能为空"];
        return;
    }else if (self.oldPassword.text.length < 6 || self.oldPassword.text.length >16) {
        [self.view makeToast:@"旧密码格式为6—16位字符"];
        return;
    }else if ([self.password.text isEqualToString:StringEmpty] || self.password.text == nil) {
        [self.view makeToast:@"新密码不能为空"];
        return;
    }else if (self.password.text.length < 6 || self.password.text.length >16) {
        [self.view makeToast:@"新密码格式为6—16位字符"];
        return;
    }else if ([self.confirmPassword.text isEqualToString:StringEmpty] || self.confirmPassword.text == nil) {
        [self.view makeToast:@"确认密码不能为空"];
        return;
    }else if (![self.password.text isEqualToString:self.confirmPassword.text]) {
        [self.view makeToast:@"两次密码输入不一致"];
        return;
    }
    
    else
    {
        if ([self.changeType isEqualToString:LOGIN_PWD]) {
            [self requestUpdatePwd];
        }else if ([self.changeType isEqualToString:DRAWAL_PWD]) {
            [self requestModWithdPwd];
        }

    }
}

#pragma mark - UITextFieldDelegate
//当用户按下return键或者按回车键，keyboard消失
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    [self.oldPassword resignFirstResponder];
    [self.password resignFirstResponder];
    [self.confirmPassword resignFirstResponder];
    
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
   // editingTextField = textField;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
    if ([toBeString length] > 16) { //如果输入框内容大于20则弹出警告
        textField.text = [toBeString substringToIndex:16];
//        [self.view makeToast:@"超过最大字数(16位)不能输入了"];
        return NO;
    }
    return YES;
}

#pragma mark - 接口请求
//修改登录密码  [ProjectUtil changeToStringToMd5String:self.oldPassword.text] [ProjectUtil changeToStringToMd5String:self.password.text]
- (void)requestUpdatePwd
{
    NSDictionary *dict = @{@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"Login_User_token"],
                           @"oldPwd":self.oldPassword.text,
//                           @"identity":@"0",
                           @"pwd":self.password.text
                           };
    
    RequestInterface *requestOp = [[RequestInterface alloc] init];
    [requestOp requestUpdatePwdWithParam:dict];
    
    [self.view makeProgressViewWithTitle:@"正在修改"];
    [requestOp getInterfaceRequestObject:^(id data) {
        [self.view hideProgressView];
//        [ProjectUtil showLog:@"data = %@",data];
        if ([data[@"success"] boolValue])
        {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"登录密码修改成功" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
//            alert.tag = 800;
//            [alert show];
            [self.view makeToast:@"修改成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[SDImageCache sharedImageCache] clearDisk];
                [[SDImageCache sharedImageCache] clearMemory];
                
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Login_User_token"];
                
                NSArray *array = self.navigationController.viewControllers;
                [self.navigationController popToViewController:array[0] animated:YES];
            });
        }else {
            [self.view makeToast:data[@"message"]];
        }
    } Fail:^(NSError *error) {
        [self.view hideProgressView];
        [self.view makeToast:HintWithNetError];
    }];
}


//修改提现密码  [ProjectUtil changeToStringToMd5String:self.oldPassword.text] [ProjectUtil changeToStringToMd5String:self.password.text]
- (void)requestModWithdPwd
{
    NSDictionary *dict = @{@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"Login_User_token"],
                           @"oldPwd":self.oldPassword.text,
                           @"pwd":self.password.text
                           };
    [self.view makeProgressViewWithTitle:ProgressString];
    RequestInterface *requestOp = [[RequestInterface alloc] init];
    [requestOp requestModWithdPwdWithParam:dict];
    
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

#pragma mark - 提示框
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    
    if (alertView.tag == 800 )
    {
//        [self.view endEditing:YES];
        
        [[SDImageCache sharedImageCache] clearDisk];
        [[SDImageCache sharedImageCache] clearMemory];
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Login_User_token"];
        
        NSArray *array = self.navigationController.viewControllers;
        [self.navigationController popToViewController:array[0] animated:YES];
//        UINavigationController *loginVC = [[UINavigationController alloc] initWithRootViewController:[[LoginViewController alloc]init]];
//        [self presentViewController:loginVC animated:YES completion:nil];
//        LoginAndRegisterViewController *vc = [[LoginAndRegisterViewController alloc] init];
//        [self presentViewController:vc animated:YES completion:nil];
        
    }
    else if (alertView.tag == 810)
    {
//        [self.view endEditing:YES];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
