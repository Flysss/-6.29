//
//  TwohandDetailViewController.m
//  SalesHelper_A
//
//  Created by Brant on 16/1/6.
//  Copyright (c) 2016年 X. All rights reserved.
//

#import "TwohandDetailViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import "SDCycleScrollView.h"
#import <MessageUI/MessageUI.h>
#import "LocationViewController.h"
#import "PropertyDetailViewController.h"

#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>//引入云检索功能所有的头文件
#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入计算工具所有的头文件
#import <BaiduMapAPI_Radar/BMKRadarComponent.h>//引入周边雷达功能所有的头文件
#import "SCLAlertView.h"
#import "UIImage+Rotate.h"
#import "ZJShareView.h"


#define MYBUNDLE_NAME @"mapapi.bundle"
#define MYBUNDLE_PATH [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: MYBUNDLE_NAME]
#define MYBUNDLE [NSBundle bundleWithPath: MYBUNDLE_PATH]


@interface TwohandDetailViewController () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate,  SDCycleScrollViewDelegate
,BMKMapViewDelegate,BMKLocationServiceDelegate,BMKRouteSearchDelegate, MFMessageComposeViewControllerDelegate>

@property (nonatomic, strong) UITableView *m_tableView;
@property (nonatomic, strong) NSDictionary *dataDic;
@property (nonatomic, strong) BMKMapView *m_mapView;
@end

@implementation TwohandDetailViewController
{
    SDCycleScrollView *cycleScrollView;
//    BMKMapView *m_mapView;
//    CLLocationCoordinate2D  end;
//    BMKLocationService * _locService;
    NSInteger scrollHeight;
    UIView* mapBackView;
    
    CGFloat topHeight;
    BMKPointAnnotation* annotation;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [_m_mapView viewWillAppear];
    _m_mapView.delegate = self;
//    _locService.delegate = self;
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [_m_mapView viewWillDisappear];
    _m_mapView.delegate = nil;
//    _locService.delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.view.backgroundColor = [UIColor hexChangeFloat:@"d0d0d0"];
    
    [self CreateCustomNavigtionBarWith:self leftItem:@selector(backToView) rightItem:@selector(share:)];
    //创建标题
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-120)/2, 27, 120, 30)];
    titleLabel.text = @"详情";
    titleLabel.font = Default_Font_20;
    [titleLabel setTextColor:[UIColor whiteColor]];
    //    [titleLabel sizeToFit];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.topView addSubview: titleLabel];
    [self.rightBtn setImage:[UIImage imageNamed:@"首页-分享.png"] forState:UIControlStateNormal];
    [self.rightBtn setImage:[UIImage imageByApplyingAlpha:[UIImage imageNamed:@"首页-分享.png"]] forState:UIControlStateHighlighted];
    self.rightBtn.tintColor = [UIColor whiteColor];
    
    self.dataDic = [NSDictionary dictionary];
    
    if (SCREEN_WIDTH == 320 ) {
        scrollHeight = 200;
    } else if (SCREEN_WIDTH == 375) {
        scrollHeight = 245;
    } else {
        scrollHeight = 300;
    }
    
    //设置弹出框的高度
    if (SCREEN_HEIGHT == 480) {
        topHeight = 320;
    }else if (SCREEN_HEIGHT == 568)
    {
        topHeight = 400;
    }else if (SCREEN_HEIGHT == 667)
    {
        topHeight = 450;
    }else{
        topHeight = 500;
    }

    
//    [self creatnaviControl];
    
    [self creatTableView];
    
    [self requestData:self.strId];
    
}


//返回上一页
- (void)backToView
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --分享
- (void)share:(id)sender
{
    
    
    NSMutableArray *imageArray = [NSMutableArray array];
    [imageArray addObject:[UIImage imageNamed:IMAGE_NAME]];
    
    NSString * content = [NSString stringWithFormat:@" [销邦]为伊销的人憔悴，纪人邦交只为谁。暗号:"];
    NSString * url = [NSString stringWithFormat:@"http://d.xiaobang.cc"];
    
    //分享视图所需参数
    NSDictionary *shareDic = @{@"url":url,
                               @"imageArr":imageArray,
                               @"title":@"",
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

    
//    NSString *imagePath = [[NSBundle mainBundle] pathForResource:IMAGE_NAME ofType:IMAGE_EXT];
    
//    NSString *content_sms = [NSString stringWithFormat:@"（销邦）这是我的专用邀请码%@，成功下载填写邀请码，即得100元。地址:%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"zhipu_recomd_code"],@"http://d.xiaobang.cc"];

//    NSString *content_sms = [NSString stringWithFormat:@" [销邦]为伊销的人憔悴，纪人邦交只为谁。暗号：http://d.xiaobang.cc"];
//    
//    NSArray *imageArray = @[[UIImage imageNamed:IMAGE_NAME]];
//    //1、创建分享参数
//            if (imageArray) {
//    
//    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
//    [shareParams SSDKSetupShareParamsByText:content_sms
//                                     images:imageArray
//                                        url:[NSURL URLWithString:@"http://d.xiaobang.cc"]
//                                      title:CONTENT_TITLE
//                                       type:SSDKContentTypeAuto];
//                NSArray *items = @[@(SSDKPlatformTypeSinaWeibo),@(SSDKPlatformSubTypeQZone),@(SSDKPlatformSubTypeWechatSession),@(SSDKPlatformSubTypeWechatTimeline),@(SSDKPlatformSubTypeQQFriend)];
//    //2、分享（可以弹出我们的分享菜单和编辑界面）
//    [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
//                             items:items
//                       shareParams:shareParams
//               onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
//                   
//                   switch (state) {
//                       case SSDKResponseStateSuccess:
//                       {
//                           UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
//                                                                               message:nil
//                                                                              delegate:nil
//                                                                     cancelButtonTitle:@"确定"
//                                                                     otherButtonTitles:nil];
//                           [alertView show];
//                           break;
//                       }
//                       case SSDKResponseStateFail:
//                       {
//                           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
//                                                                           message:[NSString stringWithFormat:@"%@",error]
//                                                                          delegate:nil
//                                                                 cancelButtonTitle:@"OK"
//                                                                 otherButtonTitles:nil, nil];
//                           NSLog(@"----%@",error);
//                           [alert show];
//                           break;
//                       }
//                       default:
//                           break;
//                   }
//               }
//     ];
//        }

    
}

#pragma mark --创建列表
- (void)creatTableView
{
    self.m_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,64, SCREEN_WIDTH, SCREEN_HEIGHT-64-50) style:UITableViewStyleGrouped];
    self.m_tableView.delegate = self;
    self.m_tableView.dataSource = self;
    self.m_tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.m_tableView];
    
    //顶部轮播图
    cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0,64, SCREEN_WIDTH, scrollHeight) imagesGroup:@[[UIImage imageNamed:@"top_bg.png"]]];
    self.m_tableView.tableHeaderView = cycleScrollView;
}

//请求数据
- (void)requestData:(NSString *)hId
{
    NSDictionary *dic = @{@"id":hId};
    RequestInterface *interFace = [[RequestInterface alloc] init];
    [self.view Loading_0314];
    [interFace requestTwohandDetailWithDic:dic];
    [interFace getInterfaceRequestObject:^(id data) {
        [self.view Hidden];
        
        if (data[@"success"])
        {
            self.dataDic = data[@"datas"];
            
            NSLog(@"二手房%@",self.dataDic);
            if (self.dataDic[@"images"] != nil &&
                self.dataDic[@"images"] != [NSNull null] &&
                [self.dataDic[@"images"] count] >0
                )
            {
                NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
                
                for (int i = 0; i< [self.dataDic[@"images"] count]; i++)
                {
                    [array addObject:self.dataDic[@"images"][i][@"imgsm"]];
                }
                
                [cycleScrollView removeFromSuperview];
                cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, scrollHeight) imageURLStringsGroup:array];
//                 cycleScrollView.placeholderImage = [UIImage imageNamed:@"top_bg.png"];
                if([self.dataDic[@"images"] count] == 1)
                {
                    cycleScrollView.autoScroll = NO;
                    cycleScrollView.showPageControl = NO;
                }
                
                cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
                cycleScrollView.delegate = self;
                cycleScrollView.dotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
                cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
               
                cycleScrollView.autoScrollTimeInterval = 3.0;
                self.m_tableView.tableHeaderView = cycleScrollView;
            }
            
        } else {
            [self.view makeToast:data[@"message"]];
        }
        
        [self.m_tableView reloadData];
        [self creatBottomView];
        
    } Fail:^(NSError *error) {
        [self.view Hidden];
        [self.view makeToast:@"网络错误"];
    }];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"%@", indexPath]];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    if (indexPath.section == 0)
    {
        
        if (indexPath.row == 0)
        {
            NSString *string = self.dataDic[@"topic"];
            
            CGFloat titleH = [string boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-20, 0) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:Default_Font_20} context:nil].size.height;
            
            UILabel *titleLabel = [[UILabel alloc] init];
            if (titleH > 25)
            {
                titleLabel.frame = CGRectMake(10, 12, SCREEN_WIDTH-20, 50);
            }
            else
            {
                titleLabel.frame = CGRectMake(10, 5, SCREEN_WIDTH-20, 25);
            }
            titleLabel.text = string;
            titleLabel.textColor = [UIColor hexChangeFloat:KBlackColor];
            titleLabel.font = Default_Font_20;
            titleLabel.numberOfLines = 2;
            [cell.contentView addSubview:titleLabel];
            
            //浏览次数
            UILabel * browseCount = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-120, 20, 110, 15)];
            
            if (self.dataDic[@"clickcounts"] != nil &&
                self.dataDic[@"clickcounts"] != [NSNull null] &&
                self.dataDic[@"clickcounts"])
            {
                browseCount.text =[NSString stringWithFormat:@"已被浏览%@次",self.dataDic[@"clickcounts"]];//@"1000人看过";
            }
            browseCount.textColor = [UIColor hexChangeFloat:KQianheiColor];
            browseCount.font = Default_Font_12;
            browseCount.textAlignment = NSTextAlignmentRight;
            [cell.contentView addSubview:browseCount];
            
            
            NSArray *strarrray = self.dataDic[@"tages"];
            CGFloat lablew;
            lablew = 0;
            //类别
            if (strarrray.count >0)
            {
                for (int i = 0; i < strarrray.count; i++)
                {
                    CGFloat labelwww = [strarrray[i][@"name"] boundingRectWithSize:CGSizeMake(0, 15) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:Default_Font_12} context:nil].size.width;
                    
                    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5+lablew+4, CGRectGetMaxY(titleLabel.frame)+5, labelwww+5, 15)];
                    label.text = strarrray[i][@"name"];
                    label.textAlignment = NSTextAlignmentCenter;
                    label.font = Default_Font_12;
                    label.layer.cornerRadius = 5;
                    label.layer.masksToBounds = YES;
                    label.layer.borderWidth = 0.5;
                    if (strarrray[i][@"color"] != nil &&
                        strarrray[i][@"color"] != [NSNull null] &&
                        strarrray[i][@"color"]
                        )
                    {
                        label.layer.borderColor = [UIColor hexChangeFloat:strarrray[i][@"color"]].CGColor;
                        label.textColor = [UIColor hexChangeFloat:strarrray[i][@"color"]];
                    }
                    [cell.contentView addSubview:label];
                    lablew = labelwww+5 + lablew+4;
                }
            }
            UILabel * addTimeLab = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(titleLabel.frame)+25, 160, 15)];
            addTimeLab.font = Default_Font_11;
            addTimeLab.textColor = [UIColor hexChangeFloat:KQianheiColor];
            [cell.contentView addSubview:addTimeLab];
            
            if (self.dataDic[@"addtime"] != nil &&
                self.dataDic[@"addtime"] != [NSNull null] &&
                self.dataDic[@"addtime"])
            {
            NSString * timeStr = self.dataDic[@"addtime"];
            NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"YYYY年MM月dd日"];
            NSTimeZone * zone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
            [formatter setTimeZone:zone];
            NSDate * addDate = [NSDate dateWithTimeIntervalSince1970:[timeStr integerValue]];
            NSString * addStr = [formatter stringFromDate:addDate];
            addTimeLab.text = [NSString stringWithFormat:@"发布时间:%@",addStr];
            }
        }
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, SCREEN_WIDTH/3, 20)];
            label1.text = @"售价";
            label1.textColor = [UIColor hexChangeFloat:KGrayColor];
            label1.textAlignment = NSTextAlignmentCenter;
            label1.font = Default_Font_15;
            [cell.contentView addSubview:label1];
            
            UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/3, 15, SCREEN_WIDTH/3, 20)];
            label2.text = @"户型";
            label2.textColor = [UIColor hexChangeFloat:KGrayColor];
            label2.font = Default_Font_15;
            label2.textAlignment = NSTextAlignmentCenter;
            [cell.contentView addSubview:label2];
            
            UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*2/3, 15, SCREEN_WIDTH/3, 20)];
            label3.text = @"面积";
            label3.textColor = [UIColor hexChangeFloat:KGrayColor];
            label3.font = Default_Font_15;
            label3.textAlignment = NSTextAlignmentCenter;
            [cell.contentView addSubview:label3];
            
            UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(label1.frame)+10, SCREEN_WIDTH/3, 25)];
            if (self.dataDic[@"price"] != nil &&
                self.dataDic[@"price"] != [NSNull null] &&
                self.dataDic[@"price"])
            {
                label4.text = [NSString stringWithFormat:@"%@万", self.dataDic[@"price"]];

            }
            label4.textColor = [UIColor hexChangeFloat:@"ff4c51"];
            label4.font = Default_Font_18;
            label4.textAlignment = NSTextAlignmentCenter;
            [cell.contentView addSubview:label4];
            
            UILabel *label5 = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/3, CGRectGetMaxY(label1.frame)+10, SCREEN_WIDTH/3, 25)];
            
            label5.textColor = [UIColor hexChangeFloat:@"ff4c51"];
            label5.font = Default_Font_18;
            label5.textAlignment = NSTextAlignmentCenter;
            if (self.dataDic[@"shi"] != nil &&
                self.dataDic[@"shi"] != [NSNull null] &&
                self.dataDic[@"shi"])
            {
                label5.text = [NSString stringWithFormat:@"%@室%@厅%@卫", self.dataDic[@"shi"],self.dataDic[@"ting"],self.dataDic[@"wei"]];
            }
            [cell.contentView addSubview:label5];
            
            UILabel *label6 = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/3*2, CGRectGetMaxY(label1.frame)+10, SCREEN_WIDTH/3, 25)];
            label6.textColor = [UIColor hexChangeFloat:@"ff4c51"];
            label6.font = Default_Font_18;
            label6.textAlignment = NSTextAlignmentCenter;
            if (self.dataDic[@"mianji"] != nil &&
                self.dataDic[@"mianji"] != [NSNull null] &&
                self.dataDic[@"mianji"])
            {
                label6.text = [NSString stringWithFormat:@"%@㎡", self.dataDic[@"mianji"]];
            }
            [cell.contentView addSubview:label6];
            
            
            for (int i = 1; i < 3; i++)
            {
                UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/3*i, 15, 0.5, 55)];
                lineLabel.backgroundColor = [UIColor hexChangeFloat:@"d0d0d0"];
                [cell.contentView addSubview:lineLabel];
            }
        }
        
    }
    else if (indexPath.section == 2)
    {
        NSString *str1;
        NSString *str2;
        NSString *str3;
        NSString *str4;
        NSString *str5;
        NSString *str6;
        //单价
        if (self.dataDic[@"danjia"] != nil &&
            self.dataDic[@"danjia"] != [NSNull null] &&
            self.dataDic[@"danjia"])
        {
            str1 = [NSString stringWithFormat:@"单价: %@/㎡", self.dataDic[@"danjia"]];
        } else {
            str1 = @"单价: ";
        }
        
        //装修
        if (self.dataDic[@"zhuangxiu"] != nil &&
            self.dataDic[@"zhuangxiu"] != [NSNull null] &&
            self.dataDic[@"zhuangxiu"])
        {
            str2 = [NSString stringWithFormat:@"装修: %@", self.dataDic[@"zhuangxiu"]];
        } else {
            str2 = @"装修: ";
        }
            
        
        if (self.dataDic[@"cengZong"] != nil &&
            self.dataDic[@"cengZong"] != [NSNull null] &&
            self.dataDic[@"cengZong"])
        {
            str3 = [NSString stringWithFormat:@"楼层: %@/%@", self.dataDic[@"cengIs"], self.dataDic[@"cengZong"]];
        } else {
            str3 = @"楼层: ";
        }
        
        if (self.dataDic[@"chanquan"] != nil &&
            self.dataDic[@"chanquan"] != [NSNull null] &&
            self.dataDic[@"chanquan"])
        {
            str4 = [NSString stringWithFormat:@"产权: %@", self.dataDic[@"chanquan"]];
        } else {
            str4 = @"产权: ";
        }
        if (self.dataDic[@"chaoxiang"] != nil &&
            self.dataDic[@"chaoxiang"] != [NSNull null] &&
            self.dataDic[@"chaoxiang"])
        {
            str5 = [NSString stringWithFormat:@"朝向: %@", self.dataDic[@"chaoxiang"]];
        } else {
            str5 = @"朝向: ";
        }
        
        if (self.dataDic[@"jiegou"] != nil &&
            self.dataDic[@"jiegou"] != [NSNull null] &&
            self.dataDic[@"jiegou"])
        {
            str6 = [NSString stringWithFormat:@"结构: %@", self.dataDic[@"jiegou"]];
        } else {
            str6 = @"结构: ";
        }
        
        
        NSArray *arry = @[str1, str2, str3, str4, str5, str6];
        if (indexPath.row == 0)
        {
            UILabel *titeleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45)];
            titeleLabel.text = @"房源描述";
            titeleLabel.textAlignment = NSTextAlignmentCenter;
            titeleLabel.textColor = [UIColor hexChangeFloat:KBlackColor];
            titeleLabel.font = Default_Font_16;
            [cell.contentView addSubview:titeleLabel];
            
            UILabel *lineLab1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 44.5, 10, 0.5)];
            lineLab1.backgroundColor = [UIColor hexChangeFloat:@"d0d0d0"];
            [cell.contentView addSubview:lineLab1];
        }
        else
        {
            for (int i = 0; i<arry.count; i++)
            {
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10+(SCREEN_WIDTH-20)/2*(i%2), (i/2)*45, (SCREEN_WIDTH-20)/2, 45)];
                label.text = arry[i];
                label.font = Default_Font_15;
                label.textColor = [UIColor hexChangeFloat:KBlackColor];
                [cell.contentView addSubview:label];
            }
            
            if (self.dataDic[@"isShangQuanname"] != nil &&
                self.dataDic[@"isShangQuanname"] != [NSNull null] &&
                self.dataDic[@"isShangQuanname"])
            {
            UILabel * tradeArea = [[UILabel alloc]initWithFrame:CGRectMake(10, 45*3, SCREEN_WIDTH-20, 45)];
            tradeArea.textColor = [UIColor hexChangeFloat:KBlackColor];
            tradeArea.font = Default_Font_15;
            
                tradeArea.text = [NSString stringWithFormat:@"商圈: %@", self.dataDic[@"isShangQuanname"]];
                [cell.contentView addSubview:tradeArea];
            }
            CGFloat maxY = (self.dataDic[@"isShangQuanname"] != nil &&
                            self.dataDic[@"isShangQuanname"] != [NSNull null] &&
                            self.dataDic[@"isShangQuanname"]) ? 45*4:45*3;
            //位置
            UILabel *locationLable = [[UILabel alloc] initWithFrame:CGRectMake(10, maxY, SCREEN_WIDTH-20, 45)];
            locationLable.font = Default_Font_15;
            locationLable.textColor = [UIColor hexChangeFloat:KBlackColor];
            if (self.dataDic[@"weizhi"] != nil &&
                self.dataDic[@"weizhi"] != [NSNull null] &&
                self.dataDic[@"weizhi"])
            {
                locationLable.text = [NSString stringWithFormat:@"位置: %@", self.dataDic[@"weizhi"]];
            } else {
                locationLable.text = @"位置: ";
            }
            [cell.contentView addSubview:locationLable];
            UILabel *lineLab1 = [[UILabel alloc] initWithFrame:CGRectMake(10,maxY+44.5,SCREEN_WIDTH-20, 0.5)];
            lineLab1.backgroundColor = [UIColor hexChangeFloat:@"d0d0d0"];
            [cell.contentView addSubview:lineLab1];

            
            //描述
            UILabel *miaoshuLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(locationLable.frame), SCREEN_WIDTH-20, 45)];
            miaoshuLabel.textColor = [UIColor hexChangeFloat:KBlackColor];
            miaoshuLabel.text = self.dataDic[@"miaoshu"];
            miaoshuLabel.numberOfLines = 2;
            miaoshuLabel.font = Default_Font_15;
            [cell.contentView addSubview:miaoshuLabel];
            
            //全部按钮
            UIButton *checkButton = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-100)/2, CGRectGetMaxY(miaoshuLabel.frame)+5, 100, 35)];
            [checkButton setTitle:@"全 部" forState:UIControlStateNormal];
            [checkButton setTitleColor:[UIColor hexChangeFloat:KBlueColor] forState:UIControlStateNormal];
            checkButton.layer.cornerRadius = 5;
            checkButton.layer.masksToBounds = YES;
            checkButton.layer.borderColor = [UIColor hexChangeFloat:KBlueColor].CGColor;
            checkButton.layer.borderWidth = 1;
            
            [checkButton addTarget:self action:@selector(chectAll) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:checkButton];
            
            
            for (int i = 1; i<5; i++)
            {
                UILabel *lineLab = [[UILabel alloc] initWithFrame:CGRectMake(10, i*45, SCREEN_WIDTH-20, 0.5)];
                lineLab.backgroundColor = [UIColor hexChangeFloat:@"d1d1d1"];
                [cell.contentView addSubview:lineLab];
            }
        }
    }
    else if (indexPath.section == 3)
    {
        if (indexPath.row == 0)
        {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45)];
            label.text = @"位置";
            label.font = Default_Font_15;
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = [UIColor hexChangeFloat:KBlackColor];
            [cell.contentView addSubview:label];
            
            UILabel *lineLab1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 44.5, SCREEN_WIDTH, 0.5)];
            lineLab1.backgroundColor = [UIColor hexChangeFloat:@"d1d1d1"];
            [cell.contentView addSubview:lineLab1];
        }
#pragma mark --地图
        else if (indexPath.row == 1)
        {
            //地图
            if (!mapBackView) {
                mapBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 240)];
                _m_mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 240)];
                _m_mapView.delegate = self;
                [mapBackView addSubview:_m_mapView];
                
                
                //检索
                _m_mapView.showsUserLocation = NO;//先关闭显示的定位图层
                _m_mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
                _m_mapView.showsUserLocation = YES;//显示定位图层
                _m_mapView.isSelectedAnnotationViewFront = YES;
                
                annotation = [[BMKPointAnnotation alloc] init];
                [_m_mapView addAnnotation:annotation];
                
                
            }
            
            if (self.dataDic[@"x"] != nil &&
                self.dataDic[@"x"] != [NSNull null] &&
                self.dataDic[@"x"])
            {
                NSDictionary *location2D = @{
                                             @"x":[self.dataDic objectForKey:@"x"],
                                             @"y":[self.dataDic objectForKey:@"y"],
                                             };
                CLLocationCoordinate2D myProperty2D = CLLocationCoordinate2DMake([location2D[@"x"] doubleValue], [location2D[@"y"] doubleValue]);
                _m_mapView.centerCoordinate = myProperty2D;
                _m_mapView.zoomLevel = 16;
                
                annotation.coordinate = myProperty2D;
                //                end = myProperty2D;
                
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
            
            UILabel *lineLab1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 240-0.5, SCREEN_WIDTH, 0.5)];
            lineLab1.backgroundColor = [UIColor hexChangeFloat:@"d1d1d1"];
            [cell.contentView addSubview:lineLab1];
        }
        else
        {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 12, SCREEN_WIDTH-20, 20)];
            label.text = self.dataDic[@"plot"];
            label.font = Default_Font_15;
            label.textColor = [UIColor hexChangeFloat:KBlackColor];
            [cell.contentView addSubview:label];
            
            UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(label.frame)+8, SCREEN_WIDTH-20, 20)];
            label1.text = self.dataDic[@"weizhi"];
            label1.font = Default_Font_15;
            label1.textColor = [UIColor hexChangeFloat:KGrayColor];
            [cell.contentView addSubview:label1];
        }
    }
    else
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 12, SCREEN_WIDTH, 20)];
        label.textColor = [UIColor hexChangeFloat:KBlackColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = Default_Font_15;
        label.text = @"附近房源";
        [cell.contentView addSubview:label];
        
        NSArray *imageArray = self.dataDic[@"vpibs"];
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(label.frame)+12, SCREEN_WIDTH, 130)];
        scrollView.contentSize = CGSizeMake(imageArray.count * 144 +10, 130);
        scrollView.pagingEnabled = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        [cell.contentView addSubview:scrollView];
        
        for (int i = 0; i < imageArray.count; i++)
        {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10 + 144*i, 0, 134, 100)];
            [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", imageArray[i][@"imageUrl"]]] placeholderImage:[UIImage imageNamed:@"pp_bg"]];
            [scrollView addSubview:imageView];
            
            UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 100-24, 134, 24)];
            priceLabel.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.7];
            priceLabel.text = [NSString stringWithFormat:@" %@/㎡", imageArray[i][@"price"]];
            priceLabel.textColor = [UIColor whiteColor];
            priceLabel.font = Default_Font_14;
            [imageView addSubview:priceLabel];
            
            UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 + 144*i, CGRectGetMaxY(imageView.frame)+10, 134, 20)];
            contentLabel.textColor = [UIColor hexChangeFloat:KBlackColor];
            contentLabel.font = Default_Font_14;
            contentLabel.text = imageArray[i][@"name"];
            [scrollView addSubview:contentLabel];
            
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(10 + 144*i, 0, 134, 100)];
            button.backgroundColor = [UIColor clearColor];
            button.tag = [imageArray[i][@"id"] integerValue];
           
            [button setTitle:imageArray[i][@"name"] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
            
            [button addTarget:self action:@selector(pushToDetail:) forControlEvents:UIControlEventTouchUpInside];
            [scrollView addSubview:button];
        }
    }
    return cell;
}

//检查所有房源描述
- (void)chectAll
{
    NSString *string = self.dataDic[@"miaoshu"];
    [self cgrectTextView:string andTitleStr:@"房源描述"];
}

#pragma mark --查看全部弹出框
- (void)cgrectTextView:(NSString *)str andTitleStr:(NSString*)titleStr;
{
    
    backControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    backControl.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.0];
    
    m_view = [[UIView alloc]initWithFrame:CGRectMake(5, SCREEN_HEIGHT, SCREEN_WIDTH-10, 100)];
    m_view.backgroundColor = [UIColor whiteColor];
    m_view.layer.cornerRadius = 5;
    m_view.layer.masksToBounds = YES;

    [backControl addTarget:self action:@selector(hiddenView:) forControlEvents:UIControlEventTouchUpInside];
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    [keyWindow addSubview:backControl];
    
    
    UILabel* Titlelabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-20, 39)];
    Titlelabel.text = titleStr;
    Titlelabel.font  = Default_Font_15;
    Titlelabel.textColor = [UIColor hexChangeFloat:KBlackColor];
    [m_view addSubview:Titlelabel];
    
    UIButton* colseBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-40, 10, 20, 20)];
    [colseBtn setImage:[UIImage imageNamed:@"Menu.png"] forState:UIControlStateNormal];
    [colseBtn addTarget:self action:@selector(hiddenView:) forControlEvents:UIControlEventTouchUpInside];
    [m_view addSubview:colseBtn];
    
    UILabel* line = [[UILabel alloc]initWithFrame:CGRectMake(0, 39, SCREEN_WIDTH-10, 0.5)];
    line.backgroundColor = [UIColor hexChangeFloat:@"d0d0d0"];
    [m_view addSubview:line];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 40, SCREEN_WIDTH-10, 0)];
    textView.backgroundColor = [UIColor whiteColor];
    textView.editable = NO;
    [m_view addSubview:textView];
    
    [backControl addSubview:m_view];
    
    NSMutableAttributedString* attributeStr = [[NSMutableAttributedString alloc]initWithString:str];
    NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:4];
    [attributeStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, str.length)];

    CGFloat textViewH = [str boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-10, MAXFLOAT) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:Default_Font_15} context:nil].size.height;
    
    [UIView animateWithDuration:0.3 animations:^{
        backControl.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.6];
        
        if (textViewH > topHeight-60)
        {
            
            textView.frame = CGRectMake(5, 40, SCREEN_WIDTH-10-10, topHeight-60);
            m_view.frame = CGRectMake(5, (SCREEN_HEIGHT-340)/2, SCREEN_WIDTH-10, topHeight);
        }
        else if (textViewH<100)
        {
            textView.frame = CGRectMake(5, 40, SCREEN_WIDTH-10-10, 100);
            m_view.frame = CGRectMake(5, (SCREEN_HEIGHT-160)/2, SCREEN_WIDTH-10, 160);
        }
        else
        {
            textView.frame = CGRectMake(5, 40, SCREEN_WIDTH-10-10, textViewH);
            m_view.frame = CGRectMake(5, (SCREEN_HEIGHT-textViewH-40)/2, SCREEN_WIDTH-10, textViewH+40+20);
            
        }
        
    }];
    textView.attributedText = attributeStr;
    textView.font = [UIFont systemFontOfSize:15];
    textView.textColor = [UIColor hexChangeFloat:KBlackColor];
    //[textView sizeToFit];
}

//- (void)hiddenView:(UIControl *)control
//{
//    
//    [UIView animateWithDuration:0.3 animations:^{
//        backControl.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
//        
//        [backControl removeFromSuperview];
//    }];
//}

- (void)hiddenView:(UIControl *)control
{
    [UIView animateWithDuration:0.3 animations:^{
        control.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.0];
        m_view.frame = CGRectMake(5, SCREEN_HEIGHT, SCREEN_WIDTH-10, 0);
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [backControl removeFromSuperview];
    });
}

//
- (void)pushToDetail:(UIButton *)sender
{
    NSLog(@"%ld", (long)sender.tag);
    
    PropertyDetailViewController *vc = [[PropertyDetailViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    
    vc.ID = [NSString stringWithFormat:@"%ld", (long)sender.tag];
    vc.titlestr = sender.titleLabel.text;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark --跳转到地图页面
- (void)pushToMap
{
    LocationViewController * location = [[LocationViewController alloc] init];
    location.locationName = self.dataDic[@"topic"];
    location.locationRoadName = [self.dataDic objectForKey:@"address"];
//    
    if ([self.dataDic objectForKey:@"x"] != nil &&
        [self.dataDic objectForKey:@"y"] != nil &&
        [self.dataDic objectForKey:@"x"] != [NSNull null] &&
        [self.dataDic objectForKey:@"y"] != [NSNull null] &&
        ![[self.dataDic objectForKey:@"x"] isEqualToString: @""] &&
        ![[self.dataDic objectForKey:@"y"] isEqualToString: @""]
        )
    {
        location.location2D = @{
                                @"x":[self.dataDic objectForKey:@"x"],
                                @"y":[self.dataDic objectForKey:@"y"],
                                };
        [self.navigationController pushViewController:location animated:YES];
    }
}

#pragma mark --创建底部试图
- (void)creatBottomView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50)];
    view.backgroundColor = [UIColor hexChangeFloat:KBlueColor];
    [self.view addSubview:view];
    
    //姓名
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 6, 100, 15)];
    nameLabel.font = Default_Font_15;
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.text = self.dataDic[@"name"];
    [view addSubview:nameLabel];
    
    //电话
    UILabel *phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(nameLabel.frame)+8, 120, 15)];
    phoneLabel.font = Default_Font_15;
    phoneLabel.textColor = [UIColor whiteColor];
    [view addSubview:phoneLabel];
    
    //电话按钮
    UIButton *phoneButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-118, 5, 40, 40)];
    [phoneButton setBackgroundImage:[UIImage imageNamed:@"二手房_电话"] forState:UIControlStateNormal];
    [phoneButton addTarget:self action:@selector(clickPhone) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:phoneButton];
    
    //短信按钮
    UIButton *messageButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-65+12, 5, 40, 40)];
    [messageButton setBackgroundImage:[UIImage imageNamed:@"二手房_短信"] forState:UIControlStateNormal];
    [messageButton addTarget:self action:@selector(clickMessage) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:messageButton];
    
    NSString * startStr = [self.dataDic[@"phone"] substringWithRange:NSMakeRange(0, 3)];
    NSString * endStr = [self.dataDic[@"phone"] substringFromIndex:7];
    phoneLabel.text =[NSString stringWithFormat:@"%@****%@",startStr,endStr];
    //两条分割线
    UILabel *lineLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-130, 5, 0.5, 40)];
    lineLabel1.backgroundColor = [UIColor whiteColor];
    [view addSubview:lineLabel1];
    
    UILabel *lineLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-65, 5, 0.5, 40)];
    lineLabel2.backgroundColor = [UIColor whiteColor];
    [view addSubview:lineLabel2];
}

#pragma mark --打电话
- (void)clickPhone
{
    if (GetOrgCode != nil)
    {
    UIWebView *phoneCallWebView;
    NSString *phoneNum = self.dataDic[@"phone"];// 电话号码
    NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phoneNum]];
    if (!phoneCallWebView)
    {
        phoneCallWebView = [[UIWebView alloc]initWithFrame:CGRectZero];
        // 这个webView只是一个后台的容易 不需要add到页面上来 效果跟方法二一样 但是这个方法是合法的
    }
    [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
    [self.view addSubview:phoneCallWebView];
    }
    else
    {
        [self.view makeToast:@"您尚未绑定机构码" duration:1.0 position:@"bottom"];
        
    }
    
}

#pragma mark --发短信
- (void)clickMessage
{
    if (GetOrgCode != nil)
    {
        if ([MFMessageComposeViewController canSendText])
        {
            MFMessageComposeViewController * messageVC = [[MFMessageComposeViewController alloc] init];
            messageVC.messageComposeDelegate = self;
            messageVC.navigationBar.tintColor = [UIColor blueColor];
            messageVC.recipients = [NSArray arrayWithObject:self.dataDic[@"phone"]];
            [self.navigationController presentViewController:messageVC animated:YES completion:nil];
        }
 
    }
    else
    {
        [self.view makeToast:@"您尚未绑定机构码" duration:1.0 position:@"bottom"];
 
    }
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [controller dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark --设置大头针
- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
    // 生成重用标示identifier
    NSString *AnnotationViewID = @"xidanMark";
    
    // 检查是否有重用的缓存
    BMKAnnotationView* annotationView = [view dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    
    // 缓存没有命中，自己构造一个，一般首次添加annotation代码会运行到此处
    if (annotationView == nil)
    {
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


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            NSString *string = self.dataDic[@"topic"];
            CGFloat titleH = [string boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-20, 0) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:Default_Font_20} context:nil].size.height;
            if (titleH > 25)
            {
                return 12+50+12+15+12;
            }
            else
            {
                return 12+25+12+15+12;
            }
        }
    }
    else if (indexPath.section == 1)
    {
//        if (indexPath.row == 0)
//        {
            return 30+20+25+10;
//        }
//        else
//        {
//            return 85;
//        }
    }
    else if (indexPath.section == 2)
    {
//        if (indexPath.row == 4)
//        {
//            return 80+12+20+30+15;
//        }
//        else
//        {
//            return 45;
//        }
        if (indexPath.row == 0)
        {
            return 45;
        } else
        {
            if (self.dataDic[@"isShangQuanname"] != nil &&
                self.dataDic[@"isShangQuanname"] != [NSNull null] &&
                self.dataDic[@"isShangQuanname"])
            {
                return 45*6+55;
            }else{
                return 45*5+55;
            }
        }
    }
    else if (indexPath.section == 3)
    {
        if (indexPath.row == 0)
        {
            return 45;
        }
        else if (indexPath.row == 1)
        {
            return 240;
        }
        else
        {
            return 40+24+8;
        }
    }
    else
    {
        return 24+20+100+22+20;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    else if (section == 1)
    {
        return 1;
    }
    else if (section == 2)
    {
        return 2;
    }
    else if (section == 3)
    {
        return 3;
    }
    else
    {
        return 1;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([self.dataDic[@"vpibs"] count] == 0)
    {
        return 4;
    } else {
        return 5;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    view.backgroundColor = [UIColor hexChangeFloat:@"f2f2f2"];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}



//将列表的分割线从头开始
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
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsMake(0, 10, 0, 0)];
        }
    }
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
