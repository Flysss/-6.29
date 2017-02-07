//
//  SetViewController.m
//  SalesHelper_A
//
//  Created by ZhipuTech on 15/6/15.
//  Copyright (c) 2015年 X. All rights reserved.
//

#import "SetViewController.h"
#import "APService.h"
#import "CommonProblemViewController.h"
#import "AboutSalesHelperViewController.h"
//#import "LoginAndRegisterViewController.h"
//#import "LoginViewController.h"

//#import "CoreLocationViewController.h"
#import "SDImageCache.h"
#import "MobClick.h"
#import <RongIMKit/RongIMKit.h>


@interface SetViewController () <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@end

@implementation SetViewController
{
    UISwitch * pushSwitch;
    UISwitch * loadImageSwitch;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self CreateCustomNavigtionBarWith:self leftItem:@selector(backlastView) rightItem:nil];
    //创建标题
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-120)/2, 27, 120, 30)];
    titleLabel.text = @"设置";
    titleLabel.font = Default_Font_20;
    [titleLabel setTextColor:[UIColor whiteColor]];
    //    [titleLabel sizeToFit];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.topView addSubview: titleLabel];
    
    
}
-(void)backlastView
{
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==2) {
        return 20;
    }if (section==0) {
        return 15;
    }return 5;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 3;
    }
    if (section == 1) {
        return 3;
    }
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = nil;
    NSString * cellInditify = [NSString stringWithFormat:@"cell%ld%ld",(long)indexPath.section,(long)indexPath.row];
    
    cell = [tableView dequeueReusableCellWithIdentifier:cellInditify];
    if (indexPath.row == 0 && indexPath.section == 0) {
        pushSwitch = (UISwitch *)[cell viewWithTag:1024];
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        BOOL isOn = [[defaults objectForKey:@"jpushSwitch"] boolValue];
        if ([defaults objectForKey:@"jpushSwitch"]) {
            if (isOn) {
                pushSwitch.on = YES;
                [[UIApplication sharedApplication] unregisterForRemoteNotifications];
                NSNumber * isOpen = [NSNumber numberWithBool:YES];
                NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:isOpen forKey:@"jpushSwitch"];
            }else
            {
                pushSwitch.on = NO;
                
                [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                               UIUserNotificationTypeSound |
                                                               UIUserNotificationTypeAlert) categories:nil];
                NSNumber * isOpen = [NSNumber numberWithBool:NO];
                NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:isOpen forKey:@"jpushSwitch"];
            }
        }else
        {
            NSNumber * isOpen = [NSNumber numberWithBool:YES];
            NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:isOpen forKey:@"jpushSwitch"];
            pushSwitch.on = YES;
        }
        
    }
    if (indexPath.row == 1 && indexPath.section == 0) {
        loadImageSwitch = (UISwitch *)[cell viewWithTag:1025];
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        BOOL isOn = [[defaults objectForKey:@"loadImageSwitch"] boolValue];
        if ([defaults objectForKey:@"loadImageSwitch"]) {
            if (isOn) {
                loadImageSwitch.on = YES;
                NSNumber * isOpen = [NSNumber numberWithBool:YES];
                NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:isOpen forKey:@"loadImageSwitch"];
            }else
            {
                loadImageSwitch.on = NO;
                NSNumber * isOpen = [NSNumber numberWithBool:NO];
                NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:isOpen forKey:@"loadImageSwitch"];
            }
        }else
        {
            NSNumber * isOpen = [NSNumber numberWithBool:NO];
            NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:isOpen forKey:@"loadImageSwitch"];
            loadImageSwitch.on = NO;
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *backTitle = @"设置";

    if (indexPath.section==1) {
        if (indexPath.row==0) {
            //常见问题
            NSString *commonStr;
            
            if ([self netWorkReachable] == NotReachable) {
                NSString *path = [[NSBundle mainBundle] pathForResource:@"cjwt" ofType:@"html"];
                NSURL *pathUrl = [NSURL fileURLWithPath:path];
                commonStr = [[pathUrl absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            }
            else
            {
                commonStr = @"http://sys.xiaobang.cc/Home/Article/syscontent/id/1.html";
            }
            
            CommonProblemViewController *commonVC = [[CommonProblemViewController alloc] initWithUrlString:commonStr NavigationTitle:@"常见问题"];
            commonVC.navigationController.navigationBar.tintColor = [UIColor yellowColor];
            [commonVC.navigationController.navigationBar setTitleTextAttributes:
             
               @{NSFontAttributeName:[UIFont systemFontOfSize:18],
             
                 NSForegroundColorAttributeName:[UIColor redColor]}];

            [commonVC creatBackButtonWithPushType:Push With:backTitle Action:nil];
            [self.navigationController pushViewController:commonVC animated:YES];
        }
        if (indexPath.row==1)
        {
            //新手必读
            NSString *commonStr = @"http://sys.xiaobang.cc/Home/Article/syscontent/id/6.html";
            CommonProblemViewController *commonVC = [[CommonProblemViewController alloc] initWithUrlString:commonStr NavigationTitle:@"新手必读"];
           // [commonVC creatBackButtonWithPushType:Push With:backTitle Action:nil];
           [self.navigationController pushViewController:commonVC animated:YES];
        }
        if (indexPath.row==2)
        {
            AboutSalesHelperViewController *aboutVC = [[AboutSalesHelperViewController alloc] init];
            aboutVC.title = @"关于销邦";
            [aboutVC creatBackButtonWithPushType:Push With:backTitle Action:nil];
            [self.navigationController pushViewController:aboutVC animated:YES];
        }

    }if (indexPath.section==2) {
        //退出
        [self clickLoginOutBtn];
    }
    if (indexPath.section==0&&indexPath.row==2) {
        
        [self.view Loading_0314];
        dispatch_async(
                       dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
                       , ^{
                           NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0];
                           
                           NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
                           NSLog(@"files :%lu",(unsigned long)[files count]);
                           for (NSString *p in files) {
                               NSError *error;
                               NSString *path = [cachPath stringByAppendingPathComponent:p];
                               if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                                   [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
                               }
                           }
                           [self performSelectorOnMainThread:@selector(clearCacheSuccess) withObject:nil waitUntilDone:YES];
                       });
    }
    
}
-(void)clearCacheSuccess
{
    [self.view Hidden];
    [self.view makeToast:@"清理成功"];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIEdgeInsets inset = UIEdgeInsetsMake(0, 15, 0, 0);
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:inset];
    }
    
    
    if (IOS_VERSION >= 8.0) {
        if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)])
        {
            [cell setPreservesSuperviewLayoutMargins:NO];
        }
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:inset];
        }
    }
    
}
- (void)clickLoginOutBtn
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"确定要退出登录吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag = 1000;
    [alertView show];
}

#pragma mark --退出登录
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1000) {
        if (buttonIndex == 1) {
            
            [self.view Loading_0314];
            NSDictionary *dict = @{@"token":self.login_user_token
                                   };
            
            RequestInterface *requestOp = [[RequestInterface alloc] init];
            [requestOp requestLogOutWithParam:dict];
            [requestOp getInterfaceRequestObject:^(id data) {
                
                [self.view Hidden];
                NSLog(@"data = %@",data);
//                [[SDImageCache sharedImageCache]clearDisk];
//                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Login_User_token"];
                
                if ([[data objectForKey:@"success"] boolValue])
                {
                    [MobClick profileSignOff];
                    [[SDImageCache sharedImageCache] clearDisk];
                 
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Login_User_token"];
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"loginuid"];
                    //融云登出
                    [[RCIM sharedRCIM] logout];

//                    NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
//                    [userInfo setObject:nil forKey:@"Login_User_token"];
//                    [userInfo synchronize];
                    
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Login_User_token"];
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"loginuid"];
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"orgName"];
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"orgCode"];
                    
                    NSNotification *nitifi = [NSNotification notificationWithName:@"quitSuccess" object:nil];
                    [[NSNotificationCenter defaultCenter] postNotification:nitifi];
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        
                        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
                       // NSLog(@"%@",self.navigationController.viewControllers);
                        
                    });
                }
                else
                {
                    [self.view makeToast:data[@"error_remark"]];
                }
                
            } Fail:^(NSError *error) {
                [self.view hideProgressView];
                [self.view makeToast:HintWithNetError];
                
            }];
            
//            UINavigationController *loginVC = [[UINavigationController alloc] initWithRootViewController:[[LoginViewController alloc]init]];
//            [self presentViewController:loginVC animated:NO completion:nil];
        }
    }

    [self.view hideProgressView];

}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

//推送 是否推送
- (IBAction)JPushClick:(UISwitch *)sender {
    if (sender.isOn) {
        [[UIApplication sharedApplication] unregisterForRemoteNotifications];
        NSNumber * isOpen = [NSNumber numberWithBool:YES];
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:isOpen forKey:@"jpushSwitch"];
        
        
    } else
    {
        [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                       UIUserNotificationTypeSound |
                                                       UIUserNotificationTypeAlert) categories:nil];
        NSNumber * isOpen = [NSNumber numberWithBool:NO];
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:isOpen forKey:@"jpushSwitch"];
 
    }
}

//仅从Wi-Fi 网络下载图片
- (IBAction)downLoadImage:(UISwitch *)sender {
    if (sender.isOn) {
        NSNumber * isOpen = [NSNumber numberWithBool:YES];
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:isOpen forKey:@"loadImageSwitch"];
    } else
    {
        NSNumber * isOpen = [NSNumber numberWithBool:NO];
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:isOpen forKey:@"loadImageSwitch"];
    }
}

@end
