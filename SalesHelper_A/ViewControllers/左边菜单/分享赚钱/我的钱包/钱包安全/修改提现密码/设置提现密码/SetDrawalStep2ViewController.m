//
//  SetDrawalStep2ViewController.m
//  SalesHelper_A
//
//  Created by summer on 14/12/18.
//  Copyright (c) 2014年 X. All rights reserved.
//

#import "SetDrawalStep2ViewController.h"
#import "SetDrawalStep3ViewController.h"

#define kTimeCount 60

@interface SetDrawalStep2ViewController ()
{
    NSTimer *_timer;
    NSInteger _timeCount;//验证码计时器
}

@end

@implementation SetDrawalStep2ViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)backToView
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self CreateCustomNavigtionBarWith:self leftItem:@selector(backToView) rightItem:nil];
    //创建标题
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-200)/2, 27, 200, 30)];
    titleLabel.text = @"设置提现密码(2/3)";
    titleLabel.font = Default_Font_20;
    [titleLabel setTextColor:[UIColor whiteColor]];
    //    [titleLabel sizeToFit];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.topView addSubview: titleLabel];
    _timeCount = kTimeCount;
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:21.0/255.0 green:159/255.0 blue:234/255.0 alpha:1]];
    [self layoutSubViews];
}

-(void)layoutSubViews
{
    //定制控件样式
    self.postIdentityCodeBtn.layer.cornerRadius = 20.0f;
    self.postIdentityCodeBtn.backgroundColor = [UIColor hexChangeFloat:KBlueColor];
    
    self.hintLabel.text = [NSString stringWithFormat:@"短信验证码已向+86%@发送，请注意查收。",self.myPhoneNo];
    
    //回收键盘
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(recycleKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    UITapGestureRecognizer *timeTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(requestSendSMS:)];
    [self.getIdentityCodeLabel addGestureRecognizer:timeTap];
    //启动计时器
    [self startTimerCountAction];
}

- (void)viewDidDisappear:(BOOL)paramAnimated
{
    [self.view endEditing:YES];
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
    self.getIdentityCodeLabel.backgroundColor = RGBCOLOR(189, 188, 192);
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
    [self.identityCodeField resignFirstResponder];
    //转为小写判断是否相同
//    NSString *SMSString = [self.identityCodeField.text lowercaseString];
//    NSString *verifyString = [self.identityCode lowercaseString];
    
    if (self.identityCodeField.text.length == 0) {
        [self.view makeToast:@"请填入验证码"];
        return;
    }else if (![self.identityCodeField.text isEqualToString:self.identityCode]) {
        [self.view makeToast:@"请填入正确的验证码"];
        return;
    }else {
        SetDrawalStep3ViewController *register3VC = [[SetDrawalStep3ViewController alloc]init];
        register3VC.title = @"设置提现密码（3/3）";
        register3VC.myPhoneNo = self.myPhoneNo;
        register3VC.identityCode = self.identityCodeField.text;
        [register3VC creatBackButtonWithPushType:Push With:@"安全" Action:nil];
        register3VC.isShowBank = self.isShowBank;
        [self.navigationController pushViewController:register3VC animated:YES];
    }

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestSendSMS:(UITapGestureRecognizer *)tap
{
    //启动计时器
    [self startTimerCountAction];
    
    NSDictionary *dict = @{@"phone":self.myPhoneNo== nil?@"":self.myPhoneNo,
                           @"identity":@"0"
                           };
    
    RequestInterface *sendOp = [[RequestInterface alloc] init];
    [sendOp requestForgetpwdSendSMSWithParam:dict];
    
    [self.view makeProgressViewWithTitle:ProgressString];
    [sendOp getInterfaceRequestObject:^(id data) {
        [self.view hideProgressView];
        [ProjectUtil showLog:@"data = %@",data];
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

//倒计时方法验证码实现倒计时60秒，60秒后按钮变换开始的样子
-(void)timerFireMethod:(NSTimer *)theTimer {
    if (_timeCount == 1) {
        [self releaseTImer];
    }else{
        NSString *title = [NSString stringWithFormat:@" 重新获取(%ld)",(long)_timeCount];
        _timeCount--;
        
        self.getIdentityCodeLabel.text = title;
    }
}

//停止验证码的倒数，
- (void)releaseTImer {
    if (_timer) {
        if ([_timer respondsToSelector:@selector(isValid)]) {
            if ([_timer isValid]) {
                [_timer invalidate];

                _timeCount = kTimeCount;
                
                self.getIdentityCodeLabel.text = @"重新获取";
                self.getIdentityCodeLabel.textColor = [UIColor whiteColor];
                self.getIdentityCodeLabel.userInteractionEnabled = YES;
//                self.getIdentityCodeLabel.backgroundColor = LeftMenuVCBackColor;
                self.getIdentityCodeLabel.backgroundColor = [UIColor hexChangeFloat:KBlueColor];
            }
        }
    }
}

@end
