//
//  SetDrawalStep1ViewController.m
//  SalesHelper_A
//
//  Created by summer on 14/12/18.
//  Copyright (c) 2014年 X. All rights reserved.
//

#import "SetDrawalStep1ViewController.h"
#import "SetDrawalStep2ViewController.h"
#import "ModelWebViewController.h"

@interface SetDrawalStep1ViewController ()<UITextFieldDelegate>

@end

@implementation SetDrawalStep1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self CreateCustomNavigtionBarWith:self leftItem:@selector(backToView) rightItem:nil];
    //创建标题
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-200)/2, 27, 200, 30)];
    titleLabel.text = @"设置提现密码(1/3)";
    titleLabel.font = Default_Font_20;
    [titleLabel setTextColor:[UIColor whiteColor]];
    //    [titleLabel sizeToFit];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.topView addSubview: titleLabel];

    [self layoutSubViews];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = YES;
}

- (void)backToView
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)layoutSubViews
{
    //定制控件样式
    self.getIdetityCodeBtn.layer.cornerRadius = 20.0f;
    self.getIdetityCodeBtn.backgroundColor = [UIColor hexChangeFloat:KBlueColor];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *userName = [defaults objectForKey:@"login_User_name"];
    self.phoneField.text = userName;
    self.phoneField.textColor = [UIColor grayColor];
    
    //回收键盘
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(recycleKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}

#pragma mark 回收键盘
-(void)recycleKeyboard
{
    [self.view endEditing:YES];
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

    [self requestSendSMS];

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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)requestSendSMS
{
    NSDictionary *dict = @{@"phone":self.phoneField.text,
                           @"type":@"4"
                           };
    
    RequestInterface *requestOp = [[RequestInterface alloc] init];
    [requestOp requestRegisterSendSMSWithParam:dict];
    
    [self.view makeProgressViewWithTitle:ProgressString];
    [requestOp getInterfaceRequestObject:^(id data) {
        [ProjectUtil showLog:@"data = %@",data];
        [self.view hideProgressView];
        
        if ([data[@"success"] boolValue])
        {
            SetDrawalStep2ViewController *register2VC = [[SetDrawalStep2ViewController alloc]init];
            register2VC.title = @"设置提现密码（2/3）";
            register2VC.myPhoneNo = self.phoneField.text;
            register2VC.identityCode = data[@"datas"];
            [register2VC creatBackButtonWithPushType:Push With:@"安全" Action:nil];
            register2VC.isShowBank = self.isShowBank;
            [self.navigationController pushViewController:register2VC animated:YES];
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

@end
