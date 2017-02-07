//
//  AdvertViewController.m
//  SalesHelper_A
//
//  Created by zhipu on 14/11/17.
//  Copyright (c) 2014年 zhipu. All rights reserved.
//

#import "AdvertViewController.h"
//#import "LoginViewController.h"
#import "AdvertWebViewController.h"
#import "sys/utsname.h"


@interface AdvertViewController ()
{
    NSTimer *timer;
    int timerSeconds;
    NSString *_imageURL;
    NSString *_advertURL;
}

@property (nonatomic, strong) UIImageView *advertImageView;

@end

@implementation AdvertViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = YES;
    
    _advertURL = @"";
    timerSeconds = 5;
    
    _advertImageView = [[UIImageView alloc] init];
    _advertImageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, [UIScreen mainScreen].bounds.size.height - 105);
    UIView * holdView = [[UIView alloc]initWithFrame: CGRectMake(0, _advertImageView.bottom, [UIScreen mainScreen].bounds.size.height, 105)];
    UIImageView * image = [[UIImageView alloc]initWithFrame:CGRectMake(17, 38, 260, 37)];
    image.image = [UIImage imageNamed:@"启动页字体.png"];
    [holdView addSubview:image];
    [self.view addSubview:holdView];
    
    _advertImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapImage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAdvertView)];
    tapImage.cancelsTouchesInView = NO;
    [_advertImageView addGestureRecognizer:tapImage];
    
    [self.view addSubview:_advertImageView];
    
    [self requestAdvert];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //存数据--->基本数据类型
    [defaults setBool:YES forKey:@"SalesHelper_AdvertView"];//存在公告内容
    [defaults synchronize];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    
    [self releaseNowTimer];
    
    if (_imageURL != nil) {
        [[SDImageCache sharedImageCache]removeImageForKey:_imageURL fromDisk:YES];
    }
    
    [super viewWillDisappear:animated];
}


//进入app应用
-(void)enterAppAction:(id)sender
{
    [ProjectUtil showLog:@"Login_User_token= %@ ",[[NSUserDefaults standardUserDefaults] valueForKey:@"Login_User_token"]];
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //判断是否登录过
    if(![defaults boolForKey:@"SalesHelper_publicNotice"])
    {
        if ([defaults valueForKey:@"Login_User_token"] != nil)
        {
            [self presentToMainViewController:YES];
        }
        else
        {

           [self presentToMainViewController:YES];
        }
        
        //存数据--->基本数据类型
        [defaults setBool:NO forKey:@"SalesHelper_publicNotice"];//存在公告内容
        [defaults setBool:NO forKey:@"SalesHelper_AdvertView"];//存在公告内容
        [defaults synchronize];
    }
    
    [ProjectUtil showLog:@"更新Rootviewcontroller"];
}

//图片地址查询
- (void)requestAdvert
{
    
    NSDictionary *dict = @{@"type":@""};
    RequestInterface *requestMOp = [[RequestInterface alloc] init];
    [requestMOp requestMGetAdsNWithParam:dict];
    
    [requestMOp getInterfaceRequestObject:^(id data) {
        [ProjectUtil showLog:@"data = %@",data];
        if ([[data objectForKey:@"success"] boolValue]) {
            
            NSArray *advertArray = data[@"datas"];
            if (advertArray.count > 0) {
                NSDictionary *advertDict = advertArray[0];
                _advertURL = advertDict[@"navigate_url"];
                
                struct utsname systemInfo;
                uname(&systemInfo);
                NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
                _imageURL = advertDict[@"img_url"];
                if ([UIScreen mainScreen].bounds.size.width == 414) {
                    _imageURL = advertDict[@"imgUrl3"];

                }else
                {
                    _imageURL = advertDict[@"imgUrl2"];

                }
                if ([deviceString isEqualToString:@"iPhone3,1"])
                {
                    _imageURL = advertDict[@"img_url"];

                }

                
                [_advertImageView sd_setImageWithURL:[NSURL URLWithString:_imageURL]];
                
                timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
                
            }else {
                [self enterAppAction:nil];
            }
            
        }else {
            [self enterAppAction:nil];
        }
        
    } Fail:^(NSError *error) {
        [self enterAppAction:nil];
    }];
    
}

//倒计时方法验证码实现倒计时5秒，5秒后进入主页
-(void)timerFireMethod:(NSTimer *)theTimer {

    [ProjectUtil showLog:[NSString stringWithFormat:@"timerSeconds %d",timerSeconds]];
    if (timerSeconds == 1) {
        [self releaseTImer];
        
    }else {
        timerSeconds--;
    }
}

//正常停止记数，
- (void)releaseTImer {
    if (timer) {
        if ([timer respondsToSelector:@selector(isValid)]) {
            if ([timer isValid]) {
                [timer invalidate];
                timer = nil;
                timerSeconds = 5;
                [self enterAppAction:nil];
            }
        }
    }
}

//中途停止记数，
- (void)releaseNowTimer
{
    if (timer) {
        if ([timer respondsToSelector:@selector(isValid)]) {
            if ([timer isValid]) {
                [timer invalidate];
                timer = nil;
                timerSeconds = 5;
            }
        }
    }
}

- (void)clickAdvertView
{
    if (![_advertURL isEqualToString:@""]) {
        
        [self releaseNowTimer];
        
        AdvertWebViewController *advertWeb = [[AdvertWebViewController alloc] initWithUrlString:_advertURL NavigationTitle:@"活动信息"];
        
        UINavigationController *mainNaVC = [[UINavigationController alloc] initWithRootViewController:advertWeb];
        [self presentViewController:mainNaVC animated:YES completion:nil];
    }

//    [self.navigationController pushViewController:advertWeb animated:YES];
}

@end
