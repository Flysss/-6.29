//
//  BHPostDetailViewController.m
//  SalesHelper_A
//
//  Created by zhipu on 16/2/29.
//  Copyright © 2016年 X. All rights reserved.
//

#import "BHPostDetailViewController.h"
#import "UIColor+HexColor.h"
#import "CustomBtn.h"
#import "PrisedViewController.h"
#import "BHGongGaoCell.h"
#import "RequestInterface.h"
#import "BHPingLunModel.h"
#import "BHPingLunCell.h"
#import "HWGongGaoChildModel.h"
#import "HWGongGaoToolBar.h"
#import "BHPostsDetailModel.h"
#import "NSDate+HW.h"
#import "AFHTTPRequestOperationManager.h"
#import "HWBaseToolBar.h"
#import "HWToolBarView.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import "IQKeyboardManager.h"
#import "BHKeyBoardView.h"
#import "HWContentsLabel.h"
#import "HWEmotionTextView.h"
#import "HWEmotionKeyboard.h"
#import "BHNewPersonViewController.h"
#import "BHDetailTopModel.h"
#import "BHDetailZanModel.h"
#import "BHBigPicViewController.h"
#import "HWEmotion.h"
#import "BHNewHuaTiViewController.h"
#import "ZJFirstDetailBottom.h"
#import "ZJDetailReplyHeaderView.h"
#import "ZJPostNewBottomBar.h"
#import "ModelWebViewController.h"
#import "ZJShareView.h"
#import "HWComposeController.h"
#import "ZJForwardView.h"
#import "HWEmotionAttachment.h"
#import "UITextField+ZJExtentRange.h"

@interface BHPostDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,ZJPostNewBottomBarDelegate,ZJDetailReplyHeaderViewDelegate,UIAlertViewDelegate,BHPingLunCellDelegate,ZJShareViewDelegate,ZJForwardViewDelegate>
{
    NSMutableArray *_selectedPhotos;
}
@property (nonatomic, strong)UITableView *tableview;
@property (nonatomic, strong)CustomBtn *cusTomBtn;
@property (nonatomic, strong)NSMutableArray *listArr;
@property (nonatomic, strong)NSMutableArray *childArr;
@property (nonatomic, strong)NSString *loginuid;
@property (nonatomic, strong)NSString *replyID;
@property (nonatomic, strong)NSIndexPath *indexpath;
@property (nonatomic, assign)NSInteger section;
@property (nonatomic, assign)NSInteger page;
@property (nonatomic, strong)UITextField *field;

@property (nonatomic, strong)UIView *bottomView;
@property (nonatomic,weak) HWEmotionTextView *textView;
@property (nonatomic,assign,getter=isChangeKeyboard) BOOL changeKeyboard;
@property (nonatomic,strong) HWEmotionKeyboard *keyboard;
@property (nonatomic, strong) BHDetailTopModel *topModel;
@property (nonatomic, strong) NSMutableArray *zanArr;
@property (nonatomic, strong) NSMutableArray *picArr;
@property (nonatomic, strong) UILabel *lblzanwei;
@property (nonatomic, strong) UILabel *lblAlert;
@property (nonatomic, strong) UIView *topview;
@property (nonatomic, strong) UIButton *sendButton;
@property (nonatomic, assign) NSInteger hnum;
@property (nonatomic, assign) BOOL isFirst;

@property (nonatomic,strong) UIButton *btnEmotion;

@property (nonatomic,assign,getter=isShowEmotion) BOOL showEmotion;

@property (nonatomic, strong) NSIndexPath *index;

@property (nonatomic, strong)UIView *bgView;//点击空白处收回键盘
@end

@implementation BHPostDetailViewController

- (UILabel *)lblzanwei
{
    
    if (!_lblzanwei) {
        
        UILabel *lblzanwei = [[UILabel alloc]init];
        lblzanwei.hidden = NO;
        lblzanwei.font = [UIFont systemFontOfSize:13];
        lblzanwei.text = @"快来抢占头把交椅";
        lblzanwei.textColor = [UIColor colorWithHexString:@"c8c8c8"];
        lblzanwei.userInteractionEnabled = YES;
        lblzanwei.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40);
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(comm:)];
        [lblzanwei addGestureRecognizer:tap2];
        lblzanwei.backgroundColor = [UIColor whiteColor];
        lblzanwei.textAlignment = NSTextAlignmentCenter;
        
        
        _lblzanwei = lblzanwei;
    }
    return _lblzanwei;
    
}

-(NSMutableArray *)listArr
{
    if (_listArr == nil) {
        self.listArr = [NSMutableArray array];
    }
    return _listArr;
}
-(NSMutableArray *)childArr
{
    if (_childArr == nil) {
        self.childArr = [NSMutableArray array];
    }
    return _childArr;
}

-(NSMutableArray *)zanArr
{
    if (_zanArr == nil) {
        self.zanArr = [NSMutableArray array];
    }
    return _zanArr;
}
-(NSMutableArray *)picArr
{
    if (_picArr == nil) {
        self.picArr = [NSMutableArray array];
    }
    return _picArr;
}

- (HWEmotionKeyboard *)keyboard
{
    if (!_keyboard) {
        self.keyboard = [HWEmotionKeyboard new];
        self.keyboard.bounds = CGRectMake(0, 0, 320, 256);
        
    }
    
    return _keyboard;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.hidden = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(link2DidClick:) name:HWLinkDidClickNotification object:nil];


}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent = YES;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:HWLinkDidClickNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"refreshTablew" object:nil];
     [[IQKeyboardManager sharedManager] setEnable:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.automaticallyAdjustsScrollViewInsets = NO;
    [[IQKeyboardManager sharedManager] setEnable:NO];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *longinuid =  [defaults objectForKey:@"id"];
    self.loginuid = [NSString stringWithFormat:@"%@",longinuid];
    self.page = 1;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    // 键盘即将隐藏, 就会发出UIKeyboardWillHideNotification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    //添加表情按钮的通知
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emotionSelected:) name:HWEMotionViewDidSelectedNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearButtonClick:) name:HWEmotionDidClearButton object:nil];
    
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector (textFieldChange)name:UITextFieldTextDidChangeNotification object:nil];
    [self customTopView];
    [self createTableView];
    [self requestDetailData:NO];

    [self senderRequest:NO];
    [self refresh];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(huiFuButtonDidClick:) name:HWGongGaoToolBarHuiFuDidClick object:nil];
    
    if (_iskeyboardShow==YES)
    {
        [self.field becomeFirstResponder];
    }
    
}
#pragma mark - 网络请求 - 评论列表
- (void)senderRequest:(BOOL)isHeader
{
    if (_isFirst == YES) {
        [self.view Loading_0314];
    }
    
    RequestInterface *request = [[RequestInterface alloc] init];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *longinuid =  [defaults objectForKey:@"id"];
    
    NSDictionary *dic = @{
                          @"postid" : _tieZiID,
                          @"loginuid" : longinuid,
                          @"p" : @(_page)
                          };
    [request requestBHGongGaoWithDic:dic];
    
    
    [request getInterfaceRequestObject:^(id data) {
        if ([data[@"success"] boolValue] == YES)
        {
            if (isHeader == YES)
            {
                [self.listArr removeAllObjects];
                [self.childArr removeAllObjects];
            }
            
            for (NSDictionary *dict in data[@"datas"])
            {
                BHPingLunModel *model = [[BHPingLunModel alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                [self.listArr addObject:model];
                NSMutableArray *arr = [[NSMutableArray alloc]init];
                for (NSDictionary *d in dict[@"child"]) {
                    HWGongGaoChildModel *Cmodel = [[HWGongGaoChildModel alloc]init];
                    [Cmodel setValuesForKeysWithDictionary:d];
                    [arr addObject:Cmodel];
                }
                [self.childArr addObject:arr];
            }
            [self.tableview reloadData];
            
            if (_isFirst) {
                [self.view Hidden];
            }
        }
        else
        {
            if (_isFirst) {
                [self.view Hidden];
            }
        }
        
        
    } Fail:^(NSError *error) {
        if (_isFirst) {
            [self.view Hidden];
        }
        [self.view makeToast:@"请求失败"];
    }];
    
}
#pragma mark - 网络请求 - 详情

- (void)requestDetailData:(BOOL)isDelet
{
    [self.view Loading_0314];
    RequestInterface *interface = [[RequestInterface alloc]init];
    NSDictionary *dic = @{
                          @"postid":_tieZiID,
                          @"loginuid":self.loginuid,
                          };
    [interface requestBHDetailWithDic:dic];
    [interface getInterfaceRequestObject:^(id data)
     {
         if ([data[@"success"] boolValue] == YES)
         {
             NSLog(@"%@",data);
             if ([data[@"datas"] count] != 0)
             {
                 if (isDelet == YES) {
                     
                     [self.zanArr removeAllObjects];
                 }
                     self.topModel = [[BHDetailTopModel alloc]init];
                     [self.topModel setValuesForKeysWithDictionary:data[@"datas"]];
                 for (NSDictionary *dict in self.topModel.zan) {
                     BHDetailZanModel *zanModel = [[BHDetailZanModel alloc]init];
                     [zanModel setValuesForKeysWithDictionary:dict];
                     [self.zanArr addObject:zanModel];
                 }
                 
                 _hnum = [self.topModel.hnums integerValue];

                 [self createTopView];
                [self.tableview reloadData];
                 [self.view Hidden];
             }
             else
             {
                 [self.view Hidden];
                 [self.view makeToast:data[@"message"]];
             }
         }else
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

- (void)link2DidClick:(NSNotification *)note
{
    
    NSString *linkText = note.userInfo[HWLinkText];
    
    HWContentsLabel *label = note.userInfo[HWLabelself];
    
//    BHFirstListModel *model = self.listArr[label.tag];
    
    NSString *uid = self.topModel.subject_id[@"id"];
    if ([linkText hasPrefix:@"http"]) {
        ModelWebViewController * VC = [[ModelWebViewController alloc]initWithUrlString:linkText NavigationTitle:@"详情"];
        VC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:VC animated:YES];
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:linkText]];
    }else
    {
        
        
        if ([linkText containsString:@"@"]) {
            
            NSString *name = [linkText substringFromIndex:1];
            
            NSArray *mentionArray = self.topModel.usercalls;
            
            
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
            if (_isHuaTi == YES) {
                return;
            }
            else
            {
                BHNewHuaTiViewController *HuaTi = [[BHNewHuaTiViewController alloc] init];
                HuaTi.huatiid = uid;
                HuaTi.uid = self.topModel.uid;
                HuaTi.hidesBottomBarWhenPushed = YES;
                
                [self.navigationController pushViewController:HuaTi animated:YES];
                
            }
            
            
        }
        
        
    }
    
    
}



#pragma mark-创建tableView
- (void)createTableView
{
    
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64-49) style:(UITableViewStyleGrouped)];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
//    self.tableview.tableFooterView = [UIView new];
        [self.tableview registerClass:[BHPingLunCell class] forCellReuseIdentifier:@"BHPingLunCell"];
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableview];
        

    self.bottomView = [[UIView alloc]init];
    self.bottomView.frame = CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50);
    self.bottomView.backgroundColor = [UIColor whiteColor];
    
    UIView *viewline = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    viewline.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    [self.bottomView addSubview:viewline];
    
   self.btnEmotion = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnEmotion setImage:[UIImage imageNamed:@"表情"] forState:(UIControlStateNormal)];
    self.btnEmotion.frame = CGRectMake(10, 10, 30, 30);
    [self.btnEmotion addTarget:self action:@selector(openEmotion) forControlEvents:(UIControlEventTouchUpInside)];
    [self.bottomView addSubview:self.btnEmotion];
    
     self.field = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.btnEmotion.frame)+10, 10, SCREEN_WIDTH-CGRectGetMaxX(self.btnEmotion.frame)-70, 30)];
    self.field.borderStyle = UITextBorderStyleRoundedRect;
    self.field.placeholder = @"我也来说一句";
    self.field.delegate = self;
    
    self.field.returnKeyType = UIReturnKeySend;
    [self.bottomView addSubview:self.field];
    self.sendButton = [[UIButton alloc] init];
    self.sendButton.layer.cornerRadius = 4;
    self.sendButton.layer.masksToBounds = YES;
    self.sendButton.y = self.field.y;
    self.sendButton.width = 50;
    self.sendButton.x = CGRectGetMaxX(self.field.frame) + 5;
    self.sendButton.height = 28;
    self.sendButton.backgroundColor = [UIColor lightGrayColor];
    self.sendButton.enabled = NO;
    [self.sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [self.sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.sendButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.sendButton addTarget:self action:@selector(sendButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:self.sendButton];
    [self.view addSubview:self.bottomView];
    
}
#pragma mark -自定义导航栏
- (void)customTopView
{
    [self CreateCustomNavigtionBarWith:self leftItem:@selector(returnPage) rightItem:@selector(moreChoore:)];
    [self.rightBtn setImage:[UIImage imageNamed:@"gd-1"] forState:(UIControlStateNormal)];
     [self.rightBtn setImage:[UIImage imageByApplyingAlpha:[UIImage imageNamed:@"gd-1"]] forState:(UIControlStateHighlighted)];
    [self.backBtn setImage:[UIImage imageByApplyingAlpha:[UIImage imageNamed:@"bc-1"]] forState:(UIControlStateHighlighted)];
    [self.backBtn setImage:[UIImage imageNamed:@"bc-1"] forState:(UIControlStateNormal)];
    
    UILabel *lblName = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 44)];
    lblName.textColor = [UIColor colorWithHexString:@"ffffff"];
    lblName.font = [UIFont systemFontOfSize:18];
    lblName.textAlignment = NSTextAlignmentCenter;
    lblName.tag = 505;
    lblName.text = @"详情";
    [self.topView addSubview:lblName];
}


#pragma mark 返回
- (void)returnPage
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 右上角更多按钮
- (void)moreChoore:(UIButton *)btn
{
    NSString *url = [NSString stringWithFormat:@"%@/index.php/Apis/Forum/fenxiangweb/postid/%@",BANGHUI_SHAREURL,self.topModel.Tid];
    NSMutableArray *imageArray = [NSMutableArray array];
    if ([self.topModel.imgpath isEqualToString:@""])
    {
        [imageArray addObject:[UIImage imageNamed:IMAGE_NAME]];
    }else
    {
        [imageArray addObject:self.topModel.imgpath];
    }
    NSString *title = [NSString stringWithFormat:@"[邦会]%@",self.topModel.attributedContents.string];
    if (title.length > 100) {
        title = [title substringToIndex:100];
    }
    //分享视图所需参数
    NSDictionary *shareDic = @{@"url":url,
                               @"imageArr":imageArray,
                               @"title":title,
                               @"loginuid":self.loginuid,
                               @"tieZiID":_tieZiID,
                               @"uid":self.topModel.uid,
                               @"sinPic":self.topModel.imgpaths};
    
    ZJShareView *view = [ZJShareView share];
    view.shareDic = shareDic;
    view.delegate = self;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    [window addSubview:view];
    view.width = SCREEN_WIDTH;
    view.height = SCREEN_HEIGHT;
    view.y = 0;
    view.x = 0;
                view.bgView.backgroundColor = [UIColor blackColor];
                view.bgView.alpha= 0.0;
    view.topView.y = SCREEN_HEIGHT;

        [UIView animateWithDuration:0.5 animations:^{
            view.topView.y = SCREEN_HEIGHT-view.shareViewHeight;
            view.bgView.alpha= 0.3;
        } completion:^(BOOL finished) {
            
        }];
    
   
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [self removePost];
    }
}
#pragma mark - 删除帖子
- (void)removePost
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *parame = [NSMutableDictionary dictionary];
    parame[@"postid"] = _tieZiID;
    parame[@"loginuid"] = self.loginuid;
    NSString *url = [NSString stringWithFormat:@"%@/index.php/Apis/Forum/deletePosts/",BANGHUI_URL];
    [manager POST:url parameters:parame
          success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if ([responseObject[@"success"] boolValue] == YES)
         {
             NSNotification *noti = [NSNotification notificationWithName:@"refreshTablew" object:nil];
            [[NSNotificationCenter defaultCenter] postNotification:noti];
             
             
             [self dismissViewControllerAnimated:YES completion:^{
             }];
             [self.navigationController popViewControllerAnimated:YES];
         }
         else
         {
             [self zanErrorAlertView:@"提示" message:@"删帖失败"];
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [self zanErrorAlertView:@"提示" message:@"删帖失败"];
     }];
}

//删除帖子的代理
- (void)ZJShareViewRemovePost:(ZJShareView *)shareView
{
   //先移除window在弹出alert
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    shareView.bgView.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:0.5 animations:^{
        shareView.y = 0;
        shareView.y = SCREEN_HEIGHT;
    } completion:^(BOOL finished) {
        [window removeFromSuperview];
    }];
    
    if ([GetOrgType isEqualToString:@"2"])
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"确定删除帖子吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
        
    }
    else
    {
        [self zanErrorAlertView:nil message:@"您无权限进行此操作，请先绑定机构码"];
    }
}
//刷新
- (void)ZJShareViewRefreshView:(ZJShareView *)shareView
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    [UIView animateWithDuration:0.5 animations:^{
        shareView.y = 0;
        shareView.y = SCREEN_HEIGHT;
    } completion:^(BOOL finished) {
        [window removeFromSuperview];
    }];
    [self requestDetailData:YES];
}
#pragma mark 顶部视图
- (void)createTopView
{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    UIImageView *imgMyHead = [[UIImageView alloc]initWithFrame:CGRectMake(10, 14, 45, 45)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushPage)];
    imgMyHead.userInteractionEnabled = YES;
    [imgMyHead addGestureRecognizer:tap];
    imgMyHead.layer.cornerRadius = 45/2;
    if (![self.topModel.iconpath isKindOfClass:[NSNull class]])
    {
        [imgMyHead sd_setImageWithURL:[NSURL URLWithString:self.topModel.iconpath] placeholderImage:[UIImage imageNamed:@"默认个人图像"]];
    }
    imgMyHead.layer.masksToBounds = YES;
    [view addSubview:imgMyHead];
    
    UILabel *lblMyName = [[UILabel alloc]initWithFrame:CGRectMake(66, 17, [self widthForString:self.topModel.name size:14], 20 )];
    lblMyName.font = Default_Font_14;
    lblMyName.text = self.topModel.name;
    lblMyName.textColor = [UIColor colorWithHexString:@"00aff0"];
    [view addSubview:lblMyName];
    
    UIButton *btnLV = [UIButton buttonWithType:(UIButtonTypeRoundedRect)];
    NSDictionary *dic = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:13] forKey:NSFontAttributeName];
    CGRect bound = [self.topModel.remark boundingRectWithSize:CGSizeMake(0, 15) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    btnLV.frame = CGRectMake(CGRectGetMaxX(lblMyName.frame)+5, CGRectGetCenter(lblMyName.frame).y-15/2, bound.size.width+10, 15);
    [btnLV setTitle:self.topModel.remark forState:(UIControlStateNormal)];
    [btnLV setTitleColor:[UIColor colorWithHexString:@"00aff0"] forState:(UIControlStateNormal)];
    btnLV.titleLabel.font = Default_Font_13;
    btnLV.layer.borderColor = [UIColor colorWithHexString:@"d0d0d0"].CGColor;
    btnLV.layer.borderWidth = 0.5;
    btnLV.layer.masksToBounds = YES;
    btnLV.layer.cornerRadius = 5;
    [view addSubview:btnLV];
    
    UILabel *lblTime = [[UILabel alloc]initWithFrame:CGRectMake(66, 40, SCREEN_WIDTH-76, 20)];
    lblTime.font = Default_Font_10;

    if (self.topModel.org_name == nil) {
        self.topModel.org_name = @"";
    }
    NSString *or = [NSString stringWithFormat:@"%@",self.topModel.org_name];
    lblTime.text = or;
    lblTime.textColor = [UIColor colorWithHexString:@"bdbdbd"];
    [view addSubview:lblTime];
    
    if (![self.loginuid isEqualToString:self.topModel.uid])
    {
        UIButton *btnGuanZhu = [UIButton buttonWithType:(UIButtonTypeCustom)];
        btnGuanZhu.frame = CGRectMake(SCREEN_WIDTH-71, 23, 61, 30);
        if (self.topModel.isfocus != nil)
        {
            [btnGuanZhu setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            [btnGuanZhu setTitle:@"已关注" forState:(UIControlStateNormal)];
            btnGuanZhu.selected = YES;
        }else
        {
            [btnGuanZhu setImage:[UIImage imageNamed:@"plus_335px_1187514_easyicon.net"] forState:UIControlStateNormal];
            [btnGuanZhu setTitle:@"  关注" forState:(UIControlStateNormal)];
            btnGuanZhu.selected = NO;
        }
        [btnGuanZhu setTitleColor:[UIColor colorWithHexString:@"676767"] forState:(UIControlStateNormal)];
        [btnGuanZhu addTarget:self action:@selector(guanZhu:) forControlEvents:(UIControlEventTouchUpInside)];
        btnGuanZhu.titleLabel.font = Default_Font_15;
        [view addSubview:btnGuanZhu];
    }
    
    
    HWContentsLabel *lblBody = [[HWContentsLabel alloc]init];
    
    CGFloat textX = 10;
    CGFloat textY = CGRectGetMaxY(lblTime.frame)+10;
    CGFloat maxW = SCREEN_WIDTH - 2 * textX;
    CGSize maxSize = CGSizeMake(maxW, MAXFLOAT);
    CGSize textSize = [self.topModel.attributedContents boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    lblBody.frame = (CGRect){{textX,textY},textSize};
    lblBody.attributedText = self.topModel.attributedContents;
    [view addSubview:lblBody];
    CGFloat HEIGHT = 0;
    if ([self.topModel.forward isKindOfClass:[NSDictionary class]])
    {
        ZJForwardView *forward = [[ZJForwardView alloc]init];
//        self.forwardView.hidden = NO;
        forward.delegate = self;

        forward.frame =  CGRectMake(10,  CGRectGetMaxY(lblBody.frame)+10, SCREEN_WIDTH-20, 60);
        forward.dic = self.topModel.forward;
        [view addSubview:forward];
        HEIGHT += CGRectGetMaxY(lblBody.frame)+10 + 60;
    }
    else
    {
        CGFloat count = [self.topModel.imgpaths count];
        CGFloat margin = 5;
        UIView *imgsView = [[UIView alloc] init];
        imgsView.y = CGRectGetMaxY(lblBody.frame)+10;
        imgsView.width = SCREEN_WIDTH;
        CGFloat H = 0;
        for (NSUInteger i = 0; i < count; i++)
        {
            UIImageView *imgBody = [[UIImageView alloc]init];
            UITapGestureRecognizer *tapImg = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(jumpBigPic:)];
            imgBody.userInteractionEnabled = YES;
            imgBody.tag = i;
            [imgBody addGestureRecognizer:tapImg];
            
            UIImage *image = [[SDWebImageManager sharedManager].imageCache imageFromDiskCacheForKey:self.topModel.imgpaths[i]];
            if (!image) {
                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.topModel.imgpaths[i]]];
                image = [UIImage imageWithData:data];
            }
            
            if (image) {
                [imgBody setImage:image];
                CGFloat height = SCREEN_WIDTH / imgBody.image.size.width * imgBody.image.size.height;
                
                imgBody.frame = CGRectMake(0, H + margin, SCREEN_WIDTH,height - margin );
                H += height;
                
                imgBody.contentMode = UIViewContentModeScaleToFill;
                [imgsView addSubview:imgBody];
                [self.picArr addObject:self.topModel.imgpaths[i]];
            }
        }
        [view addSubview:imgsView];
        imgsView.height = H ;
        HEIGHT += CGRectGetMaxY(lblBody.frame)+10 + imgsView.height;
    }
    
    
    

    
    ZJPostNewBottomBar *barView = [[ZJPostNewBottomBar alloc]init];
    barView.height = 86/2;
    barView.width = SCREEN_WIDTH;
    barView.y = HEIGHT+10;
    barView.delegate = self;
    barView.btnShare.frame = CGRectMake(SCREEN_WIDTH-10-30, 0, 30, 43);
    barView.btnComm.frame = CGRectMake(CGRectGetMinX(barView.btnShare.frame)-50, 0, 40, 43);
    barView.btnZan.frame = CGRectMake(CGRectGetMinX(barView.btnComm.frame)-50, 0, 40, 43);
    NSString *time = [self dataWithTime:self.topModel.addtime];

    barView.lblTime.text = time;
    barView.lblTime.frame = CGRectMake(10, 0, SCREEN_WIDTH/2- (10+10+35), 43);
    if (![self.topModel.ispraise isEqualToString:@""])
    {
        barView.btnZan.selected = YES;
        [barView.btnZan setImage:[UIImage imageNamed:@"点赞之后"] forState:(UIControlStateNormal)];
    }
    else
    {
        barView.btnZan.selected = NO;
        [barView.btnZan setImage:[UIImage imageNamed:@"点赞"] forState:(UIControlStateNormal)];
    }
    if ([self.topModel.nums isEqualToString:@"0"])
    {
        [barView.btnZan setTitle:@"" forState:(UIControlStateNormal)];
    }else
    {
        [barView.btnZan setTitle:self.topModel.nums forState:(UIControlStateNormal)];
    }
    if ([self.topModel.hnums isEqualToString:@"0"])
    {
        [barView.btnComm setTitle:@"" forState:(UIControlStateNormal)];
    }else
    {
        [barView.btnComm setTitle:self.topModel.hnums forState:(UIControlStateNormal)];
    }

    [view addSubview:barView];
    
    UIView *viewLine = [[UIView alloc]init];
    viewLine.frame = CGRectMake(0, CGRectGetMaxY(barView.frame) , SCREEN_WIDTH, 8);
    viewLine.backgroundColor = [UIColor colorWithHexString:@"efeff4"];
    [view addSubview:viewLine];
    
    
        UIButton *zanBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        zanBtn.frame = CGRectMake(12, CGRectGetMaxY(viewLine.frame)+16, (SCREEN_WIDTH-30)/10-5, (SCREEN_WIDTH-30)/10-5);
        [zanBtn setImage:[UIImage imageNamed:@"点赞"] forState:(UIControlStateNormal)];
        [view addSubview:zanBtn];
        
            NSInteger num = [self.zanArr count];
        if (num > 8) {
            num = 8;
        }
        for (NSInteger i = num; i > 0; i--)
        {
            BHDetailZanModel *model = self.zanArr[i-1];
            UIImageView *imghead = [[UIImageView alloc]init];
            imghead.frame = CGRectMake(((SCREEN_WIDTH-30)/10)*i+14, CGRectGetMaxY(viewLine.frame)+16, (SCREEN_WIDTH-30)/10-5, (SCREEN_WIDTH-30)/10-5);
            imghead.layer.cornerRadius = CGRectGetWidth(imghead.frame)/2;
            imghead.layer.masksToBounds = YES;
            
            [imghead sd_setImageWithURL:[NSURL URLWithString:model.iconpath] placeholderImage:[UIImage imageNamed:@"默认个人图像"]];
            if (![model.iconpath isKindOfClass:[NSNull class]])
            {
                imghead.tag = [model.uid integerValue];
                UITapGestureRecognizer *headTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushToPerson:)];
                imghead.userInteractionEnabled = YES;
                [imghead addGestureRecognizer:headTap];
            }
            [view addSubview:imghead];
        }
        UIButton *btnZanCount = [UIButton buttonWithType:(UIButtonTypeCustom)];
        btnZanCount.frame = CGRectMake(SCREEN_WIDTH-(SCREEN_WIDTH-18)/10- 14, CGRectGetMaxY(viewLine.frame)+16, (SCREEN_WIDTH-30)/10-5, (SCREEN_WIDTH-30)/10-5);
        [btnZanCount addTarget:self action:@selector(pushToPrised:) forControlEvents:(UIControlEventTouchUpInside)];
    [btnZanCount setImage:[UIImage imageNamed:@"点赞更多"] forState:(UIControlStateNormal)];
        [view addSubview:btnZanCount];
        
        if ([self.zanArr count] > 8)
        {
            btnZanCount.hidden = NO;
        }
        else
        {
            btnZanCount.hidden = YES;
        }

    if ([self.zanArr count] != 0)
    {
        UIButton *btnPingLun = [UIButton buttonWithType:(UIButtonTypeCustom)];
        btnPingLun.frame = CGRectMake(9, CGRectGetMaxY(btnZanCount.frame)+13, 20, 20);
        btnPingLun.center = CGPointMake(CGRectGetCenter(zanBtn.frame).x, CGRectGetMaxY(btnZanCount.frame)+13+10);
        [btnPingLun  setImage:[UIImage imageNamed:@"评论"] forState:(UIControlStateNormal)];
        [view addSubview:btnPingLun];
        
        UILabel *lblPLNum = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-18)/10-10+9, CGRectGetMaxY(btnZanCount.frame)+13, 60, 20)];
        lblPLNum.textColor = [UIColor colorWithHexString:@"c8c8c8"];
        lblPLNum.textAlignment = NSTextAlignmentRight;
        lblPLNum.text = [NSString stringWithFormat:@"%ld条评论",(long)_hnum];
        lblPLNum.tag = 500;
        lblPLNum.textAlignment = NSTextAlignmentCenter;
        lblPLNum.font = [UIFont systemFontOfSize:12];
        [view addSubview:lblPLNum];
        

        view.frame = CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetMaxY(btnPingLun.frame)+10);

    }
    
    else
    {
        zanBtn.hidden = YES;
        btnZanCount.hidden = YES;
        UIButton *btnPingLun = [UIButton buttonWithType:(UIButtonTypeCustom)];
        btnPingLun.frame = CGRectMake(9, CGRectGetMaxY(barView.frame)+13, 20, 20);
        [btnPingLun  setImage:[UIImage imageNamed:@"评论"] forState:(UIControlStateNormal)];
        [view addSubview:btnPingLun];
        
        UILabel *lblPLNum = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-18)/10-10+9, CGRectGetMaxY(barView.frame)+13, 70, 20)];
        lblPLNum.textColor = [UIColor colorWithHexString:@"c8c8c8"];
        lblPLNum.textAlignment = NSTextAlignmentRight;
        lblPLNum.text = [NSString stringWithFormat:@"%ld条评论",(long)_hnum];
        lblPLNum.tag = 500;
        lblPLNum.textAlignment = NSTextAlignmentCenter;
        lblPLNum.font = [UIFont systemFontOfSize:12];
        [view addSubview:lblPLNum];
        

                    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetMaxY(btnPingLun.frame)+10);
        
    }
//    [self.tableview Hidden];
    self.tableview.tableHeaderView = view;
//    [self.view Hidden];
    
}

#pragma mark - 跳转查看图片页面
- (void)jumpBigPic:(UITapGestureRecognizer *)tap
{
    
    CATransition *animation = [CATransition animation];
    animation.duration = 1.0;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = @"rippleEffect";
    //animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromLeft;
    [self.view.window.layer addAnimation:animation forKey:nil];
    BHBigPicViewController *bigVC = [[BHBigPicViewController alloc]init];
    bigVC.index = tap.view.tag;
    bigVC.picArr = self.picArr;
    [self presentViewController:bigVC animated:YES completion:^{
        
    }];
    
}
// 抢占头把交椅的事件
- (void)comm:(UITapGestureRecognizer *)tap
{
    if ([GetOrgType isEqualToString:@"2"])
    {
        self.replyID = @"1";
        self.field.placeholder = @"我也来说一句";
        [self.field becomeFirstResponder];
    }else
    {
        [self zanErrorAlertView:nil message:@"您无权限进行此操作，请先绑定机构码"];
    }
}

#pragma mark-自适应高度
- (CGFloat)heightForString:(NSString *)str fontSize:(NSInteger)fontSize
{
    if (str == nil && [str isEqualToString:@""]) {
        return 0;
    }
    else
    {
        NSDictionary *dic = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:fontSize] forKey:NSFontAttributeName];
        CGRect bound = [str boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-20, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
        return bound.size.height;
    }
}
#pragma mark-UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    
    
    if (_hnum == 0) {
        
        
        
        return 0;
    }else
    {
        BHPingLunModel *model = self.listArr[section];
        

        return model.child.count;
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_hnum == 0) {
        return 1;
    }
    else
    {
        return self.listArr.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BHPingLunCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BHPingLunCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellAccessoryNone;
    cell.loginuid = self.loginuid;
    HWGongGaoChildModel *model = self.childArr[indexPath.section][indexPath.row];
    cell.index = indexPath.row;
    cell.indexpath = indexPath;
    [cell cellForModel:model];
    cell.delegate = self;
    cell.bodyLabel.tag = indexPath.row;
    return cell;
}
#pragma mark-UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HWGongGaoChildModel *model = self.childArr[indexPath.section][indexPath.row];
    if (model.Hname != nil)
    {
        NSString *str = [NSString stringWithFormat:@"%@回复%@:%@",model.name,model.Hname,model.contents];
        CGFloat H = [BHPingLunCell heightForString:str fontSize:12];
        if (indexPath.row == 0)
        {
            return H + 11;
        }
        else
        {
            return H + 4;
        }
    }
    else
    {
        NSString *str = [NSString stringWithFormat:@"%@:%@",model.name,model.contents];
        CGFloat H = [BHPingLunCell heightForString:str fontSize:12];
        if (indexPath.row == 0)
        {
            return H + 11;
        }
        else
        {
            return H + 4;
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (_hnum == 0) {
        if (section == 0) {
            return 40;
        }else
        {
            return 0.01;
        }
    }else
    {
        
        BHPingLunModel *model = self.listArr[section];
        CGFloat height = [model.contents boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-92, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size.height + 40+12+5;
        return height;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 8;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (_hnum == 0)
    {
       if (section == 0)
       {
           return self.lblzanwei;
        }
        else
        {
           self.lblzanwei.hidden = YES;
           return self.lblzanwei;
        }
    }
    else
    {
        BHPingLunModel *model = self.listArr[section];
        ZJDetailReplyHeaderView *replyView = [[ZJDetailReplyHeaderView alloc]init];
        replyView.delegate =self;
        replyView.loginuid = self.loginuid;
        replyView.model = model;
        replyView.tag = section;
        replyView.deletButton.tag = section;
        replyView.btnZan.tag = section;
        replyView.frame = CGRectMake(0, 0, SCREEN_WIDTH, replyView.viewHeight);
        replyView.backgroundColor = [UIColor whiteColor];
        return replyView;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]init];
    UIView *viewLine = [[UIView alloc]init];
    viewLine.frame = CGRectMake(0, 7.5, SCREEN_WIDTH, 0.5);
    viewLine.backgroundColor = [UIColor colorWithHexString:@"dadadc"];
    [view addSubview:viewLine];
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 8);
    view.backgroundColor = [UIColor whiteColor];
    return view;
} 

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([GetOrgType isEqualToString:@"2"]) {
        HWGongGaoChildModel *model = self.childArr[indexPath.section][indexPath.row];
        
        if ([self.loginuid isEqualToString:model.uid]) {
//            self.index = indexPath;
//            BHPingLunCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//            [self becomeFirstResponder];
//
//            UIMenuItem *copyLink = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(dele:)];
//            [[UIMenuController sharedMenuController] setMenuItems:@[copyLink]];
//            
//            [[UIMenuController sharedMenuController] setTargetRect:cell.bodyLabel.frame inView:cell.contentView];
//            
//            [[UIMenuController sharedMenuController] setMenuVisible:YES animated:YES];
        }
        else
        {
            self.replyID = @"3";
            self.field.placeholder = [NSString stringWithFormat:@"回复:%@",model.name];
            self.indexpath = indexPath;
            [self.field becomeFirstResponder];
        }
        
    }else
    {
        [self zanErrorAlertView:nil message:@"您无权限进行此操作，请先绑定机构码"];
    }
    
    

}
//删除回复
- (void)removeHuiFu:(BHPingLunCell *)cell
//- (void)dele:(UIMenuItem *)item
{
    
    if ([GetOrgType isEqualToString:@"2"]) {
        if ([[[UIDevice currentDevice] systemVersion]floatValue]>= 8.0) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"你确定要删除这条回复吗?" preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"否" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"是" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                HWGongGaoChildModel *model = self.childArr[self.index.section][self.index.row];
                AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
                NSMutableDictionary *parame = [NSMutableDictionary dictionary];
                parame[@"commentid"] = model.ID;
                parame[@"loginuid"] = self.loginuid;
                NSString *url = [NSString stringWithFormat:@"%@index.php/Apis/Forum/deleteComment/",BANGHUI_URL];
                [manager POST:url parameters:parame
                      success:^(AFHTTPRequestOperation *operation, id responseObject)
                 {
                     if ([responseObject[@"success"] boolValue] == YES)
                     {
                         
                         [self senderRequest:YES];
                     }
                     else
                     {
                         [self zanErrorAlertView:@"提示" message:@"删除失败"];
                     }
                 } failure:^(AFHTTPRequestOperation *operation, NSError *error)
                 {
                     [self zanErrorAlertView:@"提示" message:@"删除失败"];
                 }];
            }];
            [alert addAction:action];
            [alert addAction:action1];
            [self presentViewController:alert animated:YES completion:^{
                
            }];
        }else
        {
            HWGongGaoChildModel *model = self.childArr[self.index.section][self.index.row];
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            NSMutableDictionary *parame = [NSMutableDictionary dictionary];
            parame[@"commentid"] = model.ID;
            parame[@"loginuid"] = self.loginuid;
            NSString *url = [NSString stringWithFormat:@"%@index.php/Apis/Forum/deleteComment/",BANGHUI_URL];
            [manager POST:url parameters:parame
                  success:^(AFHTTPRequestOperation *operation, id responseObject)
             {
                 if ([responseObject[@"success"] boolValue] == YES)
                 {
                     
                     [self senderRequest:YES];
                 }
                 else
                 {
                     [self zanErrorAlertView:@"提示" message:@"删除失败"];
                 }
             } failure:^(AFHTTPRequestOperation *operation, NSError *error)
             {
                 [self zanErrorAlertView:@"提示" message:@"删除失败"];
             }];

        }
    }else
    {
        [self zanErrorAlertView:nil message:@"您无权限进行此操作，请先绑定机构码"];
    }
}
//删除评论
- (void)clickDeletReplyAction:(ZJDetailReplyHeaderView *)replyHeaderView
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"你确定要删除这条评论吗?" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"否" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"是" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            
            BHPingLunModel *model = self.listArr[replyHeaderView.deletButton.tag];
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            NSMutableDictionary *parame = [NSMutableDictionary dictionary];
            parame[@"commentid"] = model.pingLunID;
            parame[@"loginuid"] = self.loginuid;
            NSString *url = [NSString stringWithFormat:@"%@/index.php/Apis/Forum/deleteComment/",BANGHUI_URL];
            [manager POST:url parameters:parame
                  success:^(AFHTTPRequestOperation *operation, id responseObject)
             {
                 if ([responseObject[@"success"] boolValue] == YES)
                 {
                     [self.listArr removeObjectAtIndex:replyHeaderView.deletButton.tag];
                     [self.tableview reloadData];
                 }
                 else
                 {
                     [self zanErrorAlertView:@"提示" message:@"删除失败"];
                 }
             } failure:^(AFHTTPRequestOperation *operation, NSError *error)
             {
                 [self zanErrorAlertView:@"提示" message:@"删除失败"];
             }];
        }];
        [alert addAction:action];
        [alert addAction:action1];
        [self presentViewController:alert animated:YES completion:^{
            
        }];
    }else
    {
        BHPingLunModel *model = self.listArr[replyHeaderView.deletButton.tag];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSMutableDictionary *parame = [NSMutableDictionary dictionary];
        parame[@"commentid"] = model.pingLunID;
        parame[@"loginuid"] = self.loginuid;
        NSString *url = [NSString stringWithFormat:@"%@/index.php/Apis/Forum/deleteComment/",BANGHUI_URL];
        [manager POST:url parameters:parame
              success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             if ([responseObject[@"success"] boolValue] == YES)
             {
                 [self.listArr removeObjectAtIndex:replyHeaderView.deletButton.tag];
                 [self.tableview reloadData];
             }
             else
             {
                 [self zanErrorAlertView:@"提示" message:@"删除失败"];
             }
         } failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             [self zanErrorAlertView:@"提示" message:@"删除失败"];
         }];

    }


}

-(void)tapSendReplyAction:(ZJDetailReplyHeaderView *)replyHeaderView
{
    BHPingLunModel *model = self.listArr[replyHeaderView.tag];
    self.replyID = @"2";
    self.field.placeholder = [NSString stringWithFormat:@"回复:%@",model.name];
    self.section = replyHeaderView.tag;
    [self.field becomeFirstResponder];
}
- (void)clickZanReplyAction:(ZJDetailReplyHeaderView *)replyHeaderView
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *longinuid =  [defaults objectForKey:@"id"];
    BHPingLunModel *model = self.listArr[replyHeaderView.btnZan.tag];
    NSLog(@"%ld",(long)replyHeaderView.btnZan.tag);
    [self zanAnimation:replyHeaderView.btnZan];
    NSInteger count =  model.dz_num;
    
    if (replyHeaderView.btnZan.selected == YES)
    {
        
        [self.view makeToast:@"亲，你已经赞过啦~" duration:1 position:@"center"];
    }
    else
    {
        [replyHeaderView btnstate:count+1];
        [replyHeaderView.btnZan setImage:[UIImage imageNamed:@"点赞之后"] forState:(UIControlStateNormal)];
        model.is_praise = @"333";
        replyHeaderView.btnZan.selected = YES;
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSMutableDictionary *parame = [NSMutableDictionary dictionary];
        parame[@"commentid"] = model.pingLunID;
        parame[@"loginuid"] = longinuid;
        NSString *url = [NSString stringWithFormat:@"%@/index.php/Apis/Forum/setCommentLike/",BANGHUI_URL];
        [manager POST:url parameters:parame
              success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             if ([responseObject[@"success"] boolValue] == YES)
             {
                 
             }
             else
             {
                 
             }
         } failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             
         }];

    }
    
}

- (void)pushPage
{
    BHNewPersonViewController *personVC = [[BHNewPersonViewController alloc]init];
//    personVC.uid = self.topDic[@"uid"];
    personVC.uid = self.topModel.uid;
    [self.navigationController pushViewController:personVC animated:YES];
}

#pragma mark -关注按钮的事件
- (void)guanZhu:(UIButton *)btn
{
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([GetOrgType isEqualToString:@"2"]) {
        
        btn.selected = !btn.selected;
        if (btn.selected == YES)
        {
            [btn setImage:[UIImage imageNamed:@""] forState:(UIControlStateNormal)];
            [btn setTitle:@"已关注" forState:(UIControlStateNormal)];
            if (_isMessageVC == NO)
            {
                
                NSString *str = [NSString stringWithFormat:@"%ld",(long)_index_row];
                NSDictionary *dict = @{@"index":str,@"isGuan":@"1"};
                NSNotification *noti = [NSNotification notificationWithName:@"changeGuanState" object:nil userInfo:dict];
                [[NSNotificationCenter defaultCenter] postNotification:noti];
            }
            
            [self alertView:nil message:@"关注成功"];
            
        }
        else
        {
            if (_isMessageVC == NO)
            {
                NSString *str = [NSString stringWithFormat:@"%ld",(long)_index_row];
                NSDictionary *dict = @{@"index":str,@"isGuan":@"2"};
                NSNotification *noti = [NSNotification notificationWithName:@"changeGuanState" object:nil userInfo:dict];
                [[NSNotificationCenter defaultCenter] postNotification:noti];
            }
            
            [btn setTitle:@"  关注" forState:(UIControlStateNormal)];
            [btn setImage:[UIImage imageNamed:@"plus_335px_1187514_easyicon.net"] forState:(UIControlStateNormal)];
            [self alertView:nil message:@"取消关注"];
            
        }
        [self setGuanZhu:btn];
    }else
    {
        [self zanErrorAlertView:nil message:@"您无权限进行此操作，请先绑定机构码"];
    }
    
    
}
#pragma mark - 网络请求-关注接口
- (void)setGuanZhu:(UIButton *)btn
{
//    [self.view Hidden];
    RequestInterface *interface = [[RequestInterface alloc]init];
    NSDictionary *dic = @{
//                          @"uid":self.topDic[@"uid"],
                          @"uid":self.topModel.uid,
                          @"loginuid":self.loginuid,
                          };
    [interface requestBHGuanZhuWithDic:dic];
    [interface getInterfaceRequestObject:^(id data)
     {
         if ([data[@"success"] boolValue] == YES)
         {
//             [btn setImage:[UIImage imageNamed:@""] forState:(UIControlStateNormal)];
//             [btn setTitle:@"已关注" forState:(UIControlStateNormal)];
         }
         else
         {
//             [btn setTitle:@"关注" forState:(UIControlStateNormal)];
//             [btn setImage:[UIImage imageNamed:@"plus_335px_1187514_easyicon.net"] forState:(UIControlStateNormal)];
         }
     } Fail:^(NSError *error)
     {
//         [self.view makeToast:@"关注失败"];
         [self alertView:@"提示" message:@"关注失败"];
     }];
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

#pragma mark-跳转到赞过的人页面
- (void)pushToPrised:(UIButton *)button
{
    PrisedViewController *prisedVC = [[PrisedViewController alloc]init];
    prisedVC.postID = _tieZiID;
    prisedVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:prisedVC animated:YES];}

#pragma mark-跳转到个人页面
- (void)pushToPerson:(UITapGestureRecognizer *)tap
{
    BHNewPersonViewController *personVC = [[BHNewPersonViewController alloc]init];
    personVC.uid = [NSString stringWithFormat:@"%ld",(long)tap.view.tag];
    [self.navigationController pushViewController:personVC animated:YES];
}
#pragma mark-自适应宽度
- (CGFloat)widthForString:(NSString *)str size:(CGFloat)size
{
    NSDictionary *dic = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:size] forKey:NSFontAttributeName];
    CGRect bound = [str boundingRectWithSize:CGSizeMake(0, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    return bound.size.width;
}
#pragma mark - 时间转换
- (NSString *)dataWithTime:(NSString *)time
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"EEE MMM dd HH:mm:ss Z yyyy";
#warning 真机调试必须加上这句
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    
    // 获得微博发布的具体时间
    NSTimeInterval timer = [time doubleValue];
    NSDate *createDate = [NSDate dateWithTimeIntervalSince1970:timer];
    
    // 判断是否为今年
    if (createDate.isThisYear) {
        if (createDate.isToday) { // 今天
            NSDateComponents *cmps = [createDate deltaWithNow];
            if (cmps.hour >= 1) { // 至少是1小时前发的
                return [NSString stringWithFormat:@"%ld小时前", (long)cmps.hour];
            } else if (cmps.minute >= 1) { // 1~59分钟之前发的
                return [NSString stringWithFormat:@"%ld分钟前", (long)cmps.minute];
            } else { // 1分钟内发的
                return @"刚刚";
            }
        } else if (createDate.isYesterday) { // 昨天
            fmt.dateFormat = @"昨天 HH:mm";
            return [fmt stringFromDate:createDate];
        } else { // 至少是前天
            fmt.dateFormat = @"MM-dd HH:mm";
            return [fmt stringFromDate:createDate];
        }
    } else { // 非今年
        fmt.dateFormat = @"yyyy-MM-dd";
        return [fmt stringFromDate:createDate];;
    }

}
//#pragma mark - 键盘
//- (void)setupKeyboard
//{
//    HWKeyboardView *keyboard = [HWKeyboardView new];
//    keyboard.width = self.view.width;
//    keyboard.height = 150;
//    keyboard.delegate = self;
//    keyboard.backgroundColor = [UIColor colorWithHexString:@"f8f8f8"];
//    self.keyboard = keyboard;
//    keyboard.y = self.view.height;
//    [self.view addSubview:keyboard];
//}
- (void)huiFuButtonDidClick:(NSNotification *)note
{
//    self.replyID= @"1";
//    self.keyboard.textView.placeholder = @"我也来说说";
//    [self.keyboard.textView becomeFirstResponder];
//    self.keyboard.section = [note.userInfo[@"section"] integerValue];
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    [self.field resignFirstResponder];
}
#pragma mark - 发送评论
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    _isFirst = YES;
    if ([GetOrgType isEqualToString:@"2"]) {
        _page = 1;
        if (textField.text.length == 0) {
            [self alertView:@"提示" message:@"文字不能为空"];
        }
        else{
            
            [textField resignFirstResponder];
            self.lblzanwei.hidden = YES;
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            NSMutableDictionary *parame = [NSMutableDictionary dictionary];
            parame[@"postid"] = _tieZiID;
            parame[@"loginuid"] = self.loginuid;
            parame[@"contents"] = textField.text;
            if ([self.replyID isEqualToString:@"1"])
            {
                
            }
            else if ([self.replyID isEqualToString:@"2"])
            {
                
                
                BHPingLunModel *model = self.listArr[self.section];
                parame[@"pid"] = model.pingLunID;
            }
            else if ([self.replyID isEqualToString:@"3"])
            {
                
                HWGongGaoChildModel *childModel = self.childArr[self.indexpath.section][self.indexpath.row];
                parame[@"replyuid"] = childModel.uid;
                BHPingLunModel *model = self.listArr[self.indexpath.section];
                parame[@"pid"] = model.pingLunID;
            }
            [self.view Loading:@"发送中"];
            NSString *url = [NSString stringWithFormat:@"%@/index.php/Apis/Forum/setComment/",BANGHUI_URL];
            [manager POST:url parameters:parame
                  success:^(AFHTTPRequestOperation *operation, id responseObject)
             {
                 if ([responseObject[@"success"] boolValue] == YES)
                 {
                     NSLog(@"评论成功");
                     [self.view Hidden];
                     self.field.text = nil;
                     self.field.placeholder = @"我也来说一句";
                     [self senderRequest:YES];
                     _hnum++;
                     UILabel *lblPingNum = [self.view viewWithTag:500];
                     lblPingNum.text = [NSString stringWithFormat:@"%ld条评论",(long)_hnum];
                     
                     [self textFieldChange];
                 }
                 else
                 {
                     [self.view Hidden];
                     [self.view Message:@"评论失败" HiddenAfterDelay:3];
                      [self textFieldChange];
                     NSLog(@"评论失败");
                 }
             } failure:^(AFHTTPRequestOperation *operation, NSError *error)
             {
                 [self.view Message:@"评论失败" HiddenAfterDelay:3];
                  [self textFieldChange];
                 [self.view Hidden];
             }];
        }
        
        return YES;
    }else
    {
        [self zanErrorAlertView:nil message:@"您无权限进行此操作，请先绑定机构码"];
        return YES;
    }
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



- (void)keyboardViewResigFirstResponder
{
    
//    [self.keyboard.textView resignFirstResponder];
}
- (void)keyboardWillShow:(NSNotification *)note
{
    NSDictionary *userInfo = [note userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    //用于收回键盘的view
    self.bgView = [[UIView alloc]init];
    self.bgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-height);
    self.bgView.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removekeyboardView)];
    [self.bgView addGestureRecognizer:tap];
    [self.tableview addSubview:self.bgView];
    
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    CGFloat offY = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    [UIView animateWithDuration:duration animations:^{
        
        self.bottomView.transform = CGAffineTransformMakeTranslation(0, -offY );
        
    }];
    
    
}
- (void)removekeyboardView
{
    [self.field resignFirstResponder];
}

- (void)keyboardWillHide:(NSNotification *)note
{
   
    [self.bgView removeFromSuperview];

    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    [UIView animateWithDuration:duration animations:^{
        
        self.bottomView.transform = CGAffineTransformIdentity;
        
    }];
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
#pragma mark -ZJPostDelegate 底部工具栏

- (void)clickBarButtonComm:(ZJPostNewBottomBar *)psstBar
{
    if ([GetOrgType isEqualToString:@"2"])
    {
        self.replyID = @"1";
        self.field.placeholder = @"我也来说一句";
        [self.field becomeFirstResponder];
    }else
    {
        [self zanErrorAlertView:nil message:@"您无权限进行此操作，请先绑定机构码"];
    }
}
-(void)clickBarButtonZan:(ZJPostNewBottomBar *)psstBar
{
    if ([GetOrgType isEqualToString:@"2"]) {
        [self zanAnimation:psstBar.btnZan];
        psstBar.btnZan.selected = !psstBar.btnZan.selected;
        if (psstBar.btnZan.selected == YES)
        {
        }
        else
        {
        }
        
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSMutableDictionary *parame = [NSMutableDictionary dictionary];
        parame[@"postid"] = _tieZiID;
        parame[@"loginuid"] = self.loginuid;
        NSString *url = [NSString stringWithFormat:@"%@/index.php/Apis/Forum/setLike/",BANGHUI_URL];
        [manager POST:url parameters:parame
              success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             if ([responseObject[@"success"] boolValue] == YES)
             {
                 NSLog(@"%@",responseObject);
                 [psstBar.btnZan setImage:[UIImage imageNamed:@"点赞之后"] forState:(UIControlStateNormal)];
//                 [psstBar.btnZan setTitle:@"已赞" forState:(UIControlStateNormal)];
                 if (_isMessageVC == NO)
                 {
                     NSString *str = [NSString stringWithFormat:@"%ld",(long)_index_row];
                     NSDictionary *dict = @{@"index":str,@"iszan":@"1"};
                     NSNotification *noti = [NSNotification notificationWithName:@"changeZanState" object:nil userInfo:dict];
                     [[NSNotificationCenter defaultCenter] postNotification:noti];
                 }
                 [self requestDetailData:YES];
                 
             }
             else
             {
                 [psstBar.btnZan setImage:[UIImage imageNamed:@"点赞"] forState:(UIControlStateNormal)];
//                 [psstBar.btnZan setTitle:@"赞" forState:(UIControlStateNormal)];
                 if (_isMessageVC == NO)
                 {
                     NSString *str = [NSString stringWithFormat:@"%ld",(long)_index_row];
                     NSDictionary *dict = @{@"index":str,@"iszan":@"2"};
                     NSNotification *noti = [NSNotification notificationWithName:@"changeZanState" object:nil userInfo:dict];
                     [[NSNotificationCenter defaultCenter] postNotification:noti];
                 }
                 [self requestDetailData:YES];
                 
             }
         } failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             [self zanErrorAlertView:@"提示" message:@"点赞失败"];
         }];
        
    }else
    {
        [self zanErrorAlertView:nil message:@"您无权限进行此操作，请先绑定机构码"];
        
    }
}

- (void)clickBarButtonShare:(ZJPostNewBottomBar *)psstBar
{
    if ([GetOrgType isEqualToString:@"2"]) {
        HWComposeController *subVC = [[HWComposeController alloc]init];
        subVC.isForward = YES;
        subVC.detailModel = self.topModel;
        if (self.topModel.forward)
        {
            subVC.forward_id = self.topModel.forward[@"id"];
            subVC.forwardTitle = [NSString stringWithFormat:@"@%@:%@//",self.topModel.name,self.topModel.contents];
        }
        else
        {
            subVC.forward_id = self.topModel.Tid;
            subVC.forwardTitle = @"转发";
        }
        //添加@数组
        NSMutableArray *arr = [NSMutableArray arrayWithObject:self.topModel.uid];
        subVC.forward_uid = arr;
        if (self.topModel.usercalls.count != 0)
        {
            for (int i = 0; i < self.topModel.usercalls.count; i++) {
                [subVC.forward_uid addObject:self.topModel.usercalls[i][@"id"]];
            }
        }
        subVC.InterfaceDistinguish = @"2";
        UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:subVC];
        [self presentViewController:navi animated:YES completion:nil];
        


    }else
    {
        [self zanErrorAlertView:nil message:@"您无权限进行此操作，请先绑定机构码"];
    }

}

//#pragma mark - 对评论点赞
//-(void)clickBottomBtnZanAction:(ZJFirstDetailBottom *)bottomView
//{
//    
//}

#pragma mark - 刷新
- (void)refresh
{
    __block BHPostDetailViewController *test = self;
    //    [self.tableview headerBeginRefreshing];
//    [self.tableview addHeaderWithCallback:^{
//        test.page = 1;
//        [test senderRequest:YES];
//        [test.tableview headerEndRefreshing];
//    }];
    [self.tableview addFooterWithCallback:^{
        test.page ++;
        [test senderRequest:NO];
        [test.tableview footerEndRefreshing];
    }];
}







//- (void)emotionSelected:(NSNotification *)note;
//{
//    HWEmotion *emotion = note.userInfo[HWEmotionViewEmotion];
//    
//    [self.textView appendEmotion:emotion];
//    
//    [self textViewDidChange:self.textView];
//}
- (void)openEmotion
{
    
    if (self.isShowEmotion) {
        
        [self.btnEmotion setImage:[UIImage imageNamed:@"表情"] forState:UIControlStateNormal];
        
    }else{
        
         [self.btnEmotion setImage:[UIImage imageNamed:@"键盘"] forState:UIControlStateNormal];
        
    }
    
    
    self.changeKeyboard = YES;
    if (self.field.inputView) {
         self.field.inputView = nil;
        self.showEmotion = NO;
    }else{
        self.field.inputView = self.keyboard;
        self.showEmotion = YES;
    }
    [self.field resignFirstResponder];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.field becomeFirstResponder];
        
    });
    
    
    
    
    
    
}


- (void)textViewDidChange:(UITextView *)textView
{
    
    self.navigationItem.rightBarButtonItem.enabled = textView.hasText || _selectedPhotos.count > 0;
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)emotionSelected:(NSNotification *)note;
{
    HWEmotion *emotion = note.userInfo[HWEmotionViewEmotion];
    
    if (emotion.emoji) {
        
        [self.field insertText:emotion.emoji];
        
        
    }else
    {
        
        
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:self.field.attributedText];
        
        HWEmotionAttachment *attch = [[HWEmotionAttachment alloc] init];
        attch.emotion = emotion;
        attch.image = [UIImage imageNamed:emotion.png];
        attch.bounds = CGRectMake(0, -3, self.field.font.lineHeight, self.field.font.lineHeight);
        
        NSAttributedString *attchStr = [NSAttributedString attributedStringWithAttachment:attch];
        NSInteger selectedIndx = self.field.selectedRange.location;
//        UITextRange *selectedIndx = self.field.selectedTextRange;
        [attributedText insertAttributedString:attchStr atIndex:selectedIndx];
#warning 富文本的位置一定要在self.attributedText = attributedText之前 插入之后;
        [attributedText addAttribute:NSFontAttributeName value:self.field.font range:NSMakeRange(0, attributedText.length)];
        
        self.field.attributedText = attributedText;
//        self.field.selectedRange = NSMakeRange(selectedIndx + 1, 0);
        self.field.selectedRange = NSMakeRange(selectedIndx + 1, 0);

    }
    
    
}
- (void)clearButtonClick:(NSNotification *)note
{
    
    [self.field deleteBackward];
    
}
- (void)textFieldChange
{
    
    self.sendButton.enabled = self.field.hasText;
    
    if (self.sendButton.enabled == YES) {
        
        [self.sendButton setBackgroundColor:[UIColor colorWithHexString:@"00aff0"]];
        
    }else{
        
        [self.sendButton setBackgroundColor:[UIColor lightGrayColor]];
        
    }
    
    
    
}
- (void)sendButtonClick
{
    
    [self textFieldShouldReturn:self.field];
    
}
//#pragma mark - 顶部视图的代理
//- (void)clikeGuanZhuButtonAction:(ZJFirstDetailHeaderView *)firstHead
//{
//    
//}
//-(void)tapImgJumpPageAction:(ZJFirstDetailHeaderView *)firstHead
//{
//    
//}
//-(void)tapImg:(ZJFirstDetailPicView *)picView
//{
//    
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
