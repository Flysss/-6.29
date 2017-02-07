//
//  WithdrawDetailViewController.m
//  SalesHelper_A
//
//  Created by summer on 14/12/20.
//  Copyright (c) 2014年 X. All rights reserved.
//

#import "WithdrawAccountViewController.h"
#import "MyPayCenterViewController.h"
#import "BankCardViewController.h"

@interface WithdrawAccountViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_detailTableView;
    NSArray *_detailData;
}

@end

@implementation WithdrawAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:21.0/255.0 green:159/255.0 blue:234/255.0 alpha:1]];
    [self CreateCustomNavigtionBarWith:self leftItem:@selector(backToView) rightItem:nil];
    //创建标题
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-120)/2, 27, 120, 30)];
    titleLabel.text = @"我的银行卡";
    titleLabel.font = Default_Font_20;
    [titleLabel setTextColor:[UIColor whiteColor]];
    //    [titleLabel sizeToFit];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.topView addSubview: titleLabel];
    
    _detailData = @[@"我的银行卡"];
    _detailTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 10+64, SCREEN_WIDTH, _detailData.count*44)];
    _detailTableView.backgroundColor = [UIColor clearColor];
    
    _detailTableView.delegate = self;
    _detailTableView.dataSource = self;
    _detailTableView.bounces = NO;
    
    if ([_detailTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_detailTableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    //ios8SDK 兼容6 和 7 cell下划线
    if ([_detailTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_detailTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    [self.view addSubview:_detailTableView];
}

-(void)backToView
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
    return _detailData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        //ios8SDK 兼容6 和 7
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
    }
    
//    if (indexPath.row == 0) {
//        NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"zfb" ofType:@"png"];
//        cell.imageView.image = [UIImage imageWithContentsOfFile:imagePath];
//    }else if (indexPath.row == 1) {
        NSString *imagePath2 = [[NSBundle mainBundle] pathForResource:@"yhk" ofType:@"png"];
        cell.imageView.image = [UIImage imageWithContentsOfFile:imagePath2];
//    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = _detailData[indexPath.row];
    cell.textLabel.font = Default_Font_15;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

//    if (indexPath.row == 0) {
//        pushVC = (MyPayCenterViewController *)[[MyPayCenterViewController alloc] init];
//        pushVC.title = @"我的支付宝";
//    }else if (indexPath.row == 1) {
        BankCardViewController *bankVC = [[BankCardViewController alloc] init];
        bankVC.title = @"银行卡详情";
        [bankVC creatBackButtonWithPushType:Push With:@"我的 " Action:nil];
//    }

        [self.navigationController pushViewController:bankVC animated:YES];

    
}

@end
