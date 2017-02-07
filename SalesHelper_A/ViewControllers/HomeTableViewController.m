//
//  HomeTableViewController.m
//  SalesHelper_A
//
//  Created by ZhipuTech on 15/6/11.
//  Copyright (c) 2015年 X. All rights reserved.
//

#import "HomeTableViewController.h"
#import "URLRequest.h"
#import "UIColor+Extend.h"
#import "LoginViewController.h"

#import "UIImageView+WebCache.h"

//#import "RecommendViewController.h"
#import "PropertyDetailViewController.h"
#import "HomeTableViewCell.h"
#import "SDCycleScrollView.h"
#import "SearchPropertyViewController.h"
#import "ModelWebViewController.h"
#import "MPFoldTransition.h"
#import "CoreLocationViewController.h"
#import "arrowBtn.h"
#import <QuartzCore/QuartzCore.h>
#import "UIScrollView+EmptyDataSet.h"
#import "AppDelegate.h"
#import "MapViewController.h"

#import "TwohandHouseViewController.h"
#import "RecommendClientViewController.h"


@interface HomeTableViewController () <UITableViewDataSource, UITableViewDelegate, SDCycleScrollViewDelegate, locationChooseDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, UITabBarControllerDelegate,UISearchBarDelegate>
{
    //定时器
    NSTimer * timer;
    //滚动公告视图
    UIView * contentView;
    //所有数据信息
    NSMutableArray * info;
    
    //公告数据信息
    NSMutableArray * bulletin;
    
    __weak IBOutlet UITableView * _tableView;
    
    NSMutableArray * EstateStateArr;
    
    NSMutableArray * headScrollArr;
    
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
    
    SDCycleScrollView * cycleScrollView;
    
    CGFloat topHeight;
    
    UIImage *_heardImage;
    
    UIView* _topView;
    
    UISearchBar* _searchBar;
    
    UILabel * labelll;
}

@end

@implementation HomeTableViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
//    self.navigationController.navigationBar.translucent = NO;
//    
//    [self.navigationController.navigationBar setBackgroundImage:[self imageWithBgColor:[UIColor colorWithRed:23/255.0f green:183/255.0f blue:242/255.0f alpha:1]] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:[self imageWithBgColor:[UIColor colorWithRed:23/255.0f green:183/255.0f blue:242/255.0f alpha:1]]];
    
//    [self startTimer];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //self.view.backgroundColor =[UIColor colorWithRed:0 green:175/255.0f blue:240/255.0f alpha:1];
    
    //[self creatTopView];
    
    //判断网络状态
    Reachability *netWorkReachable = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    if ([netWorkReachable currentReachabilityStatus] == NotReachable)
    {
        [self.view makeToast:@"网络无法连接" duration:0.8 position:@"center"];
    }
    
    //如果是iPhone4
    if (self.view.width == 320)
    {
        topHeight = 125;
    }
    //如果是iPhone6s Pluse
    else if (self.view.width == 414)
    {
        topHeight = 161;
    }
    //其他机型
    else
    {
        topHeight = 146;
    }
    
//    _tableView.contentInset = UIEdgeInsetsMake(40, 0, 0, 0);
//    UIView *searchVIew = [[UIView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, 40)];
//    searchVIew.backgroundColor = [UIColor colorWithRed:23/255.0f green:183/255.0f blue:242/255.0f alpha:1.0];
//    [self.view addSubview:searchVIew];
//    
//    UIButton *searchbtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 5, SCREEN_WIDTH-30, 30)];
//    searchbtn.backgroundColor = [UIColor whiteColor];
//    searchbtn.layer.cornerRadius = 15;
//    searchbtn.layer.masksToBounds = YES;
//    [searchbtn setImage:[UIImage imageNamed:@"首页_搜索"] forState:UIControlStateNormal];
//    [searchbtn setTitle:@"请输入楼盘名称" forState:UIControlStateNormal];
//    searchbtn.titleLabel.font = Default_Font_15;
//    [searchbtn setTitleColor:[UIColor hexChangeFloat:KGrayColor] forState:UIControlStateNormal];
//    [searchbtn addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
//    [searchVIew addSubview:searchbtn];
    
    if(locationDict)
    {
        locationStrCity = [NSString stringWithFormat:@"%@",[locationDict objectForKey:@"id"]];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:locationStrCity  forKey:@"location_City"];
        [defaults synchronize];
        [self sendRequestWithCachorNot:YES];
        
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
            [defaults setObject:@"合肥" forKey:@"Login_User_currentLocationCity"];
            [defaults synchronize];
        }
        else
        {
            cityName = [defaults objectForKey:@"Login_User_currentLocationCity"];
        }
        arrowBtn * button = [[arrowBtn alloc]initWithFrame:CGRectMake(0, 0, 60, 35)];
        button.titleLabel.font = [UIFont systemFontOfSize:18];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(chooseLocationCity) forControlEvents:UIControlEventTouchUpInside];
        [button setImage:[UIImage imageNamed:@"形状-16.png"] forState:UIControlStateNormal];
        naviBtn = button;
        [button setImageEdgeInsets:UIEdgeInsetsMake(0.0, 45, 0.0, 0.0)];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0.0, -30, 0.0, 0.0)];
        self.navigationItem.titleView = button;
        
        NSDictionary * dict = @{
                                @"ctiyName":cityName,
                                };
        [self.view Loading_0314];
        [interface requestGetLocationCityWithParam:dict];
        [interface getInterfaceRequestObject:^(id data) {
            if ([[data objectForKey:@"success"] boolValue])
            {
                locationStrCity = [data objectForKey:@"datas"];
                [defaults setObject:locationStrCity forKey:@"location_City"];
                [button setTitle:cityName forState:UIControlStateNormal];
            }
            else
            {
                [self.view makeToast:@"您所在的城市暂未开通服务,默认为合肥"];
                [button setTitle:@"合肥" forState:UIControlStateNormal];
                locationStrCity = @"1171";
                [defaults setObject:locationStrCity forKey:@"location_City"];
                [defaults setObject:@"合肥" forKey:@"Login_User_currentLocationCity"];
                [defaults synchronize];
                
            }
            [self sendRequestWithCachorNot:YES];
//            [self loadNaviBarItems];
            
            [self loadScroll];
            
        } Fail:^(NSError *error)
         {
             [button setTitle:@"合肥" forState:UIControlStateNormal];
             locationStrCity = @"1171";
             [defaults setObject:locationStrCity forKey:@"location_City"];
             [defaults setObject:@"合肥" forKey:@"Login_User_currentLocationCity"];
             [defaults synchronize];
             [self sendRequestWithCachorNot:YES];
//             [self loadNaviBarItems];
             
             [self loadScroll];
         }];
        
    }
    [self refreshingTableView];
    
    self.tabBarController.delegate = self;
    
}

-(void)creatTopView{
    
    _topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    _topView.backgroundColor = [UIColor clearColor];
    _topView.userInteractionEnabled = YES;
    [self.view addSubview:_topView];
    
    //    UIButton* mapBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-21-10, 24, 21, 21)];
    //    [mapBtn  setImage:[UIImage imageNamed:@"首页_地图"] forState:UIControlStateNormal];
    //    [_topView addSubview:mapBtn];
    //
    //
    //    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(10, 20, SCREEN_WIDTH-10-31, 32)];
    //    view.layer.cornerRadius = 16;
    //    view.layer.masksToBounds = YES;
    //    view.backgroundColor = [UIColor whiteColor];
    //    [_topView addSubview:view];
    //
    //    NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
    //    NSString *cityName = [userInfo objectForKey:@"Login_User_currentLocationCity"];
    //
    //    UIButton* cityButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 0, 50, 32 )];
    //    cityButton.titleLabel.font = Default_Font_15;
    //    [cityButton setTitle:cityName forState:UIControlStateNormal];
    //    [cityButton setTitleColor:[UIColor hexChangeFloat:@"474747"] forState:UIControlStateNormal];
    //    [cityButton addTarget:self action:@selector(chooseLocationCity) forControlEvents:UIControlEventTouchUpInside];
    //    [view addSubview:cityButton];
    //
    //    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(65, (32-5)/2, 6, 5)];
    //    imageView.image = [UIImage imageNamed:@"首页_下三角形"];
    //    [view addSubview:imageView];
    //
    //    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(80, 5, 0.5, 22)];
    //    label.backgroundColor = [UIColor hexChangeFloat:KQianheiColor];
    //    [view addSubview:label];
    //
    //
    //    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(85, 0, SCREEN_WIDTH-50-90, 32)];
    //    _searchBar.delegate = self;
    //    _searchBar.searchBarStyle = UISearchBarStyleDefault;
    //    [_searchBar setBackgroundImage:[ProjectUtil imageWithColor:RGBACOLOR(235, 236, 238, 1) size:CGSizeMake(0.1f, 0.1f)]];
    //    [_searchBar setContentMode:UIViewContentModeLeft];
    //    _searchBar.placeholder = @"请输入楼盘名称";
    //    [view addSubview:_searchBar];
    
    
}


- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    if (viewController == [tabBarController.viewControllers objectAtIndex:3]) //assuming the index of uinavigationcontroller is 2
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



- (void)chooseLocationCity
{
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"CoreLocation Storyboard" bundle:nil];
    CoreLocationViewController * location = [storyboard instantiateViewControllerWithIdentifier:@"CoreLocationViewController"];
    location.delegate = self;
    location.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:location animated:YES];
    [self presentViewController:location animated:YES completion:nil];
}

- (void)loadChoosenLocation:(NSDictionary *)loctionDic
{
    locationDict = [loctionDic mutableCopy];
    if(locationDict)
    {
        locationStrCity = [NSString stringWithFormat:@"%@",[locationDict objectForKey:@"id"]];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:locationStrCity  forKey:@"location_City"];
        [defaults synchronize];
    }
    else
    {
        //默认城市.
        locationStrCity = @"1171";
    }
    
    [naviBtn setTitle:[locationDict objectForKey:@"name"] forState:UIControlStateNormal];
    
    [self loadScroll];
    [self sendRequestWithCachorNot:YES];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    //    indexStep = 0;
    //    [self startTimer];
    
}

#pragma mark --加载轮播图片


- (void)loadScroll
{
    __block NSMutableArray *imagesURLStrings = [NSMutableArray array];
    
    RequestInterface * loadPerpoty = [[RequestInterface alloc] init];
    NSDictionary * param = @{
                             @"cityId":locationStrCity,
                             };
    [loadPerpoty requestGetqueryHeads:param];
    
    
    [loadPerpoty getInterfaceRequestObject:^(id data) {
        if ([data objectForKey:@"success"]) {
            headScrollArr =[NSMutableArray arrayWithArray:[data objectForKey:@"datas"]];
            for (int i = 0 ; i < headScrollArr.count; i++) {
                
                [imagesURLStrings addObject:[NSString stringWithFormat:@"%@%@",REQUEST_IMG_SERVER_URL,[headScrollArr[i]objectForKey:@"url"]]];
            }
            [cycleScrollView removeFromSuperview];
            
            
            // _tableView.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);
            
            cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, self.view.width, topHeight) imageURLStringsGroup:imagesURLStrings];
            
            if(imagesURLStrings.count == 1)
            {
                cycleScrollView.autoScroll = NO;
                cycleScrollView.showPageControl = NO;
            }
            cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
            cycleScrollView.delegate = self;
            cycleScrollView.dotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
            cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
            cycleScrollView.placeholderImage = [UIImage imageNamed:@"top_bg.png"];
            cycleScrollView.autoScrollTimeInterval = 3.0;
            _tableView.tableHeaderView = cycleScrollView;
            
            [_tableView reloadData];
        }
        else
        {
            [self.view Hidden];
            [self.view makeToast:@"加载失败"];
        }
        
    } Fail:^(NSError *error) {
        [self.view Hidden];
    }];
    
    
}




//#pragma mark navibarItems
//- (void)loadNaviBarItems
//{
//    UIButton* btn=[UIButton buttonWithType:UIButtonTypeCustom];
//    btn.frame=CGRectMake(0, 0, 26, 26);
//    UIImage * image =[UIImage imageNamed:@"销邦-首页-搜索.png"];
//    [btn setBackgroundImage:image forState:UIControlStateNormal];
//    [btn setBackgroundImage:[UIImage imageByApplyingAlpha:image] forState:UIControlStateHighlighted];
//    [btn addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem* Search = [[UIBarButtonItem alloc]initWithCustomView:btn];
//    
//    
//    //    UIButton* btn1=[UIButton buttonWithType:UIButtonTypeCustom];
//    //    btn1.frame=CGRectMake(0, 0, 26, 26);
//    //    [btn1 setBackgroundImage:[UIImage imageNamed:@"销邦-首页-新-增加.png"] forState:UIControlStateNormal];
//    //    [btn1 setBackgroundImage:[UIImage imageByApplyingAlpha:[UIImage imageNamed:@"销邦-首页-新-增加.png"]] forState:UIControlStateHighlighted];
//    //    [btn1 addTarget:self action:@selector(add) forControlEvents:UIControlEventTouchUpInside];
//    //    UIBarButtonItem* addBarBtn = [[UIBarButtonItem alloc]initWithCustomView:btn1];
//    //    addBarBtn.tintColor = [UIColor whiteColor];
//    UIButton* btn1=[UIButton buttonWithType:UIButtonTypeCustom];
//    btn1.frame=CGRectMake(0, 0, 26, 26);
//    [btn1 setBackgroundImage:[UIImage imageNamed:@"首页_地图.png"] forState:UIControlStateNormal];
//    [btn1 setBackgroundImage:[UIImage imageByApplyingAlpha:[UIImage imageNamed:@"首页_地图.png"]] forState:UIControlStateHighlighted];
//    [btn1 addTarget:self action:@selector(pushToMap) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem* addBarBtn = [[UIBarButtonItem alloc]initWithCustomView:btn1];
//    addBarBtn.tintColor = [UIColor whiteColor];
//    
//    [self.navigationItem setRightBarButtonItems:@[addBarBtn,Search]];
//    
//}

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
        if ([data objectForKey:@"success"])
        {
            bulletin =[NSMutableArray arrayWithArray:[data objectForKey:@"datas"]];
                    }
        else
        {
            [self.view Hidden];
            [self.view makeToast:@"加载失败"];
        }
        
    } Fail:^(NSError *error) {
        dispatch_group_leave(group);
        [self.view Hidden];
    }];
    
#pragma mark --列表数据
    dispatch_group_enter(group);
    info = [NSMutableArray array];
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
            [info removeAllObjects];
            [info addObjectsFromArray:[data objectForKey:@"datas"]];
        }
        else
        {
            [self.view Hidden];
            [self.view makeToast:@"加载失败"];
        }
        
    } Fail:^(NSError *error) {
        dispatch_group_leave(group);
        [self.view Hidden];
    }];
    
#pragma mark --
    dispatch_group_enter(group);
    RequestInterface * loadPerpoty2 = [[RequestInterface alloc] init];
    loadPerpoty2.cachDisk = cach;
    [loadPerpoty2 requestGetEstateState];
    [loadPerpoty2 getInterfaceRequestObject:^(id data) {
        if ([data objectForKey:@"success"])
        {
            dispatch_group_leave(group);
            EstateStateArr = [NSMutableArray arrayWithArray:[data objectForKey:@"datas"]];
        }
        else
        {
            [self.view Hidden];
            [self.view makeToast:@"加载失败"];
        }
        
    } Fail:^(NSError *error) {
        dispatch_group_leave(group);
        [self.view Hidden];
    }];
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [_tableView reloadData];
        [self.view Hidden];
    });
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            return 94;
        }
        if (indexPath.row ==1 )
        {
            return 31;
        }
    }
    else
    {
        return 95;
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0)
    {
        return 2;
    }
    else
    {
        return info.count;
    }
}

- (IBAction)recommend:(id)sender {
    
    //    NSDictionary *dict = @{
    //
    //                           @"customization_token" :@"0",
    //                           @"district_id" :locationStrCity,
    //                           @"page" : @"0",
    //                           @"price_id" :@"0" ,
    //                           @"proportion_id":@"0",
    //                           @"size":@"12"
    //                           };
    //    //选择界面view
    //    SelectRealestateViewController *selectVC = [[SelectRealestateViewController alloc] init];
    //    selectVC.hidesBottomBarWhenPushed = YES;
    //
    //
    //    [ProjectUtil showLog:@"Login_User_token= %@ ",[[NSUserDefaults standardUserDefaults] valueForKey:@"Login_User_token"]];
    //    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //    //判断是否登录过
    //    if(![defaults boolForKey:@"SalesHelper_publicNotice"])
    //    {
    //        if ([defaults valueForKey:@"Login_User_token"] != nil) {
    //            [self.navigationController pushViewController:selectVC animated:YES];
    //
    //        }else {
    //            UINavigationController *mainNaVC = [[UINavigationController alloc] initWithRootViewController:[[LoginViewController alloc]init]];
    //            [self presentViewController:mainNaVC animated:YES completion:nil];
    //        }
    //        //存数据--->基本数据类型
    //        [defaults setBool:NO forKey:@"SalesHelper_publicNotice"];//存在公告内容
    //        [defaults setBool:NO forKey:@"SalesHelper_AdvertView"];//存在公告内容
    //        [defaults synchronize];
    //    }
    //    [ProjectUtil showLog:@"更新Rootviewcontroller"];
    //
    //    selectVC.title = @"推荐";
    //    selectVC.requestDict = [NSMutableDictionary dictionaryWithDictionary:dict];
    //
    //    [selectVC creatBackButtonWithPushType:Push With:@"销邦" Action:nil];
    
    
    
}


- (void)clickButton:(UIButton *)sender
{
    if (sender.tag == 100)
    {
        
//        SubmitPostViewController *vc = [[SubmitPostViewController alloc] init];
//        vc.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:vc animated:YES];
//        AlbumViewController *vc = [[AlbumViewController alloc] init];
//        vc.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:vc animated:YES];
        
        
//        [self search];
    }
    else if (sender.tag == 101)
    {
        TwohandHouseViewController *vc = [[TwohandHouseViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (sender.tag == 102)
    {
        [self pushToMap];
    }
    else
    {
        
//        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
//        if(![defaults boolForKey:@"SalesHelper_publicNotice"])
//        {
//            if ([defaults valueForKey:@"Login_User_token"] != nil)
//            {
//                RecommendClientViewController *vc = [[RecommendClientViewController alloc] init];
//                vc.hidesBottomBarWhenPushed = YES;
//                [self.navigationController pushViewController:vc animated:YES];
//            }
//            else
//            {
//                UINavigationController *mainNaVC = [[UINavigationController alloc] initWithRootViewController:[[LoginViewController alloc]init]];
//                [self presentViewController:mainNaVC animated:YES completion:nil];
//            }
//        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell = nil;
    if (indexPath.section == 0)
    {
        
        
        if (indexPath.row == 0)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"firstCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (cell.contentView.subviews.count ==0) {
                
             NSArray *picArray = @[
                                  @{@"name":@"新房", @"title":@"新房"},
                                  @{@"name":@"二手房源", @"title":@"二手房源"},
                                  @{@"name":@"地图", @"title":@"地图"},
                                  @{@"name":@"快速推荐", @"title":@"快速推荐"}];
            
            for (int i = 0; i<4; i++)
            {
                UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-46*4)/5*(i+1) + 46*i, 15, 46, 46)];
                [button setBackgroundImage:[UIImage imageNamed:picArray[i][@"name"]] forState:UIControlStateNormal];
                button.tag = 100+i;
                [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:button];
                
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-46*4)/5*(i+1) + 46*i-7, 15+50, 60, 15)];
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
            cell = [tableView dequeueReusableCellWithIdentifier:@"SecondCell"];
            labelll = (UILabel *)[cell viewWithTag:724];
            labelll.text = [bulletin[0]objectForKey:@"logTitle"];
            [labelll setTextAlignment:NSTextAlignmentLeft];
//            if(bulletin.count != 0)
//            {
//                [self stopTimer];
//                [self startTimer];
//            }

            return cell;
        }
    }
    else
    {
        // 通过唯一标识创建cell实例
        HomeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"HomeCell"];
        if(cell)
        {
            cell.smallPicLabel1.text = nil;
            cell.smallPicLabel1.backgroundColor = [UIColor clearColor];
            cell.smallPicLabel2.text = nil;
            cell.smallPicLabel2.backgroundColor = [UIColor clearColor];
            
            cell.firstLabel.text = nil;
            cell.secondLabel.text = nil;
            cell.thirdLabel.text = nil;
            cell.fourthLabel.text = nil;
            
            //            cell.firstLabel.layer.borderColor = (__bridge CGColorRef)([UIColor clearColor]);
            //            cell.secondLabel.layer.borderColor = (__bridge CGColorRef)([UIColor clearColor]);
            //            cell.thirdLabel.layer.borderColor = (__bridge CGColorRef)([UIColor clearColor]);
            //            cell.fourthLabel.layer.borderColor = (__bridge CGColorRef)([UIColor clearColor]);
            
            
            
            cell.d.image = nil;
            cell.communityName.text = nil;
            cell.commissionPriceLabel.text = nil;
            cell.signedCounts.text = nil;
        }
        
        if (info.count != 0)
        {
            cell.info = info[indexPath.row];
            // \NSLog(@"%@",info);
        }
        return cell;
    }
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        
        if (indexPath.row == 1)
        {
            ModelWebViewController * web = [[ModelWebViewController alloc]initWithUrlString:[[bulletin objectAtIndex:0] objectForKey:@"logAnnounceurl"] NavigationTitle:@"公告"];
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
        
        HomeTableViewCell * cell =  (HomeTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        Property.titlestr = cell.communityName.text;
        Property.ID = cell.ID;
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        [self.navigationController pushViewController:Property animated:YES];
    }
}

#pragma mark --下拉刷新上拉加载
//刷新tableView
-(void)refreshingTableView
{
    //下拉刷新
    __block  HomeTableViewController * h = self;
    [_tableView addHeaderWithCallback:^{
        [_tableView headerEndRefreshing];
        [h refreshingHeaderTableView];
    }];
    
    //上拉加载
    [_tableView addFooterWithCallback:^{
        //        [_tableView footerEndRefreshing];
        [h refreshingFooterTableView];
        
    }];
}
//下拉刷新
-(void)refreshingHeaderTableView
{
    [self loadScroll];
    
    [self sendRequestWithCachorNot:NO];
}
//上拉加载
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
    
    [loadPerpoty requestGetPropertyInfosWithParam:param];
    [loadPerpoty getInterfaceRequestObject:^(id data) {
        if ([data objectForKey:@"success"])
        {
            
            [info addObjectsFromArray:[data objectForKey:@"datas"]];
            
            if (![[data objectForKey:@"datas"]count])
            {
                [_tableView footerEndRefreshing];
                [self.view makeToast:@"没有更多数据了"];
            }
            [_tableView reloadData];
            [_tableView footerEndRefreshing];
            
        }else{
            pageIndex--;
            [_tableView footerEndRefreshing];
            
        }
    } Fail:^(NSError *error) {
//        NSLog(@"上拉加载信息出错啦");
        pageIndex--;
        [_tableView footerEndRefreshing];
        
    }];
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


#pragma mark - 图片轮播 代理
-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    if ([[headScrollArr[index]objectForKey:@"type"] intValue] == 2)
    {
        //        UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        //        PropertyDetailViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"PropertyDetailViewController"];
        
        PropertyDetailViewController *vc = [[PropertyDetailViewController alloc] init];
        vc.ID = [headScrollArr[index]objectForKey:@"contents"];
        vc.titlestr = [headScrollArr[index]objectForKey:@"title"];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if ([[headScrollArr[index]objectForKey:@"type"] intValue] == 1 )
    {
        if ([headScrollArr[index]objectForKey:@"contents"] != [NSNull null] && [[headScrollArr[index]objectForKey:@"type"] integerValue] > 0 && [headScrollArr[index]objectForKey:@"contents"]  != nil && [headScrollArr[index]objectForKey:@"contents"])
        {
            ModelWebViewController * web = [[ModelWebViewController alloc]initWithUrlString:[headScrollArr[index]objectForKey:@"contents"] NavigationTitle:[headScrollArr[index]objectForKey:@"title"]];
            web.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:web animated:YES];
        }
        
    }
    if ([[headScrollArr[index]objectForKey:@"type"] intValue] == 3 )
    {
        if ([headScrollArr[index]objectForKey:@"contents"] != [NSNull null]  && [[headScrollArr[index]objectForKey:@"type"] integerValue] > 0 && [headScrollArr[index]objectForKey:@"contents"]  != nil && [headScrollArr[index]objectForKey:@"contents"])
        {
            ModelWebViewController * web = [[ModelWebViewController alloc]initWithUrlString:[headScrollArr[index]objectForKey:@"contents"] NavigationTitle:[headScrollArr[index]objectForKey:@"title"]];
            web.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:web animated:YES];
        }
    }
}


#pragma mark - 第一行按钮点击事件
-(void)click_btn:(UIButton *)button
{
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SearchPropertyViewController * search = [storyboard instantiateViewControllerWithIdentifier:@"SearchPropertyViewController"];
    search.locationStr = locationStrCity;
    switch (button.tag) {
        case 10:
            search.choosenDic = EstateStateArr[0];
            break;
        case 11:
            search.choosenDic = EstateStateArr[3];
            break;
        case 12:
            search.choosenDic = EstateStateArr[2];
            break;
        case 13:
            search.choosenDic = EstateStateArr[4];
            break;
        case 14:
            search.choosenDic = EstateStateArr[1];
            break;
        default:
            break;
    }
    [self.navigationController pushViewController:search animated:YES];
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

////跳转到 添加 推荐客户
////首先判断是否是登录状态，
//- (void)add
//{
//    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
//    if(![defaults boolForKey:@"SalesHelper_publicNotice"])
//    {
//        if ([defaults valueForKey:@"Login_User_token"] != nil)
//        {
//            UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//            RecommendViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"RecommendViewController"];
//           // NSMutableArray * arr = [NSMutableArray arrayWithObject:self.dict];
//            //vc.info = arr;
//            [self.navigationController pushViewController:vc animated:YES];        }
//        else
//        {
//            UINavigationController *mainNaVC = [[UINavigationController alloc] initWithRootViewController:[[LoginViewController alloc]init]];
//            [self presentViewController:mainNaVC animated:YES completion:nil];
//            //            LoginAndRegisterViewController *vc = [[LoginAndRegisterViewController alloc] init];
//            //            [self presentViewController:vc animated:YES completion:nil];
//        }
//    }
//}

//使列表的分割线顶格开始
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    
    if (IOS_VERSION >= 8.0)
    {
        if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)])
        {
            [cell setPreservesSuperviewLayoutMargins:NO];
        }
        if ([cell respondsToSelector:@selector(setLayoutMargins:)])
        {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
    }
}


//#pragma mark - 滚动公告视图
//- (UIView *)getLabelForIndex:(NSUInteger)index
//{
//    UIView *container = [[UIView alloc] initWithFrame:contentView.bounds];
//    [container setBackgroundColor:[UIColor clearColor]];
//
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectInset(container.bounds, 0, 0)];
//    label.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//    [label setFont:Default_Font_12];
//    [label setTextAlignment:NSTextAlignmentLeft];
//    [label setTextColor:[ProjectUtil colorWithHexString:@"666666"]];
//    label.text = [bulletin[index]objectForKey:@"logTitle"];
//
//    [container addSubview:label];
//    container.tag = index + 622;
//
//    return container;
//}


//公告滚动取消
- (void)valueChange
{
    indexStep ++;
    if (indexStep == bulletin.count) {
        indexStep = 0;
    }
    labelll.text = bulletin[indexStep][@"logTitle"];

//    UIView *previousView = [[contentView subviews] objectAtIndex:0];

//    UIView *nextView = [self getLabelForIndex:indexStep];
//    // handle wrap around
//    [MPFoldTransition transitionFromView:previousView
//                                  toView:nextView
//                                duration:[MPFoldTransition defaultDuration]
//                                   style:MPFoldStyleCubic
//                        transitionAction:MPTransitionActionAddRemove
//                              completion:^(BOOL finished) {
//                              }
//     ];
    
    
}
- (void)startTimer
{
    timer =  [NSTimer scheduledTimerWithTimeInterval:6.0
                                     target:self
                                   selector:@selector(valueChange)  userInfo:nil
                                    repeats:YES];
}
- (void)stopTimer
{
    if (timer != nil){
        // 定时器调用invalidate后，就会自动执行release方法。不需要在显示的调用release方法
        [timer invalidate];
    }
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self stopTimer];// 停止定时器
    
}

@end
