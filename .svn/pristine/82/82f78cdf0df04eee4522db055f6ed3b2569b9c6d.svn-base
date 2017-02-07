//
//  ApplyVisitViewController.m
//  SalesHelper_A
//
//  Created by Brant on 16/1/11.
//  Copyright (c) 2016年 X. All rights reserved.
//

#import "ApplyVisitViewController.h"
#import "SelectClientViewController.h"
#import "ApplyVisitTableViewCell.h"
#import "HMSegmentedControl.h"
#import "TimeLineViewController.h"


@interface ApplyVisitViewController () <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) UITableView *m_tableView;
@property (nonatomic, strong) NSMutableArray *dataSourceArr;

@end

@implementation ApplyVisitViewController
{
    int pageNum;
   
    NSMutableArray * bigDataArr;
    NSMutableArray * pageIndexArr;
    NSMutableArray * pageDataSource;
    
    UILabel *backLabel;
    
    UILabel *lineLabel1;
    BOOL isBack;
//    NSInteger selectButton;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = YES;
    
    if (!isBack)
    {
       [_m_tableView headerBeginRefreshing];
    }
   
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    isBack = NO;
    pageNum = 1;
    self.dataSourceArr = [NSMutableArray arrayWithCapacity:0];
    self.selectButton = 0;
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi:) name:@"refreshApply" object:nil];
    
    [self creatNaviControl];
    
    [self creatTableView];
    
    [self creatBottomView];
    
    [self requestDataHeaderFresh:YES andType:0];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)tongzhi:(NSNotification *)text
{
    NSInteger x = [text.userInfo[@"selectType"] integerValue] * SCREEN_WIDTH/4 + (SCREEN_WIDTH/8-30);
    lineLabel1.frame = CGRectMake(x, 64+46, 60, 4);
    self.selectButton = [text.userInfo[@"selectType"] integerValue];
    [self requestDataHeaderFresh:YES andType:[text.userInfo[@"selectType"] integerValue]];
}

#pragma mark --设置导航栏
- (void)creatNaviControl
{
    [self CreateCustomNavigtionBarWith:self leftItem:@selector(popTopView) rightItem:nil];
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-120)/2, 27, 120, 30)];
    titleLabel.text = @"申请记录";
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
    NSArray *titleArray = @[@"到 访",@"认 筹",@"认 购",@"签 约"];
    for (int i = 0; i<4; i++)
    {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i*SCREEN_WIDTH/4, 64, SCREEN_WIDTH/4, 50)];
        button.tag = i;
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor hexChangeFloat:KBlackColor] forState:UIControlStateNormal];
        button.titleLabel.font = Default_Font_15;
        [button addTarget:self action:@selector(clickSegBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
    
    UILabel * lineLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 64+49.5, SCREEN_WIDTH, 0.5)];
    lineLabel2.backgroundColor = [UIColor hexChangeFloat:@"d1d1d1"];
    [self.view addSubview:lineLabel2];
    
    lineLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/8-30, 46+64, 60, 4)];
    lineLabel1.backgroundColor = [UIColor hexChangeFloat:KBlueColor];
    [self.view addSubview:lineLabel1];
    
    backLabel =[[UILabel alloc] initWithFrame:CGRectMake(0,64, SCREEN_WIDTH, SCREEN_HEIGHT-64-50)];
    backLabel.text = @"暂无申请记录";
    backLabel.font = Default_Font_16;
    backLabel.textColor = [UIColor hexChangeFloat:KGrayColor];
    backLabel.textAlignment = NSTextAlignmentCenter;
    backLabel.hidden = YES;
    [self.view addSubview:backLabel];
    
    _m_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64+50, SCREEN_WIDTH, SCREEN_HEIGHT-64-50-50) style:UITableViewStyleGrouped];
    _m_tableView.delegate = self;
    _m_tableView.dataSource = self;
    _m_tableView.tableFooterView = [[UIView alloc] init];
    _m_tableView.backgroundColor = [UIColor whiteColor];
    _m_tableView.contentInset = UIEdgeInsetsMake(-0.5, 0, 0, 0);
    [self.view addSubview:_m_tableView];
    
    [self loadGesture];
    [self tableViewConfig];
}

- (void)clickSegBtn:(UIButton *)sender
{
    self.selectButton = sender.tag;
    NSInteger x = sender.tag * SCREEN_WIDTH/4 + (SCREEN_WIDTH/8-30);
    lineLabel1.frame = CGRectMake(x, 46+64, 60, 4);
    [self requestDataHeaderFresh:YES andType:sender.tag];
    
}

#pragma mark --加载收拾
- (void)loadGesture
{
    self.view.userInteractionEnabled = YES;
    
    UISwipeGestureRecognizer *swipeGesture=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGesture)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeGesture];
    
    UISwipeGestureRecognizer *swipeLeftGesture=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftHandleSwipeGesture)];
    swipeLeftGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view  addGestureRecognizer:swipeLeftGesture];
}

#pragma mark --向左滑动
- (void)handleSwipeGesture
{
    if (self.selectButton< 3)
    {
        self.selectButton ++;
        NSInteger x = self.selectButton * SCREEN_WIDTH/4 + (SCREEN_WIDTH/8-30);
        lineLabel1.frame = CGRectMake(x, 64+46, 60, 4);
        [self requestDataHeaderFresh:YES andType:self.selectButton];
        
    }
}
#pragma mark --向右滑动
- (void)leftHandleSwipeGesture
{
    if (self.selectButton>0)
    {
        self.selectButton --;
        NSInteger x = self.selectButton * SCREEN_WIDTH/4 + (SCREEN_WIDTH/8-30);
        lineLabel1.frame = CGRectMake(x,64+46, 60, 4);
        [self requestDataHeaderFresh:YES andType:self.selectButton];
        
    }
}

- (void)changeState:(UIButton *)sender
{
    if (sender.tag == 110)
    {
        
    }
    else if (sender.tag == 111)
    {
        
    }
    else if (sender.tag == 112)
    {
        
    }
    else
    {
        
    }
}

- (void)requestDataHeaderFresh:(BOOL)head andType:(NSInteger)selectType
{
    if (head) {
        pageNum = 1;
    } else {
        pageNum++;
    }
    
    NSInteger type;
    if (selectType == 0)
    {
        type = 19;
    }
    else if (selectType == 1)
    {
        type = 9;
    }
    else if (selectType == 2)
    {
        type = 20;
    }
    else
    {
        type = 10;
    }
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"Login_User_token"];
    NSDictionary *dic = @{@"token":token,
                          @"page":[NSString stringWithFormat:@"%d", pageNum],
                          @"applicantStage":[NSNumber numberWithInteger:type]};

//    [self.view Loading_0314];
    RequestInterface *interFace = [[RequestInterface alloc] init];
    [interFace requestVisitHostoryWithDic:dic];
    [interFace getInterfaceRequestObject:^(id data) {
//        [self.view Hidden];
        if (data[@"success"])
        {
            if (head)
            {
                NSLog(@"%@", data);
                
                pageNum = 1;
                [self.dataSourceArr removeAllObjects];
                [self.dataSourceArr addObjectsFromArray:data[@"datas"]];
                
                if ([data[@"datas"] count] == 0)
                {
                    self.m_tableView.hidden = YES;
                    backLabel.hidden = NO;
                }
                else
                {
                    self.m_tableView.hidden = NO;
                    backLabel.hidden = YES;
                }
            }
            else
            {
                [self.dataSourceArr insertObjects:data[@"datas"] atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(self.dataSourceArr.count, [data[@"datas"] count])]];
                if ([data[@"datas"] count] == 0)
                {
                    [self.view makeToast:@"没有更多数据了"];
                }
            }
        }
        else
        {
            [self.view makeToast:data[@"message"]];
        }
        
        [_m_tableView reloadData];
        [_m_tableView headerEndRefreshing];
        [_m_tableView footerEndRefreshing];
    } Fail:^(NSError *error) {
        [self.view Hidden];
        [self.view makeToast:@"网络错误"];
        [_m_tableView headerEndRefreshing];
        [_m_tableView footerEndRefreshing];
    }];
    
}

#pragma mark --列表刷新
- (void)tableViewConfig
{
    __block ApplyVisitViewController *h = self;
    
    //下拉刷新
    [_m_tableView addHeaderWithCallback:^{
        
        [h requestDataHeaderFresh:YES andType:h.selectButton];
    }];

    //上拉加载
    [_m_tableView addFooterWithCallback:^{
        [h requestDataHeaderFresh:NO andType:h.selectButton];
    }];
    
}

- (void)creatBottomView
{
    
    UIButton *wantApplyBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, SCREEN_HEIGHT-50, SCREEN_WIDTH-20, 40)];
    wantApplyBtn.backgroundColor = [UIColor hexChangeFloat:KBlueColor];
    [wantApplyBtn setTitle:@"我要申请" forState:UIControlStateNormal];
    [wantApplyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    wantApplyBtn.layer.cornerRadius = 5;
    wantApplyBtn.layer.masksToBounds = YES;
    
    [wantApplyBtn addTarget:self action:@selector(iwantAppply) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:wantApplyBtn];
}

#pragma mark --我要申请
- (void)iwantAppply
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"选择申请类别"
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"到访",@"认筹",@"认购",@"签约",nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];

}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != 4)
    {
        isBack = NO;
        SelectClientViewController *vc = [[SelectClientViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.selectType = buttonIndex;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ApplyVisitTableViewCell *cell = (ApplyVisitTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (!cell)
    {
        cell = [[ApplyVisitTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                              reuseIdentifier:[NSString stringWithFormat:@"%@", indexPath]];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell configTableViewWIthDic:self.dataSourceArr[indexPath.row]];
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSourceArr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TimeLineViewController *vc = [[TimeLineViewController alloc] init];
    isBack = YES;
    vc.propertyInfo = _dataSourceArr[indexPath.row];
    vc.timeLineID = _dataSourceArr[indexPath.row][@"recomid"];
    [self.navigationController pushViewController:vc animated:YES];
    
}

//将列表的分割线从头开始
//最新的，简便些
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
