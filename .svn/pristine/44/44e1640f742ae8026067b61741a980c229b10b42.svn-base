//
//  MyHistoryComplainTableViewController.m
//  SalesHelper_A
//
//  Created by ZhipuTech on 14/12/21.
//  Copyright (c) 2014年 X. All rights reserved.
//

#import "MyHistoryComplainViewController.h"
#import "MyComplainTableViewCell.h"
#import "MJRefresh.h"
#import "MyComplainTableViewCell1.h"
@interface MyHistoryComplainViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *_dataArr;
    UITableView *_dataTableView;
    UITapGestureRecognizer *_reloadDataTap;
    CGFloat _dataTableViewHeight;
    CGFloat _cellHeight;
    CGFloat _headHeight;
}

@end

@implementation MyHistoryComplainViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self CreateCustomNavigtionBarWith:self leftItem:@selector(backToView) rightItem:nil];
    //创建标题
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-120)/2, 27, 120, 30)];
    titleLabel.text = @"历史申诉";
    titleLabel.font = Default_Font_20;
    [titleLabel setTextColor:[UIColor whiteColor]];
    //    [titleLabel sizeToFit];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.topView addSubview: titleLabel];

    [self layoutSubViews];
//    
//    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:21.0/255.0 green:159/255.0 blue:234/255.0 alpha:1]];

    
}
- (void)backToView
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)layoutSubViews
{
    //初始化
    _dataTableViewHeight = SCREEN_HEIGHT;
    _cellHeight = 168.0;
    _headHeight =10.0;
    
   _dataTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,64, SCREEN_WIDTH, _dataTableViewHeight) style:UITableViewStylePlain];
    //去除cell分隔线
//    _dataTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _dataTableView.dataSource = self;
    _dataTableView.delegate = self;
      _dataTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    if ([_dataTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_dataTableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    //ios8SDK 兼容6 和 7 cell下划线
    if ([_dataTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_dataTableView setLayoutMargins:UIEdgeInsetsZero];
    }

     [self.view addSubview:_dataTableView];
    
    //上拉刷新
    __block MyHistoryComplainViewController *myComplainVC = self;
    [_dataTableView addHeaderWithCallback:^{
        [myComplainVC requestMyComplainRecordData];
    } dateKey:@"myHistoryComplainTable"];
    
    //点击屏幕重新加载数据手势
    _reloadDataTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(reloadDatatapAction)];
    //请求数据
    [_dataTableView headerBeginRefreshing];
    
}

-(void)reloadDatatapAction
{
    [_dataTableView headerBeginRefreshing];
}

-(void)requestMyComplainRecordData
{
    [self.view hideProgressLabel];
    RequestInterface *request = [[RequestInterface alloc]init];
    [request requestGetAppealRecByCWithParam:@{@"token":self.login_user_token,
                                               @"page":@"1",
                                               @"size":@"12"
                                               }];
    
    
    [request getInterfaceRequestObject:^(id data) {
          [ProjectUtil showLog:@"GetRecRecordByCdata:%@",data];
         [self.view hideProgressLabel];
         [_dataTableView headerEndRefreshing];
        if ([[data objectForKey:@"success"]boolValue])
        {
            [self.view removeGestureRecognizer:_reloadDataTap];
            _dataArr = [data objectForKey:@"datas"];
            
            if (_dataArr.count==0)
            {
                    [self.view showProgressLabelWithTitle:HintWithNoData ViewHeight:_dataTableViewHeight];
            }
            else
            {
                [_dataTableView reloadData];
            }
        }
        else
        {
            [self.view showProgressLabelWithTitle:HintWithTapLoadData ViewHeight:_dataTableViewHeight];
            [self.view addGestureRecognizer:_reloadDataTap];
        }

       // [self.view makeToast:[data objectForKey:@"message"]];

    } Fail:^(NSError *error) {
        [self.view hideProgressLabel];
        [_dataTableView headerEndRefreshing];
        [self.view showProgressLabelWithTitle:HintWithTapLoadData ViewHeight:_dataTableViewHeight];
        [self.view addGestureRecognizer:_reloadDataTap];


    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view 数据源

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dataDic = [_dataArr objectAtIndex:indexPath.section];
    if (![dataDic[@"developer_id"]isEqual:@""])
    {
        static NSString *identifier = @"myComplainCell";
        MyComplainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (cell==nil)
        {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"MyComplainTableViewCell" owner:self options:nil] lastObject];
            
        }
        
        cell.complainTitle.text = [dataDic objectForKey:@"appealTitle"];
        cell.time.text = [[dataDic objectForKey:@"appealTime"]changeToMyDate];
        cell.name.text = [dataDic objectForKey:@"recName"];
        cell.houseName.text =[dataDic objectForKey:@"propertyName"];
        NSString * str ;
        if ([[dataDic objectForKey:@"status"] isEqualToNumber: @0])
        {
            str = @"正在解决中...请耐心等候";
            cell.progress.textColor = [UIColor redColor];

        }else
        {
            str = @"已解决";
        }
        cell.progress.text = str;

        //ios8SDK 兼容6 和 7
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;

    }
    else
    {
        static NSString *identifier1 = @"myComplainCell1";
        MyComplainTableViewCell1 *cell1 = [tableView dequeueReusableCellWithIdentifier:identifier1];
        
        if (cell1==nil)
        {
            cell1 = [[[NSBundle mainBundle]loadNibNamed:@"MyComplainTableViewCell1" owner:self options:nil] lastObject];
            
        }
        
        cell1.complainTitle.text = [dataDic objectForKey:@"appeal_title"];
        cell1.time.text = [[dataDic objectForKey:@"appeal_time"]changeToMyDate];
        cell1.progress.text = [dataDic objectForKey:@"status"];
        if ([[dataDic objectForKey:@"status"]isEqualToString:@"正在解决中...请耐心等候"])
        {
            cell1.progress.textColor = [UIColor redColor];
        }
        //ios8SDK 兼容6 和 7
        if ([cell1 respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell1 setLayoutMargins:UIEdgeInsetsZero];
        }
        cell1.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell1;

    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dataDic = [_dataArr objectAtIndex:indexPath.section];
    if (![dataDic[@"developer_id"]isEqual:@""])
    {
        return 168.0;
    }
    else
    {
        return 90.0;
    }
    
}


//设置组头的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 10;
}



@end
