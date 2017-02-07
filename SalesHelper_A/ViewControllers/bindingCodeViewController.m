//
//  bindingCodeViewController.m
//  SalesHelper_A
//
//  Created by flysss on 16/4/8.
//  Copyright © 2016年 X. All rights reserved.
//

#import "bindingCodeViewController.h"
#import "RegisterOrgCodeViewController.h"

@interface bindingCodeViewController ()

@property (nonatomic, strong)UITextField * bindingField;


@end

@implementation bindingCodeViewController
{
    UIButton * noCodeBtn;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
     [self layoutSubViews];
    
     [self requestOrgCodeState];
    
//    self.view.backgroundColor = [UIColor hexChangeFloat:@"f2f2f2"];
//    UILabel * navititleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
//    navititleLabel.backgroundColor = [UIColor clearColor];
//    navititleLabel.textColor = [UIColor whiteColor];
//    navititleLabel.text = @"绑定机构码";
//    navititleLabel.textAlignment = NSTextAlignmentCenter;
//    navititleLabel.font = Default_Font_18;
//    self.navigationItem.titleView = navititleLabel;
//    
//    UIButton* leftbtn=[UIButton buttonWithType:UIButtonTypeCustom];
//    leftbtn.frame=CGRectMake(0, 0, 26, 26);
//    [leftbtn setBackgroundImage:[UIImage imageNamed:@"首页-左箭头.png"] forState:UIControlStateNormal];
//    [leftbtn setBackgroundImage:[UIImage imageByApplyingAlpha:[UIImage imageNamed:@"首页-左箭头.png"]] forState:UIControlStateHighlighted];
//    
//    [leftbtn addTarget:self action:@selector(backlastView) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem* back=[[UIBarButtonItem alloc]initWithCustomView:leftbtn];
//    self.navigationItem.leftBarButtonItem=back;
    
    [self CreateCustomNavigtionBarWith:self leftItem:@selector(backlastView) rightItem:@selector(doneBtnAction)];
    //创建标题
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-120)/2, 27, 120, 30)];
    
    titleLabel.font = Default_Font_20;
    [titleLabel setTextColor:[UIColor whiteColor]];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.topView addSubview: titleLabel];
    

    self.bindingField = [[UITextField alloc]initWithFrame:CGRectMake(0, 64+40, SCREEN_WIDTH, 50)];
    self.bindingField.placeholder = @"请输入您要绑定的机构码";
    self.bindingField.font = Default_Font_15;
    self.bindingField.textColor = [UIColor hexChangeFloat:@"3e3a39"];
    self.bindingField.backgroundColor = [UIColor whiteColor];
    self.bindingField.leftViewMode = UITextFieldViewModeAlways;
    self.bindingField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 40)];
    [self.view addSubview:self.bindingField];
    
    if (![GetOrgType isEqualToString:@"1"])
    {
        self.bindingField.enabled = NO;
    }
//    UIButton * submitBtn = [[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-250)/2, 120, 250, 40)];
//    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
//    [submitBtn addTarget:self action:@selector(submitComplete:) forControlEvents:UIControlEventTouchUpInside];
//    submitBtn.layer.cornerRadius = 5.0f;
//    submitBtn.layer.masksToBounds = YES;
//    submitBtn.backgroundColor = [UIColor colorWithRed:0/255.0f green:175/255.0f blue:240/255.0f alpha:1];
//    [self.view addSubview:submitBtn];
    
 
    noCodeBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-130, CGRectGetMaxY(self.bindingField.frame)+30, 150, 25)];
    [noCodeBtn setTitle:@"没有机构码?" forState:UIControlStateNormal];
    noCodeBtn.titleLabel.font = Default_Font_15;
    [noCodeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [noCodeBtn addTarget:self action:@selector(goToApplyCode:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:noCodeBtn];
    
    if ([GetOrgType isEqualToString:@"1"])
    {
        titleLabel.text = @"绑定机构码";
        [self.rightBtn setTitle:@"完成" forState:UIControlStateNormal];
        
    }
    else if([GetOrgType isEqualToString:@"2"])
    {
        titleLabel.text = @"所属机构";
        self.rightBtn.frame = CGRectMake(SCREEN_WIDTH-70, 27, 60, 30);
        self.rightBtn.titleLabel.font = Default_Font_15;
        [self.rightBtn setTitle:@"申请解除" forState:UIControlStateNormal];
        self.bindingField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"orgName"];
        noCodeBtn.hidden = YES;
        
    }
    else if ([GetOrgType isEqualToString:@"3"])
    {
        self.rightBtn.hidden = YES;
        self.bindingField.placeholder = @"您的申请正在审核中，请耐心等待";
        self.bindingField.enabled = NO;
        titleLabel.text = @"审核中";
        noCodeBtn.hidden = YES;
    }
    
}

- (void)backlastView
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)layoutSubViews
{
    //回收键盘
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(recycleKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
//    UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    doneBtn.frame = CGRectMake(0, 0, 40, 30);
//    [doneBtn setTitle:@"完成" forState:UIControlStateNormal];
//    [doneBtn setTitleColor:NavigationBarTitleColor forState:UIControlStateNormal];
//    doneBtn.titleLabel.font = Default_Font_17;
//    [doneBtn addTarget: self action:@selector(doneBtnAction) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:doneBtn];
    
}
-(void)goToApplyCode:(UIButton *)sender
{
    RegisterOrgCodeViewController * VC = [[RegisterOrgCodeViewController alloc]init];
    VC.hidesBottomBarWhenPushed = YES;
    VC.phone = [[NSUserDefaults standardUserDefaults] valueForKey:@"Login_User_Account"];
    VC.realName = @"";
    VC.isBinding = YES;
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark 绑定机构码
- (void)doneBtnAction
{
    [self recycleKeyboard];
    if ([GetOrgType isEqualToString:@"1"])
    {
       
     if (self.bindingField.text.length == 8)
      {
      NSDictionary * dic = @{
                                @"token":GetUserID,
                                @"orgCode":self.bindingField.text,
                            };
      RequestInterface * request = [[RequestInterface alloc]init];
      [request requestOrgCodeWithParam:dic];
      [request getInterfaceRequestObject:^(id data) {
                    
        if ([[data objectForKey:@"success"] boolValue])
        {
            [self.view makeToast:data[@"message"] duration:0.5 position:@"center"];
            
            NSLog(@"%@",data);
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [self.view Loading_0314];
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                [self.view Hidden];
                                
                                NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
                                
                                [defaults setObject:[NSString stringWithFormat:@"%@",[data[@"datas"] objectForKey:@"orgtype"]] forKey:@"orgType"];
                                [defaults setObject:[data objectForKey:@"orgName"] forKey:@"orgName"];
                                [defaults setObject:self.bindingField.text forKey:@"orgCode"];
                                
                                [defaults synchronize];
                                
                                [[NSNotificationCenter defaultCenter] postNotificationName:@"bindingOrgCode" object:nil];
                                
                                [self.navigationController popViewControllerAnimated:YES];
                            });
                        });
            
                    }else{
                        [self.view makeToast:[data objectForKey:@"message"] duration:0.2 position:@"center"];
                    }
                } Fail:^(NSError *error) {
                    [self.view makeToast:@"网络错误" duration:0.2 position:@"center"];
                }];
            }
            else
            {
                [self.view makeToast:@"机构码不正确" duration:0.8 position:@"center"];
            }
    }
    else if([GetOrgType isEqualToString:@"2"])
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"温馨提示"] message:@"解除绑定后，您的客户数据将不可见。\n确定要解绑该机构吗?" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        alert.tag = 110;
        alert.delegate = self;
        [alert show];
    }
}
#pragma mark --解绑
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 110)
    {
        if (buttonIndex == 0)
        {
            NSDictionary * dic = @{
                                   @"token":self.login_user_token,
                                   @"orgCode":@"",
                                   };
            
            RequestInterface * request = [[RequestInterface alloc]init];
            [request requestOrgCodeWithParam:dic];
            [self.view Loading_0314];
            [request getInterfaceRequestObject:^(id data) {
                [self.view Hidden];
                if ([[data objectForKey:@"success"] boolValue])
                {
                    [self.view makeToast:[NSString stringWithFormat:@"%@",data[@"message"]]];
//                    NSLog(@"%@",data);
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        
                        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
                        [defaults setObject:[NSString stringWithFormat:@"%@",[data[@"datas"] objectForKey:@"orgtype"]] forKey:@"orgType"];
                        [defaults removeObjectForKey:@"orgCode"];
                        [defaults removeObjectForKey:@"orgName"];
                        [defaults synchronize];
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"bindingOrgCodeRelease" object:nil];
                        
                        [self.navigationController popViewControllerAnimated:YES];
     
                    });
                }
                else
                {
                    [self.view makeToast:[data objectForKey:@"message"] duration:0.2 position:@"center"];
                }
            } Fail:^(NSError *error) {
                [self.view makeToast:@"网络错误" duration:0.2 position:@"center"];
            }];
            
        }
    }
}



#pragma mark 回收键盘
-(void)recycleKeyboard
{
    [self.view endEditing:YES];
}
#pragma mark UItextFieldDelegate  点击键盘上的 完成按钮
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}



@end
