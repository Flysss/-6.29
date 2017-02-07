//
//  SearchViewController.m
//  SalesHelper_A
//
//  Created by Brant on 15/12/23.
//  Copyright (c) 2015年 X. All rights reserved.
//

#import "SearchViewController.h"
#import "UIColor+Extend.h"
//#import "CustmorStatusTableViewCell.h"
#import "QRCode.h"
#import "TimeLineViewController.h"

@interface SearchViewController () <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *m_tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation SearchViewController
{
    int page;
    NSString *keyWordStr;
    UIView * coverView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;

}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self CreateCustomNavigtionBarWith:self leftItem:@selector(backToView) rightItem:nil];
    //创建标题
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-120)/2, 27, 120, 30)];
    titleLabel.text = @"搜索";
    titleLabel.font = Default_Font_20;
    [titleLabel setTextColor:[UIColor whiteColor]];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.topView addSubview: titleLabel];

    self.view.backgroundColor = [UIColor whiteColor];
    
    page = 1;
    self.dataArray = [NSMutableArray arrayWithCapacity:1];
    keyWordStr = @"";

    
    //创建搜索框
    [self creatSearchBar];
    
    //创建列表
    [self creatTableView];
    
    
}

- (void)backToView
{

    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --创建搜索框
- (void)creatSearchBar
{
   
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0,64, SCREEN_WIDTH, 45)];
    searchBar.searchBarStyle = UISearchBarStyleMinimal;
    searchBar.placeholder = @"请输入搜索内容";
    searchBar.delegate = self;
    [self.view addSubview:searchBar];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,64+44.5, SCREEN_WIDTH, 0.5 )];
    label.backgroundColor = [UIColor hexChangeFloat:@"f2f2f2"];
    [self.view addSubview:label];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.view endEditing:YES];

    keyWordStr = searchBar.text;
    [self requestDataWith:searchBar.text andPage:1 isFooter:NO];
    
}

#pragma mark --请求数据
- (void)requestDataWith:(NSString *)keyWord andPage:(int)currentPage isFooter:(BOOL)footer
{
    //请求数据
    NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
    NSString *token = [userInfo objectForKey:@"Login_User_token"];
    
    NSDictionary *dict = @{@"token":token, @"page":[NSString stringWithFormat:@"%d", currentPage], @"size":@"10", @"keyWard":keyWord};
    [self.view Loading_0314];
    RequestInterface *request = [[RequestInterface alloc]init];
    [request requestSearchRecommentWithDic:dict];
    [request getInterfaceRequestObject:^(id data) {
        [self.view Hidden];
        
        NSLog(@"  \n%@", data[@"datas"]);
        if ([[data objectForKey:@"success"] boolValue])
        {
            if (!footer)
            {
                if (self.dataArray.count > 0)
                {
                    [self.dataArray removeAllObjects];
                }
//                [self.dataArray addObjectsFromArray:data[@"datas"]];
                if ([data[@"datas"] count] > 0)
                {
                    self.dataArray = [data[@"datas"] mutableCopy];

                } else {
                    [self.view makeToast:@"暂无数据"];
                }
            }
            else
            {
                
                if ([data[@"datas"] count] > 0)
                {
                    [self.dataArray insertObjects:data[@"datas"] atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(self.dataArray.count, [data[@"datas"] count])]];
                    [self.m_tableView footerEndRefreshing];
                }
                else
                {
                    [self.view makeToast:@"无更多数据"];
                    [self.m_tableView footerEndRefreshing];
                }
            }

            
            [self.m_tableView reloadData];
        }
        else
        {
            [self.view makeToast:@"加载失败"];
            [self.m_tableView footerEndRefreshing];
        }

    } Fail:^(NSError *error) {
        [self.view hideProgressView];
        [self.view makeToast:HintWithNetError];
        [self.m_tableView footerEndRefreshing];
    }];
}

#pragma mark --创建列表
- (void)creatTableView
{
    self.m_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 45+64, SCREEN_WIDTH, SCREEN_HEIGHT-64-45)];
    self.m_tableView.delegate = self;
    self.m_tableView.dataSource = self;
    self.m_tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.m_tableView];
    
    [self refreshingTableView];

    //添加上拉加载更多
//    [self.m_tableView addFooterWithTarget:self action:@selector(loadMoreData)];
}

-(void)refreshingTableView
{
    //下拉刷新
    __block  SearchViewController * h = self;
    
    //上拉加载
    [_m_tableView addFooterWithCallback:^{
        
        [h loadMoreData];
        
    }];
    
}
#pragma mark --加载更多
- (void)loadMoreData
{
    //判断是否有输入内容，如果没有提示输入内容，否则会崩掉
    if (keyWordStr == nil || keyWordStr.length == 0)
    {
        [self.view makeToast:@"请输入搜索内容"];
        [self.m_tableView footerEndRefreshing];
    } else {
        page ++;
        [self requestDataWith:keyWordStr andPage:page isFooter:YES];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"%@", indexPath]];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    //姓名
    NSString *nameStr = self.dataArray[indexPath.row][@"name"];
    CGFloat nameW = [nameStr boundingRectWithSize:CGSizeMake(0, 20) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.width;
    UILabel *nameLabel = [[UILabel alloc] init];

    if (nameW > 80)
    {
        nameLabel.frame = CGRectMake(10, 10, 80, 20);
    } else {
        nameLabel.frame = CGRectMake(10, 10, nameW, 20);
    }
    nameLabel.text = nameStr;
    nameLabel.font = Default_Font_15;
    nameLabel.textColor = [UIColor hexChangeFloat:KBlackColor];
    [cell.contentView addSubview:nameLabel];
    
    //号码
    UILabel *phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(nameLabel.frame)+5, 12, 110, 20)];
    phoneLabel.text = self.dataArray[indexPath.row][@"phone"];
    phoneLabel.font = Default_Font_15;
    phoneLabel.textColor = [UIColor lightGrayColor];
    [cell.contentView addSubview:phoneLabel];

    //楼盘名称
    UILabel *propertyLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(nameLabel.frame)+10, SCREEN_WIDTH/2-10, 20)];
    propertyLabel.text = self.dataArray[indexPath.row][@"propertyName"];
    propertyLabel.font = Default_Font_13;
    propertyLabel.textColor = [UIColor lightGrayColor];
    [cell.contentView addSubview:propertyLabel];
    
    //时间
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, 50, SCREEN_WIDTH/2-20, 15)];
    timeLabel.font = Default_Font_13;
    timeLabel.textColor = [UIColor lightGrayColor];
    timeLabel.textAlignment = NSTextAlignmentRight;
    timeLabel.text = [ProjectUtil compareDate:self.dataArray[indexPath.row][@"refereeTime"]];
    [cell.contentView addSubview:timeLabel];
    
    
    NSString *newStepStr = self.dataArray[indexPath.row][@"newStepName"];
    CGFloat stepW = [newStepStr boundingRectWithSize:CGSizeMake(0, 20) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:Default_Font_15} context:nil].size.width;
    //状态文字
    UILabel *stepLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-stepW-20, 15, stepW, 20)];
    stepLabel.text = self.dataArray[indexPath.row][@"newStepName"];
    stepLabel.textColor = [ProjectUtil colorWithHexString:self.dataArray[indexPath.row][@"stepColor"]];
    stepLabel.font = Default_Font_15;
    stepLabel.textAlignment = NSTextAlignmentRight;
    [cell.contentView addSubview:stepLabel];
    
    //状态
    UIButton *stepButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-35 - stepW -30, 10, 35, 35)];
    stepButton.hidden = YES;
    [stepButton setBackgroundImage:[UIImage imageNamed:@"takeLook"] forState:UIControlStateNormal];
    stepButton.tag = indexPath.row;
    [cell.contentView addSubview:stepButton];
    
    
    
    if ([self.dataArray[indexPath.row] objectForKey:@"look_type"] != nil &&
        self.dataArray[indexPath.row][@"look_type"] != [NSNull null] &&
        ![[self.dataArray[indexPath.row] objectForKey:@"look_type"]isEqualToString:@""] &&
        self.dataArray[indexPath.row][@"look_type"])
    {
        NSString *num = [self.dataArray[indexPath.row] objectForKey:@"look_type"];
        
        //判断是否是有效状态，显示按钮，添加点击事件
        if ([num isEqualToString:@"9"] &&
            [[self.dataArray[indexPath.row] objectForKey:@"newStepName"] isEqualToString:@"有效"])
        {
            stepButton.hidden = NO;
            [stepButton addTarget:self action:@selector(clickDimensionalBtn:) forControlEvents:UIControlEventTouchUpInside];
        }
    }

    
    if ([self.dataArray[indexPath.row] objectForKey:@"look_time"] != nil &&
        ![self.dataArray[indexPath.row][@"look_time"] isKindOfClass:[NSNull class]] &&
        [self.dataArray[indexPath.row] objectForKey:@"look_time"] != [NSNull null] &&
        [self.dataArray[indexPath.row] objectForKey:@"look_time"])
    {
        NSString * str = [self.dataArray[indexPath.row] objectForKey:@"look_time"];
        if (str.length != 0) {
            stepLabel.text = nil;
            stepLabel.textColor = nil;
            NSString * baseStr = [self.dataArray[indexPath.row] objectForKey:@"newStepName"];
            NSString * numTodayStr = [NSString stringWithFormat:@"%@[已带看]",baseStr];
            
            CGFloat stepLabW = [numTodayStr boundingRectWithSize:CGSizeMake(0, 20) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:Default_Font_15} context:nil].size.width;
            stepLabel.frame = CGRectMake(SCREEN_WIDTH-stepLabW-20, 15, stepLabW, 20);
            
            NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc]initWithString:numTodayStr];
            [attrStr addAttribute:NSForegroundColorAttributeName value:[ProjectUtil colorWithHexString:[self.dataArray[indexPath.row] objectForKey:@"stepColor"]] range:NSMakeRange(0,baseStr.length)];
            [attrStr addAttribute:NSForegroundColorAttributeName value:[ProjectUtil colorWithHexString:@"1d9bf3"] range:NSMakeRange(baseStr.length,5)];
            stepLabel.attributedText = attrStr;
            stepButton.hidden = YES;
        }
    }

    return cell;

//    CustmorStatusTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"detailCell"];
//    cell.dataSource = [self.dataArray objectAtIndex:indexPath.row];
//    [cell.takeLookBtn addTarget:self action:@selector(clickDimensionalBtn:) forControlEvents:UIControlEventTouchUpInside];
//    return cell;
}

- (void)clickDimensionalBtn:(UIButton *)button
{
    UITableViewCell * cell = (UITableViewCell *)[[button superview] superview];
    NSIndexPath * path = [self.m_tableView indexPathForCell:cell];
    
    
    NSDictionary * dict = [self.dataArray objectAtIndex:path.row];
    //    NSArray * dataSource = [dict objectForKey:@"data"];
    NSString * string = [NSString stringWithFormat:@"ThinkPower_%@",[dict objectForKey:@"id"]];
    //    UIImage * image = [UIImage creatQRFromString:string withIconImage:@"Icon60.png"];
    CIImage *imgQRCode = [QRCode createQRCodeImage:string];
    UIImage *imgAdaptiveQRCode = [QRCode resizeQRCodeImage:imgQRCode withSize:170];
    imgAdaptiveQRCode = [QRCode addIconToQRCodeImage:imgAdaptiveQRCode
                                            withIcon:[UIImage imageNamed:@"Icon60.png"]
                                        withIconSize:CGSizeMake(30, 30)];
    [self showQRWithQRimage:imgAdaptiveQRCode];
}

- (void)showQRWithQRimage:(UIImage *)QRimage
{
    coverView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
//    _cover = coverView;
    coverView.backgroundColor = [ProjectUtil colorWithHexString:@"80919191"];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickCoverDisAppear)];
    [coverView addGestureRecognizer:tap];
    [self.view.window addSubview:coverView];
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(72, 27, 200, 20)];
    label.text = @"带看二维码";
    label.font = [UIFont systemFontOfSize:18];
    label.textColor = [ProjectUtil colorWithHexString:@"464646"];
    
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 233, 268)];
    imageView.image = [UIImage imageNamed:@"波纹背景.png"];
    CGPoint center = imageView.center;
    center.x = self.view.center.x;
    center.y = self.view.center.y;
    imageView.center = center;
    UIImageView * QRImageView = [[UIImageView alloc]initWithFrame:CGRectMake(31, 65, 170, 170)];
    QRImageView.image = QRimage;
    [imageView addSubview:QRImageView];
    [imageView addSubview:label];
    [coverView addSubview:imageView];
}

- (void)clickCoverDisAppear
{
    [coverView removeFromSuperview];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    TimeLineViewController * time = [storyboard instantiateViewControllerWithIdentifier:@"TimeLineViewController"];
    
    TimeLineViewController *time = [[TimeLineViewController alloc] init];
    time.propertyInfo = [self.dataArray objectAtIndex:indexPath.row];
    time.timeLineID = self.dataArray[indexPath.row][@"id"];
    [self.navigationController pushViewController:time animated:YES];
    
}


//讲列表的分割线从头开始
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
