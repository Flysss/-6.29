
//
//  VisitInfoViewController.m
//  SalesHelper_A
//
//  Created by Brant on 16/1/12.
//  Copyright (c) 2016年 X. All rights reserved.
//

#import "VisitInfoViewController.h"
#import "ChoosenHouseViewController.h"
#import "IQKeyboardManager.h"

@interface VisitInfoViewController () <UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITextFieldDelegate,UITextViewDelegate>

@property (nonatomic, strong) UITableView *m_tablebView;

@property (nonatomic, strong) UITextField * dongField;

@property (nonatomic, strong) UITextField * danyuanField;

@property (nonatomic, strong) UITextField * shiField;

@property (nonatomic, strong) UIView * popView;

@property (nonatomic, strong) UIControl * bgControl;

@end

@implementation VisitInfoViewController
{
    UIDatePicker * datePicker;
    UILabel * selectTimeLabel;
    UIControl *control;
//    UITextField *nameTextField;
    UIView *whiteView;
    
    UITextView *m_textView;
    UILabel *placeLabel;
    NSMutableArray *picArray;
    
    UIButton *addPicBtn;
    UIScrollView *scrollView;
    UILabel * selectHouseLab;
    NSInteger visitTime;
    
    
    UITextField * priceField;
    UITextView * priceTextView;
    
    
    //房源id
    NSString * houseSourceID;
    //成交总价
    NSString * dealMoney;
    //签约房源
    NSString * signHouseResource;
    //房源名称
    NSString * houseName;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    picArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;
    
    
//    [self requestSignHouseResource];
    
    [self creatNaviControl];
    
    [self creatTableView];
    
//    if (self.selectDic[@"roomnumber"] != [NSNull null] &&
//        self.selectDic[@"roomnumber"] != nil &&
//        self.selectDic[@"roomnumber"])
//    {
//        [self requestSignHouseResource];
//    }
//   
}

#pragma mark --设置导航栏
- (void)creatNaviControl
{
    [self CreateCustomNavigtionBarWith:self leftItem:@selector(popTopView) rightItem:nil];
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-120)/2, 27, 120, 30)];
    titleLabel.text = @"申请信息";
    titleLabel.font = Default_Font_20;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [titleLabel setTextColor:[UIColor whiteColor]];
    [self.topView addSubview: titleLabel];
    
  }
- (void)popTopView
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)creatTableView
{
    _m_tablebView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStyleGrouped];
    _m_tablebView.delegate = self;
    _m_tablebView.dataSource = self;
    _m_tablebView.tableFooterView = [[UIView alloc] init];
    _m_tablebView.backgroundColor = [UIColor hexChangeFloat:@"f2f2f2"];
    [self.view addSubview:_m_tablebView];
    
}

//申请签约时有认购房源时请求房源
-(void)requestSignHouseResource
{
    RequestInterface * interface = [[RequestInterface alloc]init];
    [interface requestApplyClientSignHouseResourceWithParam:@{@"id":self.selectDic[@"roomnumber"]}];
    
    [interface getInterfaceRequestObject:^(id data) {
        
        if ([[data objectForKey:@"success"] boolValue])
        {
            NSLog(@"data = %@",data);
            signHouseResource = [NSString stringWithFormat:@"%@ %@栋%@单元%@室",[data[@"data"] objectForKey:@"topic"],[data[@"data"] objectForKey:@"lnum"],[data[@"data"] objectForKey:@"danYuan"],[data[@"data"] objectForKey:@"num"]];
        
        }
        [_m_tablebView reloadData];
        
    } Fail:^(NSError *error) {
        
    }];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 75;
    } else if (indexPath.section == 1)
    {
        return 45;
    }
    else if (indexPath.section == 2)
    {
        if (indexPath.row == 0)
        {
            return 45;
        } else {
            return 85;
        }
    }
    else
    {
        return 125;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    else if(section == 1)
    {
        if (self.selectType == 2)
        {
            return 3;
        }
        else if (self.selectType == 3)
        {
            return 4;
        }
        else
        {
        return 2;
        }
    }
    else if (section == 2)
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"cell%@", indexPath]];
    }
//    NSLog(@"==%@",self.selectDic);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0)
    {
        //姓名
        NSString *nameStr = self.selectDic[@"name"];
        CGFloat nameW = [nameStr boundingRectWithSize:CGSizeMake(0, 20) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:Default_Font_16} context:nil].size.width;
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 13, nameW, 20)];
        nameLabel.textColor = [UIColor hexChangeFloat:KBlackColor];
        nameLabel.font = Default_Font_16;
        nameLabel.text = nameStr;
        [cell.contentView addSubview:nameLabel];
        
        //号码
        UILabel *phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(nameLabel.frame)+10, CGRectGetMinY(nameLabel.frame), 120, 20)];
        phoneLabel.font = Default_Font_14;
        phoneLabel.textColor = [UIColor hexChangeFloat:KGrayColor];
        phoneLabel.text = self.selectDic[@"phone"];
        [cell.contentView addSubview:phoneLabel];
        
        //地点
        UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(nameLabel.frame)+10, SCREEN_WIDTH-10-110, 20)];
        addressLabel.font = Default_Font_15;
        addressLabel.textColor = [UIColor hexChangeFloat:KGrayColor];
        addressLabel.text = self.selectDic[@"propertyName"];
        [cell.contentView addSubview:addressLabel];
        
        //状态
        UILabel *stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-100, CGRectGetMinY(nameLabel.frame), 90, 20)];
        stateLabel.font = Default_Font_15;
        stateLabel.textAlignment = NSTextAlignmentRight;
        if (self.selectDic[@"stepColor"] != nil &&
            self.selectDic[@"stepColor"] != [NSNull null] &&
             self.selectDic[@"stepColor"])
        {
            stateLabel.textColor = [UIColor hexChangeFloat:self.selectDic[@"stepColor"]];

        }
        stateLabel.text = self.selectDic[@"newStepName"];
        [cell.contentView addSubview:stateLabel];
        
        //时间
        UILabel * timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, CGRectGetMinY(addressLabel.frame), SCREEN_WIDTH/2-10, 20)];
        timeLabel.font = Default_Font_14;
        timeLabel.textAlignment = NSTextAlignmentRight;
        timeLabel.textColor = [UIColor hexChangeFloat:KGrayColor];
        timeLabel.text = self.selectDic[@"refereeDate"];
        [cell.contentView addSubview:timeLabel];
        
        
    }
    else if (indexPath.section == 1)
    {

        if (indexPath.row == 0)
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 13, 100, 20)];
            label.font = Default_Font_16;
            label.textColor = [UIColor hexChangeFloat:KGrayColor];
            if (self.selectType == 0)
            {
                label.text = @"到访时间";
            }
            else if (self.selectType == 1)
            {
                label.text = @"认筹时间";
            }
            else if (self.selectType == 2)
            {
                label.text = @"认购时间";
            }
            else
            {
                label.text = @"签约时间";
            }
            [cell.contentView addSubview:label];
            
//            selectTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 0, SCREEN_WIDTH-30-110, 45)];
//            selectTimeLabel.font = Default_Font_16;
//            selectTimeLabel.textColor = [UIColor hexChangeFloat:KBlackColor];
//            selectTimeLabel.textAlignment = NSTextAlignmentRight;
//            NSDateFormatter *dataFormater = [[NSDateFormatter alloc] init];
//            [dataFormater setDateFormat:@"yyyy-MM-dd HH:mm"];
//            selectTimeLabel.text = [dataFormater stringFromDate:[NSDate date]];
//            visitTime = [[NSDate date] timeIntervalSince1970];
//            [cell.contentView addSubview:selectTimeLabel];
            if (!selectTimeLabel)
            {
                selectTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 0, SCREEN_WIDTH-30-110, 45)];
                selectTimeLabel.font = Default_Font_15;
                selectTimeLabel.textColor = [UIColor hexChangeFloat:KBlackColor];
                selectTimeLabel.textAlignment = NSTextAlignmentRight;
                selectTimeLabel.text = @"请选择时间";
//                if (self.selectType == 0)
//                {
//                    selectTimeLabel.text = @"请选择到访时间";
//                }
//                else if (self.selectType == 1)
//                {
//                    selectTimeLabel.text = @"请选择认筹时间";
//                }
//                else if (self.selectType == 2)
//                {
//                    selectTimeLabel.text = @"请选择认购时间";
//                }
//                else
//                {
//                    selectTimeLabel.text = @"请选择签约时间";
//                }
                
                
            }
            [cell.contentView addSubview:selectTimeLabel];
        }
        else if (indexPath.row == 1)
        {
            
            if (self.selectType == 0 || self.selectType == 1)
            {
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 13, 100, 20)];
                label.font = Default_Font_16;
                label.textColor = [UIColor hexChangeFloat:KGrayColor];
                label.text = @"置业顾问";
                [cell.contentView addSubview:label];
                
                UILabel *guwenName = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-120, 0, 90, 45)];
                guwenName.textAlignment = NSTextAlignmentRight;
                guwenName.textColor = [UIColor hexChangeFloat:KBlackColor];
                guwenName.font = Default_Font_15;
                
                if (self.selectDic[@"staffName"] != [NSNull null] && self.selectDic[@"staffName"] != nil && self.selectDic[@"staffName"])
                {
                    guwenName.text = self.selectDic[@"staffName"];
                }
                else
                {
                    guwenName.text = @"";
                }
                
                [cell.contentView addSubview:guwenName];
            }
            else
            {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 13, 100, 20)];
                label.font = Default_Font_16;
                label.textColor = [UIColor hexChangeFloat:KGrayColor];
                [cell.contentView addSubview:label];
                if (self.selectType == 2)
                {
                    label.text = @"认购房源";
                }
                else if (self.selectType == 3)
                {
                    label.text = @"签约房源";
                }
                
                selectHouseLab = [[UILabel alloc] initWithFrame:CGRectMake(90, 0, SCREEN_WIDTH-30-90, 45)];
                selectHouseLab.textColor = [UIColor hexChangeFloat:KBlackColor];
                selectHouseLab.font = Default_Font_15;
                selectHouseLab.textAlignment = NSTextAlignmentRight;
                [cell.contentView addSubview:selectHouseLab];
                
                if (self.selectType == 3)
                {
                    selectHouseLab.text = @"请输入房号";
                    
                }
                else if (self.selectType == 2)
                {
                    selectHouseLab.text = @"请输入房号";
                    
                }
                
            }
            
        }
        else if (indexPath.row == 2)
        {
            if (self.selectType == 2)
            {
                
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 13, 100, 20)];
                label.font = Default_Font_16;
                label.textColor = [UIColor hexChangeFloat:KGrayColor];
                label.text = @"置业顾问";
                [cell.contentView addSubview:label];
                
                UILabel *guwenName = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-120, 0, 90, 45)];
                guwenName.textAlignment = NSTextAlignmentRight;
                guwenName.textColor = [UIColor hexChangeFloat:KBlackColor];
                guwenName.font = Default_Font_15;
                
                if (self.selectDic[@"staffName"] != [NSNull null] && self.selectDic[@"staffName"] != nil && self.selectDic[@"staffName"])
                {
                    guwenName.text = self.selectDic[@"staffName"];
                }
                else
                {
                    guwenName.text = @"";
                }
                
                [cell.contentView addSubview:guwenName];
                
            }
            else if (self.selectType == 3)
            {
                //成交总价
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 13, 100, 20)];
                label.font = Default_Font_16;
                label.textColor = [UIColor hexChangeFloat:KGrayColor];
                [cell.contentView addSubview:label];
                label.text = @"成交总价";
                
                priceField = [[UITextField alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-190, 13, 160, 20)];
                priceField.placeholder = @"请输入成交总价";
                priceField.textAlignment = NSTextAlignmentRight;
                priceField.keyboardType = UIKeyboardTypeNumberPad;
                priceField.font = Default_Font_15;
                priceField.delegate = self;
                if (dealMoney != nil)
                {
                    priceField.text = dealMoney;
                }
                priceField.textColor = [UIColor hexChangeFloat:KBlackColor];
                [cell.contentView addSubview:priceField];
                
                UILabel * yuanLab = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-30, 13, 20, 20)];
                yuanLab.font = Default_Font_15;
                yuanLab.textAlignment = NSTextAlignmentRight;
                yuanLab.textColor = [UIColor hexChangeFloat:KGrayColor];
                [cell.contentView addSubview:yuanLab];
                yuanLab.text = @"元";
            }
        }
      
        else
        {
            
//            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 13, 100, 20)];
            label.font = Default_Font_16;
            label.textColor = [UIColor hexChangeFloat:KGrayColor];
            label.text = @"置业顾问";
            [cell.contentView addSubview:label];
            
            UILabel *guwenName = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-120, 0, 90, 45)];
            guwenName.textAlignment = NSTextAlignmentRight;
            guwenName.textColor = [UIColor hexChangeFloat:KBlackColor];
            guwenName.font = Default_Font_15;
            
            if (self.selectDic[@"staffName"] != [NSNull null] && self.selectDic[@"staffName"] != nil && self.selectDic[@"staffName"])
            {
                guwenName.text = self.selectDic[@"staffName"];
            }
            else
            {
                guwenName.text = @"";
            }
            
            [cell.contentView addSubview:guwenName];
            
        }
    }
    else if (indexPath.section == 2)
    {
        if (indexPath.row == 0)
        {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 13, 100, 20)];
            label.font = Default_Font_16;
            label.textColor = [UIColor hexChangeFloat:KGrayColor];
            label.text = @"上传图片";
            [cell.contentView addSubview:label];
        }
        else
        {
            //icon-添加照片@2x
            if (!scrollView)
            {
                scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 85)];
            }
            if (picArray.count*75+10 > SCREEN_WIDTH-85) {
                scrollView.contentSize = CGSizeMake(picArray.count * 75 +10 + 85, 85);
                
            }
            else
            {
                scrollView.contentSize = CGSizeMake(SCREEN_WIDTH +10, 85);

            }
            [cell.contentView addSubview:scrollView];
            
            CGFloat picRightW = 10;
            for (int i = 0; i < picArray.count; i++)
            {
                UIImageView *imageView= [[UIImageView alloc] initWithFrame:CGRectMake(10+i*75, 10, 65, 65)];
                imageView.image = picArray[i][@"image"];
                imageView.backgroundColor = [UIColor redColor];
                imageView.layer.cornerRadius = 5;
                imageView.layer.masksToBounds = YES;
                [scrollView addSubview:imageView];
                
                picRightW = 10 + CGRectGetMaxX(imageView.frame);
            }
            
            if (!addPicBtn)
            {
                addPicBtn = [[UIButton alloc] initWithFrame:CGRectMake(picRightW, 10, 65, 65)];
                [addPicBtn setImage:[UIImage imageNamed:@"icon-添加照片@2x"] forState:UIControlStateNormal];
                addPicBtn.layer.cornerRadius = 5;
                addPicBtn.layer.masksToBounds = YES;
                addPicBtn.layer.borderColor = [UIColor hexChangeFloat:@"d0d0d0"].CGColor;
                addPicBtn.layer.borderWidth = 1;
                [addPicBtn addTarget:self action:@selector(updataPic) forControlEvents:UIControlEventTouchUpInside];
            }
            addPicBtn.frame = CGRectMake(picRightW, 10, 65, 65);
            [scrollView addSubview:addPicBtn];
        }
    }
    else
    {
        if (m_textView == nil) {
            m_textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH-20, 100)];
            m_textView.delegate = self;
            m_textView.font = Default_Font_15;
            m_textView.textColor = [UIColor hexChangeFloat:KBlackColor];
            
            placeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 300, 20)];
            placeLabel.text = @"请输入备注内容";
            placeLabel.font = Default_Font_15;
            placeLabel.textColor = [UIColor hexChangeFloat:KGrayColor];
            [m_textView addSubview:placeLabel];
        }
        [cell.contentView addSubview:m_textView];
    }
    return cell;
}

-(NSString *)convertString:(NSString*)string
{
    
    
    return nil;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
//    NSLog(@"%@-%@-%lu-%lu",textField.text,string,range.length,(unsigned long)range.location);
    dealMoney = textField.text;
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init] ;
    if([string length]==0)
    {
        [formatter setGroupingSeparator:@","];
        [formatter setGroupingSize:3];
        [formatter setUsesGroupingSeparator:YES];
        [formatter setSecondaryGroupingSize:3];
        NSString *num = textField.text ;
        num= [num stringByReplacingOccurrencesOfString:@"," withString:@""];
        NSString *str = [formatter stringFromNumber:[NSNumber numberWithDouble:[num doubleValue]]];
        textField.text=str;
        NSLog(@"%@",str);
        return YES;
    }
    else
    {
        [formatter setGroupingSeparator:@","];
        [formatter setGroupingSize:3];
        [formatter setUsesGroupingSeparator:YES];
        [formatter setSecondaryGroupingSize:3];
        NSString *num = textField.text ;
        if(![num isEqualToString:@""])
        {
            num= [num stringByReplacingOccurrencesOfString:@"," withString:@""];
            NSString *str = [formatter stringFromNumber:[NSNumber numberWithDouble:[num doubleValue]]];
            
            textField.text=str;
        }
    
        return YES;
    }
    
    //[formatter setLenient:YES];
    return YES;  ;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (textField == priceField)
    {
//        NSLog(@"%@",dealMoney);
//        NSString * str = [self countNumAndChangeformat:priceField.text];
//        priceField.text = str;
    }
     self.popView.frame = CGRectMake(20,(SCREEN_HEIGHT -300)/2,SCREEN_WIDTH-40, 300);
    return  YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == priceField)
    {
//        dealMoney = textField.text;
//        NSString * str = [self countNumAndChangeformat:priceField.text];
//        priceField.text = str;
        
        
    }
    
}

-(NSString *)bankNumToNormalNum
{
    return [priceField.text stringByReplacingOccurrencesOfString:@"," withString:@""];
}


-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    if (textField == self.danyuanField)
    {
         self.popView.frame = CGRectMake(20,(SCREEN_HEIGHT -300)/2-40,SCREEN_WIDTH-40, 300);
    }
    if (textField == self.shiField)
    {
         self.popView.frame = CGRectMake(20,(SCREEN_HEIGHT -300)/2-80,SCREEN_WIDTH-40, 300);
    }
}

-(void)textViewDidChange:(UITextView *)textView
{
    
    if (textView.text.length > 0)
    {
        placeLabel.hidden = YES;
    }
    else
    {
        placeLabel.hidden = NO;
    }

}

-(NSString *)countNumAndChangeformat:(NSString *)num
{
    int count = 0;
    long long int a = num.longLongValue;
    while (a != 0)
    {
        count++;
        a /= 10;
    }
    NSMutableString *string = [NSMutableString stringWithString:num];
    NSMutableString *newstring = [NSMutableString string];
    while (count > 3)
    {
        count -= 3;
        NSRange rang = NSMakeRange(string.length - 3, 3);
        NSString *str = [string substringWithRange:rang];
        [newstring insertString:str atIndex:0];
        [newstring insertString:@"," atIndex:0];
        [string deleteCharactersInRange:rang];
    }
    [newstring insertString:string atIndex:0];
    return newstring;
}

- (BOOL)isPureNumber:(NSString*)string
{
    NSScanner * scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

#pragma mark --上传图片
- (void)updataPic
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"修改头像"
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"拍照",@"相册",nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
}

//actionsheet的代理方法
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //修改头像
   
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
        
    }
    else if(buttonIndex==2)
    {
        //取消
        return;
    }
    
    imagePicker.allowsEditing = YES;
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:nil];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    //获得编辑过的图片
    UIImage *image = [info objectForKey: @"UIImagePickerControllerEditedImage"];
    image = [self ImageWithImageSimple:image ScaledToSize:CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH)];
    // NSData * data_IMG = UIImageJPEGRepresentation(img, 1.0);
    
    //获得编辑过的图片UIImagePickerControllerEditedImage UIImagePickerControllerOriginalImage
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"Login_User_token"];
    RequestInterface *requestOp = [[RequestInterface alloc] init];
    [requestOp requestUploadAvatarInterfaceWithImage:image token:token user_version:@"A"];
    [requestOp getInterfaceRequestObject:^(id data) {

        if (data[@"success"])
        {
//            NSDictionary *dic = @{@"image":image,@"url":[NSString stringWithFormat:@"%@/%@", REQUEST_SERVER_URL, data[@"datas"]]};
            NSDictionary *dic = @{@"image":image,@"url":data[@"datas"]};
            [picArray addObject:dic];
            //一个section刷新
            //        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:2];
            //        [tableview reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
            //一个cell刷新
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:1 inSection:2];
            [_m_tablebView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        } else {
            [self.view makeToast:data[@"message"]];
        }
        
        //        [self.headImageView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:image];
//        [self requestmYinfowithDBWithURlString:data[@"datas"]];
        
        
    } Fail:^(NSError *error) {
        [self.view makeToast:HintWithNetError];
    }];
    
    [self dismissViewControllerAnimated:YES completion:nil];
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



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    view.backgroundColor = [UIColor hexChangeFloat:@"f2f2f2"];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 3)
    {
        return 70;
    } else {
        return 0.01;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 3)
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 70)];
        view.backgroundColor = [UIColor hexChangeFloat:@"f2f2f2"];
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(10, 20, SCREEN_WIDTH-20, 40)];
        [button setTitle:@"提交申请" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.backgroundColor = [UIColor hexChangeFloat:KBlueColor];
        button.layer.cornerRadius = 5;
        button.layer.masksToBounds = YES;
        [button addTarget:self action:@selector(sendApply) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
        
        return view;
    } else {
        return nil;
    }
    
}

#pragma mark --提交申请
- (void)sendApply
{
    //[selectTimeLabel.text isEqualToString:@"请选择认筹时间"] ||
//    [selectTimeLabel.text isEqualToString:@"请选择认购时间"] ||
//    [selectTimeLabel.text isEqualToString:@"请选择签约时间"]
    
    if ([selectTimeLabel.text isEqualToString:@"请选择时间"])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:selectTimeLabel.text delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
    }
    else
    {
        NSMutableArray *arr = [NSMutableArray array];
        for (int i = 0; i < picArray.count; i++)
        {
            [arr addObject:picArray[i][@"url"]];
        }
        
        int applyStage;
        
        if (self.selectType == 0) {
            applyStage = 19;
        }
        else if (self.selectType == 1)
        {
            applyStage = 9;
        }
        else if (self.selectType == 2)
        {
            applyStage = 20;
        }
        else
        {
            applyStage = 10;
        }
        
        
        NSString * houseSource = [NSString stringWithFormat:@"%@,%@,%@",self.dongField.text,self.danyuanField.text,self.shiField.text];
        
        NSString *string = [arr componentsJoinedByString:@","];
        
        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"Login_User_token"];
        
        NSDictionary *dic = [[NSDictionary alloc]init];
        
        if (self.selectType == 2)
        {
   
            dic = @{@"token":token,
                    @"recomid":self.selectDic[@"id"],
                    @"applicantTime":[NSNumber numberWithInteger:visitTime],
                    @"staffName":self.selectDic[@"staffName"],
                    @"images":string,
                    @"remark":m_textView.text,
                    @"applyStage":[NSString stringWithFormat:@"%d", applyStage],
                    @"propertyresurce":houseSource
                    };
            if (self.dongField.text.length == 0)
            {
                [self.view makeToast:@"请填写完整信息"];
            }
            else
            {
                
                RequestInterface *interFace = [[RequestInterface alloc] init];
                [self.view Loading_0314];
                [interFace requestVisitSendApplyWithDic:dic];
                [interFace getInterfaceRequestObject:^(id data) {
                    [self.view Hidden];
                    NSLog(@"%@", data);
                    if ([data[@"success"] boolValue])
                    {
                        [self.view makeToast:@"提交成功"];
                        NSDictionary *dic = @{@"selectType":[NSNumber numberWithInteger:self.selectType]};
                        NSNotification *notifi = [NSNotification notificationWithName:@"refreshApply" object:nil userInfo:dic];
                        [[NSNotificationCenter defaultCenter] postNotification:notifi];
                        
                        //跳转到申请到访
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            NSArray *array = self.navigationController.viewControllers;
                            [self.navigationController popToViewController:[array objectAtIndex:1] animated:YES];
                        });
                    }
                    else
                    {
                        [self.view makeToast:data[@"message"]];
                    }
                } Fail:^(NSError *error) {
                    [self.view Hidden];
                    [self.view makeToast:@"网络错误"];
                }];
            }
            
            
        }
        else if (self.selectType == 3)
        {
            if (self.dongField.text.length == 0 || priceField.text.length == 0)
            {
                
                [self.view makeToast:@"请填写完整信息"];
            }
            
            else
            {
//                if (![self isPureNumber:priceField.text])
//                {
//                    [self.view makeToast:@"成交金额请输入纯数字"];
//                }
                dealMoney = [self bankNumToNormalNum];
                dic = @{@"token":token,
                        @"recomid":self.selectDic[@"id"],
                        @"applicantTime":[NSNumber numberWithInteger:visitTime],
                        @"staffName":self.selectDic[@"staffName"],
                        @"images":string,
                        @"remark":m_textView.text,
                        @"applyStage":[NSString stringWithFormat:@"%d", applyStage],
                        @"propertyresurce":houseSource,
                        @"dealmoney":dealMoney
                        };
                RequestInterface *interFace = [[RequestInterface alloc] init];
                [self.view Loading_0314];
                [interFace requestVisitSendApplyWithDic:dic];
                [interFace getInterfaceRequestObject:^(id data) {
                    [self.view Hidden];
                            NSLog(@"%@-%@", data,dealMoney);
                    if ([data[@"success"] boolValue])
                    {
                        [self.view makeToast:@"提交成功"];
                        NSDictionary *dic = @{@"selectType":[NSNumber numberWithInteger:self.selectType]};
                        NSNotification *notifi = [NSNotification notificationWithName:@"refreshApply" object:nil userInfo:dic];
                        [[NSNotificationCenter defaultCenter] postNotification:notifi];
                        
                        //跳转到申请到访
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            NSArray *array = self.navigationController.viewControllers;
                            [self.navigationController popToViewController:[array objectAtIndex:1] animated:YES];
                        });
                    }
                    else
                    {
                        [self.view makeToast:data[@"message"]];
                    }
                } Fail:^(NSError *error) {
                    [self.view Hidden];
                    [self.view makeToast:@"网络错误"];
                }];

            }
        }
        else
        {
            dic = @{@"token":token,
                    @"recomid":self.selectDic[@"id"],
                    @"applicantTime":[NSNumber numberWithInteger:visitTime],
                    @"staffName":self.selectDic[@"staffName"],
                    @"images":string,
                    @"remark":m_textView.text,
                    @"applyStage":[NSString stringWithFormat:@"%d", applyStage],
                    };
            RequestInterface *interFace = [[RequestInterface alloc] init];
            [self.view Loading_0314];
            [interFace requestVisitSendApplyWithDic:dic];
            [interFace getInterfaceRequestObject:^(id data) {
                [self.view Hidden];
                //        NSLog(@"%@", data);
                if ([data[@"success"] boolValue])
                {
                    [self.view makeToast:@"提交成功"];
                    NSDictionary *dic = @{@"selectType":[NSNumber numberWithInteger:self.selectType]};
                    NSNotification *notifi = [NSNotification notificationWithName:@"refreshApply" object:nil userInfo:dic];
                    [[NSNotificationCenter defaultCenter] postNotification:notifi];
                    
                    //跳转到申请到访
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        NSArray *array = self.navigationController.viewControllers;
                        [self.navigationController popToViewController:[array objectAtIndex:1] animated:YES];
                    });
                }
                else
                {
                    [self.view makeToast:data[@"message"]];
                }
            } Fail:^(NSError *error) {
                [self.view Hidden];
                [self.view makeToast:@"网络错误"];
            }];
        }
        
    }
 
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}





- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row == 0)
    {
        control = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        control.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.0];
        [control addTarget:self action:@selector(Hidden:) forControlEvents:UIControlEventTouchUpInside];
        UIWindow *key = [[UIApplication sharedApplication] keyWindow];
        [key addSubview:control];
        
        whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 220)];
        whiteView.backgroundColor = [UIColor whiteColor];
        [UIView animateWithDuration:0.4 animations:^{
            whiteView.frame = CGRectMake(0, SCREEN_HEIGHT-220, SCREEN_WIDTH, 220);
            control.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.6];
            
        }];
        [control addSubview:whiteView];
        
        datePicker = [[UIDatePicker alloc] init];
        datePicker.frame = CGRectMake(10, 40, SCREEN_WIDTH-20, 180);
        datePicker.backgroundColor = [UIColor whiteColor];
        datePicker.datePickerMode = UIDatePickerModeDateAndTime;
        datePicker.maximumDate = [NSDate date];
        datePicker.minimumDate = [NSDate dateWithTimeIntervalSinceNow:10];
        datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置为中文
        [whiteView addSubview:datePicker];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-200)/2, 10, 200, 30)];
//        label.text = @"请选择时间";
        if (self.selectType == 0)
        {
            label.text = @"请选择到访时间";
        }
        else if (self.selectType == 1)
        {
            label.text = @"请选择认筹时间";
        }
        else if (self.selectType == 2)
        {
            label.text = @"请选择认购时间";
        }
        else
        {
            label.text = @"请选择签约时间";
        }
        label.textColor = [UIColor hexChangeFloat:KBlueColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = Default_Font_15;
        [whiteView addSubview:label];
        
        UIButton *button  = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-80, 10, 60, 30)];
        [button setTitle:@"确定" forState:UIControlStateNormal];
        button.layer.borderColor = [UIColor hexChangeFloat:KBlueColor].CGColor;
        button.layer.borderWidth = 1;
        button.layer.cornerRadius = 5;
        button.clipsToBounds = YES;
        button.titleLabel.font = Default_Font_15;
        [button setTitleColor:[UIColor hexChangeFloat:KBlueColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(setTime) forControlEvents:UIControlEventTouchUpInside];
        [whiteView addSubview:button];
        
    }
    else if (indexPath.section == 1 && indexPath.row == 1)
    {
//        // 认购 选择认购房源
//        ChoosenHouseViewController * VC = [[ChoosenHouseViewController alloc]init];
//        VC.clientID = [self.selectDic objectForKey:@"id"];
//        VC.hidesBottomBarWhenPushed = YES;
//        VC.block = ^(NSString * string,NSString * roomID){
//           
//            selectHouseLab.text = string;
//            houseName = string;
//            houseSourceID = roomID;
//        };
//        [self.navigationController pushViewController:VC animated:YES];
        
        if (self.selectType == 2 || self.selectType == 3)
        {
             [self createPopView];
        }
       
    }
    else if (indexPath.section == 1 && indexPath.row == 2)
    {
       //成交总价
    }
    
}

-(void)createPopView
{
    
    self.bgControl = [[UIControl alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.bgControl.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    
    self.popView = [[UIView alloc]initWithFrame:CGRectMake(20,(SCREEN_HEIGHT-300)/2, SCREEN_WIDTH-40, 1)];
    self.popView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
    self.popView.backgroundColor = [UIColor whiteColor];
    self.popView.layer.cornerRadius = 5.0f;
//    self.popView.layer.borderWidth = 1.0f;
//    self.popView.layer.borderColor = [UIColor hexChangeFloat:KGrayColor].CGColor;
    self.popView.layer.masksToBounds = YES;
//    UIGestureRecognizer * tap = [[UIGestureRecognizer alloc]initWithTarget:self action:@selector(touchHiddenKeyBoard:)];
//    [self.popView addGestureRecognizer:tap];
    
//    [self.bgControl addTarget:self action:@selector(touchHiddenKeyBoard:) forControlEvents:UIControlEventTouchUpInside];
    [[UIApplication sharedApplication].keyWindow addSubview:self.bgControl];
    
    UILabel * titleLab = [[UILabel  alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-50, 30, 100, 20)];
    titleLab.textColor = [UIColor hexChangeFloat:@"00aff0"];
    titleLab.text = @"输入房号";
    titleLab.font = Default_Font_17;
    [self.popView addSubview:titleLab];
    
    UILabel * dongLab = [[UILabel alloc]initWithFrame:CGRectMake(20, 80, 40, 30)];
    dongLab.text = @"楼栋";
    dongLab.textColor = [UIColor hexChangeFloat:KBlackColor];
    dongLab.font = [UIFont systemFontOfSize:15];
    [self.popView addSubview:dongLab];
    
    self.dongField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(dongLab.frame)+20, 80, 200, 30)];
    self.dongField.placeholder = @"请填写楼栋号";
    self.dongField.font = [UIFont systemFontOfSize:15];
    self.dongField.delegate = self;
    [self.popView addSubview:self.dongField];
    
    UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.dongField.frame)+5, SCREEN_WIDTH-60, 0.5)];
    line1.backgroundColor = [UIColor hexChangeFloat:KGrayColor];
    line1.alpha = 0.5;
    [self.popView addSubview:line1];
    
    UILabel * danyuanLab = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.dongField.frame)+20, 40, 30)];
    danyuanLab.text = @"单元";
    danyuanLab.textColor = [UIColor hexChangeFloat:KBlackColor];
    danyuanLab.font = [UIFont systemFontOfSize:15];
    [self.popView addSubview:danyuanLab];
    
    self.danyuanField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(dongLab.frame)+20, CGRectGetMaxY(self.dongField.frame)+20, 200, 30)];
    self.danyuanField.placeholder = @"请填写单元号";
    self.danyuanField.font = [UIFont systemFontOfSize:15];
    self.danyuanField.delegate = self;
    [self.popView addSubview:self.danyuanField];
    
    UIView * line2 = [[UIView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.danyuanField.frame)+5, SCREEN_WIDTH-60, 0.5)];
    line2.backgroundColor = [UIColor hexChangeFloat:KGrayColor];
    line2.alpha = 0.5;
    [self.popView addSubview:line2];
    
    UILabel * shiLab = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.danyuanField.frame)+20, 40, 30)];
    shiLab.text = @"房号";
    shiLab.textColor = [UIColor hexChangeFloat:KBlackColor];
    shiLab.font = [UIFont systemFontOfSize:15];
    [self.popView addSubview:shiLab];
    
    self.shiField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(dongLab.frame)+20, CGRectGetMaxY(self.danyuanField.frame)+20, 200, 30)];
    self.shiField.placeholder = @"请填写房间号";
    self.shiField.font = [UIFont systemFontOfSize:15];
    self.shiField.delegate = self;
    [self.popView addSubview:self.shiField];
    
    UIView * line3 = [[UIView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.shiField.frame)+5, SCREEN_WIDTH-60, 0.5)];
    line3.backgroundColor = [UIColor hexChangeFloat:KGrayColor];
    line3.alpha = 0.5;
    [self.popView addSubview:line3];
    
    UIButton * cacelBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 240, (SCREEN_WIDTH-100)/2, 30)];
    [cacelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cacelBtn setTitleColor:[UIColor hexChangeFloat:KGrayColor] forState:UIControlStateNormal];
    cacelBtn.layer.cornerRadius = 5.0f;
    cacelBtn.layer.borderWidth = 1.0f;
    cacelBtn.layer.borderColor = [UIColor hexChangeFloat:KGrayColor].CGColor;
    cacelBtn.layer.masksToBounds = YES;
    cacelBtn.alpha = 0.7;
    [cacelBtn addTarget:self action:@selector(hiddenView:) forControlEvents:UIControlEventTouchUpInside];
    [self.popView addSubview:cacelBtn];
    
    UIButton * confirmBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(cacelBtn.frame)+20, 240, (SCREEN_WIDTH-100)/2, 30)];
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    confirmBtn.layer.cornerRadius = 5.0f;
    confirmBtn.backgroundColor = [UIColor hexChangeFloat:@"00aff0"];
//    confirmBtn.layer.borderColor = [UIColor hexChangeFloat:@"00aff0"].CGColor;
//    confirmBtn.layer.borderWidth = 1.0f;
    confirmBtn.layer.masksToBounds = YES;
    [confirmBtn addTarget:self action:@selector(clickToConfirm:) forControlEvents:UIControlEventTouchUpInside];
    [self.popView addSubview:confirmBtn];
    
    [self.bgControl addSubview:self.popView];
    [UIView animateWithDuration:0.5 animations:^{
        self.bgControl.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        self.popView.frame = CGRectMake(20,(SCREEN_HEIGHT -300)/2,SCREEN_WIDTH-40, 300);
    }];
}



- (void)hiddenView:(UIControl *)control
{
    
    [UIView animateWithDuration:0.3 animations:^{
        
         self.popView.frame = CGRectMake(20,(SCREEN_HEIGHT-300)/2, SCREEN_WIDTH-40, 1);
        self.popView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
        self.bgControl.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.bgControl removeFromSuperview];
    });
    
}

-(void)clickToConfirm:(UIButton *)sender
{
   
    if (self.dongField.text.length == 0 ||
        self.danyuanField.text.length == 0 ||
        self.shiField.text.length == 0 )
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入完整信息" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        houseName = [NSString stringWithFormat:@"%@栋%@单元%@室",self.dongField.text ,self.danyuanField.text,self.shiField.text];
        selectHouseLab.text = houseName;
        [self hiddenView:self.bgControl];
    }
}

//确认时间
- (void)setTime
{
    [UIView animateWithDuration:0.4 animations:^{
        whiteView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 220);
        control.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.0];
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [control removeFromSuperview];
    });
    
    NSDateFormatter *dataFormater = [[NSDateFormatter alloc] init];
    [dataFormater setDateFormat:@"yyyy-MM-dd HH:mm"];
    selectTimeLabel.text = [dataFormater stringFromDate:[datePicker date]];
    visitTime = [[datePicker date] timeIntervalSince1970];
    
//    NSTimeInterval time = [[datePicker date] timeIntervalSinceNow];
//    selectTimeLabel.text = [datePicker date];
//    int dayNum = time/3600/24;
//    if (dayNum<= -1)
//    {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"选择时间有误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert show];
//    }
//    else
//    {
//        [m_dict setValue:[dataFormater stringFromDate:[datePicker date]] forKey:@"bid_huankuan"];
//        self.timeLabel.text = [NSString stringWithFormat:@"%@(%d天)",[dataFormater stringFromDate:[datePicker date]], dayNum];
//    }
    
}

- (void)Hidden:(UIControl *)sontrol
{
    [UIView animateWithDuration:0.4 animations:^{
        whiteView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 220);
        control.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.0];
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [control removeFromSuperview];
    });

}

//将列表的分割线从头开始
//最新的，简便些
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 0)];
    }
    
    
    if (IOS_VERSION >= 8.0)
    {
        if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)])
        {
            [cell setPreservesSuperviewLayoutMargins:NO];
        }
        if ([cell respondsToSelector:@selector(setLayoutMargins:)])
        {
            [cell setLayoutMargins:UIEdgeInsetsMake(0, 10, 0, 0)];
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
