//
//  EditionBankViewController.m
//  SalesHelper_A
//
//  Created by zhipu on 14/11/12.
//  Copyright (c) 2014年 zhipu. All rights reserved.
//

#import "EditionBankViewController.h"

@interface EditionBankViewController ()<UIActionSheetDelegate>

@end

@implementation EditionBankViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self CreateCustomNavigtionBarWith:self leftItem:@selector(backToView) rightItem:@selector(editionBankInfo:)];
    [self.rightBtn setTitle:@"删除" forState:UIControlStateNormal];
    [self.rightBtn setImage:nil forState:UIControlStateNormal];
    
    //创建标题
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-120)/2, 27, 120, 30)];
    titleLabel.text = @"银行卡详情";
    titleLabel.font = Default_Font_20;
    [titleLabel setTextColor:[UIColor whiteColor]];
    //    [titleLabel sizeToFit];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.topView addSubview: titleLabel];
    
    
//    UIButton *rightBtn = [self creatUIButtonWithFrame:CGRectMake(0, 20, 40, 30) BackgroundColor:nil Title:@"删除" TitleColor:NavigationBarTitleColor Action:@selector(editionBankInfo:)];
//    [rightBtn setTitleEdgeInsets:UIEdgeInsetsMake(2.0, 3.0, 0.0, 0.0)];
//    if (IOS_VERSION<7.0)
//    {
//        rightBtn.titleEdgeInsets = UIEdgeInsetsMake(2.0, -10.0, 0, 0.0);
//    }
//    rightBtn.titleLabel.font = Default_Font_17;
//    //    rightBtn.backgroundColor = [UIColor redColor];
//    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:[self creatNegativeSpacerButton],[[UIBarButtonItem alloc] initWithCustomView:rightBtn], nil];
//    
    
    
    
    [self layoutSubViews];
}

-(void)backToView
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)layoutSubViews
{
    UIView *bankView = [[UIView alloc] initWithFrame:CGRectMake(10, 64+10, SCREEN_WIDTH -20, 60)];
    bankView.backgroundColor = [UIColor whiteColor];
    bankView.layer.cornerRadius = 5;
    [self.view addSubview:bankView];
    
    UIImageView *bankImage = [[UIImageView alloc] initWithFrame:CGRectMake(8, 15, 40, 26)];
    [bankImage sd_setImageWithURL:[NSURL URLWithString:self.bankDictInfo[@"bankIcon"]]];
     [bankView addSubview:bankImage];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 5, 200, 30)];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.font = Default_Font_15;
    nameLabel.text = self.bankDictInfo[@"name"];
    [bankView addSubview:nameLabel];

    UILabel *numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 30, 200, 30)];
    numberLabel.backgroundColor = [UIColor clearColor];
    numberLabel.font = Default_Font_13;
    numberLabel.textColor = [UIColor lightGrayColor];
    numberLabel.text = [self normalNumToBankNum:self.bankDictInfo[@"account"]];
    [bankView addSubview:numberLabel];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 正常号转银行卡号 － 增加4位间的空格
-(NSString *)normalNumToBankNum:(NSString *)tmpStr
{
    
    int size = (int)((long)tmpStr.length / 4);
    
    NSMutableArray *tmpStrArr = [[NSMutableArray alloc] init];
    for (int n = 0;n < size; n++)
    {
        [tmpStrArr addObject:[tmpStr substringWithRange:NSMakeRange(n*4, 4)]];
    }
    
    [tmpStrArr addObject:[tmpStr substringWithRange:NSMakeRange(size*4, (tmpStr.length % 4))]];
    
    for (int i=1; i<tmpStrArr.count-2; i++) {
        [tmpStrArr replaceObjectAtIndex:i withObject:@"****"];
    }
    [ProjectUtil showLog:@"addObject %@",[tmpStr substringWithRange:NSMakeRange(size*4, (tmpStr.length % 4))]];
    
    tmpStr = [tmpStrArr componentsJoinedByString:@" "];
    
    return tmpStr;
}


//点击删除样式系统弹出的方法

- (void)editionBankInfo:(id)sender
{
    UIActionSheet* mySheet = [[UIActionSheet alloc]
                              initWithTitle:@"你确定吗?"
                              delegate:self
                              cancelButtonTitle:@"取消"
                              destructiveButtonTitle:nil
                              otherButtonTitles:@"删除", nil];
    [mySheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [ProjectUtil showLog:@"buttonIndex = %d",buttonIndex];
    if (buttonIndex == 0) {
        [self requestDeleteWithd];
    }
}

//删除绑定银行卡信息
- (void)requestDeleteWithd
{
    NSDictionary *dict = @{@"token":self.login_user_token,
                          // @"identity":@"0",
                           @"withdrawBankId":self.bankDictInfo[@"id"]
                           };
    RequestInterface *requestHOp = [[RequestInterface alloc] init];
    [requestHOp requestDeleteWithdWithParam:dict];
    [self.view makeProgressViewWithTitle:@"正在删除"];
    [requestHOp getInterfaceRequestObject:^(id data) {
        [ProjectUtil showLog:@"data = %@",data];
        [self.view hideProgressView];
        if ([data[@"success"]boolValue]) {
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            [self.view makeToast:data[@"error_remark"]];
        }
        
    } Fail:^(NSError *error) {
         [self.view hideProgressView];
        [self.view makeToast:HintWithNetError];
    }];
}

@end
