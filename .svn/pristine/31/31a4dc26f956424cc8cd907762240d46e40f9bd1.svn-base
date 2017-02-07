//
//  SelectdShareViewController.m
//  SalesHelper_A
//
//  Created by flysss on 16/4/29.
//  Copyright © 2016年 X. All rights reserved.
//

#import "SelectdShareViewController.h"


@interface SelectdShareViewController () 




@end

@implementation SelectdShareViewController
{
    
        
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self CreateCustomNavigtionBarWith:self leftItem:@selector(backlastView) rightItem:@selector(clickToComplete)];
    [self.rightBtn setTitle:@"完成" forState:UIControlStateNormal];
    [self.rightBtn setImage:nil forState:UIControlStateNormal];
    [self layoutSubViews];
    
}
-(void)backlastView
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)clickToComplete
{
    
    NSArray * vcArr = self.navigationController.viewControllers;
    [self.navigationController popToViewController:vcArr[1] animated:YES];
    
    
}

-(void)layoutSubViews
{
    UIImageView * successImg = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-80)/2, 64+40, 80, 80)];
    successImg.image = [UIImage imageNamed:@"成功标志"];
    [self.view addSubview:successImg];
    
    UILabel * noticeLab = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(successImg.frame)+30, SCREEN_WIDTH-40, 20)];
    noticeLab.text = @"恭喜您，我的售楼部开通成功!";
    noticeLab.textColor = [UIColor hexChangeFloat:@"00aff0"];
    noticeLab.textAlignment = NSTextAlignmentCenter;
    noticeLab.font  =  Default_Font_17;
    [self.view addSubview:noticeLab];
    
    UIButton * shareBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(noticeLab.frame)+30, SCREEN_WIDTH-20, 40)];
    [shareBtn setTitle:@"去分享到社交平台吧" forState:UIControlStateNormal];
    [shareBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(goToShared:) forControlEvents:UIControlEventTouchUpInside];
    shareBtn.backgroundColor = [UIColor hexChangeFloat:@"00aff0"];
    shareBtn.layer.cornerRadius = 5.0f;
    shareBtn.layer.masksToBounds = YES;
    [self.view addSubview:shareBtn];
    
}

-(void)goToShared:(UIButton*)sender
{
    
    
    
    
    
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
