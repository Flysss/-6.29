//
//  BHNewCircleViewController.m
//  SalesHelper_A
//
//  Created by zhipu on 16/3/19.
//  Copyright © 2016年 X. All rights reserved.
//

#import "BHNewCircleViewController.h"
#import "BHNewPersonViewController.h"
#import "PrisedViewController.h"
#import "BHPostDetailViewController.h"

#import "UIColor+HexColor.h"
#import "AFHTTPRequestOperationManager.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import "BHFirstListModel.h"
#import "BHLeftModel.h"
#import "BHFirstZanModel.h"
#import "ZJPostCell.h"
#import "ZJPostHead.h"
#import "ZJPostFirstLikeView.h"
#import "ZJPostNewBottomBar.h"
#import "ZJPostPingLunView.h"
#import "HWComposeController.h"
#import "SVPullToRefresh.h"
#import "HWContentsLabel.h"
#import "ZJPostPicView.h"
#import "ZJForwardView.h"

@interface BHNewCircleViewController ()<UITableViewDataSource,UITableViewDelegate,ZJPostHeadDelegate,ZJPostFirstLikeViewDelegate,ZJPostNewBottomBarDelegate,ZJPostPicViewDelegate,ZJForwardViewDelegate>

@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) NSMutableArray *listArr;
@property (nonatomic, strong) NSMutableArray *zanArr;
@property (nonatomic, strong) NSMutableDictionary *dic;
@property (nonatomic, strong) UIImageView *imgHead;
@property (nonatomic, strong) NSString *loginuid;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) UIActivityIndicatorView *Refresh;

@end

@implementation BHNewCircleViewController
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
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

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
    
    
    
        [self requestTopData];
    [self requestcircleListData:NO];
    
        
    
    [self createTableView];
    [self createTopView];
    [self refresh];
}

- (void)refreshTablew:(NSNotification *)noti
{
    self.page = 1;
    [self requestcircleListData:YES];
    [self requestTopData];
}

#pragma mark - 网络请求－圈子列表
- (void)requestcircleListData:(BOOL)isDelet;
{
//    [self.view Loading_0314];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *city = [defaults objectForKey:@"location_City"];
    RequestInterface *interface = [[RequestInterface alloc]init];
    NSDictionary *dic = @{
                          @"istype":@"1",
                          @"loginuid":self.loginuid,
                          @"typeid":_model.quanZiID,
                          @"city":city,
                          @"p":@(_page),
                          };
    [interface requestBHCircleListWithDic:dic];
    [interface getInterfaceRequestObject:^(id data)
     {
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
                     BHFirstListModel *model = [[BHFirstListModel alloc]init];
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
                 
                 [self.tableview reloadData];
                 [self.Refresh stopAnimating];
//                 [self.view Hidden];
                 [self.tableview.infiniteScrollingView stopAnimating];

             }
             else
             {
                 [self.view makeToast:data[@"message"]];
                 [self.Refresh stopAnimating];
//                 [self.view Hidden];
                 [self.tableview.infiniteScrollingView stopAnimating];
             }
         }
         else
         {
             [self.view makeToast:data[@"message"]];
             [self.Refresh stopAnimating];
             [self.tableview.infiniteScrollingView stopAnimating];
//             [self.view Hidden];
         }
     } Fail:^(NSError *error)
     {
         [self.Refresh stopAnimating];
         [self.tableview.infiniteScrollingView stopAnimating];
         [self.view makeToast:@"请求失败"];
     }];
}
#pragma mark - 顶部数据
- (void)requestTopData
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *parame = [NSMutableDictionary dictionary];
    
    parame[@"subjectid"] = _model.quanZiID;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *city = [defaults objectForKey:@"location_City"];
    parame[@"city"] = city;
    NSString *url = [NSString stringWithFormat:@"%@/index.php/Apis/Forum/getSubjectInfo/",BANGHUI_URL];

    [manager POST:url parameters:parame
          success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if ([responseObject[@"success"] boolValue] == YES)
         {
             self.dic = responseObject[@"datas"];
             [self.imgHead sd_setImageWithURL:[NSURL URLWithString:_model.bgimgpath]];

         }
         else
         {
             
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
     }];

}


#pragma mark -视图创建
- (void)createTableView
{
    
    
    self.tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.height) style:UITableViewStyleGrouped];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview registerClass:[ZJPostCell class] forCellReuseIdentifier:@"ZJPostCell"];
    self.tableview.separatorStyle = UITableViewCellAccessoryNone;
    [self.view addSubview:self.tableview];
    
    self.imgHead = [[UIImageView alloc]initWithFrame:CGRectMake(0, -190, SCREEN_WIDTH, 190)];
//    self.imgHead.image = [UIImage imageNamed:@"pp_bg"];
    self.imgHead.contentMode = UIViewContentModeScaleAspectFill;
    self.imgHead.clipsToBounds = YES;
    self.imgHead.autoresizesSubviews = YES;
    self.imgHead.userInteractionEnabled = YES;
    self.tableview.contentInset = UIEdgeInsetsMake(190, 0, 0, 0);
//    self.tableview.tableFooterView = [[UIView alloc]init];
    [self.tableview addSubview:self.imgHead];
    
    
    
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc]initWithEffect:blur];
    effectView.frame = CGRectMake(0, -190, SCREEN_WIDTH, 190);
    [self.imgHead addSubview:effectView];
    
    self.Refresh = [[UIActivityIndicatorView alloc]init];
    self.Refresh.bounds = CGRectMake(0, 0, SCREEN_WIDTH, 30);
    self.Refresh.centerX = self.imgHead.centerX;
    self.Refresh.centerY = self.imgHead.centerY;
//    self.Refresh.backgroundColor = [UIColor redColor];
    [self.Refresh startAnimating];
    self.Refresh.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [self.tableview addSubview:self.Refresh];
    
    UILabel *lblNum = [[UILabel alloc]init];
    NSString *num = [NSString stringWithFormat:@"%@人参与",_model.huati];
    lblNum.font = [UIFont systemFontOfSize:13];
    lblNum.textColor = [UIColor colorWithHexString:@"ffffff"];
    lblNum.frame = CGRectMake(0, 0, [BHNewCircleViewController widthForString:num font:13 height:20], 20);
    lblNum.center = CGPointMake(SCREEN_WIDTH/2, self.imgHead.height-20-10);
    lblNum.text = num;
    lblNum.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [self.imgHead addSubview:lblNum];
    
    UIImageView *imgPing = [[UIImageView alloc]init];
    imgPing.frame = CGRectMake(0, 0, 11, 13);
    imgPing.center = CGPointMake(CGRectGetMinX(lblNum.frame)-15/2-5, CGRectGetCenter(lblNum.frame).y);
    imgPing.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    imgPing.image = [UIImage imageNamed:@"帖子"];
    [self.imgHead addSubview:imgPing];
    
    
}

#pragma mark -跳转到发帖页面
- (void)pushToSub
{
    if ([GetOrgType isEqualToString:@"2"])
    {
        HWComposeController *subVC = [[HWComposeController alloc]init];
        UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:subVC];
        subVC.circle_id = _model.quanZiID;
//        subVC.cireTitle = self.dic[@"topic"];
        [self presentViewController:navi animated:YES completion:nil];
    }
    else
    {
        [self zanErrorAlertView:nil message:@"您无权限进行此操作，请先绑定机构码"];
    }
}

- (void)fanhui
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)createTopView
{
    [self CreateCustomNavigtionBarWith:self leftItem:@selector(returnPage) rightItem:nil];
    [self.backBtn setImage:[UIImage imageNamed:@"bc-1"] forState:(UIControlStateNormal)];
    [self.backBtn setImage:[UIImage imageByApplyingAlpha:[UIImage imageNamed:@"bc-1"]] forState:(UIControlStateHighlighted)];
    self.topView.backgroundColor = [UIColor clearColor];
    
    UILabel *lblName = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 44)];
    lblName.textColor = [UIColor colorWithHexString:@"ffffff"];
    lblName.font = [UIFont systemFontOfSize:20];
    lblName.textAlignment = NSTextAlignmentCenter;
    lblName.tag = 505;
    lblName.text = _model.topic;
    [self.topView addSubview:lblName];
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
- (void) doHandlePanAction:(UIPanGestureRecognizer *)paramSender{
    
    CGPoint point = [paramSender translationInView:self.view];
    NSLog(@"X:%f;Y:%f",point.x,point.y);
    
    paramSender.view.center = CGPointMake(paramSender.view.center.x + point.x, paramSender.view.center.y + point.y);
    
    [paramSender setTranslation:CGPointMake(0, 0) inView:self.view];
    
    
}
#pragma mark - tableview代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return 1;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.listArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    BHFirstListModel *model = self.listArr[indexPath.section];
    ZJPostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZJPostCell" forIndexPath:indexPath];
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
    
    cell.forwardView.indexpath = indexPath;
    cell.forwardView.delegate = self;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BHFirstListModel *model = self.listArr[indexPath.section];
    return [ZJPostCell heightForModel:model zanArr:self.zanArr[indexPath.section]];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self pushToPostDetail:indexPath.section keyboardShow:NO];
}
#pragma mark-UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.01;
    } else {
        return 8;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

#pragma mark 拖拽列表改变图片的大小
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y < - 190) {
        CGRect fram = self.imgHead.frame;
        fram.origin.y = scrollView.contentOffset.y;
        fram.size.height = -scrollView.contentOffset.y;
        self.imgHead.frame = fram;
    }
    if (scrollView.contentOffset.y > 0)
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
    
//    [self.navigationController.navigationBar setBackgroundImage:[self imageWithBgColor:[UIColor colorWithRed:23/255.0f green:183/255.0f blue:243/255.0f alpha:(self.tableview.contentOffset.y-50)/ 120]] forBarMetrics:UIBarMetricsDefault];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView.contentOffset.y < -290)
    {
        [self.Refresh startAnimating];
        self.page = 1;
        [self requestcircleListData:YES];
    }
}
+ (CGFloat)widthForString:(NSString *)str font:(CGFloat)font height:(CGFloat )height
{
    NSDictionary *dic = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:font] forKey:NSFontAttributeName];
    CGRect bound = [str boundingRectWithSize:CGSizeMake(0, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    return bound.size.width;
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
        
        BHFirstListModel *model = self.listArr[postHead.btnGuanZhu.tag];
        postHead.btnGuanZhu.selected = !postHead.btnGuanZhu.selected;
        if (postHead.btnGuanZhu.selected == YES)
        {
            for (int i = 0; i < self.listArr.count; i++)
            {
                BHFirstListModel *lModel = self.listArr[i];
                if ([model.uid isEqualToString:lModel.uid])
                {
                    //                [postHead.btnGuanZhu setImage:[UIImage imageNamed:@""] forState:(UIControlStateNormal)];
                    //                [postHead.btnGuanZhu setTitle:@"已关注" forState:(UIControlStateNormal)];
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
                BHFirstListModel *lModel = self.listArr[i];
                if ([model.uid isEqualToString:lModel.uid])
                {
                    lModel.isfocus = nil;
                }
            }
            [self.tableview reloadData];
            //        [postHead.btnGuanZhu setTitle:@"  关注" forState:(UIControlStateNormal)];
            //        [postHead.btnGuanZhu setImage:[UIImage imageNamed:@"plus_335px_1187514_easyicon.net"] forState:(UIControlStateNormal)];
            //        model.isfocus = nil;
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
    
}//跳转个人页面
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
    BHFirstZanModel *zanModel = self.zanArr[postLikeView.indexpath.section][postLikeView.n];
    BHNewPersonViewController *personVC = [[BHNewPersonViewController alloc]init];
    personVC.hidesBottomBarWhenPushed = YES;
    personVC.uid = [NSString stringWithFormat:@"%ld",(long)zanModel.uid];
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
        
        BHFirstListModel *model = self.listArr[psstBar.btnZan.tag];
        
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
                }
            }
        }
        
        
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSMutableDictionary *parame = [NSMutableDictionary dictionary];
        parame[@"postid"] = model.tieZiID;
        parame[@"loginuid"] = self.loginuid;
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
- (void)ZJForwardViewClickJumpAction:(ZJForwardView *)ForwardView
{
    BHPostDetailViewController *detailVC = [[BHPostDetailViewController alloc]init];
    detailVC.hidesBottomBarWhenPushed = YES;
    detailVC.tieZiID = ForwardView.forward_id;
    detailVC.index_row = ForwardView.indexpath.section;
    detailVC.isHuaTi = NO;
    [self.navigationController pushViewController:detailVC animated:YES];
}

-(void)clickBarButtonShare:(ZJPostNewBottomBar *)psstBar
{
    if ([GetOrgType isEqualToString:@"2"]) {
        BHFirstListModel *model;
        model = self.listArr[psstBar.btnShare.tag];
        HWComposeController *subVC = [[HWComposeController alloc]init];
        subVC.model = model;
        subVC.circle_id = _model.quanZiID;
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
        subVC.InterfaceDistinguish = @"1";
//        subVC.cireTitle = self.dic[@"topic"];
        subVC.isForward = YES;
        UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:subVC];
        [self presentViewController:navi animated:YES completion:nil];

//        BHFirstListModel *model;
//        model = self.listArr[psstBar.btnShare.tag];
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
//        //1、创建分享参数
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
#pragma mark -跳转到帖子详情界面
- (void)pushToPostDetail:(NSInteger)index keyboardShow:(BOOL)isShow
{
    BHFirstListModel *model = self.listArr[index];
    BHPostDetailViewController *detailVC = [[BHPostDetailViewController alloc]init];
    detailVC.hidesBottomBarWhenPushed = YES;
    detailVC.tieZiID = model.tieZiID;
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
- (void)refresh
{
    [self.tableview triggerPullToRefresh];
    __weak BHNewCircleViewController *test = self;
//    [self.tableview addFooterWithCallback:^{
//        test.page ++;
//        [test requestcircleListData:NO];
//        [test.tableview footerEndRefreshing];
//        
//    }];
    [self.tableview addInfiniteScrollingWithActionHandler:^{
        
        test.page ++;
        [test requestcircleListData:NO];
        
    }];

}
//- (void)headerRefresh
//{
//    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
//     self.Refresh = refresh;
//    [self.tableview addSubview:refresh];
//    refresh.backgroundColor = [UIColor redColor];
//    [refresh addTarget:self action:@selector(requestcircleListData) forControlEvents:UIControlEventValueChanged];
//    [refresh beginRefreshing];
//   
//}



- (void)changeZanState:(NSNotification *)noti
{
    NSInteger index = [noti.userInfo[@"index"] integerValue];
    NSString *str = noti.userInfo[@"iszan"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *loginuid = [defaults objectForKey:@"id"];
    BHFirstListModel *model = self.listArr[index];
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
    BHFirstListModel *model = self.listArr[index];
    if ([str isEqualToString:@"1"]) {
        for (int i = 0; i < self.listArr.count; i++)
        {
            BHFirstListModel *lModel = self.listArr[i];
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
            BHFirstListModel *lModel = self.listArr[i];
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
