//
//  RegisterStep3ViewController.h
//  SalesHelper_A
//
//  Created by summer on 14/12/18.
//  Copyright (c) 2014年 X. All rights reserved.
//

#import "ModelViewController.h"

@interface SetDrawalStep3ViewController : ModelViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *passField;
@property (weak, nonatomic) IBOutlet UITextField *rePassField;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

@property (strong, nonatomic) NSString *myPhoneNo;//手机号
@property (strong, nonatomic) NSString *identityCode;//验证码

//在结束设置密码后是否设置银行卡
@property(nonatomic,assign)BOOL isShowBank;

@end
