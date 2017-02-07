//
//  ForgetPassStep2ViewController.m
//  SalesHelper_A
//
//  Created by summer on 14/12/19.
//  Copyright (c) 2014年 X. All rights reserved.
//

#import "ForgetPassStep2ViewController.h"
#import "ForgetPassStep3ViewController.h"

#define kTimeCount 60

@interface ForgetPassStep2ViewController ()
{
    NSTimer *_timer;
    NSInteger _timeCount;//验证码计时器
}

@end

@implementation ForgetPassStep2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _timeCount = kTimeCount;
    
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
    self.postIdentityCodeBtn.layer.cornerRadius = 20.0f;
   self.hintMessageLabel.text = [NSString stringWithFormat:@"短信验证码已向+86%@发送，请注意查收。",self.myPhoneNo];
    
    //回收键盘
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(recycleKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    UITapGestureRecognizer *timeTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(requestSendSMS:)];
    [self.reGetIdentityCodeLabel addGestureRecognizer:timeTap];
    //启动计时器
    [self startTimerCountAction];
}

- (void)viewDidDisappear:(BOOL)paramAnimated
{
    
    //清楚页面数据
    self.identityCodeField.text = StringEmpty;
    
    if (_timer) {
        if ([_timer respondsToSelector:@selector(isValid)]) {
            if ([_timer isValid]) {
                [self releaseTImer];
                _timer = nil;
            }
        }
    }
    
    [super viewDidDisappear:paramAnimated];
}

- (void)startTimerCountAction
{
    //启动倒计时
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
    self.reGetIdentityCodeLabel.backgroundColor = RGBCOLOR(189, 188, 192);
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
    if (self.identityCodeField == textField){  //判断是否时我们想要限定的那个输入框
        if ([toBeString length] > 4) { //如果输入框内容大于20则弹出警告
            textField.text = [toBeString substringToIndex:4];
            //            [self.view makeToast:@"超过最大字数(4位)不能输入了"];
            return NO;
        }
        
    }
    
    return YES;
}


#pragma mark 提交验证码
- (IBAction)postIdentityCodeAction:(id)sender
{
    [self recycleKeyboard];
    
    //转为小写判断是否相同
//    NSString *SMSString = [self.identityCodeField.text lowercaseString];
//    NSString *verifyString = [self.identityCode lowercaseString];
    
    if (self.identityCodeField.text.length == 0) {
        [self.view makeToast:@"请填入验证码"];
        return;
    }
    
    else if (![self.identityCodeField.text isEqualToString:self.identityCode]) {
        [self.view makeToast:@"请填入正确的验证码"];
        return;
    }else {
        ForgetPassStep3ViewController *forgetPassStep3VC = [[ForgetPassStep3ViewController alloc]init];
        if ([self.fromViewType isEqualToString:LOGIN_VC]) {
            forgetPassStep3VC.title = @"忘记密码（3/3）";
        }else if ([self.fromViewType isEqualToString:DRAWAL_VC]) {
            forgetPassStep3VC.title = @"忘记提现密码（3/3）";
        }else {
            forgetPassStep3VC.title = @"忘记密码（3/3）";
        }
        
        forgetPassStep3VC.myPhoneNo = self.myPhoneNo;
        forgetPassStep3VC.identityCode = self.identityCodeField.text;
        forgetPassStep3VC.fromViewType = self.fromViewType;
        [forgetPassStep3VC creatBackButtonWithPushType:Push With:@"返回" Action:nil];
        [self.navigationController pushViewController:forgetPassStep3VC animated:YES];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//倒计时方法验证码实现倒计时60秒，60秒后按钮变换开始的样子
-(void)timerFireMethod:(NSTimer *)theTimer {
    if (_timeCount == 1) {
        [self releaseTImer];
    }else{
        NSString *title = [NSString stringWithFormat:@" 重新获取（%ld）",(long)_timeCount];
        _timeCount--;
        
        self.reGetIdentityCodeLabel.text = title;
    }
}

//停止验证码的倒数，
- (void)releaseTImer {
    if (_timer) {
        if ([_timer respondsToSelector:@selector(isValid)]) {
            if ([_timer isValid]) {
                [_timer invalidate];

                _timeCount = kTimeCount;
                
                self.reGetIdentityCodeLabel.text = @"重新获取";
                self.reGetIdentityCodeLabel.textColor = [UIColor whiteColor];
                self.reGetIdentityCodeLabel.userInteractionEnabled = YES;
//                self.reGetIdentityCodeLabel.backgroundColor = LeftMenuVCBackColor;
                self.reGetIdentityCodeLabel.backgroundColor = [UIColor hexChangeFloat:KBlueColor];
            }
        }
    }
}

#pragma mark - request 服务器
//- (void)requestSendSMS:(UITapGestureRecognizer *)tap
//{
//    //启动计时器
//    [self startTimerCountAction];
//    
//    NSDictionary *dict = @{@"mobile":self.myPhoneNo,
//                           @"identity":@"0"
//                           };
//    
//    RequestInterface *requestOp = [[RequestInterface alloc] init];
//    [requestOp requestForgetpwdSendSMSWithParam:dict];
//    
//    [self.view makeProgressViewWithTitle:ProgressString];
//    [requestOp getInterfaceRequestObject:^(id data) {
//        [self.view hideProgressView];
//        [ProjectUtil showLog:@"data = %@",data];
//        if ([data[@"result"] isEqualToString:@"success"]) {
//            self.identityCode = data[@"request"];
//            tap.view.userInteractionEnabled = NO;
//        }else {
//            [self.view makeToast:data[@"error_remark"]];
//        }
//    } Fail:^(NSError *error) {
//        [self releaseTImer];
//        [self.view hideProgressView];
//        [self.view makeToast:HintWithNetError];
//    }];
//}
- (void)requestSendSMS:(UITapGestureRecognizer *)tap
{
    [self startTimerCountAction];

    NSDictionary *dict = @{@"userName":self.myPhoneNo,
                           //     @"identity":@"0" 0注册 1通知类 2 忘记密码 3:支付密码 4：提现密码
                           @"type":@"4"
                           };
    
    if ([self.fromViewType isEqualToString:DRAWAL_VC]){
        NSDictionary *dict = @{@"phone":self.myPhoneNo,
                               //     @"identity":@"0" 0注册 1通知类 2 忘记密码 3:支付密码 4：提现密码
                               @"type":@"4"
                               };
        RequestInterface *requestO = [[RequestInterface alloc] init];
        [requestO requestRegisterSendSMSWithParam:dict];
        [requestO getInterfaceRequestObject:^(id data) {
            if ([data[@"result"] isEqualToString:@"success"]) {
                self.identityCode = data[@"request"];
                tap.view.userInteractionEnabled = NO;
            }else {
                [self.view makeToast:data[@"error_remark"]];
            }

        } Fail:^(NSError *error) {
            [self releaseTImer];
            [self.view hideProgressView];
            [self.view makeToast:HintWithNetError];
        }];
        
        
    }else{
        RequestInterface *requestOp = [[RequestInterface alloc] init];
        [requestOp requestForgetpwdSendSMSWithParam:dict];
        [self.view makeProgressViewWithTitle:ProgressString];
        [requestOp getInterfaceRequestObject:^(id data) {
            if ([data[@"result"] isEqualToString:@"success"]) {
                self.identityCode = data[@"request"];
                tap.view.userInteractionEnabled = NO;
            }else {
                [self.view makeToast:data[@"error_remark"]];
            }
        } Fail:^(NSError *error) {
            [self releaseTImer];
            [self.view hideProgressView];
            [self.view makeToast:HintWithNetError];

        }];
    }
    
}

@end
