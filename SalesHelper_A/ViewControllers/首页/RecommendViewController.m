//
//  RecommentViewController.m
//  SalesHelper_A
//
//  Created by ZhipuTech on 15/6/11.
//  Copyright (c) 2015年 X. All rights reserved.
//

#import "RecommendViewController.h"
#import <AddressBookUI/AddressBookUI.h>
#import "UIViewExt.h"
#import "LoginViewController.h"

#import "NewClientsManagerViewController.h"
#import "ClientsRecommendedViewController.h"

@interface RecommendViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,ABPeoplePickerNavigationControllerDelegate,UIAlertViewDelegate, requestLogin>
{
    NSString * tokenStr ;
    __weak IBOutlet UITableView * clientTableView;
    //客户手机号
    __weak IBOutlet UITextField *iphone;
    //客户姓名
    __weak IBOutlet UITextField *clientName;
    //视图view的高度设定
    __weak IBOutlet NSLayoutConstraint *viewHeight;
    //先生按钮
    __weak IBOutlet UIButton *manBtn;
    //女士按钮
    __weak IBOutlet UIButton *womanBtn;
    //代表选中先生按钮时为yes当选中女生按钮时为NO
    BOOL selectionBtn;
    
    IBOutlet UIButton *notify;
    
    __weak IBOutlet NSLayoutConstraint *contentViewHeight;
    //提交推荐按钮  我都没用这个
    __weak IBOutlet UIButton *rcmdBtn;
    UITextField *_customerNameTextField;//姓名
    UITextField *_customerMobileTextField;//手机号
    UISegmentedControl * sexSegment;

    
    //提交推荐按钮
}

@property (nonatomic, strong) NSMutableArray *selectedContacts;   //推荐的人员信息
@end

@implementation RecommendViewController
{
    //记录数组个数
    NSUInteger  count;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:[self imageWithBgColor:[UIColor colorWithRed:23/255.0f green:183/255.0f blue:242/255.0f alpha:1]] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[self imageWithBgColor:[UIColor colorWithRed:23/255.0f green:183/255.0f blue:242/255.0f alpha:1]]];

}
-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];

    self.navigationController.navigationBar.translucent = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    if(![defaults boolForKey:@"SalesHelper_publicNotice"])
    {
        if ([defaults valueForKey:@"Login_User_token"] != nil)
        {
        }
        else
        {
            UINavigationController *mainNaVC = [[UINavigationController alloc] initWithRootViewController:[[LoginViewController alloc]init]];
            [self presentViewController:mainNaVC animated:YES completion:nil];
//            LoginAndRegisterViewController *vc = [[LoginAndRegisterViewController alloc] init];
//            [self presentViewController:vc animated:YES completion:nil];
        }
        //存数据--->基本数据类型
        [defaults setBool:NO forKey:@"SalesHelper_publicNotice"];//存 公告内容
        [defaults setBool:NO forKey:@"SalesHelper_AdvertView"];//存 广告内容
        [defaults synchronize];
    }
    
    if (self.info == nil)
    {
        self.info = [NSMutableArray arrayWithCapacity:0];
    }
    viewHeight.constant = self.view.height - 44;
    
    self.tableViewHeight.constant = 230;
    
    [rcmdBtn addTarget:self action:@selector(clickRcmdBtn) forControlEvents:UIControlEventTouchUpInside];
    
    count = self.info.count;
    
    self.tableViewHeight.constant += 49 * self.info.count;
    
    if(rcmdBtn.bottom + 44 + 49 * self.info.count > viewHeight.constant)
    {
        viewHeight.constant = rcmdBtn.bottom + 44 + 49 * self.info.count;
    }
    selectionBtn = YES;
    
    UILabel * titleLabel = [UILabel new];
    titleLabel.text = @"推荐客户";
    titleLabel.font = [UIFont systemFontOfSize:18];
    titleLabel.textColor = [UIColor whiteColor];
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    
    UITapGestureRecognizer *tableViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentTableViewTouchInSide)];
    tableViewGesture.numberOfTapsRequired = 1;
    tableViewGesture.cancelsTouchesInView = NO;
    [clientTableView addGestureRecognizer:tableViewGesture];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow) name:UIKeyboardDidShowNotification object:nil];//在这里注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden) name:UIKeyboardDidHideNotification object:nil];//在这里注册通知
    
    // Do any additional setup after loading the view.
}
- (void)keyboardWillShow
{
    clientTableView.allowsSelection = NO;
}
- (void)keyboardWillHidden
{
    clientTableView.allowsSelection = YES;
    
}
- (void)commentTableViewTouchInSide{
    [iphone resignFirstResponder];
    [clientName resignFirstResponder];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    if (section == 1) {
        return 2;
    }
    if (section == 2){
         if (self.info.count != 0) {
            return self.info.count+1;
         }else{
             return 1;
         }
    }
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 49;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //从客户列表导入
    if (indexPath.section == 0 && indexPath.row == 0)
    {
        UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"ClientsManager" bundle:nil];
        NewClientsManagerViewController * recommend = [storyboard instantiateViewControllerWithIdentifier:@"NewClientsManagerViewController"];
        recommend.isChoosen = YES;
        [recommend passContentWithBlock:^(NSDictionary *dict) {
            clientName.text = [dict objectForKey:@"name"];
            iphone.text = [dict objectForKey:@"phone"];
        }];
        [self.navigationController pushViewController:recommend animated:YES];
    }
    
    //选择意向房源
    if (indexPath.section == 2  && indexPath.row == 0) {
        UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        RecommendPropertyViewController * recommend = [storyboard instantiateViewControllerWithIdentifier:@"RecommendPropertyViewController"];
        recommend.recommendDelegate = self;
        recommend.choosenArr = self.info;
        [self.navigationController pushViewController:recommend animated:YES];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = nil;
    
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell00"];

    }
    
    if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"cell11"];
            clientName = (UITextField *)[cell.contentView viewWithTag:20];
            clientName.delegate = self;
            sexSegment = (UISegmentedControl *)[cell.contentView viewWithTag:10];
            sexSegment.tintColor = [ProjectUtil colorWithHexString:@"00aff0"];
            sexSegment.layer.cornerRadius = 20;
        }
       if (indexPath.row == 1)
       {
           cell = [tableView dequeueReusableCellWithIdentifier:@"cell10"];
           iphone = (UITextField *)[cell.contentView viewWithTag:120];
           iphone.delegate = self;
           if (self.customerInfo)
           {
               iphone.text = [self.customerInfo objectForKey:@"phone"];
               UIButton * btn = (UIButton *)[cell viewWithTag:745];
               btn.hidden = YES;
               if (self.customerInfo)
               {
                   clientName.text = [self.customerInfo objectForKey:@"name"];
                   womanBtn.hidden = YES;
                   manBtn.hidden = YES;
               }
           }
       }
    }
    if (indexPath.section == 2)
    {
        if (indexPath.row == 0)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"rCell"];
        }
        else
        {

          cell = [tableView dequeueReusableCellWithIdentifier:@"dCell"];
          UILabel * titleLabel = (UILabel *)[cell.contentView viewWithTag:10];
          titleLabel.text = [NSString stringWithFormat:@"%@",[self.info[indexPath.row -1] objectForKey:@"name"]];
        }
    }
    
    cell.separatorInset = UIEdgeInsetsMake(0, 8, 0, 0);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row > 0) {
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.info removeObjectAtIndex:(indexPath.row -1)];
    count -- ;
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    self.tableViewHeight.constant -= 49;
    
    if (viewHeight.constant > self.view.height) {
        viewHeight.constant -= 49;
    }
    
    [tableView reloadData];
}

#pragma mark - Navigation


//返回事件
- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//按返回键，关闭键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


//导入通讯录
- (IBAction)addressClick:(id)sender {
    ABPeoplePickerNavigationController * peopleNC = [[ABPeoplePickerNavigationController alloc] init];
    peopleNC.peoplePickerDelegate = self;
    [self.navigationController presentViewController:peopleNC animated:YES completion:nil];
}

//打开通讯录后，点击取消的事件
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    [peoplePicker dismissViewControllerAnimated:YES completion:nil];
}
//
////选择通信录中XX人后，发生的事件
//- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
//{
//    clientName.text = (__bridge NSString *)ABRecordCopyCompositeName(person);
//    
//    ABMutableMultiValueRef phoneMuti = ABRecordCopyValue(person, kABPersonPhoneProperty);
//
//    if (ABMultiValueGetCount(phoneMuti) > 0) {
//        NSString * phone = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phoneMuti, 0);
//        iphone.text = phone;
//        for (int i = 1; i < ABMultiValueGetCount(phoneMuti); i++) {
//             NSString * phone = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phoneMuti, i);
//            iphone.text = [NSString stringWithFormat:@"%@,%@",iphone.text,phone];
//        }
//    }
//    
//    [peoplePicker dismissViewControllerAnimated:YES completion:nil];
//    return NO;
//}
//
//- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
//{
//    return NO;
//}

// Called after a person has been selected by the user.
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
    
    NSString *phoneStr = @"";
    /*
     for (int i=0; i < ABMultiValueGetCount(phonesRef); i++) {
     CFStringRef currentPhoneLabel = ABMultiValueCopyLabelAtIndex(phonesRef, i);
     CFStringRef currentPhoneValue = ABMultiValueCopyValueAtIndex(phonesRef, i);
     
     if(currentPhoneLabel) {
     if (CFStringCompare(currentPhoneLabel, kABPersonPhoneMobileLabel, 0) == kCFCompareEqualTo) {
     phoneStr = (__bridge NSString *)currentPhoneValue;
     }
     
     if (CFStringCompare(currentPhoneLabel, kABHomeLabel, 0) == kCFCompareEqualTo) {
     phoneStr = (__bridge NSString *)currentPhoneValue;
     }
     }
     if(currentPhoneLabel) {
     CFRelease(currentPhoneLabel);
     }
     if(currentPhoneValue) {
     CFRelease(currentPhoneValue);
     }
     }*/
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
            name = lastName;
        }
        
        
        //将特殊的字符' 转为特殊符号存储
        name = [name stringByReplacingOccurrencesOfString:@"'" withString:@"|*||*|"];
        
        availablePhone = [phoneStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
        availablePhone = [availablePhone stringByReplacingOccurrencesOfString:@"+86 " withString:@""];
        availablePhone = [availablePhone stringByReplacingOccurrencesOfString:@"(" withString:@""];
        availablePhone = [availablePhone stringByReplacingOccurrencesOfString:@")" withString:@""];
        availablePhone = [availablePhone stringByReplacingOccurrencesOfString:@" " withString:@""];
//        [self valueChanged_Name:clientName];
    }
    clientName.text = name;
    iphone.text = availablePhone;
}


//点击女士按钮事件
- (IBAction)womanBtnClick:(id)sender {
     UIImage * selectImage = [UIImage imageNamed:@"销邦-推荐客户-性别1.png"];
    UIImage * unSelectImage = [UIImage imageNamed:@"销邦-推荐客户-性别2.png"];
    if (selectionBtn) {
        //当点击后womanbtn处于选中状态
        selectImage = [UIImage imageWithCGImage:selectImage.CGImage scale:1 orientation:UIImageOrientationDown];
        [womanBtn setBackgroundImage:selectImage forState:UIControlStateNormal];
        
        unSelectImage = [UIImage imageWithCGImage:unSelectImage.CGImage scale:1 orientation:UIImageOrientationDown];
        [manBtn setBackgroundImage:unSelectImage forState:UIControlStateNormal];
        [womanBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [manBtn setTitleColor:[ProjectUtil colorWithHexString:@"00aff0"] forState:UIControlStateNormal];
        selectionBtn = NO;
    }
}

//点击先生按钮事件
- (IBAction)manBtnClick:(id)sender {
    UIImage * selectImage = [UIImage imageNamed:@"销邦-推荐客户-性别1.png"];
    UIImage * unSelectImage = [UIImage imageNamed:@"销邦-推荐客户-性别2.png"];
    
    [manBtn setBackgroundImage:selectImage forState:UIControlStateNormal];
    [womanBtn setBackgroundImage:unSelectImage forState:UIControlStateNormal];
    [womanBtn setTitleColor:[ProjectUtil colorWithHexString:@"00aff0"] forState:UIControlStateNormal];
    [manBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    selectionBtn = YES;
}
//选择是否通知按钮事件
- (IBAction)notify:(UIButton *)sender {
    if (sender.tag == 0) {
        [sender setBackgroundImage:[UIImage imageNamed:@"销邦-推荐客户-单选按钮选中.png"] forState:UIControlStateNormal];
        sender.tag = 1;
    }else
    {
        sender.tag = 0;
        [sender setBackgroundImage:[UIImage imageNamed:@"销邦-推荐客户-单选按钮.png"] forState:UIControlStateNormal];
    }
}

//提交推荐事件
- (IBAction)rcmBtnClick:(id)sender {
//    [self submitContact];
}


#pragma mark - 确定选择的联系人
- (BOOL)checkContactInfo
{
    if (clientName.text.length == 0) {
        [self.view makeToast:@"推荐人姓名不能为空"];
        return NO;
    }else if (iphone.text.length == 0)
    {
        [self.view makeToast:@"手机号码不能为空"];
        return NO;
    }else if (![ProjectUtil isFuzzyPhone:iphone.text]) {
        [self.view makeToast:@"请输入正确的手机号码"];
        return NO;
    }else {
        return YES;
    }
}
//点击右边的提交按钮

//- (IBAction)submitContact {

//    [self.view endEditing:YES];
//    if (![self checkContactInfo]){
//        return;
//    }
//    
//    if (self.info.count==0)
//    {
//        [self.view makeToast:@"请添加推荐意向房源"];
//        return ;
//        
//    }
//    if (self.info.count > 0) {
////        NSDictionary *contact = self.selectedContacts.firstObject;
//        NSString *nameStr = @"";
//        NSString *phoneStr = @"";
//        int startIndex = 0;
    
//        if (self.selectedContacts.count == 6) {
//            if (_customerNameTextField.text.length > 0 && _customerMobileTextField.text.length > 0) {
//                [self.view makeToast:@"您推荐的客户数大于6人"];
//                return ;
//            }
//        }else {
//            if (_customerNameTextField.text.length > 0 && _customerMobileTextField.text.length > 0) {
//                if ([self checkContactInfo]) {
//                    nameStr = clientName.text;
//                    phoneStr = iphone.text;
//                    startIndex = 1;
//                }else {
//                    return;
//                }
//            }else {
//                if (!([_customerNameTextField.text isEqualToString:contact[@"name"]] && [_customerMobileTextField.text isEqualToString:contact[@"phone"]])) {
//                    nameStr =contact[@"name"];
//                    phoneStr = contact[@"phone"];
//                    startIndex = 1;
//                }
//            }
//        }
        
//        for (int i = startIndex; i<self.selectedContacts.count; i++) {
//            contact = self.selectedContacts[i];
//            if (!([_customerNameTextField.text isEqualToString:contact[@"name"]] && [_customerMobileTextField.text isEqualToString:contact[@"phone"]])) {
//                nameStr = [NSString stringWithFormat:@"%@|%@",nameStr,contact[@"name"]];
//                phoneStr = [NSString stringWithFormat:@"%@|%@",phoneStr,contact[@"phone"]];
//            }
//            
//        }
//        
//        NSMutableArray *allDataArray = [[NSMutableArray alloc] init];
//        for (int j=0; j<self.selectedRealestate.count; j++) {
//            NSDictionary *dict = @{@"referee_id":self.login_user_token,
//                                   @"name":nameStr,
//                                   @"phone":phoneStr,
//                                   @"developer_id":self.selectedRealestate[j][@"developer_id"],
//                                   @"property_id":self.selectedRealestate[j][@"id"]
//                                   };
//            [allDataArray addObject:dict];
//        }
//        
//        [self requestAddRec:allDataArray];
//    }else {
//        if ([self checkContactInfo]) {
//            NSMutableArray *allDataArray = [[NSMutableArray alloc] init];
//            for (int j=0; j<self.selectedRealestate.count; j++) {
//                NSDictionary *dict = @{@"referee_id":self.login_user_token,
//                                       @"name":nameStr,
//                                       @"phone":phoneStr,
////                                       @"developer_id":self.selectedRealestate[j][@"developer_id"],
////                                       @"property_id":self.selectedRealestate[j][@"id"]
//                                       };
//                [allDataArray addObject:dict];
//            }
//            
//            [self requestAddRec:allDataArray];
//        }else {
//            return;
//        }
        
        //接口要改
//    }
//}


- (IBAction)notifyBtnClick:(id)sender {
    [self notify:notify];
}

- (void)addPropertyArrInfo:(NSArray *)propertyInfoArr
{
    if (count != propertyInfoArr.count) {
        
        if (propertyInfoArr.count > count)
        {
            self.tableViewHeight.constant += 49 * (propertyInfoArr.count - count);
            if(rcmdBtn.bottom + 44 + 49 *  (propertyInfoArr.count - count) > viewHeight.constant)
            {
            viewHeight.constant = rcmdBtn.bottom + 44 + 49 *  (propertyInfoArr.count - count);
            }
        }
        if (propertyInfoArr.count < count)
        {
            self.tableViewHeight.constant -= 49 * (count - propertyInfoArr.count);
            if(propertyInfoArr.count == 0)
            {
                viewHeight.constant = rcmdBtn.bottom + 44 + 49 *  (propertyInfoArr.count - count);
            }
        }
        count = propertyInfoArr.count;
        
        [clientTableView reloadData];
    }
    else
    {
        [clientTableView reloadData];
    }
}

#pragma mark -- 提交推荐
- (void)clickRcmdBtn
{
    [self.view endEditing:YES];

    if (![self checkContactInfo])
    {
        return;
    }
    if (self.info.count==0)
    {
        [self.view makeToast:@"请添加推荐意向房源"];
        return ;
    }
//    if (self.login_user_token.length == 0)
//    {
//        UINavigationController *loginVC = [[UINavigationController alloc] initWithRootViewController:[[LoginViewController alloc]init]];
//        LoginViewController * login  = loginVC.viewControllers[0];
//        login.delegate = self;
//        [self presentViewController:loginVC animated:YES completion:nil];
//    }
  
    NSMutableArray * paramArray = [NSMutableArray array];
    for (int i = 0 ; i < self.info.count; i ++)
    {
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        NSNumber * number = [self.info[i]objectForKey:@"id"];
        [param setObject:number forKey:@"propertyId"];
        [param setObject:clientName.text forKey:@"name"];
        [param setObject:iphone.text forKey:@"phone"];
        
        NSNumber * sex =  [NSNumber numberWithInteger:sexSegment.selectedSegmentIndex];
        [param setObject:sex forKey:@"sex"];
        
        [paramArray addObject:param];
    }
    [self requestAddRec:paramArray];

}

#pragma mark - 推荐完成信息接口
-(void)requestAddRec:(NSArray *)infoArray
{
    NSData *jsonData = [ProjectUtil JSONString:infoArray];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                 encoding:NSUTF8StringEncoding];
    
    NSString *noticeFriend = @"0";
    if (notify.tag == 1) {
        noticeFriend = @"1";
    }
    
    NSDictionary *dict = @{@"recommandInfos":jsonString,
                           @"token":tokenStr.length ? tokenStr : self.login_user_token,
                           @"isSms":noticeFriend
                           };
    
    RequestInterface *requestHOp = [[RequestInterface alloc] init];
    [requestHOp requestAddRecWithParam:dict];
    
    
    [self.view makeProgressViewWithTitle:@"正在推荐"];
    [requestHOp getInterfaceRequestObject:^(id data) {
        [self.view hideProgressView];
        
//        NSLog(@"推荐客户成功和剖返回的数据 -- %@", data);
        [ProjectUtil showLog:@"data = %@",data];
//        int a = 1;
        BOOL success = YES;
        
        if ([data[@"success"] boolValue] == YES)
        {
            for (int i = 0; i < [[data objectForKey:@"datas"] count]; i++)
            {
                if ([data[@"datas"][i][@"success"] boolValue] == NO)
                {
                    success = NO;
                }
            }
            if (success)
            {
                [self.info removeAllObjects];
                [self.view endEditing:YES];
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"推荐成功" message:@"您可以在我的客户中查看客户状态信息" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:@"去看看", nil];
                [alert show];
            }
            else
            {
                NSString * str;
                for (int i = 0 ; i < [data[@"datas"] count]; i++) {
                    str = data[@"datas"][i][@"propertyName"];
                    str = [str stringByAppendingString:[NSString stringWithFormat:@":%@\n",data[@"datas"][i][@"message"]]];
                }
                [self.view makeToast:str];
                
            }
            
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

#pragma mark --关闭或去看看
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //关闭
    if (buttonIndex == 0)
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    //去看看
    else
    {
        [self.tabBarController setSelectedIndex:1];
        
        
        UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"ClientsManager" bundle:nil];
        ClientsRecommendedViewController * recommend = [storyboard instantiateViewControllerWithIdentifier:@"ClientsRecommendedViewController"];
        
        
        [self.navigationController pushViewController:recommend animated:YES];
        
//        UINavigationController * navi = self.tabBarController.selectedViewController;
//        NSMutableArray * arrNavi = [NSMutableArray arrayWithArray:navi.viewControllers];
//        
//        for (int i = 0 ; i < arrNavi.count; i++)
//        {
//            UIViewController * vc = arrNavi[i];
//            if ([vc isKindOfClass:[RecommendViewController class]])
//            {
//                [vc removeFromParentViewController];
//            }
//        }
//        
//        recommend.hidesBottomBarWhenPushed = YES;
//
//        [navi pushViewController:recommend animated:NO];
    }
}


- (void)sendRequestWithToken:(NSString *)token
{
    tokenStr = token;
    self.login_user_token = token;
    NSMutableArray * paramArray = [NSMutableArray array];
    
    for (int i = 0 ; i < self.info.count; i ++)
    {
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        NSNumber * number = [self.info[i]objectForKey:@"id"];
        [param  setObject:number forKey:@"propertyId"];
        [param setObject:clientName.text forKey:@"name"];
        [param setObject:iphone.text forKey:@"phone"];
        NSNumber * sex = [NSNumber numberWithInteger:sexSegment.selectedSegmentIndex];
        [param setObject:sex forKey:@"sex"];
        [paramArray addObject:param];
    }
    [self requestAddRec:paramArray];
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
//    if (textField == iphone) {
//        if (string.length == 0) return YES;
//        
//        NSInteger existedLength = textField.text.length;
//        NSInteger selectedLength = range.length;
//        NSInteger replaceLength = string.length;
//        if (existedLength - selectedLength + replaceLength > 11) {
//            return NO;
//        }
//    }
//    
//    if (textField ==  clientName) {
//        if (string.length == 0) return YES;
//        
//        NSInteger existedLength = textField.text.length;
//        NSInteger selectedLength = range.length;
//        NSInteger replaceLength = string.length;
//        if (existedLength - selectedLength + replaceLength > 5) {
//            return NO;
//        }
//    }
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容

    if (textField == iphone)
    {
        
        //如果输入框内容大于16则弹出警告
        if ([toBeString length] > 11)
        {
            textField.text = [toBeString substringToIndex:11];
            //        [self.view makeToast:@"超过最大字数(16位)不能输入了"];
            return NO;
        }
    }
    if (textField == clientName)
    {
        //如果输入框内容大于16则弹出警告
        if ([toBeString length] > 5)
        {
            textField.text = [toBeString substringToIndex:5];
            //        [self.view makeToast:@"超过最大字数(16位)不能输入了"];
            return NO;
        }
    }
    return YES;
}

@end
