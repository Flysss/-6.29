//
//  HomeViewController.m
//  SalesHelper_A
//
//  Created by summer on 14/12/18.
//  Copyright (c) 2014年 X. All rights reserved.
//

#import "HomeViewController.h"
#import "MJRefresh.h"
#import "RESideMenu.h"
#import "SetAreaProvinceViewController.h"
#import "RealestateHeadTableViewCell.h"
#import "RealestateListTableViewCell.h"
#import "SelectRealestateViewController.h"
#import "HouseDetailViewController.h"
#import "ItemCollectionView.h"
#import "AddBankCardViewController.h"
#import "ModelWebViewController.h"
#import "LoginViewController.h"
static NSString * const AnimationKey = @"animationKey";

@interface HomeViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,ItemCollectionViewDelegate,UIGestureRecognizerDelegate,UISearchBarDelegate>
{
    //表格的数据
    NSMutableArray *_tableData;
    NSMutableArray *_tableFirstCellData;
    UIPageControl *_topImagePageControl;//头部滚动图片pageControl
    
    
    //记录当前的城市位置信息
    NSString *currentLocationCity;
    
    //table表格的高度
    CGFloat _dataTableViewHeight;
    
    //headBackView距离顶部的高度
    CGFloat _headBackViewFromTop;
    
    //记录当前选中的标题的 ID
    NSString *_regionButIndex;
    NSString *_areaButIndex;
    NSString *_priceButIndex;
    
    //记录服务器所有的信息条数
    double allPageCount;
    //记录当前页数
    int pageIndex;
    
    //三个title标题button
    UIButton *_regionTitleBut;  //区域
    UIButton *_areaTitleBut;    //面积
    UIButton *_priceTitleBut;   //价格
    
    ItemCollectionView *_regionItemView;//区域状态View
    ItemCollectionView *_areaItemView;//面积状态View
    ItemCollectionView *_priceItemView;//价格状态View
    
    //记录三个标题的 服务ID
    NSMutableArray *_regionIdArray;
    NSMutableArray *_areaIdArray;
    NSMutableArray *_priceIdArray;
    
    //记录三个标题的 服务ID
    NSMutableArray *_regionTitleArray;
    NSMutableArray *_areaTitleArray;
    NSMutableArray *_priceTitleArray;
    
    UIImageView *_leftHeadImageView;
    
    //最后滚动的offset
//    float lastContentOffset;
    
    UITapGestureRecognizer *_reloadDataTap;
    
    //上拉下拉 搜索框的出现隐藏
    BOOL _isStartAnimation;
    
    //新手必读的View
    UIView *_noviceReadView;
}

@property (weak, nonatomic) IBOutlet UITextField *searchText;
@property (weak, nonatomic) IBOutlet UIView *searchBackView;

@property (nonatomic, strong) UIView *headBackView;//头部背景view

//页面table

@property (nonatomic, strong) NSMutableArray *filteredRealestate;       //过滤后所有的楼盘信息

@property (assign, nonatomic) float lastContentOffset;//记录滑动的上一次offset

//@property (strong, nonatomic) UIPanGestureRecognizer* panGesture;
//
@property (assign, nonatomic) BOOL isScrollUp_now;//tableview向上滑
@property (assign, nonatomic) BOOL isScrollDown_now;//tableview向下滑

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    self.view.backgroundColor = [UIColor whiteColor];
   [self creatNavigationItemWithMNavigationItem:MNavigationItemTypeTitle ItemName:@"销邦"];
  
    
      [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:21.0/255.0 green:159/255.0 blue:234/255.0 alpha:1]];
    //记录当前的城市位置信息
    currentLocationCity = [[NSString alloc] init];
    currentLocationCity = [[NSUserDefaults standardUserDefaults] valueForKey:@"Login_User_currentLocationCity"];
    
    //记录服务器所有的信息条数
    allPageCount = MAXFLOAT;
    
    
    [self layoutSubViews];

    //点击屏幕重新加载数据手势
    _reloadDataTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(reloadDatatapAction)];
    
    _isStartAnimation = YES;
    self.lastContentOffset = 0.0;
    
    //是否需要提现账户
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"SalesHelper_isNeedDrawal"]) {
       // [self requestGetWithd];
    }
    //接收通知  接收定位 页面更新的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getAreaSelectedResult:) name:@"RealestateViewArea_notice" object:nil];
    if (_regionIdArray.count > 0 && _areaIdArray.count > 0 && _priceIdArray.count > 0) {
        [self.view hideProgressLabel];
        [self.view removeGestureRecognizer:_reloadDataTap];
        //2015/05/25
        [self refreshDataTable];
    }else {
        [self startReloadRequest];
    }
    
    //更新用户头像
    [self updateHeadImage];

    
    //设置状态栏的颜色
    if (IOS_VERSION>7.0)
    {
        [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    }
    
    
    
    

}

- (void)layoutSubViews
{
    //左边的头像
    NSString *path = [[NSBundle mainBundle] pathForResource:@"xtoux" ofType:@"png"];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    
    _leftHeadImageView = [[UIImageView alloc] init];
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0,0,30,30)];
    [leftButton addSubview:_leftHeadImageView];
    _leftHeadImageView.frame = leftButton.frame;
    leftButton.layer.cornerRadius = leftButton.width/2;
    leftButton.layer.masksToBounds = YES;
    _leftHeadImageView.image = image;
//    [leftButton setImage:_leftHeadImageView.image forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(presentLeftMenuViewController:)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    //右边的推荐button
    UIButton *rightBtn = [self creatUIButtonWithFrame:CGRectMake(0, 20, 40, 30) BackgroundColor:nil Title:@"推荐" TitleColor:NavigationBarTitleColor Action:@selector(clickSelectBtn:)];
    [rightBtn setTitleEdgeInsets:UIEdgeInsetsMake(2.0, 3.0, 0.0, 0.0)];
    if (IOS_VERSION<7.0)
    {
        rightBtn.titleEdgeInsets = UIEdgeInsetsMake(2.0, -10.0, 0, 0.0);
    }
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:[self creatNegativeSpacerButton],[[UIBarButtonItem alloc] initWithCustomView:rightBtn], nil];
    
    //修改mySearchBar 样式
    self.searchBackView.layer.cornerRadius = 5;
    
    //新手指导 的图层
    [self creatNoviceReadView];
    
    //顶部view 的图层
    [self creatHeadBackView];
    
    //searchView 的图层
    [self creatMySearchBarView];
    
    //tableView 图层
    [self creatThisViewTableView];
    
    //三个选项卡 图层
    [self creatThreeTitleBtn];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //以前在viewwillappear中
    self.sideMenuViewController.panGestureEnabled = YES;
    
    //默认起始页
    pageIndex = 1;
    
    //搜索框的view
    self.headBackView.frame = CGRectMake(0, _headBackViewFromTop, SCREEN_WIDTH, 74);
    if (_realestateTableView.height > 0) {
        _realestateTableView.frame = CGRectMake(0, 75+_headBackViewFromTop, SCREEN_WIDTH, _dataTableViewHeight-_headBackViewFromTop);
    }
    
    //区域
    [_regionItemView setTop:self.headBackView.bottom+1];
    //面积
    [_areaItemView setTop:self.headBackView.bottom+1];
    //价格
    [_priceItemView setTop:self.headBackView.bottom+1];
    
    if (_regionIdArray.count > 0 && _areaIdArray.count > 0 && _priceIdArray.count > 0) {
        [self.view hideProgressLabel];
        [self.view removeGestureRecognizer:_reloadDataTap];
               //[self refreshDataTable];
    }else {
        [self startReloadRequest];
    }
    
    //更新用户头像
    [self updateHeadImage];
    

}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.sideMenuViewController.panGestureEnabled = YES;
    //[self.view removeFromSuperview];
   // [_realestateTableView reloadData];
    
    
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.sideMenuViewController.panGestureEnabled = NO;
    //面积
    _areaItemView.hiddenItemView = YES;
    //价格
    _priceItemView.hiddenItemView = YES;
    //区域
    _regionItemView.hiddenItemView = YES;
    [self giveupFirstResponder];
    
    [super viewWillDisappear:animated];
    
    
    
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self.view endEditing:YES];
    
    [super viewDidDisappear:animated];
}

//更新用户头像
- (void)updateHeadImage
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/SalesServers/%@",REQUEST_SERVER_URL,[defaults objectForKey:@"login_User_face"]];

    [_leftHeadImageView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"xtoux"]];
}

- (void)creatNoviceReadView
{
    //更新登录状态
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if([userDefaults boolForKey:@"SalesHelper_NoviceRead"]) {
        
        //初始化顶部view距离顶部的高度
        _headBackViewFromTop = 30.0f;
        
        //新手必读view
        //新建新手必读的view
        _noviceReadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _headBackViewFromTop)];
        _noviceReadView.backgroundColor = RGBACOLOR(253, 96, 77, 1);
        //文件路径
        NSString *novicePath = [[NSBundle mainBundle] pathForResource:@"xsyd" ofType:@"png"];
        UIImageView *noviceImageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-100)/2.0, 7, 15, 16)];
        noviceImageView.image = [UIImage imageWithContentsOfFile:novicePath];
        [_noviceReadView addSubview:noviceImageView];
        
        UILabel *noviceLabel = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-70)/2.0, 0, 70, _headBackViewFromTop)];
        noviceLabel.backgroundColor = [UIColor clearColor];
        noviceLabel.textColor = [UIColor whiteColor];
        noviceLabel.font = Default_Font_15;
        noviceLabel.text = @"新手必读";
        noviceLabel.textAlignment = NSTextAlignmentCenter;
        [_noviceReadView addSubview:noviceLabel];
        
        
        NSString *clickPath = [[NSBundle mainBundle] pathForResource:@"ybjt" ofType:@"png"];
        UIImageView *nextImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_noviceReadView.width - 28, 7, 15, 16)];
        nextImageView.image = [UIImage imageWithContentsOfFile:clickPath];
        [_noviceReadView addSubview:nextImageView];
        
        //手势消失键盘
        UITapGestureRecognizer *noticeTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(noviceReadViewClick)];
        noticeTap.delegate = self;
        [_noviceReadView addGestureRecognizer:noticeTap];
        
    }else {
        //初始化顶部view距离顶部的高度
        _headBackViewFromTop = 0.0f;
    }
    
    [userDefaults setBool:NO forKey:@"SalesHelper_NoviceRead"];
    [userDefaults synchronize];
}

//创建区域 面积 和价格背景view
- (void)creatHeadBackView
{
    //创建区域 面积 和价格背景view
    self.headBackView = [[UIView alloc] initWithFrame:CGRectMake(0, _headBackViewFromTop, SCREEN_WIDTH, 75)];
    self.headBackView.backgroundColor = [UIColor whiteColor];
    
    //搜索栏背景颜色
    UIView *grayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    grayView.backgroundColor = RGBACOLOR(235, 236, 238, 1);
    [self.headBackView addSubview:grayView];
    
}

#pragma mark - 区域 面积 价格
- (void)creatThreeTitleBtn
{
    //设置默认选中的Index
    _regionButIndex =@"0";
    _areaButIndex = @"0";
    _priceButIndex = @"0";
    
    //记录三个标题的 服务ID数组初始化
    _regionIdArray = [[NSMutableArray alloc] init];
    _areaIdArray = [[NSMutableArray alloc] init];
    _priceIdArray = [[NSMutableArray alloc] init];
    
    //记录三个标题的 服务ID数组初始化
    _regionTitleArray = [[NSMutableArray alloc] init];
    _areaTitleArray = [[NSMutableArray alloc] init];
    _priceTitleArray = [[NSMutableArray alloc] init];
    
    //状态栏 区域
    _regionItemView = [[ItemCollectionView alloc]initWithItemArr:@[] OrignalY:75.0];
    _regionItemView.selectedItem = 0;
    _regionItemView.tag = 1500;
    _regionItemView.itemDelelgate = self;
    _regionItemView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_regionItemView];
    
    //面积
    _areaItemView = [[ItemCollectionView alloc]initWithItemArr:@[] OrignalY:75.0];
    _areaItemView.selectedItem = 0;
    _areaItemView.tag = 1510;
    _areaItemView.itemDelelgate = self;
    _areaItemView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_areaItemView];
    
    //价格
    _priceItemView = [[ItemCollectionView alloc]initWithItemArr:@[] OrignalY:75.0];
    _priceItemView.selectedItem = 0;
    _priceItemView.tag = 1520;
    _priceItemView.itemDelelgate = self;
    _priceItemView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_priceItemView];
    
    NSString *imageName = @"xljt";
    
    //区域
    _regionTitleBut = [self creatSpecialButtonWithFrame:CGRectMake(-5, mySearchBar.bottom-1, SCREEN_WIDTH/3, 30.0f) Title:@"区域" WithImage:imageName Action:@selector(clickRegionTitleBtn:)];

    [self.headBackView addSubview:_regionTitleBut];
    
    //面积
    _areaTitleBut = [self creatSpecialButtonWithFrame:CGRectMake(_regionTitleBut.right, mySearchBar.bottom-1, SCREEN_WIDTH/3, 30.0f) Title:@"面积" WithImage:imageName Action:@selector(clickAreaTitleBtn:)];
    [self.headBackView addSubview:_areaTitleBut];
    
    //价格
    _priceTitleBut = [self creatSpecialButtonWithFrame:CGRectMake(_areaTitleBut.right-10, mySearchBar.bottom-1, SCREEN_WIDTH/3, 30.0f) Title:@"价格" WithImage:imageName Action:@selector(clickPriceTitleBtn:)];
    
    //3个button下面的那条横线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, _priceTitleBut.bottom+1, SCREEN_WIDTH, 1.0f)];
    lineView.backgroundColor = NavigationBarColor;
    [self.headBackView addSubview:lineView];
    [self.headBackView addSubview:_priceTitleBut];
}

//获取标题数据
- (void)startReloadRequest
{
   [_tableData removeAllObjects];
    
    //查询面积 价格标题的tag
    [self requestGetHouseAttribute:@"4"];
    //查询区域标题的tag
    [self requestGetDistrict:@"1" WithName:currentLocationCity];
}

//创建标题 附加可点击事件 就是点击搜索框事件
- (void)creatMySearchBarView
{    
    mySearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    mySearchBar.delegate = self;
    [mySearchBar setBackgroundImage:[ProjectUtil imageWithColor:RGBACOLOR(235, 236, 238, 1) size:CGSizeMake(0.1f, 0.1f)]];
    [mySearchBar setContentMode:UIViewContentModeLeft];
    [mySearchBar setPlaceholder:@"搜索关键字"];
    [self.headBackView addSubview:mySearchBar];
}

#pragma mark - 通知 调用的方法
- (void)getAreaSelectedResult:(NSNotification *)notice
{
    
    NSDictionary *dict = notice.object;
    NSString *cityName = dict[@"cityName"];
    if ([[cityName substringFromIndex:(cityName.length-1)] isEqualToString:@"市"]) {
        currentLocationCity = [cityName substringToIndex:(cityName.length-1)];
    }else{
        currentLocationCity = cityName;
    }
    
    //设置默认选中的Index
    _regionButIndex =@"0";
    _areaButIndex = @"0";
    _priceButIndex = @"0";
    
    //记录三个标题的 服务ID数组初始化
    [_regionIdArray removeAllObjects];
    [_areaIdArray removeAllObjects];
    [_priceIdArray removeAllObjects];
    
    //记录三个标题的 服务ID数组初始化
    [_regionTitleArray removeAllObjects];
    [_areaTitleArray removeAllObjects];
    [_priceTitleArray removeAllObjects];
    
    [_tableData removeAllObjects];
    [_tableFirstCellData removeAllObjects];
    
    _regionItemView.hiddenItemView = YES;
    _areaItemView.hiddenItemView = YES;
    _priceItemView.hiddenItemView = YES;
    
    [self updateThreeBtnTitle:_regionTitleBut BtnTitle:@"区域" BtnFont:Default_Font_18];
    [self updateThreeBtnTitle:_areaTitleBut BtnTitle:@"面积" BtnFont:Default_Font_18];
    [self updateThreeBtnTitle:_priceTitleBut BtnTitle:@"价格" BtnFont:Default_Font_18];
    //xianshi 显示选择的内容。
    [self.view makeToast:[NSString stringWithFormat:@"已切换到%@",currentLocationCity] Position:ToastPositionTypeBottom];
    
    if ([dict[@"type"] isEqualToString:@"NeedReload"])
    {
        [self startReloadRequest];
    }
    
    //[_realestateTableView reloadData];

}

#pragma mark - 创建tableview
- (void)creatThisViewTableView
{

    self.filteredRealestate = [[NSMutableArray alloc] init];
    _tableData = [NSMutableArray array];
    _tableFirstCellData = [NSMutableArray array];
    
    _dataTableViewHeight = SCREEN_HEIGHT-64-80 -44;
    
    _realestateTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 75+_headBackViewFromTop, SCREEN_WIDTH, _dataTableViewHeight-_headBackViewFromTop) style:UITableViewStylePlain];
    _realestateTableView.contentOffset = CGPointMake(0, 75+_headBackViewFromTop);
    
    _realestateTableView.backgroundColor = [UIColor whiteColor];//RGBACOLOR(240, 239, 237, 1);
    
    _realestateTableView.dataSource = self;
    _realestateTableView.delegate = self;
    _realestateTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    
    if ([_realestateTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_realestateTableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    //ios8SDK 兼容6 和 7 cell下划线
    if ([_realestateTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_realestateTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    __block HomeViewController *blockSelf = self;

    //下拉view
    [_realestateTableView addHeaderWithCallback:^{
       
        [ProjectUtil showLog:(@"下拉刷新")];
        blockSelf->pageIndex = 1;
        
        if (blockSelf->_regionIdArray.count > 0) {
            [blockSelf refreshDataTable];
        }else {
            [blockSelf startReloadRequest];
        }
        
    } dateKey:@"homeTable"];
    
    //上拉view
    [_realestateTableView addFooterWithCallback:^{
        [ProjectUtil showLog:(@"上拉加载更多")];

        if (blockSelf->pageIndex*10 >= blockSelf->allPageCount) {
            [blockSelf.realestateTableView footerEndRefreshing];
            [blockSelf.view makeToast:HintWithNoMoreData];
        }else {
            blockSelf->pageIndex ++ ;
            [blockSelf loadMoreDataToTable];
        }
        
    }];
    
    [self.view addSubview:_realestateTableView];
    
    [self.view addSubview:self.headBackView];
    
    if (_noviceReadView != nil) {
        [self.view addSubview:_noviceReadView];
    }
    
    _topImagePageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];

    
    [_realestateTableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
   //点击空白的敌方键盘会下去
    [self.view endEditing:YES];
    [self giveupFirstResponder];
    [self hiddenItemView];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //辟邪的
    int index = scrollView.contentOffset.x/scrollView.width;
    _topImagePageControl.currentPage = index;
    
    if (scrollView.tag == 2000) {
        //首页的大房源信息 若有多个 可以左右滑动
        RealestateHeadTableViewCell *firstCell = (RealestateHeadTableViewCell *)[_realestateTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        NSDictionary *firstCellDict = [_tableFirstCellData objectAtIndex:_topImagePageControl.currentPage];
        firstCell.housePageControl.currentPage = _topImagePageControl.currentPage;
        
        NSString *propertyName = firstCellDict[@"property_name"];
        NSString *priceStr = [NSString stringWithFormat:@"%@",[firstCellDict objectForKey:@"price"]];
        NSString *brokerageStr = [NSString stringWithFormat:@"%@",[firstCellDict objectForKey:@"brokerage"]];

        NSString *houseStr = [NSString stringWithFormat:@"%@     均价 %@     佣金 %@",propertyName,priceStr,brokerageStr];
        
        NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:houseStr];
        [attributeStr addAttribute:NSFontAttributeName value:Default_Font_15 range:NSMakeRange(0, propertyName.length)];
        [attributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, propertyName.length)];
        
        [attributeStr addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:Default_Font_13,NSFontAttributeName,RGBCOLOR(103, 103, 103),NSForegroundColorAttributeName,nil] range:NSMakeRange(propertyName.length+5,houseStr.length-propertyName.length-5)];
        [attributeStr addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(250, 0, 20) range:NSMakeRange(propertyName.length+5+3, priceStr.length)];
        [attributeStr addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(250, 0, 20) range:NSMakeRange(propertyName.length+5+3+priceStr.length+5+3, brokerageStr.length)];
        
        firstCell.houseInfoLabel.attributedText = attributeStr;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

    if (scrollView.contentOffset.y < 0) {
        self.lastContentOffset = scrollView.contentOffset.y;
        return;
    }
    
    if (scrollView.contentOffset.y >= scrollView.contentSize.height - _realestateTableView.height){
        self.lastContentOffset = scrollView.contentOffset.y;
        return;
    }
    
    
    
    if (self.lastContentOffset-scrollView.contentOffset.y>=3)
    {
//       下拉操作;
        if (_realestateTableView.headerRefreshing|_realestateTableView.footerRefreshing)
        {
            
        }
        else
        {
            [UIView animateWithDuration:0.3 animations:^{
                if (_isStartAnimation)
                {
                    //                    //出现
                    [self.headBackView setTop:_headBackViewFromTop];
                    [self.headBackView bringSubviewToFront:_realestateTableView];
                    [_realestateTableView setTop:self.headBackView.bottom+1];
                    [_realestateTableView setHeight:_dataTableViewHeight-_headBackViewFromTop];
                    
                }
                
            } completion:^(BOOL finished) {
                _isStartAnimation = NO;
                
                [_regionItemView setTop:self.headBackView.bottom+1];
                [_areaItemView setTop:self.headBackView.bottom+1];
                [_priceItemView setTop:self.headBackView.bottom+1];
            }];

        }
        }
    else if (scrollView.contentOffset.y-self.lastContentOffset>=3)
    {
//       上拉操作;
        if (_realestateTableView.headerRefreshing|_realestateTableView.footerRefreshing)
        {
            
        }
        else
        {
            [UIView animateWithDuration:0.3 animations:^{
                if (!_isStartAnimation)
                {

                    //                    //隐藏
                    [self.headBackView setTop:_headBackViewFromTop-44.0f];
                    [_realestateTableView setHeight:_dataTableViewHeight+44-_headBackViewFromTop];
                    [_realestateTableView setTop:self.headBackView.bottom+1];
                    
                }
                
            } completion:^(BOOL finished) {
                _isStartAnimation = YES;
                
                [_regionItemView setTop:self.headBackView.bottom+1];
                [_areaItemView setTop:self.headBackView.bottom+1];
                [_priceItemView setTop:self.headBackView.bottom+1];
            }];

        }
     
    }
    self.lastContentOffset = scrollView.contentOffset.y;

}

#pragma mark - UITapGestureRecognizer
//shoushi 手势点击事件
- (void)reloadDatatapAction
{
    
    if (_tableData.count > 0) {
        NSDictionary *dict = @{@"district_id":_regionButIndex,
                               @"proportion_id":_areaButIndex,
                               @"price_id":_priceButIndex
                               };
        [self requestGetPropertyInfos:dict];
    }else{
        [self startReloadRequest];
    }
    
}



#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    if (textField == self.searchText && textField.returnKeyType == UIReturnKeySearch) {
        NSDictionary *dict = @{@"district_id":_regionButIndex,
                               @"proportion_id":_areaButIndex,
                               @"price_id":_priceButIndex
                               };
        [self requestGetPropertyInfos:dict];
    }
    

    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}

#pragma mark - UISearchbar

- (void)giveupFirstResponder
{
    mySearchBar.showsCancelButton = NO;
    [mySearchBar resignFirstResponder];
    [mySearchBar setText:@""];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [self hiddenItemView];
    [searchBar setShowsCancelButton:YES animated:YES];
    
    // 修改UISearchBar右侧的取消按钮文字颜色及背景图片
    [self modifySearchBarCancelBtn:searchBar Color:RGBACOLOR(50, 50, 50, 0.5)];
}

/*键盘搜索按钮*/
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [mySearchBar resignFirstResponder];
    
    UIView *view= (UIView *)[mySearchBar subviews][0];
    for(id control in [view subviews])
    {
        if ([control isKindOfClass:[UIButton class]])
        {
            
            UIButton * btn =(UIButton *)control;
            //            [btn setTitle:@"搜索" forState:UIControlStateNormal ];
            btn.enabled=YES;
        }
    }
    
    NSDictionary *dict = @{@"district_id":_regionButIndex,
                           @"proportion_id":_areaButIndex,
                           @"price_id":_priceButIndex,
                           };
    [self requestGetPropertyInfos:dict];
    [searchBar setShowsCancelButton:NO animated:YES];
    
}
//搜索框的内容变化
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length == 0) {
        [searchBar resignFirstResponder];
       
        [searchBar setText:@""];
        NSDictionary *dict = @{@"district_id":_regionButIndex,
                               @"proportion_id":_areaButIndex,
                               @"price_id":_priceButIndex,
                               };
        [self requestGetPropertyInfos:dict];
        [searchBar setShowsCancelButton:NO animated:YES];
        
    }
}

//cancel button clicked...
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    [searchBar setText:@""];
    NSDictionary *dict = @{@"district_id":_regionButIndex,
                           @"proportion_id":_areaButIndex,
                           @"price_id":_priceButIndex,
                           };
    [self requestGetPropertyInfos:dict];
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    
}


#pragma mark - tableViewDatasourse
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        if (_tableFirstCellData.count==0)
        {
            return 105;
        }
        else
        {
            return SCREEN_WIDTH*36/76.0 + 8;
        }
        
    }
    return 105;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_tableData.count == 0 && _tableFirstCellData.count == 0) {
        return 0;
    }
    
    if (_tableFirstCellData.count > 0) {
        return _tableData.count+1;
    }else {
        return _tableData.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *normolCellIdentifier = @"normolCell";
    static NSString *specialCellIdentifier = @"SpecialCell";
    
    //正常的cell
    RealestateListTableViewCell *cell_N;
    //特殊的cell
    RealestateHeadTableViewCell *cell_S;
    
    if (indexPath.row == 0&&_tableFirstCellData.count!=0)
    {
        cell_S = (RealestateHeadTableViewCell *)[tableView dequeueReusableCellWithIdentifier:specialCellIdentifier];
        if (cell_S == nil) {
            cell_S = [[[NSBundle mainBundle]loadNibNamed:@"RealestateHeadTableViewCell" owner:self options:nil]lastObject];
            //ios8SDK 兼容6 和 7
            if ([cell_S respondsToSelector:@selector(setLayoutMargins:)]) {
                [cell_S setLayoutMargins:UIEdgeInsetsZero];
            }
        }
        
        cell_S.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSDictionary *firstCellDict;
        
        NSMutableArray *imageArr = [NSMutableArray array];
        
        if (_tableFirstCellData.count > 0) {
            firstCellDict = [_tableFirstCellData objectAtIndex:0];
            for (int i= 0; i < _tableFirstCellData.count; i++) {
                [imageArr addObject:_tableFirstCellData[i][@"adimage_url"]];
            }
        }else {
            firstCellDict = [_tableData objectAtIndex:0];
            [imageArr addObject:firstCellDict[@"adimage_url"]];
        }
        
        cell_S.scrllImageView.contentSize = CGSizeMake((SCREEN_WIDTH-16)*imageArr.count, cell_S.scrllImageView.height);
        cell_S.scrllImageView.pagingEnabled = YES;
        cell_S.scrllImageView.delegate = self;
        cell_S.scrllImageView.showsHorizontalScrollIndicator = NO;
        cell_S.scrllImageView.directionalLockEnabled = YES;
        cell_S.scrllImageView.bounces = NO;
        
        for (UIView *scrView in cell_S.scrllImageView.subviews) {
            [scrView removeFromSuperview];
        }
        
        //滚动图片
        for (int i=0; i<imageArr.count; i++)
        {
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-16)*i, 0,(SCREEN_WIDTH-16) , SCREEN_WIDTH*36/76.0 + 8-16)];

            imageView.tag = 950 + i ;
            [imageView sd_setImageWithURL:[NSURL URLWithString:[imageArr objectAtIndex:i]] placeholderImage:[UIImage imageNamed:@"failed_img"]];
            
            UITapGestureRecognizer *imageTap = [[ UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headImageClickAction:)];
            imageView.userInteractionEnabled = YES;
            [imageView addGestureRecognizer:imageTap];
            
            [cell_S.scrllImageView addSubview:imageView];
        }
        
        _topImagePageControl.numberOfPages = imageArr.count;
        _topImagePageControl.currentPage = 0;
        cell_S.housePageControl.numberOfPages = imageArr.count;
        cell_S.housePageControl.currentPage = 0;

        NSString *propertyName = firstCellDict[@"property_name"];
        NSString *priceStr = [NSString stringWithFormat:@"%@",[firstCellDict objectForKey:@"price"]];
        NSString *brokerageStr = [NSString stringWithFormat:@"%@",[firstCellDict objectForKey:@"brokerage"]];
//        if (![priceStr isEqualToString:@"待定"])
//        {
//            priceStr = [priceStr stringByAppendingString:@"元/平米"];
//        }
//        if (![brokerageStr isEqualToString:@"待定"])
//        {
//            brokerageStr = [brokerageStr stringByAppendingString:@"元"];
//        }

        NSString *houseStr = [NSString stringWithFormat:@"%@   均价 %@   佣金 %@",propertyName,priceStr,brokerageStr];
        NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:houseStr];
        [attributeStr addAttribute:NSFontAttributeName value:Default_Font_15 range:NSMakeRange(0, propertyName.length)];
        [attributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, propertyName.length)];
        
        [attributeStr addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:Default_Font_13,NSFontAttributeName,RGBCOLOR(103, 103, 103),NSForegroundColorAttributeName,nil] range:NSMakeRange(propertyName.length+3,houseStr.length-propertyName.length-3)];
        [attributeStr addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(250, 0, 20) range:NSMakeRange(propertyName.length+3+3, priceStr.length)];
        [attributeStr addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(250, 0, 20) range:NSMakeRange(propertyName.length+3+3+priceStr.length+3+3, brokerageStr.length)];
        
        
        
        cell_S.houseInfoLabel.attributedText = attributeStr;
        
        return cell_S;
    } else {
        cell_N = (RealestateListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:normolCellIdentifier];
        if (cell_N == nil) {
            cell_N = [[[NSBundle mainBundle]loadNibNamed:@"RealestateListTableViewCell" owner:self options:nil]lastObject];
            //ios8SDK 兼容6 和 7
            if ([cell_N respondsToSelector:@selector(setLayoutMargins:)]) {
                [cell_N setLayoutMargins:UIEdgeInsetsZero];
            }
        }
        
        if (_tableData.count > 0) {
            NSDictionary *cellDict;
            
            [ProjectUtil showLog:@"indexPath.row %d",indexPath.row];
            
            if (_tableFirstCellData.count > 0) {
                cellDict = [_tableData objectAtIndex:indexPath.row-1];
            }else {
                cellDict = [_tableData objectAtIndex:indexPath.row];
            }
            
            //Get the UI elements in the cell;
            UIImageView *realestateImage = (UIImageView *)[cell_N viewWithTag:600];
            
            [ProjectUtil showLog:@"imageURL = %@",cellDict[@"image_url"]];
            [realestateImage sd_setImageWithURL:[NSURL URLWithString:cellDict[@"image_url"]] placeholderImage:[UIImage imageNamed:@"ipzs"]];
         
            UILabel *realestateNameLabel = (UILabel *)[cell_N viewWithTag:610];
            realestateNameLabel.text = cellDict[@"property_name"];
            
            UILabel *realestateMoneyLabel = (UILabel *)[cell_N viewWithTag:611];
            NSString *brokerage_type = cellDict[@"brokerage_type"];
            
            if ([brokerage_type isEqualToString:@"0"]) {
                NSString *brokerageStr = [cellDict objectForKey:@"brokerage"];
                NSMutableAttributedString *attributedStr=[[NSMutableAttributedString alloc]initWithString:brokerageStr attributes:@{NSFontAttributeName:Default_Font_13,NSForegroundColorAttributeName:RGBCOLOR(250, 0, 20)}];
                if (![brokerageStr isEqualToString:@"待定"])
                {
                    
                    [attributedStr appendAttributedString:[[NSAttributedString alloc]initWithString:@"元" attributes:@{NSForegroundColorAttributeName:RGBCOLOR(95, 95, 95)}]];
                }
                realestateMoneyLabel.attributedText = attributedStr;
            }else if ([brokerage_type isEqualToString:@"1"]) {
                realestateMoneyLabel.text = cellDict[@"brokerage_percent"];
            }else {
                realestateMoneyLabel.text = @"";
            }
            
            UILabel *signUpLabel = (UILabel *)[cell_N viewWithTag:612];
            signUpLabel.text = [NSString stringWithFormat:@"已报名 %@人",cellDict[@"referee_sum"]];
            NSString *priceStr = cellDict[@"price"];
        NSMutableAttributedString *attributedStr=[[NSMutableAttributedString alloc]initWithString:priceStr attributes:@{NSFontAttributeName:Default_Font_13,NSForegroundColorAttributeName:RGBCOLOR(250, 0, 20)}];
            if (![priceStr isEqualToString:@"待定"])
            {
                 [attributedStr appendAttributedString:[[NSAttributedString alloc]initWithString:@"元/平米" attributes:@{NSForegroundColorAttributeName:RGBCOLOR(95, 95, 95)}]];
            }

            
            UILabel *realestatePriceLabel = (UILabel *)[cell_N viewWithTag:613];
            realestatePriceLabel.attributedText = attributedStr;
            UILabel *realestateHousingLabel = (UILabel *)[cell_N viewWithTag:614];
            realestateHousingLabel.text = cellDict[@"house_resources"];
        }
        return cell_N;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSDictionary *cellDict;
    if (_tableFirstCellData.count != 0){
        if(indexPath.row == 0){
            cellDict = [_tableFirstCellData objectAtIndex:indexPath.row];
        }
        else{
            cellDict = [_tableData objectAtIndex:indexPath.row - 1];
        }
    }
    else{
        cellDict = [_tableData objectAtIndex:indexPath.row];
    }
//    if (indexPath.row == 0) {
//        if (_tableFirstCellData.count > 0) {
//            cellDict = [_tableFirstCellData objectAtIndex:indexPath.row];
//        }else {
//            cellDict = [_tableData objectAtIndex:indexPath.row];
//        }
//    }else {
//        cellDict = [_tableData objectAtIndex:indexPath.row-1];
//    }
     [self pushToDetailView:cellDict];
    
}


//房源点击事件
- (void)headImageClickAction:(UITapGestureRecognizer *)sender
{
    NSDictionary *cellDict;
    if (_tableFirstCellData.count > 0) {
        cellDict = [_tableFirstCellData objectAtIndex:sender.view.tag-950];
    }else {
        cellDict = [_tableData objectAtIndex:sender.view.tag-950];
    }
    
    [self pushToDetailView:cellDict];
}

//跳入详情界面
- (void)pushToDetailView:(NSDictionary *)cellDict
{
    //收起编辑框
    [self.view endEditing:YES];
    //隐藏 区域 面积 价格按钮
    [self hiddenItemView];
    //放弃第一响应者
    [self giveupFirstResponder];
    //
    NSString *searchStr = mySearchBar.text.length == 0?@"":mySearchBar.text;
    NSDictionary *dict = @{@"allPageCount":[NSString stringWithFormat:@"%f",allPageCount],
                           @"district_id":@"1171",
                           @"proportion_id":@"0",
                           @"price_id":@"0",
                           @"property":searchStr,
                           @"page":@"1",
                           @"size":@"10",
                           @"customization_token":self.login_user_token
                           };
    
    NSArray *allThreeBtnInfo = @[_regionTitleArray,_regionIdArray,_areaTitleArray,_areaIdArray,_priceTitleArray,_priceIdArray];

    HouseDetailViewController *houseDetailVC = [[HouseDetailViewController alloc]init];
    houseDetailVC.requestDict =  [NSMutableDictionary dictionaryWithDictionary:dict];
    houseDetailVC.title = @"详情";
    
    houseDetailVC.dataDic = cellDict;
    
    houseDetailVC.title = cellDict[@"property_name"];
    houseDetailVC.threeBtnInfoArray = allThreeBtnInfo;
    houseDetailVC.hidesBottomBarWhenPushed = YES;
    [houseDetailVC creatBackButtonWithPushType:Push With:@"首页" Action:nil];
    [self.navigationController pushViewController:houseDetailVC animated:YES];
//    [self presentViewController:houseDetailVC animated:YES completion:nil];

}

#pragma mark - ItemCollectionViewDelegate
-(void)itemCollectionView:(ItemCollectionView *)itemCollectionView DidSelectedItemIndex:(NSInteger)itemIndex ItemTitle:(NSString *)itemTitle
{

    if (itemCollectionView.tag == 1500) {
        //区域view
        
        _regionItemView.selectedItem = itemIndex;
        
        _regionButIndex = _regionIdArray[itemIndex];
        
        if (itemTitle.length > 4 && SCREEN_WIDTH ==320) {
            itemTitle = [NSString stringWithFormat:@"%@…",[itemTitle substringToIndex:4]];
        }
        
        [self updateThreeBtnTitle:_regionTitleBut BtnTitle:itemTitle BtnFont:Default_Font_18];
        
    }else if (itemCollectionView.tag == 1510) {
        //面价view
        
        _areaItemView.selectedItem = itemIndex;
        
        _areaButIndex = _areaIdArray[itemIndex];
        
        if (itemTitle.length > 5 && SCREEN_WIDTH ==320) {
            if ([itemTitle rangeOfString:@"以上"].location !=NSNotFound) {
                itemTitle = [itemTitle stringByReplacingOccurrencesOfString:@"以上" withString:@"…"];
            }else {
                itemTitle = [NSString stringWithFormat:@"%@…",[itemTitle substringToIndex:5]];
            }
        }
        
        [self updateThreeBtnTitle:_areaTitleBut BtnTitle:itemTitle BtnFont:Default_Font_18];
    }else if (itemCollectionView.tag == 1520) {
        //价格view
        
        _priceItemView.selectedItem = itemIndex;
        
        _priceButIndex = _priceIdArray[itemIndex];
        
        if (itemTitle.length > 6 && SCREEN_WIDTH ==320) {
            if ([itemTitle rangeOfString:@"以上"].location !=NSNotFound) {
                itemTitle = [itemTitle stringByReplacingOccurrencesOfString:@"以上" withString:@"…"];
            }else {
                itemTitle = [NSString stringWithFormat:@"%@…",[itemTitle substringToIndex:6]];
            }
        }
        
        [self updateThreeBtnTitle:_priceTitleBut BtnTitle:itemTitle BtnFont:Default_Font_18];
    }
    
    NSDictionary *dict = @{@"district_id":_regionButIndex,
                           @"proportion_id":_areaButIndex,
                           @"price_id":_priceButIndex,
                           };
    [self requestGetPropertyInfos:dict];
    
}

#pragma mark - 选择楼盘界面
- (void)clickSelectBtn:(id)sender
{
    
    NSString *searchStr = mySearchBar.text.length == 0?@"":mySearchBar.text;
    NSDictionary *dict = @{@"allPageCount":[NSString stringWithFormat:@"%f",allPageCount],
                           @"district_id":@"1171",
                           @"proportion_id":@"0",
                           @"price_id":@"0",
                           @"property":searchStr,
                           @"page":@"1",
                           @"size":@"10",
                           @"customization_token":self.login_user_token
                           };
    
    NSArray *allThreeBtnInfo = @[_regionTitleArray,_regionIdArray,_areaTitleArray,_areaIdArray,_priceTitleArray,_priceIdArray];
    //选择界面view
    SelectRealestateViewController *selectVC = [[SelectRealestateViewController alloc] init];
    
    [ProjectUtil showLog:@"Login_User_token= %@ ",[[NSUserDefaults standardUserDefaults] valueForKey:@"Login_User_token"]];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //判断是否登录过
    if(![defaults boolForKey:@"SalesHelper_publicNotice"])
    {
        if ([defaults valueForKey:@"Login_User_token"] != nil) {
            [self.navigationController pushViewController:selectVC animated:YES];
            
        }else {
            UINavigationController *mainNaVC = [[UINavigationController alloc] initWithRootViewController:[[LoginViewController alloc]init]];
            [self presentViewController:mainNaVC animated:YES completion:nil];
        }
        //存数据--->基本数据类型
        [defaults setBool:NO forKey:@"SalesHelper_publicNotice"];//存在公告内容
        [defaults setBool:NO forKey:@"SalesHelper_AdvertView"];//存在公告内容
        [defaults synchronize];
    }
    [ProjectUtil showLog:@"更新Rootviewcontroller"];
    
    
    selectVC.title = @"推荐";
    selectVC.requestDict = [NSMutableDictionary dictionaryWithDictionary:dict];
    
    NSMutableArray *realestateData = [NSMutableArray arrayWithArray:_tableFirstCellData];
    [realestateData addObjectsFromArray:self.filteredRealestate];
    selectVC.realestateData = realestateData;
    selectVC.threeBtnInfoArray = allThreeBtnInfo;
    selectVC.hidesBottomBarWhenPushed = YES;
    [selectVC creatBackButtonWithPushType:Push With:@"首页" Action:nil];
    //[self.navigationController pushViewController:selectVC animated:YES];
}

#pragma mark - BtnClickAction
- (void)noviceReadViewClick
{
    [ProjectUtil showLog:@"您点击了新手必读"];
    
    //储存是否需要显示新手必读
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:NO forKey:@"SalesHelper_NoviceRead"];
    [userDefaults synchronize];
    
    NSString *urlStr = @"http://g.xiaobang.cc/?id=27";
    
    ModelWebViewController *webVC = [[ModelWebViewController alloc] initWithUrlString:urlStr NavigationTitle:@"新手必读"];
    [webVC creatBackButtonWithPushType:Push With:self.title Action:nil];
    webVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webVC animated:YES];
    
    [UIView animateWithDuration:0.3 animations:^{
        _headBackViewFromTop = 0.0f;
        _noviceReadView.hidden = YES;
    } completion:^(BOOL finished) {
    }];
}

#pragma mark - BtnClickAction
- (void)clickLocationBtn:(id)sender {
    
    SetAreaProvinceViewController *provinceVC = [[SetAreaProvinceViewController alloc] init];
    provinceVC.hidesBottomBarWhenPushed = YES;
    provinceVC.title = @"选择省份";
    [provinceVC creatBackButtonWithPushType:Push With:self.title Action:nil];
    [self.navigationController pushViewController:provinceVC animated:YES];
}

//点击区域
- (void)clickRegionTitleBtn:(UIButton *)sender
{
    [self giveupFirstResponder];
    _areaItemView.hiddenItemView = YES;
    _priceItemView.hiddenItemView = YES;
    if (_regionTitleArray.count > 0) {
        _regionItemView.itemArr = _regionTitleArray;
        _regionItemView.hiddenItemView = !_regionItemView.hiddenItemView;
        _regionItemView.backgroundColor = [UIColor whiteColor];
        
        //让_regionItemView 显示在最上层
        [self.view bringSubviewToFront:_regionItemView];
    }
    
}

//点击面积
- (void)clickAreaTitleBtn:(UIButton *)sender
{
    [self giveupFirstResponder];
    _regionItemView.hiddenItemView = YES;
    _priceItemView.hiddenItemView = YES;
    if (_areaTitleArray.count > 0) {
        _areaItemView.itemArr = _areaTitleArray;
        _areaItemView.hiddenItemView = !_areaItemView.hiddenItemView;
        _areaItemView.backgroundColor = [UIColor whiteColor];
        
        //让_areaItemView 显示在最上层
        [self.view bringSubviewToFront:_areaItemView];
        
    }

}

//点击价格
- (void)clickPriceTitleBtn:(UIButton *)sender
{
    [self giveupFirstResponder];
    _regionItemView.hiddenItemView = YES;
    _areaItemView.hiddenItemView = YES;
    if (_priceTitleArray.count > 0) {
        _priceItemView.itemArr = _priceTitleArray;
        _priceItemView.hiddenItemView = !_priceItemView.hiddenItemView;
        _priceItemView.backgroundColor = [UIColor whiteColor];
        
        //让_regionItemView 显示在最上层
        [self.view bringSubviewToFront:_priceItemView];
        
    }
}

//隐藏三个Btn
- (void)hiddenItemView
{

    _priceItemView.hiddenItemView = YES;
    _regionItemView.hiddenItemView = YES;
    _areaItemView.hiddenItemView = YES;
}


#pragma mark - 后台接口调用
//面积、价格标题查询
- (void)requestGetHouseAttribute:(NSString *)type
{
    NSDictionary *dict = @{@"type":type
                           };
    RequestInterface *requestHOp = [[RequestInterface alloc] init];
    [requestHOp requestGetHouseAttributeWithParam:dict];
    
    [self.view removeGestureRecognizer:_reloadDataTap];
    
    [requestHOp getInterfaceRequestObject:^(id data) {
        [self.realestateTableView headerEndRefreshing];
        
        [ProjectUtil showLog:@"data = %@",data];
        
        if ([data[@"result"] isEqualToString:@"success"]) {
            
            NSArray *categoryArray = [NSArray arrayWithArray:data[@"record"]];
            
            //移除所有存储的信息
            [_areaTitleArray removeAllObjects];
            [_areaIdArray removeAllObjects];
            [_priceTitleArray removeAllObjects];
            [_priceIdArray removeAllObjects];
            
            if (categoryArray.count > 0) {
                NSArray *areaArray = categoryArray[1];
                [_areaTitleArray addObject:@"全部"];
                [_areaIdArray addObject:@"0"];
                for (int i=0; i<areaArray.count; i++) {
                    [_areaTitleArray addObject:areaArray[i][@"name"]];
                    [_areaIdArray addObject:areaArray[i][@"id"]];
                }
 
                areaArray = categoryArray[0];
                
                [_priceTitleArray addObject:@"全部"];
                [_priceIdArray addObject:@"0"];
                for (int i=0; i<areaArray.count; i++) {
                    [_priceTitleArray addObject:areaArray[i][@"name"]];
                    [_priceIdArray addObject:areaArray[i][@"id"]];
                }
 
            }
            _areaButIndex = @"0";
            _priceButIndex = @"0";
            
        }else {

        }
        
    } Fail:^(NSError *error) {
        [self.realestateTableView headerEndRefreshing];

        [self.view makeToast:HintWithNetError];
    }];
}

//区域标题查询
- (void)requestGetDistrict:(NSString *)type WithName:(NSString *)name
{

    NSDictionary *dict = @{@"type":type,
                           @"id":@"",
                           @"name":name
                           };
    
    [self.view hideProgressLabel];
    [self.view hideProgressView];
    [self.view removeGestureRecognizer:_reloadDataTap];
    
    [self.view makeProgressViewWithTitle:HintWithBeingLoading];

    RequestInterface *requestDOp = [[RequestInterface alloc] init];
    [requestDOp requestGetDistrictWithParam:dict];
    
    [requestDOp getInterfaceRequestObject:^(id data) {
        [self.realestateTableView headerEndRefreshing];
        [self.view hideProgressView];
        
        [ProjectUtil showLog:@"data = %@",data];
        if ([data[@"result"] isEqualToString:@"success"]) {
            
            NSMutableArray *categoryArray = [NSMutableArray arrayWithArray:data[@"record"]];
            
            [_regionTitleArray removeAllObjects];
            [_regionIdArray removeAllObjects];
            
            if (categoryArray.count > 0) {
                [_regionTitleArray addObject:@"全部"];
                [_regionIdArray addObject:data[@"request"]];
                
                for (int i=0; i<categoryArray.count; i++) {
                    [_regionTitleArray addObject:categoryArray[i][@"name"]];
                    [_regionIdArray addObject:categoryArray[i][@"id"]];
                }

                _regionButIndex = data[@"request"];

                //请求数据
                NSDictionary *dict = @{@"district_id":_regionButIndex,
                                       @"proportion_id":_areaButIndex,
                                       @"price_id":_priceButIndex
                                       };
                [self requestGetPropertyInfos:dict];

            }else {
                [_realestateTableView setHeight:0.0f];
                [self.view showProgressLabelWithTitle:HintWithNoData ViewHeight:_dataTableViewHeight];
            }
        }else {
            _regionItemView.itemArr = _regionTitleArray;
            _regionItemView.hiddenItemView = YES;
            _regionButIndex = @"0";
            
            [_realestateTableView setHeight:0.0f];
            [self.view removeGestureRecognizer:_reloadDataTap];
            [self.view showProgressLabelWithTitle:HintWithTapLoadData ViewHeight:_dataTableViewHeight];
            [self.view addGestureRecognizer:_reloadDataTap];
            [self.view makeToast:data[@"error_remark"]];
        }
        

        
    } Fail:^(NSError *error) {
        [self.realestateTableView headerEndRefreshing];
        [self.view hideProgressView];

        [self updateTableDataWithLocalDB];

        [self.view makeToast:HintWithNetError];
    }];
}

//总房产信息查询
- (void)requestGetPropertyInfos:(NSDictionary *)idDict
{
    NSString *searchStr = mySearchBar.text.length == 0?@"":mySearchBar.text;
    
    NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithObjectsAndKeys:
                               [NSString stringWithFormat:@"1"],@"page",@"10", @"size",searchStr, @"property",self.login_user_token, @"customization_token", nil];
    [dict addEntriesFromDictionary:idDict];
    
    [self.view hideProgressLabel];
    [self.view hideProgressView];
    [self.view removeGestureRecognizer:_reloadDataTap];
    
    [self.view makeProgressViewWithTitle:HintWithBeingLoading];

    RequestInterface *requestOp = [[RequestInterface alloc] init];
    [requestOp requestGetPropertyInfosWithParam:dict];
    
    [requestOp getInterfaceRequestObject:^(id data) {
        [ProjectUtil showLog:@"data = %@",data];
        [self.view hideProgressView];

        if ([data[@"result"] isEqualToString:@"success"]) {
            
            allPageCount = [data[@"count"] doubleValue];
            
            _tableFirstCellData = [NSMutableArray arrayWithArray:data[@"record"][0]];
            self.filteredRealestate = [NSMutableArray arrayWithArray:data[@"record"][1]];
            
            if (_tableFirstCellData.count > 0 && self.filteredRealestate.count > 0) {
                NSArray *array = @[currentLocationCity,data[@"record"]];
                [self insertZhipuDBAllInfo:array WithReqName:@"GetPropertyInfos"];
            }
            
            if (self.filteredRealestate.count > 0 || _tableFirstCellData.count > 0) {
                [self resetRealestateTableViewFrame];
            }else {
                [_realestateTableView setHeight:0.0f];
                [self.view showProgressLabelWithTitle:HintWithNoData ViewHeight:_dataTableViewHeight];
            }
        }else {
            [_realestateTableView setHeight:0.0f];
            [self.view removeGestureRecognizer:_reloadDataTap];
            [self.view showProgressLabelWithTitle:HintWithTapLoadData ViewHeight:_dataTableViewHeight];
            [self.view addGestureRecognizer:_reloadDataTap];
            [self.view makeToast:data[@"error_remark"]];
        }
        
    } Fail:^(NSError *error) {
        [self.view hideProgressView];
        if ([self netWorkReachable] == NotReachable) {
            [self updateTableDataWithLocalDB];
        }else {
            [_realestateTableView setHeight:0.0f];
            [self.view removeGestureRecognizer:_reloadDataTap];
            [self.view showProgressLabelWithTitle:HintWithTapLoadData ViewHeight:_dataTableViewHeight];
            [self.view addGestureRecognizer:_reloadDataTap];
            [self.view makeToast:HintWithNetError];
        }
    }];
}

#pragma mark - Refresh and load more methods

//下拉刷新的函数
- (void)refreshDataTable
{
    NSDictionary *dict = @{@"district_id":_regionButIndex,
                           @"proportion_id":_areaButIndex,
                           @"price_id":_priceButIndex,
                           @"page":[NSString stringWithFormat:@"%d",pageIndex],
                           @"size":@"10",
                           @"property":(mySearchBar.text.length > 0)?mySearchBar.text:@"",
                           @"customization_token":self.login_user_token
                           };
    
    [self.view hideProgressLabel];
    
    RequestInterface *requestOp = [[RequestInterface alloc] init];
    [requestOp requestGetPropertyInfosWithParam:dict];
    
    [requestOp getInterfaceRequestObject:^(id data) {
        [self.realestateTableView headerEndRefreshing];

        [ProjectUtil showLog:@"data = %@",data];
        if ([data[@"result"] isEqualToString:@"success"]) {
            
            allPageCount = [data[@"count"] doubleValue];

            [self.filteredRealestate removeAllObjects];
            _tableFirstCellData = [NSMutableArray arrayWithArray:data[@"record"][0]];
            [self.filteredRealestate addObjectsFromArray:data[@"record"][1]];
            
            if (_tableFirstCellData.count > 0 && self.filteredRealestate.count > 0) {

                NSArray *array = @[currentLocationCity,data[@"record"]];
                [self insertZhipuDBAllInfo:array WithReqName:@"GetPropertyInfos"];
            }
                        
            if (self.filteredRealestate.count > 0 || _tableFirstCellData.count > 0) {
                
                [self resetRealestateTableViewFrame];
            }else {
                [_realestateTableView setHeight:0.0f];
                [self.view showProgressLabelWithTitle:HintWithNoData ViewHeight:_dataTableViewHeight];
            }
            
        }else {
            [_realestateTableView setHeight:0.0f];
            [self.view removeGestureRecognizer:_reloadDataTap];
            [self.view showProgressLabelWithTitle:HintWithTapLoadData ViewHeight:_dataTableViewHeight];
            [self.view addGestureRecognizer:_reloadDataTap];
            [self.view makeToast:data[@"error_remark"]];
        }
    } Fail:^(NSError *error) {

        [self.realestateTableView headerEndRefreshing];
        [self updateTableDataWithLocalDB];
    }];
}

//上拉加载更多的函数
- (void)loadMoreDataToTable
{
    NSDictionary *dict = @{@"district_id":_regionButIndex,
                           @"proportion_id":_areaButIndex,
                           @"price_id":_priceButIndex,
                           @"page":[NSString stringWithFormat:@"%d",pageIndex],
                           @"size":@"10",
                           @"property":(mySearchBar.text.length > 0)?mySearchBar.text:@"",
                           @"customization_token":self.login_user_token
                           };
    
    [self.view hideProgressLabel];
    
    RequestInterface *requestOp = [[RequestInterface alloc] init];
    [requestOp requestGetPropertyInfosWithParam:dict];
    
    [requestOp getInterfaceRequestObject:^(id data) {
        [self.realestateTableView footerEndRefreshing];
        
        [ProjectUtil showLog:@"data = %@",data];
        if ([data[@"result"] isEqualToString:@"success"]) {
            
            allPageCount = [data[@"count"] doubleValue];
            
//            _tableFirstCellData = [NSMutableArray arrayWithArray:data[@"record"][0]];
//            [self.filteredRealestate addObjectsFromArray:data[@"record"][1]];
//            [self resetRealestateTableViewFrame];
            
            [self.view hideProgressLabel];
            [self.view hideProgressView];
            [self.view removeGestureRecognizer:_reloadDataTap];
            
            [_tableData addObjectsFromArray:data[@"record"][1]];
            [ProjectUtil showLog:[NSString stringWithFormat:@"self.headBackView.frame.origin.y %f",self.headBackView.frame.origin.y]];
            
            if (self.headBackView.frame.origin.y == _headBackViewFromTop-44) {
                [_realestateTableView setHeight:_dataTableViewHeight+44-_headBackViewFromTop];
            }else{
                [_realestateTableView setHeight:_dataTableViewHeight-_headBackViewFromTop];
            }
            
            [_realestateTableView reloadData];
        }else {
            pageIndex --;
            [self.view makeToast:data[@"error_remark"]];
        }

    } Fail:^(NSError *error) {
        pageIndex --;
        [self.realestateTableView footerEndRefreshing];
        [self.view makeToast:HintWithNetError];
    }];
    
}

//数据表的刷新
- (void)resetRealestateTableViewFrame
{
    [self.view hideProgressLabel];
    [self.view hideProgressView];
    [self.view removeGestureRecognizer:_reloadDataTap];
    
    [_tableData removeAllObjects];
    _tableData = [NSMutableArray arrayWithArray:self.filteredRealestate];
    
    [ProjectUtil showLog:[NSString stringWithFormat:@"self.headBackView.frame.origin.y %f",self.headBackView.frame.origin.y]];

    if (self.headBackView.frame.origin.y == _headBackViewFromTop-44) {
        [_realestateTableView setHeight:_dataTableViewHeight+44-_headBackViewFromTop];
    }else{
        [_realestateTableView setHeight:_dataTableViewHeight-_headBackViewFromTop];
    }
    
    [_realestateTableView reloadData];
}

//启用本地缓存的数据
- (void)updateTableDataWithLocalDB
{
    [self.view hideProgressLabel];
    [self.view hideProgressView];
    [self.view makeToast:HintWithNetError];
    [self.realestateTableView headerEndRefreshing];
    [self.realestateTableView footerEndRefreshing];
    
    NSArray *infoArray  = [self doQueryZhipuDBAllInfo:@"GetPropertyInfos"];
    NSArray *firstArray = [[NSArray alloc] init];
    if (infoArray.count == 2) {
        firstArray = infoArray[1];
    }
    
    NSString *locationStr = infoArray[0];
    
    if (locationStr != nil && [locationStr isEqualToString:currentLocationCity]) {
        if (firstArray.count > 0) {
            [self.filteredRealestate removeAllObjects];
            _tableFirstCellData = [NSMutableArray arrayWithArray:firstArray[0]];
            [self.filteredRealestate addObjectsFromArray:firstArray[1]];
            [self resetRealestateTableViewFrame];
        }else {
            [_realestateTableView setHeight:0.0f];
            [self.view removeGestureRecognizer:_reloadDataTap];
            [self.view showProgressLabelWithTitle:HintWithTapLoadData ViewHeight:_dataTableViewHeight];
            [self.view addGestureRecognizer:_reloadDataTap];
        }
    }else {
        [_realestateTableView setHeight:0.0f];
        [self.view showProgressLabelWithTitle:HintWithNoData ViewHeight:_dataTableViewHeight];
    }
}


//查询支付宝 和 银行卡账户
- (void)requestGetWithd
{
    NSDictionary *dict = @{@"token":self.login_user_token,
                           @"type":@"1",
                           @"identity":@"0"
                           };
    
    RequestInterface *requestOp = [[RequestInterface alloc] init];
    [requestOp requestGetWithdWithParam:dict];
    
    [requestOp getInterfaceRequestObject:^(id data) {
        [ProjectUtil showLog:@"data = %@",data];
        if ([data[@"result"] isEqualToString:@"success"]) {
            NSArray *accountArray = data[@"record"];
            if (accountArray.count == 0) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"设置您的钱包账户方便以后随时提现,是否现在去设置?" delegate:self cancelButtonTitle:@"跳过" otherButtonTitles:@"去设置", nil];
                alert.tag = 800;
                [alert show];
            }
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            //存数据--->基本数据类型
            [defaults setBool:NO forKey:@"SalesHelper_isNeedDrawal"];//是否需要设置提现账户
            [defaults synchronize];

        }
        
    } Fail:^(NSError *error) {
        [self.view addGestureRecognizer:_reloadDataTap];
        [self.view makeToast:HintWithNetError];
    }];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 800 ) {
        if (buttonIndex == 0) {
            [ProjectUtil showLog:@"更新取消"];
        }
        else if (buttonIndex == 1)
        {
            AddBankCardViewController *addBankVC = [[AddBankCardViewController alloc] init];
            addBankVC.title = @"添加银行卡";
            addBankVC.hidesBottomBarWhenPushed = YES;
            [addBankVC creatBackButtonWithPushType:Push With:self.title Action:nil];
            [self.navigationController pushViewController:addBankVC animated:YES];
        }
    }
    
}

@end
