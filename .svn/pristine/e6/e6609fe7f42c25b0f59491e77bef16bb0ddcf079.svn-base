//
//  MsgViewController.m
//  SalesHelper_A
//
//  Created by Brant on 16/2/19.
//  Copyright © 2016年 X. All rights reserved.
//

#import "MsgViewController.h"
#import "SearchHistViewController.h"
#import "TieziTableViewCell.h"
#import "BHMessageCell.h"


@interface MsgViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
@property (nonatomic, strong) UITableView *m_tableView;
@property (nonatomic, strong) UIButton *m_searchBtn;

@end

@implementation MsgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self creatnavi];
    
    [self creatSearchButton];
    
    [self creatTableView];
}

#pragma mark --创建导航栏
- (void)creatnavi
{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 11, 22)];
    [button setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateHighlighted];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [button addTarget:self action:@selector(backToPop) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    UILabel *titlelael = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    titlelael.font = Default_Font_19;
    titlelael.text = @"消息";
    titlelael.textAlignment = NSTextAlignmentCenter;
    titlelael.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titlelael;
    
}

- (void)backToPop
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --创建搜索框
- (void)creatSearchButton
{
    self.m_searchBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 7, SCREEN_WIDTH-20, 36)];
    self.m_searchBtn.backgroundColor = [UIColor hexChangeFloat:@"ebebeb"];
    [self.m_searchBtn setImage:[UIImage imageNamed:@"Search"] forState:UIControlStateNormal];
    [self.m_searchBtn setImage:[UIImage imageNamed:@"Search"] forState:UIControlStateHighlighted];
    [self.m_searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [self.m_searchBtn setTitleColor:[UIColor hexChangeFloat:@"dadadc"] forState:UIControlStateNormal];
    self.m_searchBtn.titleLabel.font = Default_Font_15;
    self.m_searchBtn.layer.cornerRadius = 5;
    self.m_searchBtn.layer.masksToBounds = YES;
    [self.m_searchBtn addTarget:self action:@selector(pushToSearch) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.m_searchBtn];
}
- (void)pushToSearch
{
    SearchHistViewController *vc = [[SearchHistViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark --创建列表
- (void)creatTableView
{
    self.m_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, SCREEN_HEIGHT-64-50) style:UITableViewStylePlain];
    self.m_tableView.delegate = self;
    self.m_tableView.dataSource = self;
    self.m_tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.m_tableView];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BHMessageCell *cell = (BHMessageCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[BHMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"%@", indexPath]];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSDictionary *dic = [NSDictionary dictionary];
    [cell configTableViewWithDic:dic];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


//将列表的分割线从头开始
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
