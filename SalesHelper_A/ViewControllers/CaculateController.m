//
//  CaculateController.m
//  SalesHelperC
//
//  Created by My on 16/1/22.
//  Copyright © 2016年 X. All rights reserved.
//

#import "CaculateController.h"
#import "UIColor+Extend.h"

@interface CaculateController ()

@property (nonatomic, strong) UIView * topView;
@property (nonatomic, strong) UIButton * backBtn;
@property (nonatomic, strong) UIButton * rightBtn;

@end

@implementation CaculateController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    
    
    
//    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 30)];
//    titleLabel.text = @"房贷计算器";
//    titleLabel.textColor = [UIColor whiteColor];
//    titleLabel.font = Default_Font_18;
//    titleLabel.textAlignment = NSTextAlignmentCenter;
//    self.navigationItem.titleView = titleLabel;
//
//    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 26, 26)];
//    [backButton setImage:[UIImage imageNamed:@"首页-左箭头"] forState:UIControlStateNormal];
//    [backButton setImage:[UIImage imageByApplyingAlpha:[UIImage imageNamed:@"首页-左箭头"]] forState:UIControlStateHighlighted];
//    [backButton addTarget:self action:@selector(backToView) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self creatNaviController];
    
    UIWebView *caculweb = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [caculweb loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",@"http://sys.xiaobang.cc/Public/Data/fangdai/shangye.html"]] cachePolicy: NSURLRequestReturnCacheDataElseLoad timeoutInterval:30.0f]];
    [self.view addSubview:caculweb];
}

- (void)backToView
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark --创建导航栏
- (void)creatNaviController
{
    
    self.topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    self.topView.backgroundColor = [UIColor hexChangeFloat:@"00aff0"];
    self.backBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.backBtn setImage:[UIImage imageNamed:@"首页-左箭头"] forState:(UIControlStateNormal)];
    [self.backBtn setImage:[UIImage imageByApplyingAlpha:[UIImage imageNamed:@"首页-左箭头"]] forState:(UIControlStateHighlighted)];
    [self.backBtn addTarget:self action:@selector(backToView) forControlEvents:(UIControlEventTouchUpInside)];
    self.backBtn.frame = CGRectMake(11, 20, 30, 44);
    [self.topView addSubview:self.backBtn];
    
    self.rightBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.rightBtn.frame = CGRectMake(SCREEN_WIDTH-11-40, 20, 40, 44);
    [self.rightBtn addTarget:self action:@selector(backToView) forControlEvents:(UIControlEventTouchUpInside)];
    [self.topView addSubview:self.rightBtn];
    [self.view addSubview:self.topView];
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-120)/2, 27, 120, 30)];
    titleLabel.text = @"房贷计算器";
    titleLabel.font = Default_Font_20;
    [titleLabel setTextColor:[UIColor whiteColor]];
    //    [titleLabel sizeToFit];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.topView addSubview: titleLabel];

}



- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    //代理置空，否则会闪退
//    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
//    }
}
//#pragma mark -- 返回
- (void)didReceiveMemoryWarning
{
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
