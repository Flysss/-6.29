//
//  ShareWebInfoViewController.m
//  SalesHelper_A
//
//  Created by zhipu on 14/12/26.
//  Copyright (c) 2014年 X. All rights reserved.
//

#import "ShareWebInfoViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>

@interface ShareWebInfoViewController ()<UIWebViewDelegate,UIActionSheetDelegate>
{
    

    //分享赚钱调用接口次数 最多三次
    NSInteger requestIndex;
}

@property (weak, nonatomic) IBOutlet UIWebView *shareMainWebView;

@end

@implementation ShareWebInfoViewController
//@synthesize htmlBody = _htmlBody;
- (void)viewDidLoad {
    [super viewDidLoad];

    [_webView setHeight:_webView.height];
    //让self.bottomView 显示在最上层  销邦-发现-分享赚钱-刷新@x.png
    [self.view bringSubviewToFront:self.shareBtn];
    
    
    UIButton* btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake(0, 0, 26, 26);
    [btn setBackgroundImage:[UIImage imageNamed:@"首页-左箭头.png"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageByApplyingAlpha:[UIImage imageNamed:@"首页-左箭头.png"]] forState:UIControlStateHighlighted];

    [btn addTarget:self action:@selector(backlastView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* BACK=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=BACK;
//    
//    [self.view setBackgroundColor:[UIColor colorWithRed:258.0/255.0 green:238.0/255.0 blue:218.0/255.0 alpha:1]];
    
    
//    UIButton* rightbtn=[UIButton buttonWithType:UIButtonTypeCustom];
//    rightbtn.frame=CGRectMake(0, 0, 26, 26);
//    [rightbtn setBackgroundImage:[UIImage imageNamed:@"销邦-发现-分享赚钱-刷新.png"] forState:UIControlStateNormal];
//    [rightbtn addTarget:self action:@selector(shuaxinView) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem* bACK=[[UIBarButtonItem alloc]initWithCustomView:rightbtn];
//    self.navigationItem.rightBarButtonItem=bACK;
}
-(void)shuaxinView
{
   
    
//    NSURL* url=[NSURL URLWithString:self.shareDict[@"logshareurl"]];
//    NSURLRequest* ruquesturl=[[NSURLRequest alloc]initWithURL:url];
//    [self.shareMainWebView loadRequest:ruquesturl];

   [self.shareMainWebView reload];
}
-(void)backlastView
{
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)updateShareWebInfoView
//{
//    NSString* htmlHeader=@"<html><head></head><body>";
//    NSString* htmlFooter=@"</body></html>";
//    NSString* strHtml=[[NSString alloc] initWithFormat:@"%@%@%@",htmlHeader,self.htmlBody,htmlFooter];
//    [ProjectUtil showLog:@"strHtml  %@",strHtml];
//    [self.shareMainWebView loadHTMLString:strHtml baseURL:nil];
//}


- (IBAction)shareBtnClickAction:(id)sender {

    //创建分享内容
//    NSString *urlString = self.shareDict[@"logIntroimg"];
    
    NSString *content_url = self.shareDict[@"logshareurl"];
    
    NSString *content_sms = [NSString stringWithFormat:@"%@ 地址:%@",self.shareDict[@"logTitle"],content_url];
    
    NSArray *imageArray = @[[UIImage imageNamed:BANGHUI_SHAREURL]];
    //1、创建分享参数
            if (imageArray) {
    
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:content_sms
                                     images:imageArray
                                        url:[NSURL URLWithString:content_url]
                                      title:self.shareDict[@"logTitle"]
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
                           [self requestAddShareRec];
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


//分享赚钱调用接口次数
- (void)requestAddShareRec
{
    NSDictionary *dict = @{@"token":self.login_user_token,
                           @"share_time":self.shareDict[@"logPostTime"],
                           @"share_url":self.shareDict[@"logshareurl"],
                           @"share_logid":self.shareDict[@"logId"]
                           };
    
    RequestInterface *requestOp = [[RequestInterface alloc] init];
    [requestOp requestAddShareRecWithParam:dict];
    
    [requestOp getInterfaceRequestObject:^(id data) {
        [ProjectUtil showLog:@"data = %@",data];
        if ([data[@"success"] boolValue]) {
            
        }
    } Fail:^(NSError *error) {
        if (requestIndex < 3) {
            requestIndex ++;
            [self requestAddShareRec];
        }
    }];
}


@end
