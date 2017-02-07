//
//  ModelWebViewController.m
//  FunnyPie
//
//  Created by summer on 14-10-14.
//  Copyright (c) 2014年 X. All rights reserved.
//

#import "ModelWebViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import "CreditWebViewController.h"

@interface ModelWebViewController ()

{
    NSString *_urlString;
    NSString *_navigationTitle;
    
    UIProgressView *_progressView;
    NSTimer *_progressTimer;
}

@end

@implementation ModelWebViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

-(id)initWithUrlString:(NSString *)urlString NavigationTitle:(NSString *)navigationTitle
{
    self = [super init];
    if (self)
    {
        _navigationTitle = navigationTitle;
        _urlString = urlString;
    }
    return  self;
}



- (void)viewDidLoad {
    [super viewDidLoad];

//    //设置导航栏的颜色
//    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:21.0/255.0 green:159/255.0 blue:234/255.0 alpha:1]];
    
    //事实证明 这种方法没吊用
//    [self.navigationController.navigationBar setBarTintColor:[UIColor redColor]];
//   self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor redColor] forKey:UITextAttributeTextColor];
    
    //这个方法都不对  感觉不行了
//    [self.navigationController.navigationBar setTitleTextAttributes:
//     
//  @{NSFontAttributeName:[UIFont systemFontOfSize:18],
//    
//    NSForegroundColorAttributeName:[UIColor redColor]}];
    
    
//    [self creatNavigationItemWithMNavigationItem:MNavigationItemTypeTitle ItemName:_navigationTitle];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _progressView = [[UIProgressView alloc]initWithFrame:CGRectMake(0,64, SCREEN_WIDTH, 2)];
    _progressView.progressTintColor = RGBCOLOR(48, 154, 228);
    _progressView.trackTintColor = NavigationBarColor;
    [self.view addSubview:_progressView];
    
    
    NSURL *url = [NSURL URLWithString:_urlString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
  
    //_progressView.bottom
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64+2, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    [_webView loadRequest:request];
    _webView.delegate = self;
    _webView.backgroundColor = [UIColor clearColor];
    [_webView setScalesPageToFit:YES];
    [self.view addSubview:_webView];
    
    _progressTimer = [NSTimer scheduledTimerWithTimeInterval:0.008 target:self selector:@selector(progressTimerAction) userInfo:nil repeats:YES];
    [_progressTimer setFireDate:[NSDate distantFuture]];
    
    
    //自定义导航栏
    self.topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    self.topView.backgroundColor = [UIColor hexChangeFloat:@"00aff0"];
    self.backBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.backBtn setImage:[UIImage imageNamed:@"首页-左箭头.png"] forState:(UIControlStateNormal)];
    [self.backBtn addTarget:self action:@selector(backlastView) forControlEvents:(UIControlEventTouchUpInside)];
    self.backBtn.frame = CGRectMake(11, 20, 30, 44);
    [self.topView addSubview:self.backBtn];
    
    self.rightBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.rightBtn.frame = CGRectMake(SCREEN_WIDTH-11-30, 30, 26, 26);
    [self.rightBtn addTarget:self action:@selector(refreshBtnAction) forControlEvents:(UIControlEventTouchUpInside)];
    //销邦-发现-分享赚钱-刷新
    [self.rightBtn setImage:[UIImage imageNamed:@"销邦-发现-分享赚钱-刷新"] forState:UIControlStateNormal];
    [self.rightBtn setImage:[UIImage imageByApplyingAlpha:[UIImage imageNamed:@"销邦-发现-分享赚钱-刷新"]] forState:UIControlStateHighlighted];
    [self.topView addSubview:self.rightBtn];
    [self.view addSubview:self.topView];
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-200)/2, 27, 200, 30)];
    titleLabel.text =_navigationTitle;
    titleLabel.font = Default_Font_17;
    [titleLabel setTextColor:[UIColor whiteColor]];
    //    [titleLabel sizeToFit];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.topView addSubview: titleLabel];
    
//    //导航栏右侧刷新按钮
//    UIButton *refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [refreshBtn setImage:[UIImage imageNamed:@"销邦-发现-分享赚钱-刷新"] forState:UIControlStateNormal];
//    [refreshBtn setBackgroundImage:[UIImage imageByApplyingAlpha:[UIImage imageNamed:@"销邦-发现-分享赚钱-刷新"]] forState:UIControlStateHighlighted];
//    refreshBtn.frame = CGRectMake(0,0,26,26);
//    [refreshBtn addTarget: self action:@selector(refreshBtnAction) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:refreshBtn];
//    
//    //导航栏上的返回按钮
//    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn.frame = CGRectMake(0, 0, 26, 26);
//    [btn setBackgroundImage:[UIImage imageNamed:@"首页-左箭头.png"] forState:UIControlStateNormal];
//    [btn setBackgroundImage:[UIImage imageByApplyingAlpha:[UIImage imageNamed:@"首页-左箭头.png"]] forState:UIControlStateHighlighted];
//    [btn addTarget:self action:@selector(backlastView) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem* BACK = [[UIBarButtonItem alloc]initWithCustomView:btn];
//    self.navigationItem.leftBarButtonItem = BACK;

}

//返回上一页
-(void)backlastView
{
    
    if ([_webView canGoBack])
    {
        [_webView goBack];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSMutableString *url=[[NSMutableString alloc]initWithString:[request.URL absoluteString]];
    
    if([url rangeOfString:@"dbnewopen"].location!=NSNotFound)
    {
        
        [url replaceCharactersInRange:[url rangeOfString:@"&dbnewopen"] withString:@""];
        CreditWebViewController *web=[[CreditWebViewController alloc]initWithUrl:url];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:web animated:YES];
        
        return NO;
    }
    return YES;
}



//刷新   销邦-发现-分享赚钱-刷新@x.png   refresh
-(void)refreshBtnAction
{
    NSURL *url = [NSURL URLWithString:_urlString];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
    [_webView loadRequest:request];
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
