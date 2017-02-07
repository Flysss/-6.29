//
//  ClientsEditViewController.m
//  SalesHelper_A
//
//  Created by summer on 15/11/4.
//  Copyright © 2015年 X. All rights reserved.
//

#import "ClientsEditViewController.h"

@interface ClientsEditViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@end

@implementation ClientsEditViewController
{
    UIImageView * headImageView;
    UILabel * levelLabel;
    UITextField * nameLabel;
    UILabel * sexLabel;
    UITextView * myTextView;
    UIView * holdView;
    NSString * imgUrl;
    UITextField * ageTextField;
    UILabel *headBackLabel;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self CreateCustomNavigtionBarWith:self leftItem:@selector(backlastView) rightItem:@selector(saveInfo:)];
    //创建标题
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-120)/2, 27, 120, 30)];
    titleLabel.text = @"编辑客户";
    titleLabel.font = Default_Font_20;
    [titleLabel setTextColor:[UIColor whiteColor]];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.topView addSubview: titleLabel];
    [self.rightBtn setTitle:@"保存" forState:UIControlStateNormal];
    [self.rightBtn setImage:nil forState:UIControlStateNormal];
    self.rightBtn.tintColor = [UIColor whiteColor];
   
}

- (void)backlastView
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            if (indexPath.row == 0) {
                return 70;
            }else
            {
                return 50;
            }
            break;
        case 1:
            return 55;
            break;
        case 2:
            return 140;
            break;
        default:
            return 1;
            break;
    }

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 2;
            break;
        case 1:
            return 3;
            break;
        case 2:
            return 1;
            break;
        default:
            return 0;
            break;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * cellid = [NSString stringWithFormat:@"cell%ld%ld",(long)indexPath.section,(long)indexPath.row];
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if(indexPath.section == 0 && indexPath.row == 0)
    {
        headImageView = (UIImageView *)[cell viewWithTag:10];
        headImageView.layer.cornerRadius = 25;
        headImageView.layer.masksToBounds = YES;
        
        headBackLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        headBackLabel.layer.cornerRadius = 25;
        headBackLabel.clipsToBounds = YES;
        headBackLabel.text = [[_custmorData objectForKey:@"name"] substringToIndex:1];
        headBackLabel.textColor = [UIColor whiteColor];
        headBackLabel.font = [UIFont systemFontOfSize:19];
        headBackLabel.backgroundColor = [ProjectUtil colorWithHexString:[ProjectUtil makeColorStringWithNameStr:[_custmorData objectForKey:@"name"]]];
        headBackLabel.textAlignment = NSTextAlignmentCenter;
        headBackLabel.hidden = YES;
        [headImageView addSubview:headBackLabel];
        
        if ([_custmorData objectForKey:@"face"] != nil &&
            [_custmorData objectForKey:@"face"] != [NSNull null] &&
            ![[_custmorData objectForKey:@"face"] isEqualToString:@""] &&
            ![[_custmorData objectForKey:@"face"] isEqualToString:@"<null>"]
            )
        {
            headBackLabel.hidden = YES;
            [headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",Image_Url, [_custmorData objectForKey:@"face"]]] placeholderImage:[UIImage imageNamed:@"客户-客户管理.png"]];
        }
        else
        {
            headBackLabel.hidden = NO;
        }
    }

    if(indexPath.section == 0 && indexPath.row == 1)
    {
        levelLabel = (UILabel *)[cell viewWithTag:11];
        if ([_custmorData objectForKey:@"intention_rank"] != nil || [_custmorData objectForKey:@"intention_rank"] != [NSNull null] || [_custmorData objectForKey:@"intention_rank"])
        {
            levelLabel.text = [_custmorData objectForKey:@"intention_rank"];
        }
        else
        {
            levelLabel.hidden = YES;
        }
        levelLabel.layer.borderWidth = 0.5;
        levelLabel.layer.cornerRadius = 2;
        levelLabel.layer.borderColor = [ProjectUtil colorWithHexString:@"EF5F5F"].CGColor;
    }
    if(indexPath.section == 1 && indexPath.row == 0)
    {
        nameLabel = (UITextField *)[cell viewWithTag:20];
        nameLabel.text = [_custmorData objectForKey:@"name"];
    }else  if(indexPath.section == 1 && indexPath.row == 1){
        sexLabel = (UILabel *)[cell viewWithTag:21];
        NSString * str =  [[_custmorData objectForKey:@"sex"] boolValue] ? @"女" : @"男";
        sexLabel.text = [NSString stringWithFormat:@"%@",str];
    }else if(indexPath.section == 1 && indexPath.row == 2)
    {
        ageTextField = (UITextField *)[cell viewWithTag:22];
        if ([_custmorData objectForKey:@"age"] != nil && [_custmorData objectForKey:@"age"] != [NSNull null]) {
            ageTextField.text = [_custmorData objectForKey:@"age"];
        }else
        {
            ageTextField.placeholder = @"未填写";
        }
    }
    if (indexPath.section == 2) {
        myTextView = (UITextView *)[cell viewWithTag:30];
//        NSString * str = [_custmorData objectForKey:@"remarks"];
        holdView = [cell viewWithTag:31];
        NSLog(@"%@", _custmorData);
        if ([_custmorData objectForKey:@"remarks"] == nil ||
            [_custmorData objectForKey:@"remarks"] == [NSNull null] ||
            [[_custmorData objectForKey:@"remarks"] isEqualToString:@""])
        {
            holdView.hidden = NO;
        }
        else
        {
            myTextView.text = [_custmorData objectForKey:@"remarks"];
            holdView.hidden = YES;
        }
        myTextView.delegate = self;
    }
    
    return  cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0 && indexPath.row == 0)
    {
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:@"修改头像"
                                      delegate:self
                                      cancelButtonTitle:@"取消"
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:@"拍照",@"相册",nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
        actionSheet.tag=800;
        [actionSheet showInView:[UIApplication sharedApplication].keyWindow];

    }
    if (indexPath.section == 0 && indexPath.row == 1)
    {
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
    if (indexPath.section == 1 && indexPath.row == 0)
    {
        [nameLabel becomeFirstResponder];
    }
    if (indexPath.section == 1 && indexPath.row == 1)
    {
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:@"客户性别"
                                      delegate:self
                                      cancelButtonTitle:@"取消"
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:@"男",@"女",nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
        actionSheet.tag=802;
        [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
    }
    if (indexPath.section == 1 && indexPath.row == 2)
    {
        [ageTextField becomeFirstResponder];
    }
}

#pragma mark -- UITextViewDelegate
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


#pragma mark --imagePicker
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    headBackLabel.hidden = YES;
    
    //获得编辑过的图片
    UIImage *image = [info objectForKey: @"UIImagePickerControllerEditedImage"];
    image = [self ImageWithImageSimple:image ScaledToSize:CGSizeMake(100, 100)];
    headImageView.image = image;
    // NSData * data_IMG = UIImageJPEGRepresentation(img, 1.0);
    
    //获得编辑过的图片UIImagePickerControllerEditedImage UIImagePickerControllerOriginalImage
    RequestInterface *requestOp = [[RequestInterface alloc] init];
    [requestOp requestUploadAvatarInterfaceWithImage:image token:self.login_user_token user_version:@"A"];
    [self.view Loading_0314];
    [requestOp getInterfaceRequestObject:^(id data) {
        if ([[data objectForKey:@"success"] boolValue])
        {
            [self.view Hidden];
            NSLog(@"\n%@", data);

            imgUrl = [data objectForKey:@"datas"];
        }
        else
        {
            [self.view makeToast:@"图片上传失败"];
            [self.view Hidden];

        }
    } Fail:^(NSError *error) {
        [self.view makeToast:HintWithNetError];
        [self.view Hidden];
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

#pragma mark -- 保存提交
- (IBAction)saveInfo:(id)sender {
    
    [self.view endEditing:YES];
    
    [self.view Loading_0314];
    
    RequestInterface * interface = [[RequestInterface alloc]init];
    NSNumber * sexNum ;
    if ([sexLabel.text isEqualToString:@"男"])
    {
        sexNum = @0;
    }else
    {
        sexNum = @1;
    }
    
    NSDictionary * dict = @{
                                @"id":[_custmorData objectForKey:@"id"],
                                @"name":nameLabel.text,
                                @"remarks":myTextView.text,
                                @"intention_rank":levelLabel.text ? levelLabel.text : @"",
                                @"face":imgUrl ? imgUrl : [_custmorData objectForKey:@"face"],
                                @"sex":sexNum,
                                @"age":ageTextField.text ? ageTextField.text : @"",
                                @"phone":[_custmorData objectForKey:@"phone"],
                            };
    [interface requestEditClientsWithInfos:dict];
    
    NSLog(@"%@", dict);
    [interface getInterfaceRequestObject:^(id data) {
        
        [self.view Hidden];
        if ([[data objectForKey:@"success"] boolValue])
        {
            [self.view makeToast:@"修改成功"];
           
            if (self.refreshBlock)
            {
                self.refreshBlock(dict);
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
            
        }
        else
        {
            [self.view makeToast:[data objectForKey:@"message"]];
        }
    } Fail:^(NSError *error) {
        [self.view makeToast:@"网络错误"];
    }];
}

- (void)refesh:(RefreshBlock)block
{
    self.refreshBlock = block;
}


#pragma mark -- UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 800)
    {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        if (buttonIndex == 0) {//拍照
        
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
            
        }else if(buttonIndex==2){//取消
            
            return;
        }
        
        imagePicker.allowsEditing = YES;
        imagePicker.delegate = self;
        [self presentViewController:imagePicker animated:YES completion:nil];
        
    }
    else if(actionSheet.tag == 801)
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
    else
    {
        switch (buttonIndex)
        {
            case 0:
                sexLabel.text = @"男";
                break;
            case 1:
                sexLabel.text = @"女";
                break;
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
