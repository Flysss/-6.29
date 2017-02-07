//
//  CreditWebViewController.m
//  dui88-iOS-sdk
//
//  Created by xuhengfei on 14-5-16.
//  Copyright (c) 2014年 cpp. All rights reserved.
//

#import "CreditWebViewController.h"
#import "CreditWebView.h"
#import "CreditConstant.h"
#import "UIColor+Extend.h"

@interface CreditWebViewController ()<UIWebViewDelegate>
    
@property(nonatomic,strong) NSURLRequest *request;
@property(nonatomic,strong) CreditWebView *webView;
@property(nonatomic,strong) NSString *shareUrl;
@property(nonatomic,strong) NSString *shareTitle;
@property(nonatomic,strong) NSString *shareSubtitle;
@property(nonatomic,strong) NSString *shareThumbnail;

@property(nonatomic,strong) UIBarButtonItem *shareButton;


@property(nonatomic,strong) UIActivityIndicatorView *activity;

@end

static BOOL byPresent=NO;
static UINavigationController *navController;
static NSString *originUserAgent;

@implementation CreditWebViewController


-(id)initWithUrl:(NSString *)url{
    self=[super init];
    self.request=[NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    
    
    return self;
}
-(id)initWithUrlByPresent:(NSString *)url{
    self=[self initWithUrl:url];
    
    
//    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(dismiss)];
//    self.navigationItem.leftBarButtonItem=leftButton;
    
    
    byPresent=YES;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(shouldNewOpen:) name:@"dbnewopen" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(shouldBackRefresh:) name:@"dbbackrefresh" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(shouldBack:) name:@"dbback" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(shouldBackRoot:) name:@"dbbackroot" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(shouldBackRootRefresh:) name:@"dbbackrootrefresh" object:nil];
    
    return self;
}
-(id)initWithRequest:(NSURLRequest *)request{
    self=[super init];
    self.request=request;
    
       
    return self;
}

-(void)dismiss
{
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSUserDefaults standardUserDefaults]registerDefaults:@{@"UserAgent":originUserAgent}];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(originUserAgent==nil){
        UIWebView* webView = [[UIWebView alloc] initWithFrame:CGRectZero];
        originUserAgent = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    }
    NSString *ua=[originUserAgent stringByAppendingFormat:@" Duiba/%@",DUIBA_VERSION];
    [[NSUserDefaults standardUserDefaults]registerDefaults:@{@"UserAgent":ua}];
    
//    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    self.navigationController.navigationBarHidden = YES;
    
    self.webView.frame=CGRectMake(0, 44, SCREEN_WIDTH, SCREEN_HEIGHT-44);
    

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    if(!byPresent && navController==nil){
        navController=self.navigationController;
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(shouldNewOpen:) name:@"dbnewopen" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(shouldBackRefresh:) name:@"dbbackrefresh" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(shouldBack:) name:@"dbback" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(shouldBackRoot:) name:@"dbbackroot" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(shouldBackRootRefresh:) name:@"dbbackrootrefresh" object:nil];
    }
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(setRefreshCurrentUrl:) name:@"duiba-autologin-visit" object:nil];
    
    [super viewDidLoad];
	self.webView=[[CreditWebView alloc]initWithFrame:self.view.bounds andUrl:[[self.request URL] absoluteString]];
    [self.view addSubview:self.webView];
    [self.webView loadRequest:self.request];
    self.webView.webDelegate=self;
    self.title=@"加载中";
#pragma mark--导航栏操作
    
    self.topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    self.topView.backgroundColor = [UIColor hexChangeFloat:@"00aff0"];
    self.backBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.backBtn setImage:[UIImage imageNamed:@"首页-左箭头.png"] forState:(UIControlStateNormal)];
    [self.backBtn setImage:[UIImage imageByApplyingAlpha:[UIImage imageNamed:@"首页-左箭头"]] forState:(UIControlStateHighlighted)];
    [self.backBtn addTarget:self action:@selector(backlastView) forControlEvents:(UIControlEventTouchUpInside)];
    self.backBtn.frame = CGRectMake(11, 20, 30, 44);
    [self.topView addSubview:self.backBtn];
    //创建标题
   self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-120)/2, 27, 120, 30)];
    self.titleLabel.text = @"加载中";
    self.titleLabel.font = Default_Font_20;
    [self.titleLabel setTextColor:[UIColor whiteColor]];
    //    [titleLabel sizeToFit];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.topView addSubview: self.titleLabel];
    
    [self.view addSubview:self.topView];
    

    
//    NSDictionary *attributes=[NSDictionary dictionaryWithObjectsAndKeys:
//                              [UIColor whiteColor],
//                              NSForegroundColorAttributeName,
//                              [UIFont systemFontOfSize:17],
//                              NSFontAttributeName,
//                              nil];
//    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
//    
//    UIButton* btn=[UIButton buttonWithType:UIButtonTypeCustom];
//    btn.frame=CGRectMake(0, 0, 26, 26);
//    [btn setBackgroundImage:[UIImage imageNamed:@"首页-左箭头.png"] forState:UIControlStateNormal];
//    [btn setBackgroundImage:[UIImage imageByApplyingAlpha:[UIImage imageNamed:@"首页-左箭头.png"]] forState:UIControlStateHighlighted];
//    
//    [btn addTarget:self action:@selector(backlastView) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem* BACK=[[UIBarButtonItem alloc]initWithCustomView:btn];
//    self.navigationItem.leftBarButtonItem=BACK;
    
    
    self.activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];//指定进度轮的大小
    [self.activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [self.activity hidesWhenStopped];
    [self.activity setCenter:self.view.center];//指定进度轮中心点
    
    [self.activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];//设置进度轮显示类型
    self.activity.color=[UIColor blackColor];
    
    [self.view addSubview:self.activity];
    
    
}
-(void)backlastView
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    if(self.needRefreshUrl!=nil){
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.needRefreshUrl]]];
        self.needRefreshUrl=nil;
    }
}


-(void)setRefreshCurrentUrl:(NSNotification*)notify{
    if([notify.userInfo objectForKey:@"webView"]!=self.webView){
        self.needRefreshUrl=self.webView.request.URL.absoluteString;
    }
}

-(void)refreshParentPage:(NSURLRequest *)request{
    [self.webView loadRequest:request];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    if(navController!=nil && !byPresent){
        NSInteger count=navController.viewControllers.count;
        BOOL containCredit=NO;
        for(int i=0;i<count;i++){
            UIViewController *vc=[navController.viewControllers objectAtIndex:i];
            if([vc isKindOfClass:[CreditWebViewController class]]){
                containCredit=YES;
                break;
            }
        }
        if(!containCredit){
            navController=nil;
        }
    }
    
}
#pragma mark WebViewDelegate
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
}
-(void)webViewDidStartLoad:(UIWebView *)webView{
    [self.activity startAnimating];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    self.title=[webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.titleLabel.text = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    NSString *content=[webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('duiba-share-url').getAttribute('content');"];
    if(content.length>0)
    {
        NSArray *d=[content componentsSeparatedByString:@"|"];
        if(d.count==4){
            self.shareUrl=[d objectAtIndex:0];
            self.shareThumbnail=[d objectAtIndex:1];
            self.shareTitle=[d objectAtIndex:2];
            self.shareSubtitle=[d objectAtIndex:3];
            
//            if(self.shareButton==nil)
//            {
//                self.shareButton=[[UIBarButtonItem alloc] initWithTitle:@"分享" style:UIBarButtonItemStyleBordered target:self action:@selector(onShareClick)];
//                
//            }
//            
//            if(self.navigationItem.rightBarButtonItem==nil){
//                self.navigationItem.rightBarButtonItem=self.shareButton;
//            }
            if (self.rightBtn == nil)
            {
                self.rightBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
                self.rightBtn.frame = CGRectMake(SCREEN_WIDTH-11-40, 20, 40, 44);
                [self.rightBtn setTitle:@"分享" forState:UIControlStateNormal];
                [self.rightBtn addTarget:self action:@selector(onShareClick) forControlEvents:(UIControlEventTouchUpInside)];
                [self.topView addSubview:self.rightBtn];
            }
            
        }
    }else
    {
//        if(self.shareButton!= nil && self.shareButton==self.navigationItem.rightBarButtonItem)
//        {
//            self.navigationItem.rightBarButtonItem=nil;
//        }
        self.rightBtn = nil;
        
    }
    [self.activity stopAnimating];
}



-(void)onShareClick{
    NSMutableDictionary *dict=[NSMutableDictionary dictionary];
    [dict setObject:self.shareUrl forKey:@"shareUrl"];
    [dict setObject:self.shareThumbnail forKey:@"shareThumbnail"];
    [dict setObject:self.shareTitle forKey:@"shareTitle"];
    [dict setObject:self.shareSubtitle forKey:@"shareSubtitle"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"duiba-share-click" object:self userInfo:dict];
}

-(UINavigationController*)getNavCon{
    if(byPresent){
        return self.navigationController;
    }
    return navController;
}

#pragma mark 5 activite

//H5页面push进入下一页
-(void)shouldNewOpen:(NSNotification*)notification{
//    UIViewController *last=[[self getNavCon].viewControllers lastObject];
    
    CreditWebViewController *newvc=[[CreditWebViewController alloc]initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[notification.userInfo objectForKey:@"url"]]]];
    
//    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:nil action:nil];
//    [last.navigationItem setBackBarButtonItem:backItem];
    
//    [[self getNavCon] pushViewController:newvc animated:YES];
    [self.navigationController pushViewController:newvc animated:YES];
}

//返回刷新
-(void)shouldBackRefresh:(NSNotification*) notification{
    NSInteger count=[[self getNavCon].viewControllers count];
    
    
    if(count>1){
        CreditWebViewController *second=[[self getNavCon].viewControllers objectAtIndex:count-2];
        second.needRefreshUrl=[notification.userInfo objectForKey:@"url"];
    }
    
//    [[self getNavCon] popViewControllerAnimated:YES];
    [self.navigationController popViewControllerAnimated:YES];
    
}
//页面返回通知
-(void)shouldBack:(NSNotification*)notification
{
//    [[self getNavCon] popViewControllerAnimated:YES];
    [self.navigationController popViewControllerAnimated:YES];

}
//通知：返回到首页
-(void)shouldBackRoot:(NSNotification*)notification
{
    NSInteger count=[self getNavCon].viewControllers.count;
    CreditWebViewController *rootVC=nil;
    for(int i=0;i<count;i++)
    {
        UIViewController *vc=[[self getNavCon].viewControllers objectAtIndex:i];
        if([vc isKindOfClass:[CreditWebViewController class]]){
            rootVC=(CreditWebViewController*)vc;
            break;
        }
    }
    if(rootVC!=nil){
        [[self getNavCon] popToViewController:rootVC animated:YES];
    }else{
        [[self getNavCon] popViewControllerAnimated:YES];
    }
}
//通知：返回到首页并刷新页面
-(void)shouldBackRootRefresh:(NSNotification*)notification{
    NSInteger count=[self getNavCon].viewControllers.count;
    CreditWebViewController *rootVC=nil;
    for(int i=0;i<count;i++){
        UIViewController *vc=[[self getNavCon].viewControllers objectAtIndex:i];
        if([vc isKindOfClass:[CreditWebViewController class]]){
            rootVC=(CreditWebViewController*)vc;
            break;
        }
    }
    if(rootVC!=nil){
        rootVC.needRefreshUrl=[notification.userInfo objectForKey:@"url"];
        [[self getNavCon] popToViewController:rootVC animated:YES];
    }else{
        [[self getNavCon] popViewControllerAnimated:YES];
    }
}


@end
 