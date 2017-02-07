//
//  NewClientsManagerViewController.m
//  SalesHelper_A
//
//  Created by summer on 15/10/30.
//  Copyright © 2015年 X. All rights reserved.
//

#import "NewClientsManagerViewController.h"
#import "UIScrollView+EmptyDataSet.h"
#import "NewClientsManagerTableViewCell.h"
#import "ProjectUtil.h"
#import "AddClientViewController.h"
#import "ClientsInfosViewController.h"

@interface NewClientsManagerViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UISearchBar *mySearchBar;

@end

@implementation NewClientsManagerViewController
{
    NSArray * dataArr;
    NSArray * searchArr;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden =YES;
    
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self CreateCustomNavigtionBarWith:self leftItem:@selector(backToView) rightItem:@selector(add)];
    //创建标题
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-120)/2, 27, 120, 30)];
    titleLabel.text = @"客户";
    titleLabel.font = Default_Font_20;
    [titleLabel setTextColor:[UIColor whiteColor]];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.topView addSubview: titleLabel];
    [self.rightBtn setImage:[UIImage imageNamed:@"销邦-首页-新-增加.png"] forState:UIControlStateNormal];
    [self.rightBtn setImage:[UIImage imageByApplyingAlpha:[UIImage imageNamed:@"销邦-首页-新-增加.png"]] forState:UIControlStateHighlighted];
    self.rightBtn.tintColor = [UIColor whiteColor];

//    self.myTableView.frame = CGRectMake(0, 64+44, SCREEN_WIDTH, SCREEN_HEIGHT);
//    self.mySearchBar.frame = CGRectMake(0, 64, SCREEN_WIDTH, 44);
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    [_myTableView setTableFooterView:view];
    _myTableView.sectionIndexColor = [ProjectUtil colorWithHexString:@"767676"];
    _myTableView.sectionIndexBackgroundColor = [UIColor clearColor];
    [self requestDataWithCach:YES];
    [self refreshingTableView];
   
}

- (void)backToView
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)add
{
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"ClientsManager" bundle:nil];
    AddClientViewController * recommend = [storyboard instantiateViewControllerWithIdentifier:@"AddClientViewController"];
    __weak  typeof(&*self)WS  = self;
    [recommend refesh:^{
        [WS requestDataWithCach:NO];
    }];
    [self.navigationController pushViewController:recommend animated:YES];
}

- (void)requestDataWithCach:(BOOL)cach
{
    RequestInterface * interface = [[RequestInterface alloc] init];
    NSUserDefaults *uyserInfo = [NSUserDefaults standardUserDefaults];
    
//    interface.cachDisk = cach;
    [interface requestMyCustmorsManagerWithToken:[uyserInfo objectForKey:@"Login_User_token"]];
    NSLog(@"%@", [uyserInfo objectForKey:@"Login_User_token"]);
    [self.view Loading_0314];
    [interface getInterfaceRequestObject:^(id data) {
        if ([[data objectForKey:@"success"] boolValue])
        {
            [self.view Hidden];
            NSLog(@"客户列表数据 == %@", data);
            dataArr = [data objectForKey:@"datas"];
            searchArr = [data objectForKey:@"list"];
            [_myTableView reloadData];
        }
    } Fail:^(NSError *error) {
        [self.view Hidden];
        [self.view makeToast:@"网络错误"];
    }];
}

-(void)refreshingTableView
{
    //下拉刷新
    __weak typeof(*&self)WeakSelf = self;
    [_myTableView addHeaderWithCallback:^{
        [_myTableView headerEndRefreshing];
        [WeakSelf refreshingHeaderTableView];
    }];
}
- (void)refreshingHeaderTableView
{
    [self requestDataWithCach:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -- UITableViewDelegate && UITablewViewDatasource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray * arr = [[dataArr objectAtIndex:section]objectForKey:@"listData"];
    return arr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewClientsManagerTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"custmor"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.dataSource = dataArr[indexPath.section][@"listData"][indexPath.row];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isChoosen)
    {
        if (self.myBlock)
        {
            self.myBlock([[[dataArr objectAtIndex:indexPath.section]objectForKey:@"listData"] objectAtIndex:indexPath.row]);
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else
    {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
#pragma mark --从客户跳转到客户详情
        UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"ClientsManager" bundle:nil];
        ClientsInfosViewController * recommend = [storyboard instantiateViewControllerWithIdentifier:@"ClientsInfosViewController"];
        recommend.custmorData = [[[dataArr objectAtIndex:indexPath.section] objectForKey:@"listData"] objectAtIndex:indexPath.row];
        
        __weak  typeof(&*self)WS  = self;
        [recommend refeshCLientsManager:^{
            
            if (recommend.isEdit)
            {
                [WS requestDataWithCach:NO];
            }
        }];
        [self.navigationController pushViewController:recommend animated:YES];
    }
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:0];
    [arr addObject:@"{search}"];//等价于[arr addObject:UITableViewIndexSearch];
    [arr addObjectsFromArray:searchArr];
    return arr;
}


-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
        UIView *headView = [[UIView alloc]init];
        headView.backgroundColor = [UIColor clearColor];
        //标题背景
        UIView *biaotiView = [[UIView alloc]init];
        biaotiView.backgroundColor = [ProjectUtil colorWithHexString:@"f2f2f2"];
        biaotiView.frame=CGRectMake(0, 0, self.view.width, 30);
        [headView addSubview:biaotiView];
         
        //标题文字
        UILabel *lblBiaoti = [[UILabel alloc]init];
        lblBiaoti.backgroundColor = [UIColor clearColor];
        lblBiaoti.textAlignment = NSTextAlignmentLeft;
        lblBiaoti.font = [UIFont systemFontOfSize:15];
        lblBiaoti.textColor = [ProjectUtil colorWithHexString:@"767676"];
        lblBiaoti.frame = CGRectMake(15,0, 200, 30);
        lblBiaoti.text = [searchArr objectAtIndex:section];
        [biaotiView addSubview:lblBiaoti];
        return headView;
}
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if (index != 0)
    {
        [tableView
         scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index-1]
         atScrollPosition:UITableViewScrollPositionTop animated:YES];
        return index -1;
    }
    else if (index == 0)
    {
        [_mySearchBar becomeFirstResponder];
        return 0;
    }
    else
    {
        return index;
    }
}
#pragma mark -- #pragma mark - UISerchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    _mySearchBar.showsCancelButton = YES;
    return YES;
}


- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    _mySearchBar.showsCancelButton = NO;
    [_mySearchBar resignFirstResponder];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    _mySearchBar.showsCancelButton = NO;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if (_mySearchBar.text.length) {
        RequestInterface * interface = [[RequestInterface alloc]init];
        NSDictionary * dict = @{
                                @"token":self.login_user_token,
                                @"keywords":searchBar.text,
                                };
        [interface requestMyCustmorSearchWith:dict];
        [self.view Loading_0314];
        [interface getInterfaceRequestObject:^(id data) {
            if ([[data objectForKey:@"success"] boolValue])
            {
                [self.view Hidden];
                dataArr = [data objectForKey:@"datas"];
                searchArr = [data objectForKey:@"list"];
                [_myTableView reloadData];
            }
            else
            {
                [self.view Hidden];

                [self.view makeToast:HintWithNetError];
            }
        } Fail:^(NSError *error) {
            [self.view Hidden];

            [self.view makeToast:HintWithNetError];
        }];
    }
    [_mySearchBar resignFirstResponder];
}


-(void)passContentWithBlock:(passContentBlock)block
{
    self.myBlock = block;
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
