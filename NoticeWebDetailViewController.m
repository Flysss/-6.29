//
//  NoticeWebDetailViewController.m
//  SalesHelper_A
//
//  Created by flysss on 16/6/3.
//  Copyright © 2016年 X. All rights reserved.
//

#import "NoticeWebDetailViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import "ZJShareView.h"

@interface NoticeWebDetailViewController ()

@end

@implementation NoticeWebDetailViewController
{
    NSString *_urlString;
    NSString *_navigationTitle;

}
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSURL *url = [NSURL URLWithString:_urlString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    //_progressView.bottom
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    [_webView loadRequest:request];
    _webView.delegate = self;
    _webView.backgroundColor = [UIColor clearColor];
    [_webView setScalesPageToFit:YES];
    [self.view addSubview:_webView];
    
    //自定义导航栏
    self.topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    self.topView.backgroundColor = [UIColor hexChangeFloat:@"00aff0"];
    self.backBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.backBtn setImage:[UIImage imageNamed:@"首页-左箭头.png"] forState:(UIControlStateNormal)];
    [self.backBtn addTarget:self action:@selector(backlastView) forControlEvents:(UIControlEventTouchUpInside)];
    self.backBtn.frame = CGRectMake(11, 20, 30, 44);
    [self.topView addSubview:self.backBtn];
    
    self.rightBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.rightBtn.frame = CGRectMake(SCREEN_WIDTH-30-11, 20, 30, 44);
    [self.rightBtn addTarget:self action:@selector(selectNoticeToShare) forControlEvents:(UIControlEventTouchUpInside)];
    //销邦-发现-分享赚钱-刷新
    [self.rightBtn setImage:[UIImage imageNamed:@"首页-分享"] forState:UIControlStateNormal];
    [self.rightBtn setImage:[UIImage imageByApplyingAlpha:[UIImage imageNamed:@"首页-分享"]] forState:UIControlStateHighlighted];
    [self.topView addSubview:self.rightBtn];
    [self.view addSubview:self.topView];
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-200)/2, 27, 200, 30)];
    titleLabel.text =_navigationTitle;
    titleLabel.font = Default_Font_18;
    [titleLabel setTextColor:[UIColor whiteColor]];
    //    [titleLabel sizeToFit];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.topView addSubview: titleLabel];
    
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
//    NSMutableString *url=[[NSMutableString alloc]initWithString:[request.URL absoluteString]];
    
    
    return YES;
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
  
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
   
    
}

//公告分享
-(void)selectNoticeToShare
{
    
    NSMutableArray *imageArray = [NSMutableArray array];
    [imageArray addObject:[UIImage imageNamed:IMAGE_NAME]];
    
    NSString * content = [NSString stringWithFormat:@"销邦公告分享连接:%@",_urlString];
    
    //分享视图所需参数
    NSDictionary *shareDic = @{@"url":_urlString,
                               @"imageArr":imageArray,
                               @"title":@"",
                               @"loginuid":@"",
                               @"tieZiID":@"",
                               @"uid":@"",
                               @"sinPic":@"",
                               @"content":content
                               };
    
    ZJShareView * view = [ZJShareView share];
    view.shareDic = shareDic;
    view.isDelete = YES;
    view.isReport = YES;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    [window addSubview:view];
    
    view.width = SCREEN_WIDTH;
    view.height = SCREEN_HEIGHT;
    view.y = 0;
    view.x = 0;
    view.bgView.backgroundColor = [UIColor blackColor];
    view.bgView.alpha= 0.0;
    view.topView.y = SCREEN_HEIGHT;
    
    [UIView animateWithDuration:0.5 animations:^{
        view.topView.y = SCREEN_HEIGHT-view.shareViewHeight;
        view.bgView.alpha= 0.3;
    } completion:^(BOOL finished) {
        
    }];

    
    
//    NSMutableArray * imageArray = [NSMutableArray arrayWithCapacity:0];
//    NSURL * url = [NSURL URLWithString:_urlString];
//    NSString * content = [NSString stringWithFormat:@"销邦公告分享连接:%@",url];
//    [imageArray addObject:[UIImage imageNamed:IMAGE_NAME]];
//    //    1、创建分享参数
//    if (imageArray)
//    {
//        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
//        [shareParams SSDKSetupShareParamsByText:content
//                                         images:imageArray
//                                            url:url
//                                          title:@"我的分享"
//                                           type:SSDKContentTypeAuto];
//        NSArray *items = @[@(SSDKPlatformTypeSinaWeibo),@(SSDKPlatformSubTypeQZone),@(SSDKPlatformSubTypeWechatSession),@(SSDKPlatformSubTypeWechatTimeline),@(SSDKPlatformSubTypeQQFriend)];
//        //2、分享（可以弹出我们的分享菜单和编辑界面）
//        [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
//                                 items:items
//                           shareParams:shareParams
//                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
//                       
//                       [[UIApplication sharedApplication].keyWindow endEditing:YES];
//                       
//                       switch (state) {
//                           case SSDKResponseStateSuccess:
//                           {
//                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
//                                                                                   message:nil
//                                                                                  delegate:nil
//                                                                         cancelButtonTitle:@"确定"
//                                                                         otherButtonTitles:nil];
//                               [alertView show];
//                               
//                               break;
//                           }
//                           case SSDKResponseStateFail:
//                           {
//                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
//                                                                               message:[NSString stringWithFormat:@"%@",error]
//                                                                              delegate:nil
//                                                                     cancelButtonTitle:@"OK"
//                                                                     otherButtonTitles:nil, nil];
//                               NSLog(@"----%@",error);
//                               [alert show];
//                               break;
//                           }
//                           default:
//                               break;
//                       }
//                   }
//         ];
//    }
    
    
    
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
