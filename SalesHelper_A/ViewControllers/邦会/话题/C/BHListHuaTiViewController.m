//
//  BHListHuaTiViewController.m
//  SalesHelper_A
//
//  Created by zhipu on 16/3/30.
//  Copyright © 2016年 X. All rights reserved.
//

#import "BHListHuaTiViewController.h"
#import "BHListHuaTiAndGongGaoModel.h"
#import "BHListHuaTiCell.h"
#import "UIColor+HexColor.h"
#import "HWComposeController.h"
#import "HWGongGaoViewController.h"
#import "BHNewHuaTiViewController.h"

@interface BHListHuaTiViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) NSMutableArray *listArr;
@property (nonatomic, strong) UIView *topView;

@end

@implementation BHListHuaTiViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
//- (void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    self.navigationController.navigationBar.hidden = NO;
//}

-(NSMutableArray *)listArr
{
    if (_listArr == nil) {
        self.listArr = [NSMutableArray array];
    }
    return _listArr;
}
#pragma mark - 网络请求－邦学院列表
- (void)requeestBangXueYuanListData:(BOOL)isDelet
{
    [self.view Loading_0314];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *loginuid =  [defaults objectForKey:@"id"];
    NSString *city = [defaults objectForKey:@"location_City"];
    RequestInterface *interface = [[RequestInterface alloc]init];
    
    
    NSDictionary *dic = @{
                          @"city":city,
                          @"loginuid":loginuid,
                          };
    [interface requestBHListBangXueYuan:dic];
    [interface getInterfaceRequestObject:^(id data)
     {
         if ([data[@"success"] boolValue] == YES)
         {
             if ([data[@"datas"] count] != 0)
             {
                 if (isDelet == YES) {
                     [self.listArr removeAllObjects];
                 }
                 for (NSDictionary *dict in data[@"datas"])
                 {
                     BHListHuaTiAndGongGaoModel *model = [[BHListHuaTiAndGongGaoModel alloc]init];
                     [model setValuesForKeysWithDictionary:dict];
                     [self.listArr addObject:model];
                 }
                 [self.tableview reloadData];
             }
             else
             {
                 [self.view makeToast:data[@"message"]];
             }
         }
         else
         {
             [self.view makeToast:data[@"message"]];
         }
     } Fail:^(NSError *error)
     {
         [self.view makeToast:@"请求失败"];
     }];

}
#pragma mark - 网络请求－话题列表
- (void)requeestHuaTiListData:(BOOL)isDelet
{
    [self.view Loading_0314];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *loginuid =  [defaults objectForKey:@"id"];
    NSString *city = [defaults objectForKey:@"location_City"];
    RequestInterface *interface = [[RequestInterface alloc]init];
    
   
        NSDictionary *dic = @{
                              @"city":city,
                              @"loginuid":loginuid,
                              };
        [interface requestBHListHuaTi:dic];
        [interface getInterfaceRequestObject:^(id data)
         {
             if ([data[@"success"] boolValue] == YES)
             {
                 if ([data[@"datas"] count] != 0)
                 {
                     if (isDelet == YES) {
                         [self.listArr removeAllObjects];
                     }
                     for (NSDictionary *dict in data[@"datas"])
                     {
                         BHListHuaTiAndGongGaoModel *model = [[BHListHuaTiAndGongGaoModel alloc]init];
                         [model setValuesForKeysWithDictionary:dict];
                         [self.listArr addObject:model];
                     }
                     [self.tableview reloadData];
                 }
                 else
                 {
                     [self.view makeToast:data[@"message"]];
                 }
             }
             else
             {
                 [self.view makeToast:data[@"message"]];
             }
         } Fail:^(NSError *error)
         {
             [self.view makeToast:@"请求失败"];
         }];
    
}
#pragma mark - 网络请求－公告列表
- (void)requeestGongGaoListData:(BOOL)isDelet
{
    [self.view Loading_0314];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *loginuid =  [defaults objectForKey:@"id"];
    NSString *city = [defaults objectForKey:@"location_City"];
    RequestInterface *interface = [[RequestInterface alloc]init];
    
    NSDictionary *dic = @{
                          @"city":city,
                           @"loginuid":loginuid,
                          };
    [interface requestBHListGongGao:dic];
    [interface getInterfaceRequestObject:^(id data)
     {
         if ([data[@"success"] boolValue] == YES)
         {
             if ([data[@"datas"] count] != 0)
             {
                 if (isDelet == YES) {
                     [self.listArr removeAllObjects];
                 }
                 for (NSDictionary *dict in data[@"datas"])
                 {
                     BHListHuaTiAndGongGaoModel *model = [[BHListHuaTiAndGongGaoModel alloc]init];
                     [model setValuesForKeysWithDictionary:dict];
                     [self.listArr addObject:model];
                 }
                 [self.tableview reloadData];
             }
             else
             {
                 [self.view makeToast:data[@"message"]];
             }
         }
         else
         {
             [self.view makeToast:data[@"message"]];
         }
     } Fail:^(NSError *error)
     {
         [self.view makeToast:@"请求失败"];
     }];
    
}

#pragma mark - 网络请求－公告列表
- (void)requeestListData:(BOOL)isDelet
{
    [self.view Loading_0314];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *loginuid =  [defaults objectForKey:@"id"];
    
    NSString *type;
    //1是话题2是公告
    if ([_isList isEqualToString:@"1"])
    {
        type = @"3";
    }
    else if([_isList isEqualToString:@"2"])
    {
        type = @"2";
    }
    else if([_isList isEqualToString:@"3"])
    {
        type = @"5";
    }
    
    RequestInterface *interface = [[RequestInterface alloc]init];
    
    NSDictionary *dic = @{
                          @"loginuid":loginuid,
                          @"type":type
                          };
    [interface requestBHListTopic:dic];
    [interface getInterfaceRequestObject:^(id data)
     {
         if ([data[@"success"] boolValue] == YES)
         {
             if ([data[@"datas"] count] != 0)
             {
                 if (isDelet == YES) {
                     [self.listArr removeAllObjects];
                 }
                 for (NSDictionary *dict in data[@"datas"])
                 {
                     BHListHuaTiAndGongGaoModel *model = [[BHListHuaTiAndGongGaoModel alloc]init];
                     [model setValuesForKeysWithDictionary:dict];
                     [self.listArr addObject:model];
                 }
                 [self.tableview reloadData];
             }
             else
             {
                 [self.view makeToast:data[@"message"]];
             }
         }
         else
         {
             [self.view makeToast:data[@"message"]];
         }
     } Fail:^(NSError *error)
     {
         [self.view makeToast:@"请求失败"];
     }];
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    //1是话题2是公告
//    if ([_isList isEqualToString:@"1"])
//    {
//        [self requeestHuaTiListData:NO];
//    }
//    else if([_isList isEqualToString:@"2"])
//    {
//        [self requeestGongGaoListData:NO];
//    }
//    else if([_isList isEqualToString:@"3"])
//    {
        [self requeestListData:NO];
//    }
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"bc-1"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:(UIBarButtonItemStyleDone) target:self action:@selector(returnPage)];
    [self customTopView];
    [self createTableView];
    
}
#pragma mark -自定义导航栏
- (void)customTopView
{
    self.topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    UIButton *btnBack = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [btnBack setImage:[UIImage imageNamed:@"bc-1"] forState:(UIControlStateNormal)];
    [btnBack setImage:[UIImage imageByApplyingAlpha:[UIImage imageNamed:@"bc-1"]] forState:(UIControlStateHighlighted)];
    [btnBack addTarget:self action:@selector(returnPage) forControlEvents:(UIControlEventTouchUpInside)];
    btnBack.frame = CGRectMake(10, 20, 30, 44);
    
    [self.topView addSubview:btnBack];
    
    UILabel *lblName = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 44)];
    lblName.textColor = [UIColor colorWithHexString:@"ffffff"];
    lblName.font = [UIFont systemFontOfSize:18];
    lblName.textAlignment = NSTextAlignmentCenter;
    if ([_isList isEqualToString:@"1"])
    {
        lblName.text = @"话题列表";
    }
    else if([_isList isEqualToString:@"2"])
    {
        lblName.text = @"公告列表";
    }
    else if([_isList isEqualToString:@"3"])
    {
        lblName.text = @"邦学院列表";
    }
    [self.topView addSubview:lblName];
    self.topView.backgroundColor = [UIColor colorWithHexString:@"00aff0"];
    [self.view addSubview:self.topView];
    
}

- (void)returnPage
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -视图创建
- (void)createTableView
{
    
    self.tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, self.view.bounds.size.height-64) style:UITableViewStylePlain];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview registerClass:[BHListHuaTiCell class] forCellReuseIdentifier:@"BHListHuaTiCell"];
    self.tableview.separatorStyle = UITableViewCellAccessoryNone;
    [self.view addSubview:self.tableview];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.listArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    BHListHuaTiCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BHListHuaTiCell" forIndexPath:indexPath];
    BHListHuaTiAndGongGaoModel *model = self.listArr[indexPath.section];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.isList = _isList;
    cell.model = model;

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(JumpComm:)];
    cell.lblHuaTi.tag = indexPath.section;
    [cell.lblHuaTi addGestureRecognizer:tap];
    cell.lblHuaTi.userInteractionEnabled = YES;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BHListHuaTiAndGongGaoModel *model = self.listArr[indexPath.section];
    if ([_isList isEqualToString:@"1"])
    {
        [self pushToHuaTi:model];
    }
    else if([_isList isEqualToString:@"2"])
    {
        [self pushToGongGao:model.Tid];
    }
    else if([_isList isEqualToString:@"3"])
    {
//        [self pushToGongGao:model.Tid];
        HWGongGaoViewController *gongGaoVC = [[HWGongGaoViewController alloc]init];
        gongGaoVC.postID = model.Tid;
        gongGaoVC.isBangSchool = YES;
        gongGaoVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:gongGaoVC animated:YES];
    }
}




- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.01;
    }
    return 8;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 180*SCREEN_WIDTH/320+60;
}

#pragma mark - 发表话题的按钮
- (void)JumpComm:(UITapGestureRecognizer *)tap
{
    if ([GetOrgType isEqualToString:@"2"])
    {
        BHListHuaTiAndGongGaoModel *model = self.listArr[tap.view.tag];
        HWComposeController *subVC = [[HWComposeController alloc]init];
        UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:subVC];
        subVC.subject_id = model.Tid;
        subVC.subjectTitle = model.topic;
        [self presentViewController:navi animated:YES completion:nil];
    }
    else
    {
        [self zanErrorAlertView:nil message:@"您无权限进行此操作，请先绑定机构码"];
    }
    
}
#pragma mark -跳转到公告页面
- (void)pushToGongGao:(NSString *)postID
{
    HWGongGaoViewController *gongGaoVC = [[HWGongGaoViewController alloc]init];
    gongGaoVC.postID = postID;
    gongGaoVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:gongGaoVC animated:YES];
}
#pragma mark-跳转到话题页面
- (void)pushToHuaTi:(BHListHuaTiAndGongGaoModel *)model
{
    BHNewHuaTiViewController *huatiVC = [[BHNewHuaTiViewController alloc]init];
    huatiVC.hidesBottomBarWhenPushed = YES;
    huatiVC.huatiid = model.Tid;
    //    huatiVC.subid = model.subject_id[@""]
    [self.navigationController pushViewController:huatiVC animated:YES];
}


#pragma mark - 点赞失败的提示
- (void)zanErrorAlertView:(NSString *)title message:(NSString *)message
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:^{
            
        }];
        
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
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
