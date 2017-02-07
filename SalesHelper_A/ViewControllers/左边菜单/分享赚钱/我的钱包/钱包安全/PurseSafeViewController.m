//
//  PurseSafeViewController.m
//  SalesHelper_A
//
//  Created by summer on 14/12/20.
//  Copyright (c) 2014年 X. All rights reserved.
//

#import "PurseSafeViewController.h"
#import "SetDrawalStep1ViewController.h"
#import "ChangePasswordViewController.h"

@interface PurseSafeViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *_itemArr;
}
@end

@implementation PurseSafeViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden  = YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self layoutSubViews];
    
    [self CreateCustomNavigtionBarWith:self leftItem:@selector(backlastView:) rightItem:nil];
    //创建标题
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-120)/2, 27, 120, 30)];
    titleLabel.text = @"提现密码";
    titleLabel.font = Default_Font_20;
    [titleLabel setTextColor:[UIColor whiteColor]];
    //    [titleLabel sizeToFit];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.topView addSubview: titleLabel];
    
//    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:21.0/255.0 green:159/255.0 blue:234/255.0 alpha:1]];
}
- (void)backlastView:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)layoutSubViews
{
    _itemArr = [NSArray arrayWithObjects:@"设置提现密码",@"修改提现密码", nil];
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 10+64, SCREEN_WIDTH, _itemArr.count*44) style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.bounces = NO;
    [self.view addSubview:tableView];
//    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:21.0/255.0 green:159/255.0 blue:234/255.0 alpha:1]];
    
}

#pragma mark UITableViewDataSource,UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _itemArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.font = Default_Font_15;
    cell.textLabel.text = [_itemArr objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.row==0)
    {
        //设置提现密码
        SetDrawalStep1ViewController *withDrawalVC = [[SetDrawalStep1ViewController alloc] init];
        withDrawalVC.title = @"设置提现密码（1/3）";
        [withDrawalVC creatBackButtonWithPushType:Push With:@"安全" Action:nil];
        [self.navigationController pushViewController:withDrawalVC animated:YES];
        
    }
    if (indexPath.row==1)
    {
        //修改提现密码
        ChangePasswordViewController *changeVC = [[ChangePasswordViewController alloc] init];
        changeVC.changeType = DRAWAL_PWD;
        changeVC.title = @"修改提现密码";
        [changeVC creatBackButtonWithPushType:Push With:@"安全" Action:nil];
        [self.navigationController pushViewController:changeVC animated:YES];
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
