//
//  LoginViewController.m
//  SalesHelper_A
//
//  Created by summer on 14/12/18.
//  Copyright (c) 2014年 X. All rights reserved.
//

#import "LoginViewController.h"
#import "ForgetPassStep1ViewController.h"
#import "NewResignPerViewController.h"
#import "APService.h"
#import "MobClick.h"
#import "NewResignSubmitTableViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import <RongIMKit/RongIMKit.h>


@interface LoginViewController ()<UITextFieldDelegate,RCIMUserInfoDataSource>

@property (weak, nonatomic) IBOutlet UIButton *forgotPasWordLabel;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

@end

@implementation LoginViewController
{
    CGRect viewFrame;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layoutSubViews];
    
    self.forgotPasWordLabel.titleLabel.font = Default_Font_15;
    self.registerBtn.titleLabel.font = Default_Font_15;
    _loginBtn.titleLabel.font = Default_Font_17;
    
    [_loginBtn.layer setMasksToBounds:YES];
    [_loginBtn.layer setCornerRadius:8.0];
    
    self.navigationController.navigationBarHidden = YES;
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:21.0/255.0 green:159/255.0 blue:234/255.0 alpha:1]];
    
    [self updateHeadImage];
    [self.headimageview.layer setMasksToBounds:YES];
    [self.headimageview.layer setCornerRadius:40];
    
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillAppear:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillDisappear:) name:UIKeyboardWillHideNotification object:nil];
 
}
//-(CGFloat)keyboardEndingFrameHeight:(NSDictionary *)userInfo//计算键盘的高度
//{
//    CGRect keyboardEndingUncorrectedFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue];
//    CGRect keyboardEndingFrame = [self.view convertRect:keyboardEndingUncorrectedFrame fromView:nil];
//    return keyboardEndingFrame.size.height;
//}
//-(void)keyboardWillAppear:(NSNotification *)notification
//{
//    CGRect currentFrame = self.view.frame;
//    viewFrame = self.view.frame;
//    CGFloat change = [self keyboardEndingFrameHeight:[notification userInfo]];
//    if (change > self.view.frame.size.height / 2 - 30) {
//        currentFrame.origin.y = change - self.view.frame.size.height/2 - 30 ;
//    }
//    self.view.frame = currentFrame;
//}

//- (void)keyboardWillDisappear:(NSNotification *)notification
//{
//    self.view.frame = viewFrame;
//}


//更新用户头像
- (void)updateHeadImage
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",Image_Url,[defaults objectForKey:@"login_User_face"]];
    
    [self.headimageview sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"toux"]];
}



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setNeedsStatusBarAppearanceUpdate];
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"Login_User_Account"] != nil) {
        self.accountField.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"Login_User_Account"];
    }
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];

}

-(void)layoutSubViews
{
//定制控件样式
    self.loginBtn.layer.cornerRadius = 20.0;

    self.passField.keyboardType = UIKeyboardAppearanceAlert;
    
    //回收键盘
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(recycleKeyboard)];
    [self.view addGestureRecognizer:tap];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

//退出登录，返回上一个进入登录之前的页面
- (IBAction)BackLastView:(id)sender {
    
//    if (self.delegate) {
//        [self.navigationController popViewControllerAnimated:NO];
//    }
    [self.view endEditing:YES];
//    [self.view hud];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self.view Hidden];
    
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
//        [self presentToMainViewController:YES];
//    });
}


#pragma mark 回收键盘
-(void)recycleKeyboard
{
    [self.view endEditing:YES];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
    if (textField == self.accountField) {
        if ([toBeString length] > 11) { //如果输入框内容大于16则弹出警告
            textField.text = [toBeString substringToIndex:11];
                    [self.view makeToast:@"超过最大字数(16位)不能输入了"];
            return NO;
        }
    }else if (textField == self.passField) {
        if ([toBeString length] > 16) { //如果输入框内容大于16则弹出警告
            textField.text = [toBeString substringToIndex:16];
            //        [self.view makeToast:@"超过最大字数(16位)不能输入了"];
            return NO;
        }
    }
    
    
    return YES;
}

#pragma mark 登录

- (IBAction)loginAction:(id)sender
{
    [self.view endEditing:YES];
    
    if (![ProjectUtil isFuzzyPhone:self.accountField.text])
    {
        [self.view makeToast:@"请输入正确的手机号码"];
        return;
    }
    else if (self.passField.text.length < 6 || self.passField.text.length >16) {
        [self.view makeToast:@"密码格式为6—16位字符"];
        return;
    }
    else
    {
        [self requestLogin];
    }
}

- (void)presentToMainViewControllers
{
    [super presentToMainViewController:NO];
}
#pragma mark 忘记密码
- (IBAction)forgetPassAction:(id)sender
{
    self.navigationController.navigationBarHidden = NO;
    ForgetPassStep1ViewController *forgetPassStep1VC = [[ForgetPassStep1ViewController alloc]init];
    forgetPassStep1VC.title = @"忘记密码（1/3）";
    forgetPassStep1VC.fromViewType = LOGIN_VC;
    [forgetPassStep1VC creatBackButtonWithPushType:Push With:@"返回" Action:nil];
    [self.navigationController pushViewController:forgetPassStep1VC animated:YES];
}

#pragma mark 注册用户
- (IBAction)registerAction:(id)sender
{
//    self.navigationController.navigationBarHidden = NO;
//    NewResignPerViewController *vc = [[NewResignPerViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
    
    
    
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"resignView" bundle:nil];
    NewResignSubmitTableViewController  * resign = [storyboard instantiateViewControllerWithIdentifier:@"NewResignSubmitTableViewController"];
    resign.personal = NO;
    [self.navigationController pushViewController:resign animated:YES];
}

#pragma mark UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (void)requestLogin
{
    NSDictionary *dict = @{@"userName":self.accountField.text,
                           @"userPwd":self.passField.text,
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
        if ([[data objectForKey:@"success"] boolValue])
        {
            
            [MobClick profileSignInWithPUID:self.accountField.text];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                //登陆的tokenID
                if ([data objectForKey:@"token"])
                {
                    [defaults setObject:[data objectForKey:@"token"] forKey:@"Login_User_token"];//账户ID
                }
                //登录的用户id
                if ([[data objectForKey:@"datas"] objectForKey:@"id"]) {
                    [defaults setObject:data[@"datas"][@"id"] forKey:@"loginuid"];
                }
                //邀请码
                if ([[data objectForKey:@"datas"] objectForKey:@"recomdCode"] )
                {
                    [defaults setObject:data[@"datas"][@"recomdCode"] forKey:@"zhipu_recomd_code"];//邀请码
                }
                
                //用户名称
                if ([[data objectForKey:@"datas"]objectForKey:@"name"] == [NSNull null] ||
                    [[data objectForKey:@"datas"]objectForKey:@"name"] ==
                    nil)
                {
                    
                }
                else
                {
                    [defaults setObject:[[data objectForKey:@"datas"]objectForKey:@"name"] forKey:@"name"];
                }
                
                //性别
                if ([[data objectForKey:@"datas"]objectForKey:@"sex"])
                {
                    [defaults setObject:[[data objectForKey:@"datas"]objectForKey:@"sex"] forKey:@"sex"];
                }
                
                //判断机构类型
                if ([[data objectForKey:@"datas"] objectForKey:@"orgType"])
                {
                    NSString * str = [NSString stringWithFormat:@"%@",[[data objectForKey:@"datas"] objectForKey:@"orgType"]];
                    [defaults setObject:str forKey:@"orgType"];
                }
                
                //机构名称
                if ([[data objectForKey:@"datas"]objectForKey:@"orgName"])
                {
                    [defaults setObject:data[@"datas"][@"orgName"] forKey:@"orgName"];
                }
                //                绑定的机构码
                if (data[@"datas"][@"orgCode"] != [NSNull null])
                {
                    if ([data[@"datas"][@"orgCode"] length] != 0)
                    {
                        [defaults setObject:data[@"datas"][@"orgCode"] forKey:@"orgCode"];

                    }
                    else
                    {
                        [defaults setObject:nil forKey:@"orgCode"];

                    }
                }
                else
                {
                     [defaults setObject:nil forKey:@"orgCode"];
                }
                
                if (self.accountField.text) {
                    [defaults setObject:self.accountField.text forKey:@"Login_User_Account"];
                    
                }
                if (self.accountField.text) {
                    [defaults setObject:self.accountField.text forKey:@"Login_User_Account"];
                    
                }
                
                if ([[data objectForKey:@"datas"]objectForKey:@"face"]==[NSNull null]||[[data objectForKey:@"datas"]objectForKey:@"face"]==nil)
                {
//                    [defaults setObject:@"销邦-我的-头像.png"forKey:@"login_User_face"];//头像]
                    [defaults setObject:nil forKey:@"login_User_face"];
                }
                else
                {
                    [defaults setObject:[[data objectForKey:@"datas"] objectForKey:@"face"] forKey:@"login_User_face"];//头像
                }
                
                if (_accountField.text) {
                    [defaults setObject:_accountField.text forKey:@"login_User_name"];//用户名
                }
                [defaults synchronize];
                [ProjectUtil showLog:@"---------------------------------token:%@",data[@"token"]];
                
                [defaults setObject:[[data objectForKey:@"datas"] objectForKey:@"id"]  forKey:@"id"];
                //登录融云
                [self requestToken:[[data objectForKey:@"datas"] objectForKey:@"id"]];
                
                self.navigationController.navigationBarHidden = NO;
                
                //跳转界面
//                if (self.delegate)
//                {
//                    [self.delegate sendRequestWithToken:[data objectForKey:@"token"]];
//                    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
//                }
//                else
//                {
//                    [self presentToMainViewController:NO];
//
//                }
                
                
                
                NSNotification *nitifi = [NSNotification notificationWithName:@"refreshClient" object:nil];
                [[NSNotificationCenter defaultCenter] postNotification:nitifi];
                
         //修改后，
#pragma mark --登陆成功后，修改跳转界面
                if (self.delegate && [self.delegate respondsToSelector:@selector(sendRequestWithToken:)])
                {
                    [self.delegate sendRequestWithToken:[data objectForKey:@"token"]];
                }
                
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];

            });
          
        }
        else
        {
            [self.view makeToast:data[@"message"]];
        }
        
    } Fail:^(NSError *error)
    {
        [self.view hideProgressView];
        [self.view makeToast:HintWithNetError];
    }];
}

#pragma mark - 融云Token
- (void)requestToken:(NSString *)longinuid
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *parame = [NSMutableDictionary dictionary];
    parame[@"loginuid"] = longinuid;
    NSString *url = [NSString stringWithFormat:@"%@/index.php/Apis/Forum/getTokenid/",BANGHUI_URL];
    [manager POST:url parameters:parame
          success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if ([responseObject[@"success"] boolValue] == YES)
         {
             NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
             [defaults setObject:responseObject[@"datas"] forKey:@"RCIMToken"];
             [[RCIM sharedRCIM] connectWithToken:responseObject[@"datas"] success:^(NSString *userId)
              {
                  NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
                    [[RCIM sharedRCIM] setUserInfoDataSource:self];
              } error:^(RCConnectErrorCode status)
              {
                  NSLog(@"登陆的错误码为:%ld", (long)status);
              } tokenIncorrect:^{
                  NSLog(@"token错误");
              }];
             
         }
         else
         {
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
         NSString *token = [defaults objectForKey:@"RCIMToken"];
         [[RCIM sharedRCIM] connectWithToken:token success:^(NSString *userId)
          {
              
              [[RCIM sharedRCIM] setUserInfoDataSource:self];
              NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
          } error:^(RCConnectErrorCode status)
          {
              NSLog(@"登陆的错误码为:%ld", (long)status);
          } tokenIncorrect:^{
              NSLog(@"token错误");
          }];

     }];
    
}

- (void)getUserInfoWithUserId:(NSString *)userId
                   completion:(void (^)(RCUserInfo *userInfo))completion
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    RequestInterface *interface = [[RequestInterface alloc]init];
    NSDictionary *dic = @{
                          @"getuid":userId,
                          @"loginuid":[defaults objectForKey:@"id"]
                          };
    [interface requestBHPersonalCenterWithDic:dic];
    [interface getInterfaceRequestObject:^(id data)
     {
         
         
         if ([data[@"success"] boolValue] == YES)
         {
             
             NSDictionary *dict = data[@"datas"];
             
             RCUserInfo *userInfo = [[RCUserInfo alloc] init];
             
             userInfo.userId = userId;
             
             userInfo.name = dict[@"name"];
             
             userInfo.portraitUri = dict[@"iconPath"];
             
             return completion(userInfo);
             
             
             
             
             
             
         }
     } Fail:^(NSError *error)
     {
         
     }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.[ProjectUtil changeToStringToMd5String:self.passField.text]
}

@end
