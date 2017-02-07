//
//  MineViewController.m
//  SalesHelper_A
//
//  Created by flysss on 16/3/17.
//  Copyright © 2016年 X. All rights reserved.
//

#import "MineViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import "CreditWebViewController.h"
#import "CreditNavigationController.h"
#import "CaculateController.h"

#import "NoticeViewController.h"
#import "PublicNoticeWebViewController.h"
#import "SCLAlertView.h"
#import "SetViewController.h"
#import "UserInfoViewController.h"
#import "IWantComplainViewController.h"
#import "LoginViewController.h"
#import "ShareMakeMoneyViewController.h"
#import "InviteMakeMoneyViewController.h"
#import "ChooseTitleViewController.h"
#import "bindingCodeViewController.h"

#import "BanghuiSearchViewController.h"
#import "MyWalletViewController.h"
#import "MySalesCenterViewController.h"
#import "MyTeamViewController.h"

#define KHeadHEIGHT 200;
#define KHEIGHT 64;

@interface MineViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UITabBarControllerDelegate>

@property (nonatomic, strong) UITableView* tableView;

@property (nonatomic,strong) NSDictionary *loginData;

@end


@implementation MineViewController
{
    float BGHEIGHT;
    
    NSDictionary * info;
    
    NSArray* titleArray;
    NSString * labelTitle;
    NSString *nameStr;
    NSString *urlString;

    NSString * org_name;
    
    NSString* creditsUrl;
    
    //登录时间戳
    NSString * timeStamp;
    NSString * levelStr;
    NSString * redirect;
    
    UIButton * levelBtn;
    UIButton * myPoints;

    UIButton* signIn;

    UIVisualEffectView *effectView;
    
    //弹出背景
    UIControl * backControl;
    UIView * backView;
    NSString * adUrlString;
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden =YES;
    
    self.tabBarController.tabBar.hidden = NO;
    
    [self requestOrgCodeState];
    
    [self requestLevel];
    
    [self requestMyInfo];
    
    if (GetUserID != nil)
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self loadLoginAdForIndex];
        });
    }

}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]){
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars =NO;
    }
    if([self respondsToSelector:@selector(setModalPresentationCapturesStatusBarAppearance:)]){
        self.modalPresentationCapturesStatusBarAppearance =NO;
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    //根据屏幕宽度适应高度
    if (SCREEN_WIDTH == 320 || SCREEN_WIDTH == 375)
    {
        BGHEIGHT = 200;
    }else if (SCREEN_WIDTH == 414)
    {
        BGHEIGHT = 250;
    }
    
    titleArray = @[@"我的钱包",@"分享赚钱",@"我的售楼部",@"我的团队",@"我要申诉",@"房贷计算器"];
    self.view.backgroundColor = [UIColor hexChangeFloat:@"f1f1f1"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:@"quitSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestData) name:@"changeImageSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestData) name:@"refreshClient" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestData) name:@"bindingOrgCode" object:nil];
    
    
    //添加分享按钮的监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDuibaShareClick:) name:@"duiba-share-click" object:nil];
//    添加登录按钮的监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDuibaLoginClick:) name:@"duiba-login-click" object:nil];
    
    [self createTableView];
    [self addTopView];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //判断是否登录过
    if(![defaults boolForKey:@"SalesHelper_publicNotice"])
    {
        //存数据--->基本数据类型
        [defaults setBool:NO forKey:@"SalesHelper_publicNotice"];//存 公告内容
        [defaults setBool:NO forKey:@"SalesHelper_AdvertView"];//存 广告内容
        [defaults synchronize];
    }
    //如果已经登陆过
    if ([defaults valueForKey:@"Login_User_token"] != nil)
    {
        
        [self requestLevel];
        [self requestMyInfo];
        
    }
    //如果没有登录过，跳转到登录界面
    else
    {
        [self gotoLogining];
    }
    //判断网络状态
    Reachability *netWorkReachable = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    if ([netWorkReachable currentReachabilityStatus] == NotReachable)
    {
        NSString * urlStr =[NSString stringWithFormat:@"%@/%@",Image_Url,[[NSUserDefaults standardUserDefaults] objectForKey:@"login_User_face"]];
        [self.bgImage sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"wdbg-1-@2x"]];
        [self.headImg sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"toux.png"]];
        self.userName.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"name"];
        [self.orgBtn setTitle:[[NSUserDefaults standardUserDefaults] objectForKey:@"orgName"] forState:UIControlStateNormal];
        
    }

  
}

#pragma mark -- 第一次启动时广告
-(void)loadLoginAdForIndex
{
    
    RequestInterface * adInterface = [[RequestInterface alloc]init];
    NSDictionary * dict = @{
                            @"token":GetUserID,
                            @"type":@"1",
                            @"ispage":@"4"
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
                //            backControl.backgroundColor = [UIColor colorWithRed:0 green:0 blue: 0 alpha:0.5];
                backControl.backgroundColor = [UIColor clearColor];
                backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
                backView.backgroundColor = [UIColor colorWithRed:0 green:0 blue: 0 alpha:0.5];
                backView.layer.cornerRadius = 5.0f;
                backView.layer.masksToBounds = YES;
                [backControl addSubview:backView];
                
                adUrlString = [data[@"datas"] objectForKey:@"urls"];
                UIButton* imageBtn = [[UIButton alloc]initWithFrame:CGRectMake(40, 80, SCREEN_WIDTH-80, (SCREEN_WIDTH - 80)*4/3)];
                [imageBtn setBackgroundColor: [UIColor redColor]];
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
                [colseBtn setImage:[UIImage imageNamed:@"登录"] forState:UIControlStateNormal];
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


//创建tableview
-(void)createTableView
{
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-49) style:UITableViewStylePlain];
    self.tableView.contentInset = UIEdgeInsetsMake(BGHEIGHT, 0, 0, 0);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.backgroundColor = [UIColor hexChangeFloat:@"f1f1f1"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:self.tableView];
    
    //设置
    UIButton * setting = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-50, 20, 40, 40)];
    [setting setImage:[UIImage imageNamed:@"销邦-我的-设置.png"] forState:UIControlStateNormal];
    [setting addTarget:self action:@selector(clickToSetting:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:setting];
    [setting bringSubviewToFront:self.view];
    
    UILabel *lblTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    lblTitle.text = @"个人中心";
    lblTitle.textAlignment = NSTextAlignmentCenter;
    lblTitle.textColor = [UIColor whiteColor];
    lblTitle.font = [UIFont systemFontOfSize:18];
    self.navigationItem.titleView = lblTitle;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"销邦-我的-设置"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:(UIBarButtonItemStyleDone) target:self action:@selector(clickToSetting:)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:(UIBarButtonItemStyleBordered) target:self action:@selector(aaa)];
    
}
#pragma mark -占位
- (void)aaa
{
    
}
#pragma  mark -- 个人信息
-(void)addTopView
{
    //背景图
    self.bgImage = [[UIImageView alloc]initWithFrame:CGRectMake(0,-BGHEIGHT, SCREEN_WIDTH, BGHEIGHT)];
    self.bgImage.contentMode = UIViewContentModeScaleAspectFill;
    self.bgImage.userInteractionEnabled = YES;
//    self.bgImage.autoresizesSubviews = YES;
    [self.tableView insertSubview:self.bgImage atIndex:0];
    
    if (IOS_VERSION >= 8.0)
    {
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    effectView = [[UIVisualEffectView alloc]initWithEffect:blur];
    effectView.frame = CGRectMake(0,-BGHEIGHT, SCREEN_WIDTH, 2*BGHEIGHT);
    effectView.contentMode = UIViewContentModeScaleAspectFill;
    [self.bgImage addSubview:effectView];
    }
    else
    {
        UIImageView * effectImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, -BGHEIGHT, SCREEN_WIDTH, 2*BGHEIGHT)];
        effectImg.image = [self imageWithBgColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
        effectImg.userInteractionEnabled = YES;
        [self.bgImage addSubview:effectImg];
    }
    //头像
    self.headImg = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-60)/2, BGHEIGHT-150, 60, 60)];
    self.headImg.image = [UIImage imageNamed:@""];
//    self.headImg.backgroundColor = [UIColor redColor];
    self.headImg.layer.cornerRadius = 30;
    self.headImg.layer.borderColor = [UIColor whiteColor].CGColor;
    self.headImg.layer.borderWidth  = 2.0f;
    self.headImg.layer.masksToBounds = YES;
    self.headImg.userInteractionEnabled = YES;
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickBtnToChangeInfomation:)];
    [self.headImg addGestureRecognizer:tap];
    [self.bgImage addSubview:self.headImg];
    
    //签到按钮
    signIn  = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.headImg.frame)+30, BGHEIGHT-140, 40, 40)];
    signIn.alpha = 1.0;
    signIn.hidden = NO;
    [signIn setImage:[UIImage imageNamed:@"wdqd-1-0"] forState:UIControlStateNormal];
    [signIn setImage:[UIImage imageNamed:@"wdqdh-1-0"] forState:UIControlStateSelected];
    [signIn addTarget:self action:@selector(clickToSignIn:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgImage addSubview:signIn];
    
    //用户姓名
    self.userName = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-150)/2, CGRectGetMaxY(self.headImg.frame)+10, 150, 30)];
    self.userName.userInteractionEnabled = YES;
    UITapGestureRecognizer* tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickBtnToChangeInfomation:)];
    [self.userName addGestureRecognizer:tap1];
    self.userName.textAlignment = NSTextAlignmentCenter;
    self.userName.textColor = [UIColor whiteColor];
    self.userName.font = Default_Font_17;
    [self.bgImage addSubview:self.userName];
    //用户公司
    
//    self.company = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-250)/2, CGRectGetMaxY(self.userName.frame)+5,250, 20)];
//    self.company.textColor = [UIColor whiteColor];
//    self.company.font = Default_Font_14;
//    self.company.textAlignment = NSTextAlignmentCenter;
//    self.company.userInteractionEnabled = YES;
//    [self.bgImage addSubview:self.company];
    
    self.headImg.image = [UIImage imageNamed:@"toux.png"];
    self.bgImage.image = [UIImage imageNamed:@"wdbg-1-@2x"];
    self.userName.text = @"";
    self.orgBtn.hidden = YES;
    signIn.hidden = YES;

    self.orgBtn  = [[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-250)/2, CGRectGetMaxY(self.userName.frame)+5,250,30)];
    [self.orgBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.orgBtn.titleLabel.font = Default_Font_14;
    self.orgBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.orgBtn addTarget:self action:@selector(clickControlToOrg:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgImage addSubview:self.orgBtn];
    
}

-(void)clickControlToOrg:(UIControl*)sender
{
    
    NSLog(@"%@",GetOrgCode);
    
    if (![GetOrgType isEqualToString:@"2"])
    {
            //        NSLog(@"绑定机构码");
            bindingCodeViewController * VC = [[bindingCodeViewController alloc]init];
            VC.hidesBottomBarWhenPushed = YES;
//            VC.isBingding = YES;
            [self.navigationController pushViewController:VC animated:YES];
    }

}

-(void)clickToSetting:(UIButton*)sender
{
//    NSLog(@"设置");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //判断是否登录过
    if(![defaults boolForKey:@"SalesHelper_publicNotice"])
    {
        //如果已经登陆过
        if ([defaults valueForKey:@"Login_User_token"] != nil)
        {
            UIStoryboard * story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            SetViewController * vc = [story instantiateViewControllerWithIdentifier:@"SetViewController"];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            [self gotoLogining];
        }
    }
}

#pragma mark ---修改1
- (void)refreshData
{
    if (GetUserID ==nil)
    {
        self.headImg.image = [UIImage imageNamed:@"toux.png"];
        self.bgImage.image = [UIImage imageNamed:@"wdbg-1-0"];
        self.userName.text = @"点击登录";
        self.orgBtn.hidden = YES;
        signIn.hidden = YES;
    }
    [self.tableView reloadData];
}


- (void)requestData
{
    [self requestLevel];
    [self requestMyInfo];
}



#pragma mark -- 请求用户等级和积分
-(void)requestLevel
{
   
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"Login_User_token"];
    if (token != nil)
    {
    NSDictionary* dict=@{
                         @"token":token
                         };
    RequestInterface *request = [[RequestInterface alloc] init];
       [request requestAwardPointQueryAP:dict];
        [request getInterfaceRequestObject:^(id data) {
            if (data[@"success"])
            {
//                NSLog(@"redirect=%@",data);
                if (data[@"AP_LV"] != nil && data[@"AP_LV"] != [NSNull null] && data[@"AP_LV"])
                {
                    [[NSUserDefaults standardUserDefaults] setObject:data[@"AP_LV"] forKey:@"LV"];
                }else
                {
                    [[NSUserDefaults standardUserDefaults] setObject:@"LV.0" forKey:@"LV"];
                }
                if (data[@"redirect"] != nil && data[@"redirect"] != [NSNull null] && data[@"redirect"])
                {
                   [[NSUserDefaults standardUserDefaults] setObject:data[@"redirect"] forKey:@"redirect"];
                }else
                {
                   [[NSUserDefaults standardUserDefaults] setObject:@"0"forKey:@"redirect"];
                }
            [[NSUserDefaults standardUserDefaults] synchronize];
                
            [self.tableView reloadData];
            }
        } Fail:^(NSError *error) {
           
            [self.view hideProgressView];
        }];
    }
}
#pragma mark -- 请求用户信息
-(void)requestMyInfo
{
    //请求 推荐人 用户个人信息
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"Login_User_token"];
//    NSLog(@"token = %@",token);
    if (token != nil)
    {
        
    NSDictionary* dict=@{
                         @"token":token
                         };
    RequestInterface *request = [[RequestInterface alloc] init];
    [request requestGetReferInfoWithParam:dict];
    
//    [self.view makeProgressViewWithTitle:@"正在更新"];
    [request getInterfaceRequestObject:^(id data) {
     
//        [self.view hideProgressView];
        
        info = [data objectForKey:@"datas"];
        if ([[data objectForKey:@"success"] boolValue])
        {
            [[NSUserDefaults standardUserDefaults] setObject:info[@"phone"] forKey:@"currentPhone"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            NSLog(@"%@",data);
            nameStr = [[data objectForKey:@"datas"] objectForKey:@"name"];
            if ([[data objectForKey:@"datas"] objectForKey:@"name"] != [NSNull null] && [[data objectForKey:@"datas"] objectForKey:@"name"] != nil && nameStr.length > 0)
            {
                nameStr = [[data objectForKey:@"datas"] objectForKey:@"name"];
                
            }else{
                nameStr = @"匿名";
            }
            if (data[@"datas"])
            {
//                NSLog(@"info = %@",info);
                //从网上下载
                //Image_Url1测试   Image_Url线上用
                urlString = [NSString stringWithFormat:@"%@/%@",Image_Url, [[data objectForKey:@"datas"] objectForKey:@"face"]];
            }
            if ([[data objectForKey:@"datas"] objectForKey:@"sign_time"]
                && [[data objectForKey:@"datas"] objectForKey:@"sign_time"] !=[NSNull null]
                && [[data objectForKey:@"datas"] objectForKey:@"sign_time"] !=nil)
            {
            //取出时间戳
                timeStamp = [[data objectForKey:@"datas"] objectForKey:@"sign_time"];
                if ([self getTodayTimeStamp] && timeStamp.length != 0)
                {
                    signIn.selected = YES;
                }else{
                    signIn.selected = NO;
                }
            }
            if ([[data objectForKey:@"datas"] objectForKey:@"org_name"]
                && [[data objectForKey:@"datas"] objectForKey:@"org_name"] !=[NSNull null]
                && [[data objectForKey:@"datas"] objectForKey:@"org_name"] !=nil)
            {
                //机构
//               org_name = [[data objectForKey:@"datas"] objectForKey:@"org_name"];
                org_name = [[NSUserDefaults standardUserDefaults] valueForKey:@"orgName"];
            }
            
            if ([defaults objectForKey:@"Login_User_token"] !=nil)
            {
                [self.headImg sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"toux.png"]];
            
                if ([info objectForKey:@"face"] != [NSNull null]
                    && [info objectForKey:@"face"]
                    &&[info objectForKey:@"face"] != nil )
                {
                    
                    [self.bgImage sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"wdbg-1-0"]];
                }
                else
                {
                    self.bgImage.image = [UIImage imageNamed:@"wdbg-1-0"];
                }

                self.userName.text = nameStr;
                
                if ([GetOrgType isEqualToString:@"2"])
                {
                    [self.orgBtn setTitle:[[NSUserDefaults standardUserDefaults] valueForKey:@"orgName"] forState:UIControlStateNormal];
                }
                else if ([GetOrgType isEqualToString:@"1"])
                {
                    [self.orgBtn setTitle:@"未绑定机构,立即绑定" forState:UIControlStateNormal];
                }
                else if ([GetOrgType isEqualToString:@"3"])
                {
                    [self.orgBtn setTitle:@"正在审核中" forState:UIControlStateNormal];
                }
                self.orgBtn.hidden = NO;
                signIn.hidden = NO;
            }
            else
            {
                self.headImg.image = [UIImage imageNamed:@"toux.png"];
                self.bgImage.image = [UIImage imageNamed:@"wdbg-1-0"];
                self.userName.text = @"点击登录";
                self.orgBtn.hidden = YES;
                signIn.hidden = YES;
            }
        }
//        [self.view hideProgressView];
        [self.tableView reloadData];
        
    } Fail:^(NSError *error) {
//        [self.view hideProgressView];
        [self.view makeToast:HintWithNetError];
    }];
    }
}

#pragma mark  tableView协议代理方法
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return 65;
    }
    else if(indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            return 51;
        }else{
            return 65;
        }
    }
    else if (indexPath.section == 2)
    {
        if (indexPath.row == 0)
        {
            return 51;
        }else{
            return 65;
        }
    }
    else
    {
        return 51;
    }
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
//    else if (section == 1)
//    {
//        return 2;
//    }else if (section = 2)
//    {
//        return 2;
//    }
    else{
        return 2;
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"%ld", (long)indexPath.row]];
    }
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            //用户等级
           levelBtn = [[UIButton alloc]initWithFrame:CGRectMake(((SCREEN_WIDTH/2-40)/2), 15, 50, 20)];
            
            //请求数据
            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"Login_User_token"] !=nil)
            {
                if ([[NSUserDefaults standardUserDefaults] valueForKey:@"LV"] != nil &&
                    [[NSUserDefaults standardUserDefaults] valueForKey:@"LV"] != [NSNull null]) {
                    [levelBtn setTitle:[[NSUserDefaults standardUserDefaults] valueForKey:@"LV"] forState:UIControlStateNormal];
                }
                else
                {
                    [levelBtn setTitle:@"LV.0" forState:UIControlStateNormal];
                }
                
            }else{
                [levelBtn setTitle:@"LV.0" forState:UIControlStateNormal];
            }

            [levelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            levelBtn.backgroundColor = [UIColor hexChangeFloat:@"ff5f66"];
            levelBtn.layer.cornerRadius = 5.0f;
            levelBtn.layer.masksToBounds = YES;
            [cell.contentView addSubview:levelBtn];
            //分割线
            UIView * line = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2, 0, 0.4, 51)];
            line.backgroundColor = [UIColor grayColor];
            line.alpha = 0.4;
            [cell.contentView addSubview:line];
            //用户积分
            myPoints = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2,0,SCREEN_WIDTH/2,51)];
            [myPoints setTitleColor:[UIColor colorWithRed:23/255.0f green:183/255.0f blue:242/255.0f alpha:1] forState:UIControlStateNormal];
            //请求数据
            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"Login_User_token"] !=nil) {
                if ([[NSUserDefaults standardUserDefaults] valueForKey:@"redirect"] != nil &&
                    [[NSUserDefaults standardUserDefaults] valueForKey:@"redirect"] != [NSNull null])
                {
                    [myPoints setTitle:[NSString stringWithFormat:@"%@ 积分",[[NSUserDefaults standardUserDefaults] valueForKey:@"redirect"] ] forState:UIControlStateNormal];
                }else{
                    [myPoints setTitle:[NSString stringWithFormat:@"0 积分"] forState:UIControlStateNormal];
                }
               
            }else{
                [myPoints setTitle:[NSString stringWithFormat:@"0 积分"] forState:UIControlStateNormal];
            }
            [myPoints addTarget:self action:@selector(clickToGoMypoints:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:myPoints];
            
            UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(0,50.5, SCREEN_WIDTH ,0.4)];
            line1.backgroundColor = [UIColor grayColor];
            line1.alpha = 0.4;
            [cell.contentView addSubview:line1];
            
            UILabel * gapLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 51, SCREEN_WIDTH, 14)];
            gapLab.backgroundColor = [UIColor hexChangeFloat:@"f1f1f1"];
            [cell.contentView addSubview:gapLab];
        }
    }
    else if (indexPath.section == 1)
    {
        cell.separatorInset = UIEdgeInsetsMake(0, 47, 0, 0);
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(45, 13, 100, 25)];
        label.textColor = [UIColor hexChangeFloat:@"3e3a39"];
        label.font = Default_Font_16;
        [cell.contentView addSubview:label];
        UIImageView* image = [[UIImageView alloc]initWithFrame:CGRectMake(8, 10, 30, 30)];
        [cell.contentView addSubview:image];
       
        if (indexPath.row ==0)
        {
            UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH ,0.4)];
            line1.backgroundColor = [UIColor grayColor];
            line1.alpha = 0.4;
            [cell.contentView addSubview:line1];
            label.text = titleArray[0];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            image.image = [UIImage imageNamed:@"销邦-我的-钱包.png"];
            
        }
        if (indexPath.row == 1)
        {
            label.text = titleArray[1];
            image.image = [UIImage imageNamed:@"ico-my01"];
            UILabel * gapLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 51, SCREEN_WIDTH, 14)];
            gapLab.backgroundColor = [UIColor hexChangeFloat:@"f1f1f1"];
            [cell.contentView addSubview:gapLab];
            UIImageView * arrow = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-24, 17, 8,14)];
            arrow.image = [UIImage imageNamed:@"yjt"];
            [cell.contentView addSubview:arrow];
            UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(0,50.5, SCREEN_WIDTH ,0.4)];
            line1.backgroundColor = [UIColor grayColor];
            line1.alpha = 0.4;
            [cell.contentView addSubview:line1];

         }

        }
    else if (indexPath.section == 2)
    {
        
        cell.separatorInset = UIEdgeInsetsMake(0, 47, 0, 0);
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(45, 13, 100, 25)];
        label.textColor = [UIColor hexChangeFloat:@"3e3a39"];
        label.font = Default_Font_16;
        [cell.contentView addSubview:label];
        UIImageView* image = [[UIImageView alloc]initWithFrame:CGRectMake(8, 10, 30, 30)];
        [cell.contentView addSubview:image];
        
        if (indexPath.row ==0)
        {
            UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH ,0.4)];
            line1.backgroundColor = [UIColor grayColor];
            line1.alpha = 0.4;
            [cell.contentView addSubview:line1];
            label.text = titleArray[2];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            image.image = [UIImage imageNamed:@"新我的售楼部"];
            
        }
        if (indexPath.row == 1)
        {
            label.text = titleArray[3];
            image.image = [UIImage imageNamed:@"新我的团队"];
            UILabel * gapLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 51, SCREEN_WIDTH, 14)];
            gapLab.backgroundColor = [UIColor hexChangeFloat:@"f1f1f1"];
            [cell.contentView addSubview:gapLab];
            UIImageView * arrow = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-24, 17, 8,14)];
            arrow.image = [UIImage imageNamed:@"yjt"];
            [cell.contentView addSubview:arrow];
            UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(0,50.5, SCREEN_WIDTH ,0.4)];
            line1.backgroundColor = [UIColor grayColor];
            line1.alpha = 0.4;
            [cell.contentView addSubview:line1];
            
        }
        
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        cell.separatorInset = UIEdgeInsetsMake(0, 47, 0, 0);
//        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(45, 13, 100, 25)];
//        label.textColor = [UIColor hexChangeFloat:@"3e3a39"];
//        label.font = Default_Font_16;
//        [cell.contentView addSubview:label];
//        UIImageView* image = [[UIImageView alloc]initWithFrame:CGRectMake(8, 10, 30,30)];
//        [cell.contentView addSubview:image];
//        
//        if (indexPath.row == 0)
//        {
//            UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH ,0.4)];
//            line1.backgroundColor = [UIColor grayColor];
//            line1.alpha = 0.4;
//            [cell.contentView addSubview:line1];
//        }
//        
//        if (indexPath.row == 2)
//        {
//            UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(0,50.5, SCREEN_WIDTH ,0.4)];
//            line1.backgroundColor = [UIColor grayColor];
//            line1.alpha = 0.4;
//            [cell.contentView addSubview:line1];
//        }
//
//        if (indexPath.row == 0)
//        {
//            label.text = titleArray[2];
//            image.image = [UIImage imageNamed:@"ico-my01"];
//        }else if (indexPath.row == 1)
//        {
//            label.text = titleArray[3];
//            image.image = [UIImage imageNamed:@"销邦-我的-投诉"];
//        }
//
//               else if (indexPath.row == 2)
//        {
//            label.text = titleArray[4];
//            image.image = [UIImage imageNamed:@"组-2.png"];
//        }
    }
    else if (indexPath.section == 3)
    {
        cell.separatorInset = UIEdgeInsetsMake(0, 47, 0, 0);
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(45, 13, 100, 25)];
        label.textColor = [UIColor hexChangeFloat:@"3e3a39"];
        label.font = Default_Font_16;
        [cell.contentView addSubview:label];
        UIImageView* image = [[UIImageView alloc]initWithFrame:CGRectMake(8, 10, 30, 30)];
        [cell.contentView addSubview:image];
        
        if (indexPath.row ==0)
        {
            UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH ,0.4)];
            line1.backgroundColor = [UIColor grayColor];
            line1.alpha = 0.4;
            [cell.contentView addSubview:line1];
            label.text = titleArray[4];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            image.image = [UIImage imageNamed:@"销邦-我的-投诉"];
            
        }
        if (indexPath.row == 1)
        {
            label.text = titleArray[5];
            image.image = [UIImage imageNamed:@"组-2.png"];
//            UILabel * gapLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 51, SCREEN_WIDTH, 14)];
//            gapLab.backgroundColor = [UIColor hexChangeFloat:@"f1f1f1"];
//            [cell.contentView addSubview:gapLab];
            UIImageView * arrow = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-24, 17, 8,14)];
            arrow.image = [UIImage imageNamed:@"yjt"];
            [cell.contentView addSubview:arrow];
            UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(0,50.5, SCREEN_WIDTH ,0.4)];
            line1.backgroundColor = [UIColor grayColor];
            line1.alpha = 0.4;
            [cell.contentView addSubview:line1];
            
        }
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    if (indexPath.section == 0)
    {
    }
    if (indexPath.section == 1)
    {
        if ([GetOrgType isEqualToString:@"2"])
       {
        //我的钱包
        if (indexPath.row == 0)
        {
            if ([defaults valueForKey:@"Login_User_token"] != nil)
            {
                UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"MyPurseViewController"];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
//                MyWalletViewController * VC = [[MyWalletViewController alloc]init];
//                VC.hidesBottomBarWhenPushed = YES;
//                [self.navigationController pushViewController:VC animated:YES];
            }
         }
         else if (indexPath.row == 1)
         {
                 ShareMakeMoneyViewController * shareVC =[[ShareMakeMoneyViewController alloc] init];
                    shareVC.hidesBottomBarWhenPushed=YES;
                    [self.navigationController pushViewController:shareVC animated:YES];
          }
        }
        else
        {
            [self.view makeToast:@"您无权限进行此操作，请先绑定机构码" duration:1.0 position:@"bottom"];
        }
  
//        //积分商城
//        if (indexPath.row == 1)
//        {
//            NSString *token = [defaults objectForKey:@"Login_User_token"];
//            NSDictionary * dict;
//            int value = arc4random();
//            NSString * randomNum = [NSString stringWithFormat:@"%d",value];
//            if (token != nil)
//            {
//                dict = @{@"token":token,
//                         @"redirect":@"",
//                         @"uuid":randomNum
//                         };
//            }else{
//                dict = @{@"uuid":randomNum};
//            }
//            RequestInterface *request = [[RequestInterface alloc] init];
//            [request requestVisitCreditsShopWith:dict];
////            [self.view makeProgressViewWithTitle:@"正在更新"];
//            [request getInterfaceRequestObject:^(id data) {
//                [self.view hideProgressView];
//                if ([[data objectForKey:@"success"] boolValue]) {
//                    
//                    creditsUrl = data[@"url"];
//                    CreditWebViewController *web=[[CreditWebViewController alloc]initWithUrl:creditsUrl];
//                 
//                    web.hidesBottomBarWhenPushed = YES;
//                    [self.navigationController pushViewController:web animated:YES];
//                }
//                
//            } Fail:^(NSError *error) {
////                [self.view hideProgressView];
//                [self.view makeToast:HintWithNetError];
//            }];
//        }
            
    }
    if (indexPath.section == 2)
    {
        
        //我的售楼处
        if (indexPath.row == 0)
        {
            
          if ([GetOrgType isEqualToString:@"2"] )
          {
            
            MySalesCenterViewController * vc = [[MySalesCenterViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
            
           }else
           {
            [self.view makeToast:@"您无权限进行此操作，请先绑定机构码" duration:1.0 position:@"center"];
           }
        }
        else
        {
            //我的团队
            if ([GetOrgType isEqualToString:@"2"] )
            {
                
                MyTeamViewController * vc = [[MyTeamViewController alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
                
                
            }else
            {
                [self.view makeToast:@"您无权限进行此操作，请先绑定机构码" duration:1.0 position:@"center"];
            }
 
            
        }
        
    }
    else if (indexPath.section == 3)
    {
        //我要申诉
        if (indexPath.row == 0)
        {
            if ([GetOrgType isEqualToString:@"2"])
            {
                if ([defaults valueForKey:@"Login_User_token"] != nil)
                {
                    IWantComplainViewController *vc = [[IWantComplainViewController alloc] init];
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                else
                {
                    [self gotoLogining];
                }
            }else
            {
                [self.view makeToast:@"您无权限进行此操作，请先绑定机构码" duration:1.0 position:@"bottom"];
            }
        }
        
        if (indexPath.row == 1)
        {
            CaculateController *vc = [[CaculateController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }

    }
    
}
#pragma mark 积分商城 页面点击登录/分享调用函数
//当兑吧页面内点击登录时，会调用此处函数
//请在此处弹出登录层，进行登录处理
//登录成功后，请从dict拿到当前页面currentUrl
//让服务器端重新生成一次自动登录地址，并附带redirect=currentUrl参数
//使用新生成的自动登录地址，让webView重新进行一次加载
-(void)onDuibaLoginClick:(NSNotification *)notify{
    
    //进行登录操作，登录完成重新加载web页面
#if 0
#else
    
    self.loginData=notify.userInfo;
    NSLog(@"login = %@",self.loginData);
    UINavigationController *mainNaVC = [[UINavigationController alloc] initWithRootViewController:[[LoginViewController alloc]init]];
    mainNaVC.modalTransitionStyle =UIModalTransitionStyleCrossDissolve;
    [self presentViewController:mainNaVC animated:YES completion:nil];
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"Login_User_token"];
    
    NSDictionary* dict = @{@"token":token,@"redirect":self.loginData[@"currentUrl"]};
    RequestInterface *request = [[RequestInterface alloc] init];
    
    [request requestVisitCreditsShopWith:dict];
    
    [request getInterfaceRequestObject:^(id data) {
        
        creditsUrl = data[@"url"];
        CreditWebViewController *web=[[CreditWebViewController alloc]initWithUrl:creditsUrl];
//        self.tabBarController.tabBar.hidden = YES;
        web.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:web animated:YES];
        
    } Fail:^(NSError *error) {
        
    }];
    
#endif
    
}

//跳转登录
-(void)gotoLogining
{
    UINavigationController *mainNaVC = [[UINavigationController alloc] initWithRootViewController:[[LoginViewController alloc]init]];
    mainNaVC.modalTransitionStyle =UIModalTransitionStyleCrossDissolve;
    [self presentViewController:mainNaVC animated:YES completion:nil];
    
//    LoginViewController * VC = [[LoginViewController alloc]init]
//    mainNaVC.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:mainNaVC animated:YES];
    
}
#pragma mark 分享到社交平台
-(void)onDuibaShareClick:(NSNotification *)notify{
    
    //分享操作
    NSDictionary *dict=notify.userInfo;
    NSString *shareUrl=[dict objectForKey:@"shareUrl"];//分享url
    NSString *shareTitle=[dict objectForKey:@"shareTitle"];//标题
    NSString *shareThumbnail=[dict objectForKey:@"shareThumbnail"];//缩略图
    //    NSString *shareSubTitle=[dict objectForKey:@"shareSubtitle"];//副标题
    
    //    NSString *message=@"";
    //    message=[message stringByAppendingFormat:@"分享地址:%@ \n 分享标题:%@ \n分享图:%@ \n分享副标题:%@",shareUrl,shareTitle,shareThumbnail,shareSubTitle];
    //    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"捕获到分享点击" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    //    [alert show];
   
    NSArray *imageArray = @[shareThumbnail];
//    1、创建分享参数
    if (imageArray) {
    
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:shareTitle
                                     images:imageArray
                                        url:[NSURL URLWithString:shareUrl]
                                      title:shareTitle
                                       type:SSDKContentTypeAuto];
                NSArray *items = @[@(SSDKPlatformTypeSinaWeibo),@(SSDKPlatformSubTypeQZone),@(SSDKPlatformSubTypeWechatSession),@(SSDKPlatformSubTypeWechatTimeline),@(SSDKPlatformSubTypeQQFriend)];
    //2、分享（可以弹出我们的分享菜单和编辑界面）
    [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                             items:items
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


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat y = scrollView.contentOffset.y;
    
    CGFloat offsetH = -BGHEIGHT -y;
//    NSLog(@"%f-%f",offsetH,y );
    if (offsetH < 0)
    {
        return;
    }else
    {
    }

}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
//    if (section == 2) {
//        return 15;
//    }
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}


//点击头像进入个人信息
-(void)clickBtnToChangeInfomation:(UIButton*)sender
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults valueForKey:@"Login_User_token"] != nil)
    {
        UserInfoViewController *vc = [[UserInfoViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        [self gotoLogining];
    }
    
}
//转换时间戳
-(BOOL)getTodayTimeStamp
{
    NSDate * date = [NSDate date];
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
//    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
//    [formatter setTimeZone:timeZone];
    NSString* nowStr = [formatter stringFromDate:date];
    NSString * minStr =[NSString stringWithFormat:@"%@ 00:00:00",[nowStr substringWithRange:NSMakeRange(0, 10)]];
    NSString * maxStr = [NSString stringWithFormat:@"%@ 23:59:59",[nowStr substringWithRange:NSMakeRange(0, 10)]];
    
    NSDate * minDate = [formatter dateFromString:minStr];
    NSDate * maxDate = [formatter dateFromString:maxStr];
    NSString* minStamp = [NSString stringWithFormat:@"%ld",(long)[minDate timeIntervalSince1970]];
    NSString* maxStamp = [NSString stringWithFormat:@"%ld",(long)[maxDate timeIntervalSince1970]];
    
    NSInteger minS = [minStamp integerValue];
    NSInteger maxS = [maxStamp integerValue];
   
    NSLog(@"%ld-%d-%@",(long)minS,maxS,timeStamp);
    
    return minS < [timeStamp integerValue] && maxS > [timeStamp integerValue];
}

//点击签到
-(void)clickToSignIn:(UIButton*)sender
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"Login_User_token"];
    if (timeStamp != nil && timeStamp.length !=0)
    {
      if (![self getTodayTimeStamp])
      {
         //发送签到请求；
        if (!sender.selected)
        {
         sender.selected = !sender.selected;
        //请求 推荐人 用户个人信息
         NSDictionary* dict=@{
                             @"token":token
                             };
         RequestInterface *request = [[RequestInterface alloc] init];
         [request requestAwardPointRefereeSignWith:dict];
         [request getInterfaceRequestObject:^(id data) {
            
            if ([[data objectForKey:@"success"] boolValue])
            {
              [self.view makeToast:@"签到成功！" duration:1.0 position:@"center"];
                
            }
            
         } Fail:^(NSError *error) {
            NSLog(@"%@",error);
        }];
        
       }
     }
    else
     {
         [self.view makeToast:@"今天您已经签过到了！" duration:1.0 position:nil];
     }
    }else
    {
        if (!sender.selected)
        {
            sender.selected = !sender.selected;
            //请求 推荐人 用户个人信息
            NSDictionary* dict=@{
                                 @"token":token
                                 };
            RequestInterface *request = [[RequestInterface alloc] init];
            [request requestAwardPointRefereeSignWith:dict];
            [request getInterfaceRequestObject:^(id data) {
                
                if ([[data objectForKey:@"success"] boolValue]) {
                    NSLog(@"%@-%@",data,token);
                }
                
            } Fail:^(NSError *error) {
                NSLog(@"%@",error);
            }];
        }
    }
}
//进入我的积分
-(void)clickToGoMypoints:(UIButton*)sender
{
    ModelWebViewController * web = [[ModelWebViewController alloc]initWithUrlString:[NSString stringWithFormat:@"%@/apinfo.jsp?token=%@&redirect=%@",REQUEST_SERVER_URL,GetUserID,GetUserRedirect] NavigationTitle:@"我的积分"];
    web.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:web animated:YES];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
