//
//  PublicNoticeWebViewController.m
//  SalesHelper_A
//
//  Created by zhipu on 15/1/9.
//  Copyright (c) 2015年 X. All rights reserved.
//

#import "PublicNoticeWebViewController.h"
//#import "LoginAndRegisterView#Controller.h"
#import "LoginViewController.h"

@interface PublicNoticeWebViewController ()

@end

@implementation PublicNoticeWebViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;

}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)presentViewControllerWithDefault
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults boolForKey:@"SalesHelper_AdvertView"]) {
        if ([[NSUserDefaults standardUserDefaults] valueForKey:@"Login_User_token"] != nil) {
            [self presentToMainViewController:YES];
        }
        else
        {
            UINavigationController *mainNaVC = [[UINavigationController alloc] initWithRootViewController:[[LoginViewController alloc]init]];
            [self presentViewController:mainNaVC animated:YES completion:nil];
//            LoginAndRegisterViewController *vc = [[LoginAndRegisterViewController alloc] init];
//            [self presentViewController:vc animated:YES completion:nil];
        }
        
    }else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    //存数据--->基本数据类型
    [defaults setBool:NO forKey:@"SalesHelper_publicNotice"];//存在公告内容
    [defaults setBool:NO forKey:@"SalesHelper_AdvertView"];//由广告页过来
    [defaults synchronize];
    
    
}

@end
