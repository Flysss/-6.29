//
//  SelectBankTypeViewController.m
//  SalesHelper_A
//
//  Created by zhipu on 14/11/13.
//  Copyright (c) 2014年 zhipu. All rights reserved.
//

#import "SelectBankTypeViewController.h"

@interface SelectBankTypeViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *_tableData;
    NSDictionary *_selectBankDict;
    
    UITapGestureRecognizer *_reloadDataTap;
    
    CGFloat _dataTableViewHeight;
}

@end

@implementation SelectBankTypeViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:21.0/255.0 green:159/255.0 blue:234/255.0 alpha:1]];
    
    [self CreateCustomNavigtionBarWith:self leftItem:@selector(backToView) rightItem:nil];
    //创建标题
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-120)/2, 27, 120, 30)];
    titleLabel.text = @"选择银行卡";
    titleLabel.font = Default_Font_20;
    [titleLabel setTextColor:[UIColor whiteColor]];
    //    [titleLabel sizeToFit];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.topView addSubview: titleLabel];
    
    _dataTableViewHeight = SCREEN_HEIGHT;
    
    //点击屏幕重新加载数据手势
    _reloadDataTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(reloadDatatapAction)];
    

    [self requestGetHouseAttribute:@"6"];
}
- (void)backToView
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//银行名称
- (void)requestGetHouseAttribute:(NSString *)type
{
    NSDictionary *dict = @{@"page":@"1",
                           @"size":@"10000"
                           };
    RequestInterface *requestHOp = [[RequestInterface alloc] init];
    [requestHOp requestGetAllbankWithParam:dict];
    [self.view hideProgressLabel];
    [self.view showProgressLabel];
    
    [self.view removeGestureRecognizer:_reloadDataTap];
    [requestHOp getInterfaceRequestObject:^(id data) {
        [self.view hideProgressLabel];
        [ProjectUtil showLog:@"data = %@",data];
        if ([data[@"success"] boolValue]) {
            _tableData = data[@"datas"];
            _selectBankDict = _tableData[0];
            [self layoutSubViews];
        }else {
            [self.view showProgressLabelWithTitle:HintWithTapLoadData ViewHeight:_dataTableViewHeight];
            [self.view addGestureRecognizer:_reloadDataTap];
            [self.view makeToast:data[@"error_remark"]];
        }
        
    } Fail:^(NSError *error) {
         [self.view hideProgressLabel];
        [self.view showProgressLabelWithTitle:HintWithTapLoadData ViewHeight:_dataTableViewHeight];
        [self.view addGestureRecognizer:_reloadDataTap];
        [self.view makeToast:HintWithNetError];
    }];
}

#pragma mark - UITapGestureRecognizer

- (void)reloadDatatapAction
{
    [self requestGetHouseAttribute:@"6"];
}


- (void)layoutSubViews
{
    UITableView *bankTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,64, SCREEN_WIDTH, _tableData.count * 44)];
    if (bankTableView.height < SCREEN_HEIGHT-64.0) {
        bankTableView.bounces = NO;
    }
    bankTableView.delegate = self;
    bankTableView.dataSource = self;
  
    if ([bankTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [bankTableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    //ios8SDK 兼容6 和 7 cell下划线
    if ([bankTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [bankTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    [self.view addSubview:bankTableView];
    
    UILabel *tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, bankTableView.bottom+20, SCREEN_WIDTH, 30)];
    tipLabel.text = @"注：暂只支持以上银行";
    tipLabel.backgroundColor = [UIColor clearColor];
    tipLabel.font = Default_Font_13;
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.textColor = [UIColor grayColor];
    [self.view addSubview:tipLabel];
    
    
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _tableData.count;
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
        
        UIImageView *bankImage = [[UIImageView alloc] initWithFrame:CGRectMake(8, 10, 29, 19)];
        bankImage.tag = 700;
        [cell.contentView addSubview:bankImage];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 5, 200, 30)];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.font = Default_Font_14;
        nameLabel.tag = 710;
        [cell.contentView addSubview:nameLabel];
        
        
        UIImageView *selectImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 35, 18, 18, 14)];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"pitchon" ofType:@"png"];
        selectImageView.image = [UIImage imageWithContentsOfFile:path];
        
        selectImageView.tag = 800;
        [cell.contentView addSubview:selectImageView];
    }
    
    UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:800];
    if (indexPath.row == self.selectedItemIndex)
    {
        imageView.hidden = NO;
    }else {
        imageView.hidden = YES;
    }

    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    UIImageView *bankImageView = (UIImageView *)[cell.contentView viewWithTag:700];
    [bankImageView sd_setImageWithURL:[NSURL URLWithString:_tableData[indexPath.row][@"icon"]] placeholderImage:nil];
      
    UILabel *name = (UILabel *)[cell.contentView viewWithTag:710];
    name.text = _tableData[indexPath.row][@"name"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    UITableViewCell *selectCell;
    for (int i = 0; i < _tableData.count; i++) {
        selectCell = (UITableViewCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        UIImageView *imageView = (UIImageView *)[selectCell viewWithTag:800];
        if (i == indexPath.row) {
            imageView.hidden = NO;
            _selectBankDict = _tableData[i];
        }else {
            imageView.hidden = YES;
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    [self.delegate callBackWithBankInfo:_selectBankDict Index:indexPath.row];
    
}


@end
