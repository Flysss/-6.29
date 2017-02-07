//
//  ShareSuccessViewController.m
//  SalesHelper_A
//
//  Created by Brant on 16/1/21.
//  Copyright (c) 2016年 X. All rights reserved.
//

#import "ShareSuccessViewController.h"

@interface ShareSuccessViewController ()

@end

@implementation ShareSuccessViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor hexChangeFloat:@"f2f2f2"];
    
    [self creatNavigation];
    
    [self creatView];
    //NSLog(@"%@",self.shareDic);
    
    
}
//导航栏
- (void)creatNavigation
{
    [self CreateCustomNavigtionBarWith:self leftItem:@selector(backlastView) rightItem:nil];
    UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    titleLable.text = @"分享成功";
    titleLable.font = Default_Font_18;
    titleLable.textColor = [UIColor whiteColor];
    titleLable.textAlignment = NSTextAlignmentCenter;
    [self.topView  addSubview: titleLable];}
-(void)backlastView
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)creatView
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-124)/2+64, 48, 124, 122)];
    imageView.image = [UIImage imageNamed:@"成功标志"];
    [self.view addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame)+22, SCREEN_WIDTH, 30)];
    label.textColor = [UIColor hexChangeFloat:@"e93a3b"];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"恭喜,分享成功!";
    label.font = Default_Font_20;
    [self.view addSubview:label];
    

    NSString *shareMoneyStr = self.shareDic[@"sharemoney"];
    
    NSString *string = [NSString stringWithFormat:@"获得%@元现金奖励, 已存入我的钱包", shareMoneyStr];
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc] initWithString:string];
    
    [AttributedStr addAttributes:@{NSForegroundColorAttributeName:[UIColor hexChangeFloat:@"e93a3b"]} range:NSMakeRange(2,[shareMoneyStr length])];
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(label.frame)+10, SCREEN_WIDTH, 20)];
    label1.text = string;
    label1.textColor = [UIColor hexChangeFloat:@"898989"];
    label1.font = Default_Font_13;
    label1.textAlignment = NSTextAlignmentCenter;
    label1.attributedText = AttributedStr;
    
    [self.view addSubview:label1];
    
    
    UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(56, CGRectGetMaxY(label1.frame)+75, SCREEN_WIDTH-112, 39)];
    [button1 setBackgroundImage:[UIImage imageNamed:@"继续分享"] forState:UIControlStateNormal];
    [button1 setBackgroundImage:[UIImage imageNamed:@"继续分享"] forState:UIControlStateHighlighted];
    [button1 setTitle:@"继续分享到社交媒体" forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button1.titleLabel.font = Default_Font_15;
    [button1 addTarget:self action:@selector(continueShare) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
    
    UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(56, CGRectGetMaxY(button1.frame)+17, SCREEN_WIDTH-112, 39)];
    [button2 setBackgroundImage:[UIImage imageNamed:@"去钱包"] forState:UIControlStateNormal];
    [button2 setBackgroundImage:[UIImage imageNamed:@"去钱包"] forState:UIControlStateHighlighted];
    [button2 setTitle:@"去我的钱包看看" forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor hexChangeFloat:@"e93a3b"] forState:UIControlStateNormal];
    button2.titleLabel.font = Default_Font_15;
    [button2 addTarget:self action:@selector(toSeeMoney) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];

}

//继续分享
- (void)continueShare
{
    [self backlastView];
}

//去钱包看看
- (void)toSeeMoney
{
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"MyPurseViewController"];
    [self.navigationController pushViewController:vc animated:YES];
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
