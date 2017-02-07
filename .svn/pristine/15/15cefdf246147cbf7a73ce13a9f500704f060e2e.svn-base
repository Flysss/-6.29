//
//  NoticeViewController.m
//  SalesHelper_A
//
//  Created by summer on 15/1/6.
//  Copyright (c) 2015年 X. All rights reserved.
//

#import "NoticeViewController.h"
#import "MJRefresh.h"
#import "NoticeCell.h"
#import "ModelWebViewController.h"

@interface NoticeViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_dataArr;
    UITableView *_dataTableView;
    UITapGestureRecognizer *_reloadDataTap;
    CGFloat _dataTableViewHeight;
    NSInteger _currentPage;
    CGFloat _cellHeight;
    
}
@end

@implementation NoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutSubViews];
    [self layoutdaohangpicture];
    
}
-(void)layoutdaohangpicture
{

    UILabel* titlelabel=[UILabel new];
    titlelabel.text=@"最新公告";
    [titlelabel sizeToFit];
    titlelabel.font=Default_Font_18;
    [titlelabel setTextColor:[UIColor whiteColor]];
    self.navigationItem.titleView=titlelabel;

    
    UIButton* backbtn=[UIButton buttonWithType:UIButtonTypeCustom];
    backbtn.frame=CGRectMake(0, 0, 26, 26);
    [backbtn setBackgroundImage:[UIImage imageNamed:@"首页-左箭头.png"] forState:UIControlStateNormal];
    [backbtn setBackgroundImage:[UIImage imageByApplyingAlpha:[UIImage imageNamed:@"首页-左箭头.png"]] forState:UIControlStateHighlighted];

    [backbtn addTarget:self action:@selector(backlastView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* back_item = [[UIBarButtonItem alloc]initWithCustomView:backbtn];
    self.navigationItem.leftBarButtonItem = back_item;
}

- (void)backlastView
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)layoutSubViews
{
    _dataTableViewHeight = SCREEN_HEIGHT-64.0;
    _dataArr = [NSMutableArray array];
    _currentPage = 1;
    _cellHeight = 78.0;
    //数据tableview
    _dataTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,_dataTableViewHeight) style:UITableViewStylePlain];
    _dataTableView.dataSource = self;
    _dataTableView.delegate = self;
    _dataTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:_dataTableView];
    
    
    if ([_dataTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_dataTableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    //ios8SDK 兼容6 和 7 cell下划线
    if ([_dataTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_dataTableView setLayoutMargins:UIEdgeInsetsZero];
    }

//    //上拉刷新
    __block NoticeViewController *noticeVC = self;
    [_dataTableView addHeaderWithCallback:^{
        noticeVC-> _currentPage = 1;
        [noticeVC requestDataAction];
    } dateKey:@"NoticeRecordTable"];
    
    
    [_dataTableView addFooterWithCallback:^{
        noticeVC->_currentPage++;
        [noticeVC requestDataAction];
    }];

    
    //两种方法都可以 上面这个dateKey:@"NoticeRecordTable"]; 是什么鬼东西、、
//    __block NoticeViewController* noticeVC=self;
//    [_dataTableView addHeaderWithCallback:^{
//        noticeVC->_currentPage=1;
//        [noticeVC requestDataAction];
//    }];
//    
//    [_dataTableView addFooterWithCallback:^{
//    
//       noticeVC->_currentPage++;
//        [noticeVC requestDataAction];
//    
//    }];
    
    

    // 这两段代码重复被使用
    // 手势方法   点击屏幕重新加载数据
    _reloadDataTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(reloadDatatapAction)];
    
    //请求数据
    [_dataTableView headerBeginRefreshing];

}

-(void)reloadDatatapAction
{
    [_dataTableView headerBeginRefreshing];
}

-(void)requestDataAction
{
    [self.view hideProgressLabel];
    RequestInterface *request = [[RequestInterface alloc]init];
    NSDictionary *dic = @{@"token":self.login_user_token ,
                          @"page":[NSString stringWithFormat:@"%ld",(long)_currentPage],@"size":@"10",
                          @"cityId":[[NSUserDefaults standardUserDefaults] objectForKey:@"location_City"]
                          };
    [request requestGetAnnounceListWithParam:dic];

    [request getInterfaceRequestObject:^(id data) {
        if (_dataTableView.headerRefreshing)
        {
            [_dataArr removeAllObjects];
        }
        [ProjectUtil showLog:@"GetRecRecordByCdata:%@",data];
        [self.view hideProgressLabel];
        
        NSArray *recordArr = [data objectForKey:@"datas"];
        if ([[data objectForKey:@"success"]boolValue])
        {
            [self.view removeGestureRecognizer:_reloadDataTap];
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
    NSDictionary *dataDic = [_dataArr objectAtIndex:indexPath.row];
    static NSString * identifier = @"cell";
    [tableView registerNib:[UINib nibWithNibName:@"NoticeCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    NoticeCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (dataDic[@"logIntroimg"] != nil && dataDic[@"logIntroimg"] !=  [NSNull null] && dataDic[@"logIntroimg"])
    {
        [cell.notiImageView sd_setImageWithURL:[NSURL URLWithString:dataDic[@"logIntroimg"]] placeholderImage:[UIImage imageNamed:@"房源默认图.png"]];
    }
    cell.titleLabel.text = dataDic[@"logTitle"];
    NSString* str1=[NSString stringWithFormat:@"%@",dataDic[@"logPostTime"]];
    cell.dateLabel.text = [NSString stringWithFormat:@"发布时间:%@",[str1 changeToMyDate]];
    
    //ios8SDK 兼容6 和 7
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    cell.notiImageView.contentMode = UIViewContentModeScaleAspectFit;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *urlString = [_dataArr[indexPath.row]objectForKey:@"logAnnounceurl"];
    ModelWebViewController *noticeDetailVC = [[ModelWebViewController alloc]initWithUrlString:urlString NavigationTitle:@"公告"];
    [noticeDetailVC creatBackButtonWithPushType:Push With:self.title Action:nil];
    [self.navigationController pushViewController:noticeDetailVC animated:YES];    
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
