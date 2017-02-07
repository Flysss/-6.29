//
//  ZJShareView.m
//  SalesHelper_A
//
//  Created by zhipu on 16/6/16.
//  Copyright © 2016年 X. All rights reserved.
//

#import "ZJShareView.h"
#import "UIColor+HexColor.h"
#import "ZJShareIconView.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import "AFHTTPRequestOperationManager.h"

@implementation ZJShareView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
static ZJShareView *shareView = nil;
+ (ZJShareView *)share
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        shareView = [[ZJShareView alloc]init];
    });
    return shareView;
}



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        
        [self setupView];
    }
    return self;
}
//分享选择布局
- (void)setupView
{
    NSArray *iconArray = @[@"wxpyq",@"wxhy",@"qqkj",@"qq",@"wb"];
    NSArray *titleArray = @[@"朋友圈",@"微信好友",@"QQ空间",@"QQ",@"新浪微博"];
    
    NSArray *iconArr = @[@"copy",@"jb",@"delete"];
    NSArray *nameArr = @[@"复制链接",@"举报",@"删除"];
    
    
    self.bgView = [[UIView alloc]init];
    self.bgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.bgView.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeView)];
    [self.bgView addGestureRecognizer:tap];
    [self addSubview:self.bgView];
    
    
    self.topView = [[UIView alloc]init];
    self.topView.frame = CGRectMake(0, SCREEN_HEIGHT-200, SCREEN_WIDTH, 150);
    self.topView.backgroundColor = [UIColor colorWithHexString:@"f3f3f3"];
    [self addSubview:self.topView];
    
    UILabel *lblTitle = [[UILabel alloc]init];
    lblTitle.frame = CGRectMake(0, 10, SCREEN_WIDTH, 20);
    lblTitle.font = [UIFont systemFontOfSize:14];
    lblTitle.text = @"分享至";
    lblTitle.textAlignment = NSTextAlignmentCenter;
    lblTitle.textColor = [UIColor colorWithHexString:@"999999"];
    [self.topView addSubview:lblTitle];
    
    CGFloat scrollY = 0;
    int totalloc = 5;
    CGFloat appvieww = 70*SCREEN_WIDTH/320;
    CGFloat appviewh = 70*SCREEN_WIDTH/320;
    //    CGFloat margin=(SCREEN_WIDTH-totalloc*appvieww)/(totalloc+1);
    CGFloat margin=5;
    
    
    UIScrollView *scrollView = [[UIScrollView alloc]init];
    for (int i = 0; i < iconArray.count; i++)
    {
        ZJShareIconView *icon = [[ZJShareIconView alloc]init];
        int row=i/totalloc;//行号
        int loc=i%totalloc;//列号
        CGFloat appviewx=margin+(margin+appvieww)*loc;
        CGFloat appviewy=margin+(margin+appviewh)*row;
        icon.frame = CGRectMake(appviewx, appviewy, appvieww, appviewh);
        [icon shareIconViewWithIcom:iconArray[i] title:titleArray[i]];
        [icon.btnShare addTarget:self action:@selector(shareAction:) forControlEvents:(UIControlEventTouchUpInside)];
        icon.btnShare.tag = i;
        [scrollView addSubview:icon];
        scrollY = appviewy+appviewh;
    }
    scrollView.showsVerticalScrollIndicator = FALSE;
    scrollView.showsHorizontalScrollIndicator = FALSE;
    scrollView.contentSize = CGSizeMake(appvieww*iconArray.count+margin*(iconArray.count+1), 0);
    scrollView.frame = CGRectMake(0, CGRectGetMaxY(lblTitle.frame), SCREEN_WIDTH, scrollY+20+margin*2);
    [self.topView addSubview:scrollView];
    
    UIView *lineView = [[UIView alloc]init];
    lineView.frame = CGRectMake(0, CGRectGetMaxY(scrollView.frame)+margin, SCREEN_WIDTH, 0.5);
    lineView.backgroundColor = [UIColor colorWithHexString:@"cdcdcd"];
    [self.topView addSubview:lineView];
    
    UIScrollView *scrollView2 = [[UIScrollView alloc]init];
    
    for (int i = 0; i < iconArr.count; i++)
    {
        ZJShareIconView *icon = [[ZJShareIconView alloc]init];
        int row=i/totalloc;//行号
        int loc=i%totalloc;//列号
        icon.tag = 200+i;
        CGFloat appviewx = margin+(margin+appvieww)*loc;
        CGFloat appviewy = margin+(margin+appviewh)*row;
        icon.frame = CGRectMake(appviewx, appviewy, appvieww, appviewh);
        [icon shareIconViewWithIcom:iconArr[i] title:nameArr[i]];
        [icon.btnShare addTarget:self action:@selector(otherAction:) forControlEvents:(UIControlEventTouchUpInside)];
        icon.btnShare.tag = 10+i;
        [scrollView2 addSubview:icon];
    }
    scrollView2.frame = CGRectMake(0, CGRectGetMaxY(lineView.frame)+margin*2, SCREEN_WIDTH, scrollY+20+margin*2);
    [self.topView addSubview:scrollView2];
    
    UIButton *btnReturn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btnReturn.frame = CGRectMake(0, CGRectGetMaxY(scrollView2.frame), SCREEN_WIDTH, 50);
    btnReturn.backgroundColor = [UIColor whiteColor];
    [btnReturn setTitle:@"取消" forState:(UIControlStateNormal)];
    [btnReturn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [btnReturn addTarget:self action:@selector(removeView) forControlEvents:(UIControlEventTouchUpInside)];
    [self.topView addSubview:btnReturn];
    
    
    self.topView.frame = CGRectMake(0, SCREEN_HEIGHT - (scrollView.height+scrollView2.height)-50-margin*2, SCREEN_WIDTH, CGRectGetMaxY(btnReturn.frame));
    _shareViewHeight = self.topView.height;
}
- (void)setShareDic:(NSDictionary *)shareDic
{
    _shareDic = shareDic;
    ZJShareIconView *icon = [self viewWithTag:202];
    [icon shareIconViewWithDic:shareDic];
    
    ZJShareIconView *icon1 = [self viewWithTag:201];
    [icon1 shareIconViewWithDic1:shareDic];
    int row=1/5;//行号
    int loc=1%5;//列号
    CGFloat appvieww = 70*SCREEN_WIDTH/320;
    CGFloat appviewh = 70*SCREEN_WIDTH/320;

//    CGFloat margin=(SCREEN_WIDTH-5*appvieww)/(5+1);
        CGFloat margin=5;
    CGFloat appviewx = margin+(margin+appvieww)*loc;
    CGFloat appviewy = margin+(margin+appviewh)*row;

    icon.frame = CGRectMake(appviewx, appviewy, appvieww, appviewh);
}

- (void)setIsReport:(BOOL)isReport
{
    if (isReport == YES) {
        ZJShareIconView *icon1 = [self viewWithTag:201];
        icon1.hidden = YES;
    }
}
-(void)setIsDelete:(BOOL)isDelete
{
    if (isDelete == YES) {
        ZJShareIconView *icon1 = [self viewWithTag:202];
        icon1.hidden = YES;
    }
}



//移除分享选择视图
- (void)removeView
{
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;

    self.bgView.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:0.5 animations:^{
        self.y = 0;
        self.y = SCREEN_HEIGHT;
    } completion:^(BOOL finished) {
        [window removeFromSuperview];
    }];

}
//分享到平台
- (void)shareAction:(UIButton *)btn
{
    //参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters SSDKSetupShareParamsByText:_shareDic[@"content"] images:_shareDic[@"imageArr"] url:[NSURL URLWithString:_shareDic[@"url"]] title:_shareDic[@"title"] type:SSDKContentTypeAuto];
    
    if (btn.tag == 0)
    {
        [self shareToplatformType:SSDKPlatformSubTypeWechatTimeline parameters:parameters];
    }
    else if (btn.tag == 1)
    {
        [self shareToplatformType:SSDKPlatformSubTypeWechatSession parameters:parameters];

    }
    else if (btn.tag == 2)
    {
        [self shareToplatformType:SSDKPlatformSubTypeQZone parameters:parameters];

    }
    else if (btn.tag == 3)
    {
        [self shareToplatformType:SSDKPlatformSubTypeQQFriend parameters:parameters];

    }
    else if (btn.tag == 4)
    {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        NSString *text = [NSString stringWithFormat:@"%@ %@ %@",_shareDic[@"title"],_shareDic[@"content"],_shareDic[@"url"]];
        [dic SSDKSetupShareParamsByText:text images:_shareDic[@"imageArr"] url:[NSURL URLWithString:_shareDic[@"url"]] title:_shareDic[@"title"] type:SSDKContentTypeAuto];
        NSLog(@"%@",_shareDic[@"imageArr"]);
        [dic SSDKEnableUseClientShare];
        
       
        [ShareSDK share:SSDKPlatformTypeSinaWeibo parameters:dic onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        
//        }]
//        [ShareSDK showShareEditor:SSDKPlatformTypeSinaWeibo otherPlatformTypes:nil shareParams:dic onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
            if (state == SSDKResponseStateSuccess)
            {
                [self removeView];
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                    message:nil
                                                                   delegate:nil
                                                          cancelButtonTitle:@"确定"
                                                          otherButtonTitles:nil];
                [alertView show];
                NSLog(NSLocalizedString(@"TEXT_ShARE_SUC", @"分享成功"));
            }
            else if (state == SSDKResponseStateFail)
            {
                [self removeView];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                message:[NSString stringWithFormat:@"%@",error]
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil, nil];
                [alert show];
                
                NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), error);
                NSLog(@"%@",error);
            }
//            else
//            {
//                NSLog(@"%@",error);
//            }
        }];

    }

}
// 无UI分享视图
- (void)shareToplatformType:(SSDKPlatformType)type parameters:(NSMutableDictionary *)parameters
{
    [ShareSDK share:type parameters:parameters onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error)
     {
         if (state == SSDKResponseStateSuccess)
         {
             [self removeView];

             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                 message:nil
                                                                delegate:nil
                                                       cancelButtonTitle:@"确定"
                                                       otherButtonTitles:nil];
             [alertView show];
             NSLog(NSLocalizedString(@"TEXT_ShARE_SUC", @"分享成功"));
         }
         else if (state == SSDKResponseStateFail)
         {
             [self removeView];

             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                             message:[NSString stringWithFormat:@"%@",error]
                                                            delegate:nil
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil, nil];
             [alert show];
             
             NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), error);
             NSLog(@"%@",error);
         }
     }];

}

- (void)otherAction:(UIButton *)btn
{
    
    if (btn.tag == 10)
    {
        [self copyLink];
    }
    else if (btn.tag == 11)
    {
        [self ToReport];
    }
    else if (btn.tag == 12)
    {
        [self removePost];

    }
}



//复制链接
- (void)copyLink
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window makeToast:@"复制链接成功" duration:1 position:@"center"];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = _shareDic[@"url"];
    [self removeView];
}
//举报
- (void)ToReport
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;

    [window makeToast:@"举报成功,我们会尽快核实" duration:1 position:@"center"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *parame = [NSMutableDictionary dictionary];
    parame[@"reportid"] = _shareDic[@"tieZiID"];
    parame[@"loginuid"] = _shareDic[@"loginuid"];
    NSString *url = [NSString stringWithFormat:@"%@/index.php/Apis/Forum/setReport/",BANGHUI_URL];
    [manager POST:url parameters:parame
          success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if ([responseObject[@"success"] boolValue] == YES)
         {
             [self removeView];
         }
         else
         {
             [window makeToast:@"举报失败,请查看网络" duration:1 position:@"center"];
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [window makeToast:@"举报失败,请查看网络" duration:1 position:@"center"];
     }];

}
//删除帖子
- (void)removePost
{
    if (_delegate && [_delegate respondsToSelector:@selector(ZJShareViewRemovePost:)])
    {
        [_delegate ZJShareViewRemovePost:self];
    }
}
//刷新
- (void)refreshView
{
    if (_delegate && [_delegate respondsToSelector:@selector(ZJShareViewRefreshView:)])
    {
        [_delegate ZJShareViewRefreshView:self];
    }
}



@end
