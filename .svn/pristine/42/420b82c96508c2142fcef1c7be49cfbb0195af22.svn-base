//
//  BHNewHuaTiViewController.m
//  SalesHelper_A
//
//  Created by zhipu on 16/3/17.
//  Copyright © 2016年 X. All rights reserved.
//

#import "BHNewHuaTiViewController.h"

#import "BHNewPersonViewController.h"
#import "PrisedViewController.h"
#import "BHPostDetailViewController.h"

#import "UIColor+HexColor.h"
#import "AFHTTPRequestOperationManager.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import "BHFirstZanModel.h"
#import "ZJPostHead.h"
#import "ZJPostFirstLikeView.h"
#import "ZJPostNewBottomBar.h"
#import "HWComposeController.h"
#import "ZJHuaTiCell.h"
#import "BHHuaTiModel.h"
#import "TransitionsManager.h"
#import "SVPullToRefresh.h"
#import "ZJPostPingLunView.h"
#import "HWContentsLabel.h"
#import "ZJPostPicView.h"
#import "JLPhotoBrowser.h"
#import "JLPhoto.h"
#import "ZJForwardView.h"

@interface BHNewHuaTiViewController ()<UITableViewDataSource,UITableViewDelegate,ZJPostHeadDelegate,ZJPostFirstLikeViewDelegate,ZJPostNewBottomBarDelegate,ZJPostPicViewDelegate,ZJForwardViewDelegate>

@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) NSMutableArray *listArr;
@property (nonatomic, strong) NSMutableArray *zanArr;

@property (nonatomic, strong) NSMutableDictionary *dic;
//@property (nonatomic, strong) UIImageView *imgHead;
@property (nonatomic, strong) NSString *loginuid;

@property (nonatomic, strong)UILabel *lblName;
@property (nonatomic, strong) UIActivityIndicatorView *Refresh;

@property (nonatomic, strong) UIImageView *imgHead;
@property (nonatomic, strong) UILabel *lblNum;
//@property (nonatomic, strong)  UIVisualEffectView *effectView;
@property (nonatomic, strong) UIView *effView;
@property (nonatomic, assign) BOOL isOpen;
@property (nonatomic, strong) UIButton *btnMore;
@property (nonatomic, strong) ZJPostPicView *picView;

@end

@implementation BHNewHuaTiViewController

-(NSMutableArray *)zanArr
{
    if (_zanArr == nil) {
        self.zanArr = [NSMutableArray array];
    }
    return _zanArr;
}
-(NSMutableArray *)listArr
{
    if (_listArr == nil) {
        self.listArr = [NSMutableArray array];
    }
    return _listArr;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeFram:) name:@"changeFram" object:nil];

}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"changeFram" object:nil];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *longinuid =  [defaults objectForKey:@"id"];
    self.loginuid = [NSString stringWithFormat:@"%@",longinuid];
    //改变点赞状态
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeZanState:) name:@"changeZanState" object:nil];
    //改变关注的状态
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeGuanState:) name:@"changeGuanState" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTablew:) name:@"refreshTablew" object:nil];

    _page = 1;
    [self requeestHuaTiListData:NO];
    [self requestTopData];
    [self createTableView];
    [self createTopView];
    [self refresh];
    self.tableview.backgroundColor = [UIColor colorWithHexString:@"efeff4"];
    
    self.btnMore = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.btnMore.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.btnMore setTitle:@"展开" forState:(UIControlStateNormal)];
    [self.btnMore setTitle:@"收起" forState:UIControlStateSelected];
    [self.btnMore setTitleColor:[UIColor colorWithHexString:@"00aff0"] forState:(UIControlStateNormal)];
    [self.btnMore addTarget:self action:@selector(openMoreData:) forControlEvents:(UIControlEventTouchUpInside)];
}

- (void)fanhui
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)refreshTablew:(NSNotification *)noti
{
    
    _page = 1;
    [self requeestHuaTiListData:YES];
//   NSInteger nuber = [self.dic[@"Hnum"] integerValue];
    [self requestTopData];
//    self.lblNum.text = [NSString stringWithFormat:@"已有%ld人参与话题讨论",(long)++nuber];
    
    
//    self.lblNum.text = [NSString stringWithFormat:@"%@",self.dic[@"Hnum"]];
    
}
#pragma mark - 网络请求－话题列表
- (void)requeestHuaTiListData:(BOOL)isDelet
{
//    [self.view Loading_0314];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *loginuid =  [defaults objectForKey:@"id"];
    NSString *city = [defaults objectForKey:@"location_City"];
    RequestInterface *interface = [[RequestInterface alloc]init];
    
    if (_huatiid != nil)
    {
        NSDictionary *dic = @{
                              @"istype":@"2",
                              @"loginuid":loginuid,
                              @"typeid":self.huatiid,
                              @"city":city,
                              @"p":@(_page)
                              };
        [interface requestBHCircleListWithDic:dic];
        [interface getInterfaceRequestObject:^(id data)
         {
//             NSLog(@"%@",data);
             if ([data[@"success"] boolValue] == YES)
             {
                 if ([data[@"datas"] count] != 0)
                 {
                     if (isDelet == YES) {
                         [self.listArr removeAllObjects];
                         [self.zanArr removeAllObjects];
                     }
                     for (NSDictionary *dict in data[@"datas"])
                     {
                         BHHuaTiModel *model = [[BHHuaTiModel alloc]init];
                         [model setValuesForKeysWithDictionary:dict];
                         [self.listArr addObject:model];
                         NSMutableArray *arr = [NSMutableArray array];
                         for (NSDictionary *dicti in model.zan)
                         {
                             BHFirstZanModel *model = [[BHFirstZanModel alloc]init];
                             [model setValuesForKeysWithDictionary:dicti];
                             [arr addObject:model];
                         }
                         [self.zanArr addObject:arr];
                         
                     }
                     [self.Refresh stopAnimating];
//                     [self.view Hidden];
                     [self.tableview.infiniteScrollingView stopAnimating];
                     [self.tableview reloadData];
                 }
                 else
                 {
                     [self.Refresh stopAnimating];
//                     [self.view Hidden];
                     [self.tableview.infiniteScrollingView stopAnimating];
                     [self.view makeToast:data[@"message"]];
                 }
             }
             else
             {
                 [self.Refresh stopAnimating];
//                 [self.view Hidden];
                 [self.tableview.infiniteScrollingView stopAnimating];
                 [self.view makeToast:data[@"message"]];
             }
         } Fail:^(NSError *error)
         {
             [self.Refresh stopAnimating];
//             [self.view Hidden];
             [self.tableview.infiniteScrollingView stopAnimating];
             [self.view makeToast:@"请求失败"];
         }];
    }
    
}


#pragma mark - 顶部数据
- (void)requestTopData
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *city = [defaults objectForKey:@"location_City"];
    NSString *loginuid =  [defaults objectForKey:@"id"];

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *parame = [NSMutableDictionary dictionary];
    parame[@"subjectid"] = _huatiid;
    parame[@"city"] = city;
    parame[@"loginuid"] = loginuid;
    NSString *url = [NSString stringWithFormat:@"%@/index.php/Apis/Forum/getSubjectInfo/",BANGHUI_URL];
    [manager POST:url parameters:parame
          success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if ([responseObject[@"success"] boolValue] == YES)
         {
             NSLog(@"%@",responseObject);
             self.dic = responseObject[@"datas"];
             [self createHeaderView];
             self.lblName.text = self.dic[@"topic"];
             NSString *num = [NSString stringWithFormat:@"已有%@人参与话题讨论",self.dic[@"Hnum"]];
             self.lblNum.text = num;
            [self.imgHead sd_setImageWithURL:[NSURL URLWithString:self.dic[@"imgpath"]]];
             [self.tableview reloadData];
         }
         else
         {
             
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
     }];
    
}

- (void)createHeaderView
{
//    UIView *view = [[UIView alloc]init];
//    UILabel *lblContents = [[UILabel alloc]init];
//    lblContents.x = 10;
//    lblContents.width = SCREEN_WIDTH-20;
//    lblContents.y = 5;
//    lblContents.numberOfLines = 0;
//    lblContents.height = [BHNewHuaTiViewController heightForString:self.dic[@"contents"] font:15 width:SCREEN_WIDTH-20];
//    lblContents.textColor = [UIColor colorWithHexString:@"676767"];
//    lblContents.font = [UIFont systemFontOfSize:15];
//    lblContents.text = self.dic[@"contents"];
//    [view addSubview:lblContents];
//    
//    view.frame =CGRectMake(0, 0, SCREEN_WIDTH, [BHNewHuaTiViewController heightForString:self.dic[@"contents"] font:15 width:SCREEN_WIDTH-20]+20);
//    
//    view.backgroundColor = [UIColor whiteColor];
//    self.tableview.tableHeaderView = view;
    
    
}

#pragma mark -视图创建
- (void)createTableView
{
    
    self.tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.bounds.size.height) style:UITableViewStyleGrouped];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview registerClass:[ZJHuaTiCell class] forCellReuseIdentifier:@"ZJHuaTiCell"];
    self.tableview.separatorStyle = UITableViewCellAccessoryNone;
    [self.view addSubview:self.tableview];
    
    //    UIWindow *window = [UIApplication sharedApplication].keyWindow;
   

    self.imgHead = [[UIImageView alloc]initWithFrame:CGRectMake(0, -190, SCREEN_WIDTH, 190)];
    //    self.imgHead.image = [UIImage imageNamed:@"pp_bg"];
    self.imgHead.contentMode = UIViewContentModeScaleAspectFill;
    self.imgHead.clipsToBounds = YES;
    self.imgHead.autoresizesSubviews = YES;
    self.imgHead.userInteractionEnabled = YES;
    self.tableview.contentInset = UIEdgeInsetsMake(190, 0, 0, 0);
    //    self.tableview.tableFooterView = [[UIView alloc]init];
    [self.tableview addSubview:self.imgHead];
    
    
    
    self.effView = [[UIView alloc]init];
    self.effView.frame = CGRectMake(0, -190, SCREEN_WIDTH, 190);
    self.effView.backgroundColor = [UIColor blackColor];
    self.effView.alpha = 0.5;
    [self.tableview addSubview:self.effView];
    
    self.lblNum = [[UILabel alloc]initWithFrame:CGRectMake(10, self.imgHead.height-10-20, SCREEN_WIDTH-20, 20)];
    self.lblNum.font = [UIFont systemFontOfSize:13];
    self.lblNum.textColor = [UIColor colorWithHexString:@"ffffff"];
    self.lblNum.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [self.effView addSubview:self.lblNum];

    self.Refresh = [[UIActivityIndicatorView alloc]init];
    self.Refresh.bounds = CGRectMake(0, 0, SCREEN_WIDTH, 30);
    self.Refresh.centerX = self.imgHead.centerX;
    self.Refresh.centerY = self.imgHead.centerY;
    //    self.Refresh.backgroundColor = [UIColor redColor];
    [self.Refresh startAnimating];
    self.Refresh.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [self.tableview addSubview:self.Refresh];
    
}
- (void) doHandlePanAction:(UIPanGestureRecognizer *)paramSender{
    
    CGPoint point = [paramSender translationInView:self.view];
    NSLog(@"X:%f;Y:%f",point.x,point.y);
    
    paramSender.view.center = CGPointMake(paramSender.view.center.x + point.x, paramSender.view.center.y + point.y);
    
    [paramSender setTranslation:CGPointMake(0, 0) inView:self.view];
    
    
}

#pragma mark -跳转到发帖页面
- (void)pushToSub
{
    if ([GetOrgType isEqualToString:@"2"]) {
        
        HWComposeController *subVC = [[HWComposeController alloc]init];
        UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:subVC];
        subVC.subject_id = _huatiid;
        subVC.subjectTitle = self.dic[@"topic"];
        [self presentViewController:navi animated:YES completion:nil];
    }
    else
    {
        [self zanErrorAlertView:nil message:@"您无权限进行此操作，请先绑定机构码"];
    }
}

- (void)createTopView
{
    [self CreateCustomNavigtionBarWith:self leftItem:@selector(returnPage) rightItem:nil];
    [self.backBtn setImage:[UIImage imageNamed:@"bc-1"] forState:(UIControlStateNormal)];
    [self.backBtn setImage:[UIImage imageByApplyingAlpha:[UIImage imageNamed:@"bc-1"]] forState:(UIControlStateHighlighted)];
    self.topView.backgroundColor = [UIColor clearColor];
    
    self.lblName = [[UILabel alloc]initWithFrame:CGRectMake(41, 20, SCREEN_WIDTH-82, 44)];
    self.lblName .textColor = [UIColor colorWithHexString:@"ffffff"];
    self.lblName .font = [UIFont systemFontOfSize:18];
    self.lblName .textAlignment = NSTextAlignmentCenter;
//    self.lblName .tag = 507;
    [self.topView addSubview:self.lblName ];
    
    UIButton *btnMain = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btnMain.frame = CGRectMake(SCREEN_WIDTH-52-10, self.view.height-50-20, 52, 52);
    [btnMain setImage:[UIImage imageNamed:@"myadd-1-0"] forState:(UIControlStateNormal)];
    [btnMain addTarget:self action:@selector(pushToSub) forControlEvents:(UIControlEventTouchUpInside)];
    btnMain.alpha = 0;
    [UIView animateWithDuration:0.5 animations:^{
        btnMain.alpha = 1;
    }];
    UIPanGestureRecognizer * panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                            action:@selector(doHandlePanAction:)];
    [btnMain addGestureRecognizer:panGestureRecognizer];
    
    [self.view addSubview:btnMain];
}


#pragma mark-自适应宽度
+ (CGFloat)heightForString:(NSString *)str font:(CGFloat)font width:(CGFloat)width
{
    NSDictionary *dic = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:font] forKey:NSFontAttributeName];
    CGRect bound = [str boundingRectWithSize:CGSizeMake(width, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    return bound.size.height;
}



- (void)refresh
{
    [self.tableview triggerPullToRefresh];
    __block BHNewHuaTiViewController *test = self;
//    [self.tableview addFooterWithCallback:^{
//        test.page ++;
//        [test requeestHuaTiListData:NO];
//        [test.tableview footerEndRefreshing];
//        
//    }];
//    [self.tableview addHeaderWithCallback:^{
//        test.page = 1;
//        [test requeestHuaTiListData:YES];
//        [test.tableview headerEndRefreshing];
//    }];
    [self.tableview addInfiniteScrollingWithActionHandler:^{
       
            test.page ++;
            [test requeestHuaTiListData:NO];
//            [test.tableview.infiniteScrollingView stopAnimating];
        
    }];

}






#pragma mark - tableview代理
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        CGSize maxSize = CGSizeMake(SCREEN_WIDTH-20, 120);
        CGSize lblContentsSize;
        if (_isOpen == NO) {
            lblContentsSize = [self.dic[@"contents"] boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
        }else
        {
            lblContentsSize = [self.dic[@"contents"] boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-20, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
        }
        
        CGFloat height = [BHNewHuaTiViewController heightForString:self.dic[@"contents"] font:15 width:SCREEN_WIDTH-20];
        
        if (height > 120)
        {

            return lblContentsSize.height+30+5+8;
        }else
        {
            return lblContentsSize.height+8+10;
        }
    } else {
        return 8;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        
        UIView *view = [[UIView alloc]init];
        UILabel *lblContents = [[UILabel alloc]init];
        lblContents.x = 10;
        lblContents.width = SCREEN_WIDTH-20;
        lblContents.y = 5;
        lblContents.numberOfLines = 0;
    
        CGSize maxSize = CGSizeMake(SCREEN_WIDTH-20, 120);
        CGSize lblContentsSize;
        if (_isOpen == NO) {
            
            lblContentsSize = [self.dic[@"contents"] boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
        }else
        {
            lblContentsSize = [self.dic[@"contents"] boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-20, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
        }
        lblContents.height = lblContentsSize.height;
        lblContents.textColor = [UIColor colorWithHexString:@"676767"];
        lblContents.font = [UIFont systemFontOfSize:15];
        lblContents.text = self.dic[@"contents"];
        [view addSubview:lblContents];
        
        
        self.btnMore.frame = CGRectMake(10, lblContentsSize.height+10, 45, 20);
        [view addSubview:self.btnMore];
        
        UIView *lineView = [[UIView alloc]init];
        lineView.x = 0;
        lineView.width = SCREEN_WIDTH;
        lineView.height = 8;
        lineView.backgroundColor = [UIColor colorWithHexString:@"efeff4"];
        [view addSubview:lineView];
        
         CGFloat height = [BHNewHuaTiViewController heightForString:self.dic[@"contents"] font:15 width:SCREEN_WIDTH-20];
        if (height > 120)
        {
            _btnMore.hidden = NO;
            lineView.y = lblContentsSize.height+35;
        }
        else
        {
            _btnMore.hidden = YES;
            lineView.y = lblContentsSize.height+15;
        }
        
        view.frame =CGRectMake(0, 0, SCREEN_WIDTH, lblContentsSize.height+CGRectGetMaxY(_btnMore.frame)+5+8);

        view.backgroundColor = [UIColor whiteColor];
        return view;
    }else
    {
        
        return nil;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return 1;
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.listArr.count == 0)
    {
        return 1;
    }
    else
    {
        return self.listArr.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    ZJHuaTiCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZJHuaTiCell" forIndexPath:indexPath];
    
    if (self.listArr.count != 0) {
        BHHuaTiModel *model = self.listArr[indexPath.section];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.zanArr = self.zanArr[indexPath.section];
        
        cell.postHeadView.loginuid = self.loginuid;
        
        cell.model = model;
        
        cell.postHeadView.btnGuanZhu.tag = indexPath.section;
        cell.postHeadView.imgHead.tag = [model.uid integerValue];
        cell.postHeadView.delegate = self;
        
        cell.postNewBar.delegate = self;
        cell.postNewBar.btnComm.tag = indexPath.section;
        cell.postNewBar.btnZan.tag = indexPath.section;
        cell.postNewBar.btnShare.tag = indexPath.section;
        
        cell.postPingView.likeView.delegate = self;
        cell.postPingView.likeView.indexpath = indexPath;
        cell.lblbody.tag = indexPath.section;
        
        cell.postPicView.delegate = self;
        cell.postPicView.indexpath = indexPath;
        
        cell.postPingView.likeView.btnZanCount.tag = [model.tieZiID integerValue];
        
        cell.forwardView.delegate = self;
        cell.forwardView.indexpath = indexPath;
        
    }
    else{
        cell.clipsToBounds = YES;
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.listArr.count != 0) {
        BHHuaTiModel *model = self.listArr[indexPath.section];
        
        return [ZJHuaTiCell heightForModel:model zanArr:self.zanArr[indexPath.section]];
        
    }else
    {
        return 0;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self pushToPostDetail:indexPath.section keyboardShow:NO];
}

- (void)openMoreData:(UIButton *)btn
{
    btn.selected = !btn.isSelected;
    
    if (btn.selected == YES) {
        _isOpen = YES;
        [btn setTitle:@"收起" forState:UIControlStateSelected];
    }
    else
    {
        _isOpen = NO;
        [btn setTitle:@"展开" forState:(UIControlStateNormal)];
    }
    [self.tableview reloadData];
}
#pragma mark 拖拽列表改变图片的大小
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{

    if (scrollView.contentOffset.y > -64)
    {
        [UIView animateWithDuration:0.5 animations:^{
            
            self.topView.backgroundColor = [UIColor colorWithHexString:@"00aff0"];
        }];
    }
    else
    {
        [UIView animateWithDuration:0.5 animations:^{

            self.topView.backgroundColor = [UIColor clearColor];
        }];
    }
    if (scrollView.contentOffset.y < - 190) {
        CGRect fram = self.imgHead.frame;
        fram.origin.y = scrollView.contentOffset.y;
        fram.size.height = -scrollView.contentOffset.y;
        self.imgHead.frame = fram;
        self.effView.frame = fram;
    }
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView.contentOffset.y < -290)
    {
        [self.Refresh startAnimating];
        self.page = 1;
        [self requeestHuaTiListData:YES];
    }
}
#pragma mark - 事件
- (void)returnPage
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 自定义View代理
//关注
-(void)clikeGuanZhuButtonAction:(ZJPostHead *)postHead
{
    if ([GetOrgType isEqualToString:@"2"]) {
        
        BHHuaTiModel *model = self.listArr[postHead.btnGuanZhu.tag];
        postHead.btnGuanZhu.selected = !postHead.btnGuanZhu.selected;
        if (postHead.btnGuanZhu.selected == YES)
        {
            for (int i = 0; i < self.listArr.count; i++)
            {
                BHHuaTiModel *lModel = self.listArr[i];
                if ([model.uid isEqualToString:lModel.uid])
                {
                    lModel.isfocus = @"333";
                }
            }
            [self.tableview reloadData];
            [self alertView:nil message:@"关注成功"];
        }
        else
        {
            for (int i = 0; i < self.listArr.count; i++)
            {
                BHHuaTiModel *lModel = self.listArr[i];
                if ([model.uid isEqualToString:lModel.uid])
                {
                    lModel.isfocus = nil;
                }
            }
            [self.tableview reloadData];
         
            [self alertView:nil message:@"取消关注"];
        }
        
        
        RequestInterface *interface = [[RequestInterface alloc]init];
        NSLog(@"%@ %@",model.uid,self.loginuid);
        NSDictionary *dic = @{
                              @"uid":model.uid,
                              @"loginuid":self.loginuid,
                              };
        [interface requestBHGuanZhuWithDic:dic];
        [interface getInterfaceRequestObject:^(id data)
         {
             if ([data[@"success"] boolValue] == YES)
             {
                 
                 
             }
             else
             {
                 
                 
             }
         } Fail:^(NSError *error)
         {
             [self zanErrorAlertView:@"提示" message:@"抱歉，关注失败"];
         }];
    }else
    {
        [self zanErrorAlertView:nil message:@"您无权限进行此操作，请先绑定机构码"];
    }
    
}
//跳转个人页面
-(void)tapImgJumpPageAction:(ZJPostHead *)postHead
{
    BHNewPersonViewController *personVC = [[BHNewPersonViewController alloc]init];
    personVC.hidesBottomBarWhenPushed = YES;
    personVC.uid = [NSString stringWithFormat:@"%ld",(long)postHead.imgHead.tag];
    [self.navigationController pushViewController:personVC animated:YES];
}
//跳转个人页面
- (void)tapLikeHeadImgJumpPageAction:(ZJPostFirstLikeView *)postLikeView
{
    BHFirstZanModel *model = self.zanArr[postLikeView.indexpath.section][postLikeView.n];
    BHNewPersonViewController *personVC = [[BHNewPersonViewController alloc]init];
    personVC.hidesBottomBarWhenPushed = YES;
    personVC.uid = [NSString stringWithFormat:@"%ld",(long)model.uid];
    [self.navigationController pushViewController:personVC animated:YES];
}
//跳转点过赞的人列表页面
-(void)clickJumpPageLikePeopleButtonAction:(ZJPostFirstLikeView *)postLikeView
{
    PrisedViewController *prisedVC = [[PrisedViewController alloc]init];
    NSString *ID = [NSString stringWithFormat:@"%ld",(long)postLikeView.btnZanCount.tag];
    prisedVC.postID = ID;
    [self.navigationController pushViewController:prisedVC animated:YES];
}
-(void)clickBarButtonZan:(ZJPostNewBottomBar *)psstBar
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *loginuid = [defaults objectForKey:@"id"];
    if ([GetOrgType isEqualToString:@"2"]) {
        
        BHHuaTiModel *model = self.listArr[psstBar.btnZan.tag];
        
        psstBar.btnZan.selected = !psstBar.btnZan.selected;
        [self zanAnimation:psstBar.btnZan];
        if (psstBar.btnZan.selected == YES)
        {
            [psstBar.btnZan setImage:[UIImage imageNamed:@"点赞之后"] forState:(UIControlStateNormal)];
            model.ispraise = @"333";
            
            NSInteger count = [model.nums integerValue];
            count += 1;
            model.nums = [NSString stringWithFormat:@"%ld",(long)count];
            [psstBar changeZanCount:count];
            
            NSString *face = [[NSUserDefaults standardUserDefaults] objectForKey:@"login_User_face"];
            NSString *str = [NSString stringWithFormat:@"http://app.hfapp.cn/%@",face];
            NSDictionary  *dic = @{@"uid":loginuid,@"iconpath":str};
            BHFirstZanModel *zanModel = [[BHFirstZanModel alloc]init];
            [zanModel setValuesForKeysWithDictionary:dic];
            [self.zanArr[psstBar.btnZan.tag] insertObject:zanModel atIndex:0];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:psstBar.btnZan.tag];
                
                [self.tableview reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            });
        }
        else
        {
            [psstBar.btnZan setImage:[UIImage imageNamed:@"点赞"] forState:(UIControlStateNormal)];
            model.ispraise = nil;
            
            NSInteger count = [model.nums integerValue];
            count -= 1;
            model.nums = [NSString stringWithFormat:@"%ld",(long)count];
            [psstBar changeZanCount:count];
            
            for (int i = 0; i < [self.zanArr[psstBar.btnZan.tag] count]; i++) {
                BHFirstZanModel *zanModel = self.zanArr[psstBar.btnZan.tag][i];
             
                if (zanModel.uid == [loginuid integerValue])
                {
                    [self.zanArr[psstBar.btnZan.tag] removeObjectAtIndex:i];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        
                        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:psstBar.btnZan.tag];
                        
                        [self.tableview reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                    });
                }else
                {
                    NSLog(@"%ld,%@",(long)zanModel.uid,self.loginuid);
                }
            }
        }
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSMutableDictionary *parame = [NSMutableDictionary dictionary];
        parame[@"postid"] = model.tieZiID;
        parame[@"loginuid"] = loginuid;
        NSString *url = [NSString stringWithFormat:@"%@/index.php/Apis/Forum/setLike/",BANGHUI_URL];
        [manager POST:url parameters:parame
              success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             if ([responseObject[@"success"] boolValue] == YES)
             {
                 NSLog(@"%@",responseObject);
             }
             else
             {
                 NSLog(@"%@",responseObject);
             }
         } failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             [self zanErrorAlertView:@"提示" message:@"抱歉,点赞失败"];
         }];
    }else
    {
        [self zanErrorAlertView:nil message:@"您无权限进行此操作，请先绑定机构码"];
    }

}

-(void)clickBarButtonComm:(ZJPostNewBottomBar *)psstBar
{
    [self pushToPostDetail:psstBar.btnComm.tag keyboardShow:YES];
}

-(void)clickBarButtonShare:(ZJPostNewBottomBar *)psstBar
{
    if ([GetOrgType isEqualToString:@"2"]) {
        BHHuaTiModel *model;
        model = self.listArr[psstBar.btnShare.tag];
        HWComposeController *subVC = [[HWComposeController alloc]init];
        subVC.huatiModel = model;
        subVC.subject_id = _huatiid;
        if (model.forward)
        {
            subVC.forward_id = model.forward[@"id"];
            subVC.forwardTitle = [NSString stringWithFormat:@"@%@:%@//",model.name,model.contents];
        }
        else
        {
            subVC.forward_id = model.tieZiID;
            subVC.forwardTitle = @"转发";
        }
        //添加@数组
        NSMutableArray *arr = [NSMutableArray arrayWithObject:model.uid];
        subVC.forward_uid = arr;
        if (model.usercalls.count != 0)
        {
            for (int i = 0; i < model.usercalls.count; i++) {
                [subVC.forward_uid addObject:model.usercalls[i][@"id"]];
            }
        }
        subVC.subjectTitle = self.dic[@"topic"];
        subVC.InterfaceDistinguish = @"3";
        subVC.isForward = YES;
        UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:subVC];
        [self presentViewController:navi animated:YES completion:nil];
//        NSString *url = [NSString stringWithFormat:@"%@/index.php/Apis/Forum/fenxiangweb/postid/%@",BANGHUI_SHAREURL,model.tieZiID];
//        NSMutableArray *imageArray = [NSMutableArray array];
//        if ([model.imgpath isEqualToString:@""])
//        {
//            [imageArray addObject:[UIImage imageNamed:IMAGE_NAME]];
//        }else
//        {
//            [imageArray addObject:model.imgpath];
//        }
//        NSString *title = [NSString stringWithFormat:@"[邦会]%@",model.attributedContents.string];
//        if (title.length > 100) {
//            title = [title substringToIndex:100];
//        }
////        1、创建分享参数
//                if (imageArray) {
//        
//        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
//        [shareParams SSDKSetupShareParamsByText:nil
//                                         images:imageArray
//                                            url:[NSURL URLWithString:url]
//                                          title:title
//                                           type:SSDKContentTypeAuto];
//                    NSArray *items = @[@(SSDKPlatformTypeSinaWeibo),@(SSDKPlatformSubTypeQZone),@(SSDKPlatformSubTypeWechatSession),@(SSDKPlatformSubTypeWechatTimeline),@(SSDKPlatformSubTypeQQFriend)];
//        //2、分享（可以弹出我们的分享菜单和编辑界面）
//        [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
//                                 items:items
//                           shareParams:shareParams
//                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
//                       
//                       switch (state) {
//                           case SSDKResponseStateSuccess:
//                           {
//                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
//                                                                                   message:nil
//                                                                                  delegate:nil
//                                                                         cancelButtonTitle:@"确定"
//                                                                         otherButtonTitles:nil];
//                               [alertView show];
//                               break;
//                           }
//                           case SSDKResponseStateFail:
//                           {
//                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
//                                                                               message:[NSString stringWithFormat:@"%@",error]
//                                                                              delegate:nil
//                                                                     cancelButtonTitle:@"OK"
//                                                                     otherButtonTitles:nil, nil];
//                               NSLog(@"----%@",error);
//                               [alert show];
//                               break;
//                           }
//                           default:
//                               break;
//                       }
//                   }
//         ];
//            }

    }else
    {
        [self zanErrorAlertView:nil message:@"您无权限进行此操作，请先绑定机构码"];
    }
    
}

- (void)ZJForwardViewClickJumpAction:(ZJForwardView *)ForwardView
{
    BHPostDetailViewController *detailVC = [[BHPostDetailViewController alloc]init];
    detailVC.hidesBottomBarWhenPushed = YES;
    detailVC.tieZiID = ForwardView.forward_id;
    detailVC.index_row = ForwardView.indexpath.section;
    detailVC.isHuaTi = NO;
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)clickPicAction:(ZJPostPicView *)picView
{
    BHHuaTiModel *model = self.listArr[picView.indexpath.section];
    
    
    NSInteger count = model.imgpathsarr.count;
    
//    self.picView = picView;
//    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
//    
//    browser.sourceImagesContainerView = picView;
//    
//    browser.imageCount = count;
//    
//    browser.currentImageIndex = picView.tag;
//    
//    browser.delegate = self;
//    
//    [browser show]; // 展示图片浏览器
    
    
    NSMutableArray *photos = [NSMutableArray array];
    
    for (int i=0; i<count; i++) {
        
        UIImageView *child = picView.subviews[i];
        //1.创建photo模型
        JLPhoto *photo = [[JLPhoto alloc] init];
        //2.原始imageView
        photo.sourceImageView = child;
        //3.要放大图片的url
        photo.bigImgUrl = model.imgpathsarr[i];
        //标志
        photo.tag = i;
        
        [photos addObject:photo];
        
    }
    
    //1.创建图片浏览器
    JLPhotoBrowser *photoBrowser = [[JLPhotoBrowser alloc] init];
    //2.获取photo数组
    photoBrowser.photos = photos;
    //3.当前要显示的图片
    photoBrowser.currentIndex = (int)picView.tag ;
    [photoBrowser show];
    
    
}

#pragma mark -跳转到帖子详情界面
- (void)pushToPostDetail:(NSInteger)index keyboardShow:(BOOL)isShow
{
    BHHuaTiModel *model = self.listArr[index];
    BHPostDetailViewController *detailVC = [[BHPostDetailViewController alloc]init];
    detailVC.hidesBottomBarWhenPushed = YES;
    detailVC.tieZiID = model.tieZiID;
    detailVC.isHuaTi = YES;
    detailVC.iskeyboardShow = isShow;
    [self.navigationController pushViewController:detailVC animated:YES];
}


#pragma mark - 关注提示
- (void)alertView:(NSString *)title message:(NSString *)message
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:^{
            
        }];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
            
        });
    }else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alert dismissWithClickedButtonIndex:1 animated:YES];
        });
        
    }
}

#pragma mark - 点赞失败的提示
- (void)zanErrorAlertView:(NSString *)title message:(NSString *)message
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:^{
            
        }];
        
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
    }
    
}

#pragma mark 赞的按钮的动画
- (void)zanAnimation:(UIButton *)button
{
    CAKeyframeAnimation *k = [CAKeyframeAnimation  animationWithKeyPath:@"transform.scale"];
    k.values = @[@(0.1),@(1.0),@(1.5)];
    k.keyTimes = @[@(0.0),@(0.5),@(0.8),@(0.8)];
    k.calculationMode = kCAAnimationLinear;
    [button.layer addAnimation:k forKey:@"SHOW"];
}
- (void)changeZanState:(NSNotification *)noti
{
    NSInteger index = [noti.userInfo[@"index"] integerValue];
    NSString *str = noti.userInfo[@"iszan"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *loginuid = [defaults objectForKey:@"id"];
    BHHuaTiModel *model = self.listArr[index];
    if ([str isEqualToString:@"1"])
    {
        model.ispraise = @"333";
        NSString *face = [[NSUserDefaults standardUserDefaults] objectForKey:@"login_User_face"];
        NSString *str = [NSString stringWithFormat:@"http://app.hfapp.cn/%@",face];
        NSDictionary  *dic = @{@"uid":loginuid,@"iconpath":str};
        BHFirstZanModel *zanModel = [[BHFirstZanModel alloc]init];
        [zanModel setValuesForKeysWithDictionary:dic];
        //        [self.zanArr[psstBar.btnZan.tag] addObject:zanModel];
        [self.zanArr[index] insertObject:zanModel atIndex:0];
        [self.tableview reloadData];
    }
    else if ([str isEqualToString:@"2"])
    {
        model.ispraise = nil;
        for (int i = 0; i < [self.zanArr[index] count]; i++)
        {
            BHFirstZanModel *zanModel = self.zanArr[index][i];
            if (zanModel.uid == [loginuid integerValue])
            {
                [self.zanArr[index] removeObjectAtIndex:i];
                [self.tableview reloadData];
            }
            else
            {
            }
            
        }
    }
}

- (void)changeGuanState:(NSNotification *)noti
{
    NSInteger index = [noti.userInfo[@"index"] integerValue];
    NSString *str = noti.userInfo[@"isGuan"];
    BHHuaTiModel *model = self.listArr[index];
    if ([str isEqualToString:@"1"]) {
        for (int i = 0; i < self.listArr.count; i++)
        {
            BHHuaTiModel *lModel = self.listArr[i];
            if ([model.uid isEqualToString:lModel.uid])
            {
                lModel.isfocus = @"333";
            }
        }
        [self.tableview reloadData];
    }else if ([str isEqualToString:@"2"])
    {
        for (int i = 0; i < self.listArr.count; i++)
        {
            BHHuaTiModel *lModel = self.listArr[i];
            if ([model.uid isEqualToString:lModel.uid])
            {
                lModel.isfocus = nil;
            }
        }
        [self.tableview reloadData];
        
    }
    
    
}

#pragma mark - 通知方法
- (void)changeFram:(NSNotification *)noti
{
    //    NSIndexPath *indexPath = noti.userInfo[@"index"];
    
    
    [self.tableview reloadData];
    //    [self requestFirstListData:YES];
    
}

@end
