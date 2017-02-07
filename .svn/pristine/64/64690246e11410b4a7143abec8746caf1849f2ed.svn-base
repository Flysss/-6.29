//
//  BHChatViewController.m
//  SalesHelper_A
//
//  Created by zhipu on 16/2/25.
//  Copyright © 2016年 X. All rights reserved.
//

#import "BHChatViewController.h"
#import "UIColor+HexColor.h"

@interface BHChatViewController ()
@property(nonatomic, strong) RCUserInfo *currentUserInfo;
@property (nonatomic, strong) UIView *topView;
@end

@implementation BHChatViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
#pragma mark -自定义导航栏
- (void)customTopView
{
    self.topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    UIButton *btnBack = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [btnBack setImage:[UIImage imageNamed:@"bc-1"] forState:(UIControlStateNormal)];
    [btnBack setImage:[UIImage imageByApplyingAlpha:[UIImage imageNamed:@"bc-1"]] forState:(UIControlStateHighlighted)];
    [btnBack addTarget:self action:@selector(backClick) forControlEvents:(UIControlEventTouchUpInside)];
    btnBack.frame = CGRectMake(11, 20, 30, 44);
    [self.topView addSubview:btnBack];
    
    UILabel *lblName = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 44)];
    lblName.textColor = [UIColor colorWithHexString:@"ffffff"];
    lblName.font = [UIFont systemFontOfSize:18];
    lblName.textAlignment = NSTextAlignmentCenter;
    lblName.tag = 505;
    lblName.text = self.ctitle;
    [self.topView addSubview:lblName];
    self.topView.backgroundColor = [UIColor colorWithHexString:@"00aff0"];
    
    
    
    
    [self.view addSubview:self.topView];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//     self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"返回" heighImage:@"返回" target:self action:@selector(backClick)];
    [self customTopView];
    

    self.conversationMessageCollectionView.contentInset = UIEdgeInsetsMake(44, 0, 0, 0);

}
- (void)backClick
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
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
