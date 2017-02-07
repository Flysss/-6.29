//
//  SelectToMyCenterViewController.m
//  SalesHelper_A
//
//  Created by flysss on 16/5/12.
//  Copyright © 2016年 X. All rights reserved.
//

#import "SelectToMyCenterViewController.h"
#import "RecommendTableViewCell.h"
#import "SalesOfficeCell.h"

@interface SelectToMyCenterViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) NSMutableArray * dataSource;

@property (nonatomic, assign) NSInteger pageIndex;

@property (nonatomic, strong)NSMutableArray * choosenArray;

@end

@implementation SelectToMyCenterViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
     self.dataSource = [NSMutableArray arrayWithCapacity:0];
    self.choosenArray = [NSMutableArray arrayWithCapacity:0];
    
    self.pageIndex = 1;
    [self CreateCustomNavigtionBarWith:self leftItem:@selector(backlastView) rightItem:@selector(click_makeSure)];
    [self.rightBtn setTitle:@"完成" forState:UIControlStateNormal];
    self.rightBtn.frame = CGRectMake(SCREEN_WIDTH-50, 24, 50, 40);
    self.rightBtn.titleLabel.font = Default_Font_17;
    [self.rightBtn setTitleColor:[UIColor colorWithWhite:1 alpha:0.5] forState:UIControlStateNormal];
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-120)/2, 27, 120, 30)];
    titleLabel.text = @"选择楼盘";
    titleLabel.font = Default_Font_18;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [titleLabel setTextColor:[UIColor whiteColor]];
    [self.topView addSubview: titleLabel];
    
    [self layoutSubViews];
    [self requestDataForShareBuildingsWithRefresh:NO];
     [self tableViewConfig];
}

-(void)backlastView
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)click_makeSure
{
    
    NSMutableArray * array  = [NSMutableArray arrayWithCapacity:0];
    
    for (id obj in self.choosenArray)
    {
        [array addObject:obj[@"id"]];
    }
    NSString * pidsStr = [array componentsJoinedByString:@","];
    NSDictionary * dict = @{
                            @"token":GetUserID,
                            @"prids":pidsStr
                            };
    
    RequestInterface * interface = [[RequestInterface alloc]init];
    
    [interface requestMySalesOfficeToShareWithParam:dict];
    [interface getInterfaceRequestObject:^(id data) {
        
        if ([[data objectForKey:@"success"] boolValue])
        {
            NSLog(@"%@-%@",data,pidsStr);
//            [self.view makeToast:@"恭喜您的售楼部开通成功！"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
            
        }
    } Fail:^(NSError *error) {
        
        [self.view makeToast:@"加载失败"];
    }];
    
    
    //    SelectdShareViewController * VC = [[SelectdShareViewController alloc]init];
    //    VC.hidesBottomBarWhenPushed = YES;
    //    [self.navigationController pushViewController:VC animated:YES];
    
}

-(void)layoutSubViews
{
    
    [super layoutSubViews];
    
    
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,64, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[RecommendTableViewCell class] forCellReuseIdentifier:@"RecommendTableViewCell"];
    self.tableView.separatorColor = [UIColor colorWithRed:239/255.0f green:239/255.0f blue:244/255.0f alpha:1];
    
   
  
    
}
//刷新
-(void)tableViewConfig
{
    
    __block SelectToMyCenterViewController * temp = self;
    [self.tableView addHeaderWithCallback:^{
        temp.pageIndex = 1;
        [temp.tableView headerEndRefreshing];
        [temp requestDataForShareBuildingsWithRefresh:YES];
        
    }];
//    [self.tableView addFooterWithCallback:^{
//        
//        temp.pageIndex ++ ;
//        [temp.tableView footerEndRefreshing];
//        [temp requestDataForShareBuildingsWithRefresh:NO];
//    }];
    
}

//请求我的售楼部楼盘
-(void)requestDataForShareBuildingsWithRefresh:(BOOL)refresh
{
    
    NSString * cityID = [[NSUserDefaults standardUserDefaults] objectForKey:@"location_City"];
    NSDictionary * dict = @{@"token":GetUserID,
                            @"type":@"1",
                            @"city":cityID
                            };
    NSLog(@"%@",dict);
    [self.view Loading_0314];
    RequestInterface* interface = [[RequestInterface alloc]init];
    [interface requestMySalesCentreBuildingSharedWithParam:dict];
    [interface getInterfaceRequestObject:^(id data) {
        
        if ([[data objectForKey:@"success"] boolValue])
        {
//            NSLog(@"dataaaa=%@",data);
            if (refresh)
            {
                [self.dataSource removeAllObjects];
            }
            [self.dataSource addObjectsFromArray:data[@"datas"]];
            
            if ([data[@"datas"] count] == 0)
            {
               
            }
            
            [self.view Hidden];
            [self.tableView reloadData];
            [_tableView headerEndRefreshing];
        }
        
        
    } Fail:^(NSError *error) {
        [self.view Hidden];
        [_tableView headerEndRefreshing];
    }];
}

#pragma mark  tableView协议代理方法
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100 ;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataSource count];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    RecommendTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RecommendTableViewCell" forIndexPath:indexPath];
    //    SalesOfficeCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SalesOfficeCell" forIndexPath:indexPath];
    if ([self.dataSource count] > 0)
    {
        [cell setAttributeForCell:self.dataSource[indexPath.row]];
        cell.commissionPriceLabel.hidden = YES;
        cell.yongImg.hidden = YES;
    }
    
    if ([self.choosenArray containsObject:[self.dataSource objectAtIndex:indexPath.row]])
    {
        cell.choosenBtn.selected = YES;
    }
    else
    {
        cell.choosenBtn.selected = NO;
    }
    return cell;

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    RecommendTableViewCell * cell = (RecommendTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    NSDictionary * dic = [self.dataSource objectAtIndex:indexPath.row];
//    NSLog(@"%@",dic[@"name"]);
    cell.choosenBtn.selected = YES;
    cell.choosen = YES;
    if ([self.choosenArray containsObject:dic])
    {
        [self.choosenArray removeObject:dic];
        cell.choosenBtn.selected = NO;
        cell.choosen = NO;
        
    }
    else
    {
        [self.choosenArray addObject:dic];
        cell.choosenBtn.selected = YES;
        cell.choosen = YES;
        
    }
    if ([self.choosenArray count])
    {
        self.rightBtn.enabled = YES;
        [self.rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    else
    {
        [self.rightBtn setTitleColor:[UIColor colorWithWhite:1 alpha:0.5] forState:UIControlStateNormal];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 0)];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(0, 10, 0, 0)];
    }
    if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]&& IOS_VERSION >= 8.0)
    {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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
