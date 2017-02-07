//
//  ChoosenHouseViewController.m
//  SalesHelper_A
//
//  Created by flysss on 16/5/3.
//  Copyright © 2016年 X. All rights reserved.
//

#import "ChoosenHouseViewController.h"
#import "HouseSourceCell.h"


@interface ChoosenHouseViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) NSMutableArray * dataSource;

@property (nonatomic, assign) NSInteger pageIndex;

@end

@implementation ChoosenHouseViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self CreateCustomNavigtionBarWith:self leftItem:@selector(goBack) rightItem:nil];
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-120)/2, 27, 120, 30)];
    titleLabel.text = @"选择房源";
    titleLabel.font = Default_Font_20;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [titleLabel setTextColor:[UIColor whiteColor]];
    [self.topView addSubview: titleLabel];

    self.pageIndex = 1;
    self.dataSource = [NSMutableArray arrayWithCapacity:0];
    
    [self layoutSubViews];
    
    [self requestDataWithRefresh:NO];
    
    
}

-(void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)layoutSubViews
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 60;
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[HouseSourceCell class] forCellReuseIdentifier:@"HouseSourceCell"];
    
}

-(void)requestDataWithRefresh:(BOOL)refresh
{
    
    NSDictionary * dict = @{
                            @"recid":self.clientID,
                            @"pageNumber":[NSString stringWithFormat:@"%d",self.pageIndex],
                            @"pageSize":@"20"
                            };
    [self.view Loading_0314];
    RequestInterface * interface = [[RequestInterface alloc]init];
    [interface requestAPPlySelectHouseResourceWithParam:dict];
    
    [interface getInterfaceRequestObject:^(id data) {
        [self.view Hidden];
//        NSLog(@"%@-%@",data,self.clientID);
        if ([data[@"success"] boolValue])
        {
            if (refresh)
            {
                [self.dataSource removeAllObjects];
            }
            [self.dataSource addObjectsFromArray:data[@"datas"]];
            if ([data[@"datas"] count] == 0)
            {
                [self.view makeToast:@"没有更多数据了"];
            }
           
        }
//        [self.tableView headerEndRefreshing];
//        [self.tableView footerEndRefreshing];
        [self.tableView reloadData];
        
    } Fail:^(NSError *error) {
        [self.view Hidden];
         NSLog(@"%@",error);
//        [self.tableView headerEndRefreshing];
//        [self.tableView footerEndRefreshing];
    }];
    
}

-(void)tableViewConfig
{
    __block ChoosenHouseViewController * temp = self;
    
    [self.tableView addHeaderWithCallback:^{
        temp.pageIndex = 1;
        [temp.tableView headerEndRefreshing];
        [temp requestDataWithRefresh:YES];
    }];
    
    [self.tableView addFooterWithCallback:^{
        
        temp.pageIndex ++ ;
        [temp.tableView footerEndRefreshing];
        [temp requestDataWithRefresh:NO];
    }];
    
}



#pragma mark  tableView协议代理方法

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataSource count];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HouseSourceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HouseSourceCell" forIndexPath:indexPath];
    if ([self.dataSource count] > 0)
    {
        [cell setAttributeForCellWithData:self.dataSource[indexPath.row]];
        
    }
    
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    HouseSourceCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if ([cell.saleStateLab.text isEqualToString:@"不可售"])
    {
        return;
    }
    else if ([cell.saleStateLab.text isEqualToString:@"可售"])
    {
        NSString * str = [NSString stringWithFormat:@"%@ %@%@",cell.houseGroupLab.text,cell.flotLab.text,cell.unitLab.text];
        self.block(str,self.dataSource[indexPath.row][@"id"]);
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}


//将列表的分割线从头开始
//最新的，简便些
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }

    if (IOS_VERSION >= 8.0)
    {
        if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)])
        {
            [cell setPreservesSuperviewLayoutMargins:NO];
        }
        if ([cell respondsToSelector:@selector(setLayoutMargins:)])
        {
            [cell setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
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
