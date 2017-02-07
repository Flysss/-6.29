//
//  AboutSalesHelperViewController.m
//  SalesHelper_A
//
//  Created by zhipu on 14/10/24.
//  Copyright (c) 2014年 zhipu. All rights reserved.
//

#import "AboutSalesHelperViewController.h"
#import "ModelWebViewController.h"
#import <StoreKit/StoreKit.h>

#define TABLE_HEIGHT 50
#define VERSION_LABEL @"已是最新版本"

@interface AboutSalesHelperViewController ()<UITableViewDataSource,UITableViewDelegate,SKStoreProductViewControllerDelegate>
{
    UILabel *_versionLable;
    NSArray *_titleNameArray;
    UITableView *_versionTable;
}

@property (nonatomic, strong) NSURL *versionUrl;

@end

@implementation AboutSalesHelperViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];

//    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.097 green:0.547 blue:0.896 alpha:1.000]];
    
    _titleNameArray = @[@"去评分",@"功能介绍",@"服务协议"];
    
    [self CreateCustomNavigtionBarWith:self leftItem:@selector(backToView) rightItem:nil];
    //创建标题
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-120)/2, 27, 120, 30)];
    titleLabel.text = @"关于销邦";
    titleLabel.font = Default_Font_20;
    [titleLabel setTextColor:[UIColor whiteColor]];
    //    [titleLabel sizeToFit];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.topView addSubview: titleLabel];
    
    [self layoutSubViews];
    
    _versionTable = [[UITableView alloc] initWithFrame:CGRectMake(0, _versionLable.bottom + 20, SCREEN_WIDTH, _titleNameArray.count * TABLE_HEIGHT)];
    _versionTable.delegate = self;
    _versionTable.dataSource = self;
    _versionTable.bounces = NO;
    
    if ([_versionTable respondsToSelector:@selector(setSeparatorInset:)]) {
        [_versionTable setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    //ios8SDK 兼容6 和 7 cell下划线
    if ([_versionTable respondsToSelector:@selector(setLayoutMargins:)]) {
        [_versionTable setLayoutMargins:UIEdgeInsetsZero];
    }
    
    [self.view addSubview:_versionTable];
    
//    UILabel *copyRightLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-64-60, SCREEN_WIDTH, 20)];
//    copyRightLabel.text = @"合肥智朴信息科技有限公司  版权所有";
//    copyRightLabel.textAlignment = NSTextAlignmentCenter;
//    copyRightLabel.textColor = RGBCOLOR(169, 168, 173);
//    copyRightLabel.font = Default_Font_15;
//    [self.view addSubview:copyRightLabel];
    
    UILabel *copyRightDetailLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-30, SCREEN_WIDTH, 20)];
    copyRightDetailLabel.backgroundColor = [UIColor clearColor];
    copyRightDetailLabel.text = @"Copyright © 2016,ThinkPower,Inc. All Rights Reserved";
    copyRightDetailLabel.textAlignment = NSTextAlignmentCenter;
    copyRightDetailLabel.textColor = RGBCOLOR(169, 168, 173);
    copyRightDetailLabel.font = [UIFont systemFontOfSize:11];
    [self.view addSubview:copyRightDetailLabel];
    
    [self requestNewVersion];
}
- (void)backToView
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)layoutSubViews
{
    UIImageView *imgaeView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 107)/2, 50+64,107, 40)];
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"logo" ofType:@"png"];
//    imgaeView.image = [UIImage imageWithContentsOfFile:path];
    imgaeView.image = [UIImage imageNamed:@"灰色.png"];
    [self.view addSubview:imgaeView];
    
    _versionLable = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-80)/2, imgaeView.bottom + 10, 80, 30)];
    _versionLable.backgroundColor = [UIColor clearColor];
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    NSString *curVersion = [info valueForKey:@"CFBundleShortVersionString"];
    _versionLable.text = [NSString stringWithFormat:@"V%@",curVersion];
    _versionLable.textColor = RGBACOLOR(151, 151, 151, 1);
    _versionLable.font = [UIFont systemFontOfSize:18];
    _versionLable.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_versionLable];
    
}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return TABLE_HEIGHT;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titleNameArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"Cell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:identify];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        //ios8SDK 兼容6 和 7
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
    }
    
    cell.textLabel.text = _titleNameArray[indexPath.row];
    cell.textLabel.font = Default_Font_15;
    if (indexPath.row == 0) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        /*
        UILabel *detailLable = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-200, 5, 180, 40)];
        detailLable.text = VERSION_LABEL;
        detailLable.textColor = RGBACOLOR(151, 151, 151, 1);
        detailLable.tag = 200;
        detailLable.font = Default_Font_15;
        detailLable.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:detailLable];
         */
        
    }else if (indexPath.row == 1) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else if (indexPath.row==2)
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0)
    {
        
        NSString  * nsStringToOpen = [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=955317307"];
        
        if( ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0))
        {
            nsStringToOpen = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id955317307"];
        }
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:nsStringToOpen]];
        
        /*
        [ProjectUtil showLog:@"点击了版本信息"];
        UITableViewCell *selectCell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        UILabel *versionLabel = (UILabel *)[selectCell.contentView viewWithTag:200];
        if (![versionLabel.text isEqualToString:VERSION_LABEL]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"亲！销邦又有新版本了" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"亲！销邦又有新版本了" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            [alert show];

        }
         */
    }
    else if (indexPath.row == 1)
    {
        
        [ProjectUtil showLog:@"点击了功能介绍"];
        NSString *urlStr;
        
        if ([self netWorkReachable] == NotReachable) {
            NSString *path = [[NSBundle mainBundle] pathForResource:@"gnjs" ofType:@"html"];
            NSURL *pathUrl =[NSURL fileURLWithPath:path];
            urlStr = [[pathUrl absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }else {
            urlStr = @"http://sys.xiaobang.cc/Home/Article/syscontent/id/4.html";
        }
        
        ModelWebViewController *webVC = [[ModelWebViewController alloc] initWithUrlString:urlStr NavigationTitle:@"功能介绍"];
        [webVC creatBackButtonWithPushType:Push With:self.title Action:nil];
        [self.navigationController pushViewController:webVC animated:YES];
    }
    else
    {
        //服务协议
        NSString *urlStr;
        
        if ([self netWorkReachable] == NotReachable) {
            NSString *path = [[NSBundle mainBundle] pathForResource:@"server" ofType:@"html"];
            NSURL *pathUrl =[NSURL fileURLWithPath:path];
            urlStr = [[pathUrl absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }else {
            urlStr = @"http://sys.xiaobang.cc/Home/Article/syscontent/id/5.html";
        }
        
        ModelWebViewController *webVC = [[ModelWebViewController alloc] initWithUrlString:urlStr NavigationTitle:@"服务协议"];
        [webVC creatBackButtonWithPushType:Push With:self.title Action:nil];
        [self.navigationController pushViewController:webVC animated:YES];
    }
}

-(void) openAppStore:(id)sender
{
    //初始化Product View Controller
    SKStoreProductViewController *storeProductViewController = [[SKStoreProductViewController alloc] init];
    //配置View　Controller
    [storeProductViewController setDelegate:self];
    [storeProductViewController loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier:@"955317307"}
                                          completionBlock:^(BOOL result, NSError *error){
                                              if(error)
                                              {
                                                  NSLog(@"Error %@ with User Info %@.", error, [error userInfo]);
                                              }
                                              else
                                              {
                                                  [self presentViewController:storeProductViewController
                                                                     animated:YES
                                                                   completion:nil];
                                              }
                                          }];
    
}

-(void) productViewControllerDidFinish:(SKStoreProductViewController *)viewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Version 版本更新

- (void)requestNewVersion
{
    RequestInterface *versionOp = [[RequestInterface alloc] init];
    
    [versionOp requestUpGrateAppInterface];
    
    [versionOp getInterfaceRequestObject:^(id data) {
        
        NSDictionary *dict = data[0];
        NSString *version = dict[@"version_name"];
        NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
        NSString *curVersion = [info valueForKey:@"CFBundleShortVersionString"];
        NSComparisonResult r = [curVersion compare:version options:NSNumericSearch];
        if (r == NSOrderedAscending)
        {
            if (![dict[@"version_name"]isEqualToString:curVersion])
            {
                NSMutableString *urlStr = dict[@"download_url"];
                NSURL *url = [NSURL URLWithString:urlStr];
                
                self.versionUrl = url;
                
                UITableViewCell *cell = [_versionTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                UILabel *versionLabel = (UILabel *)[cell.contentView viewWithTag:200];
                versionLabel.text = [NSString stringWithFormat:@"有最新版本 %@",version];
            }
        }else {
        }
        
    } Fail:^(NSError *error) {
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [ProjectUtil showLog:@"更新取消"];
    }
    else if (buttonIndex == 1)
    {
        [ProjectUtil showLog:@"确定更新下载 = %@",self.versionUrl];
        [[UIApplication sharedApplication] openURL:self.versionUrl];
    }
    
}


@end
