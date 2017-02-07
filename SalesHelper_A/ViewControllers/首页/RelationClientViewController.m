//
//  RelationClientViewController.m
//  SalesHelper_A
//
//  Created by Brant on 16/1/8.
//  Copyright (c) 2016年 X. All rights reserved.
//

#import "RelationClientViewController.h"
#import "NewClientsManagerViewController.h"
#import "IQKeyboardManager.h"

@interface RelationClientViewController () <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UITableView *m_tableView;
@property (nonatomic, strong) UILabel *relationLabel;
@end

@implementation RelationClientViewController
{
    UITextField * clientName;
    UITextField * iphone;
    UISegmentedControl * sexSegment;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;
    
    
//    [self creatNaviGationContr];
    [self CreateCustomNavigtionBarWith:self leftItem:@selector(backlastView) rightItem:nil];
    //创建标题
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-120)/2, 27, 120, 30)];
    titleLabel.text = @"关联客户";
    titleLabel.font = Default_Font_20;
    [titleLabel setTextColor:[UIColor whiteColor]];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.topView addSubview: titleLabel];
    
    [self creatTableView];
    
//    [self requestData];
    
}


#pragma mark--返回上一页
- (void)backlastView
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --创建列表
- (void)creatTableView
{
    self.m_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,64, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStyleGrouped];
    self.m_tableView.delegate = self;
    self.m_tableView.dataSource = self;
    self.m_tableView.tableFooterView = [[UIView alloc] init];
    self.m_tableView.contentInset = UIEdgeInsetsMake(12, 0, 0, 0);
    self.m_tableView.backgroundColor = [UIColor hexChangeFloat:@"f2f2f2"];
    [self.view addSubview:self.m_tableView];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"%@", indexPath]];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 0)
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-10-25, 50)];
        label.text = @"从客户列表导入";
        label.textColor = [UIColor hexChangeFloat:KBlackColor];
        label.font = Default_Font_15;
        [cell.contentView addSubview:label];
        
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-25, (50-17)/2, 9, 17)];
        image.image = [UIImage imageNamed:@"销邦-楼盘详情页-右箭头"];
        [cell.contentView addSubview:image];
        
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            clientName = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-100, 50)];
            clientName.delegate = self;
            clientName.placeholder = @"请输入关联客户姓名";
            clientName.font = Default_Font_15;
            clientName.textColor = [UIColor hexChangeFloat:KBlackColor];
            [cell.contentView addSubview:clientName];
            
            sexSegment = [[UISegmentedControl alloc] initWithItems:@[@"先生",@"女士"]];
            sexSegment.frame = CGRectMake(SCREEN_WIDTH-100, 10, 90, 30);
            sexSegment.layer.masksToBounds = YES;
            sexSegment.layer.cornerRadius = 15;
            
            sexSegment.layer.borderColor = [ProjectUtil colorWithHexString:@"00aff0"].CGColor;
            sexSegment.layer.borderWidth = 1.0;
            sexSegment.tintColor = [ProjectUtil colorWithHexString:@"00aff0"];
            sexSegment.selectedSegmentIndex = 0;
            [cell.contentView addSubview:sexSegment];
        }
        else
        {
            iphone = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-100, 50)];
            iphone.delegate = self;
            iphone.placeholder = @"请输入关联客户手机";
            iphone.font = Default_Font_15;
            iphone.keyboardType = UIKeyboardTypeNumberPad;
            iphone.textColor = [UIColor hexChangeFloat:KBlackColor];
            [cell.contentView addSubview:iphone];
        }
    }
    else
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 50)];
        label.text = @"客户关系";
        label.font = Default_Font_15;
        label.textColor = [UIColor hexChangeFloat:KBlackColor];
        [cell.contentView addSubview:label];
        
        _relationLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 0, SCREEN_WIDTH-30-110, 50)];
        _relationLabel.textColor = [UIColor hexChangeFloat:KBlueColor];
        _relationLabel.font = Default_Font_15;
        _relationLabel.textAlignment = NSTextAlignmentRight;
        _relationLabel.text = @"夫妻";
        [cell.contentView addSubview:_relationLabel];
        
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-25, (50-17)/2, 9, 17)];
        image.image = [UIImage imageNamed:@"销邦-楼盘详情页-右箭头"];
        [cell.contentView addSubview:image];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1)
    {
        return 2;
    }
    else
    {
        return 1;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 2)
    {
        return 60;
    } else {
        return 12;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 2) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
        view.backgroundColor = [UIColor hexChangeFloat:@"f2f2f2"];
        
        UIButton *sureButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 20, SCREEN_WIDTH-20, 40)];
        sureButton.backgroundColor = [UIColor hexChangeFloat:@"ff4c51"];
        sureButton.layer.cornerRadius = 5;
        sureButton.layer.masksToBounds = YES;
        [sureButton setTitle:@"确定关联" forState:UIControlStateNormal];
        [sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [sureButton addTarget:self action:@selector(suerBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:sureButton];
        
        return view;
    } else {
        return nil;
    }
    
}

#pragma mark --点击确定关联
- (void)suerBtnClick
{
//    NSLog(@"点击了确定关联");
    if (clientName.text.length == 0)
    {
        [self.view makeToast:@"请填写姓名" duration:1.0 position:@"center"];
        return;
    }
    if (iphone.text.length == 0 )
    {
      [self.view makeToast:@"请填写手机号" duration:1.0 position:@"center"];
        return;
    }
    
    NSString *relation = _relationLabel.text;
    NSString *name = clientName.text;
    NSString *phone = iphone.text;
    NSString *sex = sexSegment.selectedSegmentIndex == 0 ? @"男" : @"女";
    NSLog(@"%@ %@ %@ %@ ", relation, name, phone, sex);
    
//    NSString *searchStr = searchBar1.text;
    
    NSDictionary *dic = @{@"name":name, @"phoneNum":phone , @"sex":sex, @"relation":relation};
    
    NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
    NSArray * array = [userInfo objectForKey:@"relationClient"];
    
    NSMutableArray *arrrrrrr = [NSMutableArray arrayWithArray:array];
    
    int i = 0;
    for (int i = 0; i < array.count; i++)
    {
        if ([phone isEqualToString:array[i][@"phoneNum"]])
        {
            [self.view makeToast:@"该客户已关联"];
            i++;
        }
    }
    if (i > 0)
    {
        
    }
    else
    {
        
        [arrrrrrr insertObject:dic atIndex:0];
        [userInfo setObject:arrrrrrr forKey:@"relationClient"];
        [userInfo synchronize];
        self.addBlick();
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"父亲", @"母亲", @"夫妻", @"子女", @"朋友", nil];
        [alert show];
    }
    if (indexPath.section == 0)
    {
        UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"ClientsManager" bundle:nil];
        NewClientsManagerViewController * recommend = [storyboard instantiateViewControllerWithIdentifier:@"NewClientsManagerViewController"];
        recommend.isChoosen = YES;
        [recommend passContentWithBlock:^(NSDictionary *dict) {
            clientName.text = [dict objectForKey:@"name"];
            iphone.text = [dict objectForKey:@"phone"];
        }];
        [self.navigationController pushViewController:recommend animated:YES];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        _relationLabel.text = @"父亲";
    }
    else if (buttonIndex == 1)
    {
        _relationLabel.text = @"母亲";
    }
    else if (buttonIndex == 2)
    {
        _relationLabel.text = @"夫妻";
    }
    else if (buttonIndex == 3)
    {
        _relationLabel.text = @"子女";
    }
    else 
    {
        _relationLabel.text = @"朋友";
    }
}


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
