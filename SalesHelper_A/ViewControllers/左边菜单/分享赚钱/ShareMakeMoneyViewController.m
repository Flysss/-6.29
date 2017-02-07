//
//  ShareMakeMoneyViewController.m
//  SalesHelper_A
//
//  Created by summer on 14/12/20.
//  Copyright (c) 2014年 X. All rights reserved.
//

#import "ShareMakeMoneyViewController.h"
#import "ShareMakeMoneyCell.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import "ShareWebInfoViewController.h"
#import "MJRefresh.h"
#import "ShareEarnViewController.h"


@interface ShareMakeMoneyViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *_dataArr;
    UITableView *_dataTableView;
    UITapGestureRecognizer *_reloadDataTap;
    CGFloat _dataTableViewHeight;
    CGFloat _headViewHeight;
    CGFloat _cellHeight;
    
    //分享赚钱调用接口次数 最多三次
    NSInteger requestIndex;
    
    NSString *urlString;
    NSString *content_url;
    NSString *content_sms;
    NSString* titleName;
    NSString* content_id;
    NSString* logPostTime;

    
}
@end

@implementation ShareMakeMoneyViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layoutSubViews];

    [self CreateCustomNavigtionBarWith:self leftItem:@selector(backlastView) rightItem:nil];
    //创建标题
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-120)/2, 27, 120, 30)];
    titleLabel.text = @"分享赚钱";
    titleLabel.font = Default_Font_20;
    [titleLabel setTextColor:[UIColor whiteColor]];
    //    [titleLabel sizeToFit];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.topView addSubview: titleLabel];
    
}

-(void)layoutSubViews
{
    _dataTableViewHeight = SCREEN_HEIGHT;
    _headViewHeight = 8.0;
 // _cellHeight = 3*SCREEN_WIDTH/8.0;
    _cellHeight = 90;
    _dataTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,64, SCREEN_WIDTH, _dataTableViewHeight-64) style:UITableViewStylePlain];
    _dataTableView.delegate = self;
    _dataTableView.dataSource = self;
    _dataTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_dataTableView];
    
    __block ShareMakeMoneyViewController *shareVC = self;
    [_dataTableView addHeaderWithCallback:^{
        [shareVC refreshAction];
    } dateKey:@"ShareMakeMoneyData"];
    [self reloadDatatapAction];
    //点击屏幕重新加载数据手势
    _reloadDataTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(reloadDatatapAction)];
//    
//    UIButton* btn=[UIButton buttonWithType:UIButtonTypeCustom];
//    btn.frame=CGRectMake(0, 0, 26, 26);
//    [btn setBackgroundImage:[UIImage imageNamed:@"首页-左箭头.png"] forState:UIControlStateNormal];
//    [btn setBackgroundImage:[UIImage imageByApplyingAlpha:[UIImage imageNamed:@"首页-左箭头.png"]] forState:UIControlStateHighlighted];
//    [btn addTarget:self action:@selector(backlastView) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem* BACK=[[UIBarButtonItem alloc]initWithCustomView:btn];
//    self.navigationItem.leftBarButtonItem=BACK;
    self.view.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:1];

//    [self.view setBackgroundColor:[UIColor colorWithRed:258.0/255.0 green:238.0/255.0 blue:218.0/255.0 alpha:1]];
    
}
-(void)backlastView
{
    [self.navigationController popViewControllerAnimated:YES];
    
}


//下拉刷新操作
-(void)reloadDatatapAction
{
    [_dataTableView headerBeginRefreshing];
}

#pragma mark - 刷新操作
-(void)refreshAction
{
    RequestInterface *request = [[RequestInterface alloc]init];
    [request requestGetShareListWithParam:[NSDictionary dictionaryWithObject:self.login_user_token forKey:@"token"]];
    [request getInterfaceRequestObject:^(id data) {
        NSLog(@"%@", data);
        [self.view hideProgressLabel];
        
        if ([data[@"success"] boolValue])
        {
            [_dataTableView headerEndRefreshing];
            _dataArr = [data objectForKey:@"datas"];
            if (_dataArr.count==0)
            {
                [self.view showProgressLabelWithTitle:HintWithNoData ViewHeight:_dataTableViewHeight];
            }
        }
        else
        {
            [self.view showProgressLabelWithTitle:HintWithTapLoadData ViewHeight:_dataTableViewHeight];
            [self.view addGestureRecognizer:_reloadDataTap];
        }
        [_dataTableView reloadData];
        
    } Fail:^(NSError *error) {
        [_dataTableView reloadData];
        [self.view makeToast:HintWithNetError];
        [_dataTableView headerEndRefreshing];
    }];
}

#pragma mark UITableViewDelegate,UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _cellHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
   return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
       static NSString *identifier = @"cell1";
        
       ShareMakeMoneyCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];        if (cell==nil)
        {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"ShareMakeMoneyCell" owner:self options:nil]lastObject];
        }
    
    [ProjectUtil showLog:[NSString stringWithFormat:@"indexPath.row = %ld",(long)indexPath.row]];
    NSDictionary *dataDic = [_dataArr objectAtIndex:indexPath.section];
    
    _shareBtn = (UIButton* )[cell.contentView viewWithTag:1001];
    [_shareBtn addTarget:self action:@selector(sharebuttonclick:) forControlEvents:UIControlEventTouchUpInside];
//    _shareBtn.frame=CGRectMake(283, 48, 54, 26);
//    [_shareBtn.layer setMasksToBounds:YES];
//    [_shareBtn.layer setCornerRadius:5.0]; //设置矩形四个圆角半径
//    [_shareBtn.layer setBorderWidth:1.0]; //边框宽度
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 1,0 , 0, 1 });
//    
//    [_shareBtn.layer setBorderColor:colorref];//边框颜色
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([dataDic objectForKey:@"logIntroimg"] != nil && [dataDic objectForKey:@"logIntroimg"] != [NSNull null] && [dataDic objectForKey:@"logIntroimg"] )
    {
        [cell.shareHouseImageView sd_setImageWithURL:[NSURL URLWithString:[dataDic objectForKey:@"logIntroimg"]] placeholderImage:[UIImage imageNamed:@"房源默认图.png"]];
    }
    
   
    cell.shareTitleLabel.text = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"logTitle"]];
    cell.shareLabel.text=[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"countUser"]];
//    NSString * str = [dataDic objectForKey:@"sumReward"];
//    NSLog(@"%@",dataDic);
//    if ([[dataDic objectForKey:@"sumReward"]isKindOfClass:[NSNull class]])
//    {
//        str = @"0";
//    }
    if (dataDic[@"sharemoney"] != nil && dataDic[@"sharemoney"] != [NSNull null] && dataDic[@"sharemoney"])
    {
        cell.yongjinLabel.text = [NSString stringWithFormat:@"%@", dataDic[@"sharemoney"]];
    }else
    {
        cell.yongjinLabel.text = @"0";
    }
    
    //fengexian fengexian分割线
    UILabel* fenge_label=[[UILabel alloc]init];
    fenge_label.frame=CGRectMake(0, _cellHeight-0.5, SCREEN_WIDTH, 0.5);
    fenge_label.backgroundColor=[UIColor colorWithRed:199.0/255.0 green:197.0/255.0 blue:204.0/255.0 alpha:1];
    [cell.contentView addSubview:fenge_label];
    return cell;

}
-(void)sharebuttonclick:(id)sender
{
    [self shareToWeixinqq:sender];
    
}
-(void)shareToWeixinqq:(UIButton *)sender
{
    UITableViewCell * cell = (UITableViewCell *)[[sender superview] superview];
    NSIndexPath * path = [_dataTableView indexPathForCell:cell];
    NSInteger i = path.section;//创建分享内容
    urlString = _dataArr[i][@"logIntroimg"];
    content_url = _dataArr[i][@"logshareurl"];
    content_sms = [NSString stringWithFormat:@"%@ 地址:%@",_dataArr[i][@"logTitle"],content_url];
    titleName=_dataArr[i][@"logTitle"];
    content_id=_dataArr[i][@"logId"];
    logPostTime = _dataArr[i][@"logPostTime"];
    
    //创建分享内容
//    NSString *urlString = self.shareDict[@"logintroimg"];
//    
//    NSString *content_url = self.shareDict[@"logshareurl"];
//    
//    NSString *content_sms = [NSString stringWithFormat:@"%@ 地址:%@",self.shareDict[@"logtitle"],content_url];
   
    NSArray *imageArray = @[urlString];
    //1、创建分享参数
            if (imageArray) {
    
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:content_sms
                                     images:imageArray
                                        url:[NSURL URLWithString:content_url]
                                      title:titleName
                                       type:SSDKContentTypeAuto];
    //2、分享（可以弹出我们的分享菜单和编辑界面）
    [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                             items:nil
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
                           requestIndex = 1;
                           [self requestAddShareRec];
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


//分享赚钱调用接口次数
- (void)requestAddShareRec
{
    NSDictionary *dict = @{@"token":self.login_user_token,
                           @"shareUrl": content_url,
                           @"shareId":content_id,
                           @"share_time":logPostTime,
                           @"cityId":[[NSUserDefaults standardUserDefaults] objectForKey:@"location_City"]
                           };
    RequestInterface *requestOp = [[RequestInterface alloc] init];
    [requestOp requestAddShareRecWithParam:dict];
    
    [requestOp getInterfaceRequestObject:^(id data) {
        [ProjectUtil showLog:@"data = %@",data];
        if ([data[@"success"] boolValue]) {
            
        }
    } Fail:^(NSError *error) {
        if (requestIndex < 3) {
            requestIndex ++;
            [self requestAddShareRec];
        }
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    ShareWebInfoViewController *shareVC = [[ShareWebInfoViewController alloc] initWithUrlString:[[_dataArr objectAtIndex:indexPath.section] objectForKey:@"logshareurl"] NavigationTitle:@"分享赚钱详情"];
//   
//    shareVC.shareDict = [_dataArr objectAtIndex:indexPath.section];
//
//    [self.navigationController pushViewController:shareVC animated:YES];
    
    
//    NSLog(@"%@",[_dataArr[indexPath.section] objectForKey:@"logshareurl"]);
    if ([_dataArr[indexPath.section] objectForKey:@"logshareurl"] != [NSNull null])
    {
        ShareEarnViewController *vc = [[ShareEarnViewController alloc] init];
        vc.shareDict = [_dataArr objectAtIndex:indexPath.section];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
