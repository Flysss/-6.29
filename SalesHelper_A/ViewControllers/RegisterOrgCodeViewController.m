//
//  RegisterOrgCodeViewController.m
//  SalesHelper_A
//
//  Created by flysss on 16/4/7.
//  Copyright © 2016年 X. All rights reserved.
//

#import "RegisterOrgCodeViewController.h"
#import "APService.h"
#import "MobClick.h"
#import "TZImagePickerController.h"
#import "AFHTTPRequestOperationManager.h"
#import "IQKeyboardManager.h"
#import <RongIMKit/RongIMKit.h>

@interface RegisterOrgCodeViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,TZImagePickerControllerDelegate,RCIMUserInfoDataSource>


@property (nonatomic, strong) UITableView* tableView;

@property (nonatomic, strong)NSMutableArray * dataArr;

@property (nonatomic, strong)NSMutableDictionary* dataSource;

@end

@implementation RegisterOrgCodeViewController
{
    UITextField * orgField;
    UITextField * contactField;
    UITextField * phoneField;
    UIImageView * personImg;
    UIImageView * companyImg;
    NSMutableArray * arrImg;
    
    UIImageView * uploadImg1;
    UIImageView * uploadImg2;
    
     NSMutableArray * selectedPhotos;
     NSMutableArray *photoArr;
    NSString *tapTag;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    photoArr = [NSMutableArray arrayWithCapacity:0];
    arrImg = [NSMutableArray arrayWithCapacity:0];
    selectedPhotos = [NSMutableArray arrayWithCapacity:0];
   
    self.view.backgroundColor = [UIColor whiteColor];
    
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;

    
    self.view.backgroundColor = [UIColor hexChangeFloat:@"f2f2f2"];
    
    [self CreateCustomNavigtionBarWith:self leftItem:@selector(backlastView) rightItem:nil];
    //创建标题
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-120)/2, 27, 120, 30)];
    titleLabel.text = @"申请机构码";
    
    if (self.isBinding)
    {
        titleLabel.font = Default_Font_20;
    }else{
        titleLabel.font = Default_Font_16;
    }
    
    [titleLabel setTextColor:[UIColor whiteColor]];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.topView addSubview: titleLabel];
    

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addImageFromCamera:) name:HWImagePickerImage object:nil];

    
    
//    UILabel * navititleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
//    navititleLabel.backgroundColor = [UIColor clearColor];
//    navititleLabel.textColor = [UIColor whiteColor];
//    navititleLabel.text = @"申请机构码";
//    navititleLabel.textAlignment = NSTextAlignmentCenter;
//    navititleLabel.font = Default_Font_18;
//    self.navigationItem.titleView = navititleLabel;
//    
//    UIButton* leftbtn=[UIButton buttonWithType:UIButtonTypeCustom];
//    leftbtn.frame=CGRectMake(0, 0, 26, 26);
//    [leftbtn setBackgroundImage:[UIImage imageNamed:@"首页-左箭头.png"] forState:UIControlStateNormal];
//    [leftbtn setBackgroundImage:[UIImage imageByApplyingAlpha:[UIImage imageNamed:@"首页-左箭头.png"]] forState:UIControlStateHighlighted];
//    
//    [leftbtn addTarget:self action:@selector(backlastView) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem* back=[[UIBarButtonItem alloc]initWithCustomView:leftbtn];
//    self.navigationItem.leftBarButtonItem=back;
    
    
    [self createTableView];
    
    self.dataArr = [NSMutableArray arrayWithCapacity:0];
    self.dataSource = [NSMutableDictionary dictionaryWithCapacity:0];
}


- (void)addImageFromCamera:(NSNotification *)noti
{
    
    UIImage *image = noti.userInfo[HWCameraImage];
    
    if ([tapTag isEqualToString:@"999"])
    {
        personImg.image = image;
        uploadImg1.hidden = YES;
    }else if ([tapTag isEqualToString:@"888"])
    {
        companyImg.image = image;
        uploadImg2.hidden = YES;
    }
    [self.view Loading_0314];
    
    CGFloat w = image.size.width;
    CGFloat h = image.size.height;
    
    UIImage *  image1 = [self ImageWithImageSimple:image  ScaledToSize:CGSizeMake(w/4,h/4)];
    RequestInterface *requestOp = [[RequestInterface alloc] init];
    [requestOp requestUploadPersonImgWithImage:image1];
    [requestOp getInterfaceRequestObject:^(id data) {
        
        if ([data[@"success"] boolValue ])
        {
            [self.view Hidden];
            NSLog(@"data1 = %@",data);
            [self.dataArr addObject:data[@"datas"]];
        }
    }
    Fail:^(NSError *error)
     {
         NSLog(@"error= %@",error);
         [self.view Hidden];
         [self.view makeToast:HintWithNetError];
     }];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
- (void)backlastView
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)createTableView
{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,64, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor hexChangeFloat:@"f2f2f2"];
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    [self.view addSubview:self.tableView];
}

#pragma mark  tableView协议代理方法
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row ==3 || indexPath.row == 5)
    {
        return 80;
    }else if (indexPath.row == 4)
    {
        return 150;
    }else
    return 44;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"cell%ld", (long)indexPath.row]];
    
    if (indexPath.row == 0)
    {
        orgField = [[UITextField alloc]initWithFrame:CGRectMake(40, 12, SCREEN_WIDTH-50, 20)];
        orgField.placeholder = @"请填写机构名称";
        orgField.delegate = self;
        orgField.font = Default_Font_15;
        orgField.text = [self.dataSource objectForKey:@"org"];
        [cell.contentView addSubview:orgField];
        
        UIImageView * orgImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 12, 20, 20)];
        orgImg.image = [UIImage imageNamed:@"home1-1-0"];
        [cell.contentView addSubview:orgImg];
        
        UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
        line.backgroundColor = [UIColor hexChangeFloat:KHuiseColor];
        line.alpha = 0.5;
        [cell.contentView addSubview:line];
    }
    else if (indexPath.row == 1)
    {
        contactField = [[UITextField alloc]initWithFrame:CGRectMake(40, 12, SCREEN_WIDTH-50, 20)];
        contactField.placeholder = @"请填写联系人";
        contactField.delegate = self;
        contactField.font = Default_Font_15;
        contactField.text = [self.dataSource objectForKey:@"contact"];
        [cell.contentView addSubview:contactField];
        
        UIImageView * contactImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 12, 20, 20)];
        contactImg.image = [UIImage imageNamed:@"sf1-1-0"];
        [cell.contentView addSubview:contactImg];
    }
    else if (indexPath.row == 2)
    {
        phoneField = [[UITextField alloc]initWithFrame:CGRectMake(40, 12, SCREEN_WIDTH-50, 20)];
        phoneField.placeholder = @"请填写联系电话";
        phoneField.delegate = self;
        phoneField.font = Default_Font_15;
        phoneField.text = [self.dataSource objectForKey:@"phone"];
        [cell.contentView addSubview:phoneField];
        
        UIImageView * phoneImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 12, 20, 20)];
        phoneImg.image = [UIImage imageNamed:@"tel1-1-0"];
        [cell.contentView addSubview:phoneImg];
    }
    else if (indexPath.row == 3)
    {
        UILabel * label  = [[UILabel alloc]initWithFrame:CGRectMake(20, 30, SCREEN_WIDTH-40, 30)];
        label.text = @"请上传个人名片、公司营业执照";
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor hexChangeFloat:KBlackColor];
        label.font = Default_Font_18;
        [cell.contentView addSubview:label];
        
        UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, 79.5, 40, 0.5)];
        line.backgroundColor = [UIColor hexChangeFloat:KHuiseColor];
        line.alpha = 0.5;
        [cell.contentView addSubview:line];
    }
    else if (indexPath.row == 4)
    {
        UILabel * personLab = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, SCREEN_WIDTH/2-40, 20)];
        personLab.text = @"请上传个人名片照片";
        personLab.textAlignment = NSTextAlignmentCenter;
        personLab.textColor = [UIColor hexChangeFloat:KHuiseColor];
        personLab.font = Default_Font_13;
        [cell.contentView addSubview:personLab];
        
        UILabel * companyLab = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2+20, 10, SCREEN_WIDTH/2-40, 20)];
        companyLab.text = @"请上传营业执照照片";
        companyLab.textAlignment = NSTextAlignmentCenter;
        companyLab.textColor = [UIColor hexChangeFloat:KHuiseColor];
        companyLab.font = Default_Font_13;
        [cell.contentView addSubview:companyLab];
        
        personImg = [[UIImageView alloc]initWithFrame:CGRectMake(20, 40, SCREEN_WIDTH/2-40, 90)];
        personImg.image = [UIImage imageNamed:@"idcard2.jpg"];
        UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClickToUploadPersonImg:)];
        personImg.userInteractionEnabled = YES;
        personImg.backgroundColor = [UIColor grayColor];
        [personImg addGestureRecognizer:tap1];
        personImg.tag = 999;
        [cell.contentView addSubview:personImg];
        
        companyImg = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2+20,40, SCREEN_WIDTH/2-40, 90)];
        companyImg.image = [UIImage imageNamed:@"zhizhao2.jpg"];
        companyImg.userInteractionEnabled = YES;
        companyImg.backgroundColor = [UIColor grayColor];
        UITapGestureRecognizer * tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClickToUploadPersonImg:)];
        [companyImg addGestureRecognizer:tap2];
        companyImg.tag = 888;
        [cell.contentView addSubview:companyImg];
        
        uploadImg1 = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH/2-40-30)/2, 30, 30, 30)];
        uploadImg1.image = [UIImage imageNamed:@"upload1-1"];
        [personImg addSubview:uploadImg1];
        uploadImg2 = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH/2-40-30)/2, 30, 30, 30)];
        uploadImg2.image = [UIImage imageNamed:@"upload1-1"];
        [companyImg addSubview:uploadImg2];

        UIView * line = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2, 10, 0.5, 130)];
        line.alpha = 0.5;
        line.backgroundColor = [UIColor hexChangeFloat:KHuiseColor];
        [cell.contentView addSubview:line];
        UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 149.5, 40, 0.5)];
        line1.backgroundColor = [UIColor hexChangeFloat:KHuiseColor];
        line1.alpha = 0.5;
        [cell.contentView addSubview:line1];
    }
    else if (indexPath.row == 5)
    {
        
        UIButton * submitBtn = [[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-300)/2, 20, 300, 40)];
        [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
        [submitBtn addTarget:self action:@selector(submitComplete:) forControlEvents:UIControlEventTouchUpInside];
        submitBtn.layer.cornerRadius = 5.0f;
        submitBtn.layer.masksToBounds = YES;
        submitBtn.backgroundColor = [UIColor colorWithRed:0/255.0f green:175/255.0f blue:240/255.0f alpha:1];
        [cell.contentView addSubview:submitBtn];
        
//        UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0,79.5, SCREEN_WIDTH, 0.5)];
//        line.backgroundColor = [UIColor hexChangeFloat:KHuiseColor];
//        line.alpha = 0.5;
//        [cell.contentView addSubview:line];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

//提交
-(void)submitComplete:(UIButton*)sender
{
    
    NSString * personStr;
    NSString * companyStr;

    if (orgField.text.length == 0 )
    {
        [self.view makeToast:@"请填写机构名"];
        return;
    }
    if (contactField.text.length == 0)
    {
            [self.view makeToast:@"请填写联系人"];
            return;
    }
    if (phoneField.text.length == 0 )
    {
        [self.view makeToast:@"手机号码输入错误"];
        return;
    }
    
    if (self.dataArr.count < 1)
    {
     
        [self.view makeToast:@"请上传个人名片"];
       
    }
    else if (self.dataArr.count == 1)
    {
        [self.view makeToast:@"请上传营业执照"];
        
    }
    else if ([self.dataArr count] > 1)
    {
      personStr  = [self.dataArr firstObject];
      companyStr  = [self.dataArr lastObject];
    
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"phoneNumber"] != nil)
    {
        self.phone = [[NSUserDefaults standardUserDefaults] valueForKey:@"phoneNumber"];
    }
    else
    {
        self.phone = [[NSUserDefaults standardUserDefaults] valueForKey:@"currentPhone"];
    }
//    NSLog(@"dict = %@-%@-%@-%@",self.phone,self.realName,personStr,companyStr);
     NSDictionary* dict = @{@"userphone":self.phone,
                           @"name" :self.realName,
                           @"orgmname" :contactField.text,
                           @"phone" :phoneField.text,
                           @"jigouname":orgField.text,
                           @"yinyezhizhao":personStr,
                           @"gerenmingpian":companyStr
                           };
  
    RequestInterface* requestOP = [[RequestInterface alloc]init];
    [requestOP requestApplyOrgCode:dict];
    [requestOP getInterfaceRequestObject:^(id data){
        
        if ([[data objectForKey:@"success"] boolValue])
        {
            NSLog(@"%@",data);
            
            if (!self.isBinding)
            {
                [self.view makeToast:@"申请成功，稍后我们将以短信的形式给您发送机构码" duration:1.0 position:@"center" ];
                [self requestLogin];
            }
            else
            {
                [self.view makeToast:@"申请成功，稍后我们将以短信的形式给您发送机构码" duration:0.5 position:@"center"];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.view Loading_0314];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self.view Hidden];
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    });
                });
            }
        }
        else
        {
            [self.view makeToast:data[@"message"]];
        }
    } Fail:^(NSError *error){
        [self.view hideProgressView];
        [self.view makeToast:HintWithNetError];
    }];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    for (UITextField * text in cell.contentView.subviews)
    {
        [text becomeFirstResponder];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(void)tapClickToUploadPersonImg:(UITapGestureRecognizer*)tap
{

    
//    UIActionSheet *actionSheet = [[UIActionSheet alloc]
//                                  initWithTitle:@"上传"
//                                  delegate:self
//                                  cancelButtonTitle:@"取消"
//                                  destructiveButtonTitle:nil
//                                  otherButtonTitles:@"拍照",@"相册",nil];
//    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
//    actionSheet.tag = 800;
//    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    
    tapTag = [NSString stringWithFormat:@"%ld",tap.view.tag];
    
    
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets) {
        
    }];
    
        [self presentViewController:imagePickerVc animated:YES completion:nil];
   
    
    
}
#pragma mark TZImagePickerControllerDelegate

/// User click cancel button
/// 用户点击了取消
- (void)imagePickerControllerDidCancel:(TZImagePickerController *)picker
{
    // NSLog(@"cancel");
}



/// User finish picking photo，if assets are not empty, user picking original photo.
/// 用户选择好了图片，如果assets非空，则用户选择了原图。
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets{
    
//    [selectedPhotos addObjectsFromArray:photos];
    
    if ([tapTag isEqualToString:@"999"])
    {
//        personImg.image =[selectedPhotos firstObject];
        personImg.image = [photos firstObject];
        uploadImg1.hidden = YES;
    }else if ([tapTag isEqualToString:@"888"])
    {
//        companyImg.image = [selectedPhotos lastObject];
        companyImg.image = [photos firstObject];
        uploadImg2.hidden = YES;
 
    }
   [self.view Loading_0314];
    UIImage * image = [photos firstObject] ;
    CGFloat w = image.size.width;
    CGFloat h = image.size.height;
    
   UIImage *  image1 = [self ImageWithImageSimple:image  ScaledToSize:CGSizeMake(w/4, h/4)];
    RequestInterface *requestOp = [[RequestInterface alloc] init];
    [requestOp requestUploadPersonImgWithImage:image1];
    [requestOp getInterfaceRequestObject:^(id data) {
        
        if ([data[@"success"] boolValue ])
        {
            [self.view Hidden];
            NSLog(@"data1 = %@",data);
            [self.dataArr addObject:data[@"datas"]];
        }
    }
    Fail:^(NSError *error)
    {
        NSLog(@"error= %@",error);
        [self.view Hidden];
        [self.view makeToast:HintWithNetError];
    }];

}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
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
//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
//{
//    //获得编辑过的图片
//    UIImage *image = [info objectForKey: @"UIImagePickerControllerOriginalImage"];
//    image = [self ImageWithImageSimple:image ScaledToSize:CGSizeMake(400, 400)];
//    
//    [arrImg addObject:image];
//    if ([arrImg count] ==1)
//    {
//        personImg.image = [arrImg firstObject];
//        uploadImg1.hidden = YES;
//    }else if ([arrImg count ] == 2)
//    {
//        companyImg.image = [arrImg lastObject];
//        personImg.image = [arrImg firstObject];
//         uploadImg2.hidden = YES;
//    }
//    
//    RequestInterface *requestOp = [[RequestInterface alloc] init];
//    [requestOp requestUploadPersonImgWithImage:image];
//    [requestOp getInterfaceRequestObject:^(id data) {
//        
//        if ([data[@"success"] boolValue ])
//        {
//            NSLog(@"%@",data);
//            [self.dataArr addObject:data[@"datas"]];
//            
//        }
//        
//    } Fail:^(NSError *error) {
//        [self.view makeToast:HintWithNetError];
//    }];
//    
//    [self dismissViewControllerAnimated:YES completion:nil];
//}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == orgField)
    {
        [self.dataSource setObject:orgField.text forKey:@"org"];
        
    }
    if (textField == contactField)
    {
        [self.dataSource setObject:contactField.text forKey:@"contact"];
    }
    if (textField == phoneField)
    {
        [self.dataSource setObject:phoneField.text forKey:@"phone"];
    }
    
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
     NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (textField == phoneField)
    {
        if (toBeString.length > 11)
        {
            textField.text = [toBeString substringToIndex:11];
            return NO;
        }
    }

    return YES;
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
//- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
//{
//    
//    [self dismissViewControllerAnimated:YES completion:nil];
//    
//}
//登录
- (void)requestLogin
{
    
    NSDictionary *dict = @{
                           @"userName":self.phone,
                           @"userPwd":self.passWordNum,
                           @"registrationID":[APService registrationID],
                           @"loginOrigin":CGLOBAL_LOGIN_ORIGIN,
                           @"versionCode":[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]
                           };
    
    [self.view makeProgressViewWithTitle:@"正在登录"];
    RequestInterface *requestOp = [[RequestInterface alloc] init];
    [requestOp requestLoginWithParam:dict];
    
    [requestOp getInterfaceRequestObject:^(id data) {
        [ProjectUtil showLog:@"data = %@",data];
        
        [self.view hideProgressView];
        if ([[data objectForKey:@"success"] boolValue]) {
            
            [MobClick profileSignInWithPUID:self.phone];
            dispatch_async(dispatch_get_main_queue(), ^{
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                if ([data objectForKey:@"token"]) {
                    [defaults setObject:[data objectForKey:@"token"] forKey:@"Login_User_token"];//账户ID
                    
                }
                //登录的用户id
                if ([[data objectForKey:@"datas"] objectForKey:@"id"]) {
                    [defaults setObject:data[@"datas"][@"id"] forKey:@"loginuid"];
                }
                
                if ([[data objectForKey:@"datas"] objectForKey:@"recomdCode"] ) {
                    [defaults setObject:[[data objectForKey:@"datas"] objectForKey:@"recomdCode"] forKey:@"zhipu_recomd_code"];//邀请码
                }
                
                if ([[data objectForKey:@"datas"]objectForKey:@"name"]==[NSNull null]||[[data objectForKey:@"datas"]objectForKey:@"name"]==nil) {
                    
                    
                }else{
                    
                    [defaults setObject:[[data objectForKey:@"datas"]objectForKey:@"name"] forKey:@"name"];
                }
                
                
                if ([[data objectForKey:@"datas"]objectForKey:@"sex"]) {
                    [defaults setObject:[[data objectForKey:@"datas"]objectForKey:@"sex"] forKey:@"sex"];
                }
                
//                NSLog(@"login = %@",data);
                if ([[data objectForKey:@"datas"] objectForKey:@"orgType"])
                {
                    NSString * str = [NSString stringWithFormat:@"%@",[[data objectForKey:@"datas"] objectForKey:@"orgType"]];
                    [defaults setObject:str forKey:@"orgType"];
                }
                
                if ([[data objectForKey:@"datas"]objectForKey:@"orgName"]) {
                    [defaults setObject:[[data objectForKey:@"datas"]objectForKey:@"orgName"] forKey:@"orgName"];
                }
                if ([[data objectForKey:@"datas"]objectForKey:@"orgCode"] != [NSNull null] && [[data objectForKey:@"datas"]objectForKey:@"orgCode"] != nil)
                {
                    [defaults setObject:[[data objectForKey:@"datas"]objectForKey:@"orgCode"] forKey:@"orgCode"];
                }
                if (self.phone)
                {
                    [defaults setObject:self.phone forKey:@"Login_User_Account"];
                    
                }
                if ([[data objectForKey:@"datas"]objectForKey:@"face"]==[NSNull null]||[[data objectForKey:@"datas"]objectForKey:@"face"]==nil) {
//                    [defaults setObject:@"销邦-我的-头像.png"forKey:@"login_User_face"];//头像]
                    [defaults setObject:nil forKey:@"login_User_face"];
                }
                else
                {
                    [defaults setObject:[[data objectForKey:@"datas"] objectForKey:@"face"] forKey:@"login_User_face"];//头像
                }
                
                if (self.phone)
                {
                    [defaults setObject:self.phone forKey:@"login_User_name"];//用户名
                }
                [defaults synchronize];
                [ProjectUtil showLog:@"---------------------------------token:%@",data[@"token"]];
                
                [defaults setObject:[[data objectForKey:@"datas"] objectForKey:@"id"]  forKey:@"id"];
                
                //登录融云
                [self requestToken:[[data objectForKey:@"datas"] objectForKey:@"id"]];
                
                
                self.navigationController.navigationBarHidden = NO;
                 [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            });
            
        }else {
            [self.view makeToast:data[@"message"]];
        }
        
    } Fail:^(NSError *error) {
        [self.view hideProgressView];
        [self.view makeToast:HintWithNetError];
    }];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
//使列表的分割线顶格开始
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 40, 0, 0)];
    }
    
    if (IOS_VERSION >= 8.0)
    {
        if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)])
        {
            [cell setPreservesSuperviewLayoutMargins:NO];
        }
        if ([cell respondsToSelector:@selector(setLayoutMargins:)])
        {
            [cell setLayoutMargins:UIEdgeInsetsMake(0, 40, 0, 0)];
        }
    }
}


#pragma mark - 融云Token
- (void)requestToken:(NSString *)longinuid
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *parame = [NSMutableDictionary dictionary];
    parame[@"loginuid"] = longinuid;
    NSString *url = [NSString stringWithFormat:@"%@/index.php/Apis/Forum/getTokenid/",BANGHUI_URL];
    [manager POST:url parameters:parame
          success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if ([responseObject[@"success"] boolValue] == YES)
         {
             NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
             [defaults setObject:responseObject[@"datas"] forKey:@"RCIMToken"];
             [[RCIM sharedRCIM] connectWithToken:responseObject[@"datas"] success:^(NSString *userId)
              {
                  NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
                  [[RCIM sharedRCIM] setUserInfoDataSource:self];
              } error:^(RCConnectErrorCode status)
              {
                  NSLog(@"登陆的错误码为:%ld", (long)status);
              } tokenIncorrect:^{
                  NSLog(@"token错误");
              }];
             
         }
         else
         {
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
         NSString *token = [defaults objectForKey:@"RCIMToken"];
         [[RCIM sharedRCIM] connectWithToken:token success:^(NSString *userId)
          {
              
              [[RCIM sharedRCIM] setUserInfoDataSource:self];
              NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
          } error:^(RCConnectErrorCode status)
          {
              NSLog(@"登陆的错误码为:%ld", (long)status);
          } tokenIncorrect:^{
              NSLog(@"token错误");
          }];
         
     }];
    
}

- (void)getUserInfoWithUserId:(NSString *)userId
                   completion:(void (^)(RCUserInfo *userInfo))completion
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    RequestInterface *interface = [[RequestInterface alloc]init];
    NSDictionary *dic = @{
                          @"getuid":userId,
                          @"loginuid":[defaults objectForKey:@"id"]
                          };
    [interface requestBHPersonalCenterWithDic:dic];
    [interface getInterfaceRequestObject:^(id data)
     {
         
         
         if ([data[@"success"] boolValue] == YES)
         {
             
             NSDictionary *dict = data[@"datas"];
             
             RCUserInfo *userInfo = [[RCUserInfo alloc] init];
             
             userInfo.userId = userId;
             
             userInfo.name = dict[@"name"];
             
             userInfo.portraitUri = dict[@"iconPath"];
             
             return completion(userInfo);
             
             
             
             
             
             
         }
     } Fail:^(NSError *error)
     {
         
     }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
