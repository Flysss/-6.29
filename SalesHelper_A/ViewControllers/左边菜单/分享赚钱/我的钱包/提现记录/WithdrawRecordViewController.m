//
//  WithdrawRecordViewController.m
//  SalesHelper_A
//
//  Created by summer on 14/12/20.
//  Copyright (c) 2014年 X. All rights reserved.
//
//选择线缩短长度
#define MARGIN 10.0

#import "WithdrawRecordViewController.h"
#import "RecordTableViewCell.h"
#import "MJRefresh.h"


@interface WithdrawRecordViewController () <UITableViewDataSource,UITableViewDelegate>
{
    CGFloat _dataTableViewHeight;
    NSInteger _currentPage;
    UITapGestureRecognizer *_reloadDataTap;
    NSMutableArray *_dataArr;
    NSString *_dataSize;
    NSString *_currentDataStr;
}
@property (nonatomic,weak) UIView *buttonView;
@property (nonatomic,strong) NSMutableArray *buttons;
@property (nonatomic,weak) UIView *viewLine;
@property (nonatomic,weak) UITableView *tableView;
@end

@implementation WithdrawRecordViewController
@synthesize buttonView = _buttonView,buttons = _buttons,viewLine = _viewLine,tableView = _tableView;
- (void)viewDidLoad {
    [super viewDidLoad];
  
    [self layoutSubViews];
    //默认选中第一个
    UIButton *button = self.buttons[0];
    button.selected = YES;
}

- (void)layoutSubViews
{
    //添加按钮
    [self creatButton];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:21.0/255.0 green:159/255.0 blue:234/255.0 alpha:1]];
    //初始化常量
      _dataSize = @"10";
    _dataTableViewHeight = SCREEN_HEIGHT-64-60;
    _dataArr = [NSMutableArray array];
    _currentPage = 1;
    _currentDataStr = @"1";
    //按钮父视图高度
    CGFloat buttonViewH = 40;
    CGFloat buttonViewY = 10;
    
    self.buttonView.frame = CGRectMake(-1, buttonViewY, self.view.frame.size.width+2, 40);
    CGFloat buttonY = 0;
    CGFloat buttonW = self.view.frame.size.width / self.buttons.count;
    CGFloat buttonH = buttonViewH;
    for (int i=0; i<self.buttons.count; i++) {
        
        UIButton *button = self.buttons[i];
        CGFloat buttonX = i * buttonW;
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
    }
    
    CGFloat lineW = buttonW - (2 * MARGIN);
    CGFloat lineX = buttonW - lineW - MARGIN;
    self.viewLine.frame = CGRectMake(lineX, 48, lineW, 2);
    
    
    //表格
    UITableView *tableView = [[UITableView alloc] init];

    self.tableView = tableView;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 60;
    self.tableView.frame = CGRectMake(0, 60, SCREEN_WIDTH, _dataTableViewHeight);
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    //cell线到头
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }    //ios8SDK 兼容6 和 7 cell下划线
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView  setLayoutMargins:UIEdgeInsetsZero];
    }
        [self.view addSubview:tableView];
    
    //上拉刷新
    __block WithdrawRecordViewController *withdrawRVC = self;
    [_tableView addHeaderWithCallback:^{
        [self tapAction];
    } dateKey:@"withdrawRecordTable"];
    
    //下拉刷新
    [_tableView addFooterWithCallback:^{
        withdrawRVC->_currentPage++;
        [withdrawRVC requestData];
    }];
    //点击屏幕重新加载数据手势
    _reloadDataTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(requestData)];
    [_tableView headerBeginRefreshing];
}

-(void)tapAction
{
    [_dataArr removeAllObjects];
    _currentPage = 1;
    [self requestData];
}

//创建按钮
- (void)creatButton
{
    UIView *buttonView = [[UIView alloc] init];
    self.buttonView = buttonView;

    buttonView.backgroundColor = [UIColor whiteColor];
    buttonView.layer.borderWidth = 1;
    buttonView.layer.borderColor = [[UIColor colorWithRed:215/255.0 green:215/255.0 blue:215/255.0 alpha:1.0] CGColor];
    [self.view addSubview:buttonView];
    
    [self addButtonWithTitle:@"近一周" tag:0];
     [self addButtonWithTitle:@"近一个月" tag:1];
    [self addButtonWithTitle:@"全部" tag:2];
   
    //添加选中线
   UIView *viewLine = [[UIView alloc] init];
    viewLine.backgroundColor = LeftMenuVCBackColor;
    [self.view addSubview:viewLine];
    self.viewLine = viewLine;
    
    
}

//添加按钮
- (void)addButtonWithTitle:(NSString *)title tag:(int)tag
{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = tag;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:RGBCOLOR(139, 139, 139) forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [button addTarget:self action:@selector(buttonClike:) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonView addSubview:button];
    [self.buttons addObject:button];
}

//按钮点击
- (void)buttonClike:(UIButton *)button
{
    
    CGRect buttonF = button.frame;
    CGRect lineF = self.viewLine.frame;
    lineF.origin.x = button.tag * buttonF.size.width + MARGIN;
    self.viewLine.frame = lineF;
    if (button.tag==0)
    {//近一个月
        _currentDataStr = @"1";
    }else if (button.tag==1)
    {//近一周
        _currentDataStr = @"2";
    }else
    {//全部
        _currentDataStr = @"0";
    }
    [self tapAction];
 
}
//请求数据
-(void)requestData
{
    [self.view hideProgressLabel];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:self.login_user_token,@"token",_currentDataStr,@"date",[NSString stringWithFormat:@"%ld",(long)_currentPage],@"page",_dataSize,@"size",nil];

    RequestInterface *requestOp = [[RequestInterface alloc] init];
    [requestOp requestGetWithdRecordWithParam:dict];
    [requestOp getInterfaceRequestObject:^(id data) {
        [ProjectUtil showLog:@"GetRecRecordByCdata:%@",data];
        [self.view hideProgressLabel];

        NSArray *recordArr = [data objectForKey:@"record"];
        if ([[data objectForKey:@"result"]isEqualToString:@"success"])
        {
            if (recordArr.count==0)
            {
                if (_currentPage==1)
                {
                    [self.view showProgressLabelWithTitle:HintWithNoData ViewHeight:_dataTableViewHeight];
                }
                [self.view makeToast:HintWithNoMoreData];
            }
            else
            {
                [_dataArr addObjectsFromArray:recordArr];
            }
            
            if (_dataArr.count>0) {
                [self insertZhipuDBAllInfo:_dataArr WithReqName:[NSString stringWithFormat:@"GetWithdRecord_%@_%@",_currentDataStr,_login_User_name]];
            }
            
            
        }
        else
        {
            if (_currentPage==1)
            {
                [self.view showProgressLabelWithTitle:HintWithTapLoadData ViewHeight:_dataTableViewHeight];
                [self.view addGestureRecognizer:_reloadDataTap];
            }
            [self.view makeToast:data[@"error_remark"]];
        }
        
        
        [_tableView reloadData];
        [_tableView headerEndRefreshing];
        [_tableView footerEndRefreshing];
        
    } Fail:^(NSError *error) {
        [self updateTableDataWithLocalDB];
    }];

    
}

//启用本地缓存的数据
- (void)updateTableDataWithLocalDB
{
    [self.view makeToast:HintWithNetError];
    [_tableView headerEndRefreshing];
    [_tableView footerEndRefreshing];
    
    NSArray *infoArray  = [self doQueryZhipuDBAllInfo:[NSString stringWithFormat:@"GetWithdRecord_%@_%@",_currentDataStr,_login_User_name]];
    
    if (infoArray.count > 0) {
        _dataArr = [NSMutableArray arrayWithArray:infoArray];
    }else{
        [_dataArr removeAllObjects];
        [self.view hideProgressLabel];
        [self.view showProgressLabelWithTitle:HintWithTapLoadData ViewHeight:_dataTableViewHeight];
        [self.view addGestureRecognizer:_reloadDataTap];
    }
    [_tableView reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//按钮数组
- (NSMutableArray *)buttons
{
    if (_buttons==nil) {
        _buttons = [NSMutableArray array];
    }
    
    return _buttons;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return _dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    static NSString *identifier = @"recordCell";
    RecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell==nil)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"RecordTableViewCell" owner:self options:nil] lastObject];
        
    }
    
    //ios8SDK 兼容6 和 7
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    NSDictionary *dataDic = [_dataArr objectAtIndex:indexPath.row];
    NSString *drawMethods = nil;
    if ([[dataDic objectForKey:@"withdraw_type"]integerValue]==0)
    {
        drawMethods = @"银行卡取现";
    }
    else
    {
        drawMethods = @"支付宝取现";
    }
    cell.drawMethods.text = drawMethods;
    cell.amount.text = [NSString stringWithFormat:@"金额：¥%@元",[dataDic objectForKey:@"withdraw_sum"]];
    cell.time.text = [[dataDic objectForKey:@"withdraw_time"]changeToMyDate];
    cell.state.text = [dataDic objectForKey:@"withdraw_result"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end
