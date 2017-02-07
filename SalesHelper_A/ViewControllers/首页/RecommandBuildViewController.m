//
//  RecommandBuildViewController.m
//  SalesHelper_A
//
//  Created by flysss on 16/1/28.
//  Copyright © 2016年 X. All rights reserved.
//

#import "RecommandBuildViewController.h"
#import "NewClientsManagerViewController.h"
#import "RecommendPropertyViewController.h"
#import "RelationClientViewController.h"
#import "ClientsRecommendedViewController.h"

@interface RecommandBuildViewController () <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, recommendPropertyVCDelegate, UIAlertViewDelegate, UITextFieldDelegate>
@property (nonatomic, strong) UITableView * m_tabelView;
@property (nonatomic, strong) UITextView * m_textView;

@end

@implementation RecommandBuildViewController
{
    //客户手机
    UITextField *iphone;
    //客户姓名
    UITextField *clientName;
    UISegmentedControl *sexSegment;
    
    UILabel *placeStr;
    BOOL isSms;
    UIButton *smsButton;
}


- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
    [userInfo setObject:nil forKey:@"relationClient"];
    [userInfo synchronize];
    

    [self CreateCustomNavigtionBarWith:self leftItem:@selector(backlastView) rightItem:nil];
    //创建标题
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-120)/2, 27, 120, 30)];
    titleLabel.text = @"推荐客户";
    titleLabel.font = Default_Font_20;
    [titleLabel setTextColor:[UIColor whiteColor]];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.topView addSubview: titleLabel];

    
    [self creatTableView];
    
    [self requestData];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.navigationController.navigationBarHidden = YES;
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}


- (void)backlastView
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)creatTableView
{
    self.m_tabelView = [[UITableView alloc] initWithFrame:CGRectMake(0,64, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStyleGrouped];
    self.m_tabelView.delegate = self;
    self.m_tabelView.dataSource = self;
    self.m_tabelView.tableFooterView = [[UIView alloc] init];
    self.m_tabelView.contentInset = UIEdgeInsetsMake(12, 0, 0, 0);
    self.m_tabelView.backgroundColor = [UIColor hexChangeFloat:@"f2f2f2"];
    [self.view addSubview:self.m_tabelView];
    
}


- (void)requestData
{
    [self.m_tabelView reloadData];
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
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-35, 50)];
        label.text = @"从客户列表导入";
        label.textColor = [UIColor hexChangeFloat:KBlackColor];
        label.font = Default_Font_15;
        [cell.contentView addSubview:label];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-20, (50-17)/2, 9, 17)];
        imageView.image = [UIImage imageNamed:@"销邦-楼盘详情页-右箭头"];
        [cell.contentView addSubview:imageView];
        
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            if (clientName == nil)
            {
                clientName = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-10-100, 50)];
                clientName.placeholder = @"请输入客户姓名";
                clientName.font = Default_Font_15;
                clientName.textColor = [UIColor hexChangeFloat:KBlackColor];
            }
            [cell.contentView addSubview:clientName];
            
            if (sexSegment == nil)
            {
                sexSegment = [[UISegmentedControl alloc] initWithItems:@[@"先生",@"女士"]];
                sexSegment.frame = CGRectMake(SCREEN_WIDTH-100, 10, 90, 30);
                sexSegment.layer.masksToBounds = YES;
                sexSegment.layer.cornerRadius = 15;
                
                sexSegment.layer.borderColor = [ProjectUtil colorWithHexString:@"00aff0"].CGColor;
                sexSegment.layer.borderWidth = 1.0;
                sexSegment.tintColor = [ProjectUtil colorWithHexString:@"00aff0"];
                sexSegment.selectedSegmentIndex = 0;
            }
            [cell.contentView addSubview:sexSegment];
            
        }
        else
        {
            if (iphone == nil)
            {
                iphone = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-10-100, 50)];
                iphone.placeholder = @"请输入客户手机";
                iphone.font = Default_Font_15;
                iphone.keyboardType = UIKeyboardTypeNumberPad;
//                iphone.delegate = self;
                iphone.textColor = [UIColor hexChangeFloat:KBlackColor];
                //输入框添加点击事件
                [iphone addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
            }
            [cell.contentView addSubview:iphone];
        }
    }
    else if (indexPath.section == 2)
    {
        NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
        NSArray * array = [userInfo objectForKey:@"relationClient"];
        NSLog(@"%@", array);
        if (indexPath.row == array.count)
        {
            UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(10, (45-19)/2, 19, 19 )];
            image.image = [UIImage imageNamed:@"添加客户"];
            [cell.contentView addSubview:image];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(image.frame)+8, 0, 150, 45)];
            label.textColor = [UIColor hexChangeFloat:KBlueColor];
            label.font = Default_Font_15;
            label.text = @"添加关联客户";
            [cell.contentView addSubview:label];
            
        } else {
            UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 12, SCREEN_WIDTH/2, 20)];
            nameLabel.text = array[indexPath.row][@"name"];
            nameLabel.textColor = [UIColor hexChangeFloat:KBlackColor];
            nameLabel.font = Default_Font_15;
            [cell.contentView addSubview:nameLabel];
            
            UILabel *phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(nameLabel.frame)+8, SCREEN_WIDTH/2, 20)];
            phoneLabel.textColor = [UIColor hexChangeFloat:KGrayColor];
            phoneLabel.font = Default_Font_15;
            phoneLabel.text = array[indexPath.row][@"phoneNum"];
            [cell.contentView addSubview:phoneLabel];
            
            UILabel *relationLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-25-100, 0, 100, 70)];
            relationLabel.font = Default_Font_15;
            relationLabel.textAlignment = NSTextAlignmentRight;
            relationLabel.textColor = [UIColor hexChangeFloat:KBlueColor];
            relationLabel.text = array[indexPath.row][@"relation"];
            [cell.contentView addSubview:relationLabel];
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-20, (70-17)/2, 9, 17)];
            imageView.image = [UIImage imageNamed:@"销邦-楼盘详情页-右箭头"];
            [cell.contentView addSubview:imageView];
            
        }
        
        
    }
    else if (indexPath.section == 3)
    {
        if (_m_textView == nil) {
            _m_textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-20, 100)];
            _m_textView.font = Default_Font_15;
            _m_textView.delegate = self;
            
            
            placeStr = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, SCREEN_WIDTH-20, 20)];
            placeStr.text = @"备注";
            placeStr.textColor = [UIColor hexChangeFloat:KGrayColor];
            placeStr.font = Default_Font_15;
            [_m_textView addSubview:placeStr];
        }
        [cell.contentView addSubview:_m_textView];
    }
    else
    {
        if (indexPath.row == 0)
        {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-35, 50)];
            label.text = @"请选择意向房源";
            label.textColor = [UIColor hexChangeFloat:@"ff4c51"];
            label.font = Default_Font_15;
            [cell.contentView addSubview:label];
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-25, (50-17)/2, 9, 17)];
            imageView.image = [UIImage imageNamed:@"销邦-楼盘详情页-右箭头"];
            [cell.contentView addSubview:imageView];
        }
        else
        {
            UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-20, 50)];
            titleLabel.font = Default_Font_15;
            titleLabel.textColor = [UIColor hexChangeFloat:KGrayColor];
            
            titleLabel.text = [NSString stringWithFormat:@"%@",[self.info[indexPath.row -1] objectForKey:@"name"]];
            
            [cell.contentView addSubview:titleLabel];
        }
    }
    
    return cell;
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length > 0)
    {
        placeStr.hidden = YES;
    }
    else
    {
        placeStr.hidden = NO;
    }
}

#pragma Mark --输入号码长度限制
- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField == iphone) {
        if (textField.text.length > 11) {
            textField.text = [textField.text substringToIndex:11];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 3)
    {
        return 100;
    }
    else if (indexPath.section == 2)
    {
        NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
        NSArray * array = [userInfo objectForKey:@"relationClient"];
        if (indexPath.row == array.count)
        {
            return 45;
        } else {
            return 70;
        }
        
    }
    else
    {
        return 50;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0 || section == 3)
    {
        return 1;
    } else if (section == 1)
    {
        return 2;
    }
    else if (section == 2)
    {
        NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
        NSArray * array = [userInfo objectForKey:@"relationClient"];
        return array.count+1;
    }
    else if (section == 4)
    {
        if (self.info.count != 0)
        {
            return self.info.count+1;
        } else {
            return 1;
        }
    }
    else
    {
        return 3;//关联客户数量 + 1
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 4)
    {
        return 140;
    }
//    else if (section == 1)
//    {
//        return 40;
//    }
    else
    {
        return 12;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 1)
    {
//        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
//        view.backgroundColor = [UIColor hexChangeFloat:@"f2f2f2"];
//        
//        UILabel *lanenl = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 40)];
//        lanenl.text = @"关联客户";
//        lanenl.textColor = [UIColor hexChangeFloat:KGrayColor];
//        lanenl.font = Default_Font_15;
//        [view addSubview:lanenl];
//        return view;

        return nil;
    }
    else if (section == 4)
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 140)];
        view.backgroundColor = [UIColor hexChangeFloat:@"f2f2f2"];
        
//        //是否通知客户
//        if (smsButton == nil)
//        {
//            smsButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 120, 30)];
//            [smsButton setImage:[UIImage imageNamed:@"销邦-推荐客户-单选按钮"] forState:UIControlStateNormal];
//            [smsButton setTitle:@"是否通知客户" forState:UIControlStateNormal];
//            [smsButton setTitleColor:[UIColor hexChangeFloat:KGrayColor] forState:UIControlStateNormal];
//            smsButton.titleLabel.font = Default_Font_15;
//            smsButton.tag = 100;
//            [smsButton addTarget:self action:@selector(YesOrNo:) forControlEvents:UIControlEventTouchUpInside];
//            isSms = 0;
//        }
//        [view addSubview:smsButton];
        
        //提交推荐按钮
        UIButton *sendButotn = [[UIButton alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(smsButton.frame)+15, SCREEN_WIDTH-20, 40)];
        sendButotn.layer.cornerRadius = 5;
        sendButotn.layer.masksToBounds = YES;
        sendButotn.backgroundColor = [UIColor hexChangeFloat:@"ff4c51"];
        [sendButotn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [sendButotn setTitle:@"提交推荐" forState:UIControlStateNormal];
        [sendButotn addTarget:self action:@selector(sendBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:sendButotn];
        
        
        return view;
    }
    else
    {
        return nil;
    }
}

- (void)YesOrNo:(UIButton *)sender
{
    if ([sender.imageView.image isEqual:[UIImage imageNamed:@"销邦-推荐客户-单选按钮"]])
    {
        [sender setImage:[UIImage imageNamed:@"销邦-推荐客户-单选按钮选中"] forState:UIControlStateNormal];
        isSms = 1;
    } else {
        [sender setImage:[UIImage imageNamed:@"销邦-推荐客户-单选按钮"] forState:UIControlStateNormal];
        isSms = 0;
    }
}

#pragma mark --提交推荐
- (void)sendBtnClick
{
    [self.view endEditing:YES];
    
    if (![self checkContactInfo])
    {
        return;
    }
    else if (self.info.count==0)
    {
        [self.view makeToast:@"请添加推荐意向房源"];
        return ;
    }
    else
    {
        //意向房源
        NSMutableArray * paramArray = [NSMutableArray array];
        for (int i = 0 ; i < self.info.count; i ++)
        {
//            NSLog(@"%@", self.info);
            NSMutableDictionary * param = [NSMutableDictionary dictionary];
            NSNumber * number = [self.info[i] objectForKey:@"id"];
            [param setObject:number forKey:@"propertyId"];
            [param setObject:clientName.text forKey:@"name"];
            [param setObject:iphone.text forKey:@"phone"];
            [param setObject:self.m_textView.text forKey:@"xremark"];
            NSNumber * sex =  [NSNumber numberWithInteger:sexSegment.selectedSegmentIndex];
            [param setObject:sex forKey:@"sex"];
            
            [paramArray addObject:param];
        }
        
        NSData *jsonData = [ProjectUtil JSONString:paramArray];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                     encoding:NSUTF8StringEncoding];
        
        //关联客户
        NSMutableArray * paramArray1 = [NSMutableArray array];
        NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
        NSArray * array = [userInfo objectForKey:@"relationClient"];
        for (int i = 0; i < array.count; i++)
        {
            NSMutableDictionary * param1 = [NSMutableDictionary dictionary];
            [param1 setObject:array[i][@"name"] forKey:@"name"];
            [param1 setObject:array[i][@"phoneNum"] forKey:@"Phone"];
            [param1 setObject:array[i][@"relation"] forKey:@"relation"];
            [paramArray1 addObject:param1];
        }
        
        NSData *jsonData1 = [ProjectUtil JSONString:paramArray1];
        NSString *jsonString1 = [[NSString alloc] initWithData:jsonData1
                                                      encoding:NSUTF8StringEncoding];
        
        [self requestAddRec:jsonString andString:jsonString1];
    }
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


#pragma mark - 推荐完成信息接口
-(void)requestAddRec:(NSString *)jsonStr andString:(NSString *)jsonStr1
{
    
    //    NSData *jsonData = [ProjectUtil JSONString:infoArray];
    //    NSString *jsonString = [[NSString alloc] initWithData:jsonData
    //                                                 encoding:NSUTF8StringEncoding];
    
    NSString *noticeFriend = @"0";
    if (isSms == 1) {
        noticeFriend = @"1";
    }
    
    NSDictionary *dict = @{@"recommandInfos":jsonStr,
                           @"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"Login_User_token"],
                           @"isSms":noticeFriend,
                           @"relations":jsonStr1
                           };
    
    RequestInterface *requestHOp = [[RequestInterface alloc] init];
    [requestHOp requestAddRecWithParam:dict];
    
    [self.view makeProgressViewWithTitle:@"正在推荐"];
    [requestHOp getInterfaceRequestObject:^(id data) {
        [self.view hideProgressView];
        
        [ProjectUtil showLog:@"data = %@",data];
        
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
                alert.tag = 10000;
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
    if (alertView.tag == 10000)
    {
        //关闭
        if (buttonIndex == 0)
        {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        //去看看
        else
        {
//            [self.tabBarController setSelectedIndex:1];
            
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
    else
    {
        if (buttonIndex == 1)
        {
            NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
            NSArray * array = [userInfo objectForKey:@"relationClient"];
            
            NSMutableArray *arr = [NSMutableArray arrayWithArray:array];
            [arr removeObjectAtIndex:alertView.tag];
            [userInfo setObject:arr forKey:@"relationClient"];
            [userInfo synchronize];
            
            [self.m_tabelView reloadData];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
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
    
    //请选择意向房源
    if (indexPath.section == 4 && indexPath.row == 0)
    {
        
        UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        RecommendPropertyViewController * recommend = [storyboard instantiateViewControllerWithIdentifier:@"RecommendPropertyViewController"];
        recommend.recommendDelegate = self;
        recommend.choosenArr = self.info;

        [self.navigationController pushViewController:recommend animated:YES];
    }
    
    //添加关联客户
    
    NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
    NSArray * array = [userInfo objectForKey:@"relationClient"];
    if (indexPath.section == 2 && indexPath.row == array.count)
    {
        RelationClientViewController *vc = [[RelationClientViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        __block RecommandBuildViewController *test = self;
        vc.addBlick = ^(void){
            [test requestData];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.section == 2 && indexPath.row != array.count)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"解除关联" message:@"是否解除关联？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = indexPath.row;
        [alert show];
    }
}


//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (buttonIndex == 1)
//    {
//        NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
//        NSArray * array = [userInfo objectForKey:@"relationClient"];
//
//        NSMutableArray *arr = [NSMutableArray arrayWithArray:array];
//        [arr removeObjectAtIndex:alertView.tag];
//        [userInfo setObject:arr forKey:@"relationClient"];
//        [userInfo synchronize];
//
//        [self.m_tabelView reloadData];
//    }
//    else
//    {
//
//    }
//}

//添加推荐房源代理
- (void)addPropertyArrInfo:(NSArray *)propertyInfoArr
{
    self.info = [propertyInfoArr mutableCopy];
    [self.m_tabelView reloadData];
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


//将列表的分割线从头开始
//最新的，简便些
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 0)];
    }
    
    
    if (IOS_VERSION >= 8.0) {
        if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)])
        {
            [cell setPreservesSuperviewLayoutMargins:NO];
        }
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsMake(0, 10, 0, 0)];
        }
    }
}



@end
