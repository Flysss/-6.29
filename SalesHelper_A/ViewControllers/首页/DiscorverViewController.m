//
//  DiscorverViewController.m
//  SalesHelper_A
//
//  Created by zhipu on 15/7/15.
//  Copyright (c) 2015年 X. All rights reserved.
//

#import "DiscorverViewController.h"
#import "ShareMakeMoneyViewController.h"
#import "RequestInterface.h"
#import "ModelWebViewController.h"
#import "sys/utsname.h"
#import "UIImageView+WebCache.h"
#import "NoticeViewController.h"
#import "LoginViewController.h"
//#import "TwohandHouseViewController.h"

@interface DiscorverViewController () <UITabBarControllerDelegate>
{

    UITableView *myTableView;

    NSArray *_listNameArray;   //列表标题
    NSMutableArray * _dataSource;
    NSMutableArray * _dataSourceReSord;
}
@end

@implementation DiscorverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataSource = [NSMutableArray arrayWithCapacity:0];
    
    [self requestData];
    
    [self creatTableView];

    UILabel * titleLabel = [UILabel new];
    titleLabel.text = @"发现";
    titleLabel.font = Default_Font_18;
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0/255.0f green:175/255.0f blue:240/255.0f alpha:1];

    self.tabBarController.delegate = self;

}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[self imageWithBgColor:[UIColor colorWithRed:0/255.0f green:175/255.0f blue:240/255.0f alpha:1]] forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController.navigationBar setShadowImage:[self imageWithBgColor:[UIColor colorWithRed:0/255.0f green:175/255.0f blue:250/255.0f alpha:1]]];
    
}

#pragma mark  绘制图片
-(UIImage *)imageWithBgColor:(UIColor *)color {
    
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)creatTableView
{
    myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-50) style:UITableViewStyleGrouped];
    myTableView.delegate = self;
    myTableView.dataSource = self;
//    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableView.tableFooterView = [UIView new];
    [self.view addSubview:myTableView];
}

- (void)requestData
{
    RequestInterface * loadPerpoty = [[RequestInterface alloc] init];
    
    [self.view Loading_0314];
    [loadPerpoty requestGEtDisCover];
    [loadPerpoty getInterfaceRequestObject:^(id data) {
        if ([data objectForKey:@"success"]) {
            
            [self.view Hidden];
            
            [_dataSource removeAllObjects];
            [_dataSource addObjectsFromArray:[data objectForKey:@"datas"]];
            
            _dataSourceReSord = [NSMutableArray array];
            NSMutableArray *  arr1 = [NSMutableArray array];
            [arr1 addObject:_dataSource[0]];
            [_dataSourceReSord addObject:arr1];
            
            for (int i = 1; i < _dataSource.count; i++) {
                NSMutableArray * arr = [NSMutableArray array];
                if (i % 2 == 1) {
                    [arr addObject:_dataSource[i]];
                    if (i != _dataSource.count-1) {
                        [arr addObject:_dataSource[i+1]];
                    }
                }
                if (arr.count > 0) {
                    [_dataSourceReSord addObject:arr];
                }
            }
            [myTableView reloadData];
            
        }else
        {
            [self.view Hidden];
            [self.view makeToast:@"加载失败"];
        }
        
    } Fail:^(NSError *error) {
        [self.view Hidden];
    }];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    if (viewController == [tabBarController.viewControllers objectAtIndex:3]) //assuming the index of uinavigationcontroller is 2
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        //判断是否登录过
        if(![defaults boolForKey:@"SalesHelper_publicNotice"])
        {
            if ([defaults valueForKey:@"Login_User_token"] != nil) {
                return YES;
            }else {
                
                UINavigationController *loginVC = [[UINavigationController alloc] initWithRootViewController:[[LoginViewController alloc]init]];
                [self presentViewController:loginVC animated:YES completion:nil];
//                LoginAndRegisterViewController *vc = [[LoginAndRegisterViewController alloc] init];
//                [self presentViewController:vc animated:YES completion:nil];
                
                return NO;
            }
            //存数据--->基本数据类型
        }
        else
        {
            return YES;
        }
    }else {
        return YES;
    }
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//    return _dataSourceReSord.count;
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if (section == 0)
//    {
//        return 1;
//    }
//    else
//    {
//        NSArray * array = _dataSourceReSord[section];
//        return array.count;
//    }
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc]initWithFrame:CGRectZero];
}
-(UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* identifer=@"cell";
    UITableViewCell* cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    if (!cell) {
        cell=[tableView dequeueReusableCellWithIdentifier:identifer];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

//    if (indexPath.section == 2)
//    {
//        UIImageView * imag =[[UIImageView alloc]initWithFrame:CGRectMake(12, 10, 29, 29)];
//        [imag setImage:[UIImage imageNamed:@"二手的房子.jpg"]];
//        [cell.contentView addSubview:imag];
//        
//        UILabel* titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(55, 5, SCREEN_WIDTH-60, 40)];
//        titleLabel.text = @"二手房";
//        [cell.contentView addSubview:titleLabel];
//    }
//    else
//    {
        UILabel* titlelabel=[[UILabel alloc]initWithFrame:CGRectMake(55, 5, SCREEN_WIDTH-60, 40)];
        titlelabel.text= [[[_dataSourceReSord objectAtIndex:indexPath.section]objectAtIndex:indexPath.row] objectForKey:@"name"];
        [cell.contentView addSubview:titlelabel];
        
        struct utsname systemInfo;
        uname(&systemInfo);
        NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
        
        UIImageView * image=[[UIImageView alloc]initWithFrame:CGRectMake(12, 10, 29, 29)];
        if ([UIScreen mainScreen].bounds.size.width == 414)
        {
            [image sd_setImageWithURL:[[[_dataSourceReSord objectAtIndex:indexPath.section]objectAtIndex:indexPath.row]objectForKey:@"imageUrl3"]];
        }
        else
        {
            [image sd_setImageWithURL:[[[_dataSourceReSord objectAtIndex:indexPath.section]objectAtIndex:indexPath.row]objectForKey:@"imageUrl2"]];
        }
        if ([deviceString isEqualToString:@"iPhone3,1"])
        {
            [image sd_setImageWithURL:[[[_dataSourceReSord objectAtIndex:indexPath.section]objectAtIndex:indexPath.row]objectForKey:@"imageUrl"]];
        }
        [cell.contentView addSubview:image];
        
//    }

    return cell;
}




-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if ([_listNameArray[indexPath.row]isEqualToString:@"分享赚钱"]) {
//        UITableViewCell* cell=[tableView cellForRowAtIndexPath:indexPath];
//        UILabel * titlelabel=(UILabel* )[cell.contentView viewWithTag:1001];
//        if (titlelabel.text.length==0) {
//            return;
//        }
//    }
    
    //分享好友
    if (indexPath.section == 0 && indexPath.row == 0)
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        //判断是否登录过
        if(![defaults boolForKey:@"SalesHelper_publicNotice"])
        {
            //存数据--->基本数据类型
            [defaults setBool:NO forKey:@"SalesHelper_publicNotice"];//存 公告内容
            [defaults setBool:NO forKey:@"SalesHelper_AdvertView"];//存 广告内容
            [defaults synchronize];
            
            if ([defaults valueForKey:@"Login_User_token"] != nil)
            {
                ShareMakeMoneyViewController * shareVC =[[ShareMakeMoneyViewController alloc] init];
                shareVC.hidesBottomBarWhenPushed=YES;
                [self.navigationController pushViewController:shareVC animated:YES];
            }
            else
            {
                UINavigationController *mainNaVC = [[UINavigationController alloc] initWithRootViewController:[[LoginViewController alloc]init]];
                [self presentViewController:mainNaVC animated:YES completion:nil];
                
//                LoginAndRegisterViewController *vc = [[LoginAndRegisterViewController alloc] init];
//                [self presentViewController:vc animated:YES completion:nil];
            }
            
        }
       
    }
    //最新公告
    else if (indexPath.row == 0 && indexPath.section == 1)
    {
        NoticeViewController* noticeVC = [[NoticeViewController alloc]init];
        noticeVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:noticeVC animated:YES];
        
    }
//    else if (indexPath.section == 2)
//    {
//        TwohandHouseViewController *vc = [[TwohandHouseViewController alloc] init];
//        vc.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:vc animated:YES];
//    }
    else
    {
//        ModelWebViewController * web = [[ModelWebViewController alloc] initWithUrlString:[[[_dataSourceReSord objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"url"] NavigationTitle:[[[_dataSourceReSord objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"name"]];
        
        NSString *url = _dataSourceReSord[indexPath.section][indexPath.row][@"url"];
        NSString *name = _dataSourceReSord[indexPath.section][indexPath.row][@"name"];
        ModelWebViewController *web = [[ModelWebViewController alloc] initWithUrlString:url NavigationTitle:name];
            web.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:web animated:YES];
    }
   
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIEdgeInsets inset = UIEdgeInsetsMake(0, 12, 0, 0);
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:inset];
    }
    
    
    if (IOS_VERSION >= 8.0) {
        if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)])
        {
            [cell setPreservesSuperviewLayoutMargins:NO];
        }
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:inset];
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
