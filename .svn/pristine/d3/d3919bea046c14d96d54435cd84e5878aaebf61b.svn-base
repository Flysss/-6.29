//
//  MyPurseViewController.m
//  SalesHelper_A
//
//  Created by summer on 15/7/28.
//  Copyright (c) 2015年 X. All rights reserved.
//

#import "MyPurseViewController.h"
#import "popTableView.h"
#import "UIScrollView+EmptyDataSet.h"
#import "WithdrawalPageViewController.h"
#import "AppConfig.h"
#import "SetDrawalStep1ViewController.h"
#import "BankCardViewController.h"
#import "ModelWebViewController.h"
#import "AddBankCardViewController.h"
#import "tixianVC.h"

@interface MyPurseViewController () <UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate,UIActionSheetDelegate,refreshDataDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *helpWebView;
@property (weak, nonatomic) IBOutlet UILabel *myMoney;

@property (weak, nonatomic) IBOutlet UILabel *totalMoney;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,retain)popTableView * listTableView;
@end

@implementation MyPurseViewController
{
    __weak IBOutlet UILabel *changeLabel;
    NSMutableArray *  dataSource;
    NSMutableArray * choosenTableSource;
    __weak IBOutlet UIView *tapForShowListView;
    BOOL isShow;//记录listView状态
    UIView * coverView;
    NSArray *accountArray;
    NSInteger pageIndex;
    NSString * typeNow;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    pageIndex = 1;
    
    isShow = NO;
    typeNow = @"100";
    
    
    [self creatNaviControl];
    [self requestUserInfoo];
    [self requestRewardType];
    [self sendRequestWith:@"100" isFooter:NO];
    
    self.tableView.tableFooterView = [UIView new];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapForSHow)];
    [tapForShowListView addGestureRecognizer:tap];
    
    self.helpWebView.userInteractionEnabled = YES;
    UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapForHelp)];
    [self.helpWebView addGestureRecognizer:tap1];
    [self refreshingTableView];
    // Do any additional setup after loading the view.
}

#pragma mark --创建导航栏
- (void)creatNaviControl
{
    
    [self CreateCustomNavigtionBarWith:self leftItem:@selector(goBack:) rightItem:@selector(more:)];
    //创建标题
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-120)/2, 27, 120, 30)];
    titleLabel.text = @"我的钱包";
    titleLabel.font = Default_Font_20;
    [titleLabel setTextColor:[UIColor whiteColor]];
    //    [titleLabel sizeToFit];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.topView addSubview: titleLabel];
    [self.rightBtn setImage:[UIImage imageNamed:@"客邦-4我的-C1-3我的钱包-更多.png"] forState:UIControlStateNormal];
    
    
//    UIImage * image = [UIImage imageNamed:@"客邦-4我的-C1-3我的钱包-更多.png"];
//    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0,0,27,27)];
//    [rightButton setImage:image forState:UIControlStateNormal];
//    [rightButton setImage:[UIImage imageByApplyingAlpha:image] forState:UIControlStateHighlighted];
//    [rightButton addTarget:self action:@selector(more:)forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem * buttonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
//    self.navigationItem.rightBarButtonItem = buttonItem;
//    
//    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn.frame=CGRectMake(0, 0, 26, 26);
//    [btn setBackgroundImage:[UIImage imageNamed:@"首页-左箭头.png"] forState:UIControlStateNormal];
//    [btn setImage:[UIImage imageByApplyingAlpha:[UIImage imageNamed:@"首页-左箭头.png"]] forState:UIControlStateHighlighted];
//    [btn addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem * left = [[UIBarButtonItem alloc] initWithCustomView:btn];
//    self.navigationItem.leftBarButtonItem = left;

}
-(void)refreshingTableView
{
    //下拉刷新
    __block  MyPurseViewController * h = self;
    [_tableView addHeaderWithCallback:^{
        [_tableView headerEndRefreshing];
        [h refreshingHeaderTableView];
    }];
    //上拉加载
    [_tableView addFooterWithCallback:^{
        [h refreshingFooterTableView];
    }];
}

-(void)refreshingHeaderTableView
{
    pageIndex = 1;
    [self sendRequestWith:typeNow isFooter:NO];
}

-(void)refreshingFooterTableView
{
    [self sendRequestWith:typeNow isFooter:YES];
}

-(void)tapForSHow
{
    if (!isShow)
    {
        popTableView * table = [[popTableView alloc]initWithFrame:CGRectMake(0, self.tableView.frame.origin.y, self.view.width, 0)];
        table.alignment = popTableViewCellAlignmentLCenter;
        table.DataSource_0314 = choosenTableSource;
        coverView = [[UIView alloc]initWithFrame:CGRectMake(0,self.tableView.frame.origin.y + (44 * 5), self.view.width,self.view.height - 104 + (44 * 5))];
        coverView.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.5];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapForHidden)];
        [coverView addGestureRecognizer:tap];
        coverView.userInteractionEnabled = YES;
        self.listTableView = table;
        [UIView animateWithDuration:0.3 animations:^{
            self.listTableView.frame =CGRectMake(0, self.tableView.frame.origin.y, self.view.width, 44 * 5);
        } completion:^(BOOL finished) {
            
        }];
        [self.view addSubview:table];
        [self.view addSubview:coverView];
        self.tableView.hidden = YES;
        isShow = YES;
        
        typeof(self)WS = self;
        [self.listTableView CellSelected:^(NSDictionary *dic) {
            changeLabel.text = [dic objectForKey:@"name"];
            [WS.listTableView removeFromSuperview];
            [coverView removeFromSuperview];
            WS.tableView.hidden = NO;
            NSString * str = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
            typeNow = str;
            pageIndex = 1;
            [WS sendRequestWith:str isFooter:NO];
            isShow = NO;
        }];
         
    }else{
        isShow = NO;
        self.tableView.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            self.listTableView.frame =CGRectMake(0, self.tableView.frame.origin.y, self.view.width, 0);
        } completion:^(BOOL finished) {
            [self.listTableView removeFromSuperview];
        }];
        [coverView removeFromSuperview];
    }
    
}
- (void)tapForHidden
{
    isShow = NO;
    self.tableView.hidden = NO;
    [self.listTableView removeFromSuperview];
    [coverView removeFromSuperview];
}

-(void)requestUserInfoo
{
    //请求用户信息
    RequestInterface *request = [[RequestInterface alloc]init];
    [request requestGetReferInfoWithParam:@{@"token":self.login_user_token}];
    [self.view makeProgressViewWithTitle:@"正在更新数据"];
    [request getInterfaceRequestObject:^(id data) {
        [self.view hideProgressView];
        if ([[data objectForKey:@"success"] boolValue])
        {
//            NSLog(@"%@",data);
            self.myMoney.text = [NSString stringWithFormat:@"%@",[data objectForKey:@"datas"][@"availableReward"]];
            NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:self.myMoney.text forKey:@"myMoney"];
            [defaults synchronize];
            NSString * numberStr = [NSString stringWithFormat:@"%@",[data objectForKey:@"datas"][@"reward"]];
            NSString* strfloat = [NSString stringWithFormat:@"%@",numberStr];
            self.totalMoney.text=strfloat;
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

-(void)requestRewardType
{
    
    RequestInterface *requestMoney = [[RequestInterface alloc] init];
    [requestMoney requestRewardTypeWithparam:nil];
    
    [requestMoney getInterfaceRequestObject:^(id data) {
        if ([data[@"success"]boolValue]) {
            
            NSLog(@"%@",data);
            choosenTableSource =[NSMutableArray array];
            
            choosenTableSource=[data objectForKey:@"datas"];
            
            self.tableView.emptyDataSetSource = self;
            
            self.tableView.emptyDataSetDelegate = self;
            
        }
    } Fail:^(NSError *error) {
        NSLog(@"失败了");
    }];
    
}

- (void)sendRequestWith:(NSString *)type isFooter:(BOOL)foot
{
    if (foot) {
        pageIndex++;
    }
    NSDictionary* dic=@{@"token":self.login_user_token,
                        @"type":type,
                        @"page":[NSNumber numberWithInteger:pageIndex],
                        @"size":@"10"
                        };
    RequestInterface *requestMoney = [[RequestInterface alloc] init];
    [requestMoney requestGetRewardByRWithParam:dic];
    [requestMoney getInterfaceRequestObject:^(id data) {
        if ([data[@"success"]boolValue])
        {
            NSLog(@"page %@",data);
            if (!foot) {
                dataSource = [NSMutableArray array];
                dataSource =[NSMutableArray arrayWithArray:[data objectForKey:@"datas"]] ;
            } else {
                [dataSource addObjectsFromArray:[data objectForKey:@"datas"]];
                NSArray * arr = [data objectForKey:@"datas"];
                if (arr.count == 0) {
                    [self.view makeToast:@"暂无数据"];
                    pageIndex--;
                }
            }
            [self.tableView footerEndRefreshing];
            [self.tableView reloadData];
        } else {
            [self.tableView footerEndRefreshing];
            pageIndex--;
        }
    } Fail:^(NSError *error) {
        [self.tableView footerEndRefreshing];
        pageIndex--;
//        NSLog(@"失败了");
    }];
}



#pragma mark  - UITableViewDelegate && UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  72;
}
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

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = nil;
    
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"cell3" forIndexPath:indexPath];
    
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell3"];
    }
    
    UILabel * namelabel = (UILabel *)[cell.contentView viewWithTag:10];
    //签约
    UILabel * statusLabel= (UILabel *)[cell.contentView viewWithTag:11];
    
    //签约时间
    UILabel * timeLabel = (UILabel *)[cell.contentView viewWithTag:12];
    
    //获得佣金金额
    UILabel * moneyLabel = (UILabel *)[cell.contentView viewWithTag:13];
    
    if (dataSource.count != 0)
    {
        if ([dataSource[indexPath.row] objectForKey:@"name"] !=[NSNull null] &&
            [dataSource[indexPath.row]objectForKey:@"name"]!=nil &&
            [dataSource[indexPath.row]objectForKey:@"name"])
        {
            namelabel.text=[dataSource[indexPath.row]objectForKey:@"name"];
            
        }else{
            namelabel.text=@"";

        }
        NSUserDefaults* defaults=[NSUserDefaults standardUserDefaults];
        
        /////  //   佣金
        if ([[dataSource[indexPath.row]objectForKey:@"rewardType"] integerValue] == 2 ) {
            
            statusLabel.text=@"提现";
            
            moneyLabel.text=[NSString stringWithFormat:@"-%.2f",[[dataSource[indexPath.row] objectForKey:@"reward"] floatValue]];
            moneyLabel.textColor = [ProjectUtil colorWithHexString:@"52a346"];
            timeLabel.text = [dataSource[indexPath.row]objectForKey:@"regDate"];
            
        }
        else if ([[dataSource[indexPath.row]objectForKey:@"rewardType"]integerValue] == 1)
        {
            statusLabel.text=@"邀请";
            
            timeLabel.text=[dataSource[indexPath.row] objectForKey:@"regDate"];
            
            NSString* str005=[NSString stringWithFormat:@"%@",[dataSource[indexPath.row] objectForKey:@"userId"]];
            
            NSString* str=[NSString stringWithFormat:@"%@",[defaults objectForKey:@"id"] ];
            if ([str005 isEqualToString:str])
            {
                moneyLabel.text = [NSString stringWithFormat:@"+%.2f",[[dataSource[indexPath.row] objectForKey:@"reward"] floatValue]];
                
            }
            else
            {
                if ([dataSource[indexPath.row] objectForKey:@"invitReward"] != [NSNull null] &&
                    [dataSource[indexPath.row] objectForKey:@"invitReward"] != nil &&
                    [dataSource[indexPath.row] objectForKey:@"invitReward"])
                {
                moneyLabel.text=[NSString stringWithFormat:@"+%.2f",[[dataSource[indexPath.row] objectForKey:@"invitReward"] floatValue]];
                }
            }
            moneyLabel.textColor = [ProjectUtil colorWithHexString:@"e93a3b"];

            
        }
        else if ([[dataSource[indexPath.row]objectForKey:@"rewardType"] integerValue]== 0)
        {
            statusLabel.text=@"成交";
            timeLabel.text=[dataSource[indexPath.row] objectForKey:@"regDate"];
            
            NSString* str007=[NSString stringWithFormat:@"%@",[dataSource[indexPath.row] objectForKey:@"userId"]];
            NSString* str=[NSString stringWithFormat:@"%@",[defaults objectForKey:@"id"] ];
            
            
            if ([str007 isEqualToString:str]) {
                moneyLabel.text=[NSString stringWithFormat:@"+%.2f",[[dataSource[indexPath.row]objectForKey:@"reward"] floatValue]];
                
            }
            else
            {
                if ([dataSource[indexPath.row] objectForKey:@"invitReward"] != [NSNull null] &&
                    [dataSource[indexPath.row] objectForKey:@"invitReward"] != nil &&
                    [dataSource[indexPath.row] objectForKey:@"invitReward"])
                {
                    moneyLabel.text=[NSString stringWithFormat:@"+%.2f",[[dataSource[indexPath.row] objectForKey:@"invitReward"] floatValue]];
                }

            }
            moneyLabel.textColor = [ProjectUtil colorWithHexString:@"e93a3b"];
            
        }
        else if ([[dataSource[indexPath.row]objectForKey:@"rewardType"] integerValue] == 3)
        {
            timeLabel.text=[dataSource[indexPath.row] objectForKey:@"regDate"];
            
            NSString* str007=[NSString stringWithFormat:@"%@",[dataSource[indexPath.row] objectForKey:@"userId"]];
            NSString* str=[NSString stringWithFormat:@"%@",[defaults objectForKey:@"id"] ];
            
            if ([str007 isEqualToString:str]) {
                moneyLabel.text=[NSString stringWithFormat:@"+%.2f",[[dataSource[indexPath.row]objectForKey:@"reward"] floatValue]];
                if ([dataSource[indexPath.row] objectForKey:@"typeName"] != [NSNull null] &&
                    [dataSource[indexPath.row] objectForKey:@"typeName"] != nil &&
                    [dataSource[indexPath.row] objectForKey:@"typeName"])
                {
                    statusLabel.text=[dataSource[indexPath.row] objectForKey:@"typeName"];
                }
                
                
            }else{
                moneyLabel.text=[NSString stringWithFormat:@"+%.2f",[[dataSource[indexPath.row] objectForKey:@"invitReward"] floatValue]];
                if ([dataSource[indexPath.row] objectForKey:@"codeTypeName"] != [NSNull null] &&
                    [dataSource[indexPath.row] objectForKey:@"codeTypeName"] != nil &&
                    [dataSource[indexPath.row] objectForKey:@"codeTypeName"])
                {
                statusLabel.text=[dataSource[indexPath.row] objectForKey:@"codeTypeName"];
                }
            }
            moneyLabel.textColor = [ProjectUtil colorWithHexString:@"e93a3b"];

        }
        else if ([[dataSource[indexPath.row]objectForKey:@"rewardType"]integerValue] == 4){
            timeLabel.text=[dataSource[indexPath.row] objectForKey:@"regDate"];
            
            NSString* str007=[NSString stringWithFormat:@"%@",[dataSource[indexPath.row] objectForKey:@"userId"]];
            NSString* str=[NSString stringWithFormat:@"%@",[defaults objectForKey:@"id"] ];
            if ([str007 isEqualToString:str]) {
                moneyLabel.text=[NSString stringWithFormat:@"+%.2f",[[dataSource[indexPath.row]objectForKey:@"reward"] floatValue]];
                
                if ([dataSource[indexPath.row] objectForKey:@"typeName"] != [NSNull null] &&
                    [dataSource[indexPath.row] objectForKey:@"typeName"] != nil &&
                    [dataSource[indexPath.row] objectForKey:@"typeName"])
                {
                    statusLabel.text=[dataSource[indexPath.row] objectForKey:@"typeName"];
                }

            }
            else
            {
                if ([dataSource[indexPath.row] objectForKey:@"invitReward"] != [NSNull null] &&
                    [dataSource[indexPath.row] objectForKey:@"invitReward"] != nil &&
                    [dataSource[indexPath.row] objectForKey:@"invitReward"])
                {
                    moneyLabel.text=[NSString stringWithFormat:@"+%.2f",[[dataSource[indexPath.row] objectForKey:@"invitReward"] floatValue]];
                }
                
                if ([dataSource[indexPath.row] objectForKey:@"codeTypeName"] != [NSNull null] &&
                    [dataSource[indexPath.row] objectForKey:@"codeTypeName"] != nil &&
                    [dataSource[indexPath.row] objectForKey:@"codeTypeName"])
                {
                    statusLabel.text=[dataSource[indexPath.row] objectForKey:@"codeTypeName"];
                }

            }
            moneyLabel.textColor = [ProjectUtil colorWithHexString:@"e93a3b"];

            
        }
        else{
            timeLabel.text = [dataSource[indexPath.row]objectForKey:@"regDate"];
            moneyLabel.text = [NSString stringWithFormat:@"+%.2f",[[dataSource[indexPath.row]objectForKey:@"reward"] floatValue]];
            moneyLabel.textColor = [ProjectUtil colorWithHexString:@"e93a3b"];
            namelabel.text = @"";
            if ([dataSource[indexPath.row] objectForKey:@"typeName"] != [NSNull null] &&
                [dataSource[indexPath.row] objectForKey:@"typeName"] != nil &&
                [dataSource[indexPath.row] objectForKey:@"typeName"])
            {
                statusLabel.text=[dataSource[indexPath.row] objectForKey:@"typeName"];
            }

        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
//if (dataSource.count != 0) {
//    if ([dataSource[indexPath.row] objectForKey:@"name"]==[NSNull null]||[dataSource[indexPath.row]objectForKey:@"name"]==nil) {
//        namelabel.text=@"";
//        
//    }else{
//        namelabel.text=[dataSource[indexPath.row]objectForKey:@"name"];
//    }
//    NSUserDefaults* defaults=[NSUserDefaults standardUserDefaults];
//    
//    /////  //   佣金
//    if ([[dataSource[indexPath.row]objectForKey:@"rewardType"]isEqualToString:@"2"] ) {
//        
//        statusLabel.text=@"提现";
//        
//        moneyLabel.text=[NSString stringWithFormat:@"-%@",[dataSource[indexPath.row]objectForKey:@"reward"]];
//        
//        timeLabel.text = [dataSource[indexPath.row]objectForKey:@"regDate"];
//        
//    }else if ([[dataSource[indexPath.row]objectForKey:@"rewardType"]isEqualToString:@"1"])
//    {
//        statusLabel.text=@"邀请";
//        
//        timeLabel.text=[dataSource[indexPath.row] objectForKey:@"regDate"];
//        
//        NSString* str005=[NSString stringWithFormat:@"%@",[dataSource[indexPath.row] objectForKey:@"userId"]];
//        
//        NSString* str=[NSString stringWithFormat:@"%@",[defaults objectForKey:@"id"] ];
//        if ([str005 isEqualToString:str]) {
//            moneyLabel.text=[NSString stringWithFormat:@"+%@",[dataSource[indexPath.row]objectForKey:@"reward"]];
//            
//        }else{
//            moneyLabel.text=[NSString stringWithFormat:@"+%@",[dataSource[indexPath.row] objectForKey:@"invitReward"]];
//        }
//        
//    }else if ([[dataSource[indexPath.row]objectForKey:@"rewardType"]isEqualToString:@"0"])
//    {
//        statusLabel.text=@"成交";
//        timeLabel.text=[dataSource[indexPath.row] objectForKey:@"regDate"];
//        
//        NSString* str007=[NSString stringWithFormat:@"%@",[dataSource[indexPath.row] objectForKey:@"userId"]];
//        NSString* str=[NSString stringWithFormat:@"%@",[defaults objectForKey:@"id"] ];
//        
//        
//        if ([str007 isEqualToString:str]) {
//            moneyLabel.text=[NSString stringWithFormat:@"+%@",[dataSource[indexPath.row]objectForKey:@"reward"]];
//            
//        }else{
//            moneyLabel.text=[NSString stringWithFormat:@"+%@",[dataSource[indexPath.row] objectForKey:@"invitReward"]];
//        }
//    }else if ([[dataSource[indexPath.row]objectForKey:@"rewardType"]isEqualToString:@"3"])
//    {
//        timeLabel.text=[dataSource[indexPath.row] objectForKey:@"regDate"];
//        
//        NSString* str007=[NSString stringWithFormat:@"%@",[dataSource[indexPath.row] objectForKey:@"userId"]];
//        NSString* str=[NSString stringWithFormat:@"%@",[defaults objectForKey:@"id"] ];
//        
//        
//        if ([str007 isEqualToString:str]) {
//            moneyLabel.text=[NSString stringWithFormat:@"+%@",[dataSource[indexPath.row]objectForKey:@"reward"]];
//            statusLabel.text=[dataSource[indexPath.row] objectForKey:@"typeName"];
//        }else{
//            moneyLabel.text=[NSString stringWithFormat:@"+%@",[dataSource[indexPath.row] objectForKey:@"invitReward"]];
//            statusLabel.text=[dataSource[indexPath.row] objectForKey:@"codeTypeName"];
//            
//        }
//    } else if ([[dataSource[indexPath.row]objectForKey:@"rewardType"]isEqualToString:@"4"]){
//        statusLabel.text=@"成交";
//        timeLabel.text=[dataSource[indexPath.row] objectForKey:@"regDate"];
//        
//        NSString* str007=[NSString stringWithFormat:@"%@",[dataSource[indexPath.row] objectForKey:@"userId"]];
//        NSString* str=[NSString stringWithFormat:@"%@",[defaults objectForKey:@"id"] ];
//        
//        
//        if ([str007 isEqualToString:str]) {
//            moneyLabel.text=[NSString stringWithFormat:@"+%@",[dataSource[indexPath.row]objectForKey:@"reward"]];
//            
//        }else{
//            moneyLabel.text=[NSString stringWithFormat:@"+%@",[dataSource[indexPath.row] objectForKey:@"invitReward"]];
//        }
//    }else{
//        timeLabel.text = [dataSource[indexPath.row]objectForKey:@"regDate"];
//        moneyLabel.text = [NSString stringWithFormat:@"+%@",[dataSource[indexPath.row]objectForKey:@"reward"]];
//        statusLabel.text = [dataSource[indexPath.row]objectForKey:@"typeName"];
//        if ([dataSource[indexPath.row]objectForKey:@"name"] != [NSNull null]) {
//            namelabel.text=[dataSource[indexPath.row]objectForKey:@"name"];
//        }
//    }
//}
//cell.selectionStyle = UITableViewCellSelectionStyleNone;
//return cell;

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = nil;
    UIFont *font = nil;
    UIColor *textColor = nil;
    
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    text = @"暂无数据 赶快去推荐客户赚钱吧";
    font =  Default_Font_12;
    textColor = [ProjectUtil colorWithHexString:@"808080"];
    
    if (!text) {
        return nil;
    }
    
    if (font) [attributes setObject:font forKey:NSFontAttributeName];
    if (textColor) [attributes setObject:textColor forKey:NSForegroundColorAttributeName];
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
    
}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"灰色.png"];
}

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//更多
- (IBAction)more:(id)sender {
    
    UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"提现",@"我的银行卡",@"提现密码", nil];
    [actionSheet showInView:self.view];
}

//提现 我的银行卡 提现密码 
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSUserDefaults* defaults=[NSUserDefaults standardUserDefaults];
    if (buttonIndex == 0) { //提现
        [self requestGetWithd];
        
    }
    if (buttonIndex == 1) { //我的银行卡
        BankCardViewController *bankVC = [[BankCardViewController alloc] init];
        bankVC.title = @"我的银行卡";
        bankVC.hidesBottomBarWhenPushed = YES;
//        [bankVC creatBackButtonWithPushType:Push With:self.title Action:nil];
        [self.navigationController pushViewController:bankVC animated:YES];
    }
    if (buttonIndex == 2) //提现密码
    {
        NSString * str = [defaults objectForKey:@"withdrawPwd"];
        if (str.length) {
            tixianVC * txianvc=[[tixianVC alloc]init];
            txianvc.hidesBottomBarWhenPushed=YES;
            txianvc.title=@"提现密码";
//            [txianvc creatBackButtonWithPushType:Present With:self.title Action:nil];
            [self.navigationController pushViewController:txianvc animated:YES];
        }else
        {
            SetDrawalStep1ViewController *setDrawVC = [[SetDrawalStep1ViewController alloc] init];
            setDrawVC.title = @"设置提现密码（1/3）";
            setDrawVC.isShowBank = NO;
            setDrawVC.hidesBottomBarWhenPushed = YES;
//            [setDrawVC creatBackButtonWithPushType:Present With:self.title Action:nil];
            [self.navigationController pushViewController:setDrawVC animated:YES];
        }
        
    }
}

//查询支付宝 和 银行卡账户
- (void)requestGetWithd
{
    //self.login_user_token = @"blGnqmPl3d70cHzfcplharUuxASR0A8J%0D%0A";
    
    NSUserDefaults* defaults=[NSUserDefaults standardUserDefaults];
    NSDictionary *dict =@{@"token":self.login_user_token,
                          @"page":@"1",
                          @"size":@"10000"
                          };
    
    RequestInterface *requestOp = [[RequestInterface alloc] init];
    [requestOp requestGetWithdWithParam:dict];
    
    [requestOp getInterfaceRequestObject:^(id data)
     {
         
         if ([data[@"success"] boolValue])
         {
             accountArray = data[@"datas"];
             NSString * str = [defaults objectForKey:@"withdrawPwd"];
             NSArray * arr  = data[@"datas"];
             if(arr.count == 0 && !str.length)
             {
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您需要先设置提现密码，并绑定银行卡才可以提现" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:@"去设置", nil];
                 alert.tag = 800;
                 [alert show];
                 return ;
             }
             if (accountArray.count == 0) {
                 
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您需要先绑定银行卡才可以提现" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:@"去设置", nil];
                 alert.tag = 900;
                 [alert show];
             }else{
                 if (str.length) {
                     WithdrawalPageViewController* drawnpageVC=[[WithdrawalPageViewController alloc]init];
                     drawnpageVC.title=@"提现";
                     drawnpageVC.moneyStr=_myMoney.text;
                     drawnpageVC.delegate = self;
                     
                     [self.navigationController pushViewController:drawnpageVC animated:YES];
                     
                 }else{
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您需要先设置提现密码 才可以提现！" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:@"去设置", nil];
                     alert.tag = 800;
                     [alert show];
                 
                 }
             }
             //存数据--->基本数据类型
             [defaults setBool:NO forKey:@"SalesHelper_isNeedDrawal"];//是否需要设置提现账户
             [defaults synchronize];
             
         }
         
     } Fail:^(NSError *error)
     {
         // [self.view addGestureRecognizer:_reloadDataTap];
        // [self.view makeToast:HintWithNetError];
         
     }];
    
}



//点击提现警告框的代理方法

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 800) {
        if (buttonIndex == 1)
        {
            SetDrawalStep1ViewController *setDrawVC = [[SetDrawalStep1ViewController alloc] init];
            setDrawVC.title = @"设置提现密码（1/3）";
            if (accountArray.count == 0) {
                setDrawVC.isShowBank = YES;
            }
            [setDrawVC creatBackButtonWithPushType:Push With:self.title Action:nil];
            [self.navigationController pushViewController:setDrawVC animated:YES];
        }

    }
    
    if (alertView.tag==900) {
        if (buttonIndex==1) {
            AddBankCardViewController* addcard = [[AddBankCardViewController alloc] init];
            addcard.title = @"添加银行卡";
            addcard.hidesBottomBarWhenPushed = YES;
            [addcard creatBackButtonWithPushType:Push With:self.title Action:nil];
            [self.navigationController pushViewController:addcard animated:YES];
        }
    }
    
}

- (void)tapForHelp
{
    ModelWebViewController * web = [[ModelWebViewController alloc] initWithUrlString:@"http://app.xiaobang.cc/fangduobang/tixian/" NavigationTitle:@"提现说明"];
    web.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:web animated:YES];
}
#pragma mark - refreshDataDelegate
-(void)refresh
{
    [self requestUserInfoo];
    [self requestRewardType];
}
-(void)dealloc
{
    NSLog(@"我的钱包销毁了");
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
