//
//  ModelViewController.m
//  SalesHelper_C
//
//  Created by summer on 14-10-10.
//  Copyright (c) 2014年 X. All rights reserved.
//

#import "ModelViewController.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "FMDatabaseAdditions.h"
#import "BaseTabBarController.h"
#import "AppDelegate.h"
#import <ShareSDKUI/SSUIEditorViewStyle.h>
#import "UIColor+HexColor.h"

//#import "LoginAndRegisterViewController.h"

@interface ModelViewController ()<UINavigationControllerDelegate,UIGestureRecognizerDelegate>
{
    NSMutableArray *viewControllers;
    NSMutableArray *titles;
    NSMutableArray *selectedImages;
    NSMutableArray *unSelectedImages;
    NSMutableArray *mutArr;
}


@end

@implementation ModelViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
//    self.navigationController.navigationBar.translucent = NO;
//    
//    [self.navigationController.navigationBar setBackgroundImage:[self imageWithBgColor:[UIColor colorWithRed:23/255.0f green:183/255.0f blue:242/255.0f alpha:1]] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:[self imageWithBgColor:[UIColor colorWithRed:23/255.0f green:183/255.0f blue:242/255.0f alpha:1]]];
//    [self requestOrgCodeState];
    
}

-(void)requestOrgCodeState
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"Login_User_token"];
    if (token != nil)
    {
        NSDictionary* dict=@{
                             @"token":token
                             };
        RequestInterface *request = [[RequestInterface alloc] init];
        [request requestOrgCodeStateWithParam:dict];
        [request getInterfaceRequestObject:^(id data) {
            if (data[@"success"])
            {
                NSLog(@"orgType = %@",data);
                NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:[data[@"datas"] objectForKey:@"orgname"] forKey:@"orgName"];
                [defaults setObject:[NSString stringWithFormat:@"%@",[data[@"datas"] objectForKey:@"orgtype"]] forKey:@"orgType"];
                if ([data[@"datas"] objectForKey:@"orgcode"] == [NSNull null])
                {
                    [defaults setObject:nil forKey:@"orgCode"];
                }
                else
                {
                    [defaults setObject:[data[@"datas"] objectForKey:@"orgcode"] forKey:@"orgCode"];
                }

                [defaults synchronize];
            }
        } Fail:^(NSError *error) {
            
        }];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _login_User_name = [defaults objectForKey:@"login_User_name"];
    
    if (IOS_VERSION<7.0)
    {
//        [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:21.0/255.0 green:159/255.0 blue:234/255.0 alpha:1]];
       // self.navigationController.navigationBar.TintColor = NavigationBarColor;
    }
    else
    {
//        [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:21.0/255.0 green:159/255.0 blue:234/255.0 alpha:1]];
//        self.navigationController.navigationBar.tintColor = NavigationBarTitleColor;
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.view.backgroundColor = NavigationBarColor;
    
//    [self creatNavigationItemWithMNavigationItem:MNavigationItemTypeTitle ItemName:self.title];
    
    self.login_user_token = [[NSUserDefaults standardUserDefaults] valueForKey:@"Login_User_token"];
    self.login_user_token = self.login_user_token == nil?@"":self.login_user_token;
    
}

-(void)CreateCustomNavigtionBarWith:(id)target leftItem:(SEL)leftAction rightItem:(SEL)rightAction
{
    self.topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    self.topView.backgroundColor = [UIColor hexChangeFloat:@"00aff0"];
    self.backBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.backBtn setImage:[UIImage imageNamed:@"首页-左箭头.png"] forState:(UIControlStateNormal)];
    [self.backBtn setImage:[UIImage imageByApplyingAlpha:[UIImage imageNamed:@"首页-左箭头"]] forState:(UIControlStateHighlighted)];
    [self.backBtn addTarget:target action:leftAction forControlEvents:(UIControlEventTouchUpInside)];
    self.backBtn.frame = CGRectMake(11, 20, 30, 44);
    [self.topView addSubview:self.backBtn];

    self.rightBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.rightBtn.frame = CGRectMake(SCREEN_WIDTH-40-5, 20, 40, 44);
    [self.rightBtn addTarget:target action:rightAction forControlEvents:(UIControlEventTouchUpInside)];
    [self.topView addSubview:self.rightBtn];
    [self.view addSubview:self.topView];
}

#pragma mark  绘制图片
-(UIImage *)imageWithBgColor:(UIColor *)color {
    
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();    
    return image;
}

-(void)layoutSubViews
{
    
}
//跳入主界面
-(void)presentToMainViewController:(BOOL)flag
{
    /*
     viewControllers = [NSMutableArray array];
     titles = [NSMutableArray array];
     selectedImages = [NSMutableArray array];
     unSelectedImages = [NSMutableArray array];
     
     HomeViewController *homeVC = [[HomeViewController alloc] init];
     homeVC.title = @"销邦";
     UINavigationController *homeNaVC = [[UINavigationController alloc] initWithRootViewController:homeVC];
     if (IOS_VERSION>=7.0)
     {
         homeNaVC.interactivePopGestureRecognizer.enabled = NO;
     }
     
     LeftMenuViewController* leftVC=[[LeftMenuViewController alloc]init];
     leftVC.title=@"我";
     
     CustomViewController *customVC = [[CustomViewController alloc] init];
     customVC.title = @"联系人";
     RecommendRecordViewController *recommendVC = [[RecommendRecordViewController alloc] init];
     recommendVC.title = @"推荐记录";
     
     UINavigationController *recommendNaVC = [[UINavigationController alloc]initWithRootViewController:recommendVC];
     UINavigationController *customNaVC = [[UINavigationController alloc]initWithRootViewController:customVC];
     [self addObjectWithViewController:homeNaVC Title:@"首页" SelectedImageName:@"fangy" UnSelectedImageName:@"hfangy"];
     [self addObjectWithViewController:customNaVC Title:@"联系人" SelectedImageName:@"lkehu" UnSelectedImageName:@"kehu"];
     [self addObjectWithViewController:recommendNaVC Title:@"推荐记录" SelectedImageName:@"ltjjl" UnSelectedImageName:@"tjjl"];
     // [self addObjectWithViewController:leftVC Title:@"我" SelectedImageName:<#(NSString *)#> UnSelectedImageName:<#(NSString *)#>]
     
     UITabBarController *tabVC = [CreatCustom creatTabBarItemsWithTitle:titles SelectedImages:selectedImages UnSelectedImages:unSelectedImages ViewControllers:viewControllers selectedIndex:0];
     
     LeftMenuViewController *leftMenuVC = [[LeftMenuViewController alloc] init];
     UINavigationController *leftMenuNaVC = [[UINavigationController alloc]initWithRootViewController:leftMenuVC];
     
     //左侧 侧滑栏
     RESideMenu *sideMenuViewController = [[RESideMenu alloc] initWithContentViewController:tabVC
     leftMenuViewController:leftMenuNaVC
     rightMenuViewController:nil];
     //    sideMenuViewController.backgroundImage = [UIImage imageNamed:@"Stars"];
     sideMenuViewController.menuPreferredStatusBarStyle = 1; // UIStatusBarStyleLightContent
     
     sideMenuViewController.delegate = self;
     sideMenuViewController.contentViewShadowColor = [UIColor blackColor];
     sideMenuViewController.contentViewShadowOffset = CGSizeMake(0, 0);
     sideMenuViewController.contentViewShadowOpacity = 0.6;
     sideMenuViewController.contentViewShadowRadius = 12;
     sideMenuViewController.contentViewShadowEnabled = YES;
     self.view.window.rootViewController = sideMenuViewController;
     */
#if 0
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UITabBarController * tabVC = [storyboard instantiateViewControllerWithIdentifier:@"mainTBC"];

#else
    
    
    mutArr = [NSMutableArray array];
    BaseTabBarController* tabVC = [[BaseTabBarController alloc]initWithNibName:@"BaseTabBarController" bundle:nil];
    
    NSArray* Controllers = @[@"HomeTabViewController",@"BangHuiFirstViewController",@"NewMyClientViewController",@"MineViewController"];
    for (int i=0; i<4; i++) {
        
        Class cl = NSClassFromString(Controllers[i]);
    
        UIViewController* vc = [[cl alloc]init];
        UINavigationController* nav = [[UINavigationController alloc]initWithRootViewController:vc];
        nav.interactivePopGestureRecognizer.delegate = self;
        [mutArr addObject:nav];
    }
    tabVC.viewControllers = mutArr;
    
#endif
    UITabBar * tabBar = tabVC.tabBar;
    tabBar.tintColor = [UIColor colorWithRed:23/255.0f green:183/255.0f blue:242/255.0f alpha:1];    
    
    UITabBarItem * homeItem = tabBar.items[0];
     homeItem.title = @"首页";
    homeItem.image = [[UIImage imageNamed:@"home1-1-0"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    homeItem.selectedImage = [[UIImage imageNamed:@"home1-0"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    
    UITabBarItem * clientItem = tabBar.items[1];
    clientItem.title = @"邦会";
    clientItem.image = [[UIImage imageNamed:@"邦会-默认"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    clientItem.selectedImage = [[UIImage imageNamed:@"邦会-选中"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    
    UITabBarItem * phoneItem = tabBar.items[2];
    phoneItem.title = @"客户";
    phoneItem.image = [[UIImage imageNamed:@"客户-默认0"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    phoneItem.selectedImage = [[UIImage imageNamed:@"客户-选中0"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UITabBarItem * myItem = tabBar.items[3];
    myItem.title = @"我的";
    myItem.image = [[UIImage imageNamed:@"我的-默认0"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    myItem.selectedImage = [[UIImage imageNamed:@"我的-选中0"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabBar.backgroundColor = [UIColor whiteColor];
    
    [SSUIEditorViewStyle setiPhoneNavigationBarBackgroundColor:[UIColor colorWithHexString:@"00aff0"]];
    [SSUIEditorViewStyle setShareButtonLabelColor:[UIColor whiteColor]];
    [SSUIEditorViewStyle setCancelButtonLabelColor:[UIColor whiteColor]];
    [SSUIEditorViewStyle setTitleColor:[UIColor whiteColor]];
//    LeftRootViewController* slideVC = [[LeftRootViewController alloc]init];
//    LeftSlideViewController* leftSlideVC = [[LeftSlideViewController alloc]initWithLeftView:slideVC andMainView:tabVC];
//    [leftSlideVC setPanEnabled:NO];
    [[UIApplication sharedApplication].keyWindow setRootViewController:tabVC];
}

-(void)addObjectWithViewController:(UIViewController *)viewController Title:(NSString *)title SelectedImageName:(NSString *)selectedImageName UnSelectedImageName:(NSString *)unSelectedImageName
{
    [viewControllers addObject:viewController];
    [titles addObject:title];
    [selectedImages addObject:selectedImageName];
    [unSelectedImages addObject:unSelectedImageName];
}

//创建NavigationItem 
-(void)creatNavigationItemWithMNavigationItem:(MNavigationItemType)itemType ItemName:(NSString *)imageName
{
    
    if (itemType==MNavigationItemTypeTitle)
    {
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.text = imageName;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:18];

        self.navigationItem.titleView = titleLabel;
    }
    
    if (itemType==MNavigationItemTypeRight)
    {
        UIImage *image = [UIImage imageNamed:imageName];
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        rightButton.frame = CGRectMake(0, 0, image.size.width, image.size.height);
        rightButton.tag = MNavigationItemTypeRight;
        [rightButton setImage:image forState:UIControlStateNormal];
        [rightButton setBackgroundImage:[UIImage imageByApplyingAlpha:image] forState:UIControlStateHighlighted];

        [rightButton addTarget:self action:@selector(modelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    }
}

#pragma mark -- 创建导航栏返回按钮
- (void)creatBackButtonWithPushType:(PushType)pushType With:(NSString *)leftBtnTitle Action:(SEL)action
{

//    UIFont *font = [UIFont systemFontOfSize:20];
    
//    CGSize strSize = [leftBtnTitle sizeWithFont:font
//                              constrainedToSize:CGSizeMake(50.f, MAXFLOAT)
//                                  lineBreakMode:NSLineBreakByWordWrapping];
    CGSize strSize = [leftBtnTitle boundingRectWithSize:CGSizeMake(50.f, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20]} context:nil].size;
    [ProjectUtil showLog:@"labelSize %f  %f",strSize.width,strSize.height];
    
    if (action == nil) {
        action = @selector(backToFormViewController:);
    }
    
//    左侧返回按妞
    UIButton* leftbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftbtn.frame = CGRectMake(0, 0, 26, 26);
    [leftbtn setBackgroundImage:[UIImage imageNamed:@"首页-左箭头.png"] forState:UIControlStateNormal];
    [leftbtn setBackgroundImage:[UIImage imageByApplyingAlpha:[UIImage imageNamed:@"首页-左箭头.png"]] forState:UIControlStateHighlighted];

    [leftbtn addTarget:self action:@selector(backlastView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* back = [[UIBarButtonItem alloc]initWithCustomView:leftbtn];
    self.navigationItem.leftBarButtonItem = back;
   
}

- (void)backlastView
{
    [self.navigationController popViewControllerAnimated:YES];

}

-(void)backToFormViewController:(UIButton *)sender
{
    if (sender.tag == Present)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    if (sender.tag == Push)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//获取月份和年份
-(NSAttributedString *)getDateWithYear:(NSInteger)year Month:(NSInteger)month Index:(NSInteger)index
{
    
    if (index<0)
    {
        for (int i=0; i<-index; i++)
        {
            month-=1;
            if (month==0)
            {
                month=12;
                year-=1;
            }
        }
    }
    else if (index>0)
    {
        for (int i=0; i<index; i++)
        {
            month+=1;
            if (month==13)
            {
                month=1;
                year+=1;
            }
        }
    }
    NSString *calendStr = [NSString stringWithFormat:@"%ld/%ld",(long)month,(long)year];
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:calendStr];
    [attributedStr addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:Default_Font_20,NSFontAttributeName, nil] range:NSMakeRange(0, calendStr.length-5)];
    [attributedStr addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:Default_Font_15,NSFontAttributeName, nil] range:NSMakeRange(calendStr.length-5,5)];
    return attributedStr;
}


-(void)modelButtonAction:(UIButton *)sender
{
    mbuttonBlock (sender.tag);
}

-(void)setMButtonAction:(MButtonBlock)ablock
{
    mbuttonBlock = [ablock copy];
}

//创建自定义button
-(UIButton *)creatUIButtonWithFrame:(CGRect)frame BackgroundColor:(UIColor *)backgroundColor Title:(NSString *)title TitleColor:(UIColor *)titleColor Action:(SEL)action
{
    if (backgroundColor==nil)
    {
        backgroundColor = [UIColor clearColor];
    }
    UIButton *button;
    if (IOS_VERSION<7.0)
    {
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    }
    else
    {
        button = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    button.frame = frame;
    
    [button setBackgroundColor:backgroundColor];
    if (titleColor==nil)
    {
        titleColor = [UIColor whiteColor];
        button.titleLabel.font = Default_Font_17;
    }
    else
    {
        button.titleLabel.font = Default_Font_17;
    }
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateHighlighted];
    [button setTitleColor:titleColor forState:UIControlStateHighlighted];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

-(UIBarButtonItem *)creatNegativeSpacerButton
{
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -5;
    return negativeSpacer;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//创建特定button
-(UIButton *)creatSpecialButtonWithFrame:(CGRect)frame Title:(NSString *)title WithImage:(NSString *)imageName Action:(SEL)action
{
    UIFont *font = [UIFont systemFontOfSize:15];
    
//    CGSize strSize = [title sizeWithFont:font
//                              constrainedToSize:CGSizeMake(50.f, MAXFLOAT)
//                                  lineBreakMode:NSLineBreakByWordWrapping];
    CGSize strSize = [title boundingRectWithSize:CGSizeMake(50.f, MAXFLOAT) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    
    [ProjectUtil showLog:@"labelSize %f  %f",strSize.width,strSize.height];
    
    UIButton *titleBtn;
    if (IOS_VERSION<7.0)
    {
        titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        titleBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    }
    else
    {
        titleBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    }
    titleBtn.frame = frame;

    NSString *titleBtnImagePath = [[NSBundle mainBundle] pathForResource:imageName ofType:@"png"];
    UIImage *image = [UIImage imageWithContentsOfFile:titleBtnImagePath];
    [titleBtn setImage:image forState:UIControlStateNormal];
    
    [titleBtn setTintColor:RGBACOLOR(95, 95, 95, 1)];
  
    [titleBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)];
    
    if (SCREEN_WIDTH > 320) {
        [titleBtn setImageEdgeInsets:UIEdgeInsetsMake(0.0, strSize.width/2 + titleBtn.width/2+8, 0.0, 0.0)];
    }else {
        [titleBtn setImageEdgeInsets:UIEdgeInsetsMake(2.0, strSize.width/2 + titleBtn.width/2+5, 0.0, 0.0)];
    }

    
    titleBtn.titleLabel.font = font;
    [titleBtn setTitle:title forState:UIControlStateNormal];
    [titleBtn setTitleColor:RGBACOLOR(95, 95, 95, 1) forState:UIControlStateNormal];

    [titleBtn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    return titleBtn ;
}

//更新特定button的样式
- (void)updateThreeBtnTitle:(UIButton *)button BtnTitle:(NSString *)title BtnFont:(UIFont *)font
{
//    CGSize strSize = [title sizeWithFont:font
//                           constrainedToSize:CGSizeMake(MAXFLOAT,44.0f)
//                               lineBreakMode:NSLineBreakByWordWrapping];
    CGSize strSize = [title boundingRectWithSize:CGSizeMake(MAXFLOAT,44.0f) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil].size;
    
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateHighlighted];
    
    [button setImageEdgeInsets:UIEdgeInsetsMake(2.0, strSize.width/2+button.width/2, 0.0, 0)];
    
    if (SCREEN_WIDTH > 320) {
        [button setImageEdgeInsets:UIEdgeInsetsMake(0.0, strSize.width/2 + button.width/2+8, 0.0, 0.0)];
    }else {
        [button setImageEdgeInsets:UIEdgeInsetsMake(2.0, strSize.width/2+button.width/2+5, 0.0, 0)];
    }
}

#pragma mark - ModifyUIsearchBar   cancelButton color
- (void)modifySearchBarCancelBtn:(UISearchBar *)searchBar Color:(UIColor *)color
{
    // 修改UISearchBar右侧的取消按钮文字颜色及背景图片
    UIView *view= (UIView *)[searchBar subviews][0];
    for (id searchbuttons in [view subviews]){
        if ([searchbuttons isKindOfClass:[UIButton class]]) {
            UIButton *cancelButton = (UIButton*)searchbuttons;
            // 修改文字颜色
            [cancelButton setTitleColor:color forState:UIControlStateNormal];
            [cancelButton setTitleColor:color forState:UIControlStateHighlighted];
        }
    }
}

//保存数据时插入页面传送过来的数据
- (void)insertZhipuDBAllInfo:(NSArray *)dataArray WithReqName:(NSString *)requestName
{
    
    //开始操作数据库
    FMDatabase *db = [FMDatabase databaseWithPath:[ProjectUtil fileFMDatabasePath]];
    NSString * alertMessage = @"";
    
    if ([db open]) {
        
        NSData *jsonData = [ProjectUtil JSONString:dataArray];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                     encoding:NSUTF8StringEncoding];
        
        //将特殊的字符' 转为特殊符号存储
        jsonString = [jsonString stringByReplacingOccurrencesOfString:@"'" withString:@"|*||*|"];
        
        //获得保存时间
        NSDate *nowDate = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *strDate = [formatter stringFromDate:nowDate];
        
        //先查询此条数据是否存在，若存在则删除 为更新做准备
        NSString *sql_query = [NSString stringWithFormat:@"select * from ZhipuRecordDB where REQUESTNAME = '%@'",requestName];
        
        NSString * queryInfo =[db stringForQuery:sql_query];
        
        if (queryInfo != nil) {//数据库有此条数据
            
            NSString *sql = [NSString stringWithFormat:@"UPDATE ZhipuRecordDB SET INTERFACEINFO = '%@' , INSERTTIME = '%@' WHERE REQUESTNAME = '%@'",jsonString,strDate,requestName];
            
            //更新数据库 数据
            BOOL res = [db executeUpdate:sql];
            if (res) {
                alertMessage = [NSString stringWithFormat:@"数据更新成功，请返回！"];
                [ProjectUtil showLog:@"ZhipuRecordDB %@",alertMessage];
            } else {
//                [ProjectUtil showAlert:@"确定" message:[NSString stringWithFormat:@"数据保存失败"]];
            }
        }else {
            NSMutableString *keys = [NSMutableString stringWithString:@"REQUESTNAME,INTERFACEINFO,INSERTTIME"];
            NSMutableString *values = [NSMutableString stringWithFormat:@"'%@','%@','%@' ",requestName,jsonString,strDate];
            
            //对数据库进行数据插入
            NSString *sql = [NSString stringWithFormat:@"insert into ZhipuRecordDB (%@) values(%@) ",keys,values];
            
            BOOL res = [db executeUpdate:sql];
            if (res) {
                alertMessage = [NSString stringWithFormat:@"数据插入成功，请返回！"];
                [ProjectUtil showLog:@"ZhipuRecordDB %@",alertMessage];
            } else {
//                [ProjectUtil showAlert:@"确定" message:[NSString stringWithFormat:@"数据保存失败"]];
            }
        }
        
        [db close];
    }
}

//查询所有的存储的信息
-(id)doQueryZhipuDBAllInfo:(NSString *)requestName
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    id interFaceContent;
    
    if ([fileManager fileExistsAtPath:[ProjectUtil fileFMDatabasePath]]) {
        //开始操作数据库
        FMDatabase *db = [FMDatabase databaseWithPath:[ProjectUtil fileFMDatabasePath]];

        if ([db open]) {
            FMResultSet *SaveData = [db executeQuery:[NSString stringWithFormat:@"select * from ZhipuRecordDB where REQUESTNAME = '%@'",requestName]];//

            while ([SaveData next]) {
                NSString *interFaceInfo = [SaveData stringForColumn:@"INTERFACEINFO"];
                //将存储的特殊的字符|*||*| 转为特殊符号'
                interFaceInfo = [interFaceInfo stringByReplacingOccurrencesOfString:@"|*||*|" withString:@"'"];
                
                [ProjectUtil showLog:@"数据库存储的信息 = %@",interFaceInfo];
                
                interFaceContent = [NSJSONSerialization JSONObjectWithData:[interFaceInfo dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
            }

            [db close];
        }
    }
    
    return interFaceContent;

}
//检测网络情况
- (NSInteger)netWorkReachable
{
    Reachability *r = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    
    return [r currentReachabilityStatus];
}
-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    //开启滑动手势
    if ([navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

@end
