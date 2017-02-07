//
//  MyPayCenterViewController.m
//  SalesHelper_A
//
//  Created by Reconcilie on 14/10/26.
//  Copyright (c) 2014年 zhipu. All rights reserved.
//

#import "MyPayCenterViewController.h"

#define CLICKBTN_N @"编辑"
#define CLICKBTN_S @"保存"

@interface MyPayCenterViewController ()<UITextFieldDelegate>
{
    UITextField *_myPayNameTextField;
    UITextField *_myNameTextField;
    
    UIButton *_myNextBtn;
    
    NSDictionary *_modWithdDict;
}
//当前支付宝用户名
@property (nonatomic,copy)NSString *currentPayName;
//当前我的姓名
@property (nonatomic,copy)NSString *currentMyName;
@end

@implementation MyPayCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:21.0/255.0 green:159/255.0 blue:234/255.0 alpha:1]];
    [self requestGetWithd];
    
    [self layoutSubViews];
    
    _myPayNameTextField.delegate = self;
    _myNameTextField.delegate = self;
    
    //设置触摸非输入框 键盘隐藏
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(recycleKeyBoard)];
    tapRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapRecognizer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)layoutSubViews
{
    UILabel *payNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 120, 45)];
    payNameLabel.backgroundColor = [UIColor clearColor];
    payNameLabel.text = @"支付宝账户名：";
    payNameLabel.font = Default_Font_15;
    [self.view addSubview:payNameLabel];
    
    _myPayNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(payNameLabel.right, payNameLabel.top, 160, 45)];
    _myPayNameTextField.placeholder = @"支付宝账户/手机号码";
    _myPayNameTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _myPayNameTextField.font = Default_Font_15;
    _myPayNameTextField.textColor = RGBACOLOR(162, 162, 162, 1);
    [self.view addSubview:_myPayNameTextField];
    
    UIColor *lineColor = RGBACOLOR(215, 214, 215, 1);
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, payNameLabel.bottom, SCREEN_WIDTH, 1)];
    lineView.backgroundColor = lineColor;
    [self.view addSubview:lineView];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, lineView.bottom, 120, 45)];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.text = @"我的姓名：";
    nameLabel.font = Default_Font_15;
    [self.view addSubview:nameLabel];
    
    _myNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(nameLabel.right, nameLabel.top, 160, 45)];
    _myNameTextField.placeholder = @"注册时姓名";
    _myNameTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _myNameTextField.font = Default_Font_15;
    _myNameTextField.textColor = RGBACOLOR(162, 162, 162, 1);
    [self.view addSubview:_myNameTextField];
    
    UIView *mlineView = [[UIView alloc] initWithFrame:CGRectMake(0, nameLabel.bottom, SCREEN_WIDTH, 1)];
    mlineView.backgroundColor = lineColor;
    [self.view addSubview:mlineView];
    
    
    //下一步的button
    _myNextBtn = [self creatUIButtonWithFrame:CGRectMake(15, mlineView.bottom + 40, SCREEN_WIDTH - 30, 40) BackgroundColor:LeftMenuVCBackColor Title:@"确 定" TitleColor:[UIColor whiteColor] Action:@selector(nextBtnClick)];
    _myNextBtn.hidden = YES;
    _myNextBtn.layer.cornerRadius = 20.0f;
    _myNextBtn.titleLabel.font = Default_Font_20;
    [self.view addSubview:_myNextBtn];
}

#pragma mark - UITextFieldDelegate
//当用户按下return键或者按回车键，keyboard消失
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - clickBtnAction
- (void)recycleKeyBoard {
    [self.view endEditing:YES];
}

- (void)nextBtnClick
{
    if (!(_myPayNameTextField.text.length > 0)) {
        [self.view makeToast:@"支付宝账户名不能为空"];
        return;
    }else if (![ProjectUtil isPersonPhone:_myPayNameTextField.text] && ! [ProjectUtil isValidateEmail:_myPayNameTextField.text]) {
        [self.view makeToast:@"请输入正确的支付宝账号"];
        return;
    }else if (!(_myNameTextField.text.length > 0)) {
        [self.view makeToast:@"我的姓名不能为空"];
        return;
    }
    
    [self requestAddWithd];
}

//注册支付宝账号
- (void)requestAddWithd
{
    NSDictionary *dict = @{@"token":self.login_user_token,
                           @"name":_myNameTextField.text,
                           @"account":_myPayNameTextField.text,
                           @"type":@"0"
                           };
    RequestInterface *requestOp = [[RequestInterface alloc] init];
    [requestOp requestAddWithdWithParam:dict];
    
    [requestOp getInterfaceRequestObject:^(id data) {
        [ProjectUtil showLog:@"data = %@",data];
        if ([data[@"result"] isEqualToString:@"success"]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"支付宝账号注册成功" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            alert.tag = 800;
            [alert show];
        }else {
            [self.view makeToast:data[@"error_remark"]];
        }
        
    } Fail:^(NSError *error) {
        [self.view makeToast:HintWithNetError];
    }];
}


- (void)creatEditableButton
{
    //提现按钮
    UIButton *rightBtn;
    
    if (IOS_VERSION<7.0)
    {
        rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        rightBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    }
    else
    {
        rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    rightBtn.titleLabel.font = Default_Font_18;
    rightBtn.frame = CGRectMake(0, 20, 40, 40);
    rightBtn.backgroundColor = [UIColor clearColor];
    [rightBtn setTitle:CLICKBTN_N forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [rightBtn setTitle:CLICKBTN_S forState:UIControlStateSelected];
    [rightBtn setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
    [rightBtn addTarget:self action:@selector(clickEditableBtn:) forControlEvents:UIControlEventTouchUpInside];

    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:[self creatNegativeSpacerButton],[[UIBarButtonItem alloc] initWithCustomView:rightBtn], nil];
    
    _myPayNameTextField.enabled = NO;
    _myNameTextField.enabled = NO;
}

- (void)clickEditableBtn:(UIButton *)sender
{
    if (sender.selected) {
        if (![ProjectUtil isPersonPhone:_myPayNameTextField.text] && ! [ProjectUtil isValidateEmail:_myPayNameTextField.text]) {
            [self.view makeToast:@"请输入正确的支付宝账号"];
            return;
        }else if([self.currentPayName isEqualToString:_myPayNameTextField.text] && [self.currentMyName isEqualToString:_myNameTextField.text]){//如果没有个性账号信息
            
            [ProjectUtil showAlert:@"提示" message:@"您没有修改账号信息"];
            _myPayNameTextField.enabled = NO;
            _myNameTextField.enabled = NO;
            _myPayNameTextField.textColor = RGBACOLOR(162, 162, 162, 1);
            _myNameTextField.textColor = RGBACOLOR(162, 162, 162, 1);
        }else{
            //修改支付宝
            [self requestModWithd];
        }
        
    }else {
        _myPayNameTextField.enabled = YES;
        _myNameTextField.enabled = YES;
        _myPayNameTextField.textColor = [UIColor blackColor];
        _myNameTextField.textColor = [UIColor blackColor];
        //取出当前账号和姓名用于判断有没有修改账号和姓名
        self.currentPayName = _myPayNameTextField.text;
        self.currentMyName = _myNameTextField.text;
    }
    
    sender.selected = !sender.selected;
    sender.backgroundColor = [UIColor clearColor];
    
}

//查询支付宝名称
- (void)requestGetWithd
{
    NSDictionary *dict = @{@"token":self.login_user_token,
                           @"type":@"0"
                           };
    [self.view showProgressLabel];
    RequestInterface *requestOp = [[RequestInterface alloc] init];
    [requestOp requestGetWithdWithParam:dict];
    
    [requestOp getInterfaceRequestObject:^(id data) {
        [ProjectUtil showLog:@"data = %@",data];
        NSArray *infoArray = data[@"record"];
        [self.view hideProgressLabel];
        if (infoArray.count > 0) {
            [self creatEditableButton];
            _modWithdDict = infoArray[0];
            _myPayNameTextField.text = infoArray[0][@"account"];
            _myNameTextField.text = infoArray[0][@"name"];
        }else {
            _myPayNameTextField.textColor = [UIColor blackColor];
            _myNameTextField.textColor = [UIColor blackColor];
            _myNextBtn.hidden = NO;
        }
    } Fail:^(NSError *error) {
        [self.view hideProgressLabel];
        [self.view makeToast:HintWithNetError];
    }];
}

//修改支付宝账户
- (void)requestModWithd
{
    NSDictionary *dict = @{@"user_id":self.login_user_token,
                           @"name":_myNameTextField.text,
                           @"identity":@"0",
                           @"account":_myPayNameTextField.text,
                           @"account_id":_modWithdDict[@"id"],
                           @"type":@"0"
                           };

    RequestInterface *requestOp = [[RequestInterface alloc] init];
    [requestOp requestModWithdWithParam:dict];
    
    [requestOp getInterfaceRequestObject:^(id data) {
        [ProjectUtil showLog:@"data = %@",data];
        if ([data[@"result"] isEqualToString:@"success"]) {
            _myPayNameTextField.enabled = NO;
            _myNameTextField.enabled = NO;
            _myPayNameTextField.textColor = RGBACOLOR(162, 162, 162, 1);
            _myNameTextField.textColor = RGBACOLOR(162, 162, 162, 1);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"支付宝账号修改成功" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            alert.tag = 810;
            [alert show];
        }
        
    } Fail:^(NSError *error) {
        [self.view makeToast:HintWithNetError];
    }];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 800) {
        [self creatEditableButton];
    }
}

@end
