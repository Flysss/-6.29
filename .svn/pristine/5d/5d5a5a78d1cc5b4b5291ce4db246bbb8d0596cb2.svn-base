//
//  AddClientViewController.m
//  SalesHelper_A
//
//  Created by summer on 15/11/3.
//  Copyright © 2015年 X. All rights reserved.
//

#import "AddClientViewController.h"
#import <AddressBookUI/AddressBookUI.h>
#import "UIImageView+WebCache.h"

@interface AddClientViewController ()<UITableViewDataSource, UITableViewDelegate,ABPeoplePickerNavigationControllerDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate,UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

@end

@implementation AddClientViewController
{
    UITextField * nameTextField;
    UITextField * phoneTextField;
    UISegmentedControl * sexSegment;
    UIImageView * headFaceView;
    NSString * imageUrl;
    UILabel * levelLabel;
    UITextView  * textView;
    UIView * holdView;
    UITextField * ageTextField;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden  = YES;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self CreateCustomNavigtionBarWith:self leftItem:@selector(backlastView) rightItem:nil];
    //创建标题
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-120)/2, 27, 120, 30)];
    titleLabel.text = @"新增客户";
    titleLabel.font = Default_Font_20;
    [titleLabel setTextColor:[UIColor whiteColor]];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.topView addSubview: titleLabel];
    
}
- (void)backlastView
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    switch (section)
    {
        case 0:
            return 1;
            break;
        case 1:
            return 2;
            break;
        case 2:
            return 3;
            break;
        case 3:
            return 1;
            break;
            
        default:
            return 0;
            break;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return 50;
            break;
        case 1:
            return 50;
            break;
        case 2:
            if (indexPath.row == 0) {
                return 71;
            }else
            {
                return 50;
            }
            break;
        case 3:
            return 180;
            break;
        default:
            return 1;
            break;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * idefi = [NSString stringWithFormat:@"cell%ld%ld",(long)indexPath.section,(long)indexPath.row];
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:idefi];
    
    if(indexPath.section == 1 && indexPath.row == 0)
    {
        nameTextField = (UITextField *)[cell viewWithTag:10];
    }
    if(indexPath.section == 1 && indexPath.row == 1)
    {
        phoneTextField = (UITextField *)[cell viewWithTag:11];
    }
    if(indexPath.section == 1 && indexPath.row == 0)
    {
        sexSegment = (UISegmentedControl *)[cell viewWithTag:101];
        sexSegment.tintColor = [ProjectUtil colorWithHexString:@"00aff0"];
        sexSegment.layer.cornerRadius = 20;
    }
    if (indexPath.section == 2 && indexPath.row  == 0) {
        headFaceView = (UIImageView *)[cell viewWithTag:20];
        headFaceView.layer.cornerRadius = 25;
    }
    if (indexPath.section == 2 && indexPath.row == 1) {
        levelLabel = (UILabel *)[cell viewWithTag:21];
    }
    if (indexPath.section == 2 && indexPath.row == 2) {
        ageTextField = (UITextField *)[cell viewWithTag:22];
    }
    if (indexPath.section == 3) {
        textView = (UITextView *)[cell viewWithTag:30];
        holdView = [cell viewWithTag:31];
        textView.delegate = self;
    }
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        ABPeoplePickerNavigationController * peopleNC = [[ABPeoplePickerNavigationController alloc] init];
        peopleNC.peoplePickerDelegate = self;
        [self.navigationController presentViewController:peopleNC animated:YES completion:nil];
    }
    if (indexPath.section == 2 && indexPath.row  == 0) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:@"修改头像"
                                      delegate:self
                                      cancelButtonTitle:@"取消"
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:@"拍照",@"相册",nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
        actionSheet.tag=800;
        [actionSheet showInView:[UIApplication sharedApplication].keyWindow];

//        [self changeUserImage];
    }
    if (indexPath.section == 2 && indexPath.row  == 1) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:@"客户等级"
                                      delegate:self
                                      cancelButtonTitle:@"取消"
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:@"A",@"B",@"C",@"D",@"E",nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
        actionSheet.tag=801;
        [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
    }
    if (indexPath.section == 2 && indexPath.row  == 2) {
        [ageTextField becomeFirstResponder];
    }

}

//- (void)changeUserImage
//{
//    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
//    
//    [picker setBk_didFinishPickingMediaBlock:^(UIImagePickerController *_picker, NSDictionary *_dic) {
//        UIImage *img=[_dic objectForKey:@"UIImagePickerControllerEditedImage"];
//        
//        CGSize size=CGSizeMake(400, 400);
//        UIGraphicsBeginImageContext(size);
//        [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
//        UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
//        NSData *imgdata = [NSData dataWithData:UIImageJPEGRepresentation(scaledImage, 1.0)];
//        
//        
//        [RequestHelper uploadImgPath:url params:dic ImageData:imgdata ImgName:@"usericon" FileType:nil completeBlock:^(NSError *err, id object) {
//            
//            NSLog(@"%@", object);
//            
//            [self hidenHUBWaiting:self.view Animation:YES];
//            if (object!=nil) {
//                NSDictionary *dic=object;
//                //                NSLog(@"%@",dic[@"message"]);
//                
//                if ([dic[@"success"] boolValue]==YES) {
//                    [self HUDShowWithTextOnly:@"上传成功"];
//                    
//                    userImage.image = img;
//                    
////                    NSNotification *notification = [NSNotification notificationWithName:@"shangchuan" object:nil];
////                    [[NSNotificationCenter defaultCenter] postNotification:notification];
//                }
//                else
//                {
//                    [self HUDShowWithTextOnly:@"上传失败"];
//                }
//            }
//            else
//            {
//                
//            }
//            
//        }];
//        
//        [_picker dismissViewControllerAnimated:YES completion:nil];
//    }];
//    [picker setBk_didCancelBlock:^(UIImagePickerController *_picker) {
//        [_picker dismissViewControllerAnimated:YES completion:nil];
//    }];
//    
//    picker.allowsEditing=YES;
//    
//    UIActionSheet *actionsheet=[UIActionSheet bk_actionSheetWithTitle:nil];
//    
//    [actionsheet bk_addButtonWithTitle:@"从相册选取" handler:^{
//        NSLog(@"相册");
//        
//        
//        picker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
//        [self presentViewController:picker animated:YES completion:nil];
//        
//    }];
//    [actionsheet bk_addButtonWithTitle:@"用相机拍摄" handler:^{
//        NSLog(@"相机");
//        
//        picker.sourceType=UIImagePickerControllerSourceTypeCamera;
//        [self presentViewController:picker animated:YES completion:nil];
//    }];
//    [actionsheet bk_setCancelButtonWithTitle:@"取消" handler:^{
//        NSLog(@"取消");
//    }];
//    [actionsheet showInView:self.navigationController.view];
//
//}





#pragma mark - ActionSheet 选择添加照片方式
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 800)
    {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        //拍照
        if (buttonIndex == 0)
        {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            }
            else
            {
                
                [ProjectUtil showAlert:@"提示" message:HintWithNoCamera];
                return;
            }
            
        }
        else if (buttonIndex == 1) {//相册
            
            imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            
        }
        else if(buttonIndex==2){//取消
            
            return;
        }
        
        imagePicker.allowsEditing = YES;
        imagePicker.delegate = self;
        [self presentViewController:imagePicker animated:YES completion:nil];

    }
    else
    {
        switch (buttonIndex)
        {
            case 0:
                levelLabel.text = @"A";
                break;
            case 1:
                levelLabel.text = @"B";
                break;
            case 2:
                levelLabel.text = @"C";
                break;
            case 3:
                levelLabel.text = @"D";
                break;
            case 4:
                levelLabel.text = @"E";
                break;
    
        }
    }
}

#pragma mark -- 保存提交
- (IBAction)saveInfo:(id)sender
{
    //点击保存，结束编辑状态
    [self.view endEditing:YES];
    
    if ([self checkContactInfo])
    {
        RequestInterface * interface = [[RequestInterface alloc] init];
        NSMutableDictionary * dict = [@{
                                @"token":self.login_user_token,
                                @"name":nameTextField.text,
                                @"phone":phoneTextField.text,
                                @"remarks":textView.text,
                                @"intention_rank":levelLabel.text ? levelLabel.text : @"",
                                @"face":imageUrl ? imageUrl : @"",
                                @"sex":[NSNumber numberWithInteger:sexSegment.selectedSegmentIndex],
                                
                                } mutableCopy];
        if (![ageTextField.text isEqualToString:@""]) {
//            [dict setObject:@"age" forKey:ageTextField.text];
            [dict setObject:ageTextField.text forKey:@"age"];
        }
        
//        NSLog(@"%@", dict);
        
        [interface addClientsWithInfos:dict];
        [interface getInterfaceRequestObject:^(id data) {
            if ([[data objectForKey:@"success"] boolValue])
            {
                [self.view makeToast:@"保存成功"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];

                });
                if (self.refreshBlock)
                {
                    self.refreshBlock();
                }
            }
            else
            {
                [self.view makeToast:data[@"message"]];
            }
        } Fail:^(NSError *error) {
            [self.view makeToast:@"网络错误"];
        }];
    }
    
}

//对输入的数据进行判断
- (BOOL)checkContactInfo
{
    if (nameTextField.text.length == 0)
    {
        [self.view makeToast:@"推荐人姓名不能为空"];
        return NO;
    }
    else if (phoneTextField.text.length == 0)
    {
        [self.view makeToast:@"手机号码不能为空"];
        return NO;
    }
    else if (![ProjectUtil isFuzzyPhone:phoneTextField.text])
    {
        [self.view makeToast:@"请输入正确的手机号码"];
        return NO;
    }
    else
    {
        return YES;
    }
}

#pragma mark -- ABPeoplePickerNavigationControllerDelegate

//打开通讯录后，点击取消的事件
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    [peoplePicker dismissViewControllerAnimated:YES completion:nil];
}

- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person{
    [self peopleSelected:person];
}
// Deprecated, use predicateForSelectionOfPerson and/or -peoplePickerNavigationController:didSelectPerson: instead.
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person{
    
    [self peopleSelected:person];
    
    [peoplePicker dismissViewControllerAnimated:YES completion:nil];
    
    return NO;
}

- (void)peopleSelected:(ABRecordRef)person{
    //    ABRecordRef contactPerson = (__bridge ABRecordRef)allContacts[i];
    // Get first and last names
    NSString *firstName = (__bridge_transfer NSString*)ABRecordCopyValue(person, kABPersonFirstNameProperty);
    NSString *midName = (__bridge_transfer NSString*)ABRecordCopyValue(person, kABPersonMiddleNameProperty);
    NSString *lastName = (__bridge_transfer NSString*)ABRecordCopyValue(person, kABPersonLastNameProperty);
    NSString *PrefixProperty = (__bridge_transfer NSString*)ABRecordCopyValue(person, kABPersonPrefixProperty);
    
    // Get mobile number
    ABMultiValueRef phonesRef = ABRecordCopyValue(person, kABPersonPhoneProperty);
    
//    NSLog(@"%@%@%@%@",firstName,lastName,midName,PrefixProperty);
    NSString *phoneStr = @"";

    phoneStr = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phonesRef, 0);
    if (phoneStr.length != 0) {
        for (int i = 1; i < ABMultiValueGetCount(phonesRef); i++) {
            NSString * phone = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phonesRef, i);
            if (phone) {
                phoneStr = phone;
            }
            
        }
    }
    
    
    NSString * name = @"";
    NSString * availablePhone = @"";
    if ((firstName != nil || lastName != nil)) {
        
        
        if(firstName != nil && lastName != nil) {
            name = [NSString stringWithFormat:@"%@%@", lastName,firstName];
        } else if (firstName != nil) {
            name = firstName;
        } else if (lastName != nil) {
            name =  lastName;
        }
        
        
        //将特殊的字符' 转为特殊符号存储
        name = [name stringByReplacingOccurrencesOfString:@"'" withString:@"|*||*|"];
        
        availablePhone = [phoneStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
        availablePhone = [availablePhone stringByReplacingOccurrencesOfString:@"+86" withString:@""];
        availablePhone = [availablePhone stringByReplacingOccurrencesOfString:@"(" withString:@""];
        availablePhone = [availablePhone stringByReplacingOccurrencesOfString:@")" withString:@""];
        availablePhone = [availablePhone stringByReplacingOccurrencesOfString:@" " withString:@""];
        availablePhone = [availablePhone stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        //        [self valueChanged_Name:clientName];
    }
    
    nameTextField.text = name;
    phoneTextField.text = availablePhone;
}

#pragma mark --imagePicker
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    //获得编辑过的图片
    UIImage *image = [info objectForKey: @"UIImagePickerControllerEditedImage"];
    image = [self ImageWithImageSimple:image ScaledToSize:CGSizeMake(100, 100)];
    headFaceView.image = image;
    // NSData * data_IMG = UIImageJPEGRepresentation(img, 1.0);
    
    //获得编辑过的图片UIImagePickerControllerEditedImage UIImagePickerControllerOriginalImage
    RequestInterface *requestOp = [[RequestInterface alloc] init];
    [requestOp requestUploadAvatarInterfaceWithImage:image token:self.login_user_token user_version:@"A"];
    [requestOp getInterfaceRequestObject:^(id data) {
        if ([[data objectForKey:@"success"] boolValue])
        {
            imageUrl = [data objectForKey:@"datas"];
            NSLog(@"选择图片的借口  %@", imageUrl);
            
        }
        else
        {
            [self.view makeToast:@"图片上传失败"];

        }
    } Fail:^(NSError *error) {
        [self.view makeToast:HintWithNetError];
    }];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
//压缩图片
- (UIImage*)ImageWithImageSimple:(UIImage*)image ScaledToSize:(CGSize)newSize{
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


#pragma UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    holdView.hidden = YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length == 0)
    {
        holdView.hidden = NO;
    }
}



- (void)refesh:(RefreshBlock)block
{
    self.refreshBlock = block;
}


#pragma mark --是列表的分割线左边紧贴边界
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    
    if (IOS_VERSION >= 8.0) {
        if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)])
        {
            [cell setPreservesSuperviewLayoutMargins:NO];
        }
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
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
