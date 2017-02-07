//
//  WithdrawalPageViewController.m
//  SalesHelper_A
//
//  Created by Reconcilie on 14/10/25.
//  Copyright (c) 2014年 zhipu. All rights reserved.
//

#import "WithdrawalPageViewController.h"
#import "BankAndPayViewController.h"
#import "RTLabel.h"
#import "ForgetPassStep1ViewController.h"
#import "AddBankCardViewController.h"
#import "SetDrawalStep1ViewController.h"
#import "MyPurseViewController.h"
@interface WithdrawalPageViewController ()<UITextFieldDelegate,BankAndPayViewControllerDelegate,UIAlertViewDelegate>
{
    UILabel *_moneyLabel;
    UITextField *_drawalMoneyTextField;
    UITextField *_drawalPasswordTextField;
    UITextField *editingTextField;
    RTLabel *_myMoneyLabel;
    
    NSString *_drawalBtnTypeIndex;
    UILabel *_bankNameLabel;
    UILabel *_bankNumberLabel;
    UILabel *_noticeLabel;
    UIImageView *_bankImageView;
    
    NSArray *_allBankInfoArray;
    BankAndPayViewController *bankAndPayVC;
    
    NSDictionary *_selectedDict; //默认的提现账户的id
    
}


@end

@implementation WithdrawalPageViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:21.0/255.0 green:159/255.0 blue:234/255.0 alpha:1]];
    
    [self CreateCustomNavigtionBarWith:self leftItem:@selector(backview) rightItem:nil];
    //创建标题
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-120)/2, 27, 120, 30)];
    titleLabel.text = @"提现";
    titleLabel.font = Default_Font_20;
    [titleLabel setTextColor:[UIColor whiteColor]];
    //    [titleLabel sizeToFit];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.topView addSubview: titleLabel];
    
    
//    //自定义左边的返回按钮
//    UIButton* btn=[UIButton buttonWithType:UIButtonTypeCustom];
//    btn.frame=CGRectMake(0, 0, 60, 40);
//    [btn setTitle:@"< 钱包" forState:UIControlStateNormal];
//    [btn.titleLabel setFont:[UIFont systemFontOfSize:18]];
//    btn.titleEdgeInsets = UIEdgeInsetsMake(2.0, -10.0, 0, 0.0);
//     
//    
//    
// 
//    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [btn setTitleColor:[UIColor colorWithWhite:0.000 alpha:0.450] forState:UIControlStateHighlighted];
//    [btn addTarget:self action:@selector(backMywallet) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem* back=[[UIBarButtonItem alloc]initWithCustomView:btn];
//
//    self.navigationItem.leftBarButtonItem=back;
    

    _allBankInfoArray = [[NSArray alloc] init];
    _selectedDict = [[NSDictionary alloc] init];
    
    [self layoutSubViews];
    
    _drawalMoneyTextField.delegate = self;
    _drawalPasswordTextField.delegate = self;
    
    _drawalBtnTypeIndex = @"0";
    
    //设置触摸非输入框 键盘隐藏
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(recycleKeyBoard)];
    tapRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapRecognizer];
    
    [self layoutlifebutton];
    
}
-(void)layoutlifebutton
{
    
    UIButton* btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake(0, 0, 27, 27);
    [btn setBackgroundImage:[UIImage imageNamed:@"首页-左箭头.png"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageByApplyingAlpha:[UIImage imageNamed:@"首页-左箭头.png"]] forState:UIControlStateHighlighted];

    [btn addTarget:self action:@selector(backview) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* back=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=back;
}
-(void)backview
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;

    [self requestGetRewardByR];
    
    if (_allBankInfoArray.count == 0) {
        [self requestGetWithd];
    }
    
    //键盘将要出现时的触发事件
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:)name:UIKeyboardWillShowNotification object:nil];
    
    //键盘将要消失时的触发事件
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillBeHidden:)name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)paramAnimated
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    [super viewDidDisappear:paramAnimated];
}

-(void)backMywallet
{
    //遍历导航控制器控制所有控制器页面
    for (UIViewController * viewController in self.navigationController.viewControllers)
    {
        if ([viewController isKindOfClass:[MyPurseViewController class]]) {
            [self.navigationController popToViewController:viewController animated:YES];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)layoutSubViews
{
    
    UIView *mainView = [[UIView alloc] initWithFrame:CGRectMake(10, 10+64, SCREEN_WIDTH - 20, SCREEN_HEIGHT-64)];
    mainView.backgroundColor = [UIColor clearColor];
    mainView.layer.cornerRadius = 5;
    [self.view addSubview:mainView];
    
    //银行卡信息
    UIView *acountView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, mainView.width, 60)];
    acountView.layer.cornerRadius = 5;
    acountView.backgroundColor = [UIColor whiteColor];
    
    //设置触发条件
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickAccountView)];
    tapRecognizer.cancelsTouchesInView = NO;
    [acountView addGestureRecognizer:tapRecognizer];
    [mainView addSubview:acountView];
    
    NSString *rightPath = [[NSBundle mainBundle] pathForResource:@"yjt" ofType:@"png"];
    UIImageView *rightImage = [[UIImageView alloc] initWithFrame:CGRectMake(acountView.right-29, 25, 8, 14)];
    [rightImage setImage:[UIImage imageWithContentsOfFile:rightPath]];
    [acountView addSubview:rightImage];
    
    _noticeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, 200, 30)];
    _noticeLabel.backgroundColor =[UIColor clearColor];
    _noticeLabel.text = @"无提现账户";
    _noticeLabel.font = Default_Font_14;
    [acountView addSubview:_noticeLabel];
    
    //银行图片
    _bankImageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 15, 40, 26)];
    [acountView addSubview:_bankImageView];
    
    _bankNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 5, 200, 30)];
    _bankNameLabel.backgroundColor =[UIColor clearColor];
    _bankNameLabel.text = @"";
    _bankNameLabel.font = Default_Font_14;
    [acountView addSubview:_bankNameLabel];
    
    _bankNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 30, acountView.width-30, 30)];
    _bankNumberLabel.backgroundColor =[UIColor clearColor];
    _bankNumberLabel.text = @"";
    _bankNumberLabel.font = Default_Font_13;
    _bankNumberLabel.textColor = [UIColor lightGrayColor];
    [acountView addSubview:_bankNumberLabel];
    
    //下一界面引导
    UIImageView *nextImageView = [[UIImageView alloc] initWithFrame:CGRectMake(acountView.width - 25, 25, 8, 12)];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"zhannghuzuojiantou" ofType:@"png"];
    nextImageView.image = [UIImage imageWithContentsOfFile:path];
    [acountView addSubview:nextImageView];
    
    //提现时间信息
    UIView *timeView = [[UIView alloc] initWithFrame:CGRectMake(0, acountView.bottom + 15, mainView.width, 40)];
    timeView.layer.cornerRadius = 5;
    timeView.backgroundColor = [UIColor whiteColor];
    [mainView addSubview:timeView];
    
    UILabel *timeNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 200, 30)];
    timeNameLabel.backgroundColor =[UIColor clearColor];
    timeNameLabel.text = @"到账时间";
    timeNameLabel.font = Default_Font_14;
    [timeView addSubview:timeNameLabel];
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(acountView.width - 100-15, 5, 100, 30)];
    timeLabel.backgroundColor =[UIColor clearColor];
    timeLabel.textAlignment = NSTextAlignmentRight;
    timeLabel.text = @"两天内到账";
    timeLabel.font = Default_Font_14;
    [timeView addSubview:timeLabel];
    
    //可用金额  (self.accountMoney == nil)?@"0":self.accountMoney
    _myMoneyLabel = [[RTLabel alloc] initWithFrame:CGRectMake(10, timeView.bottom+10, mainView.width, 45)];
    _myMoneyLabel.text = [NSString stringWithFormat:@"<font size=14>可提现金额：</font><font size=16 color='#EC4E4F'> %@</font><font size=15> 元</font>",_moneyStr];
    //_myMoneyLabel.text=_moneyStr;
    [mainView addSubview:_myMoneyLabel];
    
    //转出金额
    UIView *moneyView = [[UIView alloc] initWithFrame:CGRectMake(0, timeView.bottom + 40, mainView.width, 40)];
    moneyView.layer.cornerRadius = 5;
    moneyView.backgroundColor = [UIColor whiteColor];
    [mainView addSubview:moneyView];
    
    UILabel *drawalMoneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 65, 30)];
    drawalMoneyLabel.text = @"金       额";
    drawalMoneyLabel.font = Default_Font_14;
    [moneyView addSubview:drawalMoneyLabel];
    
    _drawalMoneyTextField = [[UITextField alloc] initWithFrame:CGRectMake(drawalMoneyLabel.right, drawalMoneyLabel.top, moneyView.width - 75, 30)];
    _drawalMoneyTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _drawalMoneyTextField.placeholder = @"提现金额";
    _drawalMoneyTextField.font = Default_Font_14;
    _drawalMoneyTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _drawalMoneyTextField.keyboardType = UIKeyboardTypeDecimalPad;
    [moneyView addSubview:_drawalMoneyTextField];
    
    //转出金额
    UIView *passwordView = [[UIView alloc] initWithFrame:CGRectMake(0, moneyView.bottom + 15, mainView.width, 40)];
    passwordView.layer.cornerRadius = 5;
    passwordView.backgroundColor = [UIColor whiteColor];
    [mainView addSubview:passwordView];
    
    UILabel *drawalPasswordLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 65, 30)];
    drawalPasswordLabel.text = @"提现密码";
    drawalPasswordLabel.font = Default_Font_14;
    [passwordView addSubview:drawalPasswordLabel];
    
    _drawalPasswordTextField = [[UITextField alloc] initWithFrame:CGRectMake(drawalPasswordLabel.right, drawalPasswordLabel.top, moneyView.width - 70, 30)];
    _drawalPasswordTextField.placeholder = @"提现密码";
    _drawalPasswordTextField.font = Default_Font_14;
    _drawalPasswordTextField.secureTextEntry = YES;
    _drawalPasswordTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _drawalPasswordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _drawalPasswordTextField.keyboardType = UIKeyboardTypeASCIICapable;
    [passwordView addSubview:_drawalPasswordTextField];
    
    UIButton *forgetPasswordBtn = [self creatUIButtonWithFrame:CGRectMake(mainView.right - 140, passwordView.bottom, 130, 30) BackgroundColor:[UIColor clearColor] Title:@"忘记提现密码？" TitleColor:RGBCOLOR(252, 69, 55) Action:@selector(forgetBtnClick)];
    
    
    [UIButton buttonWithType:UIButtonTypeCustom];
    forgetPasswordBtn.frame = CGRectMake(mainView.right - 140, passwordView.bottom+5, 130, 30);
    forgetPasswordBtn.backgroundColor = [UIColor clearColor];
    forgetPasswordBtn.titleLabel.font = Default_Font_14;
    [forgetPasswordBtn setTitle:@"忘记提现密码？" forState:UIControlStateNormal];
    [forgetPasswordBtn setTitleColor:RGBCOLOR(252, 69, 55) forState:UIControlStateNormal];
    [forgetPasswordBtn setTitle:@"忘记提现密码？" forState:UIControlStateHighlighted];
    [forgetPasswordBtn setTitleColor:RGBCOLOR(252, 69, 55) forState:UIControlStateHighlighted];
    [mainView addSubview:forgetPasswordBtn];
    
    
    //下一步的button
    UIButton *confirmBtn = [self creatUIButtonWithFrame:CGRectMake(15, passwordView.bottom + 40, mainView.frame.size.width - 30, 40) BackgroundColor:LeftMenuVCBackColor Title:@"确 定" TitleColor:[UIColor whiteColor] Action:@selector(confirmBtnClick)];
    confirmBtn.layer.cornerRadius = 20.0f;
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    
    [mainView addSubview:confirmBtn];
    
}


#pragma mark - UITextFieldDelegate
//当用户按下return键或者按回车键，keyboard消失
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    editingTextField = textField;
}

#pragma mark - KeyBoardNotification
//键盘将要出现的方法

-(void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    CGRect keyBoardFrame = [[info objectForKey:@"UIKeyboardFrameEndUserInfoKey"]CGRectValue];
    
    //获取键盘出现的动画时间
    NSValue *animationDurationValue = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    NSTimeInterval animation = animationDuration;
    
    //视图移动的动画开始
    
    
    CGFloat fieldOffset;
    
    if (IOS_VERSION<7.0)
    {
        fieldOffset = 64.0;
    }
    else
    {
        fieldOffset = 0.0;
    }
    
    [ProjectUtil showLog:@"editingTextField.bottom+fieldOffset = %f ",editingTextField.superview.bottom+fieldOffset+editingTextField.superview.superview.top];
    [ProjectUtil showLog:@"keyBoardFrame.origin.y= %f ",keyBoardFrame.origin.y];
    
    if (editingTextField.superview.bottom+fieldOffset+editingTextField.superview.superview.top > keyBoardFrame.origin.y)
    {
        
        CGFloat offset = editingTextField.superview.bottom+fieldOffset+editingTextField.superview.superview.top-keyBoardFrame.origin.y+10;
        
        
        [UIView animateWithDuration:animation animations:^{
            self.view.frame = CGRectMake(0, -offset, self.view.width, self.view.height);
        } completion:^(BOOL finished) {
            
        }];
    }
}
//键盘将要消失的方法

-(void)keyboardWillBeHidden:(NSNotification *)aNotification
{
    NSDictionary *info = [aNotification userInfo];
    
    //获取键盘出现的动画时间
    NSValue *animationDurationValue = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    NSTimeInterval animation = animationDuration;
    
    //视图移动的动画开始
    [UIView animateWithDuration:animation animations:^{
        if (IOS_VERSION<7.0)
        {
            self.view.frame = CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT);
        }else
        {
            self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        }
        
    } completion:^(BOOL finished) {
        
    }];
    
}

#pragma mark - buttonAction
//忘记密码点击的方法

- (void)forgetBtnClick
{
    ForgetPassStep1ViewController *forgetPassStep1VC = [[ForgetPassStep1ViewController alloc]init];
    forgetPassStep1VC.title = @"忘记提现密码（1/3）";
    forgetPassStep1VC.fromViewType = DRAWAL_VC;
    [forgetPassStep1VC creatBackButtonWithPushType:Push With:@"返回" Action:nil];
    [self.navigationController pushViewController:forgetPassStep1VC animated:YES];
}

//提现账户
- (void)clickAccountView
{
    
    if (_allBankInfoArray.count == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"您未绑定银行卡,请先绑定银行卡" delegate:self cancelButtonTitle:@"跳过" otherButtonTitles:@"去设置", nil];
        alert.tag = 800;
        [alert show];
    }else {
        bankAndPayVC = [[BankAndPayViewController alloc] init];
        bankAndPayVC.delegate = self;
        bankAndPayVC.selectedDict = _selectedDict;
        bankAndPayVC.bankPayArray = _allBankInfoArray;
        bankAndPayVC.title = @"提现账户";
        [bankAndPayVC creatBackButtonWithPushType:Push With:self.title Action:nil];
        [self.navigationController pushViewController:bankAndPayVC animated:YES];
    }
}


- (void)confirmBtnClick
{
    [ProjectUtil showLog:@" %f      %f   %@",[_drawalMoneyTextField.text floatValue],[self.accountMoney floatValue],_selectedDict];
    if (_selectedDict[@"account"] == nil) {
        [self.view makeToast:@"提现账户不能为空"];
        return;
    }
    //_moneyStr self.accountMoney
    if (!(_drawalMoneyTextField.text.length > 0)) {
        [self.view makeToast:@"提现金额不能为空"];
        return;
    }else if (![ProjectUtil validateMoney:_drawalMoneyTextField.text]) {
        [self.view makeToast:@"请输入正确的金额,支持两位小数"];
        return;
    }else if ([_drawalMoneyTextField.text floatValue] > [_moneyStr floatValue]) {
        [self.view makeToast:@"提现金额不能大于可转出金额"];
        return;
    }else if (!(_drawalPasswordTextField.text.length > 0)) {
        [self.view makeToast:@"提现密码不能为空"];
        return;
    }else if ([_drawalMoneyTextField.text floatValue]==0){
        [self.view makeToast:@"提现金额为0元，无法提现！"];
        return;
    }
    else if (_drawalPasswordTextField.text.length < 6 || _drawalPasswordTextField.text.length >16) {
        [self.view makeToast:@"密码格式为6—16位字符"];
        return;
    }
    
    [self requestSubWithd];
}

- (void)recycleKeyBoard {
    [_drawalMoneyTextField resignFirstResponder];
    [_drawalPasswordTextField resignFirstResponder];
}

//查询总得雇佣金额  xiamian 下面的参数应该 不对  现在接口没写 有时间在来看 方法不走 不用管它的——mymineylabel什么的
- (void)requestGetRewardByR
{
    NSDictionary *dict = @{@"token":self.login_user_token,
                           @"identity":@"0"
                           };
    
    RequestInterface *requestOp = [[RequestInterface alloc] init];
    [requestOp requestGetRewardByRWithParam:dict];
    
    [requestOp getInterfaceRequestObject:^(id data) {
        [ProjectUtil showLog:@"data = %@",data];
        if ([data[@"result"] boolValue]) {
            NSArray *moneyArray = data[@"datas"];
            if (moneyArray.count > 0) {
                
                NSString *moneyStr = [NSString stringWithFormat:@"%@",(moneyArray[0][@"reward"] == nil)?@"0":moneyArray[0][@"reward"]];
                _myMoneyLabel.text = [NSString stringWithFormat:@"<font size=14>可提现金额：</font><font size=16 color='#EC4E4F'> %@</font><font size=15> 元</font>",(moneyStr == nil)?@"0":moneyStr];
                
                if (moneyStr != nil) {
                    self.accountMoney = moneyStr;
                }
                
            }
            
        }else {
            
            //就是这个老是显示page size 不能为空
//            [self.view makeToast:data[@"message"]];
        }
    } Fail:^(NSError *error) {
        [self.view makeToast:HintWithNetError];
    }];
}

//提现接口  [ProjectUtil changeToStringToMd5String:_drawalPasswordTextField.text],
- (void)requestSubWithd
{
    NSDictionary *dict = @{@"token":self.login_user_token,
                           @"withdrawSum":_drawalMoneyTextField.text,
                           // @"identity":@"0",
                           @"withdrawPwd":_drawalPasswordTextField.text,
                           @"withdrawId":_selectedDict[@"id"] == nil?@"":_selectedDict[@"id"]
                           };
    [self.view makeProgressViewWithTitle:ProgressString];
    RequestInterface *requestOp = [[RequestInterface alloc] init];
    [requestOp requestSubWithdWithParam:dict];
    
    [requestOp getInterfaceRequestObject:^(id data) {
        [self.view hideProgressView];
        [ProjectUtil showLog:@"data = %@",data];
        if ([data[@"success"] boolValue]) {
            //zhege 这个可能是对的  下面的我是直接传值过去的
            _myMoneyLabel.text = [NSString stringWithFormat:@"<font size=14>可提现金额：</font><font size=16 color='#EC4E4F'> %.2f</font><font size=15> 元</font>",([_moneyStr floatValue] - [_drawalMoneyTextField.text floatValue])];
            // _myMoneyLabel.text = [NSString stringWithFormat:@"<font size=14>可提现金额：</font><font size=16 color='#EC4E4F'> %@</font><font size=15> 元</font>",_moneyStr];
            
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"提现成功！" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            alert.tag = 900;
            [alert show];
            _drawalMoneyTextField.text=@"";
            _drawalPasswordTextField.text= @"";
        }else {
            if ([data[@"request"] isEqualToString:@"0"]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"您还未设置提现密码" delegate:self cancelButtonTitle:@"跳过" otherButtonTitles:@"去设置", nil];
                alert.tag = 860;
                [alert show];
            }else {
                [self.view makeToast:data[@"message"]];
            }
            
        }
    } Fail:^(NSError *error) {
        [self.view hideProgressView];
        [self.view makeToast:HintWithNetError];
    }];
}


//查询支付宝 和 银行卡账户
- (void)requestGetWithd
{
    NSDictionary *dict = @{@"token":self.login_user_token,
                           @"page":@"1",
                           @"size":@"10000"
                           };
    
    [self.view makeProgressViewWithTitle:ProgressString];
    RequestInterface *requestOp = [[RequestInterface alloc] init];
    [requestOp requestGetWithdWithParam:dict];
    
    
    [requestOp getInterfaceRequestObject:^(id data) {
        [self.view hideProgressView];
        [ProjectUtil showLog:@"data = %@",data];
        if ([data[@"success"] boolValue]) {
            _allBankInfoArray = data[@"datas"];
            [self updateAcountView];
        }
        
    } Fail:^(NSError *error) {
        [self.view hideProgressView];
        [self.view makeToast:HintWithNetError];
    }];
}

- (void)updateAcountView
{
    if (_allBankInfoArray.count >0) {
        
        _selectedDict = _allBankInfoArray[0];
        NSString * str = [NSString stringWithFormat:@"%@",_selectedDict[@"type"]];
        
        if ([str isEqualToString:@"0"]) {
            _bankNameLabel.text = [NSString stringWithFormat:@"姓名：%@",_selectedDict[@"name"]];
            _bankNumberLabel.text = [NSString stringWithFormat:@"支付宝账号：%@",_selectedDict[@"account"]];
        }else{
            [_bankImageView sd_setImageWithURL:[NSURL URLWithString:_selectedDict[@"bankIcon"]]];
            _bankNameLabel.text = _selectedDict[@"bankName"];
            NSString *bankNumber = _selectedDict[@"account"];
            _bankNumberLabel.text = [NSString stringWithFormat:@"尾号%@",[bankNumber substringFromIndex:bankNumber.length -4]];
        }
        _noticeLabel.hidden = YES;
    }else {
        _noticeLabel.hidden = NO;
        _bankNameLabel.text = @"";
        _bankNumberLabel.text = @"";
    }
}

#pragma mark - BankAndPayViewControllerDelegate
- (void)callBackWithBankOrPayInfo:(NSDictionary *)dict
{
    _selectedDict = dict;
    NSString * str = [NSString stringWithFormat:@"%@",dict[@"type"]];
    if (dict != nil) {
        if ([str isEqualToString:@"0"]) {
            _bankNameLabel.text = [NSString stringWithFormat:@"姓名：%@",dict[@"name"]];
            _bankNumberLabel.text = [NSString stringWithFormat:@"支付宝账号：%@",dict[@"account"]];
        }else{
            [_bankImageView sd_setImageWithURL:[NSURL URLWithString:dict[@"bankIcon"]]];
            _bankNameLabel.text = dict[@"bankName"];
            NSString *bankNumber = dict[@"account"];
            _bankNumberLabel.text = [NSString stringWithFormat:@"银行卡尾号%@",[bankNumber substringFromIndex:bankNumber.length -4]];
        }
        _noticeLabel.hidden = YES;
    }else {
        _noticeLabel.hidden = NO;
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 800 ) {
        if (buttonIndex == 1) {
            AddBankCardViewController *addBankVC = [[AddBankCardViewController alloc] init];
            addBankVC.title = @"添加银行卡";
            [addBankVC creatBackButtonWithPushType:Push With:self.title Action:nil];
            [self.navigationController pushViewController:addBankVC animated:YES];
        }
    }
    if(alertView.tag == 860)
    {
        if (buttonIndex==1)
        {
            SetDrawalStep1ViewController *setDrawVC = [[SetDrawalStep1ViewController alloc] init];
            setDrawVC.title = @"设置提现密码（1/3）";
            [setDrawVC creatBackButtonWithPushType:Push With:self.title Action:nil];
            [self.navigationController pushViewController:setDrawVC animated:YES];
        }
    }
    if (alertView.tag == 900)
    {
        if (buttonIndex == 0) {
            [self.view endEditing:YES];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.delegate refresh];
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    }
    
}

@end
