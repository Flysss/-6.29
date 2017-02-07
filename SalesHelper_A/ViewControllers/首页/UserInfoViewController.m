//
//  UserInfoViewController.m
//  SalesHelper_A
//
//  Created by Brant on 15/12/25.
//  Copyright (c) 2015年 X. All rights reserved.
//

#import "UserInfoViewController.h"
#import "UIColor+Extend.h"
#import "EditUserNameViewController.h"
#import "ChangePasswordViewController.h"
#import "SCLAlertView.h"
#import "bindingCodeViewController.h"

#define CellHeight 44

typedef NS_ENUM(NSUInteger, orgType) {
    PersonalType,
    CompanyType,
};

@interface UserInfoViewController () <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ChuanrenmingNamedelegate, UIAlertViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UITableView *m_tableView;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSDictionary *dataDic;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *sexLabel;
@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel * orgLabel;

@end

@implementation UserInfoViewController
{
    NSInteger _selectedSexCount;
    UIImage * headImage;
//    UILabel * orgLabel;
    orgType myType;
    NSString * orgCode;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    self.navigationController.navigationBarHidden = YES;
    
//    [self refreshTableView];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self CreateCustomNavigtionBarWith:self leftItem:@selector(backToView) rightItem:nil];
    //创建标题
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-120)/2, 27, 120, 30)];
    titleLabel.text = @"个人信息";
    titleLabel.font = Default_Font_20;
    [titleLabel setTextColor:[UIColor whiteColor]];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.topView addSubview: titleLabel];
    
    self.titleArray = @[@[@"头像",@"我的账号"], @[@"真实姓名",@"性别"], @[@"修改登录密码"], @[@"机构码:     未绑定机构"]];
    self.dataDic = [NSDictionary dictionary];
    
    [self creatTableView];
    
    if (GetUserID != nil)
    {
       [self requestData];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTableView) name:@"bindingOrgCode" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTableView) name:@"bindingOrgCodeRelease" object:nil];

}
-(void)refreshTableView
{
//    [self.m_tableView reloadData];
    [self requestData];
}


- (void)backToView
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark --创建列表
- (void)creatTableView
{
    self.m_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    self.m_tableView.delegate = self;
    self.m_tableView.dataSource = self;
    self.m_tableView.tableFooterView = [[UIView alloc] init];
    self.m_tableView.contentInset = UIEdgeInsetsMake(15, 0, 0, 0);
    self.m_tableView.backgroundColor = [UIColor hexChangeFloat:@"f1f1f1"];
    [self.view addSubview:self.m_tableView];
}




#pragma mark --请求数据
- (void)requestData
{
    //请求用户信息
//    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    if (GetUserID !=nil )
    {
        RequestInterface *request = [[RequestInterface alloc]init];
        [request requestGetReferInfoWithParam:@{@"token":GetUserID}];
        request.cachDisk = NO;
        [request getInterfaceRequestObject:^(id data) {
            
            
            if ([data[@"success"] boolValue] == YES)
            {
                self.dataDic = data[@"datas"];
                [self.m_tableView reloadData];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"%@", indexPath]];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    

    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            //标题
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 70)];
            titleLabel.text = self.titleArray[indexPath.section][indexPath.row];
            titleLabel.font = Default_Font_15;
            titleLabel.textColor = [UIColor hexChangeFloat:@"3e3a39"];
            [cell.contentView addSubview:titleLabel];
            
            //右向箭头
            UIImageView *headView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-8-10, (70-14)/2, 8, 14)];
            headView.image = [UIImage imageNamed:@"yjt"];
            [cell.contentView addSubview:headView];
            
            //头像
            self.headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-20-60, 10, 50, 50)];
            self.headImageView.layer.cornerRadius = 25;
            self.headImageView.clipsToBounds = YES;
            
            if (self.dataDic[@"face"] != nil && self.dataDic[@"face"] != [NSNull null] && self.dataDic[@"face"])
            {
                [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", Image_Url, self.dataDic[@"face"]]] placeholderImage:[UIImage imageNamed:@"客户-客户管理"]];
            }
            [cell.contentView addSubview:self.headImageView];
            
            //边界线
            UILabel *laebl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
            laebl.backgroundColor = [UIColor hexChangeFloat:@"d2d2d2"];
            [cell.contentView addSubview:laebl];
            
        }
        else {
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, CellHeight)];
            titleLabel.text = self.titleArray[indexPath.section][indexPath.row];
            titleLabel.font = Default_Font_15;
            titleLabel.textColor = [UIColor hexChangeFloat:@"3e3a39"];
            [cell addSubview:titleLabel];
            
            //电话号码
            UILabel *phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-140, 0, 130, CellHeight)];
            if (self.dataDic[@"user"] != nil && self.dataDic[@"user"]!= [NSNull null] && self.dataDic[@"user"])
            {
                NSString * startStr = [self.dataDic[@"user"] substringWithRange:NSMakeRange(0, 3)];
                NSString * endStr = [self.dataDic[@"user"] substringFromIndex:7];
                phoneLabel.text = [NSString stringWithFormat:@"%@****%@",startStr,endStr];
            }
            phoneLabel.textAlignment = NSTextAlignmentRight;
            phoneLabel.font= Default_Font_15;
            phoneLabel.textColor = [UIColor hexChangeFloat:KGrayColor];
            [cell.contentView addSubview:phoneLabel];
            
            
            //边界线
            UILabel *laebl = [[UILabel alloc] initWithFrame:CGRectMake(0, CellHeight-0.5, SCREEN_WIDTH, 0.5)];
            laebl.backgroundColor = [UIColor hexChangeFloat:@"d2d2d2"];
            [cell.contentView addSubview:laebl];
        }
    }
    else if (indexPath.section == 1)
    {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, CellHeight)];
        titleLabel.text = self.titleArray[indexPath.section][indexPath.row];
        titleLabel.font = Default_Font_15;
        titleLabel.textColor = [UIColor hexChangeFloat:@"3e3a39"];
        [cell addSubview:titleLabel];
        
        if (indexPath.row == 0)
        {
            
            self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-20-100, 0, 100, CellHeight)];
            self.nameLabel.textColor = [UIColor hexChangeFloat:KGrayColor];
            self.nameLabel.font = Default_Font_15;
            self.nameLabel.textAlignment = NSTextAlignmentRight;
            if (self.dataDic[@"name"] != nil && self.dataDic[@"name"] != [NSNull null] && self.dataDic[@"name"]) {
                
                self.nameLabel.text = self.dataDic[@"name"];
                
            }
            [cell.contentView addSubview:self.nameLabel];
            
            //右向箭头
            UIImageView *headView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-8-10, (CellHeight-14)/2, 8, 14)];
            headView.image = [UIImage imageNamed:@"yjt"];
            [cell.contentView addSubview:headView];
            
            //边界线
            UILabel *laebl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
            laebl.backgroundColor = [UIColor hexChangeFloat:@"d2d2d2"];
            [cell.contentView addSubview:laebl];
        } else {
            
            self.sexLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-20-100, 0, 100, CellHeight)];
            if ([self.dataDic[@"sex"] intValue] == 0)
            {
                self.sexLabel.text = @"男";
            } else {
                self.sexLabel.text = @"女";
            }
            self.sexLabel.textAlignment = NSTextAlignmentRight;
            self.sexLabel.font = Default_Font_15;
            self.sexLabel.textColor = [UIColor hexChangeFloat:KGrayColor];
            [cell.contentView addSubview:self.sexLabel];
            
            //右向箭头
            UIImageView *headView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-8-10, (CellHeight-14)/2, 8, 14)];
            headView.image = [UIImage imageNamed:@"yjt"];
            [cell.contentView addSubview:headView];
            
            //边界线
            UILabel *laebl = [[UILabel alloc] initWithFrame:CGRectMake(0, CellHeight-0.5, SCREEN_WIDTH, 0.5)];
            laebl.backgroundColor = [UIColor hexChangeFloat:@"d2d2d2"];
            [cell.contentView addSubview:laebl];
        }
    }
    else if (indexPath.section == 2)
    {
        //右向箭头
        UIImageView *headView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-8-10, (CellHeight-14)/2, 8, 14)];
        headView.image = [UIImage imageNamed:@"yjt"];
        [cell.contentView addSubview:headView];

        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, CellHeight)];
        titleLabel.text = self.titleArray[indexPath.section][indexPath.row];
        titleLabel.font = Default_Font_15;
        titleLabel.textColor = [UIColor hexChangeFloat:@"3e3a39"];
        [cell addSubview:titleLabel];
        
        //边界线
        UILabel *laebl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
        laebl.backgroundColor = [UIColor hexChangeFloat:@"d2d2d2"];
        [cell.contentView addSubview:laebl];
        //边界线
        UILabel *laebl1 = [[UILabel alloc] initWithFrame:CGRectMake(0, CellHeight-0.5, SCREEN_WIDTH, 0.5)];
        laebl1.backgroundColor = [UIColor hexChangeFloat:@"d2d2d2"];
        [cell.contentView addSubview:laebl1];
    }
    else
    {
        
        NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];

        //右向箭头
        UIImageView *headView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-8-10, (CellHeight-14)/2, 8, 14)];
        headView.image = [UIImage imageNamed:@"yjt"];
        [cell.contentView addSubview:headView];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, CellHeight)];
        titleLabel.text = @"机构码:";
        titleLabel.font = Default_Font_15;
        titleLabel.textColor = [UIColor hexChangeFloat:@"3e3a39"];
        [cell addSubview:titleLabel];
        
        self.orgLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-20-100, 0, 100, CellHeight)];
        self.orgLabel.textAlignment = NSTextAlignmentRight;
        self.orgLabel.font = Default_Font_15;
        self.orgLabel.textColor = [UIColor hexChangeFloat:KGrayColor];
        [cell.contentView addSubview:self.orgLabel];
        
        if ([[userInfo objectForKey:@"orgType"] isEqualToString:@"2"])
        {
           self.orgLabel.text = [NSString stringWithFormat:@"%@",
               [userInfo objectForKey:@"orgCode"]];
        }
        else if ([[userInfo objectForKey:@"orgType"] isEqualToString:@"1"])
        {
            self.orgLabel.text = @"未绑定机构码";
        }
        else
        {
            self.orgLabel.text = @"正在审核中";
        }
        
        //边界线
        UILabel *laebl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
        laebl.backgroundColor = [UIColor hexChangeFloat:@"d2d2d2"];
        [cell.contentView addSubview:laebl];
        //边界线
        UILabel *laebl1 = [[UILabel alloc] initWithFrame:CGRectMake(0, CellHeight-0.5, SCREEN_WIDTH, 0.5)];
        laebl1.backgroundColor = [UIColor hexChangeFloat:@"d2d2d2"];
        [cell.contentView addSubview:laebl1];
    }
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0)
    {
        return 70;
    }
    else
    {
        return CellHeight;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0 || section == 1)
    {
        return 2;
    }
    else
    {
        return 1;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 15;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 15)];
    footerView.backgroundColor = [UIColor hexChangeFloat:@"f1f1f1"];
    return footerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0)
    {
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:@"修改头像"
                                      delegate:self
                                      cancelButtonTitle:@"取消"
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:@"拍照",@"相册",nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
        actionSheet.tag = 800;
        [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
    }
    else if (indexPath.section == 1)
    {
#pragma mark --修改姓名
        if (indexPath.row==0)
        {
            EditUserNameViewController *editUserNameVC = [[EditUserNameViewController alloc]init];
            editUserNameVC.delegeate = self;
            
            editUserNameVC.title = @"设置姓名";
            [editUserNameVC creatBackButtonWithPushType:Push With:@"个人" Action:nil];
            [self.navigationController pushViewController:editUserNameVC animated:YES];
        }
        
#pragma mark --修改性别
        else
        {
            
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

    }
#pragma mark --修改密码
    if (indexPath.section==2)
    {
        ChangePasswordViewController* changPsw = [[ChangePasswordViewController alloc] init];
        changPsw.title = @"修改登录密码";
        changPsw.changeType = @"loginPwd";
        [self.navigationController pushViewController:changPsw animated:YES];
    }
#pragma mark --绑定机构
    if (indexPath.section == 3)
    {
        
        bindingCodeViewController * VC = [[bindingCodeViewController alloc]init];
        VC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:VC animated:YES];

//        if (GetOrgCode != nil)
//        {
//        
//        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"确定解绑机构?\n%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"orgName"]] message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
//        alert.tag = 110;
//        alert.delegate = self;
//        [alert show];
//        }else
//        {
//            
//            
//        }
        
        
    }
//        NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
//         NSInteger orgTypeNum = [[userInfo objectForKey:@"orgType"] integerValue];
//        if (orgTypeNum == 1)
//        {
//            SCLAlertView *alert = [[SCLAlertView alloc] init];
//            
//            UITextField * textField = [alert addTextField:@""];
//            textField.delegate = self;
//            textField.keyboardType = UIKeyboardTypeNumberPad;
//            
//            __weak typeof(alert)WeakAlert = alert;
//            [alert addButton:@"确定" actionBlock:^(void) {
//                if (textField.text.length == 8)
//                {
//                    [WeakAlert hideView];
//                    NSDictionary * dic = @{
//                                           @"token":self.login_user_token,
//                                           @"orgCode":textField.text,
//                                           };
//                    RequestInterface * request = [[RequestInterface alloc]init];
//                    [request requestOrgCodeWithParam:dic];
//                    [request getInterfaceRequestObject:^(id data) {
//
//                        if ([[data objectForKey:@"success"] boolValue])
//                        {
//                            [self.view makeToast:@"恭喜您,绑定成功" duration:0.5 position:@"center"];
//                            
//                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                                [self.view Loading_0314];
//                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                                    [self.view Hidden];
//                                    
//                                    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
//                                    [defaults setObject:[NSNumber numberWithInt:2] forKey:@"orgType"];
//                                    [defaults setObject:[data objectForKey:@"orgName"] forKey:@"orgName"];
//                                    [defaults setObject:textField.text forKey:@"orgCode"];
//                                    [defaults synchronize];
//                                    
//                                    [self.navigationController popViewControllerAnimated:YES];
//                                });
//                            });
//                            
//                        }else{
//                            [self.view makeToast:[data objectForKey:@"message"] duration:0.2 position:@"center"];
//                        }
//                    } Fail:^(NSError *error) {
//                        [self.view makeToast:@"网络错误" duration:0.2 position:@"center"];
//                    }];
//                }
//                else
//                {
//                    [self.view makeToast:@"机构码不正确" duration:0.8 position:@"center"];
//                }
//            }];
//            
//            [alert showEdit:self title:@"销邦提示您" subTitle:@"请输入机构码" closeButtonTitle:@"取消" duration:0.0f];
//        }
//        else
//        {
//            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"确定解绑机构?" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
//            alert.tag = 110;
//            alert.delegate = self;
//            [alert show];
//        }
//        
//        
//    }

}

#pragma mark --解绑
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 110)
    {
        if (buttonIndex == 0)
        {
            NSDictionary * dic = @{
                                   @"token":self.login_user_token,
                                   @"orgCode":@"",
                                   };
            
            RequestInterface * request = [[RequestInterface alloc]init];
            [request requestOrgCodeWithParam:dic];
            [self.view Loading_0314];
            [request getInterfaceRequestObject:^(id data) {
                [self.view Hidden];
                if ([[data objectForKey:@"success"] boolValue])
                {
                    [self.view makeToast:@"解绑成功"];
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        
                        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
//                        [defaults setObject:[NSNumber numberWithInt:1] forKey:@"orgType"];
//                        
//                        [defaults removeObjectForKey:@"orgCode"];
//                        [defaults removeObjectForKey:@"orgName"];

                        [defaults setObject:[NSString stringWithFormat:@"%@",[data[@"datas"] objectForKey:@"orgtype"]] forKey:@"orgType"];
                        [defaults setObject:[data objectForKey:@"orgName"] forKey:@"orgName"];
                        [defaults setObject:[data objectForKey:@"orgCode"] forKey:@"orgCode"];
                        [defaults synchronize];
                        
                        [self.navigationController popViewControllerAnimated:YES];
                    });
                
                    
                }
                else
                {
                    [self.view makeToast:[data objectForKey:@"message"] duration:0.2 position:@"center"];
                }
            } Fail:^(NSError *error) {
                [self.view makeToast:@"网络错误" duration:0.2 position:@"center"];
            }];

        }
    }
}

//actionsheet的代理方法
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //修改头像
    if (actionSheet.tag == 800)
    {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        if (buttonIndex == 0)
        {//拍照
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            }else{
                
                [ProjectUtil showAlert:@"提示" message:HintWithNoCamera];
                return;
            }
            
        }else if (buttonIndex == 1) {//相册
            
            imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            
        }else if(buttonIndex==2){//取消
            
            return;
        }
        
        imagePicker.allowsEditing = YES;
        imagePicker.delegate = self;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
    else if (actionSheet.tag == 900)
    {
        
        if(buttonIndex==2)
        {//取消
            
            return;
        }
        else
        {
            //修改性别
            NSInteger count = buttonIndex;
            
            RequestInterface *request = [[RequestInterface alloc]init];
            
            [request requestsaveMyInfoWithtoken:@{
                                                  @"token":self.login_user_token,@"sex":[NSString stringWithFormat:@"%ld",(long)count]
                                                  }];
            [self.view makeProgressViewWithTitle:@"正在修改"];
            [request getInterfaceRequestObject:^(id data) {
                [self.view hideProgressView];
                
                if ([data[@"success"] boolValue])
                {
                    BOOL isSexyGirl = [[[data objectForKey:@"datas"] objectForKey:@"sex"] boolValue];
                    [self.view makeToast:@"修改成功"];
                    self.sexLabel.text = isSexyGirl ? @"女" : @"男";
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

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    //获得编辑过的图片
    UIImage *image = [info objectForKey: @"UIImagePickerControllerEditedImage"];
    image = [self ImageWithImageSimple:image ScaledToSize:CGSizeMake(100, 100)];
    headImage = image;
        // NSData * data_IMG = UIImageJPEGRepresentation(img, 1.0);
    self.headImageView.image = image;
    //获得编辑过的图片UIImagePickerControllerEditedImage UIImagePickerControllerOriginalImage
    RequestInterface *requestOp = [[RequestInterface alloc] init];
    [requestOp requestUploadAvatarInterfaceWithImage:image token:self.login_user_token user_version:@"A"];
    [requestOp getInterfaceRequestObject:^(id data) {
        
//        NSLog(@"img = %@",data);
        //存数据--->基本数据类型
//        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString * urlString = [NSString stringWithFormat:@"%@/%@",Image_Url,data[@"datas"]];
        [[SDImageCache sharedImageCache] removeImageForKey:urlString fromDisk:YES];
//        [defaults setObject:data[@"datas"] forKey:@"login_User_face"];//头像
//        [defaults synchronize];
        
        [self requestmYinfowithDBWithURlString:data[@"datas"]];
        
    } Fail:^(NSError *error)
    {
        [self.view makeToast:HintWithNetError];
    }];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)requestmYinfowithDBWithURlString: (NSString *)urlString
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (self.nameLabel.text == nil)
    {
        dict[@"token"] = self.login_user_token;
        dict[@"sex"] = [defaults objectForKey:@"sex"];
        dict[@"face"] = urlString;
    }
    else
    {
        dict[@"token"] = self.login_user_token;
        dict[@"sex"] = [defaults objectForKey:@"sex"];
        dict[@"face"] = urlString;
        dict[@"name"] = self.nameLabel.text;
    }

    RequestInterface* requestOP = [[RequestInterface alloc]init];
    [requestOP requestsaveMyInfoWithtoken:dict];
    [requestOP getInterfaceRequestObject:^(id data){
        
//        NSLog(@"data = %@",data);
        if ([[data objectForKey:@"success"] boolValue]) {
            
            NSNotification *notifi = [NSNotification notificationWithName:@"changeImageSuccess" object:nil];
            [[NSNotificationCenter defaultCenter] postNotification:notifi];
            
            if ([data objectForKey:@"token"])
            {
                [defaults setObject:data[@"token"] forKey:@"login_User_token"];
            }
            if ([[data objectForKey:@"datas"] objectForKey:@"name"] != [NSNull null])
            {
                if ([[[data objectForKey:@"datas"] objectForKey:@"name"] length])
                {
                    [defaults setObject:[[data objectForKey:@"datas"] objectForKey:@"name"] forKey:@"name"];
                }
                else
                {
                    [defaults setObject:@"匿名" forKey:@"name"];
                }
                
            }
            if ([[data objectForKey:@"datas"]objectForKey:@"sex"]) {
                [defaults setObject:[[data objectForKey:@"datas"]objectForKey:@"sex"] forKey:@"sex"];
            }
            if ([[data objectForKey:@"datas"] objectForKey:@"face"]) {
                [defaults setObject:[[data objectForKey:@"datas"]objectForKey:@"face"]forKey:@"login_User_face"];
            }
            
            [defaults synchronize];
        }
        else{
            [self.view makeToast:data[@"error_remark"]];
        }
    } Fail:^(NSError *error){
        [self.view hideProgressView];
        [self.view makeToast:HintWithNetError];
    }];
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


//压缩图片
-(UIImage*)ImageWithImageSimple:(UIImage*)image ScaledToSize:(CGSize)newSize{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


-(void)Chuanmingzidelegate:(NSString *)NameStr
{
    self.nameLabel.text= NameStr;
}




//将列表的分割线从头开始
//最新的，简便些
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    
    if (IOS_VERSION >= 8.0)
    {
        if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)])
        {
            [cell setPreservesSuperviewLayoutMargins:NO];
        }
        if ([cell respondsToSelector:@selector(setLayoutMargins:)])
        {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
    }
}



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
