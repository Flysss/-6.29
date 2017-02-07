//
//  BHChatListViewController.m
//  SalesHelper_A
//
//  Created by zhipu on 16/2/25.
//  Copyright © 2016年 X. All rights reserved.
//

#import "BHChatListViewController.h"
#import "BHChatViewController.h"

#import "UIColor+HexColor.h"
@interface BHChatListViewController ()
@property(nonatomic, strong) RCUserInfo *currentUserInfo;
@property (nonatomic, strong) UIView *topView;


@end

@implementation BHChatListViewController
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
    lblName.text = @"会话列表";
    [self.topView addSubview:lblName];
    self.topView.backgroundColor = [UIColor colorWithHexString:@"00aff0"];
    
    
    
    
    [self.view addSubview:self.topView];
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"返回" heighImage:@"返回" target:self action:@selector(backClick)];
    [self customTopView];
    self.conversationListTableView.contentInset = UIEdgeInsetsMake(44, 0, 0, 0);
    
//    UILabel *lblTitle = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-30, 0, 60, 44)];
//    lblTitle.text = @"会话列表";
//    lblTitle.textAlignment = NSTextAlignmentCenter;
//    lblTitle.textColor = [UIColor whiteColor];
//    self.navigationItem.titleView = lblTitle;
    
    
    self.conversationListTableView.tableFooterView = [[UIView alloc] init];
    //设置需要显示哪些类型的会话
    [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),
                                        @(ConversationType_DISCUSSION),
                                        @(ConversationType_CHATROOM),
                                        @(ConversationType_GROUP),
                                        @(ConversationType_APPSERVICE),
                                        @(ConversationType_SYSTEM)]];
}

- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType
         conversationModel:(RCConversationModel *)model
               atIndexPath:(NSIndexPath *)indexPath {
    //    RCConversationViewController *conversationVC = [[RCConversationViewController alloc]init];
    //    conversationVC.conversationType = model.conversationType;
    //    conversationVC.targetId = model.targetId;
    //    conversationVC.title =model.conversationTitle;
    //    [self.navigationController pushViewController:conversationVC animated:YES];
    BHChatViewController *vc = [[BHChatViewController alloc] init];
    vc.conversationType = model.conversationType;
    vc.targetId = model.targetId;
    //    vc.title = model.conversationTitle;
    
    
    UILabel *lblTitle = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-30, 0, 60, 44)];
    lblTitle.text = model.conversationTitle;
    lblTitle.textAlignment = NSTextAlignmentCenter;
    lblTitle.textColor = [UIColor whiteColor];
    vc.navigationItem.titleView = lblTitle;
    vc.ctitle = model.conversationTitle;
    
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)backClick
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
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
