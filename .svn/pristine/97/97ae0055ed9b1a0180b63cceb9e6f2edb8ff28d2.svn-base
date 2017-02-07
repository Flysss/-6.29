//
//  MyTeamViewController.m
//  SalesHelper_A
//
//  Created by flysss on 16/5/17.
//  Copyright © 2016年 X. All rights reserved.
//

#import "MyTeamViewController.h"
#import "MyTeamCell.h"
#import "HotListTeamViewController.h"

@interface MyTeamViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) NSMutableArray * dataSource;

@property (nonatomic, assign) NSInteger page;
@end

@implementation MyTeamViewController
{
    UILabel * titleLabel;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self CreateCustomNavigtionBarWith:self leftItem:@selector(backLastView) rightItem:@selector(clickToChangeState)];

    self.page = 1;
    self.dataSource = [NSMutableArray arrayWithCapacity:0];
    //创建标题
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-200)/2, 27, 200, 30)];
    titleLabel.text = @"我的团队";
    titleLabel.font = Default_Font_18;
    [titleLabel setTextColor:[UIColor whiteColor]];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.topView addSubview: titleLabel];
    self.rightBtn.frame = CGRectMake(SCREEN_WIDTH-60, 20, 50, 44);
    [self.rightBtn setTitle:@"排行榜" forState:UIControlStateNormal];
    [self.rightBtn setImage:nil forState:UIControlStateNormal];
    self.rightBtn.titleLabel.font = Default_Font_15;
    self.rightBtn.hidden = YES;
    [self.rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self layoutSubViews];
    
    [self refreshingTableView];
    
    [self requestDataWithRefresh:NO];
    
}

-(void)backLastView
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)clickToChangeState
{
    HotListTeamViewController * vc = [[HotListTeamViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)refreshingTableView
{
    //下拉刷新
    __block  MyTeamViewController * h = self;
    [_tableView addHeaderWithCallback:^{
        [h.tableView headerEndRefreshing];
        h.page = 1;
        [h requestDataWithRefresh:YES];
    }];
    //上拉加载
    [_tableView addFooterWithCallback:^{
        
        [h.tableView footerEndRefreshing];
        h.page ++;
        [h requestDataWithRefresh:NO];
    }];
}

-(void)requestDataWithRefresh:(BOOL)refresh
{
    
  
    NSDictionary * dict = @{
                            @"token":GetUserID,
                            @"page":[NSString stringWithFormat:@"%d",self.page],
                            @"size":@"10",
                            @"orderby":@"",
                            };
    RequestInterface * interface = [[RequestInterface alloc]init];
    [self.view Loading_0314];
    [interface requestMyTeamDataWithParam:dict];
    [interface getInterfaceRequestObject:^(id data) {
        [self.view Hidden];
        if ([[data objectForKey:@"success"] boolValue])
        {
            NSLog(@"team%@",data);
            if (refresh) {
                [self.dataSource removeAllObjects];
            }
            
            [self.dataSource addObjectsFromArray:data[@"datas"]];
            
            titleLabel.text =[NSString stringWithFormat:@"我的团队(%@人)",data[@"allcounts"]] ;
            [self.tableView reloadData];
            
        }
        else
        {
            [self.view makeToast:data[@"message"]];
        }
            
        
    } Fail:^(NSError *error)
    {
        [self.view Hidden];
        
    }];
    
}

-(void)layoutSubViews
{
    [super layoutSubViews];
   
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[MyTeamCell class] forCellReuseIdentifier:@"MyTeamCell"];
}

#pragma mark  tableView协议代理方法
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80 ;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataSource count];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MyTeamCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MyTeamCell" forIndexPath:indexPath];

    if ([self.dataSource count])
    {
    [cell setAttributeForCellWithDictionary:self.dataSource[indexPath.row]];
    }

    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

//使列表的分割线顶格开始
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 0)];
    }
    
    
    if (IOS_VERSION >= 8.0)
    {
        if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)])
        {
            [cell setPreservesSuperviewLayoutMargins:NO];
        }
        if ([cell respondsToSelector:@selector(setLayoutMargins:)])
        {
            [cell setLayoutMargins:UIEdgeInsetsMake(0, 10, 0, 0)];
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
