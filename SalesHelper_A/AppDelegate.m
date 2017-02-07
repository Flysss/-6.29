//
//  AppDelegate.m
//  SalesHelper_A
//
//  Created by summer on 14/12/18.
//  Copyright (c) 2014年 X. All rights reserved.
//

#import "AppDelegate.h"

#import "APService.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>

#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WeiboSDK.h"
#import <AudioToolbox/AudioToolbox.h>
#import <CoreLocation/CoreLocation.h>
#import "FMDatabase.h"

//#import "LoginViewController.h"
#import "UserGuideViewController.h"
#import "AdvertViewController.h"
#import "WithdrawRecordViewController.h"
#import "PublicNoticeWebViewController.h"
#import "TimeLineViewController.h"
#import "MobClick.h"
#import "IQKeyboardManager.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <RongIMKit/RongIMKit.h>
#import "AFHTTPRequestOperationManager.h"

@interface AppDelegate () <CLLocationManagerDelegate,UIAlertViewDelegate,RCIMUserInfoDataSource>
{
    NSInteger _jumpSignIndex;
    NSString *_recordId;
    NSString *_adUrlString;
    NSString *_currentLocationCity;
    //执行过一次弹出窗界面
    BOOL _isAlertCurrentLocation;
    NSString * _phone;
    NSString * _propertyName;
    NSString * _name;
    BMKMapManager* _mapManager;

}

@property(nonatomic,retain) CLLocationManager *locationManager;

@property (nonatomic, strong) NSURL *versionUrl;
@property (nonatomic, strong) NSString *token;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    
    //百度地图注册
    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_mapManager start:@"zq99jkfVrtx0A00ViUQ02kjG"  generalDelegate:nil];
//    BOOL ret = [_mapManager start:@"WIGfO7EzI0twXzMbvt7rWcQh"  generalDelegate:nil];
    
    //清除7天之前的缓存图片
    [[SDImageCache sharedImageCache] cleanDisk];
    
    if (!ret) {
        NSLog(@"manager start failed!");
    }
//    NSLog(@"%@",[APService registrationID]);
    
//    [ShareSDK registerApp:@"44249fc71a22"];     //参数为ShareSDK官网中添加应用后得到的AppKey
    [ShareSDK registerApp:@"44249fc71a22" activePlatforms:@[ @(SSDKPlatformTypeSinaWeibo),
                           @(SSDKPlatformSubTypeQZone),
                    @(SSDKPlatformSubTypeWechatSession),
                    @(SSDKPlatformSubTypeWechatTimeline),@(SSDKPlatformSubTypeQQFriend)] onImport:^(SSDKPlatformType platformType)
    {
        switch (platformType)
        {
            case SSDKPlatformTypeWechat:
                [ShareSDKConnector connectWeChat:[WXApi class]];
                break;
            case SSDKPlatformTypeQQ:
                [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                break;
            case SSDKPlatformTypeSinaWeibo:
                [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                break;
            default:
                break;
        }
    } onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
        switch (platformType)
        {
            case SSDKPlatformTypeSinaWeibo:
                //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                [appInfo SSDKSetupSinaWeiboByAppKey:@"2777365555"
                                          appSecret:@"dc88108a0939ffa11d78460c60c87bd8"
                                        redirectUri:@"http://www.sharesdk.cn"
                                           authType:SSDKAuthTypeBoth];
                break;
            case SSDKPlatformTypeWechat:
                [appInfo SSDKSetupWeChatByAppId:@"wxd19a27ea4bd83406"
                                      appSecret:@"98cd1f6cbcd63f5a09f81ee709487750"];
                
                break;
            case SSDKPlatformTypeQQ:
                [appInfo SSDKSetupQQByAppId:@"1103554165"
                                     appKey:@"Ce3stlbQ1gho60Jo"
                                   authType:SSDKAuthTypeBoth];
                break;
            default:
                break;
        }
    }];
    
    
//    [self initializeShareSDK];
    //融云注册
//    [[RCIM sharedRCIM] initWithAppKey:@"qf3d5gbj31w5h"];
    [[RCIM sharedRCIM] initWithAppKey:@"sfci50a7cn35i"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *longinuid =  [defaults objectForKey:@"id"];
    if (longinuid != nil)
    {
        [self requestToken:longinuid];
    }
    
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;

    
    [MobClick startWithAppkey:@"561b6b11e0f55af61d004b8f" reportPolicy:BATCH   channelId:@""];//友盟统计
    NSString * mobversion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:mobversion];
    
    //地图操作
    _isAlertCurrentLocation = YES;
    _currentLocationCity = @"";
    [self startLocate];
//    NSDictionary* remoteNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
//    NSLog(@"%@", remoteNotification);
    
    
    //极光推送
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                       UIUserNotificationTypeSound |
                                                       UIUserNotificationTypeAlert)
                                           categories:nil];
    } else {
        //categories 必须为nil
        [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                       UIRemoteNotificationTypeSound |
                                                       UIRemoteNotificationTypeAlert)
                                           categories:nil];
    }
#else
    //categories 必须为nil
    [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                   UIRemoteNotificationTypeSound |
                                                   UIRemoteNotificationTypeAlert)
                                       categories:nil];
#endif
    //Required
    [APService setupWithOption:launchOptions];
    
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    
    [defaultCenter addObserver:self selector:@selector(requestGetSetRegistID) name:kJPFNetworkDidRegisterNotification object:nil];

    
    //创建本地数据库
//    [self createLocalDBDatabase];

    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    
    
//    //判断是不是第一次启动应用
//    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"isNotFirstStart"])
//    {
//        //如果是第一次启动的话,使用UserGuideViewController (用户引导页面) 作为根视图
//        UserGuideViewController *userGuideViewController = [[UserGuideViewController alloc] init];
//        self.window.rootViewController = userGuideViewController;
//    }
//    else
//    {
//        AdvertViewController *mainNaVC = [[AdvertViewController alloc] init];
//        self.window.rootViewController = mainNaVC;
//    }
//    
//  
    
    //第二种判断一个APP应用是否是第一次启动
    NSString* key=(NSString* )kCFBundleVersionKey;
    //从info。plist中取出版本号
    NSString* version=[NSBundle mainBundle].infoDictionary[key];
    //从沙河中取出上次存储的版本号
    NSString* saveVersion=[[NSUserDefaults standardUserDefaults]objectForKey:key];
    if ([version isEqualToString:saveVersion])
    {  //再次使用这个版本  增加广告页面进入主界面
        application.statusBarHidden=NO;
        AdvertViewController * mainNaVC = [[AdvertViewController alloc] init];
        self.window.rootViewController = mainNaVC;
        
    }
    else
    {
        //第一次使用新版本 增加前面的页面启动图片
        [[NSUserDefaults standardUserDefaults] setObject:version forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:YES] forKey:@"ImageSwitch"];

    UserGuideViewController *userGuideViewController = [[UserGuideViewController alloc] init];
     self.window.rootViewController = userGuideViewController;
    
    }
    
    
    [self.window makeKeyAndVisible];
    
    
//    读取后台数据，判定是否显示“邀请赚钱”“分享赚钱”
    RequestInterface *requestOp = [[RequestInterface alloc] init];
    [requestOp ShowZhuanQian];
    [requestOp getInterfaceRequestObject:^(id data) {
        if([[data objectForKey:@"issigned"] boolValue])
        {
            ShowZhuanQian = YES;
        }
        else
        {
            ShowZhuanQian = NO;
        }
        
    } Fail:^(NSError *error) { }];
    
    
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [application setApplicationIconBadgeNumber:0];
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [self requestNewVersion];//----------版本提示
    //开始定位
    [self.locationManager startUpdatingLocation];
    
    //检测网络
    Reachability *netWorkReachable = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    if ([netWorkReachable currentReachabilityStatus] == NotReachable) {
        [self.window makeToast:@"网络无法连接！请检查您的网络"];
    }

    [self requestGetSetRegistID];
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - ShareSDK

//- (void)initializeShareSDK
//{
//    //连接短信分享
//    [ShareSDK connectSMS];
//    
//    /**
//     连接新浪微博开放平台应用以使用相关功能，此应用需要引用SinaWeiboConnection.framework
//     http://open.weibo.com上注册新浪微博开放平台应用，并将相关信息填写到以下字段
//     **/
//    [ShareSDK connectSinaWeiboWithAppKey:@"2777365555"
//                               appSecret:@"dc88108a0939ffa11d78460c60c87bd8"
//                             redirectUri:@"http://www.sharesdk.cn"];
//    
//    /**
//     连接QQ空间应用以使用相关功能，此应用需要引用QZoneConnection.framework
//     http://connect.qq.com/intro/login/上申请加入QQ登录，并将相关信息填写到以下字段
//     
//     如果需要实现SSO，需要导入TencentOpenAPI.framework,并引入QQApiInterface.h和TencentOAuth.h，将QQApiInterface和TencentOAuth的类型传入接口
//     **/
//    [ShareSDK connectQZoneWithAppKey:@"1103554165"
//                           appSecret:@"Ce3stlbQ1gho60Jo"
//                   qqApiInterfaceCls:[QQApiInterface class]
//                     tencentOAuthCls:[TencentOAuth class]];
//    
//    /**
//     连接微信应用以使用相关功能，此应用需要引用WeChatConnection.framework和微信官方SDK
//     http://open.weixin.qq.com上注册应用，并将相关信息填写以下字段
//     **/
////        [ShareSDK connectWeChatWithAppId:@"wx471420bff23e1317" wechatCls:[WXApi class]];
//    [ShareSDK connectWeChatWithAppId:@"wxd19a27ea4bd83406"
//                           appSecret:@"98cd1f6cbcd63f5a09f81ee709487750"
//                           wechatCls:[WXApi class]];
//}
//
//- (BOOL)application:(UIApplication *)application
//      handleOpenURL:(NSURL *)url
//{
//    return [ShareSDK handleOpenURL:url
//                        wxDelegate:self];
//}
//
//- (BOOL)application:(UIApplication *)application
//            openURL:(NSURL *)url
//  sourceApplication:(NSString *)sourceApplication
//         annotation:(id)annotation
//{
//    return [ShareSDK handleOpenURL:url
//                 sourceApplication:sourceApplication
//                        annotation:annotation
//                        wxDelegate:self];
//}

#pragma mark 极光推送

- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification
{
    [APService showLocalNotificationAtFront:notification identifierKey:nil];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
//    NSLog(@"this is iOS7 Remote Notification");
    
        NSLog(@"%@",userInfo);
    
        NSString *message = nil;
        _jumpSignIndex = 0;
    
        if ([userInfo[@"type"] integerValue] == 11)
        {
           
            if (userInfo[@"url"]) {
                _adUrlString = userInfo[@"url"];
            }
            _phone  = [NSString stringWithFormat:@"%@", userInfo[@"phone"]];
            _recordId = userInfo[@"recId"];
            _name = userInfo[@"name"];
            _propertyName = userInfo[@"propertyName"];
            _jumpSignIndex = 1;
            message = @"您有一条已确认推荐信息";
        }else if ([[userInfo objectForKey:@"type"] isEqualToString:@"12"])
        {
            _recordId = userInfo[@"recId"];
            if (userInfo[@"url"]) {
                _adUrlString = userInfo[@"url"];
            }
            _phone  = [NSString stringWithFormat:@"%@",userInfo[@"phone"]];
            _name = userInfo[@"name"];
            _propertyName = userInfo[@"propertyName"];
            _jumpSignIndex = 1;
            //            message = @"您有一条无效推荐信息";
            message = [NSString stringWithFormat:@"您推荐的客户%@被界定为无效", userInfo[@"name"]];
        }
        else if ([[userInfo objectForKey:@"type"]isEqualToString:@"13"])
        {
            //            _jumpSignIndex = 1;
            //            message = @"您有一条已签约推荐信息";
            _recordId = userInfo[@"recId"];
            if (userInfo[@"url"]) {
                _adUrlString = userInfo[@"url"];
            }
            _phone  = [NSString stringWithFormat:@"%@",userInfo[@"phone"]];
            _name = userInfo[@"name"];
            _propertyName = userInfo[@"propertyName"];
            _jumpSignIndex = 1;
            message = [NSString stringWithFormat:@"您推荐的客户%@已签约", userInfo[@"name"]];
        }
        else if ([[userInfo objectForKey:@"type"]isEqualToString:@"9"])
        {
            //            _jumpSignIndex = 1;
            //            message = @"您有一条新的已认筹消息";
            _recordId = userInfo[@"recId"];
            if (userInfo[@"url"]) {
                _adUrlString = userInfo[@"url"];
            }
            _phone  = [NSString stringWithFormat:@"%@",userInfo[@"phone"]];
            _name = userInfo[@"name"];
            _propertyName = userInfo[@"propertyName"];
            _jumpSignIndex = 1;
            message = [NSString stringWithFormat:@"您推荐的客户%@已认筹", userInfo[@"name"]];
        }
        else if ([[userInfo objectForKey:@"type"]isEqualToString:@"19"])
        {
            //            _jumpSignIndex = 1;
            //            message = @"您有一条新的已到访消息";
            _recordId = userInfo[@"recId"];
            if (userInfo[@"url"]) {
                _adUrlString = userInfo[@"url"];
            }
            _phone  = [NSString stringWithFormat:@"%@",userInfo[@"phone"]];
            _name = userInfo[@"name"];
            _propertyName = userInfo[@"propertyName"];
            _jumpSignIndex = 1;
            message = [NSString stringWithFormat:@"您推荐的客户%@已到访", userInfo[@"name"]];
        }
        else if ([[userInfo objectForKey:@"type"]isEqualToString:@"20"])
        {
            //            _jumpSignIndex = 1;
            //            message = @"您有一条新的已认购消息";
            _recordId = userInfo[@"recId"];
            if (userInfo[@"url"]) {
                _adUrlString = userInfo[@"url"];
            }
            _phone  = [NSString stringWithFormat:@"%@",userInfo[@"phone"]];
            _name = userInfo[@"name"];
            _propertyName = userInfo[@"propertyName"];
            _jumpSignIndex = 1;
            message = [NSString stringWithFormat:@"您推荐的客户%@已认购", userInfo[@"name"]];
        }
        else if ([[userInfo objectForKey:@"type"]isEqualToString:@"22"])
        {
            //            _jumpSignIndex = 1;
            //            message = @"您有一条新的无意向消息";
            _recordId = userInfo[@"recId"];
            if (userInfo[@"url"]) {
                _adUrlString = userInfo[@"url"];
            }
            _phone  = [NSString stringWithFormat:@"%@",userInfo[@"phone"]];
            _name = userInfo[@"name"];
            _propertyName = userInfo[@"propertyName"];
            _jumpSignIndex = 1;
            message = [NSString stringWithFormat:@"您推荐的客户%@无意向购买", userInfo[@"name"]];
            
        }
        else if ([[userInfo objectForKey:@"type"]isEqualToString:@"21"]) {
//            _jumpSignIndex = 1;
//            message = @"您有一条新的有意向消息";
            _recordId = userInfo[@"recId"];
            if (userInfo[@"url"]) {
                _adUrlString = userInfo[@"url"];
            }
            _phone  = [NSString stringWithFormat:@"%@",userInfo[@"phone"]];
            _name = userInfo[@"name"];
            _propertyName = userInfo[@"propertyName"];
            _jumpSignIndex = 1;
            message = [NSString stringWithFormat:@"您推荐的客户%@有意向购买", userInfo[@"name"]];
        }
        else if ([[userInfo objectForKey:@"type"]isEqualToString:@"14"]) {
            _jumpSignIndex = 2;
            message = @"您有一条提现成功信息";
        }else if ([[userInfo objectForKey:@"type"]isEqualToString:@"15"]) {
            _jumpSignIndex = 3;
            message = @"您有一条活动信息";
        }
        else if ([[userInfo objectForKey:@"type"]isEqualToString:@"10001"]) {
            _jumpSignIndex = 3;
            message = @"您有一条新的公告消息";
        }
        else
        {
//            message = @"您有一条新的公告消息";
        }
    
    
        if (message != nil)
        {
            if(application.applicationState == UIApplicationStateActive)
            {
                AudioServicesPlaySystemSound(1007);
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"销邦" message:message delegate:self cancelButtonTitle:@"现在查看" otherButtonTitles:@"以后再说", nil];
                alertView.tag = 100;
                [alertView show];
            }
            else
            {
                [self jumpViewControllWithJumpIndex:_jumpSignIndex];
            }
        }
    
    // Required
    [APService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNoData);
    
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    //Required
    [APService registerDeviceToken:deviceToken];
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    //Required
    [APService handleRemoteNotification:userInfo];
}



#pragma mark - 获得当前位置
- (void)startLocate
{
    // 判断定位操作是否被允许
    if([CLLocationManager locationServicesEnabled])
    {
        self.locationManager = [[CLLocationManager alloc]init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.distanceFilter = 10;
        if (IOS_VERSION >= 8.0)
        {
            [self.locationManager requestWhenInUseAuthorization];//添加这句[_locationManagerrequestAlwaysAuthorization];
        }
        
        [ProjectUtil showLog:@"经度 纬度 高度"];
    }
    else
    {
        //提示用户无法进行定位操作
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:
                                  @"提示" message:@"定位不成功 ,请确认已开启定位" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        //存数据--->基本数据类型
        [defaults setObject:@"合肥" forKey:@"Login_User_currentLocationCity"];
        [defaults synchronize];
    }
}

//停止定位操作
- (void)stopLocate:(CLLocationManager *)manager
{
    //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
    [manager stopUpdatingLocation];
}

//- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
//{
//    
//    //此处locations存储了持续更新的位置坐标值，取最后一个值为最新位置，如果不想让其持续更新位置，则在此方法中获取到一个值之后让locationManager stopUpdatingLocation
//    CLLocation *currentLocation = [locations lastObject];
////    [ProjectUtil showLog:@"经度=%f 纬度=%f 高度=%f", currentLocation.coordinate.latitude, currentLocation.coordinate.longitude, currentLocation.altitude];
//    
//    // 获取当前所在的城市名
//    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
//    //根据经纬度反向地理编译出地址信息
//    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *array, NSError *error)
//     {
//         NSString * currentLocationCity;
//         if (array.count > 0)
//         {
//             CLPlacemark *placemark = [array objectAtIndex:0];
////             //将获得的所有信息显示到label上
////             [ProjectUtil showLog:@"name %@",placemark.name];
////             [ProjectUtil showLog:@"country ：%@",placemark.country];
// 
//             //获取国家
//             NSString *countryName = @"";
//             //获取城市
//             NSString *cityName = @"";
//
//             
//             //获取国家
//             countryName = placemark.country;
//             //获取城市
//             cityName = placemark.locality;
//             
//             HWLog(@"--%@   %@",countryName,cityName);
//            
//             if (!cityName) {
//                 //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
//                 cityName = placemark.administrativeArea;
//             }
//             if ([countryName isEqualToString:@"中国"])
//             {
//                 if ([[cityName substringFromIndex:(cityName.length-1)] isEqualToString:@"市"]) {
//                     currentLocationCity = [cityName substringToIndex:(cityName.length-1)];
//                     
//                     HWLog(@"--------%@",currentLocationCity);
//                 }else{
//                     currentLocationCity = cityName;
//                 }
//             }else {
//                 //不是中国 默认合肥城市
//                 currentLocationCity = @"合肥";
//             }
//             
//             _currentLocationCity = currentLocationCity;
//             
//             [self stopLocate:manager];
//         } else {
//             if (currentLocationCity.length ==0) {
//                 currentLocationCity = @"合肥";
//             }
//             if (error == nil && [array count] == 0)
//             {
////                 NSLog(@"No results were returned.");
//             }
//             else if (error != nil)
//             {
////                 NSLog(@"An error occurred = %@", error);
//             }
//         }
//         
//         
//         [ProjectUtil showLog:@"_currentLocationCity %@",_currentLocationCity];
//         if (_currentLocationCity.length > 0) {
//             NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//             //存数据--->基本数据类型
//             [defaults setObject:_currentLocationCity forKey:@"Login_User_currentLocationCity"];
//             [defaults synchronize];
//         }
//         else
//         {
//             NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//             
//             if ([defaults valueForKey:@"Login_User_currentLocationCity"] == nil) {
//                 //存数据--->基本数据类型
//                 [defaults setObject:@"合肥" forKey:@"Login_User_currentLocationCity"];
//                 [defaults setObject:@"合肥" forKey:@"select_Current_Location"];
//                 [defaults synchronize];
//             }
//         }
//         
//     }];
//}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    
    //此处locations存储了持续更新的位置坐标值，取最后一个值为最新位置，如果不想让其持续更新位置，则在此方法中获取到一个值之后让locationManager stopUpdatingLocation
    CLLocation *currentLocation = [locations lastObject];
    //    [ProjectUtil showLog:@"经度=%f 纬度=%f 高度=%f", currentLocation.coordinate.latitude, currentLocation.coordinate.longitude, currentLocation.altitude];
    // 获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *array, NSError *error)
     {
         NSString * currentLocationCity;
         
         if (array.count > 0)
         {
             CLPlacemark *placemark = [array objectAtIndex:0];
             
             if (placemark == nil)
             {
                 currentLocationCity = @"合肥";
             }
             else
             {
                 //             //将获得的所有信息显示到label上
                 //             [ProjectUtil showLog:@"name %@",placemark.name];
                 //             [ProjectUtil showLog:@"country ：%@",placemark.country];
                 //获取国家
                 NSString *countryName = @"";
                 //获取城市
                 NSString *cityName = @"";
                 //获取国家
                 countryName = placemark.country;
                 //获取城市
                 cityName = placemark.locality;
                 
                 HWLog(@"--%@   %@",countryName,cityName);
                 
                 if (!cityName) {
                     //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                     cityName = placemark.administrativeArea;
                 }
                 
                 if ([countryName isEqualToString:@"中国"])
                 {
                     if ([[cityName substringFromIndex:(cityName.length-1)] isEqualToString:@"市"]) {
                         currentLocationCity = [cityName substringToIndex:(cityName.length-1)];
                         
                         HWLog(@"--------%@",currentLocationCity);
                     }else{
                         currentLocationCity = cityName;
                         
                     }
                 }else {
                     //不是中国 默认合肥城市
                     currentLocationCity = @"合肥";
                 }
                 
             }
             
         }
         else
         {
             if (currentLocationCity.length ==0)
             {
                 currentLocationCity = @"合肥";
             }
         }

         _currentLocationCity = currentLocationCity;
         
         [self stopLocate:manager];
         
         [ProjectUtil showLog:@"_currentLocationCity %@",_currentLocationCity];
         
         if (_currentLocationCity.length > 0)
         {
             NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
             //存数据--->基本数据类型
             [defaults setObject:_currentLocationCity forKey:@"Login_User_currentLocationCity"];
             [defaults synchronize];
         }
     }];
    
}


- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //存数据--->基本数据类型
    [defaults setObject:@"合肥" forKey:@"Login_User_currentLocationCity"];
    [defaults synchronize];
    if (error.code == kCLErrorDenied)
    {
        [self.window makeToast:@"定位出错,默认设为合肥"];
        // 提示用户出错原因，可按住Option键点击 KCLErrorDenied的查看更多出错信息，可打印error.code值查找原因所在
    }
    
}

#pragma mark - Version 版本更新

- (void)requestNewVersion
{
    RequestInterface *versionOp = [[RequestInterface alloc] init];
    
    [versionOp requestUpGrateAppInterface];
    
    [versionOp getInterfaceRequestObject:^(id data) {
        [ProjectUtil showLog:@"data = %@",data];
        NSDictionary *dict = data[0];
        NSString *version = dict[@"version_name"];
        NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
        NSString *curVersion = [info valueForKey:@"CFBundleShortVersionString"];
        NSComparisonResult r = [curVersion compare:version options:NSNumericSearch];
        if (r == NSOrderedAscending)
        {
            if (![dict[@"version_name"] isEqualToString:curVersion])
            {
                NSMutableString *urlStr = dict[@"download_url"];
                NSURL *url = [NSURL URLWithString:urlStr];
                
                self.versionUrl = url;
                //                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"亲！销邦又有新版本了" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"亲！销邦又有新版本了" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                alert.tag = 800;
                [alert show];
            }
        }else {
        }
    } Fail:^(NSError *error) {
    }];
}
#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 800 ) {
        if (buttonIndex == 0) {
            [ProjectUtil showLog:@"更新取消"];
        }
        else if (buttonIndex == 1)
        {
            [ProjectUtil showLog:@"确定更新下载 = %@",self.versionUrl];
            [[UIApplication sharedApplication] openURL:self.versionUrl];
        }
    }
    if (alertView.tag==100)
    {
        if (buttonIndex==0)
        {
            [self jumpViewControllWithJumpIndex:_jumpSignIndex];
        }
        else if (buttonIndex==1)
        {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            //存数据--->基本数据类型
            [defaults setBool:NO forKey:@"SalesHelper_publicNotice"];//存在公告内容
            [defaults synchronize];
        }
        else
        {
            
        }
    }
    if (alertView.tag == 880)
    {
        
        if (buttonIndex == 1) {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            //存数据--->基本数据类型
            [defaults setObject:_currentLocationCity forKey:@"Login_User_currentLocationCity"];
            [defaults setObject:_currentLocationCity forKey:@"select_Current_Location"];
            [defaults synchronize];
            
            NSDictionary *postDict = @{@"cityName":_currentLocationCity,
                                       @"type":@"NeedReload"
                                       };
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RealestateViewArea_notice" object:postDict];
        }
        
    }
    
}

-(void)jumpViewControllWithJumpIndex:(NSInteger)jumpIndex
{
    if (_jumpSignIndex==1)
    {

        TimeLineViewController* time = [[TimeLineViewController alloc] init];
        time.hidesBottomBarWhenPushed = YES;
        
        NSDictionary * dict = @{
                                @"id":_recordId,
                                @"propertyName":_propertyName,
                                @"name":_name,
                                @"phone":_phone,
                                };
        time.propertyInfo = dict;
        time.timeLineID = _recordId;
        
        UITabBarController * tab = (UITabBarController *)self.window.rootViewController;
        [tab  setSelectedIndex:1];
        UINavigationController * navi = tab.selectedViewController;
//        [navi setViewControllers:@[self, recommend, time] animated:YES];
        [navi pushViewController:time animated:NO];
        
    }
    else if (_jumpSignIndex==2)
    {
        WithdrawRecordViewController *withdrawRecordVC = [[WithdrawRecordViewController alloc]init];
        withdrawRecordVC.title = @"提现记录";
        [withdrawRecordVC creatBackButtonWithPushType:Push With:@"返回" Action:nil];
        
        UINavigationController *naVC = [[UINavigationController alloc]initWithRootViewController:withdrawRecordVC];
        [self.window.rootViewController presentViewController:naVC animated:YES completion:nil];
    }
    else if(_jumpSignIndex ==3)
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        //存数据--->基本数据类型
        [defaults setBool:YES forKey:@"SalesHelper_publicNotice"];//存在公告内容
        [defaults synchronize];
    
        NSString *urlString = _adUrlString;
        PublicNoticeWebViewController *noticeDetailVC = [[PublicNoticeWebViewController alloc]initWithUrlString:urlString NavigationTitle:@"公告"];
    
        UINavigationController *noticeNaVC = [[UINavigationController alloc]initWithRootViewController:noticeDetailVC];
    
        [noticeDetailVC creatBackButtonWithPushType:Present With:@"返回" Action:@selector(presentViewControllerWithDefault)];
        [self.window.rootViewController presentViewController:noticeNaVC animated:YES completion:nil];
        
    }
    else
    {
        
    }
    
}
#pragma mark - 融云Token
- (void)requestToken:(NSString *)longinuid
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    self.token = [NSString stringWithFormat:@"%@",[defaults objectForKey:@"RCIMToken"]] ;
    
    if (self.token != nil)
    {
        [[RCIM sharedRCIM] connectWithToken:self.token success:^(NSString *userId)
         {

             [[RCIM sharedRCIM] setUserInfoDataSource:self];
             NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
         } error:^(RCConnectErrorCode status)
         {
             NSLog(@"登陆的错误码为:%ld", (long)status);
         } tokenIncorrect:^{
             NSLog(@"token错误");
             
             AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
             NSMutableDictionary *parame = [NSMutableDictionary dictionary];
             parame[@"loginuid"] = longinuid;
             NSString *url = [NSString stringWithFormat:@"%@/index.php/Apis/Forum/getTokenid/",BANGHUI_URL];
             [manager POST:url parameters:parame
                   success:^(AFHTTPRequestOperation *operation, id responseObject)
              {
                  
                  if ([responseObject[@"success"] boolValue] == YES)
                  {
                      self.token = responseObject[@"datas"];
                      
                      
                      [defaults setObject:self.token forKey:@"RCIMToken"];
                      [[RCIM sharedRCIM] connectWithToken:self.token success:^(NSString *userId)
                       {
                           
                           [[RCIM sharedRCIM] setUserInfoDataSource:self];
                           NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
                       } error:^(RCConnectErrorCode status)
                       {
                           NSLog(@"登陆的错误码为:%ld", (long)status);
                       } tokenIncorrect:^{
                           NSLog(@"token错误");
                       }];
                  }
                  
              } failure:^(AFHTTPRequestOperation *operation, NSError *error)
              {
                  
              }];
         }];
        
        
        

        
    }else
    {
#warning 下下个上线版本即可删除else（当前版本3.6.7）
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSMutableDictionary *parame = [NSMutableDictionary dictionary];
        parame[@"loginuid"] = longinuid;
        NSString *url = [NSString stringWithFormat:@"%@/index.php/Apis/Forum/getTokenid/",BANGHUI_URL];
        [manager POST:url parameters:parame
              success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             
             if ([responseObject[@"success"] boolValue] == YES)
             {
                 self.token = responseObject[@"datas"];
                 
                 
                 [defaults setObject:self.token forKey:@"RCIMToken"];
                 
                 [[RCIM sharedRCIM] connectWithToken:self.token success:^(NSString *userId)
                  {
                      
                      [[RCIM sharedRCIM] setUserInfoDataSource:self];
                      NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
                  } error:^(RCConnectErrorCode status)
                  {
                      NSLog(@"登陆的错误码为:%ld", (long)status);
                  } tokenIncorrect:^{
                      NSLog(@"token错误");
                  }];
             }
            
         } failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             
         }];
    }

}

- (void)getUserInfoWithUserId:(NSString *)userId
                   completion:(void (^)(RCUserInfo *userInfo))completion
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    RequestInterface *interface = [[RequestInterface alloc]init];
    NSDictionary *dic = @{
                          @"getuid":userId,
                          @"loginuid":[defaults objectForKey:@"id"]
                          };
    [interface requestBHPersonalCenterWithDic:dic];
    [interface getInterfaceRequestObject:^(id data)
     {
         
         
         if ([data[@"success"] boolValue] == YES)
         {
             
             NSDictionary *dict = data[@"datas"];
             
             RCUserInfo *userInfo = [[RCUserInfo alloc] init];
             
             userInfo.userId = userId;
             
             userInfo.name = dict[@"name"];
             
             userInfo.portraitUri = dict[@"iconPath"];
             
             return completion(userInfo);
             
   
             
         }
     } Fail:^(NSError *error)
     {
         
     }];
    
    
}




#pragma Mark -SQL Operations

////创建数据库表
//-(void)createLocalDBDatabase
//{
//    //获取Document 下路径
//    
//    NSString * dbPath = [ProjectUtil fileFMDatabasePath];
//    
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    
//    if (![fileManager fileExistsAtPath:dbPath]) {
//        //create table
//        
//        FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
//        [ProjectUtil showLog:@"dbPath = %@",dbPath];
//        if ([db open]) {
//            NSString * sql =@"CREATE  TABLE 'ZhipuRecordDB'('REQUESTNAME' VARCHAR(30)  PRIMARY KEY  NOT NULL  UNIQUE , 'INTERFACEINFO'  VARCHAR, 'INSERTTIME' VARCHAR(30))";
//            
//            BOOL res = [db executeUpdate:sql];
//            if (res) {
//                [ProjectUtil showLog:@"接口表格创建成功"];
//            }else{
//                [ProjectUtil showLog:@"接口表格创建失败"];
//            }
//            
//            
//            NSString * addressSql =@"CREATE  TABLE 'ZhipuAddressDB'('PERSON_ID' VARCHAR(20), 'PERSON_NAME'  VARCHAR(50), 'PERSON_PHONE' VARCHAR(20), 'PERSON_FLAG' VARCHAR(5))";
//            
//            BOOL addressRes = [db executeUpdate:addressSql];
//            if (addressRes) {
//                [ProjectUtil showLog:@"通讯录表格创建成功"];
//            }else{
//                [ProjectUtil showLog:@"通讯录表格创建失败"];
//            }
//
//            [db close];
//        }else{
//            [ProjectUtil showLog:@"表打开失败"];
//        }
//    }else{
//        [ProjectUtil showLog:@"表格已经存在"];
//    }
//}

#pragma mark - 推送registrationID
- (void)requestGetSetRegistID
{
    NSString *tokenStr = [[NSUserDefaults standardUserDefaults] valueForKey:@"Login_User_token"];
    
    if (tokenStr == nil)
    {
        return;
    }
    
    NSDictionary *dict = @{@"token":tokenStr,
                           @"RegistrationID":[APService registrationID],
                           @"user_version":@"A"
                           };
    
    RequestInterface *requestOp = [[RequestInterface alloc] init];
    [requestOp requestGetSetRegistIDWithParam:dict];
    
    [requestOp getInterfaceRequestObject:^(id data) {
        
    } Fail:^(NSError *error) {
        
    }];
}
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    [[SDWebImageManager sharedManager] cancelAll];
    [[SDImageCache sharedImageCache] clearDisk];
}

@end
