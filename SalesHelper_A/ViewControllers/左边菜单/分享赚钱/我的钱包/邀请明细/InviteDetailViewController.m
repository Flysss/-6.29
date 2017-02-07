//
//  InviteDetailViewController.m
//  SalesHelper_A
//
//  Created by summer on 14/12/20.
//  Copyright (c) 2014年 X. All rights reserved.
//

#import "InviteDetailViewController.h"
#import "MJRefresh.h"

static CGFloat inviteCellHeight = 44.0;

@interface InviteDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSDateComponents *_datecomps;
    NSArray *_dataArr;
    UITableView *_dataTableView;
    NSInteger _monthIndex;
    CGFloat _dataTableViewHeight;
    UITapGestureRecognizer *_reloadDataTap;
}
@end

@implementation InviteDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutSubViews];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:21.0/255.0 green:159/255.0 blue:234/255.0 alpha:1]];
}

-(void)layoutSubViews
{
     _dataTableViewHeight = SCREEN_HEIGHT-140-64;
    //获取当前月份
    NSCalendar *calendar = [NSCalendar currentCalendar];
    _datecomps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:[NSDate date]];
    _yearAndMonthLabel.attributedText = [self getDateWithYear:_datecomps.year Month:_datecomps.month Index:0];
    
    //数据tableview
    _dataTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 140, SCREEN_WIDTH, _dataTableViewHeight) style:UITableViewStylePlain];
    _dataTableView.dataSource = self;
    _dataTableView.delegate = self;
    _dataTableView.backgroundColor = [UIColor clearColor];
    _dataTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:_dataTableView];
    _monthIndex = 0;
    
    //cell线到头
    if ([_dataTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_dataTableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }    //ios8SDK 兼容6 和 7 cell下划线
    if ([_dataTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_dataTableView  setLayoutMargins:UIEdgeInsetsZero];
    }
    __block InviteDetailViewController *inviteVC = self;
    [_dataTableView addHeaderWithCallback:^{
        [inviteVC requestDataWithMonthIndex:inviteVC->_monthIndex];
    } dateKey:@"InviteDetailData"];
    //点击屏幕重新加载数据手势
    _reloadDataTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(reloadDatatapAction)];

    [_dataTableView headerBeginRefreshing];
}
//点击屏幕重新加载数据
-(void)reloadDatatapAction
{
    [_dataTableView headerBeginRefreshing];
}

#pragma mark - 按月份请求获得邀请明细
- (void)requestDataWithMonthIndex:(NSInteger)monthIndex
{
    [self.view hideProgressLabel];
    NSString *monthStr = [NSString stringWithFormat:@"%ld",(long)monthIndex];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:self.login_user_token,@"token",monthStr,@"month",@"1",@"type",nil];
    RequestInterface *requestMoney = [[RequestInterface alloc] init];
    [requestMoney requestGetRewardDByRWithParam:dict];

    [requestMoney getInterfaceRequestObject:^(id data) {
        [ProjectUtil showLog:@"请求钱包钱数2data = %@",data];
        [self.view hideProgressLabel];
        if ([data[@"result"] isEqualToString:@"success"])
        {
            [_dataTableView headerEndRefreshing];
            _dataArr = [data objectForKey:@"record"];
            if (_dataArr.count==0)
            {
                [self.view showProgressLabelWithTitle:HintWithNoData ViewHeight:_dataTableViewHeight];
                
            }
            
            if ([monthStr isEqualToString:@"0"]&&_dataArr.count>0) {
                [self insertZhipuDBAllInfo:_dataArr WithReqName:[NSString stringWithFormat:@"GetRewardDByR_yqmx_%@",_login_User_name]];
                NSArray *countArr = [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:data[@"request"],@"request",data[@"count"],@"count", nil], nil];
//                [self insertZhipuDBAllInfo:_dataArr WithReqName:@"GetRewardDByR"];
                [self insertZhipuDBAllInfo:countArr WithReqName:[NSString stringWithFormat:@"GetRewardDByR_yqmxCount_%@",_login_User_name]];
            }

            _moneyAmountLabel.text = [NSString stringWithFormat:@"¥%@   已邀请%@人",data[@"request"],data[@"count"]];
            
        }
        else
        {
            [self.view showProgressLabelWithTitle:HintWithTapLoadData ViewHeight:_dataTableViewHeight];
            [self.view addGestureRecognizer:_reloadDataTap];
        }
        [_dataTableView reloadData];
        
    } Fail:^(NSError *error) {
        [self updateTableDataWithLocalDBWithMonth:monthStr];
    }];

}


//启用本地缓存的数据
- (void)updateTableDataWithLocalDBWithMonth:(NSString *)monthIndex
{
    _moneyAmountLabel.text = @"";
    [self.view makeToast:HintWithNetError];
    [_dataTableView headerEndRefreshing];
    [_dataTableView footerEndRefreshing];
    
    NSArray *infoArray  = [self doQueryZhipuDBAllInfo:[NSString stringWithFormat:@"GetRewardDByR_yqmx_%@",_login_User_name]];
    
    if (infoArray.count > 0&&[monthIndex isEqualToString:@"0"]) {
        _dataArr = infoArray;//[NSMutableArray arrayWithArray:infoArray];
        NSDictionary *countDict  = [[self doQueryZhipuDBAllInfo:[NSString stringWithFormat:@"GetRewardDByR_yqmxCount_%@",_login_User_name]] objectAtIndex:0];
        _moneyAmountLabel.text = [NSString stringWithFormat:@"¥%@   已邀请%@人",countDict[@"request"],countDict[@"count"]];

    }else{
        _dataArr = [NSArray array];
        [self.view hideProgressLabel];
        [self.view showProgressLabelWithTitle:HintWithTapLoadData ViewHeight:_dataTableViewHeight];
        [self.view addGestureRecognizer:_reloadDataTap];
    }
    [_dataTableView reloadData];
    
}

#pragma mark 更改月份
- (IBAction)changeMonthAction:(id)sender
{
    UIButton *changeBtn = (UIButton *)sender;
    NSInteger currentYear = [[_yearAndMonthLabel.text substringWithRange:NSMakeRange(_yearAndMonthLabel.text.length-4, 4)]integerValue];
    NSInteger currentMonth = [[_yearAndMonthLabel.text substringWithRange:NSMakeRange(0, _yearAndMonthLabel.text.length-5)]integerValue];
    NSInteger calculateIndex=0;
    [ProjectUtil showLog:[NSString stringWithFormat:@"month:%ld,year:%ld",(long)currentMonth,(long)currentYear]];
    if (changeBtn.tag==101)
    {
        //减月份
        calculateIndex-=1;
        _monthIndex-=1;

    }
    if (changeBtn.tag==102&&_monthIndex<0)
    {
        //加月份
        calculateIndex+=1;
        _monthIndex+=1;
    }
    _yearAndMonthLabel.attributedText = [self getDateWithYear:currentYear Month:currentMonth Index:calculateIndex];
    [_dataTableView headerBeginRefreshing];
}

#pragma mark UITableViewDataSource,UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return inviteCellHeight;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    if (cell==nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    //ios8SDK 兼容6 和 7
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    NSDictionary *dataDic = [_dataArr objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"¥%@元",[dataDic objectForKey:@"reward"]];
    cell.textLabel.font = Default_Font_15;
    cell.detailTextLabel.text = [[dataDic objectForKey:@"reg_time"]changeToMyDate];
    cell.detailTextLabel.font = Default_Font_15;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
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
