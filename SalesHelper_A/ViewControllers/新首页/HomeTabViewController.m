//
//  HomeTabViewController.m
//  SalesHelper_A
//
//  Created by flysss on 16/2/17.
//  Copyright © 2016年 X. All rights reserved.
//

#import "HomeTabViewController.h"
#import "URLRequest.h"
#import "UIColor+Extend.h"
#import "LoginViewController.h"

#import "UIImageView+WebCache.h"
#import "SDImageCache.h"
#import "IQKeyboardManager.h"

#import "PropertyDetailViewController.h"
#import "HomeTableViewCell.h"
#import "SDCycleScrollView.h"
#import "SearchPropertyViewController.h"
//#import "ModelWebViewController.h"
#import "MPFoldTransition.h"
#import "CoreLocationViewController.h"
#import "arrowBtn.h"
#import <QuartzCore/QuartzCore.h>
#import "UIScrollView+EmptyDataSet.h"
#import "AppDelegate.h"
#import "MapViewController.h"

#import "TwohandHouseViewController.h"
#import "RecommendClientViewController.h"

#import "HomeTabViewCell.h"
#import "ModelWebViewController.h"

#import "MySalesCenterViewController.h"
#import "CreditWebViewController.h"

#import "SDAdScrollView.h"
#import "SVPullToRefresh.h"
#import "NoticeWebDetailViewController.h"

static BOOL ifNoData = NO;

@interface HomeTabViewController ()<UITableViewDataSource, UITableViewDelegate, locationChooseDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, UITabBarControllerDelegate,UISearchBarDelegate,UITextFieldDelegate,SDCycleScrollViewDelegate,UIAlertViewDelegate>

{
    //定时器
    NSTimer * timer;
    //滚动公告视图
    UIView * contentView;
    //所有数据信息
    NSMutableArray * info;
    
    //公告数据信息
    NSMutableArray * bulletin;

//    NSMutableArray * EstateStateArr;
    
    //记录服务器所有的信息条数
    double allPageCount;
    
    //记录当前的城市位置信息
    NSString *currentLocationCity;
    
    //记录当前页数
    int pageIndex;
    
    //公告滚动页数
    NSInteger indexStep;
    
    NSMutableDictionary * locationDict;
    
    NSString * locationStrCity;//城市位置代码
    
    UIButton * naviBtn;
    
    //轮播图1
    SDCycleScrollView * cycleScrollView;
    //轮播图2
//    SDAdScrollView * adScrollView;
    
    //顶部轮播视图高度
    CGFloat topHeight;
    //
    UIImage *_heardImage;
    
    UIView* _topView;
    
    //首页底部搜索条
//    UISearchBar* mySearchBar;
    
    //公告栏
    UILabel * labelll;
    
    //弹出背景
    UIControl * backControl;
    UIView * backView;
    NSString * adUrlString;
    
    //积分商城Url
    NSString* creditsUrl;
    
    UITextField * inputField;
    
    BOOL isEqual;
    
    int numberOfExecutions;
}
@property (nonatomic, strong) UITableView* tableView;

@property (nonatomic, strong) NSMutableArray * headScrollArr;

@end

@implementation HomeTabViewController
{
    arrowBtn * button;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
    [[IQKeyboardManager sharedManager] setEnable:YES];
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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    info = [NSMutableArray array];

    //登录、退出登录、绑定机构码、解绑机构码--接受通知 刷新首页界面
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTableView) name:@"refreshClient" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTableView) name:@"quitSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTableView) name:@"bindingOrgCode" object:nil];
    
    //产生随机数，用于弹出用户评分
    numberOfExecutions = arc4random() % 20;
    if (GetUserID != nil)
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self loadLoginAdForIndex];
        });
    }

    [self requestOrgCodeState];
    
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;

    [self CreateCustomNavigtionBarWith:self leftItem:nil rightItem:@selector(searchForNewProperty)];
    self.backBtn.hidden = YES;
    button = [[arrowBtn alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-60)/2, 20, 60, 35)];
    button.titleLabel.font = [UIFont systemFontOfSize:18];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(chooseLocationCity) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:@"形状-16.png"] forState:UIControlStateNormal];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0.0, 45, 0.0, 0.0)];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0.0, -30, 0.0, 0.0)];
    [self.topView  addSubview: button];
    [self.rightBtn setImage:[UIImage imageNamed:@"myss-1-0"] forState:UIControlStateNormal];
    [self.rightBtn setImage:[UIImage imageByApplyingAlpha:[UIImage imageNamed:@"myss-1-0"]] forState:UIControlStateHighlighted];

    //公告数组下标
    indexStep = 0;
    
    topHeight = 125*SCREEN_WIDTH/320;
    
    //创建tableView
    [self createTableView];
    
    if(locationDict )
    {
        locationStrCity = [NSString stringWithFormat:@"%@",[locationDict objectForKey:@"id"]];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:locationStrCity  forKey:@"location_City"];
        [defaults synchronize];
        [self sendRequestWithCachorNot:YES];
        NSLog(@" city = %@",locationStrCity);
    }
    else
    {
        //默认城市.
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        NSString * cityName ;
        RequestInterface * interface = [[RequestInterface alloc] init];
        if ([defaults objectForKey:@"Login_User_currentLocationCity"] == nil)
        {
            cityName = @"合肥";

        }
        else
        {
            cityName = [defaults objectForKey:@"Login_User_currentLocationCity"];
            NSLog(@"%@",[defaults objectForKey:@"Login_User_currentLocationCity"]);
        }

        [interface requestyunyingCitywithdic:nil];
        [interface getInterfaceRequestObject:^(id data) {
            for (int i = 0; i < [data[@"datas"] count]; i++)
            {
                if ([data[@"datas"][i][@"name"] isEqualToString:cityName])
                {
                    isEqual = YES;
                }
            }
            [self overloading:cityName];
        } Fail:^(NSError *error)
        {
            isEqual = NO;
            [self.view makeToast:@"您所在的城市暂未开通服务,默认为合肥"];
            [button setTitle:@"合肥" forState:UIControlStateNormal];
            locationStrCity = @"1171";
            [defaults setObject:locationStrCity forKey:@"location_City"];
            [defaults setObject:@"合肥" forKey:@"Login_User_currentLocationCity"];
            [defaults synchronize];
            [self loadScroll];
            [self sendRequestWithCachorNot:YES];
        }];
    }
    //判断网络状态
    Reachability *netWorkReachable = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    if ([netWorkReachable currentReachabilityStatus] == NotReachable)
    {
        [self.view makeToast:@"网络无法连接" duration:0.8 position:@"center"];
//        网络未连接 从本地取出首页轮播图缓存
       NSArray * imageArr = [[NSUserDefaults standardUserDefaults] objectForKey:@"cycleImage"];
        if ([imageArr count])
         {
//             NSLog(@"%@",imageArr);
            [cycleScrollView setImageURLStringsGroup:imageArr];
             
        }
    }
    
//    [self refreshingTableView];
    [self newRefreshTableView];
    
    self.tabBarController.delegate = self;
    
}

//状态改变刷新数据
-(void)refreshTableView
{
    [self.tableView reloadData];
}

- (void)overloading:(NSString *)cityName
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];

        if (isEqual == YES) {
            RequestInterface * interface = [[RequestInterface alloc] init];
            NSDictionary * dict = @{
                                    @"ctiyName":cityName,
                                    };
            [interface requestGetLocationCityWithParam:dict];
            [interface getInterfaceRequestObject:^(id data) {
                if ([[data objectForKey:@"success"] boolValue])
                {
                    locationStrCity = [data objectForKey:@"datas"];
                    NSLog(@"%@",locationStrCity);
                    [defaults setObject:locationStrCity forKey:@"location_City"];
                    [button setTitle:cityName forState:UIControlStateNormal];
                }
                else
                {
                    
                }
                [self loadScroll];
                [self sendRequestWithCachorNot:YES];
                
            } Fail:^(NSError *error)
             {
                 [button setTitle:@"合肥" forState:UIControlStateNormal];
                 locationStrCity = @"1171";
                 [defaults setObject:locationStrCity forKey:@"location_City"];
                 [defaults setObject:@"合肥" forKey:@"Login_User_currentLocationCity"];
                 [defaults synchronize];
                 
                 [self loadScroll];
                 [self sendRequestWithCachorNot:YES];
                 
             }];
            
        }else
        {
            [self.view makeToast:@"您所在的城市暂未开通服务,默认为合肥"];
            [button setTitle:@"合肥" forState:UIControlStateNormal];
            locationStrCity = @"1171";
            [defaults setObject:locationStrCity forKey:@"location_City"];
            [defaults setObject:@"合肥" forKey:@"Login_User_currentLocationCity"];
            [defaults synchronize];
            [self loadScroll];
            [self sendRequestWithCachorNot:YES];
            
        }
}


-(void)loadLoginAdForIndex
{
    
    RequestInterface * adInterface = [[RequestInterface alloc]init];
    NSDictionary * dict = @{
                            @"token":GetUserID,
                            @"type":@"1",
                            @"ispage":@"1"
                             };
    [adInterface requestLoginAdPresentWithParam:dict];
    
    [adInterface getInterfaceRequestObject:^(id data) {
//        NSLog(@"adlogin  %@",data);

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
            [colseBtn setImage:[UIImage imageNamed:@"关闭"] forState:UIControlStateNormal];
            colseBtn.alpha = 1;
            [colseBtn addTarget:self action:@selector(hiddenView:) forControlEvents:UIControlEventTouchUpInside];
            [backView addSubview:colseBtn];
            UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
            [keyWindow addSubview:backControl];
            }
            else
            {
                //没有广告，弹出app评分界面-根据随机数
                NSLog(@"number%d",numberOfExecutions);
                if (numberOfExecutions == 8)
                {
                    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"是否愿意给销邦一次评价，前往App Store为销邦好评吧。" delegate:self cancelButtonTitle:@"赏你一次" otherButtonTitles:@"残忍拒绝", nil];
                    alert.tag = 1111;
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [alert show];
                    });
                }
            }
        }
    } Fail:^(NSError *error) {
    }];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1111)
    {
        if (buttonIndex == 0)
        {
            NSString  * nsStringToOpen = [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=955317307"];
            
            if( ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0))
            {
                nsStringToOpen = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id955317307"];
            }
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:nsStringToOpen]];
        }
    }
}

-(void)tapAdImageToDetail:(UIButton*)sender
{
//    NSLog(@"%@",adUrlString);
    [backControl removeFromSuperview];
    NoticeWebDetailViewController * VC = [[NoticeWebDetailViewController alloc]initWithUrlString:adUrlString NavigationTitle:@"广告详情"];
    VC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:VC animated:YES];
}


-(void)createTableView
{
    
//    self.automaticallyAdjustsScrollViewInsets = NO;
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,64, SCREEN_WIDTH, SCREEN_HEIGHT-64-49) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
//    _tableView.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);
//    [_tableView registerClass:[HomeTableViewCell class] forCellReuseIdentifier:@"HomeCell"];
//    _tableView.backgroundColor = [UIColor whiteColor];
    [_tableView registerClass:[HomeTabViewCell class] forCellReuseIdentifier:@"HomeCell"];
    [self.view addSubview:_tableView];
    self.tableView.separatorColor = [UIColor colorWithRed:239/255.0f green:239/255.0f blue:244/255.0f alpha:1];
    
//    UIView* footer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
//    footer.backgroundColor = [UIColor whiteColor];
//    _tableView.tableFooterView = footer;
    
    cycleScrollView = [[SDCycleScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, topHeight)];
    cycleScrollView.backgroundColor = [UIColor whiteColor];
    cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    cycleScrollView.delegate = self;
    cycleScrollView.dotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
    cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
    cycleScrollView.placeholderImage = [UIImage imageNamed:@"top_bg.png"];
    cycleScrollView.autoScrollTimeInterval = 5.0;
    _tableView.tableHeaderView = cycleScrollView;
    

}


- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    if (viewController == [tabBarController.viewControllers objectAtIndex:3]|| viewController == [tabBarController.viewControllers objectAtIndex:1]) //assuming the index of uinavigationcontroller is 2
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        //判断是否登录过
        if(![defaults boolForKey:@"SalesHelper_publicNotice"])
        {
            if ([defaults valueForKey:@"Login_User_token"] != nil)
            {
                return YES;
            }
            else
            {
                UINavigationController *loginVC = [[UINavigationController alloc] initWithRootViewController:[[LoginViewController alloc]init]];
                [self presentViewController:loginVC animated:YES completion:nil];
                
                return NO;
            }
            //存数据--->基本数据类型
        }
        else
        {
            return YES;
        }
    }
    else
    {
        return YES;
    }
}

//选择城市
- (void)chooseLocationCity
{
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"CoreLocation Storyboard" bundle:nil];
    CoreLocationViewController * location = [storyboard instantiateViewControllerWithIdentifier:@"CoreLocationViewController"];
    location.delegate = self;
    location.hidesBottomBarWhenPushed = YES;
    //    [self.navigationController pushViewController:location animated:YES];
    [self presentViewController:location animated:YES completion:nil];
}

//选择城市回调代理方法 locationDict 存储城市选择界面返回的城市字典
- (void)loadChoosenLocation:(NSDictionary *)loctionDic
{
    locationDict = [loctionDic mutableCopy];
    if(locationDict)
    {
        locationStrCity = [NSString stringWithFormat:@"%@",[locationDict objectForKey:@"id"]];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:locationStrCity  forKey:@"location_City"];
        [defaults synchronize];
        
        
        NSLog(@"%@",locationStrCity);
    }
    else
    {
        //默认城市.
        locationStrCity = @"1171";
    }
    
//    [naviBtn setTitle:[locationDict objectForKey:@"name"] forState:UIControlStateNormal];
    
    [button setTitle:[locationDict objectForKey:@"name"] forState:UIControlStateNormal];
    
    cycleScrollView.autoScroll = YES;
    cycleScrollView.showPageControl = YES;
    
    [self loadScroll];
    [self sendRequestWithCachorNot:YES];
}

#pragma mark --加载轮播图片
- (void)loadScroll
{
    __block NSMutableArray *imagesURLStrings = [NSMutableArray array];
    
    
//    [self.headScrollArr removeAllObjects];
    
    RequestInterface * loadPerpoty = [[RequestInterface alloc] init];
    NSDictionary * param = @{
                             @"cityId":locationStrCity,
                             };
    [loadPerpoty requestGetqueryHeads:param];
//    [self.view Loading_0314];
    [loadPerpoty getInterfaceRequestObject:^(id data) {
        if ([data objectForKey:@"success"])
        {
            
            self.headScrollArr =[NSMutableArray arrayWithArray:[data objectForKey:@"datas"]];
            for (int i = 0 ; i <  self.headScrollArr.count; i++) {
                ;
                [imagesURLStrings addObject:[NSString stringWithFormat:@"%@%@",REQUEST_IMG_SERVER_URL,[ self.headScrollArr[i]objectForKey:@"url"]]];
            }
            
//            NSLog(@"%@",self.headScrollArr);
            
            if ([locationStrCity integerValue] == 1171)
            {
                 [[NSUserDefaults standardUserDefaults] setObject:imagesURLStrings forKey:@"cycleImage"];
            }

            [cycleScrollView setImageURLStringsGroup:imagesURLStrings];

            if(imagesURLStrings.count == 1)
            {
                cycleScrollView.autoScroll = NO;
                cycleScrollView.showPageControl = NO;
            }
        }
        else
        {
            [self.view makeToast:@"加载失败"];
        }
        
    } Fail:^(NSError *error) {
        
    }];
    
    
}

- (void)pushToMap
{
    MapViewController *vc = [[MapViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.cityId = locationStrCity;
    //vc.dataArr = info;
    vc.cityName = [locationDict objectForKey:@"name"];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark --加载数据
- (void)sendRequestWithCachorNot:(BOOL)cach
{
    
    [self.view Loading_0314];

    [info removeAllObjects];
    
    dispatch_group_t group = dispatch_group_create();
    allPageCount = MAXFLOAT;
    
    //默认起始页
    pageIndex = 1;
    dispatch_group_enter(group);
    NSString * pageIdexStr = [NSString stringWithFormat:@"%d",pageIndex];
#pragma mark --定时广告切换数据
    NSDictionary * paramBulletin = @{
                                     @"page":pageIdexStr,
                                     @"size":@"1000",
                                     };
    RequestInterface * loadBull = [[RequestInterface alloc]init];
    loadBull.cachDisk = cach;
    [loadBull requestGetBulletinWithDic:paramBulletin];
    [loadBull getInterfaceRequestObject:^(id data) {
        dispatch_group_leave(group);
//        NSLog(@"%@",data);
        if ([data objectForKey:@"success"])
        {
            bulletin =[NSMutableArray arrayWithArray:[data objectForKey:@"datas"]];
        }
        else
        {

            [self.view makeToast:@"加载失败"];
        }
        
    } Fail:^(NSError *error) {
        dispatch_group_leave(group);

    }];
    
#pragma mark --列表数据
    dispatch_group_enter(group);
    if (locationStrCity != nil) {
//        NSLog(@"%@",locationStrCity);
    NSDictionary * param = @{
                             @"districtPId":locationStrCity,
                             @"page":pageIdexStr,
                             @"size":@"10",
                             };
    RequestInterface * loadPerpoty = [[RequestInterface alloc] init];
    loadPerpoty.cachDisk = cach;
    [loadPerpoty requestGetPropertyInfosWithParam:param];
    [loadPerpoty getInterfaceRequestObject:^(id data) {

        dispatch_group_leave(group);
      
        if ([data objectForKey:@"success"])
        {
//            NSLog(@"loupan%@",data);
            if ([data[@"datas"] count] > 0) {
                
                [info addObjectsFromArray:[data objectForKey:@"datas"]];
            }
        }
        else
        {
            [self.view makeToast:@"加载失败"];
        }
        [self.tableView headerEndRefreshing];
    } Fail:^(NSError *error) {
        dispatch_group_leave(group);

        [self.tableView headerEndRefreshing];
        [self.view makeToast:@"网络加载失败"];

    }];
    }
//#pragma mark --
//    dispatch_group_enter(group);
//    RequestInterface * loadPerpoty2 = [[RequestInterface alloc] init];
//    loadPerpoty2.cachDisk = cach;
//    [loadPerpoty2 requestGetEstateState];
//    [loadPerpoty2 getInterfaceRequestObject:^(id data) {
//        if ([data objectForKey:@"success"])
//        {
//            dispatch_group_leave(group);
//            EstateStateArr = [NSMutableArray arrayWithArray:[data objectForKey:@"datas"]];
//        }
//        else
//        {
////            [self.view Hidden];
//            [self.view makeToast:@"加载失败"];
//        }
//        
//    } Fail:^(NSError *error) {
//        dispatch_group_leave(group);
////        [self.view Hidden];
//    }];
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        
        [self.tableView headerEndRefreshing];
        self.tableView.tableFooterView = [[UIView alloc]init];
        self.tableView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64-49);
        [_tableView reloadData];
        ifNoData = NO;
        [self.view Hidden];
    });
    
}
#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        
        if (indexPath.row == 0)
        {
            return 100;
        }
        if (indexPath.row ==1 )
        {
            return 35;
        }
    }else{
        return 100;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 1)
    {
        return 10;
    }
    return 0.1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    }else{
        return info.count;
    }
}

- (void)clickButton:(UIButton *)sender
{
    if (sender.tag == 100)
    {
        [self search];
    }
    else if (sender.tag == 101)
    {
        TwohandHouseViewController *vc = [[TwohandHouseViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (sender.tag == 102)
    {

        if (![GetOrgType isEqualToString:@"2"])
        {
            [self.view makeToast:@"您无权限进行此操作，请先绑定机构码" duration:1.0 position:@"bottom"];
        }
        else
        {
            NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
            NSString *token = [defaults objectForKey:@"Login_User_token"];
            NSDictionary * dict;
            int value = arc4random();
            NSString * randomNum = [NSString stringWithFormat:@"%d",value];
            if (token != nil)
            {
                dict = @{@"token":token,
                         @"redirect":@"",
                         @"uuid":randomNum
                         };
            }else{
                dict = @{@"uuid":randomNum};
            }
            RequestInterface *request = [[RequestInterface alloc] init];
            [request requestVisitCreditsShopWith:dict];
//            [self.view makeProgressViewWithTitle:@"正在更新"];
            [request getInterfaceRequestObject:^(id data) {
                [self.view hideProgressView];
                if ([[data objectForKey:@"success"] boolValue]) {
                    
                    creditsUrl = data[@"url"];
                    CreditWebViewController *web=[[CreditWebViewController alloc]initWithUrl:creditsUrl];
                    
                    web.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:web animated:YES];
                }
                
            } Fail:^(NSError *error) {
//                [self.view hideProgressView];
                [self.view makeToast:HintWithNetError];
            }];

        }
        
        
    }
    else
    {
        
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        if(![defaults boolForKey:@"SalesHelper_publicNotice"])
        {
            if ([defaults valueForKey:@"Login_User_token"] != nil)
            {
                if ([GetOrgType isEqualToString:@"2"])
                {

//                    MySaleOfficeViewController * vc = [[MySaleOfficeViewController alloc]init];
                    MySalesCenterViewController * vc = [[MySalesCenterViewController alloc]init];
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                    
  
                }else
                {
                    [self.view makeToast:@"您无权限，请先绑定机构码" duration:1.0 position:@"center"];
                }
            }
            else
            {
                UINavigationController *mainNaVC = [[UINavigationController alloc] initWithRootViewController:[[LoginViewController alloc]init]];
                [self presentViewController:mainNaVC animated:YES completion:nil];
            }
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.section ==0)
    {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"%ld", (long)indexPath.row]];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 0)
        {
            

//            NSLog(@"count = %d",cell.contentView.subviews.count);
            if (cell.contentView.subviews.count ==0) {
                
                NSArray *picArray = @[
                                      @{@"name":@"新房", @"title":@"新房"},
                                      @{@"name":@"二手房", @"title":@"二手房"},
                                      @{@"name":@"积分", @"title":@"积分商城"},
                                      @{@"name":@"我的售楼部", @"title":@"我的售楼部"}];
                
                for (int i = 0; i<4; i++)
                {
                    CGFloat width = SCREEN_WIDTH/4;
                    UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(width*i, 15, width, 46)];
                    [button2 setImage:[UIImage imageNamed:picArray[i][@"name"]]  forState:UIControlStateNormal];
                    button2.tag = 100+i;
                    [button2 addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
                    [cell.contentView addSubview:button2];
                    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(width*i, 15+50, width, 15)];
                    label.text = picArray[i][@"title"];
                    label.font = Default_Font_13;
                    label.textAlignment = NSTextAlignmentCenter;
                    label.textColor = [UIColor hexChangeFloat:KGrayColor];
                    
                    [cell.contentView addSubview:label];
                }
            }
            return cell;
        }
        else if (indexPath.row == 1)
        {
        
            UIImageView* image = [[UIImageView alloc]initWithFrame:CGRectMake(10,10, 14, 14)];
            image.image = [UIImage imageNamed:@"销邦-首页-新-通知.png"];
            [cell.contentView addSubview:image];
    
            labelll = [[UILabel alloc]initWithFrame:CGRectMake(30,7, SCREEN_WIDTH-50, 20)];
            labelll.text = [bulletin[0] objectForKey:@"logTitle"];
            labelll.font = Default_Font_12;
            [labelll setTextAlignment:NSTextAlignmentLeft];
            labelll.textColor = [UIColor hexChangeFloat:KHuiseColor];
            [cell.contentView addSubview:labelll];
            
//            if ([bulletin count])
//            {
//                [self stopTimer];
//                [self startTimer];
//            }
           
        }
         return cell;
    }
    else
    {
        HomeTabViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"HomeCell" forIndexPath:indexPath];
        
        if ([info count]>0)
        {
            
            [cell setAttributeForCell:info[indexPath.row]];
 
        }
        return cell;
      }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        
        if (indexPath.row == 1)
        {
            NoticeWebDetailViewController * web = [[NoticeWebDetailViewController alloc]initWithUrlString:[[bulletin objectAtIndex:0] objectForKey:@"logAnnounceurl"] NavigationTitle:@"公告"];
//            NSLog(@"%@",[[bulletin objectAtIndex:0] objectForKey:@"logAnnounceurl"]);
            web.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:web animated:YES];
        }
    }
    if (indexPath.section == 1)
    {
        //        UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        //        PropertyDetailViewController * Property = [storyboard instantiateViewControllerWithIdentifier:@"PropertyDetailViewController"];
        //        Property.hidesBottomBarWhenPushed=YES;
        
        PropertyDetailViewController *Property = [[PropertyDetailViewController alloc] init];
        Property.hidesBottomBarWhenPushed = YES;
        
//        HomeTabViewCell * cell =  (HomeTabViewCell *)[tableView cellForRowAtIndexPath:indexPath];
//        Property.titlestr = cell.communityName.text;
//        Property.ID = cell.ID;
        Property.ID = [info[indexPath.row] objectForKey:@"id"];
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        [self.navigationController pushViewController:Property animated:YES];
    }
    
}



-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView.isDragging)
    {
       [inputField resignFirstResponder];
    }
    
}

#pragma mark --下拉刷新上拉加载
//刷新tableView
-(void)refreshingTableView
{
    //下拉刷新
    __weak  HomeTabViewController * h = self;
    [_tableView addHeaderWithCallback:^{
        [h.tableView headerEndRefreshing];
        [h refreshingHeaderTableView];
    }];
    
    //上拉加载
    [_tableView addFooterWithCallback:^{
        [h.tableView footerEndRefreshing];
        [h refreshingFooterTableView];
    }];
    
//    [self.tableView triggerPullToRefresh];
//    [self.tableView addInfiniteScrollingWithActionHandler:^{
//        [h refreshingFooterTableView];
//    }];
    
}

#pragma mark --  SVPullRefresh
-(void)newRefreshTableView
{
    __weak HomeTabViewController * temp = self;
    
    [_tableView addHeaderWithCallback:^{
        [temp.tableView headerEndRefreshing];
        [temp refreshingHeaderTableView];
    }];
    
    [self.tableView triggerPullToRefresh];
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        if (!ifNoData)
        {
            [temp refreshingFooterTableViewNew];
        }
        else
        {
            [temp.tableView.infiniteScrollingView stopAnimating];
        }
    }];
}

//下拉刷新
-(void)refreshingHeaderTableView
{
    [self loadScroll];
    
    [self sendRequestWithCachorNot:NO];
}

-(void)refreshingFooterTableViewNew
{
    pageIndex ++;
    NSString * pageIdexStr = [NSString stringWithFormat:@"%d",pageIndex];
    NSDictionary * param = @{
                             @"districtPId":locationStrCity,
                             @"page":pageIdexStr,
                             @"size":@"10",
                             };
    
    RequestInterface * loadPerpoty = [[RequestInterface alloc] init];
    [self.view Loading_0314];
    [loadPerpoty requestGetPropertyInfosWithParam:param];
    [loadPerpoty getInterfaceRequestObject:^(id data) {
        if ([data objectForKey:@"success"])
        {
            
            [self.view Hidden];
            
            [info addObjectsFromArray:[data objectForKey:@"datas"]];
            
            if ([[data objectForKey:@"datas"] count] == 10 )
            {
                NSString * pageIdexStr1 = [NSString stringWithFormat:@"%d",pageIndex+1];
                NSDictionary * param1 = @{
                                          @"districtPId":locationStrCity,
                                          @"page":pageIdexStr1,
                                          @"size":@"10",
                                          };
                RequestInterface * loadPerpoty1 = [[RequestInterface alloc] init];
                
                [loadPerpoty1 requestGetPropertyInfosWithParam:param1];
                [loadPerpoty1 getInterfaceRequestObject:^(id data) {

                    if (![[data objectForKey:@"datas"] count])
                    {
                        [self noDataAddBottomView];
                        self.tableView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64);
                        ifNoData = YES;
                        [self.view makeToast:@"没有更多数据了"];
                    }
                 
                    
                } Fail:^(NSError *error) {
                }];
                
            }
            else if ([[data objectForKey:@"datas"] count] < 10 &&
                     [[data objectForKey:@"datas"] count] >0)
            {
                
                [self noDataAddBottomView];
                self.tableView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64);
                ifNoData = YES;
                [self.view makeToast:@"没有更多数据了"];
            }
//            if (![[data objectForKey:@"datas"] count])
//            {
//                [self.view makeToast:@"没有更多数据了"];
//            }
            [self.tableView.infiniteScrollingView stopAnimating];
            [_tableView reloadData];
        }
        else
        {
            [self.view Hidden];
            pageIndex--;
            [self.tableView.infiniteScrollingView stopAnimating];
            
        }
    } Fail:^(NSError *error) {
        NSLog(@"上拉加载信息出错啦");
        [self.view Hidden];
        pageIndex--;
        [self.tableView.infiniteScrollingView stopAnimating];
        
    }];
    
}

//上拉加载---不再用
-(void)refreshingFooterTableView
{
    
    pageIndex ++;
    NSString * pageIdexStr = [NSString stringWithFormat:@"%d",pageIndex];
    NSDictionary * param = @{
                             @"districtPId":locationStrCity,
                             @"page":pageIdexStr,
                             @"size":@"10",
                             };
    
    RequestInterface * loadPerpoty = [[RequestInterface alloc] init];
    [self.view Loading_0314];
    [loadPerpoty requestGetPropertyInfosWithParam:param];
    [loadPerpoty getInterfaceRequestObject:^(id data) {
        if ([data objectForKey:@"success"])
        {

            [self.view Hidden];
            
            [info addObjectsFromArray:[data objectForKey:@"datas"]];
            
            NSString * pageIdexStr1 = [NSString stringWithFormat:@"%d",pageIndex+1];
            NSDictionary * param1 = @{
                                     @"districtPId":locationStrCity,
                                     @"page":pageIdexStr1,
                                     @"size":@"10",
                                     };
            RequestInterface * loadPerpoty1 = [[RequestInterface alloc] init];
            
            [loadPerpoty1 requestGetPropertyInfosWithParam:param1];
            [loadPerpoty1 getInterfaceRequestObject:^(id data) {
                if (![[data objectForKey:@"datas"] count])
                {
                     [_tableView footerEndRefreshing];

                      [self noDataAddBottomView];
                }
                
            } Fail:^(NSError *error) {
                [_tableView footerEndRefreshing];
            }];
            
            if (![[data objectForKey:@"datas"]count])
            {
                
                [self.view makeToast:@"没有更多数据了"];
 
            }
            else
            {
                self.tableView.tableFooterView.hidden = YES;
            }
            
            [_tableView footerEndRefreshing];
//             [self.tableView.infiniteScrollingView stopAnimating];
            [_tableView reloadData];
            
        }
        else
        {
            
            [self.view Hidden];
            pageIndex--;
            [_tableView footerEndRefreshing];
//             [self.tableView.infiniteScrollingView stopAnimating];
            
        }
    } Fail:^(NSError *error) {
        //
        NSLog(@"上拉加载信息出错啦");
        [self.view Hidden];
        pageIndex--;
        [_tableView footerEndRefreshing];
//         [self.tableView.infiniteScrollingView stopAnimating];
        
    }];
}


-(void)noDataAddBottomView
{
    UIView  * footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,120)];
    footerView.backgroundColor = [UIColor whiteColor];
    UILabel * noticeLab = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-250)/2, 10, 250, 20)];
    noticeLab.text = @"上面没有找到合适的意向楼盘";
    noticeLab.textAlignment = NSTextAlignmentCenter;
    noticeLab.textColor = [UIColor hexChangeFloat:KGrayColor];
    noticeLab.font = Default_Font_15;
    [footerView addSubview:noticeLab];
    
    inputField = [[UITextField alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(noticeLab.frame)+10, 240*SCREEN_WIDTH/320, 30)];
    inputField.placeholder = @"输入我想推荐的楼盘名称";
    inputField.font = Default_Font_15;
    //                inputField.backgroundColor = [UIColor colorWithRed:234/255.0f green:234/255.0f blue:237/255.0f alpha:1];
    inputField.borderStyle = UITextBorderStyleRoundedRect;
    inputField.contentMode = UIViewContentModeCenter;
    inputField.layer.cornerRadius = 5.0f;
    inputField.layer.masksToBounds = YES;
    inputField.delegate = self;
    [footerView addSubview:inputField];
    
    UIButton * submitBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(inputField.frame)+10, CGRectGetMaxY(noticeLab.frame)+10, 50*SCREEN_WIDTH/320, 30)];
    submitBtn.titleLabel.font =  Default_Font_15;
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    submitBtn.backgroundColor = [UIColor hexChangeFloat:@"00aff0"];
    submitBtn.layer.borderWidth = 1.0f;
    submitBtn.layer.borderColor = [UIColor hexChangeFloat:@"00aff0"].CGColor;
    submitBtn.layer.masksToBounds = YES;
    [submitBtn addTarget:self action:@selector(clickToSubmitProperty) forControlEvents:UIControlEventTouchUpInside];
    submitBtn.layer.cornerRadius = 5.0f;
    [footerView addSubview:submitBtn];
    
    UIView * endView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(submitBtn.frame)+10, SCREEN_WIDTH, 40)];
    endView.backgroundColor = [UIColor colorWithRed:239/255.0f green:239/255.0f blue:244/255.0f alpha:1];
    UILabel * endLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 20)];
    endLab.text = @"—— END ——";
    endLab.textColor = [UIColor hexChangeFloat:KGrayColor];
    endLab.font = Default_Font_15;
    endLab.textAlignment = NSTextAlignmentCenter;
    [endView addSubview:endLab];
    [footerView addSubview: endView];
    self.tableView.tableFooterView = footerView;

}

///提交楼盘
-(void)clickToSubmitProperty
{
    
    
    [inputField resignFirstResponder];
    if (inputField.text.length == 0)
    {
        [self.view makeToast:@"请填写楼盘"];
        
    }
    else
    {
        
        if (GetUserID != nil)
        {
            NSDictionary* dict = @{
                                   @"token":GetUserID,
                                   @"propertyName":inputField.text
                                   };
            RequestInterface * interface = [[RequestInterface alloc]init];
            [interface requestClientRecommandPropertyToSaleHelperWithParam:dict];
            [interface getInterfaceRequestObject:^(id data) {
                if ([[data objectForKey:@"success"] boolValue])
                {
                    
                    [self.view makeToast:data[@"message"] duration:0.5 position:@"center"];
                }
                else
                {
                    [self.view makeToast:data[@"message"]];
                }
            } Fail:^(NSError *error) {
                
            }];
            
        }
        else
        {
            [self.view makeToast:@"请先登录"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                UINavigationController *mainNaVC = [[UINavigationController alloc] initWithRootViewController:[[LoginViewController alloc]init]];
                [self presentViewController:mainNaVC animated:YES completion:nil];
            });
            
        }
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [inputField resignFirstResponder];
    return YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    
   
}


#pragma mark - 图片轮播 代理
-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    if ([[self.headScrollArr[index]objectForKey:@"type"] intValue] == 2)
    {
        //        UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        //        PropertyDetailViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"PropertyDetailViewController"];
        
        PropertyDetailViewController *vc = [[PropertyDetailViewController alloc] init];
        vc.ID = [self.headScrollArr[index]objectForKey:@"contents"];
        vc.titlestr = [self.headScrollArr[index]objectForKey:@"title"];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if ([[self.headScrollArr[index]objectForKey:@"type"] intValue] == 1 )
    {
        if ([self.headScrollArr[index]objectForKey:@"contents"] != [NSNull null] && [[self.headScrollArr[index]objectForKey:@"type"] integerValue] > 0 && [self.headScrollArr[index]objectForKey:@"contents"]  != nil && [self.headScrollArr[index]objectForKey:@"contents"])
        {
            ModelWebViewController * web = [[ModelWebViewController alloc]initWithUrlString:[self.headScrollArr[index]objectForKey:@"contents"] NavigationTitle:[self.headScrollArr[index]objectForKey:@"title"]];
            web.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:web animated:YES];
        }
        
    }
    if ([[self.headScrollArr[index]objectForKey:@"type"] intValue] == 3 )
    {
        if ([self.headScrollArr[index]objectForKey:@"contents"] != [NSNull null]  && [[self.headScrollArr[index]objectForKey:@"type"] integerValue] > 0 && [self.headScrollArr[index]objectForKey:@"contents"]  != nil && [self.headScrollArr[index]objectForKey:@"contents"])
        {
            ModelWebViewController * web = [[ModelWebViewController alloc]initWithUrlString:[self.headScrollArr[index]objectForKey:@"contents"] NavigationTitle:[self.headScrollArr[index]objectForKey:@"title"]];
            web.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:web animated:YES];
        }
    }
    
}


//#pragma mark - 第一行按钮点击事件
//-(void)click_btn:(UIButton *)button1
//{
//    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    SearchPropertyViewController * search = [storyboard instantiateViewControllerWithIdentifier:@"SearchPropertyViewController"];
//    search.locationStr = locationStrCity;
//    switch (button1.tag) {
//        case 10:
//            search.choosenDic = EstateStateArr[0];
//            break;
//        case 11:
//            search.choosenDic = EstateStateArr[3];
//            break;
//        case 12:
//            search.choosenDic = EstateStateArr[2];
//            break;
//        case 13:
//            search.choosenDic = EstateStateArr[4];
//            break;
//        case 14:
//            search.choosenDic = EstateStateArr[1];
//            break;
//        default:
//            break;
//    }
//    [self.navigationController pushViewController:search animated:YES];
//}

#pragma mark -- 搜索
-(void)searchForNewProperty
{
    
    [self search];
    
}

#pragma mark - navigationitem点击事件
//跳转到搜索界面
- (void)search
{
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SearchPropertyViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"SearchPropertyViewController"];
    vc.hidesBottomBarWhenPushed=YES;
    vc.locationStr = locationStrCity;
    [self.navigationController pushViewController:vc animated:YES];
    
}

//使列表的分割线顶格开始
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 0)];
    }
    
    
    if (IOS_VERSION >= 8.0)
    {
        if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)])
        {
            [cell setPreservesSuperviewLayoutMargins:NO];
        }
        if ([cell respondsToSelector:@selector(setLayoutMargins:)])
        {
            [cell setLayoutMargins:UIEdgeInsetsMake(0, 10, 0, 0)];
        }
    }
}


////公告滚动取消
//- (void)valueChange
//{
//    indexStep ++;
//    if (indexStep == bulletin.count) {
//        indexStep = 0;
//    }
//    labelll.text = bulletin[indexStep][@"logTitle"];
//}
//- (void)startTimer
//{
//    timer =  [NSTimer scheduledTimerWithTimeInterval:6.0
//                                              target:self
//                                            selector:@selector(valueChange)  userInfo:nil
//                                             repeats:YES];
//}
//- (void)stopTimer
//{
//    if (timer != nil)
//    {
//        // 定时器调用invalidate后，就会自动执行release方法。不需要在显示的调用release方法
//        [timer invalidate];
//    }
//}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
//    [self stopTimer];// 停止定时器
    
}
//状态改变重新请求数据
-(void)sendrRequestWithStateChange
{
    
    
    
    allPageCount = MAXFLOAT;
    //默认起始页
    pageIndex = 1;
    NSString * pageIdexStr = [NSString stringWithFormat:@"%d",pageIndex];
    if (locationStrCity != nil) {
        
        NSDictionary * param = @{
                                 @"districtPId":locationStrCity,
                                 @"page":pageIdexStr,
                                 @"size":@"10",
                                 };
        RequestInterface * loadPerpoty = [[RequestInterface alloc] init];
        loadPerpoty.cachDisk = NO;
        [loadPerpoty requestGetPropertyInfosWithParam:param];
        [loadPerpoty getInterfaceRequestObject:^(id data) {
            
            if ([data objectForKey:@"success"])
            {
                if ([[data objectForKey:@"datas"] count] > 0)
                {
                    [info removeAllObjects];
                    [info addObjectsFromArray:[data objectForKey:@"datas"]];
//                    NSLog(@"请求数据%@",info);
                }
            }
            else
            {
//                [self.view Hidden];
                [self.view makeToast:@"加载失败"];
            }
            self.tableView.tableFooterView = [[UIView alloc]init];
            self.tableView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64-49);
            [self.tableView reloadData];
        } Fail:^(NSError *error) {
            
//            [self.view Hidden];
            [self.view makeToast:@"网络加载失败"];
        }];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
