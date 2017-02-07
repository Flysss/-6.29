  //
//  HWGongGaoViewController.m
//  SalesHelper_A
//
//  Created by 胡伟 on 16/3/9.
//  Copyright © 2016年 X. All rights reserved.
//

#import "HWGongGaoViewController.h"
#import "UIColor+HexColor.h"
#import "CustomBtn.h"
#import "HWGongGaoCell.h"
#import "RequestInterface.h"
#import "HWGongGaoModel.h"
#import "MJExtension.h"
#import "HWGongGaoFrame.h"
#import "HWKeyboardView.h"
#import "BHPingLunCell.h"
#import "BHPingLunModel.h"
#import "HWGongGaoToolBar.h"
#import "NSDate+HW.h"
#import "HWTextView.h"
#import "PrisedViewController.h"
#import "BHNewPersonViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "HWToolBarView.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import "BHDetailTopModel.h"
#import "BHDetailZanModel.h"
#import "BHBigPicViewController.h"
#import "HWEmotionKeyboard.h"
#import "HWEmotion.h"
#import "IQKeyboardManager.h"
#import "ZJFirstDetailBottom.h"
#import "ZJDetailReplyHeaderView.h"
#import "ZJPostNewBottomBar.h"
#import "ZJShareView.h"
#import "HWComposeController.h"
#import "UITextField+ZJExtentRange.h"
#import "HWEmotionAttachment.h"


@interface HWGongGaoViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,ZJFirstDetailBottomDelegate,ZJPostNewBottomBarDelegate,ZJDetailReplyHeaderViewDelegate>

@property (nonatomic, strong)UITableView *tableview;
@property (nonatomic, strong)CustomBtn *cusTomBtn;
@property (nonatomic, strong)NSMutableArray *listArr;
@property (nonatomic, strong)NSMutableArray *childArr;
@property (nonatomic, strong) NSMutableDictionary *topDic;
//@property (nonatomic, weak) HWKeyboardView *keyboard;
@property (nonatomic, strong) NSString *loginuid;
@property (nonatomic, copy) NSString *replyID;
@property (nonatomic, strong) NSIndexPath *indexpath;
@property (nonatomic, assign) BOOL isdi;

@property (nonatomic, strong) NSMutableArray *zanArr;
@property (nonatomic, strong) NSMutableArray *picArr;
@property (nonatomic, strong) UILabel *lblzanwei;
@property (nonatomic, strong)UITextField *field;
@property (nonatomic, strong) BHDetailTopModel *topModel;

@property (nonatomic, strong)UIView *bottomView;
@property (nonatomic, assign)NSInteger section;
@property (nonatomic, assign)NSInteger page;
@property (nonatomic,strong) HWEmotionKeyboard *keyboard;
@property (nonatomic, strong)UILabel *lblAlert;

@property (nonatomic,strong) UIButton *sendButton;

@property (nonatomic,strong) UIButton *btnEmotion;

@property (nonatomic,assign,getter=isShowEmotion) BOOL showEmotion;
@property (nonatomic, strong) UIView *topView;

@end

@implementation HWGongGaoViewController

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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.hidden = YES;

}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    self.navigationController.navigationBar.translucent = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *longinuid =  [defaults objectForKey:@"id"];
    self.loginuid = [NSString stringWithFormat:@"%@",longinuid];
    _page = 1;
    [self senderRequest:NO];
    [self requestDetailData:NO];
//    [self customNavigation];
    [self customTopView];
    [self createTableView];
//    [self setupKeyboard];
//    [self createBottom];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(huiFuButtonDidClick:) name:HWGongGaoToolBarHuiFuDidClick object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    // 键盘即将隐藏, 就会发出UIKeyboardWillHideNotification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emotionSelected:) name:HWEMotionViewDidSelectedNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearButtonClick:) name:HWEmotionDidClearButton object:nil];
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector (textFieldChange)name:UITextFieldTextDidChangeNotification object:nil];
    [[IQKeyboardManager sharedManager] setEnable:NO];

    self.lblAlert = [[UILabel alloc]init];
    self.lblAlert.backgroundColor = [UIColor lightGrayColor];
    self.lblAlert.textColor = [UIColor whiteColor];
    self.lblAlert.text = @"亲，你已经赞过啦~";
    self.lblAlert.textAlignment = NSTextAlignmentCenter;
    self.lblAlert.font = [UIFont systemFontOfSize:10];
    self.lblAlert.frame = CGRectMake(0, 0, SCREEN_WIDTH/3, 20);
    self.lblAlert.center = CGPointMake(self.view.width/2, self.view.height/2);
    self.lblAlert.alpha = 0;
    [self.view addSubview:self.lblAlert];

}
#pragma mark -评论列表
- (void)senderRequest:(BOOL)isHeader
{
    RequestInterface *request = [[RequestInterface alloc] init];
   
    
    NSDictionary *dic = @{
                          @"postid" : _postID,
                          @"loginuid" : self.loginuid,
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
            
            
            [self.view Hidden];
        }
        else
        {
            [self.view Hidden];
        }
        
        
    } Fail:^(NSError *error) {
        
    }];
    
}
#pragma mark - 网络请求 - 邦会公告详情
- (void)requestDetailData:(BOOL)isDelet
{
    RequestInterface *interface = [[RequestInterface alloc]init];
    NSDictionary *dic = @{
                          @"postid":_postID,
                          @"loginuid" : self.loginuid,
                          };
    [interface requestBHDetailWithDic:dic];
    [interface getInterfaceRequestObject:^(id data)
     {
         if ([data[@"success"] boolValue] == YES)
         {
             if ([data[@"datas"] count] != 0)
             {
                 if (isDelet == YES) {
                     
                     [self.zanArr removeAllObjects];
                 }
                 //                 for (NSDictionary *dict in data[@"datas"])
                 //                 {
                 self.topModel = [[BHDetailTopModel alloc]init];
                 [self.topModel setValuesForKeysWithDictionary:data[@"datas"]];
                 //                 }
                 //                 self.topDic = data[@"datas"];
                 for (NSDictionary *dict in self.topModel.zan) {
                     BHDetailZanModel *zanModel = [[BHDetailZanModel alloc]init];
                     [zanModel setValuesForKeysWithDictionary:dict];
                     [self.zanArr addObject:zanModel];
                 }
                 
                 
                 [self createTopView];
                 //                 [self createBottom];
                 [self.tableview reloadData];
             }
             else
             {
                 [self.view makeToast:data[@"message"]];
             }
             [self.view Hidden];
         }else
         {
             [self.view makeToast:data[@"message"]];
             [self.view Hidden];
             
         }
     } Fail:^(NSError *error)
     {
         [self.view Hidden];
         [self.view makeToast:@"请求失败"];
     }];
}

#pragma mark-创建tableView
- (void)createTableView
{
    
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64-40) style:(UITableViewStyleGrouped)];
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
    //    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(endTounch)];
    //    [self.view addGestureRecognizer:tap];
    
    
}
#pragma mark -自定义导航栏
- (void)customTopView
{
    self.topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    UIButton *btnBack = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [btnBack setImage:[UIImage imageNamed:@"bc-1"] forState:(UIControlStateNormal)];
    [btnBack setImage:[UIImage imageByApplyingAlpha:[UIImage imageNamed:@"bc-1"]] forState:(UIControlStateHighlighted)];
    [btnBack addTarget:self action:@selector(returnPage) forControlEvents:(UIControlEventTouchUpInside)];
    btnBack.frame = CGRectMake(5, 20, 30, 44);
    [self.topView addSubview:btnBack];
    
    UIButton *rightBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [rightBtn setImage:[UIImage imageNamed:@"gd-1"] forState:(UIControlStateNormal)];
    [rightBtn setImage:[UIImage imageByApplyingAlpha:[UIImage imageNamed:@"gd-1"]] forState:(UIControlStateHighlighted)];
    [rightBtn addTarget:self action:@selector(moreChoore:) forControlEvents:(UIControlEventTouchUpInside)];
    rightBtn.frame = CGRectMake(SCREEN_WIDTH-40-5, 20, 40, 44);
    [self.topView addSubview:rightBtn];
    
    
    UILabel *lblName = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 44)];
    lblName.textColor = [UIColor colorWithHexString:@"ffffff"];
    lblName.font = [UIFont systemFontOfSize:18];
    lblName.textAlignment = NSTextAlignmentCenter;
    lblName.tag = 505;
    if (_isBangSchool) {
        lblName.text = @"邦学院";

    }else
    {
        
        lblName.text = @"公告";
    }
    [self.topView addSubview:lblName];
    self.topView.backgroundColor = [UIColor colorWithHexString:@"00aff0"];
    
    [self.view addSubview:self.topView];
    
    
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
    NSString *title;
    if (_isBangSchool) {
        title = [NSString stringWithFormat:@"[邦学院]%@",self.topModel.attributedContents.string];
    }
    else
    {
        title = [NSString stringWithFormat:@"[公告]%@",self.topModel.attributedContents.string];
    }
    if (title.length > 100) {
        title = [title substringToIndex:100];
    }
    //分享视图所需参数
    NSDictionary *shareDic = @{@"url":url,
                               @"imageArr":imageArray,
                               @"title":title,
                               @"loginuid":self.loginuid,
                               @"tieZiID":_postID,
                               @"uid":self.topModel.uid,
                               @"sinPic":self.topModel.imgpaths};

    ZJShareView *view = [ZJShareView share];
    view.shareDic = shareDic;
//    view.delegate = self;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    view.isReport = YES;
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

#pragma mark 返回
- (void)returnPage
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark 顶部视图
- (void)createTopView
{
    
    NSString *str = self.topModel.contents;
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    UILabel *lblTitle = [[UILabel alloc]init];
    lblTitle.frame = CGRectMake(10, 10, SCREEN_WIDTH-20, 30);
    lblTitle.textColor = [UIColor colorWithHexString:@"676767"];
    lblTitle.font = [UIFont systemFontOfSize:20];
    lblTitle.text = self.topModel.topic;
    [view addSubview:lblTitle];
    
    
    UILabel *lblTime = [[UILabel alloc]initWithFrame:CGRectMake(10, 40, SCREEN_WIDTH-20, 20)];
    lblTime.font = Default_Font_10;
    NSString *time = [self dataWithTime:self.topModel.addtime];
    if (self.topModel.org_name == nil) {
        self.topModel.org_name = @"";
    }
    NSString *or = [NSString stringWithFormat:@"%@  %@",time,self.topModel.oper];
    lblTime.text = or;
    lblTime.textColor = [UIColor colorWithHexString:@"bdbdbd"];
    [view addSubview:lblTime];
    
    UILabel *lblBody = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(lblTime.frame)+10, SCREEN_WIDTH-20, [self heightForString:str fontSize:16])];
    lblBody.numberOfLines = 0;
    lblBody.textColor = [UIColor colorWithHexString:@"676767"];
    lblBody.font = [UIFont systemFontOfSize:16];
    lblBody.text = str;
    [view addSubview:lblBody];
    
    UIImageView *imgsView = [[UIImageView alloc]init];
    CGFloat margin = 5;
    UIImage *image = [[SDWebImageManager sharedManager].imageCache imageFromDiskCacheForKey:self.topModel.imgpath];
    if (!image) {
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.topModel.imgpath]];
        image = [UIImage imageWithData:data];
    }else
    {
        [imgsView setImage:image];
        CGFloat height = SCREEN_WIDTH / imgsView.image.size.width * imgsView.image.size.height;
        imgsView.frame = CGRectMake(0, CGRectGetMaxY(lblBody.frame) + margin, SCREEN_WIDTH,height - margin );
        imgsView.contentMode = UIViewContentModeScaleToFill;
        [view addSubview:imgsView];
    }
    
    ZJPostNewBottomBar *barView = [[ZJPostNewBottomBar alloc]init];
    barView.height = 86/2;
    barView.width = SCREEN_WIDTH;
    barView.y = CGRectGetMaxY(imgsView.frame)+10;
    barView.btnShare.frame = CGRectMake(SCREEN_WIDTH-10-30, 0, 30, 43);
    barView.btnComm.frame = CGRectMake(CGRectGetMinX(barView.btnShare.frame)-50, 0, 40, 43);
    barView.btnZan.frame = CGRectMake(CGRectGetMinX(barView.btnComm.frame)-50, 0, 40, 43);
    barView.delegate = self;
    
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
    
    
    //
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
    btnZanCount.layer.borderWidth = 0.1;
    NSString *zanCount = [NSString stringWithFormat:@"%ld",(long)[self.zanArr count]];
    [btnZanCount setTitle:zanCount forState:(UIControlStateNormal)];
    [btnZanCount setTitleColor:[UIColor colorWithHexString:@"00aff0"] forState:(UIControlStateNormal)];
    btnZanCount.layer.cornerRadius = CGRectGetWidth(btnZanCount.frame)/2;
    btnZanCount.layer.masksToBounds = YES;
    [view addSubview:btnZanCount];
    
    if ([self.zanArr count] > 8)
    {
        btnZanCount.hidden = NO;
    }
    else
    {
        btnZanCount.hidden = YES;
    }
    
    
    self.lblzanwei = [[UILabel alloc]init];
    self.lblzanwei.text = @"快来抢占头把交椅";
    self.lblzanwei.font = [UIFont systemFontOfSize:13];
    self.lblzanwei.textColor = [UIColor colorWithHexString:@"c8c8c8"];
    self.lblzanwei.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(comm)];
    [self.lblzanwei addGestureRecognizer:tap2];
    self.lblzanwei.textAlignment = NSTextAlignmentCenter;
    [view addSubview:self.lblzanwei];
    
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
        lblPLNum.text = [NSString stringWithFormat:@"%@条评论",self.topModel.hnums];
        lblPLNum.textAlignment = NSTextAlignmentCenter;
        lblPLNum.font = [UIFont systemFontOfSize:12];
        [view addSubview:lblPLNum];
        
        if ([self.topModel.hnums integerValue] == 0) {
            self.lblzanwei.hidden = NO;
            self.lblzanwei.frame = CGRectMake(0, CGRectGetMaxY(btnPingLun.frame), SCREEN_WIDTH, 30);
            view.frame = CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetMaxY(btnPingLun.frame)+10+CGRectGetHeight(self.lblzanwei.frame)) ;
            
        }
        else
        {
            self.lblzanwei.hidden = YES;
            view.frame = CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetMaxY(btnPingLun.frame)+10);
        }
        
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
        lblPLNum.text = [NSString stringWithFormat:@"%@条评论",self.topModel.hnums];
        lblPLNum.textAlignment = NSTextAlignmentCenter;
        lblPLNum.font = [UIFont systemFontOfSize:12];
        [view addSubview:lblPLNum];
        
        
        if ([self.topModel.hnums integerValue] == 0) {
            self.lblzanwei.hidden = NO;
            self.lblzanwei.frame = CGRectMake(0, CGRectGetMaxY(btnPingLun.frame), SCREEN_WIDTH, 30);
            view.frame = CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetMaxY(btnPingLun.frame)+10+CGRectGetHeight(self.lblzanwei.frame));
        }
        else
        {
            self.lblzanwei.hidden = YES;
            view.frame = CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetMaxY(btnPingLun.frame)+10);
        }
        
    }
    
    self.tableview.tableHeaderView = view;
    
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
- (void)comm
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
    BHPingLunModel *model = self.listArr[section];
    return model.child.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.listArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BHPingLunCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BHPingLunCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellAccessoryNone;
    HWGongGaoChildModel *model = self.childArr[indexPath.section][indexPath.row];
    [cell cellForModel:model];
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
    BHPingLunModel *model = self.listArr[section];
    CGFloat height = [model.contents boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-92, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size.height + 40+20;
    return height;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 8;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
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
    HWGongGaoChildModel *model = self.childArr[indexPath.section][indexPath.row];
    self.replyID = @"3";
    self.field.placeholder = [NSString stringWithFormat:@"回复:%@",model.name];
    self.indexpath = indexPath;
    [self.field becomeFirstResponder];
    
    
    //    NSString *str = [NSString stringWithFormat:@"回复:%@",model.name];
    //    self.keyboard.textView.placeholder = str;
    //    self.indexpath = indexPath;
}
//删除回复
- (void)removeHuiFu:(BHPingLunCell *)cell
{
    if ([GetOrgType isEqualToString:@"2"]) {
        
        HWGongGaoChildModel *model = self.childArr[cell.indexpath.section][cell.indexpath.row];
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
    }else
    {
        [self zanErrorAlertView:nil message:@"您无权限进行此操作，请先绑定机构码"];
    }
}
//删除评论
- (void)clickDeletReplyAction:(ZJDetailReplyHeaderView *)replyHeaderView
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

- (void)HuiPingLun:(UITapGestureRecognizer *)tap
{
    BHPingLunModel *model = self.listArr[tap.view.tag];
    self.replyID = @"2";
    self.field.placeholder = [NSString stringWithFormat:@"回复:%@",model.name];
    self.section = tap.view.tag;
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
        [UIView animateWithDuration:2.5 animations:^{
            self.lblAlert.alpha = 0;
            self.lblAlert.alpha = 1;
            self.lblAlert.alpha = 0;
        }];
        
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

//#pragma mark 点赞按钮的事件
//- (void)zanAction:(UIButton *)button
//{
//    button.selected = !button.selected;
//    if (button.selected == YES)
//    {
//        [button setImage:[UIImage imageNamed:@"点赞之后"] forState:(UIControlStateNormal)];
//        [button setTitle:@" 已赞" forState:(UIControlStateNormal)];
//    }
//    else if (button.selected == NO)
//    {
//        [button setImage:[UIImage imageNamed:@"点赞"] forState:(UIControlStateNormal)];
//        [button setTitle:@" 赞" forState:(UIControlStateNormal)];
//
//    }
//    [self zanAnimation:button];
//}

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
    if ([GetOrgType isEqualToString:@"2"]) {
        
        btn.selected = !btn.selected;
        if (btn.selected == YES)
        {
            [btn setImage:[UIImage imageNamed:@""] forState:(UIControlStateNormal)];
            [btn setTitle:@"已关注" forState:(UIControlStateNormal)];
            
            NSString *str = [NSString stringWithFormat:@"%ld",(long)_index_row];
            NSDictionary *dict = @{@"index":str,@"isGuan":@"1"};
            NSNotification *noti = [NSNotification notificationWithName:@"changeGuanState" object:nil userInfo:dict];
            [[NSNotificationCenter defaultCenter] postNotification:noti];
            
            [self alertView:nil message:@"关注成功"];
            
        }
        else
        {
            NSString *str = [NSString stringWithFormat:@"%ld",(long)_index_row];
            NSDictionary *dict = @{@"index":str,@"isGuan":@"2"};
            NSNotification *noti = [NSNotification notificationWithName:@"changeGuanState" object:nil userInfo:dict];
            [[NSNotificationCenter defaultCenter] postNotification:noti];
            
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
    [self.view Hidden];
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
    [self.navigationController pushViewController:prisedVC animated:YES];
}

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
    if ([GetOrgType isEqualToString:@"2"]) {
        
        _page = 1;
        if (textField.text.length == 0) {
            [self alertView:@"提示" message:@"文字不能为空"];
        }
        else
        {
            [textField resignFirstResponder];
            self.lblzanwei.hidden = YES;
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            NSMutableDictionary *parame = [NSMutableDictionary dictionary];
            parame[@"postid"] = _postID;
            parame[@"loginuid"] = self.loginuid;
            parame[@"contents"] = textField.text;
            //        NSString *addtime = [NSString stringWithFormat:@"%ld",time(NULL)];
            //        NSString *face = [[NSUserDefaults standardUserDefaults] objectForKey:@"login_User_face"];
            //        NSString *str = [NSString stringWithFormat:@"http://app.hfapp.cn/%@",face];
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
- (void)keyboardWillShow:(NSNotification *)note
{
    
    
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    CGFloat offY = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    [UIView animateWithDuration:duration animations:^{
        
        self.bottomView.transform = CGAffineTransformMakeTranslation(0, -offY );
        
    }];
    
    
}

- (void)keyboardWillHide:(NSNotification *)note
{
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    [UIView animateWithDuration:duration animations:^{
        
        self.bottomView.transform = CGAffineTransformIdentity;
        
    }];
    
    
    
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
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
        parame[@"postid"] = _postID;
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
                
                 [self requestDetailData:YES];
                 
             }
             else
             {
                 [psstBar.btnZan setImage:[UIImage imageNamed:@"点赞"] forState:(UIControlStateNormal)];
//                 [psstBar.btnZan setTitle:@"赞" forState:(UIControlStateNormal)];
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

        
//        NSString *url = [NSString stringWithFormat:@"%@/index.php/Apis/Forum/fenxiangweb/postid/%@",BANGHUI_SHAREURL,self.topModel.Tid];
//        NSMutableArray *imageArray = [NSMutableArray array];
//        if ([self.topModel.imgpath isEqualToString:@""])
//        {
//            [imageArray addObject:[UIImage imageNamed:IMAGE_NAME]];
//        }else
//        {
//            UIImageView *img = [[UIImageView alloc]init];
//            [img sd_setImageWithURL:[NSURL URLWithString:self.topModel.imgpath]];
//            UIImage *image = [self ImageWithImageSimple:img.image ScaledToSize:CGSizeMake(100, 100)];
//            [imageArray addObject:image];
//        }
//        
//        NSString *title = [NSString stringWithFormat:@"[邦会]%@",self.topModel.attributedContents.string];
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
#pragma mark - 对评论点赞
-(void)clickBottomBtnZanAction:(ZJFirstDetailBottom *)bottomView
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *longinuid =  [defaults objectForKey:@"id"];
    BHPingLunModel *model = self.listArr[bottomView.btnZan.tag];
    
    [self zanAnimation:bottomView.btnZan];
    //    bottomView.btnZan.selected = !bottomView.btnZan.selected;
    NSInteger count =  model.dz_num;
    
    if (bottomView.btnZan.selected == YES)
    {
        //        model.is_praise = @"333";
        [UIView animateWithDuration:2.5 animations:^{
            self.lblAlert.alpha = 0;
            self.lblAlert.alpha = 1;
            self.lblAlert.alpha = 0;
        }];
        
    }
    else
    {
        //        [bottomView btnstate:count];
        //        [bottomView.btnZan setImage:[UIImage imageNamed:@"点赞"] forState:(UIControlStateNormal)];
        [bottomView btnstate:count+1];
        [bottomView.btnZan setImage:[UIImage imageNamed:@"点赞之后"] forState:(UIControlStateNormal)];
        model.is_praise = @"333";
        bottomView.btnZan.selected = YES;
        
    }
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

#pragma mark - 刷新
- (void)refresh
{
    __weak HWGongGaoViewController *test = self;
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
        [attributedText insertAttributedString:attchStr atIndex:selectedIndx];
#warning 富文本的位置一定要在self.attributedText = attributedText之前 插入之后;
        [attributedText addAttribute:NSFontAttributeName value:self.field.font range:NSMakeRange(0, attributedText.length)];
        
        self.field.attributedText = attributedText;
        self.field.selectedRange = NSMakeRange(selectedIndx + 1, 0);
        
    }
    
}
- (void)clearButtonClick:(NSNotification *)note
{
    
    [self.field deleteBackward];
    
}

//压缩图片
-(UIImage*)ImageWithImageSimple:(UIImage*)image ScaledToSize:(CGSize)newSize{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}
@end
