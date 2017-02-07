//
//  EditUserNameViewController.m
//  SalesHelper_A
//
//  Created by summer on 14/12/30.
//  Copyright (c) 2014年 X. All rights reserved.
//

#import "EditUserNameViewController.h"

@interface EditUserNameViewController () <UITextFieldDelegate>

@end

@implementation EditUserNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutSubViews];
    
    self.userNameField.delegate = self;
    
  

}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

-(void)layoutSubViews
{
    //回收键盘
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(recycleKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    
//    UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    doneBtn.frame = CGRectMake(0, 0, 40, 30);
//    [doneBtn setTitle:@"完成" forState:UIControlStateNormal];
//    [doneBtn setTitleColor:NavigationBarTitleColor forState:UIControlStateNormal];
//    doneBtn.titleLabel.font = Default_Font_17;
//    [doneBtn addTarget: self action:@selector(doneBtnAction) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:doneBtn];
    
    [self CreateCustomNavigtionBarWith:self leftItem:@selector(backToView) rightItem:@selector(doneBtnAction)];
    //创建标题
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-120)/2, 27, 120, 30)];
    titleLabel.text = @"设置姓名";
    titleLabel.font = Default_Font_20;
    [titleLabel setTextColor:[UIColor whiteColor]];
    //    [titleLabel sizeToFit];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.rightBtn setTitle:@"完成" forState:UIControlStateNormal];
    [self.rightBtn setImage:nil forState:(UIControlStateNormal)];
    [self.rightBtn setTitleColor:NavigationBarTitleColor forState:UIControlStateNormal];
    
    [self.topView addSubview: titleLabel];
}
- (void)backToView
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark 回收键盘
-(void)recycleKeyboard
{
    [self.view endEditing:YES];
}

#pragma mark 提交姓名
- (void)doneBtnAction
{
    [self recycleKeyboard];
    
    //姓名长度后台已加判断
    if (self.userNameField.text.length==0)
    {
        [self.view makeToast:@"请输入修改的姓名！"];
    }
    else if (![self.userNameField.text isType:StringTypeChineseName])
    {
        [self.view makeToast:@"姓名只能是纯中文！"];
    }
    else
    {
        
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        
        NSDictionary* dict=@{@"token":self.login_user_token,
                             @"name":_userNameField.text,
                             };
        RequestInterface *request = [[RequestInterface alloc]init];
     
        [request requestsaveMyInfoWithtoken:dict];
        [self.view makeProgressViewWithTitle:@"正在修改"];
        [request getInterfaceRequestObject:^(id data) {
            [self.view hideProgressView];
            if ([data[@"success"]boolValue])
            {
               
                 [self.view.window makeToast:@"修改成功"];
                if ([[data objectForKey:@"datas"]objectForKey:@"name"]) {
                    [defaults setObject:[[data objectForKey:@"datas"]objectForKey:@"name"]forKey:@"name"];
                    [self.delegeate Chuanmingzidelegate:self.userNameField.text];
                }
                
                NSNotification *nitifi = [NSNotification notificationWithName:@"changeImageSuccess" object:nil];
                [[NSNotificationCenter defaultCenter] postNotification:nitifi];
                
                [self.navigationController popViewControllerAnimated:YES];

            }
            else
            {
                 [self.view makeToast:data[@"message"]];
            }
        } Fail:^(NSError *error) {
            [self.view hideProgressView];
             [self.view makeToast:HintWithNetError];
        }];
    }

}

#pragma mark UItextFieldDelegate  点击键盘上的 完成按钮
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    [self doneBtnAction];
    return YES;
}

//
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
////    if (string.length == 0) return YES;
////    
////    NSInteger existedLength = textField.text.length;
////    NSInteger selectedLength = range.length;
////    NSInteger replaceLength = string.length;
////    if (existedLength - selectedLength + replaceLength > 5)
////    {
////        return NO;
////    }
//    
//    
//    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
//    
//        if ([toBeString length] > 10) { //如果输入框内容大于16则弹出警告
//            textField.text = [toBeString substringToIndex:10];
//            //        [self.view makeToast:@"超过最大字数(16位)不能输入了"];
//            return NO;
//    }
//    return YES;
//    
//}



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
