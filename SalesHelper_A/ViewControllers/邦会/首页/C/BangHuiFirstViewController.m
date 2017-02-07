//
//  BangHuiFirstViewController.m
//  SalesHelper_A
//
//  Created by zhipu on 16/2/18.
//  Copyright © 2016年 X. All rights reserved.
//

#import "BangHuiFirstViewController.h"
#import "AppDelegate.h"
#import "UIColor+HexColor.h"
#import "BHFirstTopicCell.h"
#import "BHFirstJoinTopicCell.h"
#import "BHChatListViewController.h"
#import "PrisedViewController.h"
#import "BHPostDetailViewController.h"
#import "RequestInterface.h"
#import "BHFirstListModel.h"
#import "HWGongGaoViewController.h"
#import "HWComposeController.h"
#import "AFHTTPRequestOperationManager.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDKUI.h>
#import "HWSearchBarController.h"
#import "BHGuangGaoCell.h"
#import "BHNewPersonViewController.h"
#import "BHNewCircleViewController.h"

#import "BHFirstGuanZhuViewController.h"
#import "ZJPostCell.h"
#import "ZJPostHead.h"
#import "ZJPostFirstLikeView.h"
#import "ZJPostPicView.h"
#import "ZJPostPingLunView.h"
#import "ZJPostNewBottomBar.h"
#import "HWMessageViewController.h"
#import "HWMenuView.h"
#import "BHNewHuaTiViewController.h"
#import "BHFirstZanModel.h"
#import "HWContentsLabel.h"
#import "BHLeftModel.h"
#import "PropertyDetailViewController.h"
#import "BanghuiSearchViewController.h"
#import "LoginViewController.h"
#import "BHListHuaTiViewController.h"
#import "ModelWebViewController.h"
#import "ShareEarnViewController.h"
#import "BHNoDataView.h"
#import "ZJFMDBManager.h"
#import "NoticeWebDetailViewController.h"
#import "SVPullToRefresh.h"
#import "ZJForwardView.h"

@interface BangHuiFirstViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,ZJPostHeadDelegate,ZJPostFirstLikeViewDelegate,ZJPostNewBottomBarDelegate,UITabBarDelegate,BHNoDataViewDelegate,ZJForwardViewDelegate>

@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, strong) UIView *moreView;
@property (nonatomic, strong) UIControl *moreControl;
@property (nonatomic, strong) UILabel *slidelabel;
@property (nonatomic, strong) NSMutableArray *listArr;//首页列表数据数组
@property (nonatomic, strong) NSMutableArray *GlistArr;//首页关注列表数据数组
@property (nonatomic, assign) NSInteger page1;
@property (nonatomic, assign) NSInteger page2;
@property (nonatomic, assign) BOOL isNew;
@property (nonatomic, strong) NSString *loginuid;
@property (nonatomic, assign) BOOL isGfoot;
@property (nonatomic, strong) UIButton *btnMain;
@property (nonatomic,weak) HWMenuView *menuView;
@property (nonatomic,copy) NSString *circleOff;
@property (nonatomic,strong) UIView *messageButton;
@property (nonatomic,weak)  UIButton *cover;

@property (nonatomic,copy) NSString *is_nums;
@property (nonatomic,copy) NSString *is_icon;
@property (nonatomic, strong)BHNoDataView *imgBac;

@property (nonatomic, strong) NSMutableArray *zanArr;

@property (nonatomic, strong)BHFirstGuanZhuViewController *gVC;
@property (nonatomic, strong) UIView *topFirstView;
@property (nonatomic, strong) UIButton *btnMessage;
@property (nonatomic, strong) UIButton *btnSlide;
@property (nonatomic, strong) UIButton *btnSearch;




@end

@implementation BangHuiFirstViewController

{
    //弹出背景
    UIControl * backControl;
    UIView * backView;
    NSString * adUrlString;
}


#pragma mark-清除通知
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
- (NSMutableArray *)zanArr
{
    if (_zanArr == nil) {
        self.zanArr = [NSMutableArray array];
    }
    return _zanArr;
}
-(NSMutableArray *)listArr
{
    if (_listArr == nil) {
        self.listArr = [NSMutableArray array];
    }
    return _listArr;
}
-(NSMutableArray *)GlistArr
{
    if (_GlistArr == nil) {
        self.GlistArr = [NSMutableArray array];
    }
    return _GlistArr;
}
- (CGRect)buttonFrame{
    return _btnMain.frame;
}


//判断是否登录
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    
    
    if (viewController == [tabBarController.viewControllers objectAtIndex:3]||viewController == [tabBarController.viewControllers objectAtIndex:1]) //assuming the index of uinavigationcontroller is 2
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        //判断是否登录过
        if(![defaults boolForKey:@"SalesHelper_publicNotice"])
        {
            if ([defaults valueForKey:@"Login_User_token"] != nil) {
                return YES;
            }else {
                
                UINavigationController *loginVC = [[UINavigationController alloc] initWithRootViewController:[[LoginViewController alloc]init]];
                [self presentViewController:loginVC animated:YES completion:nil];
                
                return NO;
            }
            //存数据--->基本数据类型
        }else
        {
            return YES;
        }
    }else {
        return YES;
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"f0eff5"];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
        //点击抽屉跳到圈子
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pushToQuanZi:) name:@"pushToPage" object:nil];
        //发帖后刷新界面
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTablew:) name:@"refreshTablew" object:nil];
        //改变点赞状态
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeZanState:) name:@"changeZanState" object:nil];
        //改变关注的状态
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeGuanState:) name:@"changeGuanState" object:nil];
//     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PicViewRefresh:) name:@"PicViewRefresh" object:nil];
    
    [ZJFMDBManager openDataBase:[ZJFMDBManager shareDataBase] update:@"CREATE TABLE t_BHFirstView_table(data blob NOT NULL);"];
        NSString *longinuid =  [defaults objectForKey:@"id"];
        self.loginuid = [NSString stringWithFormat:@"%@",longinuid];
        self.page1 = 1;
        self.page2 = 1;
        _isGfoot = YES;

        [self customNavi];
//    [self requestQuanZiShoworHiddenData];

        [self createTableView];
    
//    [self selectDataBase];
//        if (self.listArr.count == 0)
//    {
        [self requestFirstListData:YES];
//    }
    
//        [self requestGuanZhuListData];
        [self requestData];
    
        [self refresh];
        
        
        
        self.isNew = YES;
        
        
        [self seupCeHuaMenu];
//    [self messageBUttonClick];


}
#pragma mark - 网络请求 - 圈子菜单关和闭
- (void)requestQuanZiShoworHiddenData
{
    
    RequestInterface *interface = [[RequestInterface alloc]init];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *city = [defaults objectForKey:@"location_City"];
    NSString *loginuid = [defaults objectForKey:@"id"];

    NSDictionary *dic = @{
                          @"city":city,
                          @"loginuid":loginuid,
                          };
    [interface requestBHQuanZiShoworHiddenWithDic:dic];
    
    [interface getInterfaceRequestObject:^(id data) {
        
            self.circleOff = data[@"datas"];

        if (![self.circleOff isKindOfClass:[NSNull class]]) {
            
            if ([self.circleOff isEqualToString:@"1"]) {
                self.btnSlide.hidden = NO;
                [self.btnSlide setImage:[UIImage imageNamed:@"mymr-1-0"] forState:(UIControlStateNormal)];
                [self.btnSlide setImage:[UIImage imageByApplyingAlpha:[UIImage imageNamed:@"mymr-1-0"]] forState:(UIControlStateHighlighted)];
                self.btnSlide.frame = CGRectMake(SCREEN_WIDTH-self.btnSlide.currentImage.size.width-10, 20, self.btnSlide.currentImage.size.width, 40);
                
                self.btnSearch.hidden = NO;
                [self.btnSearch setImage:[UIImage imageNamed:@"myss-1-0"] forState:(UIControlStateNormal)];
                [self.btnSearch setImage:[UIImage imageByApplyingAlpha:[UIImage imageNamed:@"myss-1-0"]] forState:(UIControlStateHighlighted)];
                
                self.btnSearch.frame = CGRectMake(SCREEN_WIDTH-self.btnSearch.currentImage.size.width*2-15-20, 20, self.btnSearch.currentImage.size.width, 40);
                
            }else{
                self.btnSearch.hidden = NO;
                self.btnSlide.hidden = YES;
                [self.btnSearch setImage:[UIImage imageNamed:@"myss-1-0"] forState:(UIControlStateNormal)];
                [self.btnSearch setImage:[UIImage imageByApplyingAlpha:[UIImage imageNamed:@"myss-1-0"]] forState:(UIControlStateHighlighted)];
                self.btnSearch.frame = CGRectMake(SCREEN_WIDTH-self.btnSearch.currentImage.size.width-15, 20, self.btnSearch.currentImage.size.width, 40);
            }
        }

    } Fail:^(NSError *error) {
        self.btnSearch.hidden = NO;
        self.btnSlide.hidden = YES;
        [self.btnSearch setImage:[UIImage imageNamed:@"myss-1-0"] forState:(UIControlStateNormal)];
        [self.btnSearch setImage:[UIImage imageByApplyingAlpha:[UIImage imageNamed:@"myss-1-0"]] forState:(UIControlStateHighlighted)];
        self.btnSearch.frame = CGRectMake(SCREEN_WIDTH-self.btnSearch.currentImage.size.width-15, 20, self.btnSearch.currentImage.size.width, 40);
    }];
    
   
}
- (void)requestMessageAlertData
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *loginuid = [defaults objectForKey:@"id"];
    RequestInterface *interface = [[RequestInterface alloc]init];
    NSDictionary *dic = @{
                          @"loginuid":loginuid,
                          };
    [interface requestBHMessageWithDic:dic];
    [interface getInterfaceRequestObject:^(id data)
     {
         if ([data[@"success"] boolValue] == true) {
         
              self.tableview.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
             
                 self.is_nums = data[@"datas"][@"is_nums"];
                 self.is_icon = data[@"datas"][@"is_icon"];
    
             UIView *messageButton = [[UIView alloc] init];
             messageButton.backgroundColor = [UIColor blackColor];
             messageButton.hidden = NO;
             messageButton.layer.cornerRadius = 4;
             messageButton.layer.masksToBounds = YES;
             messageButton.width = 150;
             messageButton.height = 35;
             messageButton.centerX = self.view.center.x;
             messageButton.y = 7;
             
             
             UIImageView *imageView = [[UIImageView alloc] init];
             if (self.is_icon)
             {
                 
            [imageView sd_setImageWithURL:[NSURL URLWithString:self.is_icon] placeholderImage:[UIImage imageNamed:@"默认个人图像"]];
             }
             
             imageView.x = 3;
             imageView.y = 3;
             imageView.width = 26;
             imageView.height = 26;
             imageView.layer.cornerRadius = 13;
             imageView.layer.masksToBounds = YES;
             [messageButton addSubview:imageView];
             
             
             UILabel *label = [[UILabel alloc] init];
             
             
             if (self.is_nums) {
                 
                 label.text = [NSString stringWithFormat:@"%@条新消息",self.is_nums];
             }
             label.textColor = [UIColor whiteColor];
             label.x = CGRectGetMaxX(imageView.frame) + 15;
             label.width = messageButton.width - label.x;
             label.height = messageButton.height;
             [messageButton addSubview:label];
             
             
             [messageButton addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(messageBUttonClick)]];
             
             
             self.messageButton = messageButton;
             
             [self.tableview reloadData];
         }
         } Fail:^(NSError *error)
     {

     }];

    
    
    
    
    
}

- (void)linkDidClick:(NSNotification *)note
{
    
    NSString *linkText = note.userInfo[HWLinkText];
    
    HWContentsLabel *label = note.userInfo[HWLabelself];
    
    BHFirstListModel *model = self.listArr[label.tag];
    
    NSString *uid = model.subject_id[@"id"];
    
    if ([linkText hasPrefix:@"http"]) {
        
        ModelWebViewController * VC = [[ModelWebViewController alloc]initWithUrlString:linkText NavigationTitle:@"详情"];
        VC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:VC animated:YES];
        
    }else
    {
        
        if ([linkText containsString:@"@"]) {
            
            NSString *name = [linkText substringFromIndex:1];
            
            NSArray *mentionArray = model.usercalls;
            
            
            for (NSUInteger i = 0; i < mentionArray.count; i++) {
                
                NSDictionary *dic = mentionArray[i];
                
                if ([name isEqualToString:dic[@"name"]]) {
                    
                    BHNewPersonViewController *person = [[BHNewPersonViewController alloc] init];
                    person.uid = dic[@"id"];
                    person.hidesBottomBarWhenPushed = YES;
                    
                    [self.navigationController pushViewController:person animated:YES];
                    
                }
                
            }
        }else{
         
            BHNewHuaTiViewController *HuaTi = [[BHNewHuaTiViewController alloc] init];
            
            HuaTi.huatiid = uid;
            HuaTi.uid = model.uid;
            HuaTi.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:HuaTi animated:YES];
            
            
        }
        
        
    }
}

#pragma mark-画面将要出来修改导航栏颜色
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString *longinuid =  [defaults objectForKey:@"id"];
    self.loginuid = [NSString stringWithFormat:@"%@",longinuid];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.hidden = YES;
    
    [self requestOrgCodeState];
    
//    Reachability *netWorkReachable = [Reachability reachabilityWithHostName:@"www.baidu.com"];
//    if ([netWorkReachable currentReachabilityStatus] == NotReachable)
//    {
//        
//    }
//    else
//    {
        [self requestQuanZiShoworHiddenData];
//    }
    
    RCIMClient *client = [RCIMClient sharedRCIMClient];
    
    NSInteger count = [client getTotalUnreadCount];
    
    HWLog(@"%ld",(long)count);
    if (count) {
        [self.btnMessage setImage:[UIImage imageNamed:@"消息-1"] forState:(UIControlStateNormal)];
        [self.btnMessage setImage:[UIImage imageByApplyingAlpha:[UIImage imageNamed:@"消息-1"]] forState:(UIControlStateHighlighted)];
        self.btnMessage.frame = CGRectMake(15, 20, self.btnMessage.currentImage.size.width, 40);
        [self.btnMessage addTarget:self action:@selector(messageAction:) forControlEvents:(UIControlEventTouchUpInside)];
        
    }else{
        
        [self.btnMessage setImage:[UIImage imageNamed:@"mybh-1-0"] forState:(UIControlStateNormal)];
        [self.btnMessage setImage:[UIImage imageByApplyingAlpha:[UIImage imageNamed:@"mybh-1-0"]] forState:(UIControlStateHighlighted)];
        self.btnMessage.frame = CGRectMake(15, 20, self.btnMessage.currentImage.size.width, 40);
        [self.btnMessage addTarget:self action:@selector(messageAction:) forControlEvents:(UIControlEventTouchUpInside)];

        
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(linkDidClick:) name:HWLinkDidClickNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeFram:) name:@"changeFram" object:nil];
    
//        [self.navigationController.navigationBar setBackgroundImage:[self imageWithBgColor:[UIColor colorWithRed:23/255.0f green:183/255.0f blue:242/255.0f alpha:1]] forBarMetrics:UIBarMetricsDefault];
//        
//        [self.navigationController.navigationBar setShadowImage:[self imageWithBgColor:[UIColor colorWithRed:23/255.0f green:183/255.0f blue:242/255.0f alpha:1]]];

    if (GetUserID != nil)
    {
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self loadLoginAdForIndex];
//        });
    }
    
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    self.btnMain.hidden = YES;
//    self.navigationController.navigationBar.translucent = YES;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"changeFram" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:HWLinkDidClickNotification object:nil];;
}

#pragma mark -- 第一次启动时广告
-(void)loadLoginAdForIndex
{
    
    RequestInterface * adInterface = [[RequestInterface alloc]init];
    NSDictionary * dict = @{
                            @"token":GetUserID,
                            @"type":@"1",
                            @"ispage":@"2"
                            };
    [adInterface requestLoginAdPresentWithParam:dict];
    
    [adInterface getInterfaceRequestObject:^(id data) {
        NSLog(@"adlogin  %@",data);
        
        
        if ([[data objectForKey:@"success"] boolValue])
        {
            if (data[@"datas"] != [NSNull null] &&
                data[@"datas"] != nil &&
                data[@"datas"])
            {
                backControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
                backControl.backgroundColor = [UIColor clearColor];
                backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
                backView.backgroundColor = [UIColor colorWithRed:0 green:0 blue: 0 alpha:0.5];
                
                [backControl addSubview:backView];
                
                adUrlString = [data[@"datas"] objectForKey:@"urls"];
                UIButton* imageBtn = [[UIButton alloc]initWithFrame:CGRectMake(40, 80, SCREEN_WIDTH-80, (SCREEN_WIDTH - 80)*4/3)];
                [imageBtn setBackgroundColor: [UIColor redColor]];
                imageBtn.layer.cornerRadius = 5;
                imageBtn.layer.masksToBounds = YES;
                [imageBtn addTarget:self action:@selector(tapAdImageToDetail:) forControlEvents:UIControlEventTouchUpInside];
                if (SCREEN_WIDTH == 320)
                {
                    
                    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",REQUEST_IMG_SERVER_URL,[data[@"datas"] objectForKey:@"imgpath_sm"]]];
                    NSData * data = [NSData dataWithContentsOfURL:url];
                    UIImage* image = [UIImage imageWithData:data];
                    [imageBtn setBackgroundImage:image forState:UIControlStateNormal];
                }
                else
                {
                    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",REQUEST_IMG_SERVER_URL,[data[@"datas"] objectForKey:@"imgpath_md"]]];
                    NSData * data = [NSData dataWithContentsOfURL:url];
                    UIImage* image = [UIImage imageWithData:data];
                    [imageBtn setBackgroundImage:image forState:UIControlStateNormal];
                }
                [backView addSubview:imageBtn];
                
                UIButton* colseBtn = [[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-40)/2, CGRectGetMaxY(imageBtn.frame) + 10, 40, 40)];
                [colseBtn setImage:[UIImage imageNamed:@"关闭"] forState:UIControlStateNormal];
                colseBtn.alpha = 1;
                [colseBtn addTarget:self action:@selector(hiddenView:) forControlEvents:UIControlEventTouchUpInside];
                [backView addSubview:colseBtn];
                UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
                [keyWindow addSubview:backControl];
            }
        }
    } Fail:^(NSError *error) {
    }];
}
- (void)hiddenView:(UIControl *)control
{
    [UIView animateWithDuration:0.3 animations:^{
        backControl.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.0];
        [backView removeFromSuperview];
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [backControl removeFromSuperview];
        
    });
}

-(void)tapAdImageToDetail:(UIButton*)sender
{
    NSLog(@"%@",adUrlString);
    [backControl removeFromSuperview];
    ModelWebViewController * VC = [[ModelWebViewController alloc]initWithUrlString:adUrlString NavigationTitle:@"广告详情"];
    VC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:VC animated:YES];
}



- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!_btnMain)
    {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        self.btnMain = [UIButton buttonWithType:(UIButtonTypeCustom)];
        self.btnMain.frame = CGRectMake(SCREEN_WIDTH/2-26, SCREEN_HEIGHT-49-26, 52, 52);
        [self.btnMain setImage:[UIImage imageNamed:@"myadd-1-0"] forState:(UIControlStateNormal)];
        [self.btnMain addTarget:self action:@selector(pushToSub) forControlEvents:(UIControlEventTouchUpInside)];
        self.btnMain.alpha = 1;
//        [UIView animateWithDuration:0.6 animations:^{
//            self.btnMain.alpha = 1;
//        }];
        CAKeyframeAnimation *k = [CAKeyframeAnimation  animationWithKeyPath:@"transform.scale"];
        k.values = @[@(0.1),@(0.5),@(1)];
        k.keyTimes = @[@(0.0),@(0.5),@(1)];
        k.calculationMode = kCAAnimationLinear;
        [self.btnMain.layer addAnimation:k forKey:@"SHOW"];
        
        CABasicAnimation *anima=[CABasicAnimation animation];
        
            //1.1告诉系统要执行什么样的动画
            anima.keyPath=@"position";
             //设置通过动画，将layer从哪儿移动到哪儿
            anima.fromValue=[NSValue valueWithCGPoint:CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT)];
             anima.toValue=[NSValue valueWithCGPoint:CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT-49)];
        
             //1.2设置动画执行完毕之后不删除动画
            anima.removedOnCompletion=NO;
            //1.3设置保存动画的最新状态
            anima.fillMode=kCAFillModeForwards;
        anima.duration = 0.15;
            //2.添加核心动画到layer
            [self.btnMain.layer addAnimation:anima forKey:nil];
        
        
//        UIPanGestureRecognizer * panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
//                                                                                                action:@selector(doHandlePanAction:)];
//        [self.btnMain addGestureRecognizer:panGestureRecognizer];
        [window addSubview:self.btnMain];
    }
    else
    {
        self.btnMain.hidden = NO;
//        self.btnMain.alpha = 0;
//        [UIView animateWithDuration:0.6 animations:^{
//            self.btnMain.alpha = 1;
//        }];
        CABasicAnimation *anima=[CABasicAnimation animation];
        
        //1.1告诉系统要执行什么样的动画
        anima.keyPath=@"position";
        //设置通过动画，将layer从哪儿移动到哪儿
        anima.fromValue=[NSValue valueWithCGPoint:CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT)];
        anima.toValue=[NSValue valueWithCGPoint:CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT-49)];
        
        //1.2设置动画执行完毕之后不删除动画
        anima.removedOnCompletion=NO;
        //1.3设置保存动画的最新状态
        anima.fillMode=kCAFillModeForwards;
        anima.duration = 0.15;
        //2.添加核心动画到layer
        [self.btnMain.layer addAnimation:anima forKey:nil];
        
        CAKeyframeAnimation *k = [CAKeyframeAnimation  animationWithKeyPath:@"transform.scale"];
        k.values = @[@(0.1),@(0.5),@(1)];
        k.keyTimes = @[@(0.0),@(0.5),@(1)];
        k.calculationMode = kCAAnimationLinear;
        [self.btnMain.layer addAnimation:k forKey:@"SHOW"];
    }

}
//拖动动画
//- (void) doHandlePanAction:(UIPanGestureRecognizer *)paramSender{
//    
//    CGPoint point = [paramSender translationInView:self.btnMain];
//    NSLog(@"X:%f;Y:%f",point.x,point.y);
//    
//    paramSender.view.center = CGPointMake(paramSender.view.center.x + point.x, paramSender.view.center.y + point.y);
//    
//    [paramSender setTranslation:CGPointMake(0, 0) inView:self.btnMain];
//    
//    
//}
#pragma mark - 网络请求－首页列表
- (void)requestFirstListData:(BOOL)isdelete
{
    
//    [self.view Loading_0314];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *city = [defaults objectForKey:@"location_City"];
    NSString *longinuid =  [defaults objectForKey:@"id"];
    RequestInterface *interface = [[RequestInterface alloc]init];
    
    Reachability *netWorkReachable = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    if ([netWorkReachable currentReachabilityStatus] == NotReachable)
    {
        //查询
        [self selectDataBase];
//        [self.view Hidden];
        [self.tableview.infiniteScrollingView stopAnimating];
    }
    else
    {
        NSDictionary *dic = @{
                              @"city":city,
                              @"loginuid":longinuid,
                              @"p":@(_page1),
                              };
        [interface requestBHFirstListWithDic:dic];
        [interface getInterfaceRequestObject:^(id data)
         {
             if ([data[@"success"] boolValue] == YES)
             {
//                 NSLog(@"%@",data);
                 self.imgBac.hidden = YES;//无数据的底部视图
                 if ([data[@"datas"] count] != 0)
                 {
                     if (isdelete == YES)
                     {
                         //删除
                         [self deleteDB];

                         [self.listArr removeAllObjects];
                         [self.zanArr removeAllObjects];
                     }
                     for (NSDictionary *dict in data[@"datas"])
                     {
                         BHFirstListModel *model = [[BHFirstListModel alloc]init];
                         [model setValuesForKeysWithDictionary:dict];
                        [self.listArr addObject:model];
                         
                         if (isdelete == YES) {
                             //插入
                             [self archiverForModel:model];
                         }
                         
                         NSMutableArray *arr = [NSMutableArray array];
                         for (NSDictionary *dicti in model.zan)
                         {
                             BHFirstZanModel *model = [[BHFirstZanModel alloc]init];
                             [model setValuesForKeysWithDictionary:dicti];
                             [arr addObject:model];
                         }
                        [self.zanArr addObject:arr];
                     }
//                     [self.view Hidden];
                     [self.tableview reloadData];
                     [self.tableview.infiniteScrollingView stopAnimating];

                 }
                 else
                 {
//                     [self.view Hidden];
                     [self.tableview.infiniteScrollingView stopAnimating];
                     [self.view makeToast:data[@"message"]];
                 }
             }else
             {
//                 [self.view Hidden];
                 [self.tableview.infiniteScrollingView stopAnimating];
                 [self.view makeToast:data[@"message"]];
                 
             }
         } Fail:^(NSError *error)
         {
             [self.view makeToast:@"请求失败"];
             self.imgBac.backgroundColor = [UIColor whiteColor];
             //        self.imgBac.image = [UIImage imageNamed:@"暂无内容默认图片"];
             self.imgBac.hidden = NO;
//             [self.view Hidden];
             [self.tableview.infiniteScrollingView stopAnimating];
         }];
    }
    
    
    if ([netWorkReachable currentReachabilityStatus] == NotReachable)
    {
    }else
    {
        [self requestMessageAlertData];
    }


   
    RCIMClient *client = [RCIMClient sharedRCIMClient];
    
    NSInteger count = [client getTotalUnreadCount];
    
    
    if (count) {

        [self.btnMessage setImage:[UIImage imageNamed:@"消息-1"] forState:(UIControlStateNormal)];
        self.btnMessage.frame = CGRectMake(15, 20, self.btnMessage.currentImage.size.width, 40);
        [self.btnMessage addTarget:self action:@selector(messageAction:) forControlEvents:(UIControlEventTouchUpInside)];
        
    }else{
        
        [self.btnMessage setImage:[UIImage imageNamed:@"mybh-1-0"] forState:(UIControlStateNormal)];
        self.btnMessage.frame = CGRectMake(15, 20, self.btnMessage.currentImage.size.width, 40);
        [self.btnMessage addTarget:self action:@selector(messageAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }

}
#pragma mark - 网路请求－圈子
- (void)requestData
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *city = [defaults objectForKey:@"location_City"];
    NSMutableArray *arr = [NSMutableArray array];
    
    RequestInterface *intreface = [[RequestInterface alloc]init];
    NSDictionary *dic = @{
                          @"city":city,
                          @"loginuid":self.loginuid,
                          };
    [intreface requestBHLeftDataWith:dic];
    [intreface getInterfaceRequestObject:^(id data)
     {
         if ([data[@"success"] boolValue] == YES)
         {
             for (NSDictionary *dict in data[@"datas"])
             {
                 BHLeftModel *model = [[BHLeftModel alloc]init];
                 [model setValuesForKeysWithDictionary:dict];
                 [arr addObject:model];
             }
             self.menuView.dataArr = arr;
             [self.menuView tableViewReloadData];
         }
         
     } Fail:^(NSError *error)
     {
         
     }];
}


#pragma mark -自定义导航栏
- (void)customNavi
{
    self.topFirstView = [[UIView alloc]init];
    self.topFirstView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 64);
    self.topFirstView.backgroundColor = [UIColor colorWithHexString:@"00aff0"];
    [self.view addSubview:self.topFirstView];
    
    UIView *slideTopView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(returnTop)];
    slideTopView.backgroundColor = [UIColor clearColor];
    [slideTopView addGestureRecognizer:tap];
    [self.topFirstView addSubview:slideTopView];
    
    self.btnMessage = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.topFirstView addSubview:self.btnMessage];
    
    UIButton *newBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [newBtn setTitle:@"最新" forState:(UIControlStateNormal)];
    newBtn.frame = CGRectMake(SCREEN_WIDTH/2 - 40-10, 20, 40, 40);
    [newBtn addTarget:self action:@selector(changeNew) forControlEvents:(UIControlEventTouchUpInside)];
    newBtn.backgroundColor = [UIColor clearColor];
    [self.topFirstView addSubview:newBtn];
    
    UIButton *guanZhuBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [guanZhuBtn setTitle:@"关注" forState:(UIControlStateNormal)];
    guanZhuBtn.frame = CGRectMake(SCREEN_WIDTH/2+10, 20, 40, 40);
    guanZhuBtn.backgroundColor = [UIColor clearColor];
    [guanZhuBtn addTarget:self action:@selector(changeGuanzhu) forControlEvents:(UIControlEventTouchUpInside)];
    [self.topFirstView addSubview:guanZhuBtn];
    
    self.slidelabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 40-10, 60, 40, 3)];
    self.slidelabel.backgroundColor = [UIColor whiteColor];
    [self.topFirstView addSubview:self.slidelabel];
    
    self.btnSlide = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnSlide addTarget:self action:@selector(ceHua) forControlEvents:(UIControlEventTouchUpInside)];
    [self.topFirstView addSubview:self.btnSlide];
    self.btnSlide.hidden = YES;
    
    
    self.btnSearch = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnSearch addTarget:self action:@selector(seachAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.topFirstView addSubview:self.btnSearch];
    self.btnSearch.hidden = YES;
    
}

- (void)returnTop
{
    if (self.mainScrollView.contentOffset.x == 0)
    {
        self.tableview.contentOffset = CGPointMake(0, 0);

    }else if (self.mainScrollView.contentOffset.x == SCREEN_WIDTH)
    {
        self.gVC.tableview.contentOffset = CGPointMake(0, 0);

    }
}

#pragma mark 最新页面数据切换
- (void)changeNew
{
    self.isNew = YES;
    self.tableview.scrollsToTop = YES;
    UITableView *table = [self.gVC.view viewWithTag:333];
    table.scrollsToTop = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.slidelabel.frame = CGRectMake(SCREEN_WIDTH/2 - 40-10, 60, 40, 3);
        self.mainScrollView.contentOffset = CGPointMake(0, 0);
    }];
}
#pragma mark 关注页面数据切换
- (void)changeGuanzhu
{
    self.isNew = NO;
    self.tableview.scrollsToTop = NO;
    UITableView *table = [self.gVC.view viewWithTag:333];
    table.scrollsToTop = YES;
    [UIView animateWithDuration:0.3 animations:^{
        self.slidelabel.frame = CGRectMake(SCREEN_WIDTH/2+10, 60, 40, 3);
        self.mainScrollView.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
    }];
    
}
#pragma mark - 消息按钮的事件
- (void)messageAction:(UIBarButtonItem *)bar
{
    [self pushToMessage];
}
#pragma mark - 搜索按钮的事件
- (void)seachAction:(UIBarButtonItem *)bar
{
    [self pushToSeach];
}
- (void)messageBUttonClick
{
    
    self.messageButton = nil;
    [self.tableview reloadData];
    
    HWMessageViewController *message = [[HWMessageViewController alloc] init];
    message.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:message animated:YES];
    
    
}
#pragma mark 赞的按钮的动画
- (void)zanAnimation:(UIButton *)button
{
    CAKeyframeAnimation *k = [CAKeyframeAnimation  animationWithKeyPath:@"transform.scale"];
    k.values = @[@(0.1),@(1.0),@(1.5)];
    k.keyTimes = @[@(0.0),@(0.5),@(0.8),@(0.8)];
    k.calculationMode = kCAAnimationLinear;
    [button.layer addAnimation:k forKey:@"SHOW"];
}

//#pragma mark-侧滑栏功能
//- (void)ceHua:(UIBarButtonItem *)bar
//{
//    
//    LeftSlideViewController* slideVC =(LeftSlideViewController*)[UIApplication sharedApplication].keyWindow.rootViewController;
//    if (slideVC.closed) {
//        [slideVC openLeftView];
//    }else{
//        [slideVC closeLeftView];
//    }
//}

/**
 *  弹出侧滑菜单
 */
- (void)seupCeHuaMenu
{
    
    HWMenuView *menuView = [HWMenuView menuView];
    menuView.height = self.view.height;
    menuView.width = self.view.width * 0.7;
    menuView.x = self.view.width;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:menuView];
    
    self.menuView = menuView;
    
}
#pragma mark-创建tableView
- (void)createTableView
{
    
    
    
    self.mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64-49)];
    self.mainScrollView.delegate = self;
    self.mainScrollView.scrollsToTop = NO;
    self.mainScrollView.contentSize = CGSizeMake(SCREEN_WIDTH*2, 0);
    self.mainScrollView.showsHorizontalScrollIndicator = FALSE;
    self.mainScrollView.pagingEnabled = YES;
    self.mainScrollView.bounces = NO;
//    BHFirstGuanZhuViewController *gVC = [[BHFirstGuanZhuViewController alloc]init];
//    gVC.view.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
//    [self.mainScrollView addSubview:gVC.view];
    
    
    
    
    self.tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-49) style:UITableViewStyleGrouped];
    self.tableview.delegate = self;
    self.tableview.estimatedRowHeight = 245;
    self.tableview.dataSource = self;
    self.tableview.scrollsToTop = YES;
    [self.tableview registerClass:[ZJPostCell class] forCellReuseIdentifier:@"ZJPostCell"];
    [self.tableview registerClass:[BHFirstTopicCell class] forCellReuseIdentifier:@"BHFirstTopicCell"];
    [self.tableview registerClass:[BHGuangGaoCell class] forCellReuseIdentifier:@"BHGuangGaoCell"];
    [self.tableview registerClass:[BHFirstJoinTopicCell class] forCellReuseIdentifier:@"BHFirstJoinTopicCell"];
    self.tableview.separatorStyle = UITableViewCellAccessoryNone;
    
//    self.tableview.separatorStyle = UITableViewCellAccessoryNone;
    [self.mainScrollView addSubview:self.tableview];
    
    

    self.gVC = [[BHFirstGuanZhuViewController alloc]init];
    self.gVC.view.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-49);
    [self addChildViewController:self.gVC];
    [self.mainScrollView addSubview:self.gVC.view];
    [self.view addSubview:self.mainScrollView];
    
    self.imgBac = [[BHNoDataView alloc]init];
    self.imgBac.hidden = YES;
    self.imgBac.frame = self.tableview.frame;
    self.imgBac.contentMode = UIViewContentModeCenter;
    self.imgBac.delegate = self;
    [self.mainScrollView addSubview:self.imgBac];
   
}
#pragma mark - 刷新
- (void)refresh
{
    __block BangHuiFirstViewController *test = self;
//    [self.tableview headerBeginRefreshing];
    //判断网络状态
    
    [self.tableview addHeaderWithCallback:^{
        Reachability *netWorkReachable = [Reachability reachabilityWithHostName:@"www.baidu.com"];
        if ([netWorkReachable currentReachabilityStatus] == NotReachable)
        {
            [test.tableview headerEndRefreshing];
        }else
        {
            test.page1 = 1;
            [test requestFirstListData:YES];
            [test.tableview headerEndRefreshing];
        }
    }];
    
    [self.tableview triggerPullToRefresh];
    [self.tableview addInfiniteScrollingWithActionHandler:^{
        Reachability *netWorkReachable = [Reachability reachabilityWithHostName:@"www.baidu.com"];
        if ([netWorkReachable currentReachabilityStatus] == NotReachable)
        {
            [test.tableview.infiniteScrollingView stopAnimating];
        }else
        {
            test.page1 ++;
            [test requestFirstListData:NO];
        }
        
    }];
}
#pragma mark-UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//    if (tableView.tag == 200)
//    {
        return self.listArr.count;

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BHFirstListModel *model = self.listArr[indexPath.section];
    if ([model.type isEqualToString:@"1"]) {
        ZJPostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZJPostCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.zanArr = self.zanArr[indexPath.section];
        
        cell.postHeadView.loginuid = self.loginuid;
        
        cell.model = model;
        
        cell.postHeadView.btnGuanZhu.tag = indexPath.section;
        cell.postHeadView.imgHead.tag = [model.uid integerValue];
        cell.postHeadView.delegate = self;
        
        cell.postNewBar.delegate = self;
        cell.postNewBar.btnComm.tag = indexPath.section;
        cell.postNewBar.btnZan.tag = indexPath.section;
        cell.postNewBar.btnShare.tag = indexPath.section;
        
        cell.postPingView.likeView.delegate = self;
        cell.postPingView.likeView.indexpath = indexPath;
        cell.lblbody.tag = indexPath.section;
        
//        cell.postPicView.delegate = self;
        cell.postPicView.indexpath = indexPath;
        
        cell.postPingView.likeView.btnZanCount.tag = [model.tieZiID integerValue];
        
        
        cell.forwardView.delegate = self;
        cell.forwardView.indexpath = indexPath;
        return cell;
        
    }
    if ([model.type isEqualToString:@"2"] || [model.type isEqualToString:@"5"]) {
            BHFirstTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BHFirstTopicCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell cellForModel:model];
        cell.headerView.delegate = self;
        cell.headerView.indexpath = indexPath;
        if ([model.type isEqualToString:@"2"])
        {
            cell.headerView.lblName.tag = 2;
        }
        else if ([model.type isEqualToString:@"5"])
        {
            cell.headerView.lblName.tag = 3;
        }
        return cell;

        }
   
    if ([model.type isEqualToString:@"4"]) {
            BHGuangGaoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BHGuangGaoCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell cellForModel:model];
            return cell;
        }
    else
        {
            BHFirstJoinTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BHFirstJoinTopicCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell cellForModel:model];
            cell.headerView.delegate = self;
            cell.headerView.lblName.tag = 1;
            cell.headerView.indexpath = indexPath;

            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(JumpComm:)];
            cell.lblHuaTi.tag = indexPath.section;
            [cell.lblHuaTi addGestureRecognizer:tap];
            cell.lblHuaTi.userInteractionEnabled = YES;
            
            return cell;
        }
}
- (void)JumpComm:(UITapGestureRecognizer *)tap
{
    if ([GetOrgType isEqualToString:@"2"])
    {
        BHFirstListModel *model = self.listArr[tap.view.tag];
        HWComposeController *subVC = [[HWComposeController alloc]init];
        UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:subVC];
        subVC.subject_id = model.tieZiID;
        subVC.subjectTitle = model.topic;
        [self presentViewController:navi animated:YES completion:nil];
    }
    else
    {
        [self zanErrorAlertView:nil message:@"您无权限进行此操作，请先绑定机构码"];
    }

}

//- (void)jumpListHuaTi:(UITapGestureRecognizer *)tap
-(void)clikeNameLabelAction:(ZJPostHead *)postHead
{
    BHFirstListModel *model = self.listArr[postHead.indexpath.section];
    
    if ([model.type isEqualToString:@"2"] || [model.type isEqualToString:@"3"] || [model.type isEqualToString:@"5"])
    {
        BHListHuaTiViewController *listVC = [[BHListHuaTiViewController alloc]init];
        listVC.hidesBottomBarWhenPushed = YES;
        if (postHead.lblName.tag == 1) {
            listVC.isList = @"1";
        }else if(postHead.lblName.tag == 2)
        {
            listVC.isList = @"2";
        }else if (postHead.lblName.tag == 3)
        {
            listVC.isList = @"3";
        }
        [self.navigationController pushViewController:listVC animated:YES];
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    BHFirstListModel *model = self.listArr[indexPath.section];
    return  [ZJPostCell heightForModel:model zanArr:self.zanArr[indexPath.section]];

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BHFirstListModel *model = self.listArr[indexPath.section];
    if ([model.type isEqualToString:@"1"])
    {
        
    [self pushToPostDetail:indexPath.section keyboardShow:NO];
        
    }
    else if ([model.type isEqualToString:@"2"]) {
        [self pushToGongGao:model.tieZiID];
    }
    else if  ([model.type isEqualToString:@"3"]) {
        [self pushToHuaTi:model];
    }
    else if ([model.type isEqualToString:@"5"])
    {
        HWGongGaoViewController *gongGaoVC = [[HWGongGaoViewController alloc]init];
        gongGaoVC.hidesBottomBarWhenPushed = YES;
        gongGaoVC.postID = model.tieZiID;
        gongGaoVC.isBangSchool = YES;
        [self.navigationController pushViewController:gongGaoVC animated:YES];
    }
    else
    {
        BHFirstListModel *model = self.listArr[indexPath.section];
        if ([model.indexImgType isEqualToString:@"1"]) {
            
        }
        else if ([model.indexImgType isEqualToString:@"2"])
        {
            PropertyDetailViewController *PropertyDetailVC = [[PropertyDetailViewController alloc]init];
            PropertyDetailVC.ID = model.indexImgUrl;
            PropertyDetailVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:PropertyDetailVC animated:YES];
        }
        else if ([model.indexImgType isEqualToString:@"3"])
        {
            NoticeWebDetailViewController * web = [[NoticeWebDetailViewController alloc]initWithUrlString:model.indexImgUrl NavigationTitle:@"公告"];
            web.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:web animated:YES];
        }
        else if ([model.indexImgType isEqualToString:@"4"])
        {
            
                ShareEarnViewController *vc = [[ShareEarnViewController alloc] init];
                NSDictionary *dic = [NSDictionary dictionaryWithObject:model.indexImgUrl forKey:@"logshareurl"];
                vc.shareDict = dic;
                [self.navigationController pushViewController:vc animated:YES];
                
        }
        else if ([model.indexImgType isEqualToString:@"5"])
        {

            BHPostDetailViewController *detailVC = [[BHPostDetailViewController alloc]init];
            detailVC.hidesBottomBarWhenPushed = YES;
            detailVC.tieZiID = model.indexImgUrl;
            detailVC.isMessageVC = YES;
            [self.navigationController pushViewController:detailVC animated:YES];
        }
        else
        {
            [self pushToGongGao:model.indexImgUrl];
        }

    }

}



#pragma mark -跳转到发帖页面
- (void)pushToSub
{
    if ([GetOrgType isEqualToString:@"2"])
    {
        HWComposeController *subVC = [[HWComposeController alloc]init];
        UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:subVC];
        [self presentViewController:navi animated:YES completion:nil];
    }
    else
    {
        [self zanErrorAlertView:nil message:@"您无权限进行此操作，请先绑定机构码"];
    }
}

#pragma mark -跳转到公告页面
- (void)pushToGongGao:(NSString *)postID
{
    HWGongGaoViewController *gongGaoVC = [[HWGongGaoViewController alloc]init];
    gongGaoVC.hidesBottomBarWhenPushed = YES;
    gongGaoVC.postID = postID;
    [self.navigationController pushViewController:gongGaoVC animated:YES];
}
#pragma mark-跳转到话题页面
- (void)pushToHuaTi:(BHFirstListModel *)model
{
    BHNewHuaTiViewController *huatiVC = [[BHNewHuaTiViewController alloc]init];
    huatiVC.hidesBottomBarWhenPushed = YES;
    huatiVC.uid = model.uid;
    huatiVC.huatiid = model.tieZiID;
//    huatiVC.subid = model.subject_id[@""]
    [self.navigationController pushViewController:huatiVC animated:YES];
}

#pragma mark-跳转到消息页面
- (void)pushToMessage
{
    BHChatListViewController *searVC = [[BHChatListViewController alloc]init];
    searVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:searVC animated:YES];
}
#pragma mark-跳转到搜索页面
- (void)pushToSeach
{

    BanghuiSearchViewController * VC = [[BanghuiSearchViewController alloc]init];
    VC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:VC animated:YES];

}
#pragma mark-通知跳转圈子页面
- (void)pushToQuanZi:(NSNotification *)noti
{
    
//    LeftSlideViewController* slideVC =(LeftSlideViewController*)[UIApplication sharedApplication].keyWindow.rootViewController;
//    [slideVC closeLeftView];
    BHNewCircleViewController *circleVC = [[BHNewCircleViewController alloc]init];
    BHLeftModel *leftModel = noti.userInfo[@"leftModel"];
    circleVC.model = leftModel;
    circleVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:circleVC animated:YES];
    [self menuViewHidden];
}

- (void)refreshTablew:(NSNotification *)noti
{
    _page1 = 1;
    [self requestFirstListData:YES];
}

#pragma mark-UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if (section == 0) {
        
        if (!self.messageButton) {
            
            return nil;
            
        }else{
            
            UIView *view = [[UIView alloc] init];
            view.height = 50;
            
            [view addSubview:self.messageButton];
            
            return view;
        }
    }else{
        
        return nil;
    }
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        
        if (!self.messageButton) {
            return 0.01;
            
        }else{
            return 50;
        }
        
    } else {
        return 8;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat x = self.mainScrollView.contentOffset.x;
    if (x >= SCREEN_WIDTH )
    {
        self.isNew = NO;
        self.tableview.scrollsToTop = NO;
        UITableView *table = [self.gVC.view viewWithTag:333];
        table.scrollsToTop = YES;
        [UIView animateWithDuration:0.3 animations:^{
            self.slidelabel.frame = CGRectMake(SCREEN_WIDTH/2+10, 60, 40, 3);
        }];
    }
    else
    {
        self.isNew = YES;
        self.tableview.scrollsToTop = YES;
        UITableView *table = [self.gVC.view viewWithTag:333];
        table.scrollsToTop = NO;
        [UIView animateWithDuration:0.3 animations:^{
            self.slidelabel.frame = CGRectMake(SCREEN_WIDTH/2 - 40-10, 60, 40, 3);
        }];
    }
}

#pragma mark - 自定义View代理
//关注
-(void)clikeGuanZhuButtonAction:(ZJPostHead *)postHead
{
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([GetOrgType isEqualToString:@"2"])
    {
        BHFirstListModel *model = self.listArr[postHead.btnGuanZhu.tag];
        postHead.btnGuanZhu.selected = !postHead.btnGuanZhu.selected;
        if (postHead.btnGuanZhu.selected == YES)
        {
            for (int i = 0; i < self.listArr.count; i++)
            {
                BHFirstListModel *lModel = self.listArr[i];
                if ([model.uid isEqualToString:lModel.uid])
                {

                    lModel.isfocus = @"333";
                }
            }
            [self.tableview reloadData];
            [self alertView:nil message:@"关注成功"];
        }
        else
        {
            for (int i = 0; i < self.listArr.count; i++)
            {
                BHFirstListModel *lModel = self.listArr[i];
                if ([model.uid isEqualToString:lModel.uid])
                {
                    lModel.isfocus = nil;
                }
            }
            [self.tableview reloadData];
            [self alertView:nil message:@"取消关注"];
        }
        
        
        RequestInterface *interface = [[RequestInterface alloc]init];
        NSLog(@"%@ %@",model.uid,self.loginuid);
        NSDictionary *dic = @{
                              @"uid":model.uid,
                              @"loginuid":self.loginuid,
                              };
        [interface requestBHGuanZhuWithDic:dic];
        [interface getInterfaceRequestObject:^(id data)
         {
             if ([data[@"success"] boolValue] == YES)
             {
                 
                 
             }
             else
             {
                 
                 
             }
         } Fail:^(NSError *error)
         {
             [self zanErrorAlertView:@"提示" message:@"抱歉，关注失败"];
         }];
        
    }else
    {
        [self zanErrorAlertView:nil message:@"您无权限进行此操作，请先绑定机构码"];
    }
    
}
//跳转个人页面
-(void)tapImgJumpPageAction:(ZJPostHead *)postHead
{
    BHFirstListModel *model = self.listArr[postHead.indexpath.section];
    if ([model.type isEqualToString:@"2"] || [model.type isEqualToString:@"3"] || [model.type isEqualToString:@"5"])
    {
        BHListHuaTiViewController *listVC = [[BHListHuaTiViewController alloc]init];
        listVC.hidesBottomBarWhenPushed = YES;
        if (postHead.lblName.tag == 1) {
            listVC.isList = @"1";
        }else if(postHead.lblName.tag == 2)
        {
            listVC.isList = @"2";
        }else if (postHead.lblName.tag == 3)
        {
            listVC.isList = @"3";
        }
        [self.navigationController pushViewController:listVC animated:YES];
    }
    else
    {
        BHNewPersonViewController *personVC = [[BHNewPersonViewController alloc]init];
        personVC.hidesBottomBarWhenPushed = YES;
        personVC.uid = [NSString stringWithFormat:@"%ld",(long)postHead.imgHead.tag];
        [self.navigationController pushViewController:personVC animated:YES];
    }
}
//跳转个人页面
- (void)tapLikeHeadImgJumpPageAction:(ZJPostFirstLikeView *)postLikeView
{
    BHFirstZanModel *zanModel = self.zanArr[postLikeView.indexpath.section][postLikeView.n];
    BHNewPersonViewController *personVC = [[BHNewPersonViewController alloc]init];
    personVC.hidesBottomBarWhenPushed = YES;
    personVC.uid = [NSString stringWithFormat:@"%ld",(long)zanModel.uid];
    [self.navigationController pushViewController:personVC animated:YES];
}
//跳转点过赞的人列表页面
-(void)clickJumpPageLikePeopleButtonAction:(ZJPostFirstLikeView *)postLikeView
{
    PrisedViewController *prisedVC = [[PrisedViewController alloc]init];
    NSString *ID = [NSString stringWithFormat:@"%ld",(long)postLikeView.btnZanCount.tag];
    prisedVC.postID = ID;
    prisedVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:prisedVC animated:YES];
}

-(void)clickBarButtonZan:(ZJPostNewBottomBar *)psstBar
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *loginuid = [defaults objectForKey:@"id"];

    if ([GetOrgType isEqualToString:@"2"])
    {
        [self zanAnimation:psstBar.btnZan];
        
        BHFirstListModel *model = self.listArr[psstBar.btnZan.tag];
        psstBar.btnZan.selected = !psstBar.btnZan.selected;
        [self zanAnimation:psstBar.btnZan];
        if (psstBar.btnZan.selected == YES)
        {
            [psstBar.btnZan setImage:[UIImage imageNamed:@"点赞之后"] forState:(UIControlStateNormal)];
            
            NSInteger count = [model.nums integerValue];
            count += 1;
            model.nums = [NSString stringWithFormat:@"%ld",(long)count];
            [psstBar changeZanCount:count];
            
            model.ispraise = @"333";
            NSString *face = [defaults objectForKey:@"login_User_face"];
            NSString *str = [NSString stringWithFormat:@"http://app.hfapp.cn/%@",face];

            NSDictionary  *dic = @{@"uid":loginuid,@"iconpath":str};
            BHFirstZanModel *zanModel = [[BHFirstZanModel alloc]init];
            [zanModel setValuesForKeysWithDictionary:dic];
            [self.zanArr[psstBar.btnZan.tag] insertObject:zanModel atIndex:0];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:psstBar.btnZan.tag];
//                [self.tableview reloadData];
                [self.tableview reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            });

        }
        else
        {
            [psstBar.btnZan setImage:[UIImage imageNamed:@"点赞"] forState:(UIControlStateNormal)];
            model.ispraise = nil;
            
            NSInteger count = [model.nums integerValue];
            count -= 1;
            model.nums = [NSString stringWithFormat:@"%ld",(long)count];
            [psstBar changeZanCount:count];
            
            for (int i = 0; i < [self.zanArr[psstBar.btnZan.tag] count]; i++) {
                BHFirstZanModel *zanModel = self.zanArr[psstBar.btnZan.tag][i];
              
                if (zanModel.uid == [loginuid integerValue])
                {
                    [self.zanArr[psstBar.btnZan.tag] removeObjectAtIndex:i];
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        
                        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:psstBar.btnZan.tag];
//                        [self.tableview reloadData];
                        [self.tableview reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                    });

                }else
                {
                }
            }
        }
        
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSMutableDictionary *parame = [NSMutableDictionary dictionary];
        parame[@"postid"] = model.tieZiID;
        parame[@"loginuid"] = loginuid;
        NSString *url = [NSString stringWithFormat:@"%@/index.php/Apis/Forum/setLike/",BANGHUI_URL];
        [manager POST:url parameters:parame
              success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             if ([responseObject[@"success"] boolValue] == YES)
             {
                 NSLog(@"%@",responseObject);
             }
             else
             {
                 NSLog(@"%@",responseObject);
             }
         } failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             [self zanErrorAlertView:@"提示" message:@"抱歉,点赞失败"];
         }];
    }else
    {
        [self zanErrorAlertView:nil message:@"您无权限进行此操作，请先绑定机构码"];
    }
    
}

-(void)clickBarButtonComm:(ZJPostNewBottomBar *)psstBar
{
    [self pushToPostDetail:psstBar.btnComm.tag keyboardShow:YES];
}

-(void)clickBarButtonShare:(ZJPostNewBottomBar *)psstBar
{
    if ([GetOrgType isEqualToString:@"2"]) {
        
        BHFirstListModel *model;
        model = self.listArr[psstBar.btnShare.tag];
        HWComposeController *subVC = [[HWComposeController alloc]init];
        subVC.model = model;
        if (model.forward)
        {
            subVC.forward_id = model.forward[@"id"];
            subVC.forwardTitle = [NSString stringWithFormat:@"//@%@:%@",model.name,model.contents];
        }
        else
        {
            subVC.forward_id = model.tieZiID;
            subVC.forwardTitle = @"转发";
        }
        //添加@数组
        NSMutableArray *arr = [NSMutableArray arrayWithObject:model.uid];
        subVC.forward_uid = arr;
        if (model.usercalls.count != 0)
        {
            for (int i = 0; i < model.usercalls.count; i++) {
                [subVC.forward_uid addObject:model.usercalls[i][@"id"]];
            }
        }
        subVC.InterfaceDistinguish = @"1";
        subVC.isForward = YES;
        UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:subVC];
        [self presentViewController:navi animated:YES completion:nil];
        
//        GJHousingManagementViewController *HousingManagementVC = [[GJHousingManagementViewController alloc]init];
//        HousingManagementVC.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:HousingManagementVC animated:YES];
//        
        
        
//        NSString *url = [NSString stringWithFormat:@"%@/index.php/Apis/Forum/fenxiangweb/postid/%@",BANGHUI_SHAREURL,model.tieZiID];
//        
//        NSMutableArray *imageArray = [NSMutableArray array];
//        
//        if ([model.imgpath isEqualToString:@""])
//        {
//            [imageArray addObject:[UIImage imageNamed:IMAGE_NAME]];
//        }
//        else
//        {
//            [imageArray addObject:model.imgpath];
//        }
//        NSString *title = [NSString stringWithFormat:@"[邦会]%@",model.attributedContents.string];
//        if (title.length > 100) {
//            title = [title substringToIndex:100];
//        }
//        //1、创建分享参数
//        if (imageArray) {
//        
//            NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
//            [shareParams SSDKSetupShareParamsByText:nil
//                                             images:imageArray
//                                                url:[NSURL URLWithString:url]
//                                              title:title
//                                               type:SSDKContentTypeAuto];
//            NSArray *items = @[@(SSDKPlatformTypeSinaWeibo),@(SSDKPlatformSubTypeQZone),@(SSDKPlatformSubTypeWechatSession),@(SSDKPlatformSubTypeWechatTimeline),@(SSDKPlatformSubTypeQQFriend)];
//            
//            //2、分享（可以弹出我们的分享菜单和编辑界面）
//            [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
//                                     items:items
//                               shareParams:shareParams
//                       onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
//                           
//                           switch (state) {
//                               case SSDKResponseStateSuccess:
//                               {
//                                   UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
//                                                                                       message:nil
//                                                                                      delegate:nil
//                                                                             cancelButtonTitle:@"确定"
//                                                                             otherButtonTitles:nil];
//                                   [alertView show];
//                                   break;
//                               }
//                               case SSDKResponseStateFail:
//                               {
//                                   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
//                                                                                   message:[NSString stringWithFormat:@"%@",error]
//                                                                                  delegate:nil
//                                                                         cancelButtonTitle:@"OK"
//                                                                         otherButtonTitles:nil, nil];
//                                   NSLog(@"----%@",error);
//                                   [alert show];
//                                   break;
//                               }
//                               default:
//                                   break;
//                           }
//                       }  
//             ];
//    }
    }else
    {
        [self zanErrorAlertView:nil message:@"您无权限进行此操作，请先绑定机构码"];
    }
    
}

- (void)clickDataButton:(BHNoDataView *)noDataView
{
    [self requestFirstListData:NO];
}
- (void)ZJForwardViewClickJumpAction:(ZJForwardView *)ForwardView
{
    BHFirstListModel *model = self.listArr[ForwardView.indexpath.section];
    if ([model.forward[@"type"] isEqualToString:@"2"] || [model.forward[@"type"] isEqualToString:@"5"])
    {
        HWGongGaoViewController *gongGaoVC = [[HWGongGaoViewController alloc]init];
        gongGaoVC.hidesBottomBarWhenPushed = YES;
        gongGaoVC.postID =  ForwardView.forward_id;
        [self.navigationController pushViewController:gongGaoVC animated:YES];
    }
    else
    {
        BHPostDetailViewController *detailVC = [[BHPostDetailViewController alloc]init];
        detailVC.hidesBottomBarWhenPushed = YES;
        detailVC.tieZiID = ForwardView.forward_id;
        detailVC.index_row = ForwardView.indexpath.section;
        detailVC.isHuaTi = NO;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    
    
}

#pragma mark -跳转到帖子详情界面
- (void)pushToPostDetail:(NSInteger)index keyboardShow:(BOOL)isShow
{
    BHFirstListModel *model = self.listArr[index];
    BHPostDetailViewController *detailVC = [[BHPostDetailViewController alloc]init];
    detailVC.hidesBottomBarWhenPushed = YES;
    detailVC.tieZiID = model.tieZiID;
    detailVC.index_row = index;
    detailVC.isHuaTi = NO;
    detailVC.iskeyboardShow = isShow;
    [self.navigationController pushViewController:detailVC animated:YES];
}


#pragma mark - 关注提示
- (void)alertView:(NSString *)title message:(NSString *)message
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:^{
        
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
        
    });
    }else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alert dismissWithClickedButtonIndex:1 animated:YES];
        });

    }
}

#pragma mark - 点赞失败的提示
- (void)zanErrorAlertView:(NSString *)title message:(NSString *)message
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:^{
        
    }];
    
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
    }
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark-侧滑栏功能
- (void)ceHua
{
    //        LeftSlideViewController* slideVC =(LeftSlideViewController*)[UIApplication sharedApplication].keyWindow.rootViewController;
    //        if (slideVC.closed) {
    //            [slideVC openLeftView];
    //        }else{
    //            [slideVC closeLeftView];
    //        }
    //
    [self requestData];
    self.btnMain.hidden = YES;
    
    UIButton *cover = [[UIButton alloc] init];
    cover.alpha = 0.0;
    cover.backgroundColor = [UIColor blackColor];
    [cover addTarget:self action:@selector(menuViewHidden) forControlEvents:UIControlEventTouchUpInside];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    cover.y = 0;
    cover.width = self.view.width;
    cover.height = window.height;
    
    [window insertSubview:cover belowSubview:self.menuView];
    self.cover = cover;
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.menuView.x = self.view.width - self.menuView.width;
        //        [self.sideBar show];
        self.cover.alpha = 0.4;
        
        
    } completion:^(BOOL finished) {
        
        
        
    }];
    //
    
}

- (void)menuViewHidden
{

    [UIView animateWithDuration:0.25 animations:^{
        
        self.menuView.x = self.view.width;
        self.cover.alpha = 0.0;
        self.btnMain.hidden = NO;
        
        
    } completion:^(BOOL finished) {
        
        
        
    }];
    
    
}
#pragma mark - 通知方法
- (void)changeFram:(NSNotification *)noti
{

    [self.tableview reloadData];
//    [self requestFirstListData:YES];
    
}

//- (void)PicViewRefresh:(NSNotification *)noti
//{
//    [self.tableview reloadData];
//}
- (void)changeZanState:(NSNotification *)noti
{
    NSInteger index = [noti.userInfo[@"index"] integerValue];
    NSString *str = noti.userInfo[@"iszan"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *loginuid = [defaults objectForKey:@"id"];
    
    BHFirstListModel *model = self.listArr[index];
    if ([str isEqualToString:@"1"])
    {
        model.ispraise = @"333";
        NSString *face = [[NSUserDefaults standardUserDefaults] objectForKey:@"login_User_face"];
        NSString *str = [NSString stringWithFormat:@"http://app.hfapp.cn/%@",face];
        NSDictionary  *dic = @{@"uid":loginuid,@"iconpath":str};
        BHFirstZanModel *zanModel = [[BHFirstZanModel alloc]init];
        [zanModel setValuesForKeysWithDictionary:dic];
        [self.zanArr[index] insertObject:zanModel atIndex:0];
        [self.tableview reloadData];
    }
    else if ([str isEqualToString:@"2"])
    {
        model.ispraise = nil;
        for (int i = 0; i < [self.zanArr[index] count]; i++)
        {
            BHFirstZanModel *zanModel = self.zanArr[index][i];
            if (zanModel.uid == [loginuid integerValue])
            {
                [self.zanArr[index] removeObjectAtIndex:i];
                [self.tableview reloadData];
            }
            else
            {
            }
            
        }
    }
}

- (void)changeGuanState:(NSNotification *)noti
{
    NSInteger index = [noti.userInfo[@"index"] integerValue];
    NSString *str = noti.userInfo[@"isGuan"];
    BHFirstListModel *model = self.listArr[index];
    if ([str isEqualToString:@"1"]) {
        for (int i = 0; i < self.listArr.count; i++)
        {
            BHFirstListModel *lModel = self.listArr[i];
            if ([model.uid isEqualToString:lModel.uid])
            {
                lModel.isfocus = @"333";
            }
        }
        [self.tableview reloadData];
    }else if ([str isEqualToString:@"2"])
    {
        for (int i = 0; i < self.listArr.count; i++)
        {
            BHFirstListModel *lModel = self.listArr[i];
            if ([model.uid isEqualToString:lModel.uid])
            {
                lModel.isfocus = nil;
            }
        }
        [self.tableview reloadData];

    }
    
    
}

#pragma mark - 数据库操作
//归档
- (void)archiverForModel:(BHFirstListModel *)model
{
    NSMutableData *data = [NSMutableData data];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
    [archiver encodeObject:model forKey:@"firstModel"];
    [archiver finishEncoding];
    [self insertDatabase:data];
}

//反归档
- (BHFirstListModel *)unarchiverForData:(NSData *)data
{
    NSKeyedUnarchiver *unArchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
    BHFirstListModel *model = [unArchiver decodeObjectForKey:@"firstModel"];
    return model;
}

//查询数据库
- (void)selectDataBase
{
    FMResultSet *resultSet = [[ZJFMDBManager shareDataBase] executeQuery:@"SELECT * FROM t_BHFirstView_table"];
    while ([resultSet next])
    {
        NSData *data = [resultSet dataForColumn:@"data"];
        
        BHFirstListModel *model = [self unarchiverForData:data];
        [self.listArr addObject:model];
        NSMutableArray *arr = [NSMutableArray array];
        for (NSDictionary *dic in model.zan) {
            BHFirstZanModel *zmodel = [[BHFirstZanModel alloc]init];
            [zmodel setValuesForKeysWithDictionary:dic];
            [arr addObject:zmodel];
        }
        [self.zanArr addObject:arr];
    }
    [resultSet close];
    [self.tableview reloadData];
}

//插入数据
- (void)insertDatabase:(NSData *)data
{
    [[ZJFMDBManager shareDataBase] executeUpdate:@"INSERT INTO t_BHFirstView_table (data) VALUES (?)",data];
}
//删除数据
- (void)deleteDB
{
    //删除数据库全部内容
    [[ZJFMDBManager shareDataBase] executeUpdate:@"DELETE FROM t_BHFirstView_table"];
}

@end
