//
//  MyWalletViewController.m
//  SalesHelper_A
//
//  Created by flysss on 16/4/22.
//  Copyright © 2016年 X. All rights reserved.
//

#import "MyWalletViewController.h"
#import "UIScrollView+EmptyDataSet.h"
#import "WithdrawalPageViewController.h"
#import "AppConfig.h"
#import "SetDrawalStep1ViewController.h"
#import "ModelWebViewController.h"
#import "AddBankCardViewController.h"
#import "tixianVC.h"
#import "popTableView.h"
#import "walletCell.h"

#import "BankCardViewController.h"

@interface MyWalletViewController ()<UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource,UIActionSheetDelegate,refreshDataDelegate>
@property (nonatomic, strong) UITableView * tableView;
//类型列表
@property (nonatomic, strong) popTableView * listTableView;

@property (nonatomic, strong) UILabel * totalMoney;

@property (nonatomic, strong) UILabel * myMoney;

@property (nonatomic, strong) UIImageView * helpWebView;

@property (nonatomic, strong) UIView * tapForShowListView;

@property (nonatomic, strong) UIButton * allBtn;

@end

@implementation MyWalletViewController
{
    NSMutableArray * dataSource;
    NSMutableArray * choosenTableSource;
    
    BOOL  isShow; //记录listview状态
    
    UIView * coverView;
    NSArray * accountArray;
    NSInteger pageIndex;
    NSString * typeNow;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    self.navigationController.navigationBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor whiteColor];
    pageIndex = 1;
    isShow = NO;
    typeNow = @"100";
    
    [self creatNaviControl];
    [self layoutSubViews];
    [self requestUserInfo];
    [self requestRewardType];
    [self sendRequestWith:@"100" isFooter:NO];
    [self refreshingTableView];
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
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.topView addSubview: titleLabel];
    [self.rightBtn setImage:[UIImage imageNamed:@"客邦-4我的-C1-3我的钱包-更多.png"] forState:UIControlStateNormal];
}
-(void)goBack:(UIButton*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
//更多
- (void)more:(UIButton*)sender {
    
    UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"提现",@"我的银行卡",@"提现密码", nil];
    [actionSheet showInView:self.view];
}

#pragma mark - refreshDataDelegate
-(void)refresh
{
    [self requestUserInfo];
    [self requestRewardType];
}

//布局子视图
-(void)layoutSubViews
{
    UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 120)];
    [self.view addSubview:bgView];
    bgView.userInteractionEnabled = YES;
    UIImageView * bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120)];
    bgImageView.image = [UIImage imageNamed:@"销邦-我的-我的钱包-背景.png"];
    [bgView addSubview:bgImageView];
    UILabel * checkLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 120, 20)];
    checkLab.text = @"可提现余额（元）";
    checkLab.textColor = [UIColor whiteColor];
    checkLab.font = Default_Font_15;
    [bgView addSubview:checkLab];
    
    self.helpWebView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-40, 10, 23, 23)];
    self.helpWebView.image = [UIImage imageNamed:@"销邦-我的-我的钱包-问号.png"];
    self.helpWebView.userInteractionEnabled = YES;
    UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapForHelp)];
    [self.helpWebView addGestureRecognizer:tap1];
    [bgView addSubview:self.helpWebView];
    
    self.totalMoney = [[UILabel alloc]initWithFrame:CGRectMake(10, 50, 500, 60)];
    self.totalMoney.textColor = [UIColor whiteColor];
    self.totalMoney.font = [UIFont fontWithName:@"STHeitiTC-Light" size:50];
    self.totalMoney.text = @"1000";
    [bgView addSubview:self.totalMoney];
    
    UIView * MyView = [[UIView alloc]initWithFrame:CGRectMake(0, 184, SCREEN_WIDTH, 44)];
    MyView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:MyView];
    self.myMoney = [[UILabel alloc]initWithFrame:CGRectMake(10, 12, SCREEN_WIDTH-20, 20)];
    self.myMoney.textColor = [UIColor lightGrayColor];
    self.myMoney.font = Default_Font_15;
    self.myMoney.text = @"我的资产总额 100 (元)";
    [MyView addSubview:self.myMoney];
    
    UIView * detailView = [[UIView alloc]initWithFrame:CGRectMake(0, 228, SCREEN_WIDTH, 44)];
    detailView.backgroundColor = [UIColor hexChangeFloat:@"f1f1f1"];
    [self.view addSubview:detailView];
    UILabel * detailLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 100, 30)];
    detailLab.text = @"钱包明细";
    detailLab.textColor = [UIColor hexChangeFloat:KQianheiColor];
    detailLab.font = Default_Font_15;
    [detailView addSubview:detailLab];
    
    self.allBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-80, 5, 75, 30)];
    [self.allBtn setTitleColor:[UIColor hexChangeFloat:KQianheiColor] forState:UIControlStateNormal];
    [self.allBtn setTitle:@"全部" forState:UIControlStateNormal];
    [self.allBtn setImage:[UIImage imageNamed:@"销邦-我的-我的钱包-所有.png"] forState:UIControlStateNormal];
    self.allBtn.titleLabel.font = Default_Font_15;
    [self.allBtn setTitleEdgeInsets:UIEdgeInsetsMake(0,5, 0, 13)];
    [self.allBtn setImageEdgeInsets:UIEdgeInsetsMake(5,62,5,0)];
    [self.allBtn addTarget:self action:@selector(tapForSHow) forControlEvents:UIControlEventTouchUpInside];
    [detailView addSubview:self.allBtn];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 272, SCREEN_WIDTH, SCREEN_HEIGHT-272) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[walletCell class] forCellReuseIdentifier:@"walletCell"];
    self.tableView.tableFooterView = [[UIView alloc]init];
    
}

//弹出类型列表
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
//            self.changeLabel.text = [dic objectForKey:@"name"];
            [self.allBtn setTitle:[dic objectForKey:@"name"] forState:UIControlStateNormal];
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

- (void)tapForHelp
{
    ModelWebViewController * web = [[ModelWebViewController alloc] initWithUrlString:@"http://app.xiaobang.cc/fangduobang/tixian/" NavigationTitle:@"提现说明"];
    web.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:web animated:YES];
}

-(void)refreshingTableView
{
    //下拉刷新
    __block  MyWalletViewController * h = self;
    
    [self.tableView addHeaderWithCallback:^{
        
        [h refreshingHeaderTableView];
        [h.tableView headerEndRefreshing];
    }];
    //上拉加载
    [self.tableView addFooterWithCallback:^{
        [h refreshingFooterTableView];
        [h.tableView footerEndRefreshing];
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

//请求个人信息
-(void)requestUserInfo
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
            self.myMoney.text = [NSString stringWithFormat:@"我的资产总额 %@ (元)",[data objectForKey:@"datas"][@"availableReward"]];
            
            NSMutableAttributedString * attributeStr = [[NSMutableAttributedString alloc]initWithString:self.myMoney.text];
            [attributeStr addAttribute:NSFontAttributeName value:Default_Font_17 range:NSMakeRange(7, self.myMoney.text.length-11)];
            [attributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(7, self.myMoney.text.length-11)];
            self.myMoney.attributedText = attributeStr;
            
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
//请求佣金类型
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
//请求数据
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
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    walletCell * cell = [tableView dequeueReusableCellWithIdentifier:@"walletCell" forIndexPath:indexPath];
    if (dataSource.count != 0)
    {
        [cell setAttributeForCellWithParam:dataSource[indexPath.row]];
    }
    return cell;
}

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
             }
             else
             {
                 if (str.length) {
                     WithdrawalPageViewController* drawnpageVC=[[WithdrawalPageViewController alloc]init];
                     drawnpageVC.title=@"提现";
                     drawnpageVC.moneyStr=_myMoney.text;
                     drawnpageVC.delegate = self;
                     
                     [self.navigationController pushViewController:drawnpageVC animated:YES];
                     
                 }
                 else
                 {
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

- (void)didReceiveMemoryWarning
{
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
