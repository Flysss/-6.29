//
//  PersonalInformationViewController.m
//  SalesHelper_A
//
//  Created by ZhipuTech on 14/12/21.
//  Copyright (c) 2014年 X. All rights reserved.
//

#import "PersonalInformationViewController.h"
#import "EditUserNameViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface PersonalInformationViewController ()
{
    NSInteger _selectedSexCount;
    UIImagePickerController *imagePicker;
}
@end

@implementation PersonalInformationViewController

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
     [self requestUserInfo];
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:[self imageWithBgColor:[UIColor colorWithRed:23/255.0f green:183/255.0f blue:242/255.0f alpha:1]] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[self imageWithBgColor:[UIColor colorWithRed:23/255.0f green:183/255.0f blue:242/255.0f alpha:1]]];
    
}
#pragma mark  绘制图片
-(UIImage *)imageWithBgColor:(UIColor *)color {
    
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutSubViews];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:21.0/255.0 green:159/255.0 blue:234/255.0 alpha:1]];
    
}

-(void)layoutSubViews
{

    
    self.headImage.layer.cornerRadius = self.headImage.width/2.0;
    self.headImage.layer.masksToBounds = YES;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *userName = [defaults objectForKey:@"login_User_name"];
    self.account.text = userName;
   
    NSString *urlString = [NSString stringWithFormat:@"%@/SalesServer/%@",REQUEST_SERVER_URL,[defaults objectForKey:@"login_User_face"]];
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"toux"]];
    
    UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionDo:)];
    [self.headView addGestureRecognizer:tapGesture];
    
    UITapGestureRecognizer*nameGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editUserNameAction)];
    [self.nameView addGestureRecognizer:nameGesture];
    
    UITapGestureRecognizer*sexGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editUserSexAction)];
    [self.sexView addGestureRecognizer:sexGesture];
    
    
}



-(void)requestUserInfo
{
    //请求用户信息
    RequestInterface *request = [[RequestInterface alloc]init];
    [request requestGetReferInfoWithParam:@{@"token":self.login_user_token}];
    [self.view makeProgressViewWithTitle:@"正在更新"];
    [request getInterfaceRequestObject:^(id data) {
        [ProjectUtil showLog:@"个人信息：%@",data];
        [self.view hideProgressView];
        if ([[data objectForKey:@"result"]isEqualToString:@"success"])
        {
            NSString *nameStr = [data objectForKey:@"name"];
            if (nameStr.length==0)
            {
                nameStr = @"匿名";
            }
            NSString *sexStr = [data objectForKey:@"sex"];
            _selectedSexCount = [sexStr integerValue];
            if (sexStr.length ==0)
            {
                sexStr = @"未选择";
            }
            else if ([sexStr isEqualToString:@"0"])
            {
                sexStr = @"男";
            }
            else if ([sexStr isEqualToString:@"1"])
            {
                sexStr = @"女";
            }
            else
            {
                
            }
            
            self.nameLabel.text = nameStr;
            self.sexLabel.text = sexStr;
        }
        else
        {
            [self.view makeToast:data[@"error_remark"]];
        }
        
    } Fail:^(NSError *error) {
        [self.view hideProgressView];
        [self.view makeToast:HintWithNetError];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 修改姓名
-(void)editUserNameAction
{
    EditUserNameViewController *editUserNameVC = [[EditUserNameViewController alloc]init];
    editUserNameVC.title = @"设置姓名";
    [editUserNameVC creatBackButtonWithPushType:Push With:@"个人" Action:nil];
    [self.navigationController pushViewController:editUserNameVC animated:YES];
}


#pragma mark 修改性别
-(void)editUserSexAction
{
//    CustomAlertView *customAlertView = [[CustomAlertView alloc]initWithTopTitle:@"性别" ItemArr:[NSArray arrayWithObjects:@"男",@"女",nil] SuperView:self.view SelectedCount:_selectedSexCount];
//    customAlertView.delegate = self;
//    [customAlertView show];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"性别"
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"男",@"女",nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    actionSheet.tag = 900;
    [actionSheet showInView:self.view];

}

#pragma mark - 头像修改
-(void)actionDo:(id)sender
{

    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"修改头像"
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"拍照",@"相册",nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    actionSheet.tag = 800;
    
    [actionSheet showInView:self.view];

}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 800) {
        imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.allowsEditing = YES;
        imagePicker.delegate = self;
        if (buttonIndex == 0) {//拍照
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                if (IOS_VERSION>=7.0)
                {
                    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
                    if (authStatus != AVAuthorizationStatusAuthorized)
                    {
                        [ProjectUtil showAlert:@"提示" message:@"当前手机相机不可用，请去设置->隐私->相机，允许“销邦”使用相机"];
                        return;
                    }
                }
            }else{
                
                [ProjectUtil showAlert:@"提示" message:HintWithNoCamera];
                return;
            }
            
        }else if (buttonIndex == 1) {//相册
  
                  imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            
        }else if(buttonIndex==2){//取消
            
            return;
        }
        
        
        [self presentViewController:imagePicker animated:YES completion:^{
//            imagePicker.delegate = self;
        }];
    }else if (actionSheet.tag == 900) {
        
        if(buttonIndex==2){//取消
            
            return;
        }else {
            //修改性别
            NSInteger count = buttonIndex;
            
            RequestInterface *request = [[RequestInterface alloc]init];
            [request requestUpdateReferInfoWithParam:@{@"token":self.login_user_token,@"sex":[NSString stringWithFormat:@"%ld",(long)count]}];
            [self.view makeProgressViewWithTitle:@"正在修改"];
            [request getInterfaceRequestObject:^(id data) {
                [self.view hideProgressView];
                if ([data[@"result"]isEqualToString:@"success"])
                {
                    [self.view makeToast:@"修改成功"];
                    _selectedSexCount = count;
                    self.sexLabel.text = buttonIndex == 0?@"男":@"女";
                }
                else
                {
                    [self.view makeToast:data[@"error_remark"]];
                }
            } Fail:^(NSError *error) {
                [self.view hideProgressView];
                [self.view makeToast:HintWithNetError];
            }];
        }
    }
    
}

- (void)actionSheetCancel:(UIActionSheet *)actionSheet
{
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //获得编辑过的图片
    UIImage *image = [info objectForKey: @"UIImagePickerControllerEditedImage"];
    NSLog(@"image = %@",image);
    RequestInterface *requestOp = [[RequestInterface alloc] init];
    [requestOp requestUploadAvatarInterfaceWithImage:image token:self.login_user_token user_version:@"A"];
    [requestOp getInterfaceRequestObject:^(id data) {
         [ProjectUtil showLog:@"获得编辑过data:%@",data];
        
        //存数据--->基本数据类型
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *urlString = [NSString stringWithFormat:@"%@/SalesServer/%@",REQUEST_SERVER_URL,[defaults objectForKey:@"login_User_face"]];
        [[SDImageCache sharedImageCache]removeImageForKey:urlString fromDisk:YES];        
        [defaults setObject:data[@"module"] forKey:@"login_User_face"];//头像
        [defaults synchronize];
        
        urlString = [NSString stringWithFormat:@"%@/SalesServer/%@",REQUEST_SERVER_URL,data[@"module"]];
        [self.headImage sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:image];
        
    } Fail:^(NSError *error) {
       [self.view makeToast:HintWithNetError];
    }];
    [self dismissViewControllerAnimated:YES completion:nil];
    self.headImage.image = image;
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
    [self dismissViewControllerAnimated:YES completion:nil];

}
@end
