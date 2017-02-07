//
//  ShareEarnViewController.m
//  SalesHelper_A
//
//  Created by Brant on 16/1/21.
//  Copyright (c) 2016年 X. All rights reserved.
//

#import "ShareEarnViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/SSEShareHelper.h>

#import "ShareSuccessViewController.h"

@interface ShareEarnViewController () <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *shareMainWebView;

@end

@implementation ShareEarnViewController
{
    UIProgressView *_progressView;
    NSTimer *_progressTimer;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self creatNaviControl];
    
    [self creatWebView];
    
    [self creatShareBtn];
}


- (void)creatNaviControl
{
    
    [self CreateCustomNavigtionBarWith:self leftItem:@selector(backlastView) rightItem:@selector(refreshBtnAction)];
    //创建标题
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-120)/2, 27, 120, 30)];
    titleLabel.text = @"分享赚钱详情";
    titleLabel.font = Default_Font_20;
    [titleLabel setTextColor:[UIColor whiteColor]];
    //    [titleLabel sizeToFit];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.topView addSubview: titleLabel];
    
    self.rightBtn.frame =  CGRectMake(SCREEN_WIDTH-40, 30, 26, 26);
    [self.rightBtn setImage:[UIImage imageNamed:@"销邦-发现-分享赚钱-刷新"] forState:UIControlStateNormal];
    [self.rightBtn setImage:[UIImage imageNamed:@"销邦-发现-分享赚钱-刷新"] forState:UIControlStateHighlighted];
    
//    //导航栏右侧刷新按钮
//    UIButton *refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [refreshBtn setImage:[UIImage imageNamed:@"销邦-发现-分享赚钱-刷新"] forState:UIControlStateNormal];
//    [refreshBtn setBackgroundImage:[UIImage imageByApplyingAlpha:[UIImage imageNamed:@"销邦-发现-分享赚钱-刷新"]] forState:UIControlStateHighlighted];
//    refreshBtn.frame = CGRectMake(0, 0, 26, 26);
//    [refreshBtn addTarget: self action:@selector(refreshBtnAction) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:refreshBtn];

}
-(void)backlastView
{
    [self.navigationController popViewControllerAnimated:YES];
}

///刷新按钮
- (void)refreshBtnAction
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.shareDict[@"logshareurl"]]];
    [_shareMainWebView loadRequest:request];
}

//创建webView
- (void)creatWebView
{
    _progressView = [[UIProgressView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 2)];
    _progressView.progressTintColor = RGBCOLOR(48, 154, 228);
    _progressView.trackTintColor = NavigationBarColor;
    [self.view addSubview:_progressView];
    
    _progressTimer = [NSTimer scheduledTimerWithTimeInterval:0.008 target:self selector:@selector(progressTimerAction) userInfo:nil repeats:YES];
    [_progressTimer setFireDate:[NSDate distantFuture]];
//
    _shareMainWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64+2, SCREEN_WIDTH, SCREEN_HEIGHT-64-50)];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.shareDict[@"logshareurl"]]];
    [_shareMainWebView loadRequest:request];
    _shareMainWebView.backgroundColor = [UIColor whiteColor];
    _shareMainWebView.delegate = self;
    [self.view  addSubview:_shareMainWebView];
}
- (void)creatShareBtn
{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50)];
    button.backgroundColor = [UIColor hexChangeFloat:KBlueColor];
    button.alpha = 1.0;
    [button setTitle:@"立即分享" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = Default_Font_20;
    [button addTarget:self action:@selector(shared:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)shared:(UIButton *)sender
{
//    NSLog(@"点击了推荐按钮");
    
    //创建分享内容
        NSString *urlString = self.shareDict[@"logIntroimg"];
    
        NSString *content_url = self.shareDict[@"logshareurl"];
    
        NSString *content_sms = [NSString stringWithFormat:@"%@ 地址:%@",self.shareDict[@"logTitle"],content_url];
    
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    
    
    NSArray* imageArray = @[urlString];
    
    if (imageArray)
    {
        
        [shareParams SSDKSetupShareParamsByText:content_sms
                                         images:imageArray
                                            url:[NSURL URLWithString:content_url]
                                          title:self.shareDict[@"logTitle"]
                                           type:SSDKContentTypeAuto];
        
//        [shareParams SSDKSetupWeChatParamsByText:content_sms
//                                           title:self.shareDict[@"logTitle"]
//                                             url:[NSURL URLWithString:content_url]
//                                      thumbImage:[imageArray firstObject]
//                                           image:nil
//                                    musicFileURL:nil
//                                         extInfo:nil
//                                        fileData:nil
//                                    emoticonData:nil
//                             sourceFileExtension:nil
//                                  sourceFileData:nil
//                                            type:SSDKContentTypeAuto
//                              forPlatformSubType:SSDKPlatformSubTypeWechatTimeline];
        
        
        NSLog(@"%@",shareParams);
        //进行分享
        [ShareSDK share:SSDKPlatformSubTypeWechatTimeline
             parameters:shareParams
         onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error)
         {
             
             switch (state) {
                 case SSDKResponseStateSuccess:
                 {
//                     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
//                                                                         message:nil
//                                                                        delegate:nil
//                                                               cancelButtonTitle:@"确定"
//                                                               otherButtonTitles:nil];
//                     [alertView show];
                     [self sendShareSuccess];
                     [self.view makeToast:@"分享成功"];
                     break;
                 }
                 case SSDKResponseStateFail:
                 {
//                     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享失败"
//                                                                         message:[NSString stringWithFormat:@"%@", error]
//                                                                        delegate:nil
//                                                               cancelButtonTitle:@"确定"
//                                                               otherButtonTitles:nil];
//                     [alertView show];
                     [self.view makeToast:@"分享失败"];
                     break;
                 }
                 case SSDKResponseStateCancel:
                 {
//                     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享已取消"
//                                                                         message:nil
//                                                                        delegate:nil
//                                                               cancelButtonTitle:@"确定"
//                                                               otherButtonTitles:nil];
//                     [alertView show];
                     [self.view makeToast:@"分享已取消"];
                     break;
                     
                 }
                 default:
                     break;
             }
         }];
    }
    

}


#pragma mark --分享成功后
- (void)sendShareSuccess
{
    //分享成功后提示
    [self.view makeToast:@"分享成功"];
    
    //提交钱包赚钱，只有提交成功后才会跳转到分享成功界面，
    //第二次分享成功后，提交钱包不会成功，不会跳转
    NSDictionary *dic = @{
                          @"token":self.login_user_token,
                          @"shareUrl":self.shareDict[@"logshareurl"],
                          @"shareId":self.shareDict[@"logId"],
                          @"sharemoney":self.shareDict[@"sharemoney"]
                          };
    RequestInterface *interF = [[RequestInterface alloc] init];
    [interF requestSharedSuccessWithDic:dic];
    [interF getInterfaceRequestObject:^(id data) {
        
        if ([data[@"success"] boolValue])
        {
            //跳转到分享成功
            ShareSuccessViewController *vc = [[ShareSuccessViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            vc.shareDic = self.shareDict;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    } Fail:^(NSError *error) {
        [self.view makeToast:@"网络异常"];
        
    }];
    
    
}

//定时
-(void)progressTimerAction
{
    _progressView.progress += 0.005;
    if (_progressView.progress >= 0.95)
    {
        [_progressTimer setFireDate:[NSDate distantFuture]];
    }
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    _progressView.progress = 0.0;
    [_progressTimer setFireDate:[NSDate distantPast]];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    _progressView.progress = 0.0;
}


-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    //    if (![_navigationTitle isEqualToString:@"index"])
    //    {
    //        NSString *theTitle = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    //        [self creatNavigationItemWithMNavigationItem:MNavigationItemTypeTitle ItemName:theTitle];
    //    }
    [_progressTimer setFireDate:[NSDate distantFuture]];
    _progressView.progress = 0.0;
    _progressView.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
