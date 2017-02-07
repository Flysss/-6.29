//
//  IWantComplainViewController.m
//  SalesHelper_A
//
//  Created by summer on 14/12/20.
//  Copyright (c) 2014年 X. All rights reserved.
//

#import "IWantComplainViewController.h"
#import "MyHistoryComplainViewController.h"
#import "ChooseCustomViewController.h"
#import "ChooseTitleViewController.h"

#import "UIColor+HexColor.h"

#define DEFAULT_TEXT @"输入您申诉的内容 "

@interface IWantComplainViewController ()<UITableViewDataSource,UITableViewDelegate,ChooseCustomViewControllerDelegate,UITextFieldDelegate,UITextViewDelegate,ChooseTitleViewControllerDelegate>
{
    NSArray *_itemArr;
    NSDictionary *_customInfo;
    NSString *_choosedTitle;
    NSInteger _choosedTitleIndex;
    BOOL _isComplainWithdraw;
}

//@property (nonatomic, strong) UIView *topView;

@end



@implementation IWantComplainViewController

@synthesize contentTextView = _contentTextView;


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden =YES;
//    self.navigationController.navigationBar.translucent = NO;
//    [self.navigationController.navigationBar setBackgroundImage:[self imageWithBgColor:[UIColor colorWithRed:23/255.0f green:183/255.0f blue:242/255.0f alpha:1]] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:[self imageWithBgColor:[UIColor colorWithRed:23/255.0f green:183/255.0f blue:242/255.0f alpha:1]]];
}

//- (void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    self.navigationController.navigationBar.hidden = NO;
//}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutSubViews];

    [self.view setBackgroundColor:[UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1]];
    [self CreateCustomNavigtionBarWith:self leftItem:@selector(backlastView) rightItem:@selector(sendComplainAction)];
    [self.rightBtn setTitle:@"提交" forState:UIControlStateNormal];
    [self.rightBtn setImage:nil forState:UIControlStateNormal];
    [self.rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    //创建标题
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-120)/2, 27, 120, 30)];
    titleLabel.text = @"我要申诉";
    titleLabel.font = Default_Font_20;
    [titleLabel setTextColor:[UIColor whiteColor]];
    //    [titleLabel sizeToFit];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.topView addSubview: titleLabel];

}
-(void)backlastView
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

//#pragma mark -自定义导航栏
//- (void)customTopView
//{
//    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
//    UIButton *btnBack = [UIButton buttonWithType:(UIButtonTypeCustom)];
//    [btnBack setImage:[UIImage imageNamed:@"首页-左箭头"] forState:(UIControlStateNormal)];
//    [btnBack addTarget:self action:@selector(backlastView) forControlEvents:(UIControlEventTouchUpInside)];
//    btnBack.frame = CGRectMake(11, 20, 30, 44);
//    
//    [topView addSubview:btnBack];
//    
//    UILabel *lblName = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 44)];
//    lblName.textColor = [UIColor colorWithHexString:@"ffffff"];
//    lblName.font = [UIFont systemFontOfSize:18];
//    lblName.textAlignment = NSTextAlignmentCenter;
//    lblName.text = @"我要申述";
//    [topView addSubview:lblName];
//    topView.backgroundColor = [UIColor colorWithHexString:@"00aff0"];
//    
//    UIButton *btnMore = [UIButton buttonWithType:(UIButtonTypeCustom)];
//    btnMore.frame = CGRectMake(SCREEN_WIDTH-11-30, 20, 40, 44);
//    [btnMore setTitle:@"提交" forState:(UIControlStateNormal)];
//    [btnMore setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:(UIControlStateNormal)];
//    [btnMore addTarget:self action:@selector(sendComplainAction) forControlEvents:(UIControlEventTouchUpInside)];
//    [topView addSubview:btnMore];
//    
//    [self.view addSubview:topView];
//    
//    
//}

-(void)layoutSubViews
{
    _choosedTitle = @"";
    _choosedTitleIndex = 90;
    _isComplainWithdraw = NO;
    if ([self.selectTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.selectTableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    //ios8SDK 兼容6 和 7 cell下划线
    if ([self.selectTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.selectTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    _itemArr = [NSArray arrayWithObjects:@"我的历史申诉",@"选择客户",@"申诉标题",nil];
    
    UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendBtn setTitle:@"提交" forState:UIControlStateNormal];
    [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendBtn setTitleColor:[UIColor colorWithWhite:1.000 alpha:0.800] forState:UIControlStateHighlighted];
    sendBtn.titleLabel.font = Default_Font_17;
    sendBtn.frame = CGRectMake(0, 0, 40, 30);
//    [sendBtn addTarget:self action:@selector(sendComplainAction) forControlEvents:UIControlEventTouchUpInside];
    [sendBtn addTarget:self action:@selector(sendComplainAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:sendBtn];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    _contentTextView.text = DEFAULT_TEXT;
    _contentTextView.textColor = [UIColor lightGrayColor];
}


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark 提交申诉
-(void)sendComplainAction
{
    [self.view endEditing:YES];
    if (_customInfo==nil&&_isComplainWithdraw==NO)
    {
        [self.view makeToast:@"请选择客户！"];
    }
    else if (_choosedTitle.length==0)
    {
        [self.view makeToast:@"请输入申诉标题！"];
    }
    else if ([_contentTextView.text isEqualToString:DEFAULT_TEXT] || _contentTextView.text.length == 0)
    {
        [self.view makeToast:@"请输入申诉内容！"];
    }
    else
    {
        RequestInterface *request = [[RequestInterface alloc]init];
        
//        NSDictionary *dict = nil;
//        if (_isComplainWithdraw)
//        {
//            dict = @{@"token":self.login_user_token,@"type":@"1",@"title":_choosedTitle,@"contents":self.contentTextView.text};
//        }
//        else
//        {
//            dict = @{@"token":self.login_user_token,@"type":@"0",@"developer_id":[_customInfo objectForKey:@"developer_id"],@"property_id":[_customInfo objectForKey:@"property_id"],@"refrec_id":[_customInfo objectForKey:@"id"],@"title":_choosedTitle,@"contents":self.contentTextView.text};
//        }
        NSDictionary* dic=@{@"token":self.login_user_token,
                            @"recId":[_customInfo objectForKey:@"id"],
                            @"title":_choosedTitle,
                            @"contents":self.contentTextView.text
                            };
        
        [request requestSubAppealWithParam:dic];
        [self.view makeProgressViewWithTitle:@"正在提交"];
        [request getInterfaceRequestObject:^(id data) {
            [self.view hideProgressView];
            if ([[data objectForKey:@"success"]boolValue])
            {
                [self.navigationController popViewControllerAnimated:YES];
                [self.view.window makeToast:@"申诉成功"];
            }
            else
            {
                [self.view makeToast:[data objectForKey:@"message"]];
            }
        } Fail:^(NSError *error) {
            [self.view hideProgressView];
            [self.view makeToast:HintWithNetError];
        }];
    }

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

#pragma mark UITextViewDelegate
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([textView.text stringByAppendingString:text].length>=150)
    {
        [self.view makeToast:@"已是最大字数"];
        return NO;
    }
    else if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    else
    {
        return YES;
    }
    
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:DEFAULT_TEXT]) {
        textView.text = @"";
    }
    textView.textColor = [UIColor blackColor];
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:StringEmpty]) {
        textView.text = DEFAULT_TEXT;
        textView.textColor = [UIColor lightGrayColor];
    }
    return YES;
}


#pragma mark ChangeTextFieldFrame gai改变textfield的高度
//change TextFieldFrame
-(void)keyBoardWillShow:(NSNotification *)noti
{
    if (self.contentTextView.isFirstResponder)
    {
        CGRect keyBoardFrame = [[noti.userInfo objectForKey:@"UIKeyboardFrameEndUserInfoKey"]CGRectValue];
        float animationDuration = [[noti.userInfo objectForKey:@"UIKeyboardAnimationDurationUserInfoKey"]floatValue];
        
        CGFloat fieldOffset=0.0;
        
        if (IOS_VERSION<7.0)
        {
            fieldOffset = 64.0;
        }
        else
        {
            fieldOffset = 0.0;
        }
        if (_contentTextView.bottom+fieldOffset > keyBoardFrame.origin.y )
        {
            CGFloat offset = _contentTextView.bottom+fieldOffset-keyBoardFrame.origin.y;
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
            [UIView setAnimationDuration:animationDuration];
            [self.view setTop:-offset];
            [UIView commitAnimations];
        }
    }
}

-(void)keyBoardWillHide:(NSNotification *)noti
{

        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration: [[noti.userInfo objectForKey:@"UIKeyboardAnimationDurationUserInfoKey"]floatValue]];
        CGFloat offset=0.0;
        if (IOS_VERSION<7.0)
        {
            offset = 0.0;
        }
        else
        {
            offset = 0.0;
        }
        [self.view setTop:offset];
        [UIView commitAnimations];

}


#pragma mark UITableViewDataSource,UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _itemArr.count;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIEdgeInsets inset = UIEdgeInsetsMake(0, 15, 0, 0);
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:inset];
    }
    
    
    if (IOS_VERSION >= 8.0) {
        if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)])
        {
            [cell setPreservesSuperviewLayoutMargins:NO];
        }
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:inset];
        }
    }
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";

    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    //ios8SDK 兼容6 和 7
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
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
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = Default_Font_15;
    cell.textLabel.text = [_itemArr objectAtIndex:indexPath.row];
    cell.detailTextLabel.font = Default_Font_15;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row==0)
    {
        //我的历史申诉
        MyHistoryComplainViewController *myComplainVC = [[MyHistoryComplainViewController alloc]init];
        myComplainVC.title = @"历史申诉";
        [myComplainVC creatBackButtonWithPushType:Push With:self.title Action:nil];
        [self.navigationController pushViewController:myComplainVC animated:YES];
        
    }
    if (indexPath.row==1&&!_isComplainWithdraw)
    {
        //选择客户
        ChooseCustomViewController *chooseVC = [[ChooseCustomViewController alloc]init];
        chooseVC.title = @"选择客户";
        chooseVC.delegate = self;
        [chooseVC creatBackButtonWithPushType:Push With:self.title Action:nil];
        [self.navigationController pushViewController:chooseVC animated:YES];
    }
    if (indexPath.row==2)
    {
        //选择标题
        ChooseTitleViewController *chooseTitleVC = [[ChooseTitleViewController alloc]init];
        chooseTitleVC.title = @"申诉标题";
        chooseTitleVC.delegate = self;
        chooseTitleVC.titleIndex = _choosedTitleIndex;
        [chooseTitleVC creatBackButtonWithPushType:Push With:self.title Action:nil];
        [self.navigationController pushViewController:chooseTitleVC animated:YES];

    }
}



#pragma mark ChooseCustomViewControllerDelegate
-(void)getChoosedCustomInfo:(NSDictionary *)customInfo
{
   UITableViewCell *cell = [self.selectTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    cell.textLabel.text = [customInfo objectForKey:@"name"];
    cell.detailTextLabel.text = [customInfo objectForKey:@"phone"];
    _customInfo = customInfo;
}
#pragma mark ChooseTitleViewControllerDelegate
-(void)getChoosedTitle:(NSString *)title Index:(NSInteger)index
{
    _choosedTitle = title;
    UITableViewCell *cell = [self.selectTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    if (index == 2)
    {
        cell.detailTextLabel.text = @"无需选择客户";
        cell.textLabel.text = @"选择客户";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        _isComplainWithdraw = YES;
    }
    else
    {

        if (_customInfo[@"phone"] != nil)
        {
           cell.detailTextLabel.text = _customInfo[@"phone"];
        }
        else
        {
            cell.detailTextLabel.text = @"";
        }
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        _isComplainWithdraw = NO;
    }
    cell = [self.selectTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    cell.detailTextLabel.text = title;
    _choosedTitleIndex = index;
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
