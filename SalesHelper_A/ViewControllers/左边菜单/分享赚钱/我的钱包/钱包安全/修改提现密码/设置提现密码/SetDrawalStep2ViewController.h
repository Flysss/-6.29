//
//  SetDrawalStep2ViewController.h
//  SalesHelper_A
//
//  Created by summer on 14/12/18.
//  Copyright (c) 2014年 X. All rights reserved.
//

#import "ModelViewController.h"

@interface SetDrawalStep2ViewController : ModelViewController
@property (weak, nonatomic) IBOutlet UILabel *hintLabel;
@property (weak, nonatomic) IBOutlet UILabel *getIdentityCodeLabel;
@property (weak, nonatomic) IBOutlet UITextField *identityCodeField;
@property (weak, nonatomic) IBOutlet UIButton *postIdentityCodeBtn;

@property (strong, nonatomic) NSString *myPhoneNo;//手机号
@property (strong, nonatomic) NSString *identityCode;//验证码

//在结束设置密码后是否设置银行卡
@property(nonatomic,assign)BOOL isShowBank;

@end
