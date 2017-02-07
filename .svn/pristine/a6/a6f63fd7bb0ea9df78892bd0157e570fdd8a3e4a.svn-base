//
//  AdvertWebViewController.m
//  SalesHelper_A
//
//  Created by zhipu on 14/11/17.
//  Copyright (c) 2014年 zhipu. All rights reserved.
//

#import "AdvertWebViewController.h"
#import "UIWebView+RemoveShadow.h"
#import "UIImage+Alpha.h"
//#import "LoginAndRegisterViewController.h"
#import "LoginViewController.h"


@interface AdvertWebViewController ()

@end

@implementation AdvertWebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    UIButton* btn=[UIButton buttonWithType:UIButtonTypeCustom];
//    btn.frame=CGRectMake(0, 0, 26, 26);
//    [btn setBackgroundImage:[UIImage imageNamed:@"首页-左箭头.png"] forState:UIControlStateNormal];
//    [btn setBackgroundImage:[UIImage imageByApplyingAlpha:[UIImage imageNamed:@"首页-左箭头.png"]] forState:UIControlStateHighlighted];
//    [btn addTarget:self action:@selector(clickBackBtn:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem* BACK=[[UIBarButtonItem alloc]initWithCustomView:btn];
//    self.navigationItem.leftBarButtonItem=BACK;
    
    [self CreateCustomNavigtionBarWith:self leftItem:@selector(clickBackBtn:) rightItem:@selector(refreshAction)];
    [self.rightBtn setImage:[UIImage imageNamed:@"销邦-发现-分享赚钱-刷新"] forState:UIControlStateNormal];
    [self.rightBtn setImage:[UIImage imageByApplyingAlpha:[UIImage imageNamed:@"销邦-发现-分享赚钱-刷新"]] forState:UIControlStateHighlighted];
    self.rightBtn.width = 26;
    self.rightBtn.height = 26;
    self.rightBtn.x = SCREEN_WIDTH - 40;
    self.rightBtn.y = 27;
    //创建标题
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-120)/2, 27, 120, 30)];
    
    titleLabel.font = Default_Font_20;
    [titleLabel setTextColor:[UIColor whiteColor]];
    //    [titleLabel sizeToFit];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.topView addSubview: titleLabel];
    titleLabel.text = @"活动信息";
}
//刷新   销邦-发现-分享赚钱-刷新@x.png   refresh
-(void)refreshAction
{
    
    [self refreshBtnAction];
}

- (void)clickBackBtn:(id)sender
{
    [ProjectUtil showLog:@"Login_User_token= %@ ",[[NSUserDefaults standardUserDefaults] valueForKey:@"Login_User_token"]];
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"Login_User_token"] != nil) {
        [self presentToMainViewController:YES];
    }
    else
    {
        //更新登录状态
        UINavigationController *mainNaVC = [[UINavigationController alloc] initWithRootViewController:[[LoginViewController alloc]init]];
        [self presentViewController:mainNaVC animated:YES completion:nil];
//        LoginAndRegisterViewController *vc = [[LoginAndRegisterViewController alloc] init];
//        [self presentViewController:vc animated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
