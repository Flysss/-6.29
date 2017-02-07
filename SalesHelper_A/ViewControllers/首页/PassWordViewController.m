//
//  PassWordViewController.m
//  SalesHelper_A
//
//  Created by ZhipuTech on 15/6/15.
//  Copyright (c) 2015年 X. All rights reserved.
//

#import "PassWordViewController.h"

@interface PassWordViewController ()<UITextFieldDelegate>
{
   //第一与第二textField之间的距离
    __weak IBOutlet NSLayoutConstraint *distance12;
    //第二与第三textField之间的距离
    __weak IBOutlet NSLayoutConstraint *distance23;
    //第三与第四个之间的距离
    __weak IBOutlet NSLayoutConstraint *distance34;
    //第四个与第五个之间的距离
    
    __weak IBOutlet NSLayoutConstraint *distance45;
    
    __weak IBOutlet UITextField *textField1;
    
    __weak IBOutlet UITextField *textField2;
    
    __weak IBOutlet UITextField *textField3;
    
    __weak IBOutlet UITextField *textField4;
    
    __weak IBOutlet UITextField *textField5;
    
    __weak IBOutlet UITextField *textField6;
}
@end

@implementation PassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat distance = (self.view.width - 8*2-30*6)/5.0;
    distance12.constant = distance;
    distance23.constant = distance;
    distance34.constant = distance;
    distance45.constant = distance;
    
    UILabel * titleLabel = [UILabel new];
    titleLabel.text = @"设置提现密码";
    titleLabel.font = Default_Font_20;
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    
  /*  [textField1 addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventAllEditingEvents];
    [textField2 addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventAllEditingEvents];
    [textField3 addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventAllEditingEvents];
    [textField4 addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventAllEditingEvents];
    [textField5 addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventAllEditingEvents];
    [textField6 addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventAllEditingEvents];*/
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)valueChanged:(id)sender{
    if (sender == textField1 && textField1.text.length == 1) {
        textField2.text = @"";
        [textField2 becomeFirstResponder];
    }
    else if (sender == textField2 && textField2.text.length == 1) {
        textField3.text = @"";
        [textField3 becomeFirstResponder];
    }
    else if (sender == textField3 && textField3.text.length == 1) {
        textField4.text = @"";
        [textField4 becomeFirstResponder];
    }
    else if (sender == textField4 && textField4.text.length == 1) {
        textField5.text = @"";
        [textField5 becomeFirstResponder];
    }
    else if (sender == textField5 && textField5.text.length == 1) {
        textField6.text = @"";
        [textField6 becomeFirstResponder];
    }
    else if (sender == textField6 && textField6.text.length == 1) {
        [textField6 resignFirstResponder];
    }
}

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (textField == textField1 && textField1.text.length == 1) {
        textField2.text = @"";
        [textField2 becomeFirstResponder];
    }
    else if (textField == textField2 && textField2.text.length == 1) {
        textField3.text = @"";
        [textField3 becomeFirstResponder];
    }
    else if (textField == textField3 && textField3.text.length == 1) {
        textField4.text = @"";
        [textField4 becomeFirstResponder];
    }
    else if (textField == textField4 && textField4.text.length == 1) {
        textField5.text = @"";
        [textField5 becomeFirstResponder];
    }
    else if (textField == textField5 && textField5.text.length == 1) {
        textField6.text = @"";
        [textField6 becomeFirstResponder];
    }
    else if (textField == textField6 && textField6.text.length == 1) {
        [textField6 resignFirstResponder];
    }
    return YES;
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
