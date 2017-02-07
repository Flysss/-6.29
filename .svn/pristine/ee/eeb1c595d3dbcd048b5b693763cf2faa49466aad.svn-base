//
//  BanghuiSearchViewController.m
//  SalesHelper_A
//
//  Created by flysss on 16/3/18.
//  Copyright © 2016年 X. All rights reserved.
//

#import "BanghuiSearchViewController.h"
#import "UIColor+Extend.h"
#import "PostAndOrgCell.h"
#import "AFHTTPRequestOperationManager.h"

#import "BHMyPostsModel.h"
#import "BHNewPersonCell.h"
#import "ZJCellHeadView.h"
#import "ZJPostBodyView.h"

#import "BHNewPersonViewController.h"
#import "BHPostDetailViewController.h"
#import "HWContentsLabel.h"
#import "ZJMyPostBettomView.h"

@interface BanghuiSearchViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,ZJMyPostBettomViewDelegate>
@property (nonatomic, strong)UITableView * tableView;

@property (nonatomic, strong)UITableView * tableView_post;

@property (nonatomic, strong)UITableView * tableView_org;

//用户数组
@property (nonatomic, strong) NSMutableArray * usersArr;
//帖子
@property (nonatomic, strong) NSMutableArray * postsArr;
//机构用户
@property (nonatomic, strong) NSMutableArray * orgUserArr;

@property (nonatomic, assign)  NSInteger page1;
@property (nonatomic, assign)  NSInteger page2;
@property (nonatomic, assign)  NSInteger page3;


@property (nonatomic, copy) NSString * searchString;

@property (nonatomic, strong) NSString *loginuid;

@end

@implementation BanghuiSearchViewController
{
    //分段选择器
    UISegmentedControl* mySegment;
    //搜索条
    UISearchBar * _searchBar;
    
    
    //类型
    NSInteger type;
    
    //
    BOOL isRefresh;
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //隐藏导航栏返回按钮
//    [self.navigationItem setHidesBackButton:YES];
    self.navigationController.navigationBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    self.navigationController.navigationBar.hidden = YES;
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_searchBar becomeFirstResponder];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.page1 = 1;
    self.page2 = 1;
    self.page3 = 1;

    self.view.backgroundColor = [UIColor hexChangeFloat:@"f2f2f2"];
    self.usersArr = [NSMutableArray arrayWithCapacity:0];
    self.postsArr = [NSMutableArray arrayWithCapacity:0];
    self.orgUserArr = [NSMutableArray arrayWithCapacity:0];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.loginuid = [defaults objectForKey:@"id"];
    
    [self createSubviews];
    [self createTableView];
    
    [self tableViewConfig];
    
}
-(void)createTableView
{
    //帖子
    self.tableView_post = [[UITableView alloc]initWithFrame:CGRectMake(0,64+65, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-60-65) style:UITableViewStylePlain];
    self.tableView_post.delegate = self;
    self.tableView_post.dataSource = self;
    
    [self.tableView_post registerClass:[BHNewPersonCell class] forCellReuseIdentifier:@"BHNewPersonCell"];
    self.tableView_post.tag = 100;
    self.tableView_post.hidden = YES;
    self.tableView_post.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView_post];
    self.tableView_post.tableFooterView = [[UIView alloc]init];
    
    //邦友
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,64+65, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-60-65)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[PostAndOrgCell class] forCellReuseIdentifier:@"postcell"];
    self.tableView.tag = 101;
    self.tableView.hidden = YES;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    //机构
    self.tableView_org = [[UITableView alloc]initWithFrame:CGRectMake(0,64+65, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-60-65)];
    self.tableView_org.delegate = self;
    self.tableView_org.dataSource = self;
    [self.tableView_org registerClass:[PostAndOrgCell class] forCellReuseIdentifier:@"orgcell"];
    self.tableView_org.tag = 102;
    self.tableView_org.hidden = YES;
    self.tableView_org.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView_org];
    self.tableView_org.tableFooterView = [[UIView alloc]init];
    
}

-(void)createSubviews
{
    [self CreateCustomNavigtionBarWith:self leftItem:nil rightItem:nil];
    self.backBtn.hidden = YES;
    self.rightBtn.hidden = YES;
    _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0,25,SCREEN_WIDTH, 30)];
    [_searchBar setContentMode:UIViewContentModeLeft];
    [_searchBar setPlaceholder:@"搜索帖子/邦友/机构"];
    _searchBar.showsCancelButton = NO;
    _searchBar.layer.cornerRadius = 5.0f;
    _searchBar.layer.masksToBounds = YES;
     _searchBar.tintColor = [UIColor whiteColor];
//    _searchBar.barTintColor = [UIColor hexChangeFloat:@"00aff0"];
//    _searchBar.backgroundColor = [UIColor whiteColor];
    [_searchBar setBackgroundImage:[self imageWithBgColor:[UIColor clearColor]]];
    _searchBar.delegate = self;
//    [_searchBar becomeFirstResponder];
    
//    self.navigationItem.titleView = _searchBar;
    [self.topView addSubview:_searchBar];
    
    [self setSearchBarTextfiled:_searchBar];
    
    mySegment = [[UISegmentedControl alloc]initWithItems:@[@"帖子",@"邦友",@"机构"]];
    mySegment.frame = CGRectMake(25, 64+21, SCREEN_WIDTH-50, 30);
    mySegment.selectedSegmentIndex = 0;
    mySegment.backgroundColor = [UIColor whiteColor];
    mySegment.tintColor = [UIColor colorWithRed:23/255.0f green:183/255.0f blue:242/255.0f alpha:1];
    [mySegment setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} forState:UIControlStateNormal];
    [mySegment addTarget:self action:@selector(clickInSegment:)forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:mySegment];
    
    
    
}
- (void)setSearchBarTextfiled:(UISearchBar *)searchBar
{
    for (UIView *view in searchBar.subviews){
        for (id subview in view.subviews){
            if ( [subview isKindOfClass:[UITextField class]] )
            {
                [(UITextField *)subview setTintColor:[UIColor colorWithRed:23/255.0f green:183/255.0f blue:242/255.0f alpha:1]];
                return;
            }
        }
    }
}


#pragma mark - UISerchBarDelegate
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    _searchBar.showsCancelButton = YES;
    return YES;
}

-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    _searchBar.showsCancelButton = NO;
    return YES;
}

//取消搜索
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    _searchBar.showsCancelButton = NO;
    
    [_searchBar resignFirstResponder];
    _searchBar.hidden = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

//点击搜索按钮
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    self.searchString = searchBar.text;
    if (GetUserID != nil)
    {
        [self requestPostData:searchBar.text type:0 isfresh:NO];
    }
    
    
}

//点击button 切换数据源 刷新tableview
-(void)clickInSegment:(UISegmentedControl*)sender
{
    type = sender.selectedSegmentIndex;
    if (type == 0)
    {
        
        self.tableView.hidden = YES;
        self.tableView_org.hidden = YES;
        
        if (self.postsArr.count == 0) {
           self.tableView_post.hidden = YES;
        }else
           self.tableView_post.hidden = NO;;
    }
    if (type == 1)
    {
        self.tableView_post.hidden = YES;
        self.tableView_org.hidden = YES;
        if (self.usersArr.count == 0) {
            self.tableView.hidden = YES;
        }else
        self.tableView.hidden = NO;
    }
    if (type == 2)
    {
        
        self.tableView.hidden = YES;
        self.tableView_post.hidden = YES;
        if (self.orgUserArr.count == 0) {
           self.tableView_org.hidden = YES;
        }else
        self.tableView_org.hidden = NO;
        
    }
}

#pragma mark --增加刷新控件
- (void)tableViewConfig
{
    __block BanghuiSearchViewController * temp = self;
    
    [self.tableView addHeaderWithCallback:^{
        temp.page1 = 1;
        [temp requestPostData:temp.searchString type:1 isfresh:YES];
        [temp.tableView headerEndRefreshing];
    }];
    
    [self.tableView addFooterWithCallback:^{
        temp.page1 ++;
        [temp requestPostData:temp.searchString type:1 isfresh:NO];
        [temp.tableView footerEndRefreshing];
    }];
    
    [self.tableView_post addHeaderWithCallback:^{
        temp.page3 = 1;
        [temp requestPostData:temp.searchString type:0 isfresh:YES];
        [temp.tableView_post headerEndRefreshing];
    }];
    
    [self.tableView_post addFooterWithCallback:^{
        temp.page3 ++;
        [temp requestPostData:temp.searchString type:0 isfresh:NO];
        [temp.tableView_post footerEndRefreshing];
    }];

    [self.tableView_org addHeaderWithCallback:^{
        temp.page2 = 1;
        [temp requestPostData:temp.searchString type:2 isfresh:YES];
        [temp.tableView_org headerEndRefreshing];
    }];
    
    [self.tableView_org addFooterWithCallback:^{
        temp.page2 ++;
        [temp requestPostData:temp.searchString type:2 isfresh:NO];
        [temp.tableView_org footerEndRefreshing];
    }];

}


- (void)requestPostData:(NSString*)searchStr type:(NSInteger)index isfresh:(BOOL)refresh;
{
    
    if (![searchStr isEqualToString:[[NSUserDefaults standardUserDefaults]valueForKey:@"lastStr"]])
    {
        [self.usersArr removeAllObjects];
        [self.postsArr removeAllObjects];
        [self.orgUserArr removeAllObjects];
    }
    
    [self.view Loading_0314];
    dispatch_group_t group = dispatch_group_create();
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *city = [defaults objectForKey:@"location_City"];
    //     NSLog(@"search = %@",searchStr);
    dispatch_group_enter(group);
    NSDictionary *dic = @{
                          @"substr":searchStr,
                          @"loginuid":[[NSUserDefaults standardUserDefaults] valueForKey:@"id"],
                          @"city":city,
                          @"p":@(self.page1)
                          };
    
    //邦友 Username
    RequestInterface *interfaceUser = [[RequestInterface alloc]init];
    [interfaceUser requestBangHuiSearchUsername:dic];
    [interfaceUser getInterfaceRequestObject:^(id data) {
        dispatch_group_leave(group);
        NSLog(@"user = %@-%ld",data[@"datas"],(long)self.page1);
        if ([data[@"success"] boolValue])
        {
            if ([data[@"datas"] count] != 0)
            {
                
                if (refresh)
                {
                    [self.usersArr removeAllObjects];
                    if ([data[@"datas"] isKindOfClass:[NSArray class]])
                    {
                        [self.usersArr addObjectsFromArray:data[@"datas"]];
                    }
                }
                else
                {
                    [self.usersArr insertObjects:data[@"datas"] atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(self.usersArr.count, [data[@"datas"] count])]];
                    if (![[data objectForKey:@"datas"]count])
                    {
                        [self.view makeToast:@"没有更多数据了"];
                    }
   
                }
            }
        }else{
//            [self.view makeToast:@"加载失败"];
        }
        
    } Fail:^(NSError *error) {
        dispatch_group_leave(group);
        [self.view Hidden];
        [self.view makeToast:@"网络错误"];
    }];
    
    //机构
    dispatch_group_enter(group);
    NSDictionary *dicOrg = @{
                             @"substr":searchStr,
                             @"loginuid":[[NSUserDefaults standardUserDefaults] valueForKey:@"id"],
                             @"city":city,
                             @"p":@(self.page2)
                             };
    
    RequestInterface *interfaceOrg = [[RequestInterface alloc]init];
    [interfaceOrg requestBangHuiSearchOrgName:dicOrg];
    [interfaceOrg getInterfaceRequestObject:^(id data) {
        dispatch_group_leave(group);
        NSLog(@"org = %@",data[@"datas"]);
        if ([data[@"success"] boolValue])
        {
            if ([data[@"datas"] count] != 0)
            {
                
                if (refresh)
                {
                    [self.orgUserArr removeAllObjects];
                    if ([data[@"datas"] isKindOfClass:[NSArray class]])
                    {
                        [self.orgUserArr addObjectsFromArray:data[@"datas"]];
                    }
                }
                else
                {
                    [self.orgUserArr insertObjects:data[@"datas"] atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(self.orgUserArr.count, [data[@"datas"] count])]];
                    if (![[data objectForKey:@"datas"]count])
                    {
                        [self.view makeToast:@"没有更多数据了"];
                    }
 
                }
            }
        }
    } Fail:^(NSError *error) {
        dispatch_group_leave(group);
        [self.view Hidden];
        [self.view makeToast:@"网络错误"];
    }];
    //帖子
    dispatch_group_enter(group);
    NSDictionary *dicPost = @{
                              @"substr":searchStr,
                              @"loginuid":[[NSUserDefaults standardUserDefaults] valueForKey:@"id"],
                              @"city":city,
                              @"p":@(self.page3)
                              };
    RequestInterface *interfacePost = [[RequestInterface alloc]init];
    
    [interfacePost requestBangHuiSearchContents:dicPost];
    [interfacePost getInterfaceRequestObject:^(id data) {
        dispatch_group_leave(group);
//        NSLog(@"post = %@",data[@"datas"]);
        if ([data[@"success"] boolValue])
        {
            if ([data[@"datas"] count] != 0)
            {
                if (refresh)
                {
                    [self.postsArr removeAllObjects];
                    for (NSDictionary *dict in data[@"datas"])
                    {
                        BHMyPostsModel *model = [[BHMyPostsModel alloc]init];
                        [model setAttributeForModel:dict];
                        [self.postsArr addObject:model];
                    }
                }else
                {
                    for (NSDictionary *dict in data[@"datas"])
                    {
                        BHMyPostsModel *model = [[BHMyPostsModel alloc]init];
                        [model setAttributeForModel:dict];
                        [self.postsArr addObject:model];
                    }

                }
            }
        }
        
    } Fail:^(NSError *error) {
        dispatch_group_leave(group);
        [self.view Hidden];
        [self.view makeToast:@"网络错误"];
    }];
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        
        [[NSUserDefaults standardUserDefaults] setObject:searchStr forKey:@"lastStr"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        if (type == 0) {
          self.tableView_post.hidden = NO;
        }else if (type == 1)
        {
            self.tableView.hidden = NO;
        }else if (type == 2)
        {
            self.tableView_org.hidden = NO;
        }
        [self.tableView reloadData];
        [self.tableView_post reloadData];
        [self.tableView_org reloadData];
        [self.view Hidden];
    });
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //帖子
    if (tableView.tag == 100)
    {
        BHMyPostsModel *model = self.postsArr[indexPath.row];
//        CGFloat height = [ZJPostBodyView heightForString:model.contents font:18 width:SCREEN_WIDTH-21];
//        CGFloat maxW = SCREEN_WIDTH-21;
//        CGSize maxSize = CGSizeMake(maxW, 120);
//        CGSize textSize = [model.attributedContents boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
//        if (![model.imgpath isEqualToString:@""])
//        {
//            return (20+85+38)/2+(21/2+17/2+183/2+25/2+15+21/2)+textSize.height;
//        }
//        else
//        {
//            return (20+85+38)/2+(21/2+25/2+15+21/2+textSize.height);
//        }
        return [BHNewPersonCell heightforCell:model];
    }
    else if (tableView.tag == 101)
    {
        return 60;
    }else{
        return 60;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 100)
    {
//        NSLog(@"%d",self.postsArr.count);
        return self.postsArr.count;
    }
    else if (tableView.tag == 101)
    {
        return self.usersArr.count;
//        return 4;
        
    }
    else
    {
        return self.orgUserArr.count;
//        return 5;
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 100)
    {
        BHNewPersonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BHNewPersonCell" forIndexPath:indexPath];
        BHMyPostsModel *model = self.postsArr[indexPath.row];
        cell.MyPostBettomView.delegate = self;
        cell.MyPostBettomView.indexpath = indexPath;
        cell.model = model;
        
        cell.postBodyView.lblBody.attributedText = model.attributedContents;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
    }
    else if (tableView.tag == 101)
    {
        PostAndOrgCell * cell = [tableView dequeueReusableCellWithIdentifier:@"postcell" forIndexPath:indexPath];
        if (self.usersArr.count > 0)
        {
            [cell setSubViewForCell:self.usersArr[indexPath.row]];
         
            cell.userName.attributedText = [self convertStringToAttributeStr:cell.userName.text font:15];
            cell.userID = self.loginuid;
            cell.block = ^(UIButton* sender)
            {
                [self clickBtnToFocus:sender];
            };
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
         return cell;
    }
    else
    {
        PostAndOrgCell * cell = [tableView dequeueReusableCellWithIdentifier:@"orgcell" forIndexPath:indexPath];
        if (self.orgUserArr.count > 0)
        {
            [cell setSubViewForCell:self.orgUserArr[indexPath.row]];
            cell.companyLab.attributedText = [self convertStringToAttributeStr:cell.companyLab.text font:13];
            cell.userID = self.loginuid;
            cell.block = ^(UIButton* sender)
            {
                [self clickBtnToFocus:sender];
            };
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
   
}

//加关注按钮
-(void)clickBtnToFocus:(UIButton*)sender
{

    NSLog(@"tag=%ld",(long)sender.tag);
    sender.selected  = ! sender.selected;
    if (sender.selected == YES) {
        [self alertView:nil message:@"关注成功"];
    }else
    {
        [self alertView:nil message:@"取消关注"];
    }
    
    if ([GetOrgType isEqualToString:@"2"])
    {
        NSString *uid = [NSString stringWithFormat:@"%ld",(long)sender.tag];
        RequestInterface *interface = [[RequestInterface alloc]init];
        NSDictionary *dic = @{
                              @"uid":uid,
                              @"loginuid":[[NSUserDefaults standardUserDefaults] valueForKey:@"id"],
                              };
        [interface requestBHGuanZhuWithDic:dic];
        [interface getInterfaceRequestObject:^(id data)
         {
             if ([data[@"success"] boolValue] == YES)
             {
                 
                 
             }
             else
             {
                 
                 
             }
         } Fail:^(NSError *error)
         {
             [self zanErrorAlertView:@"提示" message:@"抱歉，关注失败"];
         }];
        
    }else
    {
        [self zanErrorAlertView:nil message:@"您无权限进行此操作，请先绑定机构码"];
    }

    
    
    
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.tableView_post])
    {
        BHMyPostsModel *model = self.postsArr[indexPath.row];
        BHPostDetailViewController * VC = [[BHPostDetailViewController alloc]init];
        VC.hidesBottomBarWhenPushed = YES;
        VC.tieZiID = model.tieziID;
        [self.navigationController pushViewController:VC animated:YES];
    }else if ([tableView isEqual:self.tableView])
    {
      
        BHNewPersonViewController * VC = [[BHNewPersonViewController alloc]init];
        VC.hidesBottomBarWhenPushed = YES;
        VC.uid = [self.usersArr[indexPath.row] objectForKey:@"uid"];
        [self.navigationController pushViewController:VC animated:YES];
        
    }else if ([tableView isEqual:self.tableView_org])
    {
        BHNewPersonViewController * VC = [[BHNewPersonViewController alloc]init];
        VC.hidesBottomBarWhenPushed = YES;
        VC.uid = [self.orgUserArr[indexPath.row] objectForKey:@"uid"];
        [self.navigationController pushViewController:VC animated:YES];

    }
}



-(NSMutableAttributedString*)convertStringToAttributeStr:(NSString*)string font:(NSInteger)font
{
    NSRange  range = [string rangeOfString:self.searchString options:NSBackwardsSearch range:NSMakeRange(0, string.length)];
    //            NSLog(@"range=%lu%lu",(unsigned long)range.length,(unsigned long)range.location);
    NSMutableAttributedString * attribute = [[NSMutableAttributedString alloc]initWithString:string];
    //富文本样式
    [attribute addAttribute:NSForegroundColorAttributeName  //文字颜色
                      value:[UIColor colorWithRed:23/255.0f green:183/255.0f blue:242/255.0f alpha:1]
                      range:range];
    [attribute addAttribute:NSFontAttributeName             //文字字体
                      value:[UIFont systemFontOfSize:font]
                      range:range];
    return attribute;
}

-(void)clickLikeButtonAction:(ZJMyPostBettomView *)ZJPostBodyView
{

}
- (void)clickComButtonAction:(ZJMyPostBettomView *)ZJPostBodyView
{

}

#pragma mark - 关注提示
- (void)alertView:(NSString *)title message:(NSString *)message
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:^{
            
        }];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
            
        });
    }else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alert dismissWithClickedButtonIndex:1 animated:YES];
        });
        
    }
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




//#pragma mark --设置分割线的偏移量
////将列表的分割线从头开始
////最新的，简便些
//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
//        [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
//    }
//    
//    
//    if (IOS_VERSION >= 8.0) {
//        if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)])
//        {
//            [cell setPreservesSuperviewLayoutMargins:NO];
//        }
//        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
//            [cell setLayoutMargins:UIEdgeInsetsMake(0,0, 0, 0)];
//        }
//    }
//}

@end
