//
//  TwohandHouseViewController.m
//  SalesHelper_A
//
//  Created by Brant on 16/1/5.
//  Copyright (c) 2016年 X. All rights reserved.
//

#import "TwohandHouseViewController.h"
#import "UIColor+Extend.h"
#import "TwohandDetailViewController.h"
#import "TwohandSearchViewController.h"
#import "TwohandTableViewCell.h"

static int i = 0;
static int j = 0;
static int k = 0;
static int l = 0;

@interface TwohandHouseViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIButton *areaButton;
@property (nonatomic, strong) UIButton *roomButton;
@property (nonatomic, strong) UIButton *mainjiButton;
@property (nonatomic, strong) UIButton *priceButton;

@property (nonatomic, strong) UIImageView *imageView1;
@property (nonatomic, strong) UIImageView *imageView2;
@property (nonatomic, strong) UIImageView *imageView3;
@property (nonatomic, strong) UIImageView *imageView4;

@property (nonatomic, strong) UITableView *subTableView1;
@property (nonatomic, strong) UITableView *subTableView2;
@property (nonatomic, strong) UITableView *subTableView3;
@property (nonatomic, strong) UITableView *mainTableView;

@property (nonatomic, strong) NSMutableArray *dataSourceArr;
@end

@implementation TwohandHouseViewController
{
    UIControl *backControl;
    BOOL isHidden;
    NSString *cityId;
    
    NSDictionary *subTableDic;
    NSArray *SubArray;
    NSArray *erjiArray;
    
    UILabel *linelabel;
    
    int selectButton;
    int pageNum;
    int selcId;
    NSMutableDictionary *dic;// = [NSMutableDictionary dictionaryWithCapacity:0];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];//colorWithRed:239.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:1];
    isHidden = YES;
    subTableDic = [NSDictionary dictionary];
    SubArray = [NSArray array];
    erjiArray  = [NSArray array];
    self.dataSourceArr = [NSMutableArray arrayWithCapacity:0];
    pageNum = 1;
    selectButton = 0;
    dic = [NSMutableDictionary dictionaryWithCapacity:0];
    
    //获取城市的id
    cityId = [[NSUserDefaults standardUserDefaults] objectForKey:@"location_City"];
    
//    [self creatnaviControl];
    
    [self CreateCustomNavigtionBarWith:self leftItem:@selector(backLastView) rightItem:@selector(searchClick)];
    //创建标题
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-120)/2, 27, 120, 30)];
    titleLabel.text = @"二手房";
    titleLabel.font = Default_Font_20;
    [titleLabel setTextColor:[UIColor whiteColor]];
//    [titleLabel sizeToFit];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.topView addSubview: titleLabel];
    [self.rightBtn setImage:[UIImage imageNamed:@"销邦-首页-搜索.png"] forState:UIControlStateNormal];
    [self.rightBtn setImage:[UIImage imageByApplyingAlpha:[UIImage imageNamed:@"销邦-首页-搜索.png"]] forState:UIControlStateHighlighted];
    self.rightBtn.tintColor = [UIColor whiteColor];
    
    [self creatTopView];
    
    [self creatTableView];
    
    [self requestData];
    
    [self requestDataSource:0 isFooterRefresh:NO buttonType:0];
    
    [self refreshingTableView];
}

#pragma mark --创建导航栏
- (void)creatnaviControl
{
    //创建标题
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-120)/2, 30, 120, 30)];
    titleLabel.text = @"二手房";
    titleLabel.font = Default_Font_20;
    [titleLabel setTextColor:[UIColor whiteColor]];
//    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    
    UIButton* btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake(0, 0, 26, 26);
    [btn setBackgroundImage:[UIImage imageNamed:@"首页-左箭头.png"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageByApplyingAlpha:[UIImage imageNamed:@"首页-左箭头.png"]] forState:UIControlStateHighlighted];
    
//    [btn addTarget:self action:@selector(backlastView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* BACK=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=BACK;
    UIButton* searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame=CGRectMake(0, 0, 26, 26);
    UIImage *image1 = [UIImage imageNamed:@"销邦-首页-搜索.png"];
    [searchBtn setBackgroundImage:image1 forState:UIControlStateNormal];
    [searchBtn setBackgroundImage:[UIImage imageByApplyingAlpha:image1] forState:UIControlStateHighlighted];
    [searchBtn addTarget:self action:@selector(searchClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* addBarBtn = [[UIBarButtonItem alloc]initWithCustomView:searchBtn];
    addBarBtn.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = addBarBtn;
}

-(void)backLastView
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --搜索
- (void)searchClick
{
    TwohandSearchViewController *twohandSearch = [[TwohandSearchViewController alloc] init];
    [self.navigationController pushViewController:twohandSearch animated:YES];
}

#pragma mark --创建顶部view分类
- (void)creatTopView
{
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0,64, SCREEN_WIDTH, 45)];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    
    for (int i = 1; i < 4; i++) {
        UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/4*i, 10, 0.5, 25)];
        lineLabel.backgroundColor = [UIColor hexChangeFloat:@"dadada"];
        [topView addSubview:lineLabel];
    }
    
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 44.5, SCREEN_WIDTH, 0.5)];
    lineLabel.backgroundColor = [UIColor hexChangeFloat:@"dadada"];
    [topView addSubview:lineLabel];
    
    //区域
    self.areaButton = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH/4-80)/2, 5, 80, 35)];
    [self.areaButton setTitle:@"区域" forState:UIControlStateNormal];
    [self.areaButton setTitleColor:[UIColor hexChangeFloat:KBlackColor] forState:UIControlStateNormal];
    self.areaButton.titleLabel.font = Default_Font_15;
    [self.areaButton setImage:[UIImage imageNamed:@"向下箭头"] forState:UIControlStateNormal];
    self.areaButton.imageEdgeInsets = UIEdgeInsetsMake(0, 50, 0, 0);
    self.areaButton.titleEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
    self.areaButton.tag = 100;
    [self.areaButton addTarget:self action:@selector(areaClick:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:self.areaButton];
    
//    self.imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/4-20, (45-13)/2, 13, 13)];
//    self.imageView1.image = [UIImage imageNamed:@"向下箭头"];
//    [topView addSubview:self.imageView1];
    
    //厅室
    self.roomButton = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH/4-80)/2+SCREEN_WIDTH/4, 5, 80, 35)];
    [self.roomButton setTitle:@"厅室" forState:UIControlStateNormal];
    [self.roomButton setTitleColor:[UIColor hexChangeFloat:KBlackColor] forState:UIControlStateNormal];
    self.roomButton.titleLabel.font = Default_Font_15;
    [self.roomButton setImage:[UIImage imageNamed:@"向下箭头"] forState:UIControlStateNormal];
    self.roomButton.imageEdgeInsets = UIEdgeInsetsMake(0, 50, 0, 0);
    self.roomButton.titleEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
    self.roomButton.tag = 101;
    [self.roomButton addTarget:self action:@selector(areaClick:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:self.roomButton];
    
//    self.imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-20, (45-13)/2, 13, 13)];
//    self.imageView2.image = [UIImage imageNamed:@"向下箭头"];
//    [topView addSubview:self.imageView2];
    
    //面积
    self.mainjiButton = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH/4-80)/2+SCREEN_WIDTH/2, 5, 80, 35)];
    [self.mainjiButton setTitle:@"面积" forState:UIControlStateNormal];
    [self.mainjiButton setTitleColor:[UIColor hexChangeFloat:KBlackColor] forState:UIControlStateNormal];
    self.mainjiButton.titleLabel.font = Default_Font_15;
    [self.mainjiButton setImage:[UIImage imageNamed:@"向下箭头"] forState:UIControlStateNormal];
    self.mainjiButton.imageEdgeInsets = UIEdgeInsetsMake(0, 50, 0, 0);
    self.mainjiButton.titleEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
    self.mainjiButton.tag = 102;
    [self.mainjiButton addTarget:self action:@selector(areaClick:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:self.mainjiButton];
    
//    self.imageView3 = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/4*3-20, (45-13)/2, 13, 13)];
//    self.imageView3.image = [UIImage imageNamed:@"向下箭头"];
//    [topView addSubview:self.imageView3];
    
    //价格
    self.priceButton = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH/4-80)/2+SCREEN_WIDTH/4*3, 5, 80, 35)];
    [self.priceButton setTitle:@"价格" forState:UIControlStateNormal];
    [self.priceButton setTitleColor:[UIColor hexChangeFloat:KBlackColor] forState:UIControlStateNormal];
    self.priceButton.titleLabel.font = Default_Font_15;
    [self.priceButton setImage:[UIImage imageNamed:@"向下箭头"] forState:UIControlStateNormal];
    self.priceButton.imageEdgeInsets = UIEdgeInsetsMake(0, 50, 0, 0);
    self.priceButton.titleEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
    self.priceButton.tag = 103;
    [self.priceButton addTarget:self action:@selector(areaClick:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:self.priceButton];
    
//    self.imageView4 = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-20, (45-13)/2, 13, 13)];
//    self.imageView4.image = [UIImage imageNamed:@"向下箭头"];
//    [topView addSubview:self.imageView4];
    
}

- (void)areaClick:(UIButton *)sender
{
    NSInteger tag = sender.tag-100;
    if (tag == 0)
    {
        if (i == 0)
        {
            backControl.hidden = NO;
            self.subTableView2.hidden = NO;
            self.subTableView1.hidden = NO;
            self.subTableView3.hidden = YES;
            [sender setImage:[UIImage imageNamed:@"向上箭头"] forState:UIControlStateNormal];
            [self.roomButton setImage:[UIImage imageNamed:@"向下箭头"] forState:UIControlStateNormal];
            [self.mainjiButton setImage:[UIImage imageNamed:@"向下箭头"] forState:UIControlStateNormal];
            [self.priceButton setImage:[UIImage imageNamed:@"向下箭头"] forState:UIControlStateNormal];
            
            i++;
            j=0;
            k=0;
            l=0;
            
            SubArray = subTableDic[@"district"];
            erjiArray = SubArray[0][@"business"];
            [self.subTableView1 reloadData];
            [self.subTableView2 reloadData];
            
            selectButton = 1000;
            [dic setObject:SubArray[0][@"id"] forKey:@"districtId"];

        }
        else
        {
            [sender setImage:[UIImage imageNamed:@"向下箭头"] forState:UIControlStateNormal];

            i=0;
            j=0;
            k=0;
            l=0;
            backControl.hidden = YES;
            self.subTableView2.hidden = YES;
            self.subTableView1.hidden = YES;
            self.subTableView3.hidden = YES;
        }
    }
    else if (tag == 1)
    {
        if (j==0)
        {
            backControl.hidden = NO;
            self.subTableView3.hidden = NO;
            self.subTableView1.hidden = YES;
            self.subTableView2.hidden = YES;
            
            [sender setImage:[UIImage imageNamed:@"向上箭头"] forState:UIControlStateNormal];
            [self.areaButton setImage:[UIImage imageNamed:@"向下箭头"] forState:UIControlStateNormal];
            [self.mainjiButton setImage:[UIImage imageNamed:@"向下箭头"] forState:UIControlStateNormal];
            [self.priceButton setImage:[UIImage imageNamed:@"向下箭头"] forState:UIControlStateNormal];
            j++;
            i=0;
            k=0;
            l=0;
            
            SubArray = subTableDic[@"ting"];
            [self.subTableView3 reloadData];
            
            selectButton = 1001;
        }
        else
        {
            backControl.hidden = YES;
            self.subTableView3.hidden = YES;
            self.subTableView2.hidden = YES;
            self.subTableView1.hidden = YES;
            
            [sender setImage:[UIImage imageNamed:@"向下箭头"] forState:UIControlStateNormal];
            i=0;
            j=0;
            k=0;
            l=0;
        }

    }
    else if (tag == 2)
    {
        static int i =0;
        if (k==0)
        {
            backControl.hidden = NO;
            self.subTableView3.hidden = NO;
            self.subTableView2.hidden = YES;
            self.subTableView1.hidden = YES;
            
            [sender setImage:[UIImage imageNamed:@"向上箭头"] forState:UIControlStateNormal];
            [self.priceButton setImage:[UIImage imageNamed:@"向下箭头"] forState:UIControlStateNormal];
            [self.roomButton setImage:[UIImage imageNamed:@"向下箭头"] forState:UIControlStateNormal];
            [self.areaButton setImage:[UIImage imageNamed:@"向下箭头"] forState:UIControlStateNormal];
            k++;
            i=0;
            j=0;
            l=0;
            
            SubArray = subTableDic[@"area"];
            [self.subTableView3 reloadData];
            
            selectButton = 1002;
            
        }
        else
        {
            backControl.hidden = YES;
            self.subTableView3.hidden = YES;
            self.subTableView2.hidden = YES;
            self.subTableView1.hidden = YES;
            
            [sender setImage:[UIImage imageNamed:@"向下箭头"] forState:UIControlStateNormal];

            i=0;
            j=0;
            k=0;
            l=0;
        }
    }
    else
    {
        static int i =0;
        if (l==0)
        {
            backControl.hidden = NO;
            self.subTableView3.hidden = NO;
            self.subTableView2.hidden = YES;
            self.subTableView1.hidden = YES;

            [sender setImage:[UIImage imageNamed:@"向上箭头"] forState:UIControlStateNormal];
            [self.mainjiButton setImage:[UIImage imageNamed:@"向下箭头"] forState:UIControlStateNormal];
            [self.roomButton setImage:[UIImage imageNamed:@"向下箭头"] forState:UIControlStateNormal];
            [self.areaButton setImage:[UIImage imageNamed:@"向下箭头"] forState:UIControlStateNormal];
            l++;
            i=0;
            j=0;
            k=0;
            
            SubArray = subTableDic[@"price"];
            [self.subTableView3 reloadData];
            
            selectButton = 1003;
        }
        else
        {
            backControl.hidden = YES;
            self.subTableView3.hidden = YES;
            self.subTableView2.hidden = YES;
            self.subTableView1.hidden = YES;
            [sender setImage:[UIImage imageNamed:@"向下箭头"] forState:UIControlStateNormal];

            i=0;
            j=0;
            k=0;
            l=0;
        }
    }
    
}

- (void)creatTableView
{
    
    self.mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 45+64, SCREEN_WIDTH, SCREEN_HEIGHT-45-64)];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.tableFooterView = [[UIView alloc] init];
    self.mainTableView.tag = 200;
    [self.view addSubview:self.mainTableView];
    self.mainTableView.separatorColor = [UIColor colorWithRed:239/255.0f green:239/255.0f blue:244/255.0f alpha:1];
    
    
    backControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 45+64, SCREEN_WIDTH, SCREEN_HEIGHT-45)];
    backControl.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.6];
    [backControl addTarget:self action:@selector(hiddenView) forControlEvents:UIControlEventTouchUpInside];
    backControl.hidden = YES;
    [self.view addSubview:backControl];
    //    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    //    [keyWindow addSubview:backControl];
    
    self.subTableView1 = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/2, 280)];
    self.subTableView1.delegate = self;
    self.subTableView1.dataSource = self;
    self.subTableView1.tableFooterView = [[UIView alloc] init];
    self.subTableView1.tag = 201;
    self.subTableView1.hidden = YES;
    [backControl addSubview:self.subTableView1];
    
    self.subTableView2 = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2, 280)];
    self.subTableView2.delegate = self;
    self.subTableView2.dataSource = self;
    self.subTableView2.tableFooterView = [[UIView alloc] init];
    self.subTableView2.tag = 202;
    self.subTableView2.hidden = YES;
    [backControl addSubview:self.subTableView2];

    self.subTableView3 = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 280)];
    self.subTableView3.delegate = self;
    self.subTableView3.dataSource = self;
    self.subTableView3.tableFooterView = [[UIView alloc] init];
    self.subTableView3.tag = 203;
    self.subTableView3.hidden = YES;
    [backControl addSubview:self.subTableView3];
}

- (void)hiddenView
{
    backControl.hidden = YES;
    self.subTableView2.hidden = YES;
    self.subTableView1.hidden = YES;
    self.subTableView3.hidden = YES;
    [self.areaButton setImage:[UIImage imageNamed:@"向下箭头"] forState:UIControlStateNormal];
    [self.roomButton setImage:[UIImage imageNamed:@"向下箭头"] forState:UIControlStateNormal];
    [self.mainjiButton setImage:[UIImage imageNamed:@"向下箭头"] forState:UIControlStateNormal];
    [self.priceButton setImage:[UIImage imageNamed:@"向下箭头"] forState:UIControlStateNormal];
    i=0;
    j=0;
    k=0;
    l=0;
}

#pragma mark --下拉刷新上拉加载
//刷新tableView
-(void)refreshingTableView
{
    //下拉刷新
    __block  TwohandHouseViewController * h = self;
    [self.mainTableView addHeaderWithCallback:^{

        [h requestDataSource:selcId isFooterRefresh:NO buttonType:selectButton];
        [self.mainTableView headerEndRefreshing];

    }];
    
    //上拉加载
    [self.mainTableView  addFooterWithCallback:^{
        [h requestDataSource:selcId isFooterRefresh:YES buttonType:selectButton];
        [self.mainTableView footerEndRefreshing];
    }];
}

- (void)requestData
{
    NSDictionary *dic1 = @{@"districtPId":cityId};
    
    RequestInterface *inteRequest = [[RequestInterface alloc] init];
    
    [inteRequest requestTwohandSubTabWithDic:dic1];
    [inteRequest getInterfaceRequestObject:^(id data) {
//        NSLog(@"二手房列表%@", data);
        if (data[@"success"])
        {
            subTableDic = data;
        }
        else {
            [self.view makeToast:data[@"message"]];
        }
        
    } Fail:^(NSError *error) {
        [self.view makeToast:@"网络错误"];
        
    }];
    
    
    
    
//    [self.mainTableView headerEndRefreshing];
//    [self.mainTableView footerEndRefreshing];
}

- (void)requestDataSource:(NSInteger)selectId isFooterRefresh:(BOOL)foot buttonType:(NSInteger)type
{
    if (type == 1000)
    {
        [dic setObject:[NSString stringWithFormat:@"%ld", (long)selectId] forKey:@"districtId"];
    }
    else if (type == 1001)
    {
        [dic setObject:[NSString stringWithFormat:@"%ld", (long)selectId] forKey:@"isTing"];
    }
    else if (type == 1002)
    {
        [dic setObject:[NSString stringWithFormat:@"%ld", (long)selectId] forKey:@"isArea"];
    }
    else if (type == 1003)
    {
        [dic setObject:[NSString stringWithFormat:@"%ld", (long)selectId] forKey:@"isJiage"];
    }
    else
    {
        [dic setObject:[NSString stringWithFormat:@"%ld", (long)selectId] forKey:@"bussiessId"];
    }
    
    if (!foot)
    {
        [dic setObject:@"1" forKey:@"page"];
        [dic setObject:@"10" forKey:@"size"];
        [dic setObject:cityId forKey:@"districtPId"];
    }
    else
    {
        pageNum ++;
        [dic setObject:[NSString stringWithFormat:@"%d", pageNum] forKey:@"page"];
        [dic setObject:@"10" forKey:@"size"];
        [dic setObject:cityId forKey:@"districtPId"];
    }
    
    RequestInterface *inteRequest = [[RequestInterface alloc] init];
    [self.view Loading_0314];
    [inteRequest requestTwohandMainTabWithDic:dic];
    [inteRequest getInterfaceRequestObject:^(id data) {
        [self.view Hidden];
        if ([data[@"success"] boolValue] == YES)
        {
            NSLog(@"二手房列表%@",data);
            if (!foot)
            {
                [self.dataSourceArr removeAllObjects];
                [self.dataSourceArr addObjectsFromArray:[data objectForKey:@"datas"]];
                if (![[data objectForKey:@"datas"] count])
                {
                    [self.view makeToast:@"暂无数据"];
                }
            } else {
                [self.dataSourceArr insertObjects:data[@"datas"] atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(self.dataSourceArr.count, [data[@"datas"] count])]];
                if (![[data objectForKey:@"datas"]count])
                {
                    [self.view makeToast:@"没有更多数据了"];
                }
            }
            
            [self.mainTableView reloadData];
            
        } else {
            [self.view makeToast:@"加载失败"];
        }
        
    } Fail:^(NSError *error) {
        [self.view Hidden];
        [self.view makeToast:@"网络错误"];
        
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 200)
    {
        TwohandTableViewCell *cell = (TwohandTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        if (!cell) {
            cell = [[TwohandTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"%@", indexPath]];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSDictionary *dict = self.dataSourceArr[indexPath.row];
        [cell configTableCellWithDic:dict];
        return cell;
        
    }
    else if (tableView.tag == 201)
    {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"%@", indexPath]];
        }
        
        UILabel *laebl = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH/2-10, 40)];
        laebl.text = SubArray[indexPath.row][@"name"];
        laebl.textColor = [UIColor hexChangeFloat:@"717171"];
        laebl.font = Default_Font_15;
        [cell.contentView addSubview:laebl];
        
        //分割线
//        if (!linelabel) {
            linelabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-0.5, 0, 0.5, 40)];
            linelabel.backgroundColor = [UIColor hexChangeFloat:@"dadada"];
//        }
        [cell.contentView addSubview:linelabel];
        
        return cell;
    }
    else if (tableView.tag == 202)
    {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"%@", indexPath]];
        }
        if (indexPath.row == 0)
        {
            UILabel *laebl = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH/2-10, 40)];
            laebl.text = @"全部";
            laebl.textColor = [UIColor hexChangeFloat:@"717171"];
            laebl.font = Default_Font_15;
            [cell.contentView addSubview:laebl];
        } else {
            UILabel *laebl = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH/2-10, 40)];
            laebl.text = erjiArray[indexPath.row-1][@"name"];
            laebl.textColor = [UIColor hexChangeFloat:@"717171"];
            laebl.font = Default_Font_15;
            [cell.contentView addSubview:laebl];
        }
        
        
//        cell.contentView.backgroundColor = [UIColor hexChangeFloat:@"f2f2f2"];
         return cell;
    }
    else
    {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"%@", indexPath]];
        }
        if (indexPath.row == 0)
        {
            UILabel *laebl = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH/2-10, 40)];
            
            laebl.textColor = [UIColor hexChangeFloat:@"717171"];
            laebl.font = Default_Font_15;
            laebl.text = @"全部";
            [cell.contentView addSubview:laebl];
        } else {
            UILabel *laebl = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH/2-10, 40)];
            
            laebl.textColor = [UIColor hexChangeFloat:@"717171"];
            laebl.font = Default_Font_15;
            laebl.text = SubArray[indexPath.row-1][@"name"];
            [cell.contentView addSubview:laebl];
        }
        
        return cell;

    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 200)
    {
        return 100;
    } else {
        return 40;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 200)
    {
        return self.dataSourceArr.count;
    }
    else if (tableView.tag == 201)
    {
        return SubArray.count;
    }
    else if (tableView.tag == 202)
    {
        if (erjiArray != nil &&
            erjiArray != NULL &&
            ![erjiArray isKindOfClass:[NSNull class]] &&
            erjiArray)
        {
            return erjiArray.count+1;
        }
        return 1;
    }
    else
    {
        return SubArray.count+1;
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 200)
    {
        TwohandDetailViewController *vc = [[TwohandDetailViewController alloc] init];
        vc.strId = self.dataSourceArr[indexPath.row][@"id"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (tableView.tag == 201)
    {

        erjiArray = SubArray[indexPath.row][@"business"];
        [dic setObject:SubArray[indexPath.row][@"id"] forKey:@"districtId"];

        [self.subTableView2 reloadData];
        
    }
    else if (tableView.tag == 202)
    {
        [self hiddenView];
        if (indexPath.row == 0)
        {
            selcId = 0;
            [self.areaButton setTitle:@"区域" forState:UIControlStateNormal];
        } else {
            selcId = [erjiArray[indexPath.row-1][@"id"] intValue];
            NSString *titleStr = erjiArray[indexPath.row-1][@"name"];
            if (titleStr.length >=3)
            {
                titleStr = [titleStr substringToIndex:3];
            }
            [self.areaButton setTitle:titleStr forState:UIControlStateNormal];
        }
        
        selectButton = 11;
        [self requestDataSource:selcId isFooterRefresh:NO buttonType:selectButton];
        
    }
    else
    {
        [self hiddenView];
        
        if (indexPath.row == 0)
        {
            selcId = 0;
            if (selectButton == 1001)
            {
                [self.roomButton setTitle:@"厅室" forState:UIControlStateNormal];
            }
            else if (selectButton == 1002)
            {
                [self.mainjiButton setTitle:@"面积" forState:UIControlStateNormal];
            }
            else if (selectButton == 1003)
            {
                [self.priceButton setTitle:@"价格" forState:UIControlStateNormal];
            }
            else
            {
                
            }
        } else {
            selcId = [SubArray[indexPath.row-1][@"id"] intValue];
            
            NSString *titleStr = SubArray[indexPath.row-1][@"name"];
            if (titleStr.length >=3)
            {
                titleStr = [titleStr substringToIndex:3];
            }
            if (selectButton == 1001)
            {
                [self.roomButton setTitle:titleStr forState:UIControlStateNormal];
            }
            else if (selectButton == 1002)
            {
                [self.mainjiButton setTitle:titleStr forState:UIControlStateNormal];
            }
            else if (selectButton == 1003)
            {
                [self.priceButton setTitle:titleStr forState:UIControlStateNormal];
            }
            else
            {
                
            }
        }
        
            
        [self requestDataSource:selcId isFooterRefresh:NO buttonType:selectButton];
    }
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
