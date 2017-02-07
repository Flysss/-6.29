//
//  ForgetPassStep1ViewController.m
//  SalesHelper_A
//
//  Created by summer on 14/12/19.
//  Copyright (c) 2014年 X. All rights reserved.
//

#import "ForgetPassStep1ViewController.h"
#import "ForgetPassStep2ViewController.h"
#import "UIColor+Extend.h"

@interface ForgetPassStep1ViewController ()

@end

@implementation ForgetPassStep1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutSubViews];
    [self CreateCustomNavigtionBarWith:self leftItem:@selector(backToView) rightItem:nil];
    //创建标题
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-200)/2, 27, 200, 30)];
    titleLabel.text = self.title;
    titleLabel.font = Default_Font_18;
    [titleLabel setTextColor:[UIColor whiteColor]];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.topView addSubview: titleLabel];
    
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
//    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:21.0/255.0 green:159/255.0 blue:234/255.0 alpha:1]];
    
    //定制控件样式
    self.getIdentityCodeBtn.layer.cornerRadius = 20.0f;
    self.getIdentityCodeBtn.backgroundColor = [UIColor hexChangeFloat:KBlueColor];
    [self.getIdentityCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *userName = [defaults objectForKey:@"login_User_name"];

    if ([self.fromViewType isEqualToString:LOGIN_VC]) {
        self.phoneField.userInteractionEnabled = YES ;
    }else if ([self.fromViewType isEqualToString:DRAWAL_VC]) {
        self.phoneField.userInteractionEnabled = NO ;
        self.phoneField.text = userName;
        self.phoneField.textColor = [UIColor grayColor];
    }

    //回收键盘
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(recycleKeyboard)];
    
    [self.view addGestureRecognizer:tap];
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
    if (self.phoneField == textField){  //判断是否时我们想要限定的那个输入框
        if ([toBeString length] > 11) { //如果输入框内容大于20则弹出警告
            textField.text = [toBeString substringToIndex:11];
            //            [self.view makeToast:@"超过最大字数(11位)不能输入了"];
            return NO;
        }
        
    }
    
    return YES;
}


#pragma mark 获取验证码
- (IBAction)getIdentityCodeAction:(id)sender
{
    [self recycleKeyboard];
    if (self.phoneField.text.length == 0)
    {
        [self.view makeToast:@"手机号码不能为空"];
        return;
    }else if (![ProjectUtil isFuzzyPhone:self.phoneField.text]) {
        [self.view makeToast:@"请输入正确的手机号码"];
        return;
    }
    else
    {
        [self requestSendSMS];
    }
}




#pragma mark - request 服务器
- (void)requestSendSMS
{
    
//    NSDictionary *dict = @{@"userName":self.phoneField.text};
//    
//    RequestInterface *requestO = [[RequestInterface alloc] init];
//    
//    [self.view makeProgressViewWithTitle:ProgressString];
//
//    NSLog(@"%@", dict);
//    [requestO requestForgetpwdSendSMSWithParam:dict];
//    
//    [requestO getInterfaceRequestObject:^(id data) {
//        
//        [self.view hideProgressView];
//        NSLog(@"%@", data);
//        if ([[data objectForKey:@"success"] boolValue])
//        {
//        
//            ForgetPassStep2ViewController *forgetPassStep2VC = [[ForgetPassStep2ViewController alloc] init];
//            
//            forgetPassStep2VC.title = @"忘记密码（2/3）";
//        
//            forgetPassStep2VC.myPhoneNo = self.phoneField.text;
//            
//            if (data[@"datas"])
//            {
//                forgetPassStep2VC.identityCode = data[@"datas"];
//            
//                forgetPassStep2VC.fromViewType = self.fromViewType;
//                [forgetPassStep2VC creatBackButtonWithPushType:Push With:@"返回" Action:nil];
//                [self.navigationController pushViewController:forgetPassStep2VC animated:YES];
//            }
//        }
//        else
//        {
//            [self.view makeToast:data[@"message"]];
//        }
//
//        
//    } Fail:^(NSError *error) {
////        [self.view hideProgressView];
//        [self.view makeToast:HintWithNetError];
//    }];
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
//    NSDictionary *dict = @{@"userName":self.phoneField.text,
//                           //     @"identity":@"0" 0注册 1通知类 2 忘记密码 3:支付密码 4：提现密码
//                           @"type":@"4"
//                           };
//    
    if ([self.fromViewType isEqualToString:DRAWAL_VC])
    {
        NSDictionary *dict = @{@"phone":self.phoneField.text,
                               //     @"identity":@"0" 0注册 1通知类 2 忘记密码 3:支付密码 4：提现密码
                               @"type":@"4"
                               };
        ForgetPassStep2ViewController *forgetPassStep2VC = [[ForgetPassStep2ViewController alloc]init];
        RequestInterface *requestO = [[RequestInterface alloc] init];
        [requestO requestRegisterSendSMSWithParam:dict];
        [requestO getInterfaceRequestObject:^(id data) {
            forgetPassStep2VC.title = @"忘记提现密码（2/3）";
            forgetPassStep2VC.myPhoneNo = self.phoneField.text;
            forgetPassStep2VC.identityCode = data[@"datas"];
            forgetPassStep2VC.fromViewType = self.fromViewType;
            [forgetPassStep2VC creatBackButtonWithPushType:Push With:@"返回" Action:nil];
            [self.navigationController pushViewController:forgetPassStep2VC animated:YES];
        } Fail:^(NSError *error) {
            
        }];
    }
    else
    {
        NSDictionary *dict = @{@"userName":self.phoneField.text};
        
        RequestInterface *requestOp = [[RequestInterface alloc] init];
        [requestOp requestForgetpwdSendSMSWithParam:dict];
        [self.view makeProgressViewWithTitle:ProgressString];
        [requestOp getInterfaceRequestObject:^(id data) {
            
            [self.view hideProgressView];
            if ([[data objectForKey:@"success"] boolValue]) {
                
                ForgetPassStep2ViewController *forgetPassStep2VC = [[ForgetPassStep2ViewController alloc] init];
                forgetPassStep2VC.title = @"忘记密码（2/3）";
                
                forgetPassStep2VC.myPhoneNo = self.phoneField.text;
                
                if (data[@"datas"])
                {
                    forgetPassStep2VC.identityCode = data[@"datas"];
                    
                    forgetPassStep2VC.fromViewType = self.fromViewType;
                    [forgetPassStep2VC creatBackButtonWithPushType:Push With:@"返回" Action:nil];
                    [self.navigationController pushViewController:forgetPassStep2VC animated:YES];
                }

            }
            else
            {
                [self.view makeToast:data[@"message"]];
            }
            
        } Fail:^(NSError *error) {
            [self.view hideProgressView];
            [self.view makeToast:HintWithNetError];
        }];
    }
    

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
