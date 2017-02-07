//
//  ApplyOrgCodeViewController.m
//  SalesHelper_A
//
//  Created by flysss on 16/3/18.
//  Copyright © 2016年 X. All rights reserved.
//

#import "ApplyOrgCodeViewController.h"
#import "APService.h"
#import "MobClick.h"
#import "ModelWebViewController.h"
#import "RegisterOrgCodeViewController.h"
#import "IQKeyboardManager.h"
#import <RongIMKit/RongIMKit.h>
#import "AFHTTPRequestOperationManager.h"

@interface ApplyOrgCodeViewController ()<UITextFieldDelegate,UITextFieldDelegate,RCIMUserInfoDataSource>

@end

@implementation ApplyOrgCodeViewController
{
    //真实姓名
    UITextField * formalNameTextField;
    
    //机构码
    UITextField * orgCodeTextField;
    //联系人
    UITextField * linkManTextfield;
    //联系电话
    UITextField * linkManPhoneTextfield;
    //机构名
    UITextField * orgNameTextField;
    //所属公司
    UITextField * companyTextField;
    
    //没有机构码
    UIButton* noCodeBtn;
    
    //注册
    UIButton *  registerBtn;
}
//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    self.navigationController.navigationBarHidden = YES;
//}
-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor hexChangeFloat:@"f1f1f1"];
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;
//    [self CreateCustomNavigtionBarWith:self leftItem:@selector(backlastView) rightItem:nil];
//    //创建标题
//    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-120)/2, 27, 120, 30)];
//    titleLabel.text = @"绑定机构码";
//    titleLabel.font = Default_Font_20;
//    [titleLabel setTextColor:[UIColor whiteColor]];
//    //    [titleLabel sizeToFit];
//    titleLabel.textAlignment = NSTextAlignmentCenter;
//    [self.topView addSubview: titleLabel];
    

    UILabel * navititleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    navititleLabel.backgroundColor = [UIColor clearColor];
    navititleLabel.textColor = [UIColor whiteColor];
    navititleLabel.text = @"绑定机构码";
    navititleLabel.textAlignment = NSTextAlignmentCenter;
    navititleLabel.font = Default_Font_16;
    self.navigationItem.titleView = navititleLabel;
    
    UIButton* leftbtn=[UIButton buttonWithType:UIButtonTypeCustom];
    leftbtn.frame=CGRectMake(0, 0, 26, 26);
    [leftbtn setBackgroundImage:[UIImage imageNamed:@"首页-左箭头.png"] forState:UIControlStateNormal];
    [leftbtn setBackgroundImage:[UIImage imageByApplyingAlpha:[UIImage imageNamed:@"首页-左箭头.png"]] forState:UIControlStateHighlighted];
    
    [leftbtn addTarget:self action:@selector(backlastView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* back=[[UIBarButtonItem alloc]initWithCustomView:leftbtn];
    self.navigationItem.leftBarButtonItem=back;
    
    [self createSubviews];
}
- (void)backlastView
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)createSubviews
{
    
    formalNameTextField = [[UITextField alloc]initWithFrame:CGRectMake(0,44, SCREEN_WIDTH, 44)];
    formalNameTextField.placeholder = @"  真实姓名:";
    formalNameTextField.borderStyle =  UITextBorderStyleNone;
    formalNameTextField.backgroundColor = [UIColor whiteColor];
    formalNameTextField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 44)];
    formalNameTextField.font = Default_Font_16;
    formalNameTextField.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:formalNameTextField];
    
    orgCodeTextField = [[UITextField alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(formalNameTextField.frame), SCREEN_WIDTH, 44)];
    orgCodeTextField.placeholder = @"  机构码:";
    orgCodeTextField.backgroundColor = [UIColor whiteColor];
    orgCodeTextField.borderStyle =  UITextBorderStyleNone;
    orgCodeTextField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 44)];
    orgCodeTextField.leftViewMode = UITextFieldViewModeAlways;
    orgCodeTextField.font = Default_Font_16;
    [self.view addSubview:orgCodeTextField];
    
    UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 43.5, SCREEN_WIDTH, 0.5)];
    line1.backgroundColor = [UIColor hexChangeFloat:KHuiseColor];
    line1.alpha = 0.5;
    [self.view addSubview:line1];
    UIView * line2 = [[UIView alloc]initWithFrame:CGRectMake(20,87.5, SCREEN_WIDTH, 0.5)];
    line2.backgroundColor = [UIColor hexChangeFloat:KHuiseColor];
    line2.alpha = 0.5;
    [self.view addSubview:line2];
//    UIView * line3 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(formalNameTextField.frame)+10-0.5, SCREEN_WIDTH, 0.5)];
//    line3.backgroundColor = [UIColor hexChangeFloat:KHuiseColor];
//    line3.alpha = 0.5;
//    [self.view addSubview:line3];
    UIView * line4 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(formalNameTextField.frame)+44-0.5, SCREEN_WIDTH, 0.5)];
    line4.backgroundColor = [UIColor hexChangeFloat:KHuiseColor];
    line4.alpha = 0.5;
    [self.view addSubview:line4];

    
    noCodeBtn = [[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-150)/2, CGRectGetMaxY(formalNameTextField.frame)+70, 150, 25)];
    [noCodeBtn setTitle:@"没有机构码?" forState:UIControlStateNormal];
    noCodeBtn.titleLabel.font = Default_Font_15;
    [noCodeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [noCodeBtn addTarget:self action:@selector(goToApplyCode:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:noCodeBtn];
    
//    linkManTextfield = [[UITextField alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(noCodeBtn.frame)+10 , SCREEN_WIDTH, 40)];
//    linkManTextfield.placeholder = @"  联系人:";
//    linkManTextfield.hidden = YES;
//    linkManTextfield.backgroundColor = [UIColor whiteColor];
//    linkManTextfield.borderStyle = UITextBorderStyleRoundedRect;
//    [self.view addSubview:linkManTextfield];
//    
//    linkManPhoneTextfield = [[UITextField alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(linkManTextfield.frame)+10, SCREEN_WIDTH, 40)];
//    linkManPhoneTextfield.placeholder =@"  联系人电话:";
//    linkManPhoneTextfield.hidden = YES;
//    linkManPhoneTextfield.backgroundColor = [UIColor whiteColor];
//    linkManPhoneTextfield.borderStyle = UITextBorderStyleRoundedRect;
//    [self.view addSubview:linkManPhoneTextfield];
//    
//    orgNameTextField = [[UITextField alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(formalNameTextField.frame)+10, SCREEN_WIDTH, 40)];
//    orgNameTextField.placeholder = @"  机构名:";
//    orgNameTextField.hidden = YES;
//    orgNameTextField.backgroundColor =[UIColor whiteColor];
//    orgNameTextField.borderStyle = UITextBorderStyleRoundedRect;
//    [self.view addSubview:orgNameTextField];
//    
//    companyTextField = [[UITextField alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(linkManPhoneTextfield.frame)+10, SCREEN_WIDTH, 40)];
//    companyTextField.placeholder = @"  所属公司:(选填)";
//    companyTextField.hidden = YES;
//    companyTextField.backgroundColor = [UIColor whiteColor];
//    companyTextField.borderStyle = UITextBorderStyleRoundedRect;
//    [self.view addSubview:companyTextField];
    
    registerBtn = [[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-300)/2,CGRectGetMaxY(noCodeBtn.frame)+30, 300, 40)];
    [registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [registerBtn setTitle:@"提交" forState:UIControlStateNormal];
    registerBtn.backgroundColor = [UIColor colorWithRed:0/255.0f green:175/255.0f blue:240/255.0f alpha:1];
    registerBtn.layer.cornerRadius = 5.0f;
    registerBtn.layer.masksToBounds = YES;
    [registerBtn addTarget:self action:@selector(goToRegister:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerBtn];
    
}

-(void)goToApplyCode:(UIButton*)sender
{
//    orgCodeTextField.hidden = YES;
//    linkManTextfield.hidden = NO;
//    linkManPhoneTextfield.hidden = NO;
//    orgNameTextField.hidden = NO;
//    companyTextField.hidden = NO;
//    registerBtn.frame = CGRectMake((SCREEN_WIDTH-300)/2,CGRectGetMaxY(companyTextField.frame)+10, 300, 40);
//    ModelWebViewController * web = [[ModelWebViewController alloc]initWithUrlString:[NSString stringWithFormat:@"http://192.168.1.166:8080/SalesServers1_2/reg.jsp?userphone=%@&realname=%@",self.phoneNum,formalNameTextField.text] NavigationTitle:@"申请机构码"];
//    web.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:web animated:YES];
    
    RegisterOrgCodeViewController * VC = [[RegisterOrgCodeViewController alloc]init];
    VC.hidesBottomBarWhenPushed = YES;
    VC.phone = self.phoneNum;
    VC.passWordNum = self.passWord;
    VC.isBinding = NO;
    VC.realName = formalNameTextField.text;
    [self.navigationController pushViewController:VC animated:YES];
}

//提交机构码
-(void)goToRegister:(UIButton*)sender
{
    
    if (formalNameTextField.text.length == 0 || formalNameTextField.text.length >=6)
    {
        [self.view makeToast:@"姓名输入有误"];
        return;
    }
    if (orgCodeTextField.text.length == 0 || orgCodeTextField.text.length >= 8) {
//        [self.view makeToast:@"机构码输入错误"];
    }
    [self.view endEditing:YES];
    NSDictionary* dict = @{@"userphone":self.phoneNum,
                           @"name":formalNameTextField.text,
                           @"orgcode":orgCodeTextField.text
                           };
    RequestInterface *registerOp = [[RequestInterface alloc] init];
    [registerOp  requestRefereeBindName:dict];
    [registerOp getInterfaceRequestObject:^(id data) {
        [self.view hideProgressView];
         if ([[data objectForKey:@"success"] boolValue])
         {
             [self.view makeToast:data[@"message"]];
             [self requestLogin];
             
         }else
         {
             [self.view makeToast:data[@"message"]];
         }
    } Fail:^(NSError *error) {
        
//        [self.view makeToast:data[@"message"]];
    }];
//    NSDictionary *dict = @{@"userName":self.phoneNum,
//                           @"send_time":@"",
//                           @"pwd":self.passWord,
//                         @"submit_time":@"",
//                         @"identity":@"0",
//                         @"code":@"",
//                           @"orgCode":orgCodeTextField.text,
//                         @"city":[[NSUserDefaults standardUserDefaults] objectForKey:@"Login_User_currentLocationCity"],
//                           @"name":formalNameTextField.text,
//                           @"orgmname":linkManTextfield.text,
//                           @"phone":linkManPhoneTextfield.text,
//                           @"gongsiname":companyTextField.text,
//                           @"jigouname":orgNameTextField.text,
//                           };
//                            [self.view makeProgressViewWithTitle:ProgressString];
//                               RequestInterface *registerOp = [[RequestInterface alloc] init];
//                               [registerOp requestRegisterWithParam:dict];
//                           
//                               [registerOp getInterfaceRequestObject:^(id data) {
//                                   [self.view hideProgressView];
//                                   if ([[data objectForKey:@"success"] boolValue]) {
//                                       [self.view makeToast:@"恭喜您,注册成功！正在为您登录中..." duration:0.8 position:@"center"];
//                                       dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                                           [self requestLogin];
//                                       });
//                                   }else {
//                                       [self.view makeToast:data[@"message"]];
//                                   }
//                                   
//                               } Fail:^(NSError *error) {
//                                   [self.view hideProgressView];
//                                   [self.view makeToast:HintWithNetError];
//                               }];
    
    
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (textField == linkManPhoneTextfield)
    {
        if (toBeString.length > 11)
        {
            textField.text = [toBeString substringToIndex:11];
            return NO;
        }
    }
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

//登录
- (void)requestLogin
{
    NSDictionary *dict = @{
                           @"userName":self.phoneNum,
                           @"userPwd":self.passWord,
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
            
            [MobClick profileSignInWithPUID:self.phoneNum];
            dispatch_async(dispatch_get_main_queue(), ^{
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                if ([data objectForKey:@"token"]) {
                    [defaults setObject:[data objectForKey:@"token"] forKey:@"Login_User_token"];//账户ID
                    
                }
                if ([[data objectForKey:@"datas"] objectForKey:@"recomdCode"] ) {
                    [defaults setObject:[[data objectForKey:@"datas"] objectForKey:@"recomdCode"] forKey:@"zhipu_recomd_code"];//邀请码
                }
                //登录的用户id
                if ([[data objectForKey:@"datas"] objectForKey:@"id"]) {
                    [defaults setObject:data[@"datas"][@"id"] forKey:@"loginuid"];
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
                if ([[data objectForKey:@"datas"]objectForKey:@"orgCode"] != [NSNull null] &&
                    [[data objectForKey:@"datas"]objectForKey:@"orgCode"] != nil)
                {
                    [defaults setObject:[[data objectForKey:@"datas"]objectForKey:@"orgCode"] forKey:@"orgCode"];
                }
                
                if (self.phoneNum)
                {
                    [defaults setObject:self.phoneNum forKey:@"Login_User_Account"];
                    
                }
                if ([[data objectForKey:@"datas"]objectForKey:@"face"]==[NSNull null]||[[data objectForKey:@"datas"]objectForKey:@"face"] == nil) {
//                    [defaults setObject:@"销邦-我的-头像.png"forKey:@"login_User_face"];//头像]
                    [defaults setObject:nil forKey:@"login_User_face"];//头像]
                }else{
                    [defaults setObject:[[data objectForKey:@"datas"] objectForKey:@"face"] forKey:@"login_User_face"];//头像
                }
                
                if (self.phoneNum) {
                    [defaults setObject:self.phoneNum forKey:@"login_User_name"];//用户名
                }
                [defaults synchronize];
                [ProjectUtil showLog:@"---------------------------------token:%@",data[@"token"]];
                
                [defaults setObject:[[data objectForKey:@"datas"] objectForKey:@"id"]  forKey:@"id"];
                //登录融云
                [self requestToken:[[data objectForKey:@"datas"] objectForKey:@"id"]];
                
                
                self.navigationController.navigationBarHidden = NO;
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            });
            
        }else {
            [self.view makeToast:data[@"message"]];
        }
        
    } Fail:^(NSError *error) {
        [self.view hideProgressView];
        [self.view makeToast:HintWithNetError];
    }];
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
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
                  
                  [[RCIM sharedRCIM] setUserInfoDataSource:self];
                  NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
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










@end
