
//
//  BHNewPersonViewController.m
//  SalesHelper_A
//
//  Created by zhipu on 16/3/18.
//  Copyright © 2016年 X. All rights reserved.
//

#import "BHNewPersonViewController.h"

#import "BHNewPersonCell.h"
#import "ZJPersonHeadView.h"
#import "BHMyPostsModel.h"
#import "ZJPostBodyView.h"
#import "BHMyReplyModel.h"

#import "HuifuTableViewCell.h"

#import "UIColor+HexColor.h"
#import "AFHTTPRequestOperationManager.h"

#import "BHPostDetailViewController.h"
#import "BHChatViewController.h"
#import "BHNewMyPostViewController.h"
#import "PrisedViewController.h"
#import "BHMyFoucsViewController.h"
#import "BHMyFansViewController.h"
#import "BHNewHuaTiViewController.h"
#import "HWContentsLabel.h"
#import "ModelWebViewController.h"
#import "ZJForwardView.h"

#import "ZJMyPostBettomView.h"
@interface BHNewPersonViewController ()<UITableViewDataSource,UITableViewDelegate,ZJPersonHeadDelegate,ZJMyPostBettomViewDelegate,ZJForwardViewDelegate>

@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) NSMutableDictionary *topDic;
@property (nonatomic, strong) NSString *loginuid;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger page2;
@property (nonatomic, strong) NSMutableArray *postArr;
@property (nonatomic, strong) UIScrollView *scrollview;
@property (nonatomic, strong) NSMutableArray *replyArr;
//@property (nonatomic, assign) BOOL isHui;
@property (nonatomic, strong) UILabel *lblName;
@property (nonatomic, strong) ZJPersonHeadView *personHead;
@end

@implementation BHNewPersonViewController

- (NSMutableDictionary *)dic
{
    if (_topDic == nil) {
        self.topDic = [NSMutableDictionary dictionary];
    }
    return _topDic;
}

- (NSMutableArray *)postArr
{
    if (_postArr == nil) {
        self.postArr = [NSMutableArray array];
    }
    return _postArr;
}
-(NSMutableArray *)replyArr
{
    if (_replyArr == nil) {
        self.replyArr = [NSMutableArray array];
    }
    return _replyArr;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(linkDidClick:) name:HWLinkDidClickNotification object:nil];

}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    self.navigationController.navigationBar.hidden = NO;
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *longinuid =  [defaults objectForKey:@"id"];
    
    self.loginuid = [NSString stringWithFormat:@"%@",longinuid];
    // Do any additional setup after loading the view.
    self.page = 1;
    [self createTableView];
    [self requsetHeadData];
    [self requestPostData:NO];
    [self createTopView];
    [self refresh];
    
    

}

- (void)requsetHeadData
{
    RequestInterface *interface = [[RequestInterface alloc]init];
    NSDictionary *dic = @{
                          @"getuid":_uid,
                          @"loginuid":self.loginuid,
                          };
    [interface requestBHPersonalCenterWithDic:dic];
    [interface getInterfaceRequestObject:^(id data)
     {
         if ([data[@"success"] boolValue] == YES)
         {
             NSLog(@"%@",data);
             self.topDic = data[@"datas"];
             self.lblName.text = self.topDic[@"name"];
             [self createTopView];
         }
         else
         {
             [self.view makeToast:@"没有数据"];
         }
     } Fail:^(NSError *error)
     {
         [self.view makeToast:@"加载失败"];
     }];
}

#pragma mark - 网络请求－我的发帖
- (void)requestPostData:(BOOL)isDelet
{
    [self.view Loading_0314];
    RequestInterface *interface = [[RequestInterface alloc]init];
    NSDictionary *dic = @{
                          @"uid":_uid,
                          @"loginuid":self.loginuid,
                          @"p":@(_page),
                          };
    [interface requestBHPostsWithDic:dic];
    [interface getInterfaceRequestObject:^(id data)
     {
         if ([data[@"success"] boolValue] == YES)
         {
             if ([data[@"datas"] count] != 0)
             {
                 if (isDelet == YES) {
                     [self.postArr removeAllObjects];
                 }
                 for (NSDictionary *dict in data[@"datas"])
                 {
                     BHMyPostsModel *model = [[BHMyPostsModel alloc]init];
                     [model setValuesForKeysWithDictionary:dict];
                     [self.postArr addObject:model];
                 }
                 [self.tableview reloadData];
                 [self.view Hidden];
             }
             else
             {
                 [self.view Hidden];
                 [self.view makeToast:data[@"message"]];
             }
         }
         else
         {
             [self.view Hidden];
             [self.view makeToast:data[@"message"]];
         }
         
     } Fail:^(NSError *error)
     {
         [self.view Hidden];
         [self.view makeToast:@"请求失败"];
     }];

}


- (void)fanhui
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)createTableView
{
    self.scrollview = [[UIScrollView alloc]init];
    self.scrollview.delegate = self;
    self.scrollview.pagingEnabled = YES;
    self.scrollview.frame = self.view.bounds;
    self.scrollview.contentSize = CGSizeMake(SCREEN_WIDTH*2,0);
    self.scrollview.showsHorizontalScrollIndicator = FALSE;
    self.scrollview.bounces = NO;
    [self.view addSubview:self.scrollview];
    
    self.tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, (434+91)/2, SCREEN_WIDTH, SCREEN_HEIGHT-(434+91)/2) style:UITableViewStylePlain];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.separatorStyle = UITableViewCellAccessoryNone;
    [self.tableview registerClass:[BHNewPersonCell class] forCellReuseIdentifier:@"BHNewPersonCell"];
    [self.tableview registerClass:[HuifuTableViewCell class] forCellReuseIdentifier:@"HuifuTableViewCell"];
    [self.scrollview addSubview:self.tableview];
    
    
    BHNewMyPostViewController *myPostVC = [[BHNewMyPostViewController alloc]init];
    myPostVC.uid = self.uid;
    [self addChildViewController:myPostVC];
    myPostVC.view.frame = CGRectMake(SCREEN_WIDTH, (434+91)/2, SCREEN_WIDTH, SCREEN_HEIGHT-(434+91)/2);
    [self.scrollview addSubview:myPostVC.view];
    
}

- (void)createTopView
{
    self.personHead = [[ZJPersonHeadView alloc]init];
    self.personHead.frame = CGRectMake(0, 0, SCREEN_WIDTH, (434+91)/2);
    self.personHead.dic = self.topDic;
    self.personHead.delegate = self;
    
    [self.view addSubview:self.personHead];

    [self CreateCustomNavigtionBarWith:self leftItem:@selector(returnPage) rightItem:nil];
    self.topView.backgroundColor = [UIColor clearColor];
    self.rightBtn.hidden = YES;
    [self.backBtn setImage:[UIImage imageNamed:@"bc-1"] forState:(UIControlStateNormal)];
    [self.backBtn setImage:[UIImage imageByApplyingAlpha:[UIImage imageNamed:@"bc-1"]] forState:(UIControlStateHighlighted)];

    UILabel *lblName = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 44)];
    lblName.textColor = [UIColor colorWithHexString:@"ffffff"];
    lblName.font = [UIFont systemFontOfSize:20];
    lblName.textAlignment = NSTextAlignmentCenter;
    lblName.tag = 500;
    [self.topView addSubview:lblName];
    
    
    [self.view addSubview:self.topView];

    
    lblName.text = self.topDic[@"name"];
    
}

- (void)refresh
{
    __block BHNewPersonViewController *test = self;
    [self.tableview addFooterWithCallback:^{
            test.page ++;
            [test requestPostData:NO];
            [test.tableview footerEndRefreshing];
    }];
    
    [self.tableview addHeaderWithCallback:^{
        test.page = 1;
        [test requestPostData:YES];
        [test.tableview headerEndRefreshing];
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.postArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BHNewPersonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BHNewPersonCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    BHMyPostsModel *model = self.postArr[indexPath.row];
    cell.MyPostBettomView.delegate = self;
    cell.MyPostBettomView.indexpath = indexPath;
    cell.model = model;
    cell.forwardView.delegate = self;
    cell.forwardView.indexpath = indexPath;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BHMyPostsModel *model = self.postArr[indexPath.row];
    return [BHNewPersonCell heightforCell:model]; 
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BHMyPostsModel *model = self.postArr[indexPath.row];
    [self pushToDetail:model.tieziID];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    if (scrollView.contentOffset.y > 434/2)
//    {
//        [UIView animateWithDuration:0.5 animations:^{
//            
//            self.topView.backgroundColor = [UIColor colorWithHexString:@"00aff0"];
//        }];
//    }
//    else
//    {
//        [UIView animateWithDuration:0.5 animations:^{
//            
//            self.topView.backgroundColor = [UIColor clearColor];
//        }];
//    }
//    CGFloat offset=self.tableview.contentOffset.y;
    
    //NSLog(@"%f",offset);
    
    
        
//        [self.navigationController.navigationBar setBackgroundImage:[self imageWithBgColor:[UIColor colorWithRed:23/255.0f green:183/255.0f blue:243/255.0f alpha:(self.tableview.contentOffset.y-50)/ 120]] forBarMetrics:UIBarMetricsDefault];
    
//        if (offset>=120 ) {
//            
//                 }else{
//        }
    if (self.scrollview.contentOffset.x >= SCREEN_WIDTH)
    {
        [self.personHead.btnPost setTitleColor:[UIColor colorWithHexString:@"676767"] forState:(UIControlStateNormal)];
        [self.personHead.btnReply setTitleColor:[UIColor colorWithHexString:@"00aff0"] forState:(UIControlStateNormal)];
    }
    else
    {
        [self.personHead.btnPost setTitleColor:[UIColor colorWithHexString:@"00aff0"] forState:(UIControlStateNormal)];
        [self.personHead.btnReply setTitleColor:[UIColor colorWithHexString:@"676767"] forState:(UIControlStateNormal)];
    }

}

#pragma mark -跳转到帖子详情界面
- (void)pushToDetail:(NSString *)tid
{
    BHPostDetailViewController *detailVC = [[BHPostDetailViewController alloc]init];
    detailVC.tieZiID = tid;
    [self.navigationController pushViewController:detailVC animated:YES];
}

+ (CGFloat)heightForString:(NSString *)str font:(CGFloat)font width:(CGFloat )width
{
    NSDictionary *dic = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:font] forKey:NSFontAttributeName];
    CGRect bound = [str boundingRectWithSize:CGSizeMake(width, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    return bound.size.height;
}

#pragma mark - 按钮的代理事件
- (void)returnPage
{
    [self.navigationController popViewControllerAnimated:YES];
}

//- (void)moreChoore:(UIButton *)button
//{
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
//    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"举报" style:(UIAlertActionStyleDestructive) handler:^(UIAlertAction * _Nonnull action) {
//    }];
//    
//    
//    UIAlertAction *action = [UIAlertAction actionWithTitle:@"关闭" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
//        
//    }];
//    [alert addAction:action1];
//    [alert addAction:action];
//    [self presentViewController:alert animated:YES completion:^{
//        
//    }];
//
//}

- (void)clickMessageButtonAction:(ZJPersonHeadView *)ZJPersonHeadView
{
    if ([GetOrgType isEqualToString:@"2"]) {
        
        //新建一个聊天会话View Controller对象
        BHChatViewController *chat = [[BHChatViewController alloc]init];
        //设置会话的类型，如单聊、讨论组、群聊、聊天室、客服、公众服务会话等
        chat.conversationType = ConversationType_PRIVATE;
        //设置会话的目标会话ID。（单聊、客服、公众服务会话为对方的ID，讨论组、群聊、聊天室为会话的ID）
        chat.targetId = _uid;
        //设置聊天会话界面要显示的标题
        
        
        UILabel *lblTitle = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-30, 0, 60, 44)];
        lblTitle.text = self.topDic[@"name"];
        lblTitle.textAlignment = NSTextAlignmentCenter;
        lblTitle.textColor = [UIColor whiteColor];
        chat.navigationItem.titleView = lblTitle;
    
        chat.ctitle = self.topDic[@"name"];
        chat.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:chat animated:YES];
    }else
    {
        [self zanErrorAlertView:nil message:@"您无权限进行此操作，请先绑定机构码"];
    }
    
}
- (void)clickGuanZhuButtonAction:(ZJPersonHeadView *)ZJPersonHeadView
{
    if ([GetOrgType isEqualToString:@"2"]) {
        
        RequestInterface *interface = [[RequestInterface alloc]init];
        NSDictionary *dic = @{
                              @"uid":_uid,
                              @"loginuid":self.loginuid,
                              };
        [interface requestBHGuanZhuWithDic:dic];
        [interface getInterfaceRequestObject:^(id data)
         {
             if ([data[@"success"] boolValue] == YES)
             {
                 [ZJPersonHeadView.btnGuanZhu setImage:[UIImage imageNamed:@"gzh-1"] forState:(UIControlStateNormal)];
                 //             self.topDic[@"is_focus"] = @"1";
                 [self alertView:nil message:@"关注成功"];
             }
             else
             {
                 [ZJPersonHeadView.btnGuanZhu setImage:[UIImage imageNamed:@"gzq-1"] forState:(UIControlStateNormal)];
                 //             self.topDic[@"is_focus"] = @"3";
                 [self alertView:nil message:@"取消关注"];
             }
             
         } Fail:^(NSError *error)
         {
             
         }];
    }else
    {
        [self zanErrorAlertView:nil message:@"您无权限进行此操作，请先绑定机构码"];
    }

}

-(void)clickPostButtonAction:(ZJPersonHeadView *)ZJPersonHeadView
{

    [UIView animateWithDuration:0.3 animations:^{
        self.scrollview.contentOffset = CGPointMake(0, 0);
        [ZJPersonHeadView.btnPost setTitleColor:[UIColor colorWithHexString:@"00aff0"] forState:(UIControlStateNormal)];
        [ZJPersonHeadView.btnReply setTitleColor:[UIColor colorWithHexString:@"676767"] forState:(UIControlStateNormal)];
    }];

}

-(void)clickReplyButtonAction:(ZJPersonHeadView *)ZJPersonHeadView
{
    [UIView animateWithDuration:0.3 animations:^{
    
    self.scrollview.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
    [ZJPersonHeadView.btnReply setTitleColor:[UIColor colorWithHexString:@"00aff0"] forState:(UIControlStateNormal)];
    [ZJPersonHeadView.btnPost setTitleColor:[UIColor colorWithHexString:@"676767"] forState:(UIControlStateNormal)];
    }];

}
-(void)clickLikeButtonAction:(ZJMyPostBettomView *)ZJPostBodyView
{
    if ([GetOrgType isEqualToString:@"2"])
    {
        BHMyPostsModel *model = self.postArr[ZJPostBodyView.btnLike.tag];
        NSInteger count = model.zan.count;
        if (ZJPostBodyView.btnLike.selected == YES)
        {
            [self.view makeToast:@"亲，你已经赞过啦~" duration:1 position:@"center"];
        }
        else
        {
            [ZJPostBodyView.btnLike setImage:[UIImage imageNamed:@"点赞之后小版"] forState:(UIControlStateNormal)];
            [ZJPostBodyView.btnLike setTitle:[NSString stringWithFormat:@"%d",count + 1] forState:(UIControlStateNormal)];
            model.ispraise = @"333";
            ZJPostBodyView.btnLike.selected = YES;
            
        }
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSMutableDictionary *parame = [NSMutableDictionary dictionary];
        parame[@"postid"] = model.tieziID;
        parame[@"loginuid"] = self.loginuid;
        NSString *url = [NSString stringWithFormat:@"%@/index.php/Apis/Forum/setLike/",BANGHUI_URL];
        [manager POST:url parameters:parame
              success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             
             if ([responseObject[@"success"] boolValue] == YES)
             {
                
                 //             NSString *face = [[NSUserDefaults standardUserDefaults] objectForKey:@"login_User_face"];
                 //             NSDictionary *dic = @{@"uid":self.loginuid};
                 //             [model.zan addObject:dic];
                 //             [self.tableview reloadData];
             }
             else
             {
                                            //             [model.zan removeLastObject];
                 //             [self.tableview reloadData];
             }
         } failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
         }];
    }else
    {
        [self zanErrorAlertView:nil message:@"您无权限进行此操作，请先绑定机构码"];
    }

}
-(void)clickComButtonAction:(ZJMyPostBettomView *)ZJPostBodyView
{
    NSLog(@"%ld",(long)ZJPostBodyView.btnReply.tag);
    BHMyPostsModel *model = self.postArr[ZJPostBodyView.btnReply.tag];
    [self pushToDetail:model.tieziID];
}

- (void)clickJumpPriVCAction:(ZJPersonHeadView *)ZJPersonHeadView
{
    if ([GetOrgType isEqualToString:@"2"])
    {
        BHMyFoucsViewController *foucsVC = [[BHMyFoucsViewController alloc]init];
        foucsVC.uid = _uid;
        [self.navigationController pushViewController:foucsVC animated:YES];
    }
    else
    {
        [self zanErrorAlertView:nil message:@"您无权限进行此操作，请先绑定机构码"];
    }
}
- (void)clickJumpFansVCAction:(ZJPersonHeadView *)ZJPersonHeadView
{
    if ([GetOrgType isEqualToString:@"2"])
    {
        BHMyFansViewController *fansVC = [[BHMyFansViewController alloc]init];
        fansVC.uid = _uid;
        [self.navigationController pushViewController:fansVC animated:YES];
    }
    else
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



#pragma mark - 网络请求-关注接口
- (void)setGuanZhu
{
    RequestInterface *interface = [[RequestInterface alloc]init];
    NSDictionary *dic = @{
                          @"uid":_uid,
                          @"loginuid":self.loginuid,
                          };
    [interface requestBHGuanZhuWithDic:dic];
    [interface getInterfaceRequestObject:^(id data)
     {
         
     } Fail:^(NSError *error)
     {
         
     }];
}
- (void)linkDidClick:(NSNotification *)note
{
    
    NSString *linkText = note.userInfo[HWLinkText];
    
    HWContentsLabel *label = note.userInfo[HWLabelself];
    
    
    
    if ([linkText hasPrefix:@"http"]) {
        ModelWebViewController * VC = [[ModelWebViewController alloc]initWithUrlString:linkText NavigationTitle:@"详情"];
        VC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:VC animated:YES];
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:linkText]];
    }else
    {
        BHMyPostsModel *model = self.postArr[label.tag];
        NSString *uid = model.subject_id[@"id"];
        
        
        if ([linkText containsString:@"@"]) {
            
            NSString *name = [linkText substringFromIndex:1];
            
            NSArray *mentionArray = model.usercalls;
            
            for (NSUInteger i = 0; i < mentionArray.count; i++) {
                
                NSDictionary *dic = mentionArray[i];
                
                if ([name isEqualToString:dic[@"name"]]) {
                    
                    BHNewPersonViewController *person = [[BHNewPersonViewController alloc] init];
                    person.uid = dic[@"id"];
                    person.hidesBottomBarWhenPushed = YES;
                    
                    [self.navigationController pushViewController:person animated:YES];
                    
                }
                
            }
        }else{
            
            BHNewHuaTiViewController *HuaTi = [[BHNewHuaTiViewController alloc] init];
            
            HuaTi.huatiid = uid;
            HuaTi.uid = model.uid;
            HuaTi.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:HuaTi animated:YES];
            
            
        }
        
        
    }
    
    
}
#pragma mark - 移除通知
- (void)dealloc
{
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
