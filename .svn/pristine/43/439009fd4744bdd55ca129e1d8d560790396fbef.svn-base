//
//  AddBankCardViewController.m
//  SalesHelper_A
//
//  Created by Reconcilie on 14/10/25.
//  Copyright (c) 2014年 zhipu. All rights reserved.
//

#import "AddBankCardViewController.h"
#import "SelectBankTypeViewController.h"
#import "SetDrawalStep1ViewController.h"
#import "WithdrawalPageViewController.h"
#import "MyPurseViewController.h"
#import "SetDrawalStep3ViewController.h"
#import "MyPurseViewController.h"
#import "WithdrawAccountViewController.h"
@interface AddBankCardViewController ()<UITextFieldDelegate,SelectBankTypeViewControllerDelegate>
{
    //卡号
    UITextField *_bankCardTextField;
    //姓名
    UITextField *_myNameTextField;
    
    //银行类型
    UILabel *_bankTypeLabel;
    
    //银行图片
    UIImageView *_bankTypeImage;
    
    SelectBankTypeViewController *_selectBankVC;
    NSDictionary *_selectBankDict;
    
    NSInteger _bankIndex;
}

@end

@implementation AddBankCardViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
//[self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.096 green:0.458 blue:0.867 alpha:1.000]];
    
    [self layoutSubViews];
    
    [self CreateCustomNavigtionBarWith:self leftItem:@selector(backToView) rightItem:nil];
    //创建标题
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-120)/2, 27, 120, 30)];
    titleLabel.text = @"添加银行卡";
    titleLabel.font = Default_Font_20;
    [titleLabel setTextColor:[UIColor whiteColor]];
    //    [titleLabel sizeToFit];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.topView addSubview: titleLabel];
    
    _bankCardTextField.delegate = self;
    _myNameTextField.delegate = self;
    
    //设置触摸非输入框 键盘隐藏
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(recycleKeyBoard)];
    tapRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapRecognizer];
    _bankIndex = 10000;
}
- (void)backToView
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)layoutSubViews
{
    UIView *bankTypeView = [self creatBackViewWith:CGRectMake(10, 10+64, SCREEN_WIDTH - 20, 45)WithFlag:YES];
    
    _bankTypeImage = [[UIImageView alloc] initWithFrame:CGRectMake(8, 13, 29, 19)];
    [bankTypeView addSubview:_bankTypeImage];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickBankTypeView)];
    tapRecognizer.cancelsTouchesInView = NO;
    [bankTypeView addGestureRecognizer:tapRecognizer];
    [self.view addSubview:bankTypeView];
    
    NSString *rightPath = [[NSBundle mainBundle] pathForResource:@"yjt" ofType:@"png"];
    UIImageView *rightImage = [[UIImageView alloc] initWithFrame:CGRectMake(bankTypeView.right-35, 16, 10, 22*10/14)];
    [rightImage setImage:[UIImage imageWithContentsOfFile:rightPath]];
    [bankTypeView addSubview:rightImage];
    
    
    _bankTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15,0, 200, 45)];
    _bankTypeLabel.backgroundColor = [UIColor clearColor];
    _bankTypeLabel.text = @"请选择银行卡类型";
    _bankTypeLabel.font = Default_Font_14;
    [bankTypeView addSubview:_bankTypeLabel];
    
    
    UIView *bankNumblerView = [self creatBackViewWith:CGRectMake(10, bankTypeView.bottom+10, SCREEN_WIDTH - 20, 45) WithFlag:NO];
    [self.view addSubview:bankNumblerView];
 
    UILabel *bankLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 80, 45)];
    bankLabel.backgroundColor = [UIColor clearColor];
    bankLabel.text = @"卡       号：";
    bankLabel.font = Default_Font_14;
    [bankNumblerView addSubview:bankLabel];
    
    _bankCardTextField = [[UITextField alloc] initWithFrame:CGRectMake(bankLabel.right, bankLabel.top, 210, 45)];
    _bankCardTextField.placeholder = @"银行卡号";
    _bankCardTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _bankCardTextField.keyboardType = UIKeyboardTypeNumberPad;
    _bankCardTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _bankCardTextField.font = Default_Font_15;
    _bankCardTextField.textColor = RGBACOLOR(162, 162, 162, 1);
    [bankNumblerView addSubview:_bankCardTextField];
    
    UIView *myNameView = [self creatBackViewWith:CGRectMake(10, bankNumblerView.bottom+10, SCREEN_WIDTH - 20, 45) WithFlag:NO];
    [self.view addSubview:myNameView];
    
    UILabel *myNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 80, 45)];
    myNameLabel.backgroundColor = [UIColor clearColor];
    myNameLabel.text = @"我的姓名：";
    myNameLabel.font = Default_Font_14;
    [myNameView addSubview:myNameLabel];
    
    _myNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(myNameLabel.right , myNameLabel.top, 210, 45)];
    _myNameTextField.placeholder = @"办理银行卡时姓名";
    _myNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _myNameTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _myNameTextField.font = Default_Font_15;
    _myNameTextField.textColor = RGBACOLOR(162, 162, 162, 1);
    [myNameView addSubview:_myNameTextField];

    //下一步的button
    UIButton *confirmBtn = [self creatUIButtonWithFrame:CGRectMake(15, myNameView.bottom + 40, SCREEN_WIDTH - 30, 40) BackgroundColor:LeftMenuVCBackColor Title:@"确 定" TitleColor:[UIColor whiteColor] Action:@selector(confirmBtnClick)];
    confirmBtn.layer.cornerRadius = 20.0f;
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    
    [self.view addSubview:confirmBtn];

}

- (UIView *)creatBackViewWith:(CGRect)frame WithFlag:(BOOL)flag
{
    UIView *backView = [[UIView alloc] initWithFrame:frame];
    backView.backgroundColor = [UIColor whiteColor];
    backView.layer.cornerRadius = 5;
    
    if (flag) {
        //下一界面引导
        UIImageView *nextImageView = [[UIImageView alloc] initWithFrame:CGRectMake(backView.width - 25, (backView.height-12)/2, 8, 12)];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"zhannghuzuojiantou" ofType:@"png"];
        nextImageView.image = [UIImage imageWithContentsOfFile:path];
        [backView addSubview:nextImageView];
    }
    
    return backView;
}

#pragma mark - button click
- (void)confirmBtnClick
{
    NSString *cardNumber = [_bankCardTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (_selectBankDict[@"id"] == nil) {
        [self.view makeToast:@"请选择银行卡类型"];
        return;
    }
    if (!(_bankCardTextField.text.length > 0)) {
        [self.view makeToast:@"卡号不能为空"];
        return;
    }else if (!(cardNumber.length == 16 || cardNumber.length == 19)) {
        [self.view makeToast:@"请填入正确的银行卡号"];
        return;
    }else if (!(_myNameTextField.text.length > 0)) {
        [self.view makeToast:@"我的姓名不能为空"];
        return;
    }
    
    [self requestAddWithd];
}

#pragma  mark - clickBtnAction
- (void)recycleKeyBoard {
    [self.view endEditing:YES];
}

#pragma mark - UITextFieldDelegate
//当用户按下return键或者按回车键，keyboard消失
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
    if (_bankCardTextField == textField) {  //判断是否时我们想要限定的那个输入框
        if (string.length > 0)
        {
            NSMutableString *txt_tmp = [NSMutableString stringWithFormat:@"%@",textField.text];
            if(textField.text.length == 4)
            {
                [txt_tmp appendString:[NSString stringWithFormat:@" "]];
            }
            else if(textField.text.length ==9)
            {
                [txt_tmp appendString:[NSString stringWithFormat:@" "]];
            }
            else if(textField.text.length ==14)
            {
                [txt_tmp appendString:[NSString stringWithFormat:@" "]];
            }
            else if(textField.text.length ==19)
            {
                [txt_tmp appendString:[NSString stringWithFormat:@" "]];
            }
            [textField setText:txt_tmp];
            
            if ([toBeString length] > 23) { //如果输入框内容大于20则弹出警告
                textField.text = [toBeString substringToIndex:23];
                //            [self.view makeToast:@"超过最大字数(11位)不能输入了"];
                return NO;
            }
        }
        
    }
    
    return YES;
}

- (void)requestAddWithd
{
    NSDictionary *dict = @{@"token":self.login_user_token,
                           @"name":_myNameTextField.text,
                       //    @"identity":@"0",
                           @"bankNumber":[_bankCardTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""],
                           @"bankId":_selectBankDict[@"id"],
                         //  @"type":@"1"
                           };
    [self.view makeProgressViewWithTitle:ProgressString];
    
    RequestInterface *requestOp = [[RequestInterface alloc] init];
    [requestOp requestAddWithdWithParam:dict];
    
    [requestOp getInterfaceRequestObject:^(id data) {
        [self.view hideProgressView];
        [ProjectUtil showLog:@"data = %@",data];
        if ([data[@"success"] boolValue]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"银行卡添加成功" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            alert.tag = 800;
            [alert show];
        }else {
            [self.view makeToast:data[@"error_remark"]];
        }
    } Fail:^(NSError *error) {
        [self.view hideProgressView];
        [self.view makeToast:HintWithNetError];
    }];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 800 ) {
        [self.view endEditing:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            for (UIViewController* controllers in self.navigationController.viewControllers) {
                if ([controllers isKindOfClass:[SetDrawalStep3ViewController class]]) {
//                    MyViewController * my = [[MyViewController alloc]init];
//                    MyPurseViewController * purse = [[MyPurseViewController alloc]init];
//                    WithdrawalPageViewController* drawnpageVC=[[WithdrawalPageViewController alloc]init];
//                    drawnpageVC.title=@"提现";
//                    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
//                    drawnpageVC.moneyStr= [defaults objectForKey:@"myMoney"];
//                    NSArray * arr = @[my,purse,drawnpageVC];
//                    [self.navigationController setViewControllers:arr animated:YES];
                    if ([controllers isKindOfClass:[MyPurseViewController class]]) {
                        [self.navigationController popToViewController:controllers animated:YES];
                    }
//                    [self.navigationController popToRootViewControllerAnimated:YES];
                }
            }
            for (UIViewController* controllers in self.navigationController.viewControllers) {

                if ([controllers isKindOfClass:[MyPurseViewController class]])
                {
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }
        });
    }

}

- (void)clickBankTypeView
{
    _selectBankVC = [[SelectBankTypeViewController alloc] init];
    _selectBankVC.delegate = self;
    _selectBankVC.title = @"选择银行卡";
    _selectBankVC.selectedItemIndex = _bankIndex;
    [_selectBankVC creatBackButtonWithPushType:Push With:@"添加" Action:nil];
    
    [self.navigationController pushViewController:_selectBankVC animated:YES];
}

#pragma mark - SelectBankTypeViewControllerDelegate
- (void)callBackWithBankInfo:(NSDictionary *)dict Index:(NSInteger)index
{
    
    if (dict != nil) {
        _selectBankDict = dict;
        [_bankTypeImage sd_setImageWithURL:[NSURL URLWithString:dict[@"icon"]]];
        
        _bankTypeLabel.frame = CGRectMake(_bankTypeImage.right + 3, 0, 200, 45);
        _bankTypeLabel.text = dict[@"name"];
        _bankIndex = index;
    }
}

@end
