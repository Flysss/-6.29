//
//  tixianVC.m
//  SalesHelper_A
//
//  Created by zhipu on 15/8/5.
//  Copyright (c) 2015年 X. All rights reserved.
//

#import "tixianVC.h"
#import "ChangePasswordViewController.h"
#import "ForgetPassStep1ViewController.h"
@interface tixianVC ()

@end

@implementation tixianVC
{

    UITableView* bigTableview;
    NSArray* nameArr;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden  = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
  
    
    [self CreateCustomNavigtionBarWith:self leftItem:@selector(backlastView:) rightItem:nil];
    //创建标题
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-120)/2, 27, 120, 30)];
    titleLabel.text = @"提现密码";
    titleLabel.font = Default_Font_20;
    [titleLabel setTextColor:[UIColor whiteColor]];
    //    [titleLabel sizeToFit];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.topView addSubview: titleLabel];
    
    nameArr = [[NSArray alloc]initWithObjects:@"忘记提现密码",@"修改提现密码" ,nil];
    bigTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 64+10, SCREEN_WIDTH, 88) style:UITableViewStylePlain];
    bigTableview.delegate=self;
    bigTableview.dataSource=self;
    bigTableview.scrollEnabled=NO;
    bigTableview.rowHeight = 44;
    [self.view addSubview:bigTableview];
}

- (void)backlastView:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return 2;

}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }if (IOS_VERSION>=8.0) {
        if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
            [cell setPreservesSuperviewLayoutMargins:NO];
        }if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
    }


}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   static NSString* identifier=@"cell";
    UITableViewCell* cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    if (!cell) {
        cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    }
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = Default_Font_16;
    cell.textLabel.textColor = [UIColor colorWithRed:0.278 green:0.271 blue:0.271 alpha:1.000];
    cell.textLabel.text=nameArr[indexPath.row];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [bigTableview deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row==0) {

        ForgetPassStep1ViewController* forgetVC=[[ForgetPassStep1ViewController alloc]init];
        forgetVC.fromViewType = @"drawalView";
        forgetVC.title = @"忘记提现密码";
        [forgetVC creatBackButtonWithPushType:Push With:self.title Action:nil];
        [self.navigationController pushViewController:forgetVC animated:YES];
    
    
    }if (indexPath.row==1) {
        ChangePasswordViewController* changVC=[[ChangePasswordViewController alloc]init];
        changVC.title=@"修改提现密码";
        changVC.changeType=@"drawalPwd";
        [self.navigationController pushViewController:changVC animated:YES];
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
