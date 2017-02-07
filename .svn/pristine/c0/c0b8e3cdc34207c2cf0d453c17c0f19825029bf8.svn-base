//
//  NewResignSubmitTableViewController.m
//  SalesHelper_A
//
//  Created by summer on 15/10/10.
//  Copyright © 2015年 X. All rights reserved.
//
#define kTimeCount 60

#import "NewResignSubmitTableViewController.h"
#import "DeHighlightedTableViewCell.h"
#import "APService.h"
#import "MobClick.h"
#import "LoginViewController.h"
#import "IQKeyboardManager.h"
//申请邀请码
#import "ApplyOrgCodeViewController.h"
#import "ModelWebViewController.h"


@interface NewResignSubmitTableViewController ()<UITextFieldDelegate>
@property (nonatomic,strong)UITextField * myPhoneTextfield;//电话号码
@property (weak, nonatomic) IBOutlet UIButton *RegisterButton;


@end

@implementation NewResignSubmitTableViewController
{
    __weak IBOutlet UILabel *titleLabel;
    UILabel * timeLabel;
    NSTimer *_timer;
    NSInteger _timeCount;//验证码计时器
    NSString * identityCode ;//验证码
    UITextField * codeTextfield;//验证码
    UITextField * passworldTextfield;
    UITextField * checkPassworldTextfield;
    //机构码
    UITextField * invitedTextField;
    UIButton * sendSMS;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _timeCount = 60;
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;

    UILabel * navititleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    navititleLabel.backgroundColor = [UIColor clearColor];
    navititleLabel.textColor = [UIColor whiteColor];
    navititleLabel.text = @"注册";
    navititleLabel.textAlignment = NSTextAlignmentCenter;
    navititleLabel.font = Default_Font_18;
    self.navigationItem.titleView = navititleLabel;

    UIButton* leftbtn=[UIButton buttonWithType:UIButtonTypeCustom];
    leftbtn.frame=CGRectMake(0, 0, 26, 26);
    [leftbtn setBackgroundImage:[UIImage imageNamed:@"首页-左箭头.png"] forState:UIControlStateNormal];
    [leftbtn setBackgroundImage:[UIImage imageByApplyingAlpha:[UIImage imageNamed:@"首页-左箭头.png"]] forState:UIControlStateHighlighted];
    
    [leftbtn addTarget:self action:@selector(backlastView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* back=[[UIBarButtonItem alloc]initWithCustomView:leftbtn];
    self.navigationItem.leftBarButtonItem=back;
    
    
    
    
    self.RegisterButton.backgroundColor = [UIColor colorWithRed:0/255.0f green:175/255.0f blue:240/255.0f alpha:1];
    self.RegisterButton.layer.cornerRadius = 5;
    self.RegisterButton.layer.masksToBounds = YES;
    sendSMS.backgroundColor = [UIColor colorWithRed:0/255.0f green:175/255.0f blue:240/255.0f alpha:1];
    
//    timeLabel.backgroundColor= [UIColor colorWithRed:0/255.0f green:175/255.0f blue:240/255.0f alpha:1];
}
- (void)backlastView
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)startTimerCountAction
{
    //启动倒计时
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
    timeLabel.backgroundColor = RGBCOLOR(189, 188, 192);
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (IBAction)pushForLogin:(id)sender {
//    LoginViewController * login = [[LoginViewController alloc]init];
//    [self.navigationController pushViewController:login animated:YES];
//}

- (void)requestSendSMS
{
    if (!_myPhoneTextfield.text)
    {
        [self.view makeToast:@"手机号码不能为空"];
        return;
    }else if (![ProjectUtil isFuzzyPhone:_myPhoneTextfield.text]) {
        [self.view makeToast:@"请输入正确的手机号码"];
        return;
    }
    
    titleLabel.text = [NSString stringWithFormat:@"验证码已发送至%@,请注意查收",_myPhoneTextfield.text];
    [sendSMS setBackgroundColor:[UIColor lightGrayColor]];
    sendSMS.enabled = NO;

    NSDictionary *dict = @{@"phone":_myPhoneTextfield.text,
                           //     @"identity":@"0" 0注册 1通知类 2 忘记密码 3:支付密码 4：提现密码
                           @"type":@"0"
                           };
    RequestInterface *requestO = [[RequestInterface alloc] init];
    [requestO requestRegisterSendSMSWithParam:dict];
    [requestO getInterfaceRequestObject:^(id data) {
        if ([data[@"success"] boolValue]) {
            identityCode = data[@"datas"];
            NSLog(@"%@",data);
            [self startTimerCountAction];

        }else {
            [self.view makeToast:data[@"message"]];
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
        titleLabel.text = [NSString stringWithFormat:@"验证码已发送至%@,请注意查收",_myPhoneTextfield.text];

    }else{
        NSString *title = [NSString stringWithFormat:@" 重新获取（%ld）",(long)_timeCount];
        _timeCount--;
        titleLabel.text = [NSString stringWithFormat:@"验证码已发送至%@,%@",_myPhoneTextfield.text,title];
    }
}

//停止验证码的倒数，
- (void)releaseTImer {
    if (_timer) {
        if ([_timer respondsToSelector:@selector(isValid)]) {
            if ([_timer isValid]) {
                [_timer invalidate];
                
                _timeCount = kTimeCount;
                sendSMS.backgroundColor = [UIColor colorWithRed:0/255.0f green:175/255.0f blue:240/255.0f alpha:1];
                sendSMS.enabled = YES;
            }
        }
    }
}


#pragma mark --点击注册
- (IBAction)requestReg:(id)sender
{
    [self requestRegister];
}

- (void)requestRegister
{

#if  0
//    NSDictionary * dict = @{
//                            @"userName":_myPhoneTextfield.text,
//                            @"smsCode":codeTextfield.text
//                            };
//    RequestInterface * request = [[RequestInterface alloc] init];
//    [request requestVertifyCodeWith:dict];
//    [request getInterfaceRequestObject:^(id data) {
////        NSLog(@"%@",data);
//        if ([data[@"success"] boolValue])
//        {
//            
//            ApplyOrgCodeViewController * VC = [[ApplyOrgCodeViewController alloc]init];
//            VC.hidesBottomBarWhenPushed = YES;
//            VC.phoneNum = _myPhoneTextfield.text;
//            VC.passWord = passworldTextfield.text;
//            [self.navigationController pushViewController:VC animated:YES];
//    
//        }else
//        {
//            [self.view makeToast:data[@"message"] duration:1.0 position:@"center"];
//        }
//        
//    } Fail:^(NSError *error) {
//        [self.view hideProgressView];
//        [self.view makeToast:HintWithNetError];
//    }];
    
    ApplyOrgCodeViewController * VC = [[ApplyOrgCodeViewController alloc]init];
    VC.hidesBottomBarWhenPushed = YES;
    VC.phoneNum = _myPhoneTextfield.text;
    VC.passWord = passworldTextfield.text;
    [self.navigationController pushViewController:VC animated:YES];

    
#else

    if (codeTextfield.text.length == 0 || codeTextfield.text.length != 4) {
        [self.view makeToast:@"验证码输入有误"];
        return;
    }
    
    if (passworldTextfield.text.length == 0) {
        [self.view makeToast:@"请输入您的密码"];
        return;
    }
    if (checkPassworldTextfield.text.length == 0) {
        [self.view makeToast:@"请再次输入密码"];
        return;
    }
    
    if (passworldTextfield.text.length < 6 || passworldTextfield.text.length >16) {
        [self.view makeToast:@"密码格式为6—16位字符"];
        return;
    }
    if (![passworldTextfield.text isEqualToString: checkPassworldTextfield.text]) {
        [self.view makeToast:@"二次输入的密码不一致"];
        return;
    }
    if (!self.agreeBtn.selected)
    {
        [self.view makeToast:@"请先阅读并同意注册协议"];
        return;
    }
   
    
    [self.view endEditing:YES];
    
    NSDictionary *dict = @{@"userName":_myPhoneTextfield.text,
                           @"smsCode":codeTextfield.text,
                           @"send_time":@"",
                           @"pwd":passworldTextfield.text,
                           @"submit_time":@"",
                           @"identity":@"0",
                           @"code":@"",
                           @"orgCode":@"",
                           @"city":[[NSUserDefaults standardUserDefaults] objectForKey:@"Login_User_currentLocationCity"]
                           };
    
    [self.view makeProgressViewWithTitle:ProgressString];
    RequestInterface *registerOp = [[RequestInterface alloc] init];
    [registerOp requestRegisterWithParam:dict];

    [registerOp getInterfaceRequestObject:^(id data) {
        [self.view hideProgressView];
        NSLog(@"data = %@",data);
        if ([[data objectForKey:@"success"] boolValue])
        {
            [self.view makeToast:@"恭喜您,注册成功！" duration:0.8 position:@"center"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [self requestLogin];
                [[NSUserDefaults  standardUserDefaults] setObject:_myPhoneTextfield.text forKey:@"phoneNumber"];
                [[NSUserDefaults  standardUserDefaults] setObject:passworldTextfield.text forKey:@"passWordNumber"];
                [[NSUserDefaults  standardUserDefaults] synchronize];
                
                ApplyOrgCodeViewController * VC = [[ApplyOrgCodeViewController alloc]init];
                VC.hidesBottomBarWhenPushed = YES;
                VC.phoneNum = _myPhoneTextfield.text;
                VC.passWord = passworldTextfield.text;
                [self.navigationController pushViewController:VC animated:YES];
            });
        }else {
            [self.view makeToast:data[@"message"] duration:1.0 position:@"center"];
        }
    } Fail:^(NSError *error) {
        [self.view hideProgressView];
        [self.view makeToast:HintWithNetError];
    }];
#endif
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DeHighlightedTableViewCell *cell = (DeHighlightedTableViewCell *)[tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"cell0%ld",(long)indexPath.row] forIndexPath:indexPath];
    
    if (indexPath.row == 0) {
        UITextField * myphoneText = (UITextField *)[cell viewWithTag:1111];
        _myPhoneTextfield = myphoneText;
        _myPhoneTextfield.delegate = self;
        UIButton * codebtn = (UIButton *)[cell viewWithTag:120];
        [codebtn addTarget:self action:@selector(requestSendSMS) forControlEvents:UIControlEventTouchUpInside];
        sendSMS = codebtn;
        sendSMS.backgroundColor = [UIColor colorWithRed:0/255.0f green:175/255.0f blue:240/255.0f alpha:1];
        sendSMS.layer.masksToBounds = YES;
        sendSMS.layer.cornerRadius = 3;
    }
    if (indexPath.row == 1) {
        UITextField * codeText = (UITextField *)[cell viewWithTag:1001];
        codeTextfield = codeText;
        codeTextfield.delegate = self;
    }
    
    if (indexPath.row == 2) {
        UITextField * passwordText = (UITextField *)[cell viewWithTag:1002];
        passworldTextfield = passwordText;
    }
    if (indexPath.row == 3) {
        UITextField * passwordText = (UITextField *)[cell viewWithTag:1006];
        checkPassworldTextfield = passwordText;
    }
    
//    if (indexPath.row == 4) {
//        UITextField * invitedCodeText = (UITextField *)[cell viewWithTag:1003];
//        invitedTextField = invitedCodeText;
//        invitedTextField.delegate = self;
//        if (!self.isPersonal) {
//            invitedCodeText.placeholder = @"机构码";
//        }
//
//    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    for (UITextField * text in cell.contentView.subviews) {
        [text becomeFirstResponder];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 49;
}

- (void)requestLogin
{
    NSDictionary *dict = @{
                           @"userName":_myPhoneTextfield.text,
                           @"userPwd":checkPassworldTextfield.text,
                           @"registrationID":[APService registrationID],
                           @"loginOrigin":CGLOBAL_LOGIN_ORIGIN,
                           @"versionCode":[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"],
                           };
    
    [self.view makeProgressViewWithTitle:@"正在登录"];
    RequestInterface *requestOp = [[RequestInterface alloc] init];
    [requestOp requestLoginWithParam:dict];
    
    [requestOp getInterfaceRequestObject:^(id data) {
        [ProjectUtil showLog:@"data = %@",data];
        
        [self.view hideProgressView];
        if ([[data objectForKey:@"success"] boolValue]) {
            
            [MobClick profileSignInWithPUID:_myPhoneTextfield.text];
            dispatch_async(dispatch_get_main_queue(), ^{
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                if ([data objectForKey:@"token"]) {
                    [defaults setObject:[data objectForKey:@"token"] forKey:@"Login_User_token"];//账户ID
                    
                }
                if ([[data objectForKey:@"datas"] objectForKey:@"recomdCode"] ) {
                    [defaults setObject:[[data objectForKey:@"datas"] objectForKey:@"recomdCode"] forKey:@"zhipu_recomd_code"];//邀请码
                }
                
                if ([[data objectForKey:@"datas"]objectForKey:@"name"]==[NSNull null]||[[data objectForKey:@"datas"]objectForKey:@"name"]==nil) {
                    
                    
                }else{
                    
                    [defaults setObject:[[data objectForKey:@"datas"]objectForKey:@"name"] forKey:@"name"];
                }
                
                
                if ([[data objectForKey:@"datas"]objectForKey:@"sex"]) {
                    [defaults setObject:[[data objectForKey:@"datas"]objectForKey:@"sex"] forKey:@"sex"];
                }
                
                if ([[data objectForKey:@"datas"]objectForKey:@"orgType"]) {
                    [defaults setObject:[[data objectForKey:@"datas"]objectForKey:@"orgType"] forKey:@"orgType"];
                }
                
                if ([[data objectForKey:@"datas"]objectForKey:@"orgName"]) {
                    [defaults setObject:[[data objectForKey:@"datas"]objectForKey:@"orgName"] forKey:@"orgName"];
                }
                if ([[data objectForKey:@"datas"]objectForKey:@"orgCode"] != [NSNull null] && [[data objectForKey:@"datas"]objectForKey:@"orgCode"] != nil) {
                    [defaults setObject:[[data objectForKey:@"datas"]objectForKey:@"orgCode"] forKey:@"orgCode"];
                }
                
                if (_myPhoneTextfield.text) {
                    [defaults setObject:_myPhoneTextfield.text forKey:@"Login_User_Account"];
                    
                }
                
                if ([[data objectForKey:@"datas"]objectForKey:@"face"]==[NSNull null]||[[data objectForKey:@"datas"]objectForKey:@"face"]==nil) {
//                    [defaults setObject:@"销邦-我的-头像.png"forKey:@"login_User_face"];//头像]
                    [defaults setObject:nil forKey:@"login_User_face"];
                }else{
                    [defaults setObject:[[data objectForKey:@"datas"] objectForKey:@"face"] forKey:@"login_User_face"];//头像
                }
                
                if (_myPhoneTextfield.text) {
                    [defaults setObject:_myPhoneTextfield.text forKey:@"login_User_name"];//用户名
                }
                [defaults synchronize];
                [ProjectUtil showLog:@"---------------------------------token:%@",data[@"token"]];
                
                [defaults setObject:[[data objectForKey:@"datas"] objectForKey:@"id"]  forKey:@"id"];
                
                self.navigationController.navigationBarHidden = NO;
                //跳转界面
                UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                UITabBarController * tabVC = [storyboard instantiateViewControllerWithIdentifier:@"mainTBC"];
                UITabBar * tabBar = tabVC.tabBar;
                tabBar.tintColor = [UIColor colorWithRed:0.082 green:0.467 blue:0.862 alpha:1.000];
                
                
                UITabBarItem * homeItem = tabBar.items[0];
                homeItem.image = [[UIImage imageNamed:@"首页-默认.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                homeItem.selectedImage = [[UIImage imageNamed:@"首页-选中.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                
                
                UITabBarItem * clientItem = tabBar.items[1];
                clientItem.image = [[UIImage imageNamed:@"客户-默认.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                clientItem.selectedImage = [[UIImage imageNamed:@"客户-选中.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                
                
                UITabBarItem * phoneItem = tabBar.items[2];
                phoneItem.image = [[UIImage imageNamed:@"发现-默认.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                phoneItem.selectedImage = [[UIImage imageNamed:@"发现-选中.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                
                UITabBarItem * myItem = tabBar.items[3];
                myItem.image = [[UIImage imageNamed:@"我的-默认.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                myItem.selectedImage = [[UIImage imageNamed:@"我的-选中.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                
                [[UIApplication sharedApplication].keyWindow setRootViewController:tabVC];
            });
            
        }else {
            [self.view makeToast:data[@"message"]];
        }
        
    } Fail:^(NSError *error) {
        [self.view hideProgressView];
        [self.view makeToast:HintWithNetError];
    }];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
//    if (textField == _myPhoneTextfield) {
//        if (string.length == 0) return YES;
//        
//        NSInteger existedLength = textField.text.length;
//        NSInteger selectedLength = range.length;
//        NSInteger replaceLength = string.length;
//        if (existedLength - selectedLength + replaceLength > 11) {
//            return NO;
//        }
//    }
//    
//    if (textField ==  invitedTextField) {
//        if (string.length == 0) return YES;
//        
//        NSInteger existedLength = textField.text.length;
//        NSInteger selectedLength = range.length;
//        NSInteger replaceLength = string.length;
//        if (existedLength - selectedLength + replaceLength > 8) {
//            return NO;
//        }
//    }
//    
//    if (textField ==  codeTextfield) {
//        if (string.length == 0) return YES;
//        
//        NSInteger existedLength = textField.text.length;
//        NSInteger selectedLength = range.length;
//        NSInteger replaceLength = string.length;
//        if (existedLength - selectedLength + replaceLength > 4) {
//            return NO;
//        }
    
        NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
        if (textField == _myPhoneTextfield) {
            if ([toBeString length] > 11) { //如果输入框内容大于16则弹出警告
                textField.text = [toBeString substringToIndex:11];
                //        [self.view makeToast:@"超过最大字数(16位)不能输入了"];
                return NO;
            }
        }
        if (textField == invitedTextField) {
            if ([toBeString length] > 8) { //如果输入框内容大于16则弹出警告
                textField.text = [toBeString substringToIndex:8];
            //        [self.view makeToast:@"超过最大字数(16位)不能输入了"];
                return NO;
            }
        }
        if (textField == codeTextfield) {
            if ([toBeString length] > 4) { //如果输入框内容大于16则弹出警告
                textField.text = [toBeString substringToIndex:4];
                return NO;
            }
        }
    return YES;

}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


- (IBAction)agreeRegisterProtocal:(UIButton *)sender
{
    sender.selected = ! sender.selected;
//    UIGestureRecognizer
}

- (IBAction)checkRegisterProtocal:(UIButton *)sender
{
    
    ModelWebViewController * vc = [[ModelWebViewController alloc]initWithUrlString:@"http://app.xiaobang.cc/Home/Article/syscontent/id/5.html" NavigationTitle:@"注册协议"];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}





/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
