//
//  ClientsRecommendedViewController.m
//  SalesHelper_A
//
//  Created by summer on 15/11/7.
//  Copyright © 2015年 X. All rights reserved.
//

#import "ClientsRecommendedViewController.h"
#import "HMSegmentedControl.h"
#import "TimeLineViewController.h"
#import "CustmorStatusTableViewCell.h"
#import "UIScrollView+EmptyDataSet.h"
#import "QRCode.h"
#import "SearchViewController.h"

@interface ClientsRecommendedViewController ()<UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (weak, nonatomic) IBOutlet HMSegmentedControl *mySegmentedControl;
@property (weak, nonatomic) IBOutlet UITableView * myTableView;

@end

@implementation ClientsRecommendedViewController
{
    NSMutableArray * bigDataArr;
    NSMutableArray * pageIndexArr;
    NSMutableArray * pageDataSource;
    UIView * _cover;
    NSInteger pageNum;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    pageNum = 1;
//    导航栏返回按钮
    [self creatNaviBackButton];
    
    [self UIConfig];
    
    self.myTableView.rowHeight = 66;
    self.myTableView.emptyDataSetSource = self;
    self.myTableView.emptyDataSetDelegate = self;
    self.myTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    pageDataSource = [NSMutableArray array];
    
    [self sendRequstWithStep:@-1 pageIndex:1 isFootAdd:NO withCash:NO];
    [self refreshingTableView];
    
    if (self.isTakeLook)
    {
        self.mySegmentedControl.selectedSegmentIndex = 2;
    }
    
    [self loadGesture];
    
}

- (void)creatNaviBackButton
{

    [self CreateCustomNavigtionBarWith:self leftItem:@selector(backlastView) rightItem:@selector(clickSearchBtn)];
    //创建标题
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-120)/2, 27, 120, 30)];
    titleLabel.text = @"推荐记录";
    titleLabel.font = Default_Font_20;
    [titleLabel setTextColor:[UIColor whiteColor]];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.topView addSubview: titleLabel];
    [self.rightBtn setImage:[UIImage imageNamed:@"销邦-首页-搜索"] forState:UIControlStateNormal];
    [self.rightBtn setImage:[UIImage imageByApplyingAlpha:[UIImage imageNamed:@"销邦-首页-搜索"]] forState:UIControlStateHighlighted];
    self.rightBtn.tintColor = [UIColor whiteColor];
    
}

#pragma mark --点击搜索按钮
- (void)clickSearchBtn
{    
    SearchViewController *vc = [[SearchViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark --返回到客户界面
- (void)backlastView
{
    NSArray *array = self.navigationController.viewControllers;
    [self.navigationController popToViewController:[array objectAtIndex:0] animated:YES];
}


#pragma mark --加载手势
- (void)loadGesture
{
    self.view.userInteractionEnabled = YES;
    UISwipeGestureRecognizer *swipeGesture=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGesture)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.myTableView addGestureRecognizer:swipeGesture];
    
    UISwipeGestureRecognizer *swipeLeftGesture=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftHandleSwipeGesture)];
    swipeLeftGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self.myTableView addGestureRecognizer:swipeLeftGesture];
    
}

#pragma mark --向左滑动
- (void)handleSwipeGesture
{
    if (self.mySegmentedControl.selectedSegmentIndex != 12)
    {
        self.mySegmentedControl.selectedSegmentIndex++;
        pageDataSource = bigDataArr[self.mySegmentedControl.selectedSegmentIndex];
        
        [_myTableView reloadData];
    }
}
#pragma mark --向右滑动
- (void)leftHandleSwipeGesture
{
    if (self.mySegmentedControl.selectedSegmentIndex != 0 )
    {
        self.mySegmentedControl.selectedSegmentIndex--;
        pageDataSource = bigDataArr[self.mySegmentedControl.selectedSegmentIndex];
        [_myTableView reloadData];
    }
}

//请求数据
- (void)sendRequstWithStep:(NSNumber *)step pageIndex:(NSInteger)pageIndex isFootAdd:(BOOL)addFootFresh withCash:(BOOL)cach
{
    
    NSNumber *page = [NSNumber numberWithInteger:pageIndex];

    NSDictionary * param = @{
                             @"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"Login_User_token"],
                             @"page":page,
                             @"size":@10,
                             @"step":step,
                             };
    RequestInterface * loadPerpoty = [[RequestInterface alloc] init];
    loadPerpoty.cachDisk = cach;
    [self.view Loading_0314];
//    __block BOOL footerSuccess = NO;
    [loadPerpoty requestGetCustomerPropertyWithParam:param];
    [loadPerpoty getInterfaceRequestObject:^(id data)
     {
         
         if ([[data objectForKey:@"success"] boolValue])
         {
             [self.view Hidden];
             
             //第一次进来
             if ([step isEqualToNumber:@-1])
             {
                 NSLog(@"%@", data);
                 
                 bigDataArr = [NSMutableArray array];
                 [bigDataArr addObjectsFromArray:[data objectForKey:@"datas"]];
                 pageDataSource = [NSMutableArray arrayWithArray:bigDataArr[self.mySegmentedControl.selectedSegmentIndex]];
             }
             else
             {
                 //如果是下拉刷新
                 if (!addFootFresh)
                 {
                     pageDataSource = [NSMutableArray array];
                     [_myTableView footerEndRefreshing];
                     [pageDataSource addObjectsFromArray:[data objectForKey:@"datas"]];
                     NSLog(@"%@", data[@"datas"]);
                     [_myTableView footerEndRefreshing];
                     [bigDataArr replaceObjectAtIndex:self.mySegmentedControl.selectedSegmentIndex withObject:pageDataSource];
                     
                 }
                 //上拉加载
                 else
                 {
                     if (![[data objectForKey:@"datas"]count])
                     {
                         [_myTableView footerEndRefreshing];
                         [self.view makeToast:@"没有更多数据了"];
//                         footerSuccess = YES;
                     }
                     else
                     {
                         pageDataSource = [NSMutableArray arrayWithArray:bigDataArr[self.mySegmentedControl.selectedSegmentIndex]];
                         [pageDataSource addObjectsFromArray:[data objectForKey:@"datas"]];
                         [bigDataArr replaceObjectAtIndex:self.mySegmentedControl.selectedSegmentIndex withObject:pageDataSource];
                         [_myTableView footerEndRefreshing];
                     }
                 }
               
             }
             [self.myTableView reloadData];
         }
         else
         {
//             footerSuccess = YES;
             [self.view Hidden];
             [self.view makeToast:[data objectForKey:@"message"]];
             [_myTableView footerEndRefreshing];
         }
         
     } Fail:^(NSError *error) {
         [self.view Hidden];
         [_myTableView footerEndRefreshing];
//         footerSuccess = YES;
     }];
    
//    if (footerSuccess)
//    {
//        NSInteger page = (NSInteger)pageIndexArr[self.mySegmentedControl.selectedSegmentIndex];
//        page--;
//        [pageIndexArr replaceObjectAtIndex:self.mySegmentedControl.selectedSegmentIndex withObject:[NSNumber numberWithInteger:page]];
//    }
    
}







#pragma mark --刷新
-(void)refreshingTableView
{
    //下拉刷新
    __block  ClientsRecommendedViewController * h = self;
    [_myTableView addHeaderWithCallback:^{
        [_myTableView headerEndRefreshing];
        [h refreshingHeaderTableView];
    }];
    
    //上拉加载
    [_myTableView addFooterWithCallback:^{
        [h refreshingFooterTableView];
    }];
}

#pragma mark --下拉刷新
- (void)refreshingHeaderTableView
{
//    NSNumber * page = [pageIndexArr objectAtIndex:[self selectIndexNum:self.mySegmentedControl.selectedSegmentIndex]];
//    NSInteger pageIndex = [page integerValue];
//    pageIndex = 1;
//    [pageIndexArr replaceObjectAtIndex:self.mySegmentedControl.selectedSegmentIndex withObject:[NSNumber numberWithInteger:pageIndex]];

    pageNum = 1;
    [self sendRequstWithStep:[NSNumber numberWithInteger:[self selectIndexNum:self.mySegmentedControl.selectedSegmentIndex]] pageIndex:pageNum isFootAdd:NO withCash:NO];
}

#pragma mark --上拉加载
- (void)refreshingFooterTableView
{
    
//    NSNumber * page =[pageIndexArr objectAtIndex:self.mySegmentedControl.selectedSegmentIndex];
//    NSInteger pageIndex = [page integerValue];
//    pageIndex++;
//    [pageIndexArr replaceObjectAtIndex:self.mySegmentedControl.selectedSegmentIndex withObject:[NSNumber numberWithInteger:pageIndex]];
    pageNum ++;
    [self sendRequstWithStep:[NSNumber numberWithInteger:[self selectIndexNum:self.mySegmentedControl.selectedSegmentIndex]] pageIndex:pageNum isFootAdd:YES withCash:NO];
}

- (void)UIConfig
{
    [self.mySegmentedControl setSectionTitles:@[@" 全部 ",@" 确认中 ",@" 有效 ",@" 有意向 ",@" 已到访 ",@" 已认筹 " ,@" 已认购 ",@" 已签约 ",@" 已结佣 ",@" 已带看 ",@"无意向",@" 无效 ",@" 失效 "]];
    [self.mySegmentedControl setSelectionIndicatorColor:[ProjectUtil colorWithHexString:@"00aff0"]];
    self.mySegmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    self.mySegmentedControl.selectionIndicatorHeight = 4.0f;
    self.mySegmentedControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    self.mySegmentedControl.backgroundColor = [UIColor whiteColor];
    self.mySegmentedControl.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[ProjectUtil colorWithHexString:@"575757"]};
    self.mySegmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName:[ProjectUtil colorWithHexString:@"575757"]};
    self.mySegmentedControl.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleDynamic;
    [self.mySegmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
}

- (void)segmentedControlChangedValue:(HMSegmentedControl *)seg
{
    pageDataSource = bigDataArr[seg.selectedSegmentIndex];
    [_myTableView reloadData];
}




#pragma mark --UITableViewDataSource && UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return pageDataSource.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustmorStatusTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"detailCell"];
    cell.dataSource = [pageDataSource objectAtIndex:indexPath.row];
    
    cell.takeLookBtn.tag = indexPath.row;
    [cell.takeLookBtn addTarget:self action:@selector(clickDimensionalBtn:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)clickDimensionalBtn:(UIButton *)button
{
//    UITableViewCell * cell = (UITableViewCell *)[[button superview] superview];
//    NSIndexPath * path = [_myTableView indexPathForCell:cell];
//    NSDictionary * dict = [pageDataSource objectAtIndex:path.row];
////    NSArray * dataSource = [dict objectForKey:@"data"];
//    NSString * string = [NSString stringWithFormat:@"ThinkPower_%@",[dict objectForKey:@"id"]];
////    UIImage * image = [UIImage creatQRFromString:string withIconImage:@"Icon60.png"];
//    CIImage *imgQRCode = [QRCode createQRCodeImage:string];
//    UIImage *imgAdaptiveQRCode = [QRCode resizeQRCodeImage:imgQRCode withSize:170];
//    imgAdaptiveQRCode = [QRCode addIconToQRCodeImage:imgAdaptiveQRCode
//                                               withIcon:[UIImage imageNamed:@"Icon60.png"]
//                                            withIconSize:CGSizeMake(30, 30)];
    
    NSString *string = [NSString stringWithFormat:@"ThinkPower_%@", pageDataSource[button.tag][@"id"]];
    CIImage *image1 = [self createQRForString:string];
    
    UIImage *image2 = [self createNonInterpolatedUIImageFormCIImage:image1 withSize:170];
    [self showQRWithQRimage:image2];
}

//生成二维码图片，但没有大小限制
- (CIImage *)createQRForString:(NSString *)qrString
{
    NSData *stringData = [qrString dataUsingEncoding:NSUTF8StringEncoding];
    // 创建filter
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 设置内容和纠错级别
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"M" forKey:@"inputCorrectionLevel"];
    // 返回CIImage
    return qrFilter.outputImage;
}
//将二维码图片，设置大小
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat)size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // 创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}


- (void)showQRWithQRimage:(UIImage *)QRimage
{
    UIView * coverView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _cover = coverView;
    coverView.backgroundColor = [ProjectUtil colorWithHexString:@"80919191"];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickCoverDisAppear)];
    [coverView addGestureRecognizer:tap];
    [self.view.window addSubview:coverView];
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(72, 27, 200, 20)];
    label.text = @"带看二维码";
    label.font = [UIFont systemFontOfSize:18];
    label.textColor = [ProjectUtil colorWithHexString:@"464646"];
    
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 233, 268)];
    imageView.image = [UIImage imageNamed:@"波纹背景.png"];
    CGPoint center = imageView.center;
    center.x = self.view.center.x;
    center.y = self.view.center.y;
    imageView.center = center;
    UIImageView * QRImageView = [[UIImageView alloc]initWithFrame:CGRectMake(31, 65, 170, 170)];
    QRImageView.image = QRimage;
    [imageView addSubview:QRImageView];
    [imageView addSubview:label];
    [_cover addSubview:imageView];
}
- (void)clickCoverDisAppear
{
    [_cover removeFromSuperview];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    TimeLineViewController * time = [storyboard instantiateViewControllerWithIdentifier:@"TimeLineViewController"];
//    time.propertyInfo = [pageDataSource objectAtIndex:indexPath.row];
//    [self.navigationController pushViewController:time animated:YES];
    
    TimeLineViewController *vc = [[ TimeLineViewController alloc] init];
    vc.propertyInfo = [pageDataSource objectAtIndex:indexPath.row];
    vc.timeLineID = pageDataSource[indexPath.row][@"id"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = nil;
    UIFont *font = nil;
    UIColor *textColor = nil;
    
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    text = @"该条件下没有推荐数据";
    font =  Default_Font_12;
    textColor = [ProjectUtil colorWithHexString:@"808080"];
    if (!text) {
        return nil;
    }
    
    if (font) [attributes setObject:font forKey:NSFontAttributeName];
    if (textColor) [attributes setObject:textColor forKey:NSForegroundColorAttributeName];
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
    
}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"灰色.png"];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    
    if (IOS_VERSION >= 8.0) {
        if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)])
        {
            [cell setPreservesSuperviewLayoutMargins:NO];
        }
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
    }
    
}


- (NSInteger)selectIndexNum:(NSInteger)index
{
    if (index == 0 || index == 1 || index == 2 || index == 3)
    {
        return index;
    }
    else if (index == 4)
    {
        return 11;
    }
    else if (index == 5)
    {
        return 4;
    }
    else if (index == 6)
    {
        return 13;
    }
    else if (index == 7)
    {
        return 5;
    }
    else if (index == 8)
    {
        return 6;
    }
    else if (index == 9)
    {
        return 7;
    }
    else if (index == 10)
    {
        return 14;
    }
    else if (index == 11)
    {
        return 8;
    }
    else
    {
        return 9;
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


/*

{
    datas =
    [
        [
            {
                manager_name = <null>,
                look_remarks = <null>,
                step = 1,
                stepColor = 47bcb3,
                manager_phone = <null>,
                dealmony = <null>,
                look_time = <null>,
                managerId = <null>,
                refereeId = 51649,
                stage = 1,
                name = 啊,
                id = 7781,
                refereeTime = 1452751655,
                propertyId = 239,
                staffId = <null>,
                phone = 15874125874,
                refereeDate = 2016-01-14 14:07:35,
                newStep = 1,
                stepName = 待定,
                propertyName = 滨湖向上城,
                look_type = 9,
                newStepName = 确认中
            },
            {
                manager_name = <null>,
                look_remarks = <null>,
                step = 1,
                stepColor = 47bcb3,
                manager_phone = <null>,
                dealmony = <null>,
                look_time = <null>,
                managerId = <null>,
                refereeId = 51649,
                stage = 1,
                name = ccc ,
                id = 7771,
                refereeTime = 1452672493,
                propertyId = 58,
                staffId = <null>,
                phone = 11111111111,
                refereeDate = 2016-01-13 16:08:13,
                newStep = 1,
                stepName = 待定,
                propertyName = 智朴销邦,
                look_type = 9,
                newStepName = 确认中

            },
            {
                manager_name = <null>,
                look_remarks = <null>,
                step = 1,
                stepColor = 47bcb3,
                manager_phone = <null>,
                dealmony = <null>,
                look_time = <null>,
                managerId = <null>,
                refereeId = 51649,
                stage = 1,
                name = 锕,
                id = 7769,
                refereeTime = 1452670569,
                propertyId = 58,
                staffId = <null>,
                phone = 13457688877,
                refereeDate = 2016-01-13 15:36:09,
                newStep = 1,
                stepName = 待定,
                propertyName = 智朴销邦,
                look_type = 9,
                newStepName = 确认中
            },
            {
                manager_name = <null>,
                look_remarks = <null>,
                step = 1,
                stepColor = 47bcb3,
                manager_phone = <null>,
                dealmony = <null>,
                look_time = <null>,
                managerId = <null>,
                refereeId = 51649,
                stage = 1,
                name = 一定,
                id = 7048,
                refereeTime = 1450939396,
                propertyId = 58,
                staffId = <null>,
                phone = 12365984774,
                refereeDate = 2015-12-24 14:43:16,
                newStep = 1,
                stepName = 待定,
                propertyName = 智朴销邦,
                look_type = 9,
                newStepName = 确认中
            },
            {
                manager_name = <null>,
                look_remarks = <null>,
                step = 7,
                stepColor = 676566,
                manager_phone = <null>,
                dealmony = <null>,
                look_time = <null>,
                managerId = <null>,
                refereeId = 51649,
                stage = 11,
                name = hehe,
                id = 6678,
                refereeTime = 1450687192,
                propertyId = 58,
                staffId = <null>,
                phone = 17172938473,
                refereeDate = 2015-12-21 16:39:52,
                newStep = 8,
                stepName = 无效,
                propertyName = 智朴销邦,
                look_type = 9,
                newStepName = 无效
            },
            {
                manager_name = 江子航,
                look_remarks = <null>,
                step = 2,
                stepColor = 9fd287,
                manager_phone = 15256985760,
                dealmony = <null>,
                look_time = <null>,
                managerId = 936,
                refereeId = 51649,
                stage = 2,
                name = the ,
                id = 6674,
                refereeTime = 1450677279,
                propertyId = 232,
                staffId = 939,
                phone = 12121121212,
                refereeDate = 2015-12-21 13:54:39,
                newStep = 2,
                stepName = 已确认,
                propertyName = 绿地派克公馆,
                look_type = 9,
                newStepName = 有效
            },
            {
                manager_name = <null>,
                look_remarks = <null>,
                step = 7,
                stepColor = 676566,
                manager_phone = <null>,
                dealmony = <null>,
                look_time = <null>,
                managerId = <null>,
                refereeId = 51649,
                stage = 11,
                name = love ,
                id = 6670,
                refereeTime = 1450670476,
                propertyId = 228,
                staffId = <null>,
                phone = 17417417417,
                refereeDate = 2015-12-21 12:01:16,
                newStep = 8,
                stepName = 无效,
                propertyName = 和昌中央城邦(公寓),
                look_type = 9,
                newStepName = 无效
            }
         ],
        [
         {
             manager_name = <null>,
             look_remarks = <null>,
             step = 1,
             stepColor = 47bcb3,
             manager_phone = <null>,
             dealmony = <null>,
             look_time = <null>,
             managerId = <null>,
             refereeId = 51649,
             stage = 1,
             name = 啊,
             id = 7782,
             refereeTime = 1452751655,
             propertyId = 231,
             staffId = <null>,
             phone = 15874125874,
             refereeDate = 2016-01-14 14:07:35,
             newStep = 1,
             stepName = 待定,
             propertyName = 天玥中心,
             look_type = 9,
             newStepName = 确认中
         },
         {
          manager_name = <null>,
          look_remarks = <null>,
          step = 1,
          stepColor = 47bcb3,
          manager_phone = <null>,
          dealmony = <null>,
          look_time = <null>,
          managerId = <null>,
          refereeId = 51649,
          stage = 1,
          name = ccc ,
          id = 7771,
          refereeTime = 1452672493,
          propertyId = 58,
          staffId = <null>,
          phone = 11111111111,
          refereeDate = 2016-01-13 16:08:13,
          newStep = 1,
          stepName = 待定,
          propertyName = 智朴销邦,
          look_type = 9,
          newStepName = 确认中
      },
         {
          manager_name = <null>,
          look_remarks = <null>,
          step = 1,
          stepColor = 47bcb3,
          manager_phone = <null>,
          dealmony = <null>,
          look_time = <null>,
          managerId = <null>,
          refereeId = 51649,
          stage = 1,
          name = 锕,
          id = 7769,
          refereeTime = 1452670569,
          propertyId = 58,
          staffId = <null>,
          phone = 13457688877,
          refereeDate = 2016-01-13 15:36:09,
          newStep = 1,
          stepName = 待定,
          propertyName = 智朴销邦,
          look_type = 9,
          newStepName = 确认中
      },
         {
          manager_name = <null>,
          look_remarks = <null>,
          step = 1,
          stepColor = 47bcb3,
          manager_phone = <null>,
          dealmony = <null>,
          look_time = <null>,
          managerId = <null>,
          refereeId = 51649,
          stage = 1,
          name = 一定,
          id = 7048,
          refereeTime = 1450939396,
          propertyId = 58,
          staffId = <null>,
          phone = 12365984774,
          refereeDate = 2015-12-24 14:43:16,
          newStep = 1,
          stepName = 待定,
          propertyName = 智朴销邦,
          look_type = 9,
          newStepName = 确认中
      }

         ],
        [
         {
        manager_name = <null>,
        look_remarks = <null>,
        step = 2,
        stepColor = 9fd287,
        manager_phone = <null>,
        dealmony = <null>,
        look_time = <null>,
        managerId = <null>,
        refereeId = 51649,
        stage = 16,
        name = ccc ,
        id = 6675,
        refereeTime = 1450677520,
        propertyId = 199,
        staffId = <null>,
        phone = 11111111111,
        refereeDate = 2015-12-21 13:58:40,
        newStep = 2,
        stepName = 已确认,
        propertyName = 奥青城公园里,
        look_type = 9,
        newStepName = 有效
    },
         {
        manager_name = 江子航,
        look_remarks = <null>,
        step = 2,
        stepColor = 9fd287,
        manager_phone = 15256985760,
        dealmony = <null>,
        look_time = <null>,
        managerId = 936,
        refereeId = 51649,
        stage = 2,
        name = the ,
        id = 6674,
        refereeTime = 1450677279,
        propertyId = 232,
        staffId = 939,
        phone = 12121121212,
        refereeDate = 2015-12-21 13:54:39,
        newStep = 2,
        stepName = 已确认,
        propertyName = 绿地派克公馆,
        look_type = 9,
        newStepName = 有效
    }
        ],
            [
                {
        manager_name = 彭玉红,
        look_remarks = <null>,
        step = 12,
        stepColor = 9fd287,
        manager_phone = 12456398740,
        dealmony = <null>,
        look_time = <null>,
        managerId = 186,
        refereeId = <null>,
        stage = 19,
        name = aa,
        id = 7767,
        refereeTime = 1452587872,
        propertyId = 58,
        staffId = 187,
        phone = 19999999999,
        refereeDate = 2016-01-12 16:37:52,
        newStep = 11,
        stepName = 已到访,
        propertyName = 智朴销邦,
        look_type = 7,
        newStepName = 已到访
    },
                {
        manager_name = 彭玉红,
        look_remarks = <null>,
        step = 12,
        stepColor = 9fd287,
        manager_phone = 12456398740,
        dealmony = <null>,
        look_time = <null>,
        managerId = 186,
        refereeId = <null>,
        stage = 19,
        name = 长撒,
        id = 7766,
        refereeTime = 1452564917,
        propertyId = 58,
        staffId = 187,
        phone = 17787878787,
        refereeDate = 2016-01-12 10:15:17,
        newStep = 11,
        stepName = 已到访,
        propertyName = 智朴销邦,
        look_type = 7,
        newStepName = 已到访
    },
                {
        manager_name = <null>,
        look_remarks = <null>,
        step = 12,
        stepColor = 9fd287,
        manager_phone = <null>,
        dealmony = <null>,
        look_time = <null>,
        managerId = <null>,
        refereeId = 4280,
        stage = 19,
        name = 测试代码,
        id = 7694,
        refereeTime = 1452068750,
        propertyId = 58,
        staffId = <null>,
        phone = 17965236523,
        refereeDate = 2016-01-06 16:25:50,
        newStep = 11,
        stepName = 已到访,
        propertyName = 智朴销邦,
        look_type = 9,
        newStepName = 已到访
    }
            ],
             [
             ],
             [
                {
        manager_name = 彭玉红,
        look_remarks = <null>,
        step = 13,
        stepColor = <null>,
        manager_phone = 12456398740,
        dealmony = <null>,
        look_time = <null>,
        managerId = 186,
        refereeId = <null>,
        stage = 20,
        name = 哈哈镜,
        id = 7768,
        refereeTime = 1452653488,
        propertyId = 58,
        staffId = 187,
        phone = 18355552222,
        refereeDate = 2016-01-13 10:51:28,
        newStep = 13,
        stepName = 已认购,
        propertyName = 智朴销邦,
        look_type = 7,
        newStepName = 已认购
    },
                {
        manager_name = 彭玉红,
        look_remarks = <null>,
        step = 13,
        stepColor = <null>,
        manager_phone = 12456398740,
        dealmony = <null>,
        look_time = <null>,
        managerId = 186,
        refereeId = <null>,
        stage = 20,
        name = 测试的,
        id = 7764,
        refereeTime = 1452562365,
        propertyId = 58,
        staffId = 187,
        phone = 17788899999,
        refereeDate = 2016-01-12 09:32:45,
        newStep = 13,
        stepName = 已认购,
        propertyName = 智朴销邦,
        look_type = 7,
        newStepName = 已认购
    },
                {
        manager_name = <null>,
        look_remarks = <null>,
        step = 13,
        stepColor = <null>,
        manager_phone = <null>,
        dealmony = <null>,
        look_time = <null>,
        managerId = <null>,
        refereeId = 4280,
        stage = 20,
        name = 测试代码,
        id = 7698,
        refereeTime = 1452070248,
        propertyId = 58,
        staffId = <null>,
        phone = 17965236523,
        refereeDate = 2016-01-06 16:50:48,
        newStep = 13,
        stepName = 已认购,
        propertyName = 智朴销邦,
        look_type = 9,
        newStepName = 已认购
    }
              ],
             [
             ],
             [
             ],
             [
             ],
             [
    {
        manager_name = 销售经理,
        look_remarks = <null>,
        step = 4,
        stepColor = aca15f,
        manager_phone = 13644316111,
        dealmony = <null>,
        look_time = <null>,
        managerId = 882,
        refereeId = 4376,
        stage = 6,
        name = 刘,
        id = 7736,
        refereeTime = 1452141290,
        propertyId = 208,
        staffId = 888,
        phone = 15947982707,
        refereeDate = 2016-01-07 12:34:50,
        newStep = 3,
        stepName = 洽谈中,
        propertyName = 欧亚城·御龙湾,
        look_type = 7,
        newStepName = 洽谈中
    },
    {
        manager_name = 王琳,
        look_remarks = <null>,
        step = 4,
        stepColor = aca15f,
        manager_phone = 15068797889,
        dealmony = <null>,
        look_time = <null>,
        managerId = 987,
        refereeId = 1432,
        stage = 6,
        name = 某先生,
        id = 7734,
        refereeTime = 1452139306,
        propertyId = 239,
        staffId = 990,
        phone = 13033003377,
        refereeDate = 2016-01-07 12:01:46,
        newStep = 3,
        stepName = 洽谈中,
        propertyName = 滨湖向上城,
        look_type = 7,
        newStepName = 洽谈中
    },
    {
        manager_name = 王琳,
        look_remarks = <null>,
        step = 4,
        stepColor = aca15f,
        manager_phone = 15068797889,
        dealmony = <null>,
        look_time = <null>,
        managerId = 987,
        refereeId = 51646,
        stage = 6,
        name = 唐女士,
        id = 7723,
        refereeTime = 1452133500,
        propertyId = 239,
        staffId = 990,
        phone = 15955440109,
        refereeDate = 2016-01-07 10:25:00,
        newStep = 3,
        stepName = 洽谈中,
        propertyName = 滨湖向上城,
        look_type = 7,
        newStepName = 洽谈中
    },
    {
        manager_name = <null>,
        look_remarks = <null>,
        step = 4,
        stepColor = <null>,
        manager_phone = <null>,
        dealmony = <null>,
        look_time = <null>,
        managerId = <null>,
        refereeId = 4280,
        stage = 21,
        name = 肖邦手机,
        id = 7700,
        refereeTime = 1452070789,
        propertyId = 58,
        staffId = <null>,
        phone = 18000009900,
        refereeDate = 2016-01-06 16:59:49,
        newStep = 3,
        stepName = 无意向,
        propertyName = 智朴销邦,
        look_type = 9,
        newStepName = 无意向
    },
    {
        manager_name = 销售经理,
        look_remarks = <null>,
        step = 4,
        stepColor = aca15f,
        manager_phone = 13644316111,
        dealmony = <null>,
        look_time = <null>,
        managerId = 882,
        refereeId = 4418,
        stage = 6,
        name = 张晓鹏雨微,
        id = 7696,
        refereeTime = 1452070701,
        propertyId = 208,
        staffId = 884,
        phone = 18643201281,
        refereeDate = 2016-01-06 16:58:21,
        newStep = 3,
        stepName = 洽谈中,
        propertyName = 欧亚城·御龙湾,
        look_type = 7,
        newStepName = 洽谈中
    },
    {
        manager_name = 王琳,
        look_remarks = <null>,
        step = 4,
        stepColor = aca15f,
        manager_phone = 15068797889,
        dealmony = <null>,
        look_time = <null>,
        managerId = 987,
        refereeId = 4657,
        stage = 6,
        name = 决定进,
        id = 7692,
        refereeTime = 1452069676,
        propertyId = 239,
        staffId = 990,
        phone = 13855418476,
        refereeDate = 2016-01-06 16:41:16,
        newStep = 3,
        stepName = 洽谈中,
        propertyName = 滨湖向上城,
        look_type = 7,
        newStepName = 洽谈中
    },
    {
        manager_name = 销售经理,
        look_remarks = <null>,
        step = 4,
        stepColor = aca15f,
        manager_phone = 13644316111,
        dealmony = <null>,
        look_time = 2018-04-08 20:32:00,
        managerId = 882,
        refereeId = 4376,
        stage = 6,
        name = 张,
        id = 7685,
        refereeTime = 1452056118,
        propertyId = 208,
        staffId = 888,
        phone = 13019279340,
        refereeDate = 2016-01-06 12:55:18,
        newStep = 3,
        stepName = 洽谈中,
        propertyName = 欧亚城·御龙湾,
        look_type = 7,
        newStepName = 洽谈中
    },
    {
        manager_name = 司石磊,
        look_remarks = <null>,
        step = 4,
        stepColor = aca15f,
        manager_phone = 13095457076,
        dealmony = <null>,
        look_time = <null>,
        managerId = 956,
        refereeId = 51779,
        stage = 6,
        name = 张女士,
        id = 7679,
        refereeTime = 1452050369,
        propertyId = 236,
        staffId = 967,
        phone = 13965031946,
        refereeDate = 2016-01-06 11:19:29,
        newStep = 3,
        stepName = 洽谈中,
        propertyName = 闽商国贸中心,
        look_type = 7,
        newStepName = 洽谈中
    },
    {
        manager_name = 王琳,
        look_remarks = <null>,
        step = 4,
        stepColor = aca15f,
        manager_phone = 15068797889,
        dealmony = <null>,
        look_time = <null>,
        managerId = 987,
        refereeId = 51831,
        stage = 6,
        name = 程燕,
        id = 7668,
        refereeTime = 1452045967,
        propertyId = 239,
        staffId = 990,
        phone = 15615706881,
        refereeDate = 2016-01-06 10:06:07,
        newStep = 3,
        stepName = 洽谈中,
        propertyName = 滨湖向上城,
        look_type = 7,
        newStepName = 洽谈中
    },
    {
        manager_name = 销售经理,
        look_remarks = <null>,
        step = 4,
        stepColor = aca15f,
        manager_phone = 13644316111,
        dealmony = <null>,
        look_time = <null>,
        managerId = 882,
        refereeId = <null>,
        stage = 6,
        name = 徐莹,
        id = 7666,
        refereeTime = 1451984228,
        propertyId = 208,
        staffId = 884,
        phone = 13321503371,
        refereeDate = 2016-01-05 16:57:08,
        newStep = 3,
        stepName = 洽谈中,
        propertyName = 欧亚城·御龙湾,
        look_type = 7,
        newStepName = 洽谈中
    }
              ],
             [
    {
        manager_name = <null>,
        look_remarks = <null>,
        step = 7,
        stepColor = 676566,
        manager_phone = <null>,
        dealmony = <null>,
        look_time = <null>,
        managerId = <null>,
        refereeId = 51649,
        stage = 11,
        name = hehe,
        id = 6678,
        refereeTime = 1450687192,
        propertyId = 58,
        staffId = <null>,
        phone = 17172938473,
        refereeDate = 2015-12-21 16:39:52,
        newStep = 8,
        stepName = 无效,
        propertyName = 智朴销邦,
        look_type = 9,
        newStepName = 无效
    },
    {
        manager_name = <null>,
        look_remarks = <null>,
        step = 7,
        stepColor = 676566,
        manager_phone = <null>,
        dealmony = <null>,
        look_time = <null>,
        managerId = <null>,
        refereeId = 51649,
        stage = 11,
        name = the ,
        id = 6671,
        refereeTime = 1450671189,
        propertyId = 231,
        staffId = <null>,
        phone = 12121121212,
        refereeDate = 2015-12-21 12:13:09,
        newStep = 8,
        stepName = 无效,
        propertyName = 天玥中心,
        look_type = 9,
        newStepName = 无效
    },
    {
        manager_name = <null>,
        look_remarks = <null>,
        step = 7,
        stepColor = 676566,
        manager_phone = <null>,
        dealmony = <null>,
        look_time = <null>,
        managerId = <null>,
        refereeId = 51649,
        stage = 11,
        name = love ,
        id = 6670,
        refereeTime = 1450670476,
        propertyId = 228,
        staffId = <null>,
        phone = 17417417417,
        refereeDate = 2015-12-21 12:01:16,
        newStep = 8,
        stepName = 无效,
        propertyName = 和昌中央城邦(公寓),
        look_type = 9,
        newStepName = 无效
    },
    {
        manager_name = <null>,
        look_remarks = <null>,
        step = 7,
        stepColor = 676566,
        manager_phone = <null>,
        dealmony = <null>,
        look_time = <null>,
        managerId = <null>,
        refereeId = 51649,
        stage = 11,
        name = ccc ,
        id = 6636,
        refereeTime = 1450664037,
        propertyId = 184,
        staffId = <null>,
        phone = 11111111111,
        refereeDate = 2015-12-21 10:13:57,
        newStep = 8,
        stepName = 无效,
        propertyName = 中星城,
        look_type = 9,
        newStepName = 无效
    }
              ],
             [
             ]
    ],
    message = 成功,
    success = 1
}


*/

@end
