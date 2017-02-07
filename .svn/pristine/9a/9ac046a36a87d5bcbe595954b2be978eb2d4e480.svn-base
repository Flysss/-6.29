//
//  MapViewController.m
//  SalesHelper_A
//
//  Created by Brant on 16/1/4.
//  Copyright (c) 2016年 X. All rights reserved.
//

#import "MapViewController.h"
#import "UIColor+Extend.h"
#import "CoreLocationViewController.h"

#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>//引入云检索功能所有的头文件
#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入计算工具所有的头文件
#import <BaiduMapAPI_Radar/BMKRadarComponent.h>//引入周边雷达功能所有的头文件
#import "SCLAlertView.h"
#import "UIImage+Rotate.h"

#import "PropertyDetailViewController.h"


@interface MapViewController () <locationChooseDelegate, UISearchBarDelegate, BMKMapViewDelegate, BMKLocationServiceDelegate>
@property (nonatomic, strong) UIButton *cityButton;
@property (nonatomic, strong) BMKMapView *m_mapView;
@property (nonatomic, strong) BMKLocationService *m_locationSever;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) BMKGeoCodeSearch * geocodesearch;

//大头针显示信息
@property (nonatomic, strong) UILabel* nameLabel;
@property (nonatomic, strong) UIButton* nameControl;
@property (nonatomic, strong) NSMutableArray* nameArray;

@property (nonatomic, strong)NSMutableDictionary* searchDict;

//自定义导航栏
@property (nonatomic, strong) UIView * topView;
@property (nonatomic, strong) UIButton * backBtn;
@end

@implementation MapViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.m_mapView.delegate = self;
    self.m_locationSever.delegate = self;
    self.navigationController.navigationBarHidden = YES;
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.m_mapView.delegate = nil;
    self.m_locationSever.delegate = nil;
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.m_mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0,64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    self.view = self.m_mapView;
    
    self.m_locationSever = [[BMKLocationService alloc]init];
    [self.m_locationSever startUserLocationService];
    
    self.m_mapView.showsUserLocation = NO;//先关闭显示的定位图层
    self.m_mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
    self.m_mapView.showsUserLocation = YES;//显示定位图层
    self.m_mapView.zoomEnabled = YES; //设定地图View能否支持用户多点缩放(双指)
    self.m_mapView.zoomLevel = 13; //地图比例尺级别，
    self.m_mapView.isSelectedAnnotationViewFront = YES;
    [self creatNaviController];
    [self requestData];
}

#pragma mark --创建导航栏
- (void)creatNaviController
{
    
    self.topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    self.topView.backgroundColor = [UIColor hexChangeFloat:@"00aff0"];
    self.backBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.backBtn setImage:[UIImage imageNamed:@"bc-1"] forState:(UIControlStateNormal)];
    [self.backBtn setImage:[UIImage imageByApplyingAlpha:[UIImage imageNamed:@"bc-1"]] forState:(UIControlStateHighlighted)];
    [self.backBtn addTarget:self action:@selector(backToView) forControlEvents:(UIControlEventTouchUpInside)];
    self.backBtn.frame = CGRectMake(11, 20, 30, 44);
    [self.topView addSubview:self.backBtn];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(50,25, SCREEN_WIDTH-60, 32)];
    view.layer.cornerRadius = 16;
    view.layer.masksToBounds = YES;
    view.backgroundColor = [UIColor whiteColor];
    [self.topView addSubview:view];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(80, 5, 0.5, 22)];
    label.backgroundColor = [UIColor hexChangeFloat:KQianheiColor];
    [view addSubview:label];
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-60, 32)];
    self.searchBar.delegate = self;
    self.searchBar.searchBarStyle = UISearchBarStyleDefault;
    [self.searchBar setBackgroundImage:[ProjectUtil imageWithColor:RGBACOLOR(235, 236, 238, 1) size:CGSizeMake(0.1f, 0.1f)]];
    [self.searchBar setContentMode:UIViewContentModeLeft];
    self.searchBar.placeholder = @"请输入楼盘名称";
    self.searchBar.tintColor = [UIColor hexChangeFloat:KBlueColor];
    [view addSubview:self.searchBar];
     [self.view addSubview:self.topView];
}

//返回上一页面
- (void)backToView
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --选择城市
- (void)selectCity
{
    [self.searchBar resignFirstResponder];
    
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"CoreLocation Storyboard" bundle:nil];
    CoreLocationViewController * location =[storyboard instantiateViewControllerWithIdentifier:@"CoreLocationViewController"];
    location.delegate = self;
    location.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:location animated:YES];
    
}

#pragma mark --城市选择成功， 代理方法
- (void)loadChoosenLocation:(NSDictionary *)loctionDic
{
    // NSLog(@"%@", loctionDic);
    [self.cityButton setTitle:loctionDic[@"name"] forState:UIControlStateNormal];
    self.cityId = [loctionDic valueForKey:@"id"];
    //NSLog(@"cityid = %@",self.cityId);
    [self requestData];
    
}

#pragma mark --搜索栏点击搜索按钮
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    
   static BOOL isExist;
    
    NSString* nameStr =[NSString stringWithFormat:@"%@",searchBar.text];

    [self.dataArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        if ([self.dataArr[idx][@"name"] rangeOfString:nameStr].length !=0) {
          
            isExist = YES;
            if (_dataArr[idx][@"x"] &&
                _dataArr[idx][@"x"]!=nil &&
                _dataArr[idx][@"x"] !=[NSNull null]
                )
            {
                
                self.m_mapView.showsUserLocation = NO;
                CLLocationCoordinate2D location;
                location.latitude = [_dataArr[idx][@"y"] doubleValue];
                location.longitude = [_dataArr[idx][@"x"] doubleValue];
                _m_mapView.centerCoordinate = location;
                self.m_mapView.zoomLevel = 16;
                
            }
        }
    }];
    if (!isExist ) {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:@"您搜索的楼盘不存在" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
        [alert show];
        isExist = NO;
    }
    
}
#pragma mark --请求数据
- (void)requestData
{
    [self.view Loading_0314];
    _dataArr = [NSMutableArray array];
    _nameArray = [NSMutableArray array];
    _searchDict = [[NSMutableDictionary alloc]init];
    RequestInterface * loadData = [[RequestInterface alloc]init];
    [loadData requestPropertiesFromAnnotationSearch:self.cityId];
    
    [loadData getInterfaceRequestObject:^(id data) {
        [self.view Hidden];
        
        if (data[@"success"])
        {
            self.dataArr = data[@"datas"];
            //NSLog(@"****%@",data[@"datas"]);
//            for (int i=0; i<self.dataArr.count; i++) {
//                
//                [self.searchDict setObject:self.dataArr[i][@"name"] forKey:@"name"];
//                [self.searchDict setObject:_dataArr[i][@"x"] forKey:@"x"];
//                [self.searchDict setObject:_dataArr[i][@"y"] forKey:@"y"];
//                [self.nameArray addObject:self.searchDict];
//            }
            
            [self mapShowAllAnnotation];
        }
        else
        {
            [self.view makeToast:data[@"success"]];
        }
    } Fail:^(NSError *error) {
        [self.view Hidden];
        NSLog(@"首页信息出错啦");
    }];
}

-(void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    
    [self.m_mapView updateLocationData:userLocation];
    CGFloat latitude = userLocation.location.coordinate.latitude;
    CGFloat longitude = userLocation.location.coordinate.longitude;
    //将经纬度保存至本地
    NSString *str1 = [NSString stringWithFormat:@"%f", latitude];
    NSString *str2 = [NSString stringWithFormat:@"%f", longitude];
    NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
    [userInfo setValue:str1 forKey:@"latitude"];
    [userInfo setValue:str2 forKey:@"longitude"];
    [userInfo synchronize];
    
}
//构建所有楼盘大头针信息
-(void)mapShowAllAnnotation{
    
    CLLocationCoordinate2D location;
    
    if (_dataArr[0][@"y"] !=nil && _dataArr[0][@"y"] !=[NSNull null] && _dataArr[0][@"y"]) {
        location.latitude = [_dataArr[0][@"y"] doubleValue];
        location.longitude = [_dataArr[0][@"x"] doubleValue];

    
    
    _m_mapView.centerCoordinate = location;
    
    
    //清除之前的所有大头针
    NSArray* array = [NSArray arrayWithArray:_m_mapView.annotations];
    [_m_mapView removeAnnotations:array];
  
 
    
    for (int i=0; i<[_dataArr count]; i++) {
        
        self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 60, 25)];
        self.nameLabel.text = _dataArr[i][@"name"];
        self.nameLabel.textColor = [UIColor whiteColor];
        self.nameLabel.textAlignment = NSTextAlignmentCenter;
        self.nameLabel.font = [UIFont boldSystemFontOfSize:13];
        self.nameLabel.backgroundColor = [UIColor clearColor];
        CGSize newFrame = [self.nameLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:13],NSFontAttributeName, nil]];
        self.nameLabel.frame = CGRectMake(10, 0, newFrame.width, 25);
        
        self.nameControl = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.nameLabel.frame.size.width+20, self.nameLabel.frame.size.height+20)];
        [self.nameControl addTarget:self action:@selector(clickToPushDetail:) forControlEvents:UIControlEventTouchUpInside];
        self.nameControl.tag = 500+ [_dataArr[i][@"id"] floatValue];
        
        
        BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
        CLLocationCoordinate2D coordinate;
        CGFloat mapLatitude = [_dataArr[i][@"y"] floatValue];
        CGFloat mapLongitude =[_dataArr[i][@"x"] floatValue];
        coordinate.latitude = mapLatitude;
        coordinate.longitude = mapLongitude;
        annotation.coordinate = coordinate;
        annotation.title = @"";//_dataArr[i][@"name"];
        [_m_mapView addAnnotation:annotation];
     }
    
    }
}
#pragma mark 点击大头针进入楼盘详情页
-(void)clickToPushDetail:(UIControl*)controll{
    
    
    NSLog(@"%d",controll.tag-500);
    
    PropertyDetailViewController* propertyVC = [[PropertyDetailViewController alloc]init];
    propertyVC.ID = [NSString stringWithFormat:@"%d",controll.tag-500];
    
    [self.navigationController pushViewController:propertyVC animated:YES];
    
}


#pragma mark --设置大头针
- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
#if 1
    // 生成重用标示identifier
    NSString *AnnotationViewID = @"xidanMark";
    // 检查是否有重用的缓存
    BMKAnnotationView* annotationView = [view dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    
    // 缓存没有命中，自己构造一个，一般首次添加annotation代码会运行到此处
    if (annotationView == nil) {
        annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        //((BMKPinAnnotationView*)annotationView).pinColor = BMKPinAnnotationColorRed;
        // 设置重天上掉下的效果(annotation)
        ((BMKPinAnnotationView*)annotationView).animatesDrop = YES;
    }
    annotationView.centerOffset = CGPointMake(0,-(annotationView.frame.size.height * 0.5));
   
    // 设置是否可以拖拽
    annotationView.draggable = YES;
    
    UIView* popView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,self.nameLabel.frame.size.width+20,40)];
    UIImageView* image1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,10+self.nameLabel.frame.size.width/2, 32)];
    image1.image = [UIImage imageNamed:@"首页-地图-左"];
    UIImageView* image2 = [[UIImageView alloc]initWithFrame:CGRectMake(10+self.nameLabel.frame.size.width/2,0,self.nameLabel.frame.size.width/2+10, 32)];
    image2.image = [UIImage imageNamed:@"首页-地图-右"];
    UIImageView* pointImg = [[UIImageView alloc]initWithFrame:CGRectMake(7+self.nameLabel.frame.size.width/2, 32, 8, 8)];
    pointImg.image = [UIImage imageNamed:@"定位点-1"];
    [popView addSubview:pointImg];
    [popView addSubview:image1];
    [popView addSubview:image2];
    [popView addSubview:self.nameLabel];
    [popView addSubview:self.nameControl];
    annotationView.frame = popView.frame;
    [annotationView addSubview:popView];
    ((BMKPinAnnotationView*)annotationView).paopaoView = nil;
    annotationView.annotation = annotation;
    
    return annotationView;
#endif
}





- (void)dealloc {
    
 

//    if (_geocodesearch != nil)
//    {
//        _geocodesearch = nil;
//    }
//    if (_m_mapView)
//    {
//        _m_mapView = nil;
//    }
    
    self.m_mapView = nil;
    self.geocodesearch = nil;
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
