//
//  ChooseCustomViewController.m
//  SalesHelper_A
//
//  Created by summer on 14/12/24.
//  Copyright (c) 2014年 X. All rights reserved.
//

#import "ChooseCustomViewController.h"
#import "MJRefresh.h"
#import "ChooseCustomCell.h"

@interface ChooseCustomViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_dataArr;
    UITableView *_dataTableView;
    UITapGestureRecognizer *_reloadDataTap;
    CGFloat _dataTableViewHeight;
    CGFloat _cellHeight;
    NSInteger _currentPage;
    NSString *_dataSize;
}
@end

@implementation ChooseCustomViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self CreateCustomNavigtionBarWith:self leftItem:@selector(backToView) rightItem:nil];
    //创建标题
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-120)/2, 27, 120, 30)];
    titleLabel.text = @"选择客户";
    titleLabel.font = Default_Font_20;
    [titleLabel setTextColor:[UIColor whiteColor]];
    //    [titleLabel sizeToFit];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.topView addSubview: titleLabel];
    
    [self layoutSubViews];
    
//    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:21.0/255.0 green:159/255.0 blue:234/255.0 alpha:1]];
}
- (void)backToView
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)layoutSubViews
{
    _dataTableViewHeight = SCREEN_HEIGHT;
    _dataArr = [NSMutableArray array];
    _currentPage = 1;
    _dataSize = @"12";
    _cellHeight = 80.0;
    //数据tableview
    _dataTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH,_dataTableViewHeight) style:UITableViewStylePlain];
    _dataTableView.dataSource = self;
    _dataTableView.delegate = self;
    _dataTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
   
    
    //ios8SDK 兼容6 和 7 cell下划线
    if ([_dataTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_dataTableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    if ([_dataTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_dataTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    [self.view addSubview:_dataTableView];
    
    //刷新 数据表
    [self refarshTable];
   
    //点击屏幕重新加载数据 的 手势
    _reloadDataTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(reloadDatatapAction)];
    
    //请求数据
    [_dataTableView headerBeginRefreshing];
}
-(void)refarshTable
{
//    //上拉刷新
//    __block ChooseCustomViewController *chooseVC = self;
//    [_dataTableView addHeaderWithCallback:^{
//        chooseVC->_currentPage = 1;
//        [chooseVC requestRecommedRecordData];
//    } dateKey:@"chooseCustomtable"];
//    
//    [_dataTableView addFooterWithCallback:^{
//        chooseVC->_currentPage++;
//        [chooseVC requestRecommedRecordData];
//    }];
    //上拉刷新
    __block ChooseCustomViewController *chooseVC = self;
    [_dataTableView addHeaderWithCallback:^{
     //   chooseVC->_currentPage = 1;
        [chooseVC refreshingHeaderTableView];
    }];

        
        
    [_dataTableView addFooterWithCallback:^{
        
        //chooseVC->_currentPage++;
        [chooseVC refreshingFooterTableView];
    }];


}

-(void)refreshingHeaderTableView
{
    
//    pageIndex = 0;   崔相如 教我的 网络请求 方法
//    NSString * urlString = [NSString stringWithFormat:@"%@/SalesServers/GetPropertyInfos.do?key=6D698A30650512C5712AFFE9FC9294F3&page=%d&size=6&customization_token=0&district_id=1171&proportion_id=0&price_id=0",REQUEST_SERVER_URL,pageIndex];
//    URLRequest * request = [[URLRequest alloc] init];
//    //异步请求数据
//    [request startAsynchronizeGetRequestWithUrlString:urlString HTTPBodyDict:nil IsJsonAnalysis:YES];
//    [request getReceivedData:^(id data) {
//        if ([data [@"result"] isEqualToString:@"success"]) {
//            //x下拉刷新生成的时nsarray 不可添加的数组 给他移除 添加新的数据源
//            
//            [info removeAllObjects];
//            [info addObjectsFromArray:[data objectForKey:@"record"][0]];
//            [_tableView reloadData];
//            
//        }
//    } Fail:^(NSError *error) {
//        
//        
//    }];

    _currentPage=1;
    RequestInterface *request = [[RequestInterface alloc]init];
    [request requestGetRecRecordByCWithParam:@{@"status":@"10",@"name":@"",@"token":self.login_user_token,@"page":[NSString stringWithFormat:@"%ld",(long)_currentPage],@"size":_dataSize}];
    [request getInterfaceRequestObject:^(id data){
        [_dataTableView headerEndRefreshing];
        [_dataArr removeAllObjects];
        [_dataArr addObjectsFromArray:[data objectForKey:@"datas"]];
        [_dataTableView reloadData];
    } Fail:^(NSError * error){
        [_dataTableView headerEndRefreshing];
    }];
}

-(void)refreshingFooterTableView
{
    RequestInterface *request = [[RequestInterface alloc]init];
    [request requestGetRecRecordByCWithParam:@{@"status":@"10",@"name":@"",@"token":self.login_user_token,@"page":[NSString stringWithFormat:@"%ld",(long)_currentPage],@"size":_dataSize}];
    [request getInterfaceRequestObject:^(id data){
       
        if ([data[@"success"] boolValue])
        {
            NSArray* smallArr=[data objectForKey:@"datas"];
            [_dataArr addObjectsFromArray:smallArr];
            [_dataTableView reloadData];
            _currentPage++;
        }
        else
        {
            _currentPage--;
            [self.view makeToast:data[@"message"]];
        }
        
        [_dataTableView footerEndRefreshing];
       
    } Fail:^(NSError * error){
        _currentPage--;
        [_dataTableView footerEndRefreshing];
        
    }];



}
//点击屏幕重新加载数据
-(void)reloadDatatapAction
{
     [_dataTableView headerBeginRefreshing];
}

//-(void)requestRecommedRecordData
//{
//    [self.view hideProgressLabel];
//    [self.view removeGestureRecognizer:_reloadDataTap];
//    RequestInterface *request = [[RequestInterface alloc]init];
//    [request requestGetRecRecordByCWithParam:@{@"status":@"10",@"name":@"",@"token":self.login_user_token,@"page":[NSString stringWithFormat:@"%ld",(long)_currentPage],@"size":_dataSize}];
//
//    [request getInterfaceRequestObject:^(id data) {
//        if (_dataTableView.headerRefreshing)
//        {
//            [_dataArr removeAllObjects];
//        }
//        [ProjectUtil showLog:@"GetRecRecordByCdata:%@",data];
//        [self.view hideProgressLabel];
//
//        NSArray *recordArr = [data objectForKey:@"datas"];
//        if ([[data objectForKey:@"success"]boolValue])
//        {
//            [self.view removeGestureRecognizer:_reloadDataTap];
//            if (recordArr.count==0)
//            {
//                if (_currentPage==1)
//                {
//                    [self.view showProgressLabelWithTitle:HintWithNoData ViewHeight:_dataTableViewHeight];
//                }
//                
//                [self.view makeToast:HintWithNoMoreData];
//            }
//            else
//            {
//                //[_dataArr addObjectsFromArray:[self resetDataWithRecordArr:recordArr]];
//            }
//            
//        }
//        else
//        {
//           
//            if (_currentPage==1)
//            {
//                [self.view showProgressLabelWithTitle:HintWithTapLoadData ViewHeight:_dataTableViewHeight];
//                [self.view addGestureRecognizer:_reloadDataTap];
//            }
//             [self.view makeToast:data[@"message"]];
//        }
//        [_dataTableView reloadData];
//        [_dataTableView headerEndRefreshing];
//        [_dataTableView footerEndRefreshing];
//        
//    } Fail:^(NSError *error) {
//        if (_dataTableView.headerRefreshing)
//        {
//            [_dataArr removeAllObjects];
//             [self.view hideProgressLabel];
//            [self.view showProgressLabelWithTitle:HintWithTapLoadData ViewHeight:_dataTableViewHeight];
//            [self.view addGestureRecognizer:_reloadDataTap];
//        }
//        [_dataTableView reloadData];
//       [self.view makeToast:HintWithNetError];
//        [_dataTableView headerEndRefreshing];
//        [_dataTableView footerEndRefreshing];
//    }];
//    
//}

//调整数据结构
//-(NSArray *)resetDataWithRecordArr:(NSArray *)recordArr
//{
//    NSMutableArray *tempArr = [NSMutableArray array];
//    
//    for (NSDictionary *recordDic in recordArr)
//    {
//        NSString *timeStr = [recordDic objectForKey:@"time"];
//        NSArray *infoArr = [recordDic objectForKey:@"infos"];
//        for (NSDictionary *infosDic in infoArr)
//        {
//            NSString *nameStr = [infosDic objectForKey:@"name"];
//            NSString *phoneStr = [infosDic objectForKey:@"phone"];
//            NSArray *recommendRecordArr = [infosDic objectForKey:@"recommendRecords"];
//            for (NSDictionary *recommendDic in recommendRecordArr)
//            {
//                NSString *houseStr = [[recommendDic objectForKey:@"object"]objectForKey:@"property"];
//                NSString *developerId = [[recommendDic objectForKey:@"object"]objectForKey:@"developer_id"];
//                NSString *recordId = [[recommendDic objectForKey:@"object"]objectForKey:@"id"];
//                         NSString *houseId = [[recommendDic objectForKey:@"object"]objectForKey:@"property_id"];
//                NSString *statusStr = [[recommendDic objectForKeyedSubscript:@"object"]objectForKey:@"status"];
//                NSDictionary *dataDic = [NSDictionary dictionaryWithObjectsAndKeys:timeStr,@"time",nameStr,@"name",phoneStr,@"phone",houseStr,@"house",developerId,@"developer_id",recordId,@"id",houseId,@"property_id",statusStr,@"status",nil];
//                [tempArr addObject:dataDic];
//            }
//        }
//    }
//    
//    return [NSArray arrayWithArray:tempArr];
//}


-(void)requestRecommedRecordData
{
    [self.view hideProgressLabel];
    [self.view removeGestureRecognizer:_reloadDataTap];
    RequestInterface *request = [[RequestInterface alloc]init];
    [request requestGetRecRecordByCWithParam:@{@"status":@"10",@"name":@"",@"token":self.login_user_token,@"page":[NSString stringWithFormat:@"%ld",(long)_currentPage],@"size":_dataSize}];
    
    [request getInterfaceRequestObject:^(id data) {
        if (_dataTableView.headerRefreshing)
        {
            [_dataArr removeAllObjects];
            [_dataTableView headerEndRefreshing];
            [_dataTableView footerEndRefreshing];

        }
        [ProjectUtil showLog:@"GetRecRecordByCdata:%@",data];
        [self.view hideProgressLabel];
        
        _dataArr = [data objectForKey:@"datas"];
        if ([[data objectForKey:@"success"]boolValue])
        {
            [self.view removeGestureRecognizer:_reloadDataTap];
            if (_dataArr.count==0)
            {
                if (_currentPage==1)
                {
                    [self.view showProgressLabelWithTitle:HintWithNoData ViewHeight:_dataTableViewHeight];
                }
                
                [self.view makeToast:HintWithNoMoreData];
            }
            else
            {
                //[_dataArr addObjectsFromArray:[self resetDataWithRecordArr:recordArr]];
            }
            
        }
        else
        {
            
            if (_currentPage==1)
            {
                [self.view showProgressLabelWithTitle:HintWithTapLoadData ViewHeight:_dataTableViewHeight];
                [self.view addGestureRecognizer:_reloadDataTap];
            }
            [self.view makeToast:data[@"message"]];
        }
        [_dataTableView reloadData];
        [_dataTableView headerEndRefreshing];
        [_dataTableView footerEndRefreshing];
        
    } Fail:^(NSError *error) {
        if (_dataTableView.headerRefreshing)
        {
            [_dataArr removeAllObjects];
            [self.view hideProgressLabel];
            [self.view showProgressLabelWithTitle:HintWithTapLoadData ViewHeight:_dataTableViewHeight];
            [self.view addGestureRecognizer:_reloadDataTap];
        }
        [_dataTableView reloadData];
        [self.view makeToast:HintWithNetError];
        [_dataTableView headerEndRefreshing];
        [_dataTableView footerEndRefreshing];
    }];
    
}


#pragma mark UITableViewDataSource,UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _cellHeight;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    ChooseCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"ChooseCustomCell" owner:self options:nil]lastObject];
    }
    //ios8SDK 兼容6 和 7
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }

    NSDictionary *dataDic = [_dataArr objectAtIndex:indexPath.row];
    NSString *customStr = [dataDic objectForKey:@"name"];
    NSString *statusStr = [dataDic objectForKey:@"stepName"];
    NSString *customNameStr = [NSString stringWithFormat:@"%@（%@）",customStr,statusStr];
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:customNameStr];
    [attributedStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11],NSForegroundColorAttributeName:RGBCOLOR(250, 0, 20)} range:NSMakeRange(customStr.length, attributedStr.length-customStr.length)];
        cell.customNameLabel.attributedText =attributedStr;
        cell.houseNameLabel.text = [dataDic objectForKey:@"propertyName"];
        cell.phoneLabel.text = [NSString stringWithFormat:@"手机号：%@",[dataDic objectForKey:@"phone"]];
        cell.recommendDateLabel.text = [NSString stringWithFormat:@"推荐日期：%@",[dataDic objectForKey:@"refereeDate"]];
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.navigationController popViewControllerAnimated:YES];
    [self.delegate getChoosedCustomInfo:[_dataArr objectAtIndex:indexPath.row]];
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
