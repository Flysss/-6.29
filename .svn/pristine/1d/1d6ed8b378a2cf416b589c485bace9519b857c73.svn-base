//
//  ChooseTitleViewController.m
//  SalesHelper_A
//
//  Created by summer on 14/12/30.
//  Copyright (c) 2014年 X. All rights reserved.
//

#import "ChooseTitleViewController.h"
#import "ChooseTitleCell.h"

@interface ChooseTitleViewController ()
{
    NSArray *_titleArr;
    NSString *_selectedTitle;
    NSInteger _selectedTitleIndex;
}
@end

@implementation ChooseTitleViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutSubViews];
    
    [self CreateCustomNavigtionBarWith:self leftItem:@selector(backlastView) rightItem:@selector(doneBtnAction)];
    //创建标题
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-120)/2, 27, 120, 30)];
    titleLabel.text = @"申诉内容";
    titleLabel.font = Default_Font_20;
    [titleLabel setTextColor:[UIColor whiteColor]];
    //    [titleLabel sizeToFit];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.topView addSubview: titleLabel];
    [self.rightBtn setTitle:@"完成" forState:UIControlStateNormal];
    
}
-(void)backlastView
{
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)layoutSubViews
{
    _selectedTitle = @"";
    _titleArr = [NSArray arrayWithObjects:@"1、置业顾问一直未处理进度流程",@"2、点击签约，却没收到佣金",@"3、提现一直不成功",nil];
    self.titleTableView.delegate = self;
    self.titleTableView.dataSource = self;
    
    if ([self.titleTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.titleTableView setSeparatorInset:UIEdgeInsetsMake(0,10,0,0)];
    }
    //ios8SDK 兼容6 和 7 cell下划线
    if ([self.titleTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.titleTableView setLayoutMargins:UIEdgeInsetsMake(0,10,0,0)];
    }
    
    

//    UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    doneBtn.frame = CGRectMake(0, 0, 40, 30);
//    [doneBtn setTitle:@"完成" forState:UIControlStateNormal];
//
//    [doneBtn setTitleColor:NavigationBarTitleColor forState:UIControlStateNormal];
//    [doneBtn setTitleColor:[UIColor colorWithWhite:0.000 alpha:0.720] forState:UIControlStateHighlighted];
//
//    doneBtn.titleLabel.font = Default_Font_17;
//    [doneBtn addTarget: self action:@selector(doneBtnAction) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:doneBtn];
}

#pragma mark 确定
-(void)doneBtnAction
{
    [self.view endEditing:YES];

    if (_selectedTitle.length!=0&&self.titleField.text.length!=0)
    {
        [self.view makeToast:@"不能同时输入标题且选择标题！"];
    }
    else if(_selectedTitle.length==0&&self.titleField.text.length==0)
    {
        [self.view makeToast:@"您还未设置标题！"];
    }
    else
    {
        NSString *selectedTitle = @"";
        if (_selectedTitle.length==0)
        {
            selectedTitle = self.titleField.text;
        }
        else
        {
            selectedTitle = _selectedTitle;
        }
        [self.delegate getChoosedTitle:selectedTitle Index:_selectedTitleIndex];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

#pragma mark UITableViewDataSource,UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titleArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    ChooseTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"ChooseTitleCell" owner:self options:nil]lastObject];
    }
    //ios8SDK 兼容6 和 7
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(0,10,0,0)];
    }
    if (indexPath.row == 0)
    {
        UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-20, 0.4)];
        line.backgroundColor = [UIColor grayColor];
        line.alpha = 0.4;
        [cell.contentView addSubview:line];
    }else if (indexPath.row == 2)
    {
        UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, 43.5, SCREEN_WIDTH-20, 0.4)];
        line.backgroundColor = [UIColor grayColor];
        line.alpha = 0.4;
        [cell.contentView addSubview:line];
    }

    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.titleLabel.text = [_titleArr objectAtIndex:indexPath.row];
    return cell;
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     ChooseTitleCell *cell = (ChooseTitleCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.selectedBtn.selected = !cell.selectedBtn.selected;
    if (cell.selectedBtn.selected)
    {
        _selectedTitle = [[_titleArr objectAtIndex:indexPath.row]substringFromIndex:2];
        _selectedTitleIndex = indexPath.row;
    }
    else
    {
        _selectedTitle = @"";
    }
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
   ChooseTitleCell *cell = (ChooseTitleCell *)[tableView cellForRowAtIndexPath:indexPath];
       cell.selectedBtn.selected = NO;
    
}

#pragma mark UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([textField.text stringByAppendingString:string].length>15)
    {
        [textField resignFirstResponder];
        [self.view makeToast:@"已是最大字数"];
        return NO;
    }
    else
    {
        return YES;
    }
    
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
