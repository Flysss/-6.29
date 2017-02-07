//
//  ChangePasswordViewController.h
//  SalesHelper_A
//
//  Created by zhipu on 14/10/24.
//  Copyright (c) 2014年 zhipu. All rights reserved.
//

#import "ModelViewController.h"

@interface ChangePasswordViewController : ModelViewController

@property (nonatomic, strong) NSString *changeType;
@property (weak, nonatomic) IBOutlet UITextField *oldPassword;
@property (weak, nonatomic) IBOutlet UITextField *password;

@property (weak, nonatomic) IBOutlet UILabel *getIdentityCodeLabel;
@property (weak, nonatomic) IBOutlet UITextField *confirmPassword;
@property (weak, nonatomic) IBOutlet UILabel *mobleText;
@property (weak, nonatomic) IBOutlet UITextField *identityText;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

@end
