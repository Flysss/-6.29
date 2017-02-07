//
//  BankCardViewController.m
//  SalesHelper_A
//
//  Created by Reconcilie on 14/10/25.
//  Copyright (c) 2014年 zhipu. All rights reserved.
//

#import "BankCardViewController.h"
#import "AddBankCardViewController.h"
#import "EditionBankViewController.h"

#define TABLE_HEIGHT 60

@interface BankCardViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_bankCardTableView;
    NSArray *_bankNameArray;//银行卡张数
    
    UILabel *_noticeBankLabel;
}

@end

@implementation BankCardViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = YES;
     [self requestGetWithd];
}
- (void)viewDidLoad {
    [super viewDidLoad];

    [self CreateCustomNavigtionBarWith:self leftItem:@selector(backToView) rightItem:nil];
    //创建标题
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-120)/2, 27, 120, 30)];
    titleLabel.text = @"我的银行卡";
    titleLabel.font = Default_Font_20;
    [titleLabel setTextColor:[UIColor whiteColor]];
    //    [titleLabel sizeToFit];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.topView addSubview: titleLabel];
    _bankNameArray = [[NSArray alloc] init];
    
    _bankCardTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64+10, SCREEN_WIDTH, MIN(SCREEN_HEIGHT, _bankNameArray.count*TABLE_HEIGHT))];
    _bankCardTableView.delegate = self;
    _bankCardTableView.dataSource = self;
    _bankCardTableView.backgroundColor = [UIColor clearColor];
    _bankCardTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    if ([_bankCardTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_bankCardTableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    //ios8SDK 兼容6 和 7 cell下划线
    if ([_bankCardTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_bankCardTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    _bankCardTableView.hidden = YES;
    [self.view addSubview:_bankCardTableView];
    
}
- (void)backToView
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _bankNameArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return TABLE_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        //ios8SDK 兼容6 和 7
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        
        //银行卡信息
//        UIView *acountView = [[UIView alloc] initWithFrame:CGRectMake(10, 5, SCREEN_WIDTH-20, 50)];
//        acountView.layer.cornerRadius = 5;
//        acountView.backgroundColor = [UIColor whiteColor];
//        [cell.contentView addSubview:acountView];
        
        UIImageView *bankImage = [[UIImageView alloc] initWithFrame:CGRectMake(8, 15, 40, 26)];
        bankImage.tag = 150;
        [cell.contentView addSubview:bankImage];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 5, 200, 30)];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.font = Default_Font_15;
        nameLabel.tag = 100;
        [cell.contentView addSubview:nameLabel];
        
        UILabel *numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 27, 200, 30)];
        numberLabel.backgroundColor = [UIColor clearColor];
        numberLabel.font = [UIFont systemFontOfSize:12];
        numberLabel.textColor = [UIColor lightGrayColor];
        numberLabel.tag = 101;
        [cell.contentView addSubview:numberLabel];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if (_bankNameArray.count >0) {
        UIImageView *bankImageView = (UIImageView *)[cell.contentView viewWithTag:150];
        [bankImageView sd_setImageWithURL:[NSURL URLWithString:_bankNameArray[indexPath.row][@"bankIcon"]]];
        
        UILabel *name = (UILabel *)[cell.contentView viewWithTag:100];
        name.text = _bankNameArray[indexPath.row][@"name"];
        
        UILabel *number = (UILabel *)[cell.contentView viewWithTag:101];
        NSString *bankNumber = _bankNameArray[indexPath.row][@"account"];
        number.text = [NSString stringWithFormat:@"尾号%@",[bankNumber substringFromIndex:bankNumber.length -4]];//@"尾号0972 ";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    EditionBankViewController *editionVC = [[EditionBankViewController alloc] init];
    editionVC.bankDictInfo = _bankNameArray[indexPath.row];
    editionVC.title = @"银行卡详情";
//    [editionVC creatBackButtonWithPushType:Push With:@"我的" Action:nil];
    [self.navigationController pushViewController:editionVC animated:YES];
}

#pragma mark --添加银行卡
- (void)addBankInfo:(UIButton *)sender
{
    AddBankCardViewController *bankVC = [[AddBankCardViewController alloc] init];
    bankVC.title = @"添加银行卡";
    [bankVC creatBackButtonWithPushType:Push With:@"返回" Action:nil];
    [self.navigationController pushViewController:bankVC animated:YES];
}

//获取银行卡列表 GetWithd_wdyhk_
- (void)requestGetWithd
{
    NSDictionary *dict = @{@"token":self.login_user_token,
                           @"page":@"1",
                           @"size":@"10000"
                           };
    [self.view makeProgressViewWithTitle:ProgressString];
    RequestInterface *requestOp = [[RequestInterface alloc] init];
    [requestOp requestGetWithdWithParam:dict];
    
    [requestOp getInterfaceRequestObject:^(id data) {
        [ProjectUtil showLog:@"data = %@",data];
        [self.view hideProgressView];
        if ([data[@"success"] boolValue]) {
            _bankNameArray = data[@"datas"];
            if (_bankNameArray.count>0) {
                [self insertZhipuDBAllInfo:_bankNameArray WithReqName:[NSString stringWithFormat:@"bankIcon%@",_login_User_name]];//我的银行卡
            }
            [ProjectUtil showLog:@"_bankNameArray  =   %d",_bankNameArray.count];
            [self reloadBankListView];
        }

    } Fail:^(NSError *error) {
        
         [self updateTableDataWithLocalDB];
        

    }];
}

//启用本地缓存的数据
- (void)updateTableDataWithLocalDB
{
    _bankNameArray = [NSArray array];

    [self.view hideProgressView];
    [self.view makeToast:HintWithNetError];
    
    NSArray *infoArray  = [self doQueryZhipuDBAllInfo:[NSString stringWithFormat:@"GetWithd_wdyhk_%@",_login_User_name]];//从本地数据库取出我的银行卡
    
    if (infoArray.count > 0) {
        _bankNameArray = [NSMutableArray arrayWithArray:infoArray];
    }
    [self reloadBankListView];
}

- (IBAction)addBankBtnAction:(id)sender
{
    AddBankCardViewController *bankVC = [[AddBankCardViewController alloc] init];
    bankVC.title = @"添加银行卡";
//    [bankVC creatBackButtonWithPushType:Push With:@"返回" Action:nil];
    [self.navigationController pushViewController:bankVC animated:YES];
}


- (void)reloadBankListView
{
    _bankCardTableView.frame = CGRectMake(0, 64, SCREEN_WIDTH, MIN(SCREEN_HEIGHT, _bankNameArray.count*TABLE_HEIGHT));
    if (_bankCardTableView.frame.size.height < SCREEN_HEIGHT+10) {
        _bankCardTableView.bounces = NO;
    }
    _bankCardTableView.hidden = NO;
    [_bankCardTableView reloadData];
    [self.view hideProgressLabel];
    if (!(_bankNameArray.count > 0))
    {
        self.bankLogoImageView.hidden = NO;
        self.addBankLabel.hidden = NO;
        self.addBankBtn.hidden = NO;
        self.addBankBtn.layer.cornerRadius = 20.0;
        self.addTipLabel.hidden = NO;
        self.navigationItem.rightBarButtonItems = nil;
    }
    else
    {
        self.bankLogoImageView.hidden = YES;
        self.addBankLabel.hidden = YES;
        self.addBankBtn.hidden = YES;
        self.addTipLabel.hidden = YES;
        
        UIButton *rightBtn = [self creatUIButtonWithFrame:CGRectMake(0, 20, 40, 30) BackgroundColor:nil Title:@"添加" TitleColor:NavigationBarTitleColor Action:@selector(addBankInfo:)];
        [rightBtn setTitleEdgeInsets:UIEdgeInsetsMake(2.0, 3.0, 0.0, 0.0)];
        if (IOS_VERSION<7.0)
        {
            rightBtn.titleEdgeInsets = UIEdgeInsetsMake(2.0, -10.0, 0, 0.0);
        }
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:[self creatNegativeSpacerButton],[[UIBarButtonItem alloc] initWithCustomView:rightBtn], nil];
    }

    
}

@end
