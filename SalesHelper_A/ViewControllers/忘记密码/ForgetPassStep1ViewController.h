//
//  ForgetPassStep1ViewController.h
//  SalesHelper_A
//
//  Created by summer on 14/12/19.
//  Copyright (c) 2014年 X. All rights reserved.
//

#import "ModelViewController.h"

@interface ForgetPassStep1ViewController : ModelViewController

@property (nonatomic, strong) NSString *fromViewType;

@property (weak, nonatomic) IBOutlet UITextField *phoneField;//手机输入框
@property (weak, nonatomic) IBOutlet UIButton *getIdentityCodeBtn;//获取验证码按钮

@end
