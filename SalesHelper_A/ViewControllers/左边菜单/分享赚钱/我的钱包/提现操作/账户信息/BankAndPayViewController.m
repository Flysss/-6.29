//
//  BankAndPayViewController.m
//  SalesHelper_A
//
//  Created by zhipu on 14/11/13.
//  Copyright (c) 2014年 zhipu. All rights reserved.
//

#import "BankAndPayViewController.h"

@interface BankAndPayViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSDictionary *_selectBankDict;
    NSInteger _selectedRow;
}

@end

@implementation BankAndPayViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    UIFont *font = Default_Font_18;
    
//    NSString *backStr = @"提现";
//    
//    CGSize strSize = [backStr sizeWithFont:font
//                              constrainedToSize:CGSizeMake(50.f, MAXFLOAT)
//                                  lineBreakMode:NSLineBreakByWordWrapping];
//    [ProjectUtil showLog:@"labelSize %f  %f",strSize.width,strSize.height];
//    
//    UIButton *leftBtn = [self creatUIButtonWithFrame:CGRectMake(0, 0, strSize.width+50, 30) BackgroundColor:nil Title:backStr TitleColor:NavigationBarTitleColor Action:@selector(backFormViewController)];
//    
//    NSString *leftBtnImagePath = [[NSBundle mainBundle] pathForResource:@"back" ofType:@"png"];
//    UIImage *image = [UIImage imageWithContentsOfFile:leftBtnImagePath];
//    [leftBtn setImage:image forState:UIControlStateNormal];
//    
//    [leftBtn setTintColor:[UIColor grayColor]];
//    
//    [leftBtn setTitleEdgeInsets:UIEdgeInsetsMake(2.0, 3.0, 0.0, 0.0)];
//    [leftBtn setImageEdgeInsets:UIEdgeInsetsMake(0.0, -2, 0.0, 0)];
//    
//    leftBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    if (IOS_VERSION<7.0)
//    {
//        leftBtn.titleEdgeInsets = UIEdgeInsetsMake(2.0, 7, 0, 0);
//        [leftBtn setImageEdgeInsets:UIEdgeInsetsMake(0.0, 5, 0.0, 0)];
//    }
//    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:[self creatNegativeSpacerButton],[[UIBarButtonItem alloc] initWithCustomView:leftBtn], nil];
    
    
    
    for (int i=0; i< self.bankPayArray.count; i++) {
        NSDictionary *dict = self.bankPayArray[i];
        NSString* str1=[NSString stringWithFormat:@"%@",dict[@"type"]];
    NSString* str2=[NSString stringWithFormat:@"%@",self.selectedDict[@"type"]];

        NSString* str3=[NSString stringWithFormat:@"%@",dict[@"account"]];
NSString* str4=[NSString stringWithFormat:@"%@",self.selectedDict[@"account"]];

        NSString* str5=[NSString stringWithFormat:@"%@",dict[@"id"]];
    NSString* str6=[NSString stringWithFormat:@"%@",self.selectedDict[@"id"]];

        
        
        if ([str1 isEqualToString:str2] && [str3 isEqualToString: str4] && [str5 isEqualToString:str6]) {
            _selectedRow = i;
            break;
        }
    }
    
    if (self.bankPayArray.count > 0) {
        _selectBankDict = self.bankPayArray[0];
        [self layoutSubViews];
    }else {
        
    }
    
    [self CreateCustomNavigtionBarWith:self leftItem:@selector(backlastView) rightItem:nil];
    //创建标题
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-120)/2, 27, 120, 30)];
    titleLabel.text = @"提现账户";
    titleLabel.font = Default_Font_20;
    [titleLabel setTextColor:[UIColor whiteColor]];
    //    [titleLabel sizeToFit];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.topView addSubview: titleLabel];

    
//    UIButton* leftbtn=[UIButton buttonWithType:UIButtonTypeCustom];
//    leftbtn.frame=CGRectMake(0, 0, 26, 26);
//    [leftbtn setBackgroundImage:[UIImage imageNamed:@"首页-左箭头.png"] forState:UIControlStateNormal];
//    [leftbtn setBackgroundImage:[UIImage imageByApplyingAlpha:[UIImage imageNamed:@"首页-左箭头.png"]] forState:UIControlStateHighlighted];
//    
//    [leftbtn addTarget:self action:@selector(backlastView) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem* back=[[UIBarButtonItem alloc]initWithCustomView:leftbtn];
//    self.navigationItem.leftBarButtonItem=back;
    
    
    
}
-(void)backlastView
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

//返回之前的页面 也即push前的页面
-(void)backFormViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)layoutSubViews
{
    UITableView *bankPayTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 74, SCREEN_WIDTH, MIN(self.bankPayArray.count * 60, SCREEN_HEIGHT+20) )];
    if (bankPayTableView.frame.size.height < SCREEN_HEIGHT+20) {
        bankPayTableView.bounces = NO;
    }
    bankPayTableView.delegate = self;
    bankPayTableView.dataSource = self;
    
    if ([bankPayTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [bankPayTableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    //ios8SDK 兼容6 和 7 cell下划线
    if ([bankPayTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [bankPayTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    [self.view addSubview:bankPayTableView];
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.bankPayArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        //ios8SDK 兼容6 和 7
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        
        UIImageView *bankImage = [[UIImageView alloc] initWithFrame:CGRectMake(8, 15, 40, 26)];
        bankImage.tag = 700;
        [cell.contentView addSubview:bankImage];
        
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 5, 200, 30)];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.font = Default_Font_15;
        nameLabel.tag = 708;
        [cell addSubview:nameLabel];
        
        UILabel *numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 27, 200, 30)];
        numberLabel.backgroundColor = [UIColor clearColor];
        numberLabel.font = [UIFont systemFontOfSize:12];
;
        numberLabel.textColor = [UIColor lightGrayColor];
        numberLabel.tag = 709;
        [cell addSubview:numberLabel];
        
        UIImageView *selectImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 35, 23, 18, 14)];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"pitchon" ofType:@"png"];
        selectImageView.image = [UIImage imageWithContentsOfFile:path];
        
        selectImageView.tag = 800;
        [cell addSubview:selectImageView];
    }
    
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:800];
    
    if (indexPath.row == _selectedRow) {
        imageView.hidden = NO;
    }else {
        imageView.hidden = YES;
    }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    NSDictionary *dict = self.bankPayArray[indexPath.row];
    
    UIImageView *bankImageView = (UIImageView *)[cell.contentView viewWithTag:700];
    
    [bankImageView sd_setImageWithURL:[NSURL URLWithString:dict[@"bankIcon"]]];
    
    UILabel *nameLabel = (UILabel *)[cell viewWithTag:708];

    UILabel *numberLabel = (UILabel *)[cell viewWithTag:709];
    
    NSString* str=[NSString stringWithFormat:@"%@",dict[@"type"]];
    
    if ([str isEqualToString:@"0"]) {
        nameLabel.text = [NSString stringWithFormat:@"姓名：%@",dict[@"name"]];
        numberLabel.text = [NSString stringWithFormat:@"支付宝账号：%@",dict[@"account"]];
    }else {
        nameLabel.text = self.bankPayArray[indexPath.row][@"name"];
        
        NSString *numStr = self.bankPayArray[indexPath.row][@"account"];
        numberLabel.text = [NSString stringWithFormat:@"尾号%@",[numStr substringFromIndex:numStr.length-4]];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    UITableViewCell *selectCell;
    for (int i = 0; i < self.bankPayArray.count; i++) {
        selectCell = (UITableViewCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        UIImageView *imageView = (UIImageView *)[selectCell viewWithTag:800];
        if (i == indexPath.row) {
            imageView.hidden = NO;
            _selectedRow = i;
            _selectBankDict = self.bankPayArray[i];
        }else {
            imageView.hidden = YES;
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    [self.delegate callBackWithBankOrPayInfo:_selectBankDict];
}

@end
