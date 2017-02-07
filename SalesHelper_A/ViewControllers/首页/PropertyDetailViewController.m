//
//  PropertyDetailViewController.m
//  SalesHelper_A
//
//  Created by ZhipuTech on 15/6/19.
//  Copyright (c) 2015年 X. All rights reserved.
//

#import "PropertyDetailViewController.h"
#import "SDCycleScrollView.h"
#import "PopupCommendView.h"
#import "RecommendViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import "redTitleViewForProperty.h"
#import "UIPhotoBrowser.h"
#import <CoreText/CoreText.h>
#import "LocationViewController.h"
#import "LoginViewController.h"


#import <MessageUI/MessageUI.h>

#import "UIColor+Extend.h"

#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>//引入云检索功能所有的头文件
#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入计算工具所有的头文件
#import <BaiduMapAPI_Radar/BMKRadarComponent.h>//引入周边雷达功能所有的头文件
#import "SCLAlertView.h"
#import "UIImage+Rotate.h"

//点击跳转页面动画
#import "HorizontalInteractionController.h"
#import "TransitionInteractionController.h"
#import "TransitionsManager.h"
#import "ZoomAlphaAnimationController.h"
#import "CardSlideAnimationController.h"
#import "VerticalSwipeInteractionController.h"
#import "PinchInteractionController.h"
#import "CirclePushAnimationController.h"
#import "PresentPicViewController.h"//展示头部图片视图

#import "RecommendClientViewController.h"
#import "RecommandBuildViewController.h"
#import "ZJShareView.h"


#define MYBUNDLE_NAME @"mapapi.bundle"
#define MYBUNDLE_PATH [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: MYBUNDLE_NAME]
#define MYBUNDLE [NSBundle bundleWithPath: MYBUNDLE_PATH]




@interface PropertyDetailViewController () <UITableViewDataSource, UITableViewDelegate, SDCycleScrollViewDelegate, UIActionSheetDelegate, UIPhotoBrowserDelegate
,BMKMapViewDelegate,BMKLocationServiceDelegate,BMKRouteSearchDelegate,UIScrollViewDelegate,MFMessageComposeViewControllerDelegate>

@property (nonatomic ,retain) NSDictionary * dict;
@property (nonatomic ,weak) UIView * scrollContentView;
@property (nonatomic ,retain) NSMutableArray * houseimageLinesURLs;
@property (nonatomic ,retain) NSMutableArray * houseimageLinestitles;
@property (nonatomic ,retain) NSMutableArray * peropertyImageUrls;
@property (nonatomic ,retain) UILabel * titleLabel;
@property (nonatomic ,retain) NSMutableArray * availableMaps;
@property (nonatomic, strong) UITableView *tabelView;
@property (nonatomic, strong) UITextView *textView;

@property (nonatomic, strong) NSMutableArray* labelArray;
@property (nonatomic, strong) BMKMapView * mapView;


@property (nonatomic, strong) NSMutableArray * agentArray;


@property (nonatomic, strong) id<TransitionInteractionController> presentInteractionController;




@end


@implementation PropertyDetailViewController
{
    //顶部图片
    NSArray * arrImage ;
    SDCycleScrollView * cycleView;//滚动浏览视图
  
    CGFloat rowHeight;
    CGFloat rowHeightForReward;
    CGFloat rowHeightForTK;
    CGFloat rowHeightForPoint;
    NSAttributedString * rewardP;
    NSAttributedString * sellP;
    NSAttributedString * tk;
    
    BMKPointAnnotation* annotationP;
    UIView *mapBackView;
    CLLocationCoordinate2D  start;
    CLLocationCoordinate2D  end;
    NSString * cityName;
    
    UIScrollView* _scrollView;
    UILabel* imgCount;
    UIView* headerView ;
    UIImageView *imageView;
    UIImageView* bottomImg1;
    UILabel *yongJinLabel;
    UILabel *label1;
    UILabel *label2;
    
    CGFloat  imageHeight;//头图根据屏幕尺寸适应
    CGFloat  dongtaiHeight;
    
    CGFloat  popViewHeight;
    UIControl *backControl;
    UIView* view11;

}

- (NSString*)getMyBundlePath1:(NSString *)filename
{
    
    NSBundle * libBundle = MYBUNDLE ;
    if ( libBundle && filename ){
        NSString * s=[[libBundle resourcePath ] stringByAppendingPathComponent : filename];
        return s;
    }
    return nil ;
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [_mapView viewWillAppear];
    _mapView.delegate = self;
    


    if (self.tabelView.contentOffset.y >=170) {

        self.topView.backgroundColor = [UIColor hexChangeFloat:@"00aff0"];
        self.titleLabel.text = self.dict[@"name"];;
    }
    
    


    [[TransitionsManager shared] setInteractionController:self.presentInteractionController
                                       fromViewController:[self class]
                                         toViewController:nil
                                                forAction:TransitionAction_Present];
    
    

    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [_mapView viewWillDisappear];
    _mapView.delegate = nil;
    
}



- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    if (SCREEN_WIDTH ==320 || SCREEN_WIDTH == 375) {
      
        imageHeight = 220;
    }else{
        imageHeight = 300;
    }
    
    if (SCREEN_HEIGHT == 480) {
        popViewHeight = 320;
    }else if (SCREEN_HEIGHT == 568){
        popViewHeight = 400;
    }else if (SCREEN_HEIGHT == 667){
        popViewHeight = 450;
    }else{
        popViewHeight = 500;
    }
    

    self.view.backgroundColor = [UIColor whiteColor];
    
    self.presentInteractionController = [[VerticalSwipeInteractionController alloc] init];
    [self.presentInteractionController setNextViewControllerDelegate:self];
    [self.presentInteractionController attachViewController:self withAction:TransitionAction_Present];
    

    [[TransitionsManager shared] setAnimationController:[[CirclePushAnimationController alloc] init]
                                     fromViewController:[self class]
                                              forAction:TransitionAction_PresentDismiss];
    [self createHeaderViewForTableView];
#pragma mark --请求数据
    
    if (IOS_VERSION >=7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    //判断网络状态
    Reachability *netWorkReachable = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    if ([netWorkReachable currentReachabilityStatus] == NotReachable)
    {
        [self.view makeToast:@"网络无法连接" duration:0.8 position:@"center"];
    }
    
    self.tabelView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    self.tabelView.delegate = self;
    self.tabelView.dataSource = self;
    self.tabelView.backgroundColor = [UIColor hexChangeFloat:@"f1f1f1"];
    
    if (GetOrgCode != nil)
    {
        UIView* footerView = [[UIView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, 50)];
        footerView.backgroundColor = [UIColor hexChangeFloat:@"f1f1f1"];
        self.tabelView.tableFooterView = footerView;
    }
    else
    {
        self.tabelView.tableFooterView = [[UIView alloc]init];
    }
    self.tabelView.separatorColor = [UIColor colorWithRed:239/255.0f green:239/255.0f blue:244/255.0f alpha:1];
    headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,imageHeight)];
    self.tabelView.tableHeaderView = headerView;
    //self.tabelView.contentInset = UIEdgeInsetsMake(220, 0, 0, 0);
    
    self.tabelView.tag = 888;
    
    [self.view addSubview:self.tabelView];
    [self requestData];
   
    
    
//    [self creatNavigationBackButton];
    [self CreateCustomNavigtionBarWith:self leftItem:@selector(backToView) rightItem:@selector(share:)];
    self.topView.alpha = 1;
    self.topView.backgroundColor = [UIColor clearColor];
    self.backBtn.alpha = 1;
    self.rightBtn.alpha = 1;
    
    //创建标题
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-200)/2, 27, 200, 30)];
    self.titleLabel.font = Default_Font_20;
    [self.titleLabel setTextColor:[UIColor whiteColor]];
    //    [titleLabel sizeToFit];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.topView addSubview: self.titleLabel];
    [self.rightBtn setImage:[UIImage imageNamed:@"首页-分享.png"] forState:UIControlStateNormal];
    [self.rightBtn setImage:[UIImage imageByApplyingAlpha:[UIImage imageNamed:@"首页-分享.png"]] forState:UIControlStateHighlighted];
    self.rightBtn.tintColor = [UIColor whiteColor];
    
}

-(void)createHeaderViewForTableView
{
    
    headerView.backgroundColor = [UIColor redColor];
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, imageHeight)];
    _scrollView.scrollEnabled = YES;
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH*self.peropertyImageUrls.count, imageHeight);
    _scrollView.tag = 999;
    _scrollView.delegate = self;
    _scrollView.backgroundColor = [UIColor blueColor];
    
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    
    [headerView addSubview:_scrollView];
    

    if ([self.dict objectForKey:@"propertyImageLines"])
    {
        for (int i=0; i<self.peropertyImageUrls.count; i++) {
            
            imageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, imageHeight)];
            imageView.image = [UIImage imageNamed:@"pp_bg.png"];
            NSString * urlString = [[self.dict objectForKey:@"propertyImageLines"][i]objectForKey:@"url"];
            imageView.tag = 3000+i;
            urlString = [REQUEST_IMG_SERVER_URL stringByAppendingString:urlString];
            [imageView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"pp_bg.png"]];
            imageView.userInteractionEnabled = YES;
            
            UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
            [imageView addGestureRecognizer:tap];
            
            [_scrollView addSubview:imageView];
            
        }
    }
    bottomImg1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, imageHeight-60, SCREEN_WIDTH, 60)];
    //bottomImg1.image = [self imageWithBgColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.05]];
    bottomImg1.image  = [UIImage imageNamed:@"图层-1@3x(1)"];
    bottomImg1.alpha = 0.8;
    bottomImg1.userInteractionEnabled = YES;
    [headerView addSubview:bottomImg1];
    
    imgCount = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-40, imageHeight-30, 30, 20)];
    imgCount.text = [NSString stringWithFormat:@"1/%d",(int)self.peropertyImageUrls.count];
    imgCount.textColor = [UIColor whiteColor];
    imgCount.font = [UIFont boldSystemFontOfSize:15];
    imgCount.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:imgCount];
    
    
    //佣金
    yongJinLabel = [[UILabel alloc] init];
    yongJinLabel.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];
    yongJinLabel.textColor = [UIColor whiteColor];
    yongJinLabel.textAlignment = NSTextAlignmentLeft;
    yongJinLabel.font = [UIFont systemFontOfSize:20];
    yongJinLabel.frame = CGRectMake(0, imageHeight-65,120, 30);
    if (GetOrgCode != nil && GetOrgCode != [NSNull null])
    {
        
      if ([self.dict objectForKey:@"priceRemark"] &&
          [self.dict objectForKey:@"priceRemark"] != [NSNull null] &&
          [self.dict objectForKey:@"priceRemark"] != nil)
       {
        
        yongJinLabel.text = [NSString stringWithFormat:@"  佣金:%@", [self.dict objectForKey:@"priceRemark"]];
        CGFloat priceW = [yongJinLabel.text boundingRectWithSize:CGSizeMake(0, 30) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20]} context:nil].size.width;
        yongJinLabel.frame = CGRectMake(0, imageHeight-65, priceW+5, 30);
        }
    }
    if (GetOrgCode == nil && GetUserID != nil)
    {
        yongJinLabel.text = @"  佣金:无权限查看";
        yongJinLabel.font = [UIFont systemFontOfSize:15];
    }
    if (GetOrgCode == nil && GetUserID == nil)
    {
        yongJinLabel.text = @"  佣金:登录后查看";
        yongJinLabel.font = [UIFont systemFontOfSize:15];
    }
    [headerView addSubview:yongJinLabel];

    //均价
    label1 = [[UILabel alloc] initWithFrame:CGRectMake(10, imageHeight-30, SCREEN_WIDTH/2-10, 20)];
    label1.backgroundColor = [UIColor clearColor];
    label1.textColor = [UIColor whiteColor];
    label1.textAlignment = NSTextAlignmentLeft;
    label1.font = [UIFont systemFontOfSize:15];
    if (([self.dict objectForKey:@"price"] &&
         [self.dict objectForKey:@"price"] != [NSNull null] &&
         [self.dict objectForKey:@"price"] != nil)
        )
    {
        label1.text = [NSString stringWithFormat:@"均价:%@元/平米", [self.dict objectForKey:@"price"]];
        
    }
    else
    {
        label1.hidden = YES;
    }
    CGSize rect = [label1.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 20) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
    label1.frame = CGRectMake(10, imageHeight-30, rect.width, 20);
    [headerView addSubview:label1];
    
    label2 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label1.frame)+10, imageHeight-30, SCREEN_WIDTH/2-20, 20)];
    label2.backgroundColor = [UIColor clearColor];
    label2.textColor = [UIColor whiteColor];
    label2.textAlignment = NSTextAlignmentLeft;
    label2.font = [UIFont systemFontOfSize:15];
    
    if ([self.dict[@"discountPrice"] floatValue]) {
        label2.text = [NSString stringWithFormat:@"购房金:%@元",self.dict[@"discountPrice"]];
    }else{
        label2.text = @"";
    }
    [headerView addSubview:label2];
//    [self.tabelView reloadData];
    
}


#pragma mark --创建导航栏左边返回按钮
- (void)creatNavigationBackButton
{
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 26, 26)];
    [backButton setImage:[UIImage imageNamed:@"首页-左箭头"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageByApplyingAlpha:[UIImage imageNamed:@"首页-左箭头"]] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backToView) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    //    UILabel * titleLabel = [UILabel new];
    //    titleLabel.text = self.titlestr;
    //    titleLabel.font = [UIFont fontWithName:@"HYQiHei-EEJ" size:18];
    //    [titleLabel setTextColor:[UIColor whiteColor]];
    //    [titleLabel sizeToFit];
    //    self.navigationItem.titleView = titleLabel;
    
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 27, 27);
    [btn setImage:[UIImage imageNamed:@"首页-分享"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"首页-分享"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* BACK = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = BACK;
    
    self.view.backgroundColor = [UIColor hexChangeFloat:@"f2f2f2"];
}

- (void)backToView
{
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --创建底部按钮
- (void)creatBottomView
{
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50)];
    bottomView.backgroundColor = [UIColor hexChangeFloat:@"00aff0"];
    [self.view addSubview:bottomView];
    
#if 0
    //图片
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, (50-22)/2, 22, 22)];
    imageView.image = [UIImage imageNamed:@"销邦-楼盘详情页-佣金2.png"];
    [bottomView addSubview:imageView];
    
    //佣金比例
    NSString *rateStr = [self.dict objectForKey:@"priceRemark"];
    CGFloat labelW = [rateStr boundingRectWithSize:CGSizeMake(0, 30) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:Default_Font_20} context:nil].size.width;
    UILabel *laebl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame)+5, 10, labelW, 30)];
    laebl.text = [self.dict objectForKey:@"priceRemark"];
    laebl.textColor = [UIColor whiteColor];
    laebl.font = Default_Font_20;
    [bottomView addSubview:laebl];
    
#endif
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-85)/2, 5, 85, 40)];
    //    button.layer.cornerRadius = 5;
    //    button.clipsToBounds = YES;
    //    button.layer.borderColor = [UIColor whiteColor].CGColor;
    //    button.layer.borderWidth = 1.2;
    [button setTitle:@"立即推荐" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(click_Commend) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:button];
    
}

#pragma mark --请求数据
- (void)requestData
{
  
    self.houseimageLinesURLs = [NSMutableArray arrayWithCapacity:0];
    self.houseimageLinestitles = [NSMutableArray arrayWithCapacity:0];
    self.peropertyImageUrls = [NSMutableArray arrayWithCapacity:0];
    self.availableMaps = [NSMutableArray arrayWithCapacity:0];
    self.labelArray = [NSMutableArray arrayWithCapacity:0];
    self.agentArray = [NSMutableArray arrayWithCapacity:0];
    
    [self.view Loading_0314];
    
    RequestInterface * loadPerpoty = [[RequestInterface alloc] init];
    [loadPerpoty requestGetPropertyInfosWithPropertyInfoID:self.ID];
    [loadPerpoty getInterfaceRequestObject:^(id data) {
        
        if ([data objectForKey:@"success"])
        {
            self.dict = [data objectForKey:@"datas"];
            HWLog(@"-------%@",self.dict[@"openDate"]);
            
            if ([self.dict objectForKey:@"dname"]) {
                [self.labelArray addObject:[self.dict objectForKey:@"dname"]];
            }
            if (self.dict[@"estateLines"] && self.dict[@"estateLines"] !=nil && self.dict[@"estateLines"] !=[NSNull null]) {
                for (int i=0; i<[self.dict[@"estateLines"] count]; i++) {
                    [self.labelArray addObject:self.dict[@"estateLines"][i][@"name"]];
                }
            }
            if (self.dict[@"propertyTages"] !=nil && self.dict[@"propertyTages"]!=[NSNull null]&&self.dict[@"propertyTages"] ) {
                
                for (int i=0; i<[self.dict[@"propertyTages"] count]; i++) {
                    [self.labelArray addObject:self.dict[@"propertyTages"][i][@"tage"]];
                    
                }
            }
            //驻场顾问
            if (self.dict[@"propertyonsite"] !=nil
                && self.dict[@"propertyonsite"]!=[NSNull null]
                &&self.dict[@"propertyonsite"] )
            {
               
                [self.agentArray addObjectsFromArray:self.dict[@"propertyonsite"]];
                NSLog(@"agent=%@",self.agentArray);
            }
            
            if ([self.dict objectForKey:@"houseimageLines"])
            {
                for (int i = 0; i < [[self.dict objectForKey:@"propertyImageLines"] count]; i ++)
                {
                    [self.peropertyImageUrls addObject:[REQUEST_IMG_SERVER_URL stringByAppendingString:[[self.dict objectForKey:@"propertyImageLines"][i] objectForKey:@"url"]]];
                }
                NSArray * array = [self.dict objectForKey:@"houseimageLines"];
                
                for (int i = 0 ; i < array.count; i++)
                {
                    NSDictionary * dict = array[i];
                    if ([dict objectForKey:@"url"])
                    {
                        NSString * str = [REQUEST_IMG_SERVER_URL stringByAppendingString:[dict objectForKey:@"url"]];
                        [self.houseimageLinesURLs addObject:str];
                    }
                    if ([dict objectForKey:@"title"])
                    {
                        [self.houseimageLinestitles addObject:[dict objectForKey:@"title"]];
                    }
                    //佣金明细
                    if([self.dict objectForKey:@"rewardPolicy"] && [self.dict objectForKey:@"rewardPolicy"] != [NSNull null] && [self.dict objectForKey:@"rewardPolicy"] != nil)
                    {
                        NSString * htmlString =[self.dict objectForKey:@"rewardPolicy"];
                        NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
                        rewardP = attrStr;
                        //NSLog(@"reward = %@",rewardP);
                    }
                    //项目卖点
                    if([self.dict objectForKey:@"sellingPoint"] && [self.dict objectForKey:@"sellingPoint"] != [NSNull null] && [self.dict objectForKey:@"sellingPoint"] != nil)
                    {
                        
                        NSString * htmlString =[self.dict objectForKey:@"sellingPoint"];
                        NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
                        sellP = attrStr;
                    }
                    //拓客技巧
                    if([self.dict objectForKey:@"tkArtifice"] &&
                       [self.dict objectForKey:@"tkArtifice"] != [NSNull null] &&
                       [self.dict objectForKey:@"tkArtifice"] != nil)
                    {
                        NSString * htmlString =[self.dict objectForKey:@"tkArtifice"];
                        NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
                        tk = attrStr;
                    }
                }
            }
            [self createHeaderViewForTableView];
        }else
        {
            [self.view Hidden];
            [self.view makeToast:data[@"success"]];
        }
        
        [self.tabelView reloadData];
#pragma mark --创建底部按钮
        if (GetOrgCode != nil && GetOrgCode != [NSNull null])
        {
            [self creatBottomView];
        }

        [self.view Hidden];

        
    } Fail:^(NSError *error) {
        [self.view Hidden];
        NSLog(@"首页信息出错啦");
    }];
    
}

#pragma mark --设置大头针
- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
    // 生成重用标示identifier
    NSString *AnnotationViewID = @"xidanMark";
    
    // 检查是否有重用的缓存
    BMKAnnotationView* annotationView = [view dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    
    // 缓存没有命中，自己构造一个，一般首次添加annotation代码会运行到此处
    if (annotationView == nil) {
        annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        ((BMKPinAnnotationView*)annotationView).pinColor = BMKPinAnnotationColorRed;
        // 设置重天上掉下的效果(annotation)
        ((BMKPinAnnotationView*)annotationView).animatesDrop = YES;
    }
    
    annotationView.centerOffset = CGPointMake(0, -(annotationView.frame.size.height * 0.5));
    annotationView.annotation = annotation;
    // 单击弹出泡泡，弹出泡泡前提annotation必须实现title属性
    annotationView.canShowCallout = YES;
    // 设置是否可以拖拽
    annotationView.draggable = YES;
    
    ((BMKPinAnnotationView*)annotationView).pinColor = BMKPinAnnotationColorPurple;
    ((BMKPinAnnotationView*)annotationView).animatesDrop = YES;// 设置该标注点动画显示
    annotationView.annotation = annotation;
    annotationView.image = [UIImage imageNamed:@"销邦-定位符号.png"];   //把大头针换成别的图片
    
    
    //        annotationView.selected = YES;
    return annotationView;
    
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 7;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 2;
    }
    else if (section == 1)
    {
        return 1;
    }
    else if (section == 2)
    {
        if ([self.dict objectForKey:@"storephone"] != nil &&
            [self.dict objectForKey:@"storephone"] != [NSNull null] &&
            [self.dict objectForKey:@"storephone"]) {
            return 8;
        }else{
            return 7;
        }
    }
    else if (section == 3 || section == 4 || section == 5)
    {
        return 2;
    }
    else{
        return [self.agentArray count];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 5)
    {
        if ([self.agentArray count] == 0)
        {
            return 0.001;
        }else{
          return 30;
        }
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
//    if (section == 0) {
//        return 220;
//    }
    return 0.0001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            return 100;
        }
        else if (self.dict[@"isDongtai"] && self.dict[@"isDongtai"] !=nil && self.dict[@"isDongtai"] !=[NSNull null])
        {
               dongtaiHeight = [self.dict[@"isDongtai"] boundingRectWithSize:CGSizeMake(MAXFLOAT, 20) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:Default_Font_15} context:nil ].size.width;
            }
            if (dongtaiHeight > 260) {
                return 60;
            }else{
                return 44;
            }
            //return 60;
    }
    else if (indexPath.section == 1)
    {
        if ([self.labelArray count]<=7) {
            return 120;
        }else{
        return  140;
        }
    }
    else if ( indexPath.section == 2)
    {
        if (indexPath.row == 1)
        {
            return 240;
        }
        else if (indexPath.row == 3)
        {
            return 60;
        }
        else
        {
            return 44;
        }
    }
    else if (indexPath.section == 3)
    {
        if (indexPath.row == 0)
        {
            return 44;
        } else {
            return 240;
        }
    }
#pragma mark --佣金政策
    else if (indexPath.section == 4)
    {
        if (indexPath.row == 0) {
            return 44;
        } else {
            
            if([self.dict objectForKey:@"rewardPolicy"] &&
               [self.dict objectForKey:@"rewardPolicy"] != [NSNull null] &&
               [self.dict objectForKey:@"rewardPolicy"] != nil)
            {
//                NSString * htmlString =[self.dict objectForKey:@"rewardPolicy"];
//                CGFloat height = [htmlString boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:Default_Font_15} context:nil].size.height;
//                if (height > 170) {
//                    return 240;
//                }else if (height < 50){
//                    return 120+40;
//                }else{
//                    return height+30+40;
                return 200;
                
            }else{
                return 60;
            }
        }
    }
#pragma mark --项目卖点
    else if (indexPath.section == 5)
    {
        if (indexPath.row == 0)
        {
            return 44;
        }
        else
        {
            
            if([self.dict objectForKey:@"rewardPolicy"] &&
               [self.dict objectForKey:@"rewardPolicy"] != [NSNull null] &&
               [self.dict objectForKey:@"rewardPolicy"] != nil)
            {
//                NSString * htmlString =[self.dict objectForKey:@"rewardPolicy"];
//                CGFloat height = [htmlString boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:Default_Font_15} context:nil].size.height;
//                if (height > 170) {
//                    return 240;
//                }else{
//                    return height+30+40;
//                }
                return 200;
            }else{
                return 60;
            }
        }
    }
#pragma mark --拓客技巧
    else
    {
//        if (indexPath.row == 0)
//        {
//            return 44;
//        }
//        else
//        {
//        return [self heightForString:tk]+24;
//        //return [self heightForString:tk];
//        }
        return 80;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 5)
    {
        if ([self.agentArray count] !=0)
        {
            
        
        UILabel * headLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
        headLab.text = @"   驻场顾问为您服务";
        headLab.textColor = [UIColor hexChangeFloat:KQianheiColor];
        headLab.font = Default_Font_14;
        headLab.backgroundColor = [UIColor hexChangeFloat:@"f1f1f1"];
        return headLab;
        }
        else
        {
            return nil;
        }
    }else{
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
        view.backgroundColor = [UIColor hexChangeFloat:@"f2f2f2"];
        return view;
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        UIView* view = [[UIView alloc]init];
        return view;
    }
    return nil;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"%ld", (long)indexPath.row]];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
 
#pragma mark --头部视图，楼盘信息
    //修改第0section1row的cell的边框
    if (indexPath.section == 0)
    {
        
    if (indexPath.row == 0)
        {
            
            //楼盘名
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, SCREEN_WIDTH-10, 30)];
            titleLabel.font = Default_Font_20;
            titleLabel.text = self.dict[@"name"];//self.titlestr;
            titleLabel.textColor = [UIColor hexChangeFloat:KBlackColor];
            [cell.contentView addSubview:titleLabel];
            
#if 0
            for (int i = 0; i < [self.dict[@"estateLines"] count]; i++)
            {
                
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10+i*45, CGRectGetMaxY(titleLabel.frame), 40, 20)];
                label.text = self.dict[@"estateLines"][i][@"name"];
                label.font = Default_Font_13;
                label.textColor = [UIColor hexChangeFloat:KHuiseColor];
                [cell.contentView addSubview:label];
                
            }
#endif
            //标签
             CGFloat tempWidth=0 ;
            for (int i = 0; i<self.labelArray.count; i++) {
                
#if 1
                if (self.labelArray.count <=7) {
                    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10+i*10, CGRectGetMaxY(titleLabel.frame), 10, 20)];
                    label.text = self.labelArray[i];
                    label.font = Default_Font_13;
                
                    CGSize sizeFrame;
                    if (IOS_VERSION <=7.0) {
                      sizeFrame = [label.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:Default_Font_13,NSFontAttributeName ,nil]];
                    }else{
                   sizeFrame = [label.text boundingRectWithSize:CGSizeMake(0, 20) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:Default_Font_13} context:nil].size;
                    }
                    label.frame = CGRectMake(10+tempWidth, CGRectGetMaxY(titleLabel.frame), sizeFrame.width, 20);
                    label.backgroundColor = [UIColor whiteColor];
                    label.textColor = [UIColor hexChangeFloat:KHuiseColor];
                    tempWidth += sizeFrame.width+5;
                    [cell.contentView addSubview:label];
                    //NSLog(@"%@",self.labelArray);
                }
                else{
                   
                    UILabel* lastLabel = [[UILabel alloc]initWithFrame:CGRectMake(10+(i-7)*42,CGRectGetMaxY(titleLabel.frame)+20,42, 20)];
                    lastLabel.text = [self.labelArray objectAtIndex:i];
                    lastLabel.font = Default_Font_13;
                    lastLabel.textColor = [UIColor hexChangeFloat:KHuiseColor];
                    [cell.contentView addSubview:lastLabel];
                }


#endif
            
            }
            //推荐有效期
            UILabel * deadline = [[UILabel alloc]initWithFrame:CGRectMake(10,CGRectGetMaxY(titleLabel.frame)+20,SCREEN_WIDTH-20, 15)];
            deadline.textAlignment = NSTextAlignmentLeft;
            deadline.textColor = [UIColor hexChangeFloat:KGrayColor];
            deadline.font = Default_Font_12;
//            deadline.text = @"有效期：2016年5月30日";
            [cell.contentView addSubview:deadline];
            
            if (self.dict[@"valid_timebucket"] != nil &&
                self.dict[@"valid_timebucket"] != [NSNull null] &&
                self.dict[@"valid_timebucket"] )
            {
               NSArray * array = [self.dict[@"valid_timebucket"] componentsSeparatedByString:@"/"];
            
//            NSLog(@"%@",array);
            if ([[array firstObject] length] > 0 || [[array lastObject] length] > 0)
            {
                NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
                [formatter setDateFormat:@"YYYY年MM月dd日"];
                NSTimeZone * zone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
                [formatter setTimeZone:zone];
                NSString * startStr;
                if ([[array firstObject] length] > 0)
                {
                    NSDate * startDate = [NSDate dateWithTimeIntervalSince1970:[[array firstObject] floatValue]];
                   startStr  = [formatter stringFromDate:startDate];
                }else{
                    startStr = @"";
                }
                NSString * endStr;
                if ([[array lastObject] length] > 0) {
                   NSDate * endDate = [NSDate dateWithTimeIntervalSince1970:[[array lastObject] floatValue]];
                    endStr = [formatter stringFromDate:endDate];
                }else
                {
                    endStr = @"";
                }
                deadline.text = [NSString stringWithFormat:@"有效期:%@-%@",startStr,endStr];
             }
            }
            for (int i = 0; i < [self.dict[@"labelLines"] count]; i++)
            {
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12 + i*55, CGRectGetMaxY(titleLabel.frame)+40, 45, 20)];
                
                
                label.text = self.dict[@"labelLines"][i][@"name"];
                label.textAlignment = NSTextAlignmentCenter;
                
                label.textColor = [UIColor hexChangeFloat:self.dict[@"labelLines"][i][@"color"]];
                label.font = Default_Font_13;
                label.layer.masksToBounds = YES;
                label.layer.cornerRadius = 5;
                label.layer.borderColor = [UIColor hexChangeFloat:self.dict[@"labelLines"][i][@"color"]].CGColor;
                label.layer.borderWidth = 0.5;
                [cell.contentView addSubview:label];
            }
            
            UILabel* lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,99.5, SCREEN_WIDTH, 0.5)];
            lineLabel.backgroundColor = [UIColor colorWithRed:239/255.0f green:239/255.0f blue:244/255.0f alpha:1];
            [cell.contentView addSubview:lineLabel];
            
        }
        else
        {
            UIImageView *imageViewS = [[UIImageView alloc] initWithFrame:CGRectMake(10, 12, 14, 14)];
            imageViewS.image = [UIImage imageNamed:@"销邦-首页-新-通知"];
            [cell.contentView addSubview:imageViewS];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageViewS.frame)+5,10, SCREEN_WIDTH-15-30-18, 36)];
#pragma mark  礼物
            if (self.dict[@"isDongtai"] && self.dict[@"isDongtai"] !=nil && self.dict[@"isDongtai"] !=[NSNull null]) {
                label.text = self.dict[@"isDongtai"];
                
                 dongtaiHeight = [self.dict[@"isDongtai"] boundingRectWithSize:CGSizeMake(MAXFLOAT, 20) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:Default_Font_15} context:nil ].size.width;

                
                
            }else {
               label.text = @"";
            }
            label.font = Default_Font_15;
            label.textColor = [UIColor hexChangeFloat:KQianheiColor];
            if (dongtaiHeight >260) {
                label.numberOfLines = 2;
            }else{
            label.numberOfLines = 1;
            label.frame = CGRectMake(CGRectGetMaxX(imageViewS.frame)+5,10, SCREEN_WIDTH-15-30-18, 20);
            }
//            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:label.text];
//            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//            [paragraphStyle setLineSpacing:4];
//            [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [label.text length])];
//            label.attributedText = attributedString;
//            [label sizeToFit];
            [cell.contentView addSubview:label];
            
            UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-20,(60-18)/2, 10, 18)];
            imageView1.image = [UIImage imageNamed:@"楼盘详情_右箭头"];
            if (dongtaiHeight <250) {
                imageView1.frame = CGRectMake(SCREEN_WIDTH-20,(44-18)/2, 10, 18);
            }
            [cell.contentView addSubview:imageView1];
            
        }
        
    }
#pragma mark --报备人数
    else if (indexPath.section == 1)
    {
        
        //报备人数
        UILabel *baobeiLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, SCREEN_WIDTH, 25)];
        baobeiLabel.textAlignment = NSTextAlignmentCenter;
        baobeiLabel.font = Default_Font_15;
        baobeiLabel.textColor = [UIColor hexChangeFloat:KQianheiColor];
        
        if (self.dict[@"refereeSum"] && self.dict[@"refereeSum"] !=nil && self.dict[@"refereeSum"] !=[NSNull null]) {
            baobeiLabel.text =[NSString stringWithFormat:@"已报备%@人", self.dict[@"refereeSum"]];
        }else{
            baobeiLabel.text = @"已报备0人";
        }
   
        NSMutableAttributedString * aAttributedString = [[NSMutableAttributedString alloc] initWithString:baobeiLabel.text];
        //富文本样式
        [aAttributedString addAttribute:NSForegroundColorAttributeName  //文字颜色
                                  value:[UIColor hexChangeFloat:@"ff5f66"]
                                  range:NSMakeRange(3, [baobeiLabel.text length]-4)];
        
        [aAttributedString addAttribute:NSFontAttributeName             //文字字体
                                  value:[UIFont systemFontOfSize:18]
                                  range:NSMakeRange(3, [baobeiLabel.text length]-4)];
        baobeiLabel.attributedText = aAttributedString;
        [cell.contentView addSubview:baobeiLabel];
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-100)/2, CGRectGetMaxY(baobeiLabel.frame)+15, 100, 30)];
        [button setTitle:@"报备规则" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor hexChangeFloat:@"00aff0"] forState:UIControlStateNormal];
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 5;
        button.titleLabel.font = Default_Font_15;
        button.layer.borderColor = [UIColor hexChangeFloat:@"00aff0"].CGColor;
        button.layer.borderWidth = 0.5;
        [button addTarget:self action:@selector(baobeiRules) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:button];
        
    }
#pragma mark --地图cell
    else if (indexPath.section == 2)
    {
        if (indexPath.row == 0)
        {
            //地址
            UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 12, SCREEN_WIDTH-20, 20)];
            addressLabel.font = Default_Font_16;
            addressLabel.textAlignment = NSTextAlignmentCenter;
            addressLabel.textColor = [UIColor hexChangeFloat:KBlackColor];
            addressLabel.text = [self.dict objectForKey:@"address"];
            NSLog(@"address%@",addressLabel.text);
            [cell.contentView addSubview:addressLabel];
            UILabel* lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,43.5, SCREEN_WIDTH, 0.5)];
             lineLabel.backgroundColor = [UIColor colorWithRed:239/255.0f green:239/255.0f blue:244/255.0f alpha:1];
            [cell.contentView addSubview:lineLabel];
            
        }
        else if (indexPath.row == 1)
        {
            //地图

            
            if (!mapBackView) {
                
                mapBackView = [[UIView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, 240)];
                
                _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 240)];
                _mapView.delegate = self;
                [mapBackView addSubview:_mapView];

                
                //检索
                _mapView.showsUserLocation = NO;//先关闭显示的定位图层
                _mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
                _mapView.showsUserLocation = YES;//显示定位图层
                _mapView.isSelectedAnnotationViewFront = YES;
               
                
                annotationP = [[BMKPointAnnotation alloc] init];
                [_mapView addAnnotation:annotationP];
                
            }
            
            if (self.dict[@"x"] !=nil &&
                self.dict[@"x"] != [NSNull null] &&
                self.dict[@"x"])
            {
                NSDictionary *location2D = @{
                                             @"x":[self.dict objectForKey:@"y"],
                                             @"y":[self.dict objectForKey:@"x"],
                                             };
                CLLocationCoordinate2D myProperty2D = CLLocationCoordinate2DMake([location2D[@"x"] doubleValue], [location2D[@"y"] doubleValue]);
                _mapView.centerCoordinate = myProperty2D;
                _mapView.zoomLevel = 16;
                
                annotationP.coordinate = myProperty2D;
    
            }
            [cell.contentView addSubview:mapBackView];


            
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushToMap)];
            [mapBackView addGestureRecognizer:tap];
            
            UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(pushToMap)];
            swipe.direction = UISwipeGestureRecognizerDirectionLeft;
            [mapBackView addGestureRecognizer:swipe];
            
            UISwipeGestureRecognizer *swipe1 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(pushToMap)];
            swipe1.direction = UISwipeGestureRecognizerDirectionRight;
            [mapBackView addGestureRecognizer:swipe1];
            
            UILabel* lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,239.5, SCREEN_WIDTH, 0.5)];
             lineLabel.backgroundColor = [UIColor colorWithRed:239/255.0f green:239/255.0f blue:244/255.0f alpha:1];
            [cell.contentView addSubview:lineLabel];
            
            
            
        }
#pragma mark --项目详情
        else if (indexPath.row == 2)
        {
            //标题
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 12, SCREEN_WIDTH, 20)];
            label.text = @"项目详情";
            label.font = Default_Font_16;
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = [UIColor hexChangeFloat:KBlackColor];
            [cell.contentView addSubview:label];
            
            UILabel* lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,43.5, SCREEN_WIDTH, 0.5)];
            lineLabel.backgroundColor = [UIColor colorWithRed:239/255.0f green:239/255.0f blue:244/255.0f alpha:1];
            [cell.contentView addSubview:lineLabel];
            
        }
        else if (indexPath.row == 3)
        {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH-20-10, 40)];
            label.font = Default_Font_15;
            label.textColor = [UIColor hexChangeFloat:KQianheiColor];
            label.numberOfLines = 2;
            
#pragma mark 项目详情
            if (self.dict[@"isXiangqing"] && self.dict[@"isXiangqing"] != nil && self.dict[@"isXiangqing"] != [NSNull null])  {
                label.text = self.dict[@"isXiangqing"];
            }else{
            label.text = @"";
                
            }//self.dict[@"isXiangqing"];
            //设置label内容的行间距
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:label.text];
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyle setLineSpacing:4];
            [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [label.text length])];
            label.attributedText = attributedString;
            [cell.contentView addSubview:label];
            [label sizeToFit];
            
            UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-20,(60-18)/2, 10, 18)];
            imageView1.image = [UIImage imageNamed:@"销邦-楼盘详情页-右箭头"];
            [cell.contentView addSubview:imageView1];
            
        }
        else if (indexPath.row == 4)
        {
            //开盘时间
            UILabel *openTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 12, SCREEN_WIDTH-20, 20)];
            openTimeLabel.font = Default_Font_15;
            openTimeLabel.textColor = [UIColor hexChangeFloat:KQianheiColor];
            
            
            if ([self.dict objectForKey:@"openTime"] &&
                [self.dict objectForKey:@"openTime"] != [NSNull null])
            {
               
                
                NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
                [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                
                NSTimeInterval time = [self.dict[@"openTime"] doubleValue];
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
                NSDateFormatter * f1 = [[NSDateFormatter alloc]init];
                [f1 setDateFormat:@"yyyy.MM.dd"];
                NSString * str = [f1 stringFromDate:date];
                openTimeLabel.text = [NSString stringWithFormat:@"开盘时间: %@", str];
            }
            else
            {
             openTimeLabel.text = [NSString stringWithFormat:@"开盘时间:"];
            }
            [cell.contentView addSubview:openTimeLabel];
            
        }
        else if (indexPath.row == 5)
        {
            //物业形态
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 12, SCREEN_WIDTH-20, 20)];
            label.font = Default_Font_15;
            label.textColor = [UIColor hexChangeFloat:KQianheiColor];
            [cell.contentView addSubview:label];
            
            if ([self.dict objectForKey:@"estateNames"] &&
                [self.dict objectForKey:@"estateNames"] != [NSNull null])
            {
                label.text = [NSString stringWithFormat:@"物业形态: %@", [self.dict objectForKey:@"estateNames"]];
            }else{
                label.text = [NSString stringWithFormat:@"物业形态:"];
            }
        }
        else if (indexPath.row == 6)
        {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 12, SCREEN_WIDTH-40, 20)];
            label.font = Default_Font_15;
            label.textColor = [UIColor hexChangeFloat:KQianheiColor];
            [cell.contentView addSubview:label];
        
            UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-20,12, 10, 18)];
            //            imageView1.image = [UIImage imageNamed:@"楼盘详情_右箭头"];
            imageView1.image = [UIImage imageNamed:@"销邦-楼盘详情页-右箭头"];
            [cell.contentView addSubview:imageView1];
            if ([self.dict objectForKey:@"houseResources"]&&[self.dict objectForKey:@"houseResources"] != [NSNull null])
            {
                
                label.text = [NSString stringWithFormat:@"在售房源: %@", [self.dict objectForKey:@"houseResources"]];
                if ([self.dict[@"houseResources"] length] * 15 <= 240)
                {
                    imageView1.hidden= YES;
                }else{
                    imageView1.hidden = NO;
                }
            }
            else
            {
                
                label.text = [NSString stringWithFormat:@"在售房源:"];
            }
        }
        //案场电话
        else
        {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 12, 80, 20)];
            label.font = Default_Font_15;
            label.text = @"案场电话：";
            label.textColor = [UIColor hexChangeFloat:KQianheiColor];
            [cell.contentView addSubview:label];
            UIButton * phoneBtn = [[UIButton alloc]initWithFrame:CGRectMake(60,12,150, 20)];
            if ([self.dict objectForKey:@"storephone"] != nil &&
                [self.dict objectForKey:@"storephone"] != [NSNull null] &&
                [self.dict objectForKey:@"storephone"])
            {
                [phoneBtn setTitle:[self.dict objectForKey:@"storephone"] forState:UIControlStateNormal];
            }
            [phoneBtn setTitleColor:[UIColor hexChangeFloat:KQianheiColor] forState:UIControlStateNormal];
            phoneBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
            phoneBtn.titleLabel.font = Default_Font_15;
            [phoneBtn addTarget:self action:@selector(clickToDailPhone:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:phoneBtn];
        }
        
    }
    else if (indexPath.section == 3)
    {
        if (indexPath.row == 0)
        {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
            label.text = @"主力户型";
            label.textColor = [UIColor hexChangeFloat:KBlackColor];
            label.font = Default_Font_16;
            label.textAlignment = NSTextAlignmentCenter;
            [cell.contentView addSubview:label];
            UILabel* lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,43.5, SCREEN_WIDTH, 0.5)];
            lineLabel.backgroundColor = [UIColor colorWithRed:239/255.0f green:239/255.0f blue:244/255.0f alpha:1];
            [cell.contentView addSubview:lineLabel];
            
        }
#pragma mark --主力户型轮播图
        else
        {
            // 户型详图scrollView
            SDCycleScrollView * cycleScrollView = [[SDCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 240)];
            
            if (self.houseimageLinesURLs.count > 0)
            {
                cycleScrollView.placeholderImage = [UIImage imageNamed:@"pp_bg.png"];
                cycleScrollView.imageURLStringsGroup = self.houseimageLinesURLs;
                if(_houseimageLinesURLs.count == 1)
                {
                    cycleScrollView.autoScroll = NO;
                    cycleScrollView.showPageControl = NO;
                }
                cycleScrollView.titlesGroup = self.houseimageLinestitles;
                cycleScrollView.titleLabelTextFont = Default_Font_12;
                cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
                cycleScrollView.delegate = self;
                cycleScrollView.dotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
                cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
                cycleScrollView.autoScrollTimeInterval = 3.0;
                cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
            }
            [cell.contentView addSubview:cycleScrollView];
        }
    }
#pragma mark --佣金政策
    else if (indexPath.section == 4)
    {
        if (indexPath.row == 0)
        {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
            label.text = @"佣金政策";
            label.textColor = [UIColor hexChangeFloat:KBlackColor];
            label.font = Default_Font_16;
            label.textAlignment = NSTextAlignmentCenter;
            [cell.contentView addSubview:label];
            UILabel* lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,43.4, SCREEN_WIDTH, 0.5)];
            lineLabel.backgroundColor = [UIColor colorWithRed:239/255.0f green:239/255.0f blue:244/255.0f alpha:1];
            [cell.contentView addSubview:lineLabel];
            
        }
        else
        {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 12, SCREEN_WIDTH-20, 130)];
//            label.numberOfLines = 6;
            label.numberOfLines = 0;

            //佣金明细
            if([self.dict objectForKey:@"rewardPolicy"] &&
               [self.dict objectForKey:@"rewardPolicy"] != [NSNull null] &&
               [self.dict objectForKey:@"rewardPolicy"] != nil)
            {
//                NSString * htmlString = [self.dict objectForKey:@"rewardPolicy"];
                //NSLog(@"%@",htmlString);
//                
//                NSMutableAttributedString* attributeStr = [[NSMutableAttributedString alloc]initWithString:htmlString];
//                NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc]init];
//                [paragraphStyle setLineSpacing:4];
//                [attributeStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, htmlString.length)];

                NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[[self.dict objectForKey:@"rewardPolicy"] dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
                
                NSMutableAttributedString* attributeStr = [[NSMutableAttributedString alloc]initWithAttributedString:attrStr];
                NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc]init];
                [paragraphStyle setLineSpacing:4];
                [attributeStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attrStr.length)];
                
                label.attributedText = attributeStr;
                label.font = Default_Font_15;
                label.textColor = [UIColor hexChangeFloat:KQianheiColor];
            }
            
            [cell.contentView addSubview:label];
//            [cell.contentView addSubview:textView];
            
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-100)/2, CGRectGetMaxY(label.frame)+5, 100, 30)];
            button.layer.borderColor = [UIColor hexChangeFloat:KBlueColor].CGColor;
            button.layer.borderWidth = 0.5;
            [button setTitle:@"全部" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor hexChangeFloat:KBlueColor] forState:UIControlStateNormal];
            button.layer.masksToBounds = YES;
            button.layer.cornerRadius = 5;
            button.tag = 100;
            [button addTarget:self action:@selector(checkAll:) forControlEvents:UIControlEventTouchUpInside];
            button.titleLabel.font = Default_Font_15;
            [cell.contentView addSubview:button];
        }
    }
    
#pragma mark --项目卖点
    else if (indexPath.section == 5)
    {
        if (indexPath.row == 0)
        {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
            label.text = @"项目卖点";
            label.textColor = [UIColor hexChangeFloat:KBlackColor];
            label.font = Default_Font_16;
            label.textAlignment = NSTextAlignmentCenter;
            [cell.contentView addSubview:label];
            UILabel* lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,43.5, SCREEN_WIDTH, 0.5)];
            lineLabel.backgroundColor = [UIColor colorWithRed:239/255.0f green:239/255.0f blue:244/255.0f alpha:1];
            [cell.contentView addSubview:lineLabel];
            
        }
        else
        {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 12, SCREEN_WIDTH-20, 130)];
            label.numberOfLines = 0;
            //项目卖点
            if([self.dict objectForKey:@"sellingPoint"] && [self.dict objectForKey:@"sellingPoint"] != [NSNull null] && [self.dict objectForKey:@"sellingPoint"] != nil)
            {
                
                NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[[self.dict objectForKey:@"sellingPoint"] dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
                
                NSMutableAttributedString* attributeStr = [[NSMutableAttributedString alloc]initWithAttributedString:attrStr];
                NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc]init];
                [paragraphStyle setLineSpacing:4];
                [attributeStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attrStr.length)];
                
                label.attributedText = attributeStr;
                label.font = Default_Font_15;
                label.textColor = [UIColor hexChangeFloat:KQianheiColor];

            }
            [cell.contentView addSubview:label];
            
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-100)/2, CGRectGetMaxY(label.frame)+5, 100, 30)];
            [button setTitle:@"全部" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor hexChangeFloat:KBlueColor] forState:UIControlStateNormal];
            button.layer.masksToBounds = YES;
            button.layer.cornerRadius = 5;
            button.layer.borderColor = [UIColor hexChangeFloat:KBlueColor].CGColor;
            button.layer.borderWidth = 0.5;
            button.tag = 101;
            [button addTarget:self action:@selector(checkAll:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:button];
        }
    }
    
#pragma mark --驻场顾问
    else
    {
        
        UIImageView * headImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 50, 50)];
        [headImg sd_setImageWithURL:[NSURL URLWithString:self.agentArray[indexPath.row][@"iconpath"]] placeholderImage:[UIImage imageNamed:@"默认个人图像"]];
        headImg.layer.cornerRadius = 25.0f;
        headImg.layer.masksToBounds = YES;
        [cell.contentView addSubview:headImg];
        
        UILabel * nameLab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(headImg.frame)+10, 15, 100, 20)];
        nameLab.textColor = [UIColor hexChangeFloat:KQianheiColor];
        nameLab.font = Default_Font_15;
        nameLab.text  = self.agentArray[indexPath.row][@"name"];//@"刘德华";
        [cell.contentView addSubview:nameLab];
        
        UILabel * phoneLab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(headImg.frame)+10, CGRectGetMaxY(nameLab.frame)+5, 150, 15)];
        phoneLab.textColor = [UIColor hexChangeFloat:KHuiseColor];
        phoneLab.font = Default_Font_13;
        
        NSString * startStr = [self.agentArray[indexPath.row][@"phone"] substringWithRange:NSMakeRange(0, 3)];
        NSString * endStr = [self.agentArray[indexPath.row][@"phone"] substringFromIndex:7];
        phoneLab.text =[NSString stringWithFormat:@"%@****%@",startStr,endStr];

        [cell.contentView addSubview:phoneLab];
        
        UIButton * dailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        dailBtn.frame = CGRectMake(SCREEN_WIDTH-100,15, 40, 40);
        [dailBtn setImage:[UIImage imageNamed:@"销邦-客户-推荐单个楼盘进度标签时间轴-电话@2x"] forState:UIControlStateNormal];
        dailBtn.tag = indexPath.row;
        [dailBtn addTarget:self action:@selector(dailPhoneToConnect:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:dailBtn];
        
        UIButton * messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        messageBtn.frame = CGRectMake(SCREEN_WIDTH-50,15, 40, 40);
        [messageBtn setImage:[UIImage imageNamed:@"销邦-客户-推荐单个楼盘进度标签时间轴-短信@2x"] forState:UIControlStateNormal];
        [messageBtn addTarget:self action:@selector(sendMessageToGuard:) forControlEvents:UIControlEventTouchUpInside];
        messageBtn.tag = indexPath.row;
        [cell.contentView addSubview:messageBtn];
    }
    
    return cell;
}
#pragma mark -- 案场电话
-(void)clickToDailPhone:(UIButton*)sender
{
    NSURL * url = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"tel:%@",[self.dict objectForKey:@"storephone"]]];
    NSURLRequest * request = [[NSURLRequest alloc]initWithURL:url];
    UIWebView * webView = [[UIWebView alloc]init];
    [webView loadRequest:request];
    [self.view addSubview:webView];
    
}

#pragma mark --call and message
//电话联系驻场顾问
-(void)dailPhoneToConnect:(UIButton*)sender
{
    
    NSURL * url = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"tel:%@",self.agentArray[sender.tag][@"phone"]]];
    NSURLRequest * request = [[NSURLRequest alloc]initWithURL:url];
    UIWebView * webView = [[UIWebView alloc]init];
    [webView loadRequest:request];
    [self.view addSubview:webView];
    
}
//短信联系驻场顾问
-(void)sendMessageToGuard:(UIButton*)sender
{
    
    if ([MFMessageComposeViewController canSendText])
    {
        MFMessageComposeViewController * messageVC = [[MFMessageComposeViewController alloc]init];
        messageVC.messageComposeDelegate = self;
        messageVC.navigationBar.tintColor = [UIColor hexChangeFloat:@"00aff0"];
        messageVC.recipients = [NSArray arrayWithObject:self.agentArray[sender.tag][@"phone"]];
        [self.navigationController presentViewController:messageVC animated:YES completion:nil];
    }
}

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [controller dismissViewControllerAnimated:YES completion:nil];
}


- (void)baobeiRules
{
    NSLog(@"%@", self.dict[@"isBaobei"]);
    if (self.dict[@"isBaobei"] &&
        self.dict[@"isBaobei"] != nil &&
        self.dict[@"isBaobei"] !=[NSNull null]) {
        //NSAttributedString* attributeStr = [[NSAttributedString alloc]initWithString:self.dict[@"isBaobei"]];
        [self cgrectMakeTextView:self.dict[@"isBaobei"] andTitleStr:@"报备规则"];
    }else {
        [self cgrectMakeTextView:nil andTitleStr:@"报备规则"];
    }
    
}

- (void)checkAll:(UIButton *)button
{
    if (button.tag == 100)
    {
        [self cgrectTextView:rewardP andTitleStr:@"佣金政策"];
//        [self cgrectMakeTextView:[self.dict objectForKey:@"rewardPolicy"] andTitleStr:@"佣金政策"];
        
    } else if (button.tag == 101)
    {
        [self cgrectTextView:sellP andTitleStr:@"项目卖点"];
    }
    else
    {
        [self cgrectTextView:tk andTitleStr:@"拓客技巧"];
    }
}

- (void)pushToMap
{
    NSLog(@"%@  %@", self.dict[@"x"], self.dict[@"y"]);
    
    LocationViewController * location = [[LocationViewController alloc] init];
    location.locationName = self.titleLabel.text;
    location.locationRoadName = [self.dict objectForKey:@"address"];
    
    if ([self.dict objectForKey:@"x"]!= nil &&
        [self.dict objectForKey:@"x"] != [NSNull null] &&
        ![[self.dict objectForKey:@"x"] isEqualToString: @""] &&
        [self.dict objectForKey:@"y"]!=nil &&
        [self.dict objectForKey:@"y"]!=[NSNull null] &&
        ![[self.dict objectForKey:@"y"] isEqualToString: @""])
    {
        location.location2D = @{
                                @"x":[self.dict objectForKey:@"y"],
                                @"y":[self.dict objectForKey:@"x"],
                                };
        [self.navigationController pushViewController:location animated:YES];
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

//tableView 开始滑动推出展示头部图片视图
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
#if 1

    CGFloat offset=self.tabelView.contentOffset.y;
//    NSLog(@"%f",offset);
    if (scrollView.tag == 888)
    {
        self.topView.backgroundColor = [UIColor colorWithRed:23/255.0f green:183/255.0f blue:242/255.0f alpha:(self.tabelView.contentOffset.y-50)/ 120];
       if (offset>=120 )
       {
          self.titleLabel.text = self.dict[@"name"];
            
        }else{
            self.titleLabel.text = @"";
        }
        
    }
    
    if (scrollView.tag == 999) {
       
        imgCount.text = [NSString stringWithFormat:@"%d/%d",(int)(1+scrollView.contentOffset.x/SCREEN_WIDTH),(int)self.peropertyImageUrls.count];
    }
    
#endif
    
}
-(void)viewDidLayoutSubviews{
    
    
}


-(void)tapClick:(UITapGestureRecognizer*)tap{
    
    PresentPicViewController* picVC = [[PresentPicViewController alloc]init];
    picVC.idStr = @"2";
    picVC.imageArrUrl = self.peropertyImageUrls;
    [picVC setTransitioningDelegate:[TransitionsManager shared]];
    [self presentViewController:picVC animated:YES completion:nil];
    
}
#pragma mark 点击头部视图跳转页面动画
- (UIViewController *)nextViewControllerForInteractor:(id<TransitionInteractionController>)interactor{
    
    PresentPicViewController* picVC = [[PresentPicViewController alloc]init];
    [picVC setTransitioningDelegate:[TransitionsManager shared]];
    return picVC;//[self nextSimpleColorViewController];
    
}

- (UIViewController *)nextSimpleViewController{
    [self setTransitioningDelegate:[TransitionsManager shared]];
    return self;
}

//- (UIViewController *)nextSimpleColorViewController{
//
//
//    PresentPicViewController* picVC = [[PresentPicViewController alloc]init];
//    picVC.idStr = self.ID;
//    picVC.imageArrUrl = self.peropertyImageUrls;
//    picVC.imageURLStringsGroup = self.houseimageLinesURLs;
//    picVC.imageTitleArr = self.houseimageLinestitles;
//    [picVC setTransitioningDelegate:[TransitionsManager shared]];
//    return picVC;
//
//
//}



-(void)showBrowser{
    
    //    NSMutableArray *photosArr = [NSMutableArray array];
    //    for(int i = 0 ; i < self.peropertyImageUrls.count;i ++)
    //    {
    //        UIPhoto *photo = [[UIPhoto alloc]init];
    //        photo.url = [NSURL URLWithString:self.peropertyImageUrls[i]];
    //        [photosArr addObject:photo];
    //    }
    //    UIPhotoBrowser *browser = [[UIPhotoBrowser alloc]init];
    //    browser.photos = photosArr;
    //    [browser show];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0)
    {
        
        
    }
    
    if (indexPath.section == 0 && indexPath.row == 1)
    {
        
    
        if (self.dict[@"isDongtai"] &&
            self.dict[@"isDongtai"] != nil &&
            self.dict[@"isDongtai"] !=[NSNull null]) {
            if ([self.dict[@"isDongtai"] length]*15 >=600) {
                [self cgrectMakeTextView:self.dict[@"isDongtai"] andTitleStr:@"最新动态"];
            }
        }else {
            //[self cgrectMakeTextView:nil andTitleStr:@"最新动态"];
        }
        
    }
    if (indexPath.section == 2 && indexPath.row == 3)
    {
        
        if (self.dict[@"isXiangqing"] &&
            self.dict[@"isXiangqing"] != nil &&
            self.dict[@"isXiangqing"] !=[NSNull null]) {
          
            if ([self.dict[@"isXiangqing"] length]*15 >=600) {
                [self cgrectMakeTextView:self.dict[@"isXiangqing"] andTitleStr:@"项目详情"];
            }
        }else {
            //[self cgrectMakeTextView:nil andTitleStr:@"项目详情"];
        }
        
       
        
    }
    if (indexPath.section == 2 && indexPath.row == 6)
    {
        if (self.dict[@"houseResources"] &&
            self.dict[@"houseResources"] != nil &&
            self.dict[@"houseResources"] !=[NSNull null])
        {
            
            if ([self.dict[@"houseResources"] length] * 15 >= 240)
            {
                [self cgrectMakeTextView:self.dict[@"houseResources"] andTitleStr:@"在售房源"];
            }
        }
    }

    //    if (indexPath.section == 2 && indexPath.row == 1)
    //    {
    //        LocationViewController * location = [[LocationViewController alloc]init];
    //        location.locationName = self.titlestr;
    //        location.locationRoadName = [self.dict objectForKey:@"address"];
    //        if ([self.dict objectForKey:@"x"]!= nil && [self.dict objectForKey:@"x"] != [NSNull null] && ![[self.dict objectForKey:@"x"] isEqualToString: @""] && [self.dict objectForKey:@"y"]!=nil &&  [self.dict objectForKey:@"y"]!=[NSNull null] && ![[self.dict objectForKey:@"y"] isEqualToString: @""])
    //        {
    //            location.location2D = @{
    //                                    @"x":[self.dict objectForKey:@"x"],
    //                                    @"y":[self.dict objectForKey:@"y"],
    //                                    };
    //            [self.navigationController pushViewController:location animated:YES];
    //        }
    //        [self availableMapsApps];
    //        UIActionSheet *action = [[UIActionSheet alloc] init];
    //
    //        [action addButtonWithTitle:@"使用系统自带地图导航"];
    //        for (NSDictionary *dic in self.availableMaps) {
    //            [action addButtonWithTitle:[NSString stringWithFormat:@"使用%@导航", dic[@"name"]]];
    //        }
    //        [action addButtonWithTitle:@"取消"];
    //        action.cancelButtonIndex = self.availableMaps.count + 1;
    //        action.delegate = self;
    //        [action showInView:self.view];
    //    }
}

- (void)cgrectTextView:(NSAttributedString *)str andTitleStr:(NSString*)titleStr;
{
    
    
    backControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    backControl.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.0];
    
    view11 = [[UIView alloc] initWithFrame:CGRectMake(5, SCREEN_HEIGHT, SCREEN_WIDTH-10, 100)];
    view11.backgroundColor = [UIColor whiteColor];
    view11.layer.cornerRadius = 5;
    view11.layer.masksToBounds = YES;
    
    [backControl addTarget:self action:@selector(hiddenView:) forControlEvents:UIControlEventTouchUpInside];
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    [keyWindow addSubview:backControl];
    
    
    //标题
    UILabel* Titlelabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-20, 39)];
    Titlelabel.text = titleStr;
    Titlelabel.font  = Default_Font_15;
    Titlelabel.textColor = [UIColor hexChangeFloat:KBlackColor];
    [view11 addSubview:Titlelabel];
    //隐藏按钮
    UIButton* colseBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-55, 0, 40, 40)];
    [colseBtn setImage:[UIImage imageNamed:@"Menu.png"] forState:UIControlStateNormal];
    [colseBtn addTarget:self action:@selector(hiddenView:) forControlEvents:UIControlEventTouchUpInside];
    [view11 addSubview:colseBtn];
    //分割线
    UILabel* line = [[UILabel alloc]initWithFrame:CGRectMake(0, 39, SCREEN_WIDTH-10, 0.5)];
    line.backgroundColor = [UIColor hexChangeFloat:@"d0d0d0"];
    [view11 addSubview:line];
    //显示
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 40, SCREEN_WIDTH-10, 0)];
    self.textView.backgroundColor = [UIColor whiteColor];
    self.textView.editable = NO;
    
    
    NSMutableAttributedString* attributeStr = [[NSMutableAttributedString alloc]initWithAttributedString:str];
    NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:4];
    [attributeStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, str.length)];
    [attributeStr addAttribute:NSFontAttributeName value:Default_Font_15 range:NSMakeRange(0, attributeStr.length)];
//    NSDictionary *attributes = @{NSFontAttributeName:Default_Font_15};
    [UIView animateWithDuration:0.3 animations:^{
        
        backControl.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.6];

        
        CGFloat textViewH = [attributeStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-10-10, 0) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
        context:nil].size.height;
        
//        NSLog(@"text = %f",textViewH);
//        if (textViewH > popViewHeight-60)
//        {
//            self.textView.frame = CGRectMake(5, 40, SCREEN_WIDTH-10-10, popViewHeight-60);
//            view11.frame = CGRectMake(5, (SCREEN_HEIGHT-popViewHeight)/2, SCREEN_WIDTH-10, popViewHeight);
//        }
//        else if (textViewH<120)
//        {
//            self.textView.frame = CGRectMake(5, 40, SCREEN_WIDTH-10-10, 120);
//            view11.frame = CGRectMake(5, (SCREEN_HEIGHT-180)/2, SCREEN_WIDTH-10, 180);
//        }
//        else
//        {
//            self.textView.frame = CGRectMake(5, 40, SCREEN_WIDTH-10-10, textViewH);
//            view11.frame = CGRectMake(5, (SCREEN_HEIGHT-textViewH-40-20)/2, SCREEN_WIDTH-10, textViewH+40+20);
//        }
        if (textViewH > popViewHeight-60)
        {
            self.textView.frame = CGRectMake(5, 40, SCREEN_WIDTH-10-15, popViewHeight-60);
            view11.frame = CGRectMake(5, (SCREEN_HEIGHT-popViewHeight)/2, SCREEN_WIDTH-10, popViewHeight);
        }else{
            self.textView.frame = CGRectMake(5, 40, SCREEN_WIDTH-10-15, 180);
            view11.frame = CGRectMake(5, (SCREEN_HEIGHT-240)/2, SCREEN_WIDTH-10, 240);
        }
        self.textView.attributedText = attributeStr;
        self.textView.font = [UIFont systemFontOfSize:15];
        self.textView.textColor = [UIColor hexChangeFloat:KBlackColor];
    }];
    [view11 addSubview:self.textView];
    [backControl addSubview:view11];
}

- (void)cgrectMakeTextView:(NSString *)str andTitleStr:(NSString*)titleStr;
{
    
    backControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    backControl.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.0];
    
    view11 = [[UIView alloc]initWithFrame:CGRectMake(5, SCREEN_HEIGHT, SCREEN_WIDTH-10, 100)];
    view11.backgroundColor = [UIColor whiteColor];
    view11.layer.cornerRadius = 5;
    view11.layer.masksToBounds = YES;
//    
//    [UIView animateWithDuration:0.3 animations:^{
//        
//        backControl.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.6];
//        view11.frame = CGRectMake(5,SCREEN_HEIGHT-220, SCREEN_WIDTH-10,220);
//    }];

    [backControl addTarget:self action:@selector(hiddenView:) forControlEvents:UIControlEventTouchUpInside];
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    [keyWindow addSubview:backControl];
    
    
    UILabel* Titlelabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-20, 39)];
    Titlelabel.text = titleStr;
    Titlelabel.font  = Default_Font_15;
    Titlelabel.textColor = [UIColor hexChangeFloat:KBlackColor];
    [view11 addSubview:Titlelabel];
    
    UIButton* colseBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-55, 0, 40, 40)];
    [colseBtn setImage:[UIImage imageNamed:@"Menu.png"] forState:UIControlStateNormal];
    [colseBtn addTarget:self action:@selector(hiddenView:) forControlEvents:UIControlEventTouchUpInside];
    //colseBtn.backgroundColor = [UIColor grayColor];
    [view11 addSubview:colseBtn];
    
    UILabel* line = [[UILabel alloc]initWithFrame:CGRectMake(0, 39, SCREEN_WIDTH-10, 0.5)];
    line.backgroundColor = [UIColor hexChangeFloat:@"d0d0d0"];
    [view11 addSubview:line];
    
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 40, SCREEN_WIDTH-10-15, 0)];
    self.textView.backgroundColor = [UIColor whiteColor];
    self.textView.editable = NO;
    [view11 addSubview:self.textView];
    
    [backControl addSubview:view11];
    
    NSMutableAttributedString* attributeStr;
    
    if (str && str !=nil ) {
        
        attributeStr = [[NSMutableAttributedString alloc]initWithString:str];
        NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        [paragraphStyle setLineSpacing:4];
        [attributeStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, str.length)];
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        
        backControl.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.6];
        
        CGFloat textViewH = [attributeStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-10-15, 0) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size.height;
        
        NSLog(@"text = %f",textViewH);
        
//        if (textViewH > popViewHeight-60)
//        {
//            self.textView.frame = CGRectMake(5, 40, SCREEN_WIDTH-10-15, popViewHeight-60);
//            view11.frame = CGRectMake(5, (SCREEN_HEIGHT-popViewHeight)/2, SCREEN_WIDTH-10, popViewHeight);
//        }
//        else if (textViewH<120)
//        {
//            self.textView.frame = CGRectMake(5, 40, SCREEN_WIDTH-10-15, 120+40);
//            view11.frame = CGRectMake(5, (SCREEN_HEIGHT-180-40)/2, SCREEN_WIDTH-10, 180+40);
//        }
//        else
//        {
//            self.textView.frame = CGRectMake(5, 40, SCREEN_WIDTH-10-15, textViewH+40);
//            view11.frame = CGRectMake(5, (SCREEN_HEIGHT-textViewH-60)/2, SCREEN_WIDTH-10, textViewH+60+40);
//            
//        }
        if (textViewH > popViewHeight-60)
        {
            self.textView.frame = CGRectMake(5, 40, SCREEN_WIDTH-10-15, popViewHeight-60);
            view11.frame = CGRectMake(5, (SCREEN_HEIGHT-popViewHeight)/2, SCREEN_WIDTH-10, popViewHeight);
        }else{
            self.textView.frame = CGRectMake(5, 40, SCREEN_WIDTH-10-15, 180);
            view11.frame = CGRectMake(5, (SCREEN_HEIGHT-240)/2, SCREEN_WIDTH-10, 240);
        }
        self.textView.attributedText = attributeStr;
        
        self.textView.font = [UIFont systemFontOfSize:15];
        self.textView.textColor = [UIColor hexChangeFloat:KBlackColor];
    }];
    
}


- (void)hiddenView:(UIControl *)control
{
  
//    [UIView animateWithDuration:0.3 animations:^{
//        backControl.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
//        
//        [backControl removeFromSuperview];
//    }];
    
    
    [UIView animateWithDuration:0.3 animations:^{
        control.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.0];
        view11.frame = CGRectMake(5, SCREEN_HEIGHT, SCREEN_WIDTH-10, 0);
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [backControl removeFromSuperview];
    });

}

//将字符串转日期
-(void)convertStringToDate:(NSString *)string
{
    
    
    
}


#pragma mark - 图片轮播期代理方法
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    //    NSMutableArray *photosArr = [NSMutableArray array];
    //    for(int i = 0 ; i < cycleScrollView.imageURLStringsGroup.count;i ++)
    //    {
    //        UIPhoto *photo = [[UIPhoto alloc]init];
    //        photo.url = [NSURL URLWithString:cycleScrollView.imageURLStringsGroup[i]];
    //        [photosArr addObject:photo];
    //    }
    //
    //    UIPhotoBrowser *browser = [[UIPhotoBrowser alloc]init];
    //    browser.delegate = self;
    //    browser.photos = photosArr;
    //    [browser setCurrentPhotoIndex:index];
    //    [browser photos];
    //    [browser show];
    
    PresentPicViewController* picVC = [[PresentPicViewController alloc]init];
    picVC.idStr = @"1";
    picVC.imageArrUrl = self.houseimageLinesURLs;
    picVC.imageTitleArr = self.houseimageLinestitles;
    [picVC setTransitioningDelegate:[TransitionsManager shared]];
    [self presentViewController:picVC animated:YES completion:nil];
    
}



//返回事件
- (IBAction)goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark--点击推荐按钮
- (void)click_Commend
{
    
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    if(![defaults boolForKey:@"SalesHelper_publicNotice"])
    {
        if ([defaults valueForKey:@"Login_User_token"] != nil)
        {
#if 0
            UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            RecommendViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"RecommendViewController"];
            NSMutableArray * arr = [NSMutableArray arrayWithObject:self.dict];
            vc.info = arr;
            [self.navigationController pushViewController:vc animated:YES];
#else
            if ([GetOrgType isEqualToString:@"2"])
            {
                RecommandBuildViewController* build = [[RecommandBuildViewController alloc]init];
                build.hidesBottomBarWhenPushed = YES;
                //            build.flatName = @{@"name":self.dict[@"name"]};
                NSMutableArray * arr = [NSMutableArray arrayWithObject:self.dict];
                build.info = arr;
                [self.navigationController pushViewController:build animated:YES];
            }else
            {
                [self.view makeToast:@"您无权限，请先绑定机构码" duration:1.0 position:@"center"];
            }
#endif
        }
        else
        {
            UINavigationController *mainNaVC = [[UINavigationController alloc] initWithRootViewController:[[LoginViewController alloc]init]];
            [self presentViewController:mainNaVC animated:YES completion:nil];
            //            LoginAndRegisterViewController *vc = [[LoginAndRegisterViewController alloc] init];
            //            [self presentViewController:vc animated:YES completion:nil];
        }
    }
    
}

//点击浏览图片
//- (void)click_imageScroll
//{
//    NSLog(@"点击了浏览图片");
//}

//-(void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    if (scrollView.contentOffset.y > 260)
//    {
//        _popView.hidden = NO;
//        _popView.frame = CGRectMake(0, self.view.height -50, self.view.width, 50);
//        bottomLayout.constant = 50;
//
//    }
//    else
//    {
//        _popView.hidden = YES;
//        _popView.frame = CGRectMake(0, self.view.height, self.view.width, 50);
//        bottomLayout.constant = 0;
//    }
//}


- (void)share:(id)sender
{
//    NSString *imagePath = [[NSBundle mainBundle] pathForResource:IMAGE_NAME ofType:IMAGE_EXT];
    
//    NSString *content_sms = [NSString stringWithFormat:@"（销邦）这是我的专用邀请码%@，成功下载填写邀请码，即得100元。地址:%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"zhipu_recomd_code"], @"http://d.xiaobang.cc"];
    
//    NSString *content_sms = [NSString stringWithFormat:@" [销邦]为伊销的人憔悴，纪人邦交只为谁。暗号：http://d.xiaobang.cc"];
//    NSArray *imageArray = @[[UIImage imageNamed:IMAGE_NAME]];
#if 0
    NSString * uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"loginuid"];
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"http://app.xiaobang.cc/index.php/Home/Building/newhouses/id/%@/uid/%@",self.ID,uid]];
    //    NSLog(@"%@",url);
    
    //    UIImageView * image = [[UIImageView alloc]init];
    //    [image sd_setImageWithURL:[NSURL URLWithString:self.peropertyImageUrls[0]] placeholderImage:[UIImage imageNamed:@""]];
    
    UIImageView * shareImg = [[UIImageView alloc]init];
    [shareImg sd_setImageWithURL:self.peropertyImageUrls[0] placeholderImage:[UIImage imageNamed:IMAGE_NAME]];
    UIImage * image = [self ImageWithImageSimple:shareImg.image ScaledToSize:CGSizeMake(shareImg.image.size.width/2, shareImg.image.size.height/2)];
    NSArray * imageArray = @[image];
    NSString * contentStr = [NSString stringWithFormat:@"%@",self.dict[@"name"]];
    
//    1、创建分享参数
            if (imageArray) {
    
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:contentStr
                                     images:imageArray
                                        url:url
                                      title:CONTENT_TITLE
                                       type:SSDKContentTypeAuto];
                NSArray *items = @[@(SSDKPlatformTypeSinaWeibo),@(SSDKPlatformSubTypeQZone),@(SSDKPlatformSubTypeWechatSession),@(SSDKPlatformSubTypeWechatTimeline),@(SSDKPlatformSubTypeQQFriend)];
                UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
                view.backgroundColor = [UIColor redColor];
    //2、分享（可以弹出我们的分享菜单和编辑界面）
    [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                             items:items
                       shareParams:shareParams
               onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                   
                   //针对新浪微博分享键盘不收起
                   [[UIApplication sharedApplication].keyWindow endEditing:YES];
                   
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

#else
    
    NSMutableArray *imageArray = [NSMutableArray array];
    UIImageView * shareImg = [[UIImageView alloc]init];
    [shareImg sd_setImageWithURL:self.peropertyImageUrls[0] placeholderImage:[UIImage imageNamed:IMAGE_NAME]];
    UIImage * image = [self ImageWithImageSimple:shareImg.image ScaledToSize:CGSizeMake(shareImg.image.size.width/2, shareImg.image.size.height/2)];
    [imageArray addObject:image];
    NSString * uidStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"id"];
    NSString * content = [NSString stringWithFormat:@"%@",self.dict[@"name"]];
    NSString * url = [NSString stringWithFormat:@"http://app.xiaobang.cc/index.php/Home/Building/newhouses/id/%@/uid/%@",self.ID,uidStr];
    
    //分享视图所需参数
    NSDictionary *shareDic = @{@"url":url,
                               @"imageArr":imageArray,
                               @"title":CONTENT_TITLE,
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
#endif
    
}



- (void)availableMapsApps {
    [self.availableMaps removeAllObjects];
    
    NSString *toName = self.titlestr;
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://map/"]])
    {
        NSString *urlString = [NSString stringWithFormat:@"baidumap://map/geocoder?address=%@&src=智朴科技|销邦",toName];
        
        NSDictionary *dic = @{@"name": @"百度地图",
                              @"url": urlString};
        [self.availableMaps addObject:dic];
    }
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]])
    {
        NSString *urlString = [NSString stringWithFormat:@"iosamap://poi?sourceApplication=applicationName&name=%@&lat1=&lon1=&lat2=&lon2=&dev=0",toName];
        
        NSDictionary *dic = @{@"name": @"高德地图",
                              @"url": urlString};
        [self.availableMaps addObject:dic];
    }
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]])
    {
        NSString *urlString = [NSString stringWithFormat:@""];
        
        NSDictionary *dic = @{@"name": @"Google Maps",
                              @"url": urlString};
        [self.availableMaps addObject:dic];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString * location = [defaults objectForKey:@"Login_User_currentLocationCity"];
        
        NSString * str =[NSString stringWithFormat:@"http://maps.apple.com/?q=%@near=%@",self.titlestr,location];
        str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:str]];
        
    }
    else if (buttonIndex < self.availableMaps.count+1)
    {
        NSDictionary *mapDic = self.availableMaps[buttonIndex-1];
        NSString *urlString = mapDic[@"url"];
        urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:urlString];
        [[UIApplication sharedApplication] openURL:url];
    }
}




- (float) heightForString:(NSAttributedString *)htmlStr
{
    CGSize sizeToLabel = [htmlStr boundingRectWithSize:CGSizeMake(self.view.width - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
    
    return sizeToLabel.height;
}

#pragma mark --设置分割线的偏移量
//将列表的分割线从头开始
//最新的，简便些
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 0)];
    }
    
    
    if (IOS_VERSION >= 8.0) {
        if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)])
        {
            [cell setPreservesSuperviewLayoutMargins:NO];
        }
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsMake(0, 10, 0, 0)];
        }
    }
}
//压缩图片
-(UIImage*)ImageWithImageSimple:(UIImage*)image ScaledToSize:(CGSize)newSize{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}
//- (void)viewOnWillDisplay:(UIViewController *)viewController shareType:(ShareType)shareType
//{
//    if (IOS_VERSION >= 7.0)
//    {
//        viewController.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:23/255.0f green:183/255.0f blue:242/255.0f alpha:1.000];
//    }
//    else
//    {
//        viewController.navigationController.navigationBar.tintColor = LeftMenuVCBackColor;
//    }
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
