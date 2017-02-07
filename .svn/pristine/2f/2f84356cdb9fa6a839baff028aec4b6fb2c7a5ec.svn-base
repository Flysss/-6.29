//
//  InviteMakeMoneyViewController.m
//  SalesHelper_A
//
//  Created by summer on 14/12/20.
//  Copyright (c) 2014年 X. All rights reserved.
//

#import "InviteMakeMoneyViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>

#define CONTENT_URL @"http://d.xiaobang.cc"

@interface InviteMakeMoneyViewController ()

@end

@implementation InviteMakeMoneyViewController


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:[self imageWithBgColor:[UIColor colorWithRed:23/255.0f green:183/255.0f blue:242/255.0f alpha:1]] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[self imageWithBgColor:[UIColor colorWithRed:23/255.0f green:183/255.0f blue:242/255.0f alpha:1]]];
    
}
#pragma mark  绘制图片
-(UIImage *)imageWithBgColor:(UIColor *)color {
    
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self.view setBackgroundColor:[UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:1]];
//    
//    self.view.window.backgroundColor=[UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:1];
//    self.view.backgroundColor=[UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:1];
//    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
     NSString *inviteCodeStr = [NSString stringWithFormat:@"我的邀请码   %@",[userDefaults objectForKey:@"zhipu_recomd_code"]];
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc]initWithString:inviteCodeStr];
    [attributeStr addAttributes:[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:20] forKey:NSFontAttributeName] range:NSMakeRange(0, 7)];
    [attributeStr addAttributes:[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:30] forKey:NSFontAttributeName] range:NSMakeRange(8, inviteCodeStr.length-8)];
    
   // [self.inviteCodeLabel setBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:233.0/255.0 alpha:1]];
    [self.inviteCodeLabel setTextColor:[UIColor colorWithRed:91.0/255.0 green:84.0/255.0 blue:77.0/255.0 alpha:1]];

    self.inviteCodeLabel.attributedText = attributeStr;
   
    
    //右边的分享
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"首页-分享@x" ofType:@"png"];
//    UIImage *image = [UIImage imageWithContentsOfFile:path];
    
    UIImage* image=[UIImage imageNamed:@"首页-分享"];
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0,0,27,27)];
    [rightButton setImage:image forState:UIControlStateNormal];
    [rightButton setImage:[UIImage imageByApplyingAlpha:image] forState:UIControlStateHighlighted];

    [rightButton addTarget:self action:@selector(shareRealestateClickHandler:)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = leftItem;
    
    UIButton* btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake(0, 0, 26, 26);
    [btn setBackgroundImage:[UIImage imageNamed:@"首页-左箭头.png"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageByApplyingAlpha:[UIImage imageNamed:@"首页-左箭头.png"]] forState:UIControlStateHighlighted];

    [btn addTarget:self action:@selector(backlastView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* BACK=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=BACK;
    
     [self.view setBackgroundColor:[UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:1]];
    
}
-(void)backlastView
{
    [self.navigationController popViewControllerAnimated:YES];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ShareSDK
- (void)shareRealestateClickHandler:(id)sender
{
//    NSString *imagePath = [[NSBundle mainBundle] pathForResource:IMAGE_NAME ofType:IMAGE_EXT];
    
    NSString *content_sms = [NSString stringWithFormat:@"（销邦）这是我的专用邀请码%@，成功下载填写邀请码，即得100元。地址:%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"zhipu_recomd_code"],CONTENT_URL];
    
    NSArray *imageArray = @[[UIImage imageNamed:IMAGE_NAME]];
    //1、创建分享参数
            if (imageArray) {
    
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:content_sms
                                     images:imageArray
                                        url:[NSURL URLWithString:CONTENT_URL]
                                      title:CONTENT_TITLE
                                       type:SSDKContentTypeAuto];
    //2、分享（可以弹出我们的分享菜单和编辑界面）
    [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                             items:nil
                       shareParams:shareParams
               onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                   
                   switch (state) {
                       case SSDKResponseStateSuccess:
                       {
                           UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                               message:nil
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"确定"
                                                                     otherButtonTitles:nil];
                           [alertView show];
                           break;
                       }
                       case SSDKResponseStateFail:
                       {
                           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                           message:[NSString stringWithFormat:@"%@",error]
                                                                          delegate:nil
                                                                 cancelButtonTitle:@"OK"
                                                                 otherButtonTitles:nil, nil];
                           NSLog(@"----%@",error);
                           [alert show];
                           break;
                       }
                       default:
                           break;
                   }
               }
     ];
        }

}

//- (void)viewOnWillDisplay:(UIViewController *)viewController shareType:(ShareType)shareType
//{
//    if (IOS_VERSION >= 7.0)
//    {
//        viewController.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.000 green:0.573 blue:0.821 alpha:1.000];
//    }else{
//        viewController.navigationController.navigationBar.tintColor = LeftMenuVCBackColor;
//        
//    }

//     [self.view setBackgroundColor:[UIColor colorWithRed:258.0/255.0 green:238.0/255.0 blue:218.0/255.0 alpha:1]];
//}


@end
