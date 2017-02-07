//
//  BaseViewController.m
//  SalesHelper_A
//
//  Created by ZhipuTech on 15/6/11.
//  Copyright (c) 2015年 X. All rights reserved.
//

#import "BaseViewController.h"
#import "UIColor+Extend.h"
@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
}
-(void)CreateCustomNavigtionBarWith:(id)target leftItem:(SEL)leftAction rightItem:(SEL)rightAction
{
    self.topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    self.topView.backgroundColor = [UIColor hexChangeFloat:@"00aff0"];
    self.backBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.backBtn setImage:[UIImage imageNamed:@"bc-1"] forState:(UIControlStateNormal)];
    [self.backBtn setImage:[UIImage imageByApplyingAlpha:[UIImage imageNamed:@"bc-1"]] forState:(UIControlStateHighlighted)];
    [self.backBtn addTarget:target action:leftAction forControlEvents:(UIControlEventTouchUpInside)];
    self.backBtn.frame = CGRectMake(11, 20, 30, 44);
    
    [self.topView addSubview:self.backBtn];
    
    self.rightBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.rightBtn.frame = CGRectMake(SCREEN_WIDTH-11-30, 20, 30, 44);
    [self.rightBtn setImage:[UIImage imageNamed:@"gd-1"] forState:(UIControlStateNormal)];
    [self.rightBtn addTarget:target action:rightAction forControlEvents:(UIControlEventTouchUpInside)];
    [self.topView addSubview:self.rightBtn];
    [self.view addSubview:self.topView];
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
