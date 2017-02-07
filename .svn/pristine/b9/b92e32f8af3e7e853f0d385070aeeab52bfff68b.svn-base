//
//  RegisterStep3ViewController.m
//  SalesHelper_A
//
//  Created by summer on 14/12/18.
//  Copyright (c) 2014年 X. All rights reserved.
//

#import "SetDrawalStep3ViewController.h"
#import "WithdrawalPageViewController.h"
#import "AddBankCardViewController.h"
#import "MyPurseViewController.h"
@interface SetDrawalStep3ViewController ()<UIAlertViewDelegate>

@end

@implementation SetDrawalStep3ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutSubViews];
    [self CreateCustomNavigtionBarWith:self leftItem:@selector(backToView) rightItem:nil];
    //创建标题
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-200)/2, 27, 200, 30)];
    titleLabel.text = @"设置提现密码(3/3)";
    titleLabel.font = Default_Font_20;
    [titleLabel setTextColor:[UIColor whiteColor]];
    //    [titleLabel sizeToFit];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.topView addSubview: titleLabel];
//    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:21.0/255.0 green:159/255.0 blue:234/255.0 alpha:1]];
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
-(void)layoutSubViews
{
    //定制控件样式
    self.registerBtn.layer.cornerRadius = 20.0f;
    self.registerBtn.backgroundColor = [UIColor hexChangeFloat:KBlueColor];
    
    self.passField.keyboardType = UIKeyboardAppearanceAlert;
    self.rePassField.keyboardType = UIKeyboardAppearanceAlert;
    
    //回收键盘
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(recycleKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}

#pragma mark 回收键盘
-(void)recycleKeyboard
{
    [self.view endEditing:YES];
}

#pragma mark UITextFieldDelegate
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickSubmitBtn:(id)sender {
    
    [self.view endEditing:YES];
    
    if (self.passField.text.length == 0 || self.rePassField.text.length == 0)
    {
        [self.view makeToast:HintWithInputNilError];
        return;
    }
    else if (self.passField.text.length < 6 || self.passField.text.length >16)
    {
        [self.view makeToast:@"密码格式为6—16位字符"];
        return;
    }
    else if (![self.passField.text isEqualToString:self.rePassField.text])
    {
        [self.view makeToast:@"两次密码输入不一致"];
        return;
    }
    
    [self requestSetWithdPwd];
}

//设置提现密码   [ProjectUtil changeToStringToMd5String:self.passField.text]
- (void)requestSetWithdPwd
{
    NSUserDefaults* defaults=[NSUserDefaults standardUserDefaults];

    NSDictionary *dict = @{@"token":self.login_user_token,
                          // @"identity":@"0",
                           @"pwd":self.passField.text,
                          // @"type":@"1",
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
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"设置提现密码成功" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            alert.tag = 800;
            [alert show];
            
            [defaults setObject:self.passField.text forKey:@"withdrawPwd"];
            [defaults synchronize];

        }else {
            [self.view makeToast:data[@"error_remark"]];
        }
    } Fail:^(NSError *error) {
        [self.view hideProgressView];
        [self.view makeToast:HintWithNetError];
    }];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self recycleKeyboard];
    
    if (alertView.tag == 800 )
    {
//        NSInteger navCount = self.navigationController.viewControllers.count;
//        if (navCount > 4) {
//            
//            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:navCount-4] animated:YES];
//        }else {
//            [self.navigationController popViewControllerAnimated:YES];
//        }
       
//        WithdrawalPageViewController* vc=[[WithdrawalPageViewController alloc]init];
//        [self.navigationController pushViewController:vc animated:YES];
        
        if (self.isShowBank) {
            [self.view endEditing:YES];
            AddBankCardViewController* vc=[[AddBankCardViewController alloc]init];
            vc.title=@"添加银行卡";
            [vc creatBackButtonWithPushType:Push With:@"返回" Action:nil];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController pushViewController:vc animated:YES];
            });
        } else
        {
            //NSArray * vcArray = self.navigationController.viewControllers;
            for (UIViewController * vc in self.navigationController.viewControllers) {
                if ([vc isKindOfClass:[MyPurseViewController class]]) {
                    
                    [self performSelector:@selector(popview) withObject:nil afterDelay:0.25];
                }
            }
        } 
        
      }
    
}
-(void)popview
{
    for (UIViewController * vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[MyPurseViewController class]]) {
            
    [self.navigationController popToViewController:vc animated:YES];
        }
    }
}
@end
