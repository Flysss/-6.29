//
//  NewResignPerViewController.m
//  SalesHelper_A
//
//  Created by summer on 15/10/10.
//  Copyright © 2015年 X. All rights reserved.
//

#import "NewResignPerViewController.h"
#import "NewResignSubmitTableViewController.h"
#import "UIColor+Extend.h"

@interface NewResignPerViewController ()
//@property (weak, nonatomic) IBOutlet UIButton *personalSalerBtn;
//@property (weak, nonatomic) IBOutlet UIButton *companySalerBtn;
//@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@property (strong, nonatomic)  UIButton *personalSalerBtn;
@property (strong, nonatomic)  UIButton *companySalerBtn;
@property (strong, nonatomic)  UIButton *nextBtn;

@end

@implementation NewResignPerViewController
{
    UIButton * selectedBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"注册";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = Default_Font_18;
    self.navigationItem.titleView = titleLabel;
    
    UIButton* leftbtn=[UIButton buttonWithType:UIButtonTypeCustom];
    leftbtn.frame=CGRectMake(0, 0, 26, 26);
    [leftbtn setBackgroundImage:[UIImage imageNamed:@"首页-左箭头.png"] forState:UIControlStateNormal];
    [leftbtn setBackgroundImage:[UIImage imageByApplyingAlpha:[UIImage imageNamed:@"首页-左箭头.png"]] forState:UIControlStateHighlighted];
    
    [leftbtn addTarget:self action:@selector(backlastView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* back=[[UIBarButtonItem alloc]initWithCustomView:leftbtn];
    self.navigationItem.leftBarButtonItem=back;
    
    
    self.view.backgroundColor = [UIColor hexChangeFloat:@"f2f2f2"];
    
    //选择身份
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 100+64, SCREEN_WIDTH, 25)];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"请选择您的身份";
    label.font = Default_Font_18;
    label.textColor = [UIColor hexChangeFloat:@"b5b5b5"];
    [self.view addSubview:label];
    
    //个人经纪人
    self.personalSalerBtn = [[UIButton alloc] initWithFrame:CGRectMake(25, CGRectGetMaxY(label.frame)+30, 120, 40)];
    self.personalSalerBtn.layer.masksToBounds = YES;
    self.personalSalerBtn.layer.borderWidth = 1;
    self.personalSalerBtn.layer.cornerRadius = 3;
    self.personalSalerBtn.layer.borderColor =  [ProjectUtil colorWithHexString:KBlueColor].CGColor;
    [self.personalSalerBtn setTitle:@"个人经纪人" forState:UIControlStateNormal];
    [self.personalSalerBtn setTitleColor:[ProjectUtil colorWithHexString:KBlueColor] forState:UIControlStateNormal];
    
    //机构经纪人
    self.companySalerBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-145, CGRectGetMaxY(label.frame)+30, 120, 40)];
    self.companySalerBtn.layer.masksToBounds = YES;
    self.companySalerBtn.layer.borderWidth = 1;
    self.companySalerBtn.layer.cornerRadius = 3;
    self.companySalerBtn.layer.borderColor = [ProjectUtil colorWithHexString:@"727171"].CGColor;
    [self.companySalerBtn setTitle:@"机构经纪人" forState:UIControlStateNormal];
    [self.companySalerBtn setTitleColor:[ProjectUtil colorWithHexString:@"727171"] forState:UIControlStateNormal];
    
    self.personalSalerBtn.tag = 100;
    self.companySalerBtn.tag = 101;
    [self.personalSalerBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.companySalerBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    selectedBtn = self.personalSalerBtn;
    selectedBtn.selected = YES;
    selectedBtn.layer.borderColor = [ProjectUtil colorWithHexString:@"00aff0"].CGColor;
    
    [self.view addSubview:self.personalSalerBtn];
    [self.view addSubview:self.companySalerBtn];
    
    
    //下一步
    self.nextBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.companySalerBtn.frame)+100, SCREEN_WIDTH-40, 40)];
    self.nextBtn.backgroundColor = [UIColor hexChangeFloat:@"00aff0"];
    self.nextBtn.layer.masksToBounds = YES;
    self.nextBtn.layer.cornerRadius = 5;
    [self.nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [self.nextBtn addTarget:self action:@selector(nextButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.nextBtn];
    
    // Do any additional setup after loading the view.
}
- (void)backlastView
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)buttonClick:(UIButton *)sender
{
    selectedBtn.selected = NO;
    selectedBtn.layer.borderColor = [ProjectUtil colorWithHexString:@"727171"].CGColor;
    [selectedBtn setTitleColor:[ProjectUtil colorWithHexString:@"727171"] forState:UIControlStateNormal];
    
    selectedBtn = sender;
    selectedBtn.selected = YES;
    selectedBtn.layer.borderColor = [ProjectUtil colorWithHexString:@"00aff0"].CGColor;
    [selectedBtn setTitleColor:[ProjectUtil colorWithHexString:@"00aff0"] forState:UIControlStateNormal];
}

- (void)nextButtonClick
{
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"resignView" bundle:nil];
    NewResignSubmitTableViewController  * resign = [storyboard instantiateViewControllerWithIdentifier:@"NewResignSubmitTableViewController"];
    if (selectedBtn == self.personalSalerBtn) {
        resign.personal = YES;
    }else
    {
        resign.personal = NO;
    }
    [self.navigationController pushViewController:resign animated:YES];

}

//- (IBAction)buttonClick:(UIButton *)sender {
//    selectedBtn.selected = NO;
//    selectedBtn.layer.borderColor = [ProjectUtil colorWithHexString:@"727171"].CGColor;
//
//    selectedBtn = sender;
//    selectedBtn.selected = YES;
//    selectedBtn.layer.borderColor = [ProjectUtil colorWithHexString:@"00aff0"].CGColor;
//}
//- (IBAction)clickForNext:(id)sender {
//    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"resignView" bundle:nil];
//    NewResignSubmitTableViewController  * resign = [storyboard instantiateViewControllerWithIdentifier:@"NewResignSubmitTableViewController"];
//    if (selectedBtn == self.personalSalerBtn) {
//        resign.personal = YES;
//    }else
//    {
//        resign.personal = NO;
//    }
//    [self.navigationController pushViewController:resign animated:YES];
//
//}


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
