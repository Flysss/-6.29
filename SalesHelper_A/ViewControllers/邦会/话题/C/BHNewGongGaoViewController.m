//
//  BHNewGongGaoViewController.m
//  SalesHelper_A
//
//  Created by zhipu on 16/3/21.
//  Copyright © 2016年 X. All rights reserved.
//

#import "BHNewGongGaoViewController.h"

#import "UIColor+HexColor.h"
#import "HWBaseToolBar.h"
#import "HWToolBarView.h"
#import "NSDate+HW.h"
#import "BHPingLunModel.h"

#import "ZJFirstDetailHeaderView.h"


@interface BHNewGongGaoViewController ()<UITableViewDelegate,UITableViewDataSource,HWBaseToolBarDelegate>

@property (nonatomic, strong)NSString *loginuid;
@property (nonatomic, strong)UITableView *tableview;
@property (nonatomic, strong) NSMutableDictionary *topDic;
@property (nonatomic, strong) NSMutableArray *listArr;
@property (nonatomic, strong) UIView *topView;

@end

@implementation BHNewGongGaoViewController

-(NSMutableArray *)listArr
{
    if (_listArr == nil) {
        self.listArr = [NSMutableArray array];
    }
    return _listArr;
}
//-(NSMutableArray *)childArr
//{
//    if (_childArr == nil) {
//        self.childArr = [NSMutableArray array];
//    }
//    return _childArr;
//}
-(NSMutableDictionary *)topDic
{
    if (_topDic == nil) {
        self.topDic = [NSMutableDictionary dictionary];
    }
    return _topDic;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *longinuid =  [defaults objectForKey:@"id"];
    self.loginuid = [NSString stringWithFormat:@"%@",longinuid];
    [self requestDetailData];
    [self createTopView];
    
}
#pragma mark - 网络请求 - 邦会公告详情
- (void)requestDetailData
{
    RequestInterface *interface = [[RequestInterface alloc]init];
    NSDictionary *dic = @{
                          @"postid":_postID,
                          };
    [interface requestBHDetailWithDic:dic];
    [interface getInterfaceRequestObject:^(id data)
     {
         if ([data[@"success"] boolValue] == YES)
         {
             if ([data[@"datas"] count] != 0)
             {
                 self.topDic = data[@"datas"];
                 
                 [self createTopView];
                 [self.tableview reloadData];
             }
             else
             {
                 [self.view makeToast:data[@"message"]];
             }
         }else
         {
             [self.view makeToast:data[@"message"]];
             
         }
     } Fail:^(NSError *error)
     {
         [self.view makeToast:@"请求失败"];
     }];
}
#pragma mark-创建tableView
- (void)createTableView
{
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-49) style:(UITableViewStyleGrouped)];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    //    self.tableview.tableFooterView = [UIView new];
//    [self.tableview registerClass:[BHPingLunCell class] forCellReuseIdentifier:@"BHPingLunCell"];
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableview];
}

//- (void)topViewCreate
//{
//    ZJFirstDetailHeaderView *headerView = [[ZJFirstDetailHeaderView alloc]init];
//    [self.topView addSubview:headerView];
//    
//    
//    
//}









#pragma mark 顶部视图
- (void)createTopView
{
    
    NSString *str = self.topDic[@"contents"];
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
//    UIImageView *imgMyHead = [[UIImageView alloc]initWithFrame:CGRectMake(10, 14, 45, 45)];
//    imgMyHead.layer.cornerRadius = 45/2;
//    if (self.topDic[@"iconpath"] != [NSNull null])
//    {
//        [imgMyHead sd_setImageWithURL:[NSURL URLWithString:self.topDic[@"iconpath"]] placeholderImage:[UIImage imageNamed:@"自己页面头像"]];
//    }
//    imgMyHead.layer.masksToBounds = YES;
//    [view addSubview:imgMyHead];
//    
//    UILabel *lblMyName = [[UILabel alloc]initWithFrame:CGRectMake(66, 17, [self widthForString:self.topDic[@"name"] size:14], 20 )];
//    lblMyName.font = Default_Font_14;
//    lblMyName.text = self.topDic[@"name"];
//    lblMyName.textColor = [UIColor colorWithHexString:@"00aff0"];
//    [view addSubview:lblMyName];
//    
//    UIButton *btnLV = [UIButton buttonWithType:(UIButtonTypeRoundedRect)];
//    btnLV.frame = CGRectMake(CGRectGetMaxX(lblMyName.frame)+5, 17, 40, 20);
//    [btnLV setTitle:self.topDic[@"remark"] forState:(UIControlStateNormal)];
//    [btnLV setTitleColor:[UIColor colorWithHexString:@"00aff0"] forState:(UIControlStateNormal)];
//    btnLV.titleLabel.font = [UIFont systemFontOfSize:11];
//    btnLV.layer.borderColor = [UIColor colorWithHexString:@"d0d0d0"].CGColor;
//    btnLV.layer.borderWidth = 0.5;
//    btnLV.layer.masksToBounds = YES;
//    btnLV.layer.cornerRadius = 10;
//    [view addSubview:btnLV];
//    
//    UILabel *lblTime = [[UILabel alloc]initWithFrame:CGRectMake(66, 40, 100, 20)];
//    lblTime.font = Default_Font_10;
//    NSString *time = [self dataWithTime:self.topDic[@"addtime"]];
//    lblTime.text = time;
//    lblTime.textColor = [UIColor colorWithHexString:@"bdbdbd"];
//    [view addSubview:lblTime];
//    
//    if (self.loginuid != self.topDic[@"uid"])
//    {
//        UIButton *btnGuanZhu = [UIButton buttonWithType:(UIButtonTypeCustom)];
//        btnGuanZhu.frame = CGRectMake(SCREEN_WIDTH-61, 23, 51, 30);
//        if (self.topDic[@"isfocus"] != [NSNull null])
//        {
//            [btnGuanZhu setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
//            [btnGuanZhu setTitle:@"已关注" forState:(UIControlStateNormal)];
//        }else
//        {
//            [btnGuanZhu setImage:[UIImage imageNamed:@"plus_335px_1187514_easyicon.net"] forState:UIControlStateNormal];
//            [btnGuanZhu setTitle:@"关注" forState:(UIControlStateNormal)];
//        }
//        [btnGuanZhu setTitleColor:[UIColor colorWithHexString:@"676767"] forState:(UIControlStateNormal)];
//        [btnGuanZhu addTarget:self action:@selector(guanZhu:) forControlEvents:(UIControlEventTouchUpInside)];
//        btnGuanZhu.titleLabel.font = Default_Font_15;
//        [view addSubview:btnGuanZhu];
//    }
    UILabel *lblTopic = [[UILabel alloc]initWithFrame:CGRectMake(10, 9, SCREEN_WIDTH-10, 30)];
    lblTopic.font = [UIFont systemFontOfSize:20];
    lblTopic.textColor = [UIColor colorWithHexString:@"676767"];
    lblTopic.text = self.topDic[@"topic"];
    [view addSubview:lblTopic];
    
    UILabel *lblTime = [[UILabel alloc]initWithFrame:CGRectMake(10, 47, 100, 20)];
    lblTime.font = Default_Font_14;
    NSString *time = [self dataWithTime:self.topDic[@"addtime"]];
    lblTime.text = time;
    lblTime.textColor = [UIColor colorWithHexString:@"bebebf"];
    [view addSubview:lblTime];
    
    UILabel *lblOrg = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lblTime.frame), 47, 100, 20)];
    lblOrg.textColor = [UIColor colorWithHexString:@"bebebf"];
    lblOrg.font = [UIFont systemFontOfSize:14];
    if (![self.topDic[@"org_name"] isKindOfClass:[NSNull class]]) {
        lblOrg.text = self.topDic[@"org_name"];
    }
    [view addSubview:lblOrg];
    
    CGFloat count = [self.topDic[@"imgpaths"] count];
    CGFloat margin = 5;
    CGFloat imgBodyH = 190;
    UIView *imgsView = [[UIView alloc] init];
    imgsView.y = CGRectGetMaxY(lblTime.frame);
    imgsView.height = imgBodyH * count + margin;
    imgsView.width = SCREEN_WIDTH;
    
    for (NSUInteger i = 0; i < count; i++)
    {
        UIImageView *imgBody = [[UIImageView alloc]init];
        [imgBody sd_setImageWithURL:[NSURL URLWithString:self.topDic[@"imgpaths"][i]] placeholderImage:[UIImage imageNamed:@"pp_bg"]];
        imgBody.contentMode = UIViewContentModeScaleAspectFill;
        imgBody.clipsToBounds = YES;
        imgBody.frame = CGRectMake(0, imgBodyH * i + margin, SCREEN_WIDTH,imgBodyH - margin);
        
        [imgsView addSubview:imgBody];
    }
    [view addSubview:imgsView];
    
    UILabel *lblBody = [[UILabel alloc]initWithFrame:CGRectMake(13, 73+(count*190+5), SCREEN_WIDTH-20, [self heightForString:str fontSize:16])];
    lblBody.numberOfLines = 0;
    lblBody.textColor = [UIColor colorWithHexString:@"676767"];
    lblBody.font = [UIFont systemFontOfSize:16];
    lblBody.text = str;
    [view addSubview:lblBody];
    
    UILabel *lblLine = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(lblBody.frame)+10, SCREEN_WIDTH, 0.5)];
    lblLine.backgroundColor = [UIColor colorWithHexString:@"dadadc"];
    [view addSubview:lblLine];
    
    
    HWToolBarView *barView = [[HWToolBarView alloc]init];
    barView.height = 49;
    barView.width = SCREEN_WIDTH;
    barView.y = CGRectGetMaxY(lblLine.frame)+5;
    //    barView.backgroundColor = [UIColor colorWithHexString:@"ebebeb"];
    barView.backgroundColor = [UIColor whiteColor];
    barView.delegate = self;
    
    [view addSubview:barView];
    
    
    UILabel *lblLine3 = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(barView.frame)+5, SCREEN_WIDTH, 0.5)];
    lblLine3.backgroundColor = [UIColor colorWithHexString:@"dadadc"];
    [view addSubview:lblLine3];
    //
    UIButton *zanBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    zanBtn.frame = CGRectMake(9, CGRectGetMaxY(lblLine3.frame)+16, (SCREEN_WIDTH-20)/10-5, (SCREEN_WIDTH-20)/10-5);
    [zanBtn setImage:[UIImage imageNamed:@"点赞"] forState:(UIControlStateNormal)];
    [view addSubview:zanBtn];
    
    NSInteger num = [self.topDic[@"zan"] count];
    if (num > 8) {
        num = 8;
    }
    for (NSInteger i = num; i > 0; i--)
    {
        UIImageView *imghead = [[UIImageView alloc]init];
        imghead.frame = CGRectMake(((SCREEN_WIDTH-18)/10)*i+10, CGRectGetMaxY(lblLine3.frame)+16, (SCREEN_WIDTH-20)/10-5, (SCREEN_WIDTH-20)/10-5);
        imghead.layer.cornerRadius = CGRectGetWidth(imghead.frame)/2;
        imghead.layer.masksToBounds = YES;
        
        [imghead sd_setImageWithURL:[NSURL URLWithString:self.topDic[@"zan"][num-i][@"iconpath"]] placeholderImage:[UIImage imageNamed:@"自己页面头像"]];
        if (self.topDic[@"zan"][num-i][@"uid"] != [NSNull null])
        {
            imghead.tag = [self.topDic[@"zan"][num-i][@"uid"] integerValue];
            UITapGestureRecognizer *headTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushToPerson:)];
            imghead.userInteractionEnabled = YES;
            [imghead addGestureRecognizer:headTap];
        }
        [view addSubview:imghead];
    }
    UIButton *btnZanCount = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btnZanCount.frame = CGRectMake(SCREEN_WIDTH-(SCREEN_WIDTH-18)/10-9, CGRectGetMaxY(lblLine3.frame)+16, (SCREEN_WIDTH-20)/10-5, (SCREEN_WIDTH-20)/10-5);
    [btnZanCount addTarget:self action:@selector(pushToPrised:) forControlEvents:(UIControlEventTouchUpInside)];
    btnZanCount.layer.borderWidth = 0.1;
    NSString *zanCount = [NSString stringWithFormat:@"%ld",(long)[self.topDic[@"zan"] count]];
    [btnZanCount setTitle:zanCount forState:(UIControlStateNormal)];
    [btnZanCount setTitleColor:[UIColor colorWithHexString:@"00aff0"] forState:(UIControlStateNormal)];
    btnZanCount.layer.cornerRadius = CGRectGetWidth(btnZanCount.frame)/2;
    btnZanCount.layer.masksToBounds = YES;
    [view addSubview:btnZanCount];
    
    if ([self.topDic[@"zan"] count] > 8)
    {
        btnZanCount.hidden = NO;
    }
    else
    {
        btnZanCount.hidden = YES;
    }
    
    if ([self.topDic[@"zan"] count] != 0)
    {
        
        UIButton *btnPingLun = [UIButton buttonWithType:(UIButtonTypeCustom)];
        btnPingLun.frame = CGRectMake(9, CGRectGetMaxY(btnZanCount.frame)+13, 20, 20);
        btnPingLun.center = CGPointMake(CGRectGetCenter(btnZanCount.frame).x, CGRectGetMaxY(btnZanCount.frame)+13+10);
        
        [btnPingLun  setImage:[UIImage imageNamed:@"评论"] forState:(UIControlStateNormal)];
        [view addSubview:btnPingLun];
        
        UILabel *lblPLNum = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-18)/10-10+9, CGRectGetMaxY(btnZanCount.frame)+13, 60, 20)];
        lblPLNum.textColor = [UIColor colorWithHexString:@"c8c8c8"];
        lblPLNum.textAlignment = NSTextAlignmentRight;
        lblPLNum.text = [NSString stringWithFormat:@"%@条评论",self.topDic[@"hnums"]];
        lblPLNum.textAlignment = NSTextAlignmentCenter;
        lblPLNum.font = [UIFont systemFontOfSize:12];
        [view addSubview:lblPLNum];
        
        UILabel *lblLine2 = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-18)/10-10+9+75-10, CGRectGetMaxY(btnZanCount.frame)+13+10, SCREEN_WIDTH-80-(SCREEN_WIDTH-18)/10-9+10, 0.5)];
        lblLine2.backgroundColor = [UIColor colorWithHexString:@"dadadc"];
        [view addSubview:lblLine2];
        view.frame = CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetMaxY(btnPingLun.frame)+10) ;
    }
    
    else
    {
        lblLine3.hidden = YES;
        zanBtn.hidden = YES;
        btnZanCount.hidden = YES;
        //        self.LikeView.hidden = YES;
        UIButton *btnPingLun = [UIButton buttonWithType:(UIButtonTypeCustom)];
        btnPingLun.frame = CGRectMake(9, CGRectGetMaxY(barView.frame)+13, 20, 20);
        //        btnPingLun.center = CGPointMake(CGRectGetCenter(zanBtn.frame).x, CGRectGetMaxY(zanBtn.frame)+13+10);
        [btnPingLun  setImage:[UIImage imageNamed:@"评论"] forState:(UIControlStateNormal)];
        [view addSubview:btnPingLun];
        
        UILabel *lblPLNum = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-18)/10-10+9, CGRectGetMaxY(barView.frame)+13, 70, 20)];
        lblPLNum.textColor = [UIColor colorWithHexString:@"c8c8c8"];
        lblPLNum.textAlignment = NSTextAlignmentRight;
        lblPLNum.text = [NSString stringWithFormat:@"%@条评论",self.topDic[@"hnums"]];
        lblPLNum.textAlignment = NSTextAlignmentCenter;
        lblPLNum.font = [UIFont systemFontOfSize:12];
        [view addSubview:lblPLNum];
        
        UILabel *lblLine2 = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-18)/10-10+9+75, CGRectGetMaxY(barView.frame)+13+10, SCREEN_WIDTH-80-(SCREEN_WIDTH-18)/10-9, 0.5)];
        lblLine2.backgroundColor = [UIColor colorWithHexString:@"dadadc"];
        [view addSubview:lblLine2];
        view.frame = CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetMaxY(btnPingLun.frame)+10) ;
    }
    
    self.tableview.tableHeaderView = view;
    
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
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    BHPingLunCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BHPingLunCell" forIndexPath:indexPath];
//    cell.selectionStyle = UITableViewCellAccessoryNone;
//    HWGongGaoChildModel *model = self.childArr[indexPath.row];
//    [cell cellForModel:model];
//    self.indexpath = indexPath;
//    return cell;
//}
//
//
//#pragma mark-UITableViewDelegate
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    HWGongGaoChildModel *model = self.childArr[indexPath.row];
//    if (model.Hname != nil)
//    {
//        NSString *str = [NSString stringWithFormat:@"%@回复%@:%@",model.name,model.Hname,model.contents];
//        return [BHPingLunCell heightForString:str fontSize:12]+10;
//    }
//    else
//    {
//        NSString *str = [NSString stringWithFormat:@"%@:%@",model.name,model.contents];
//        return [BHPingLunCell heightForString:str fontSize:12]+10;
//    }
//    
//}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 100;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 37;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    BHPingLunModel *model = self.listArr[section];
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor whiteColor];
    UIImageView *headImage = [[UIImageView alloc]initWithFrame:CGRectMake(12, 6, 40, 40)];
    headImage.layer.cornerRadius = 20;
    headImage.layer.masksToBounds = YES;
    [view addSubview:headImage];
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(62, 6, SCREEN_WIDTH-62, 20)];
    nameLabel.textColor = [UIColor colorWithHexString:@"676767"];
    nameLabel.font = [UIFont systemFontOfSize:12];
    [view addSubview:nameLabel];
    
    UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(62, CGRectGetMaxY(nameLabel.frame)+3, SCREEN_WIDTH-62, 15)];
    timeLabel.textColor = [UIColor colorWithHexString:@"c8c8c8"];
    timeLabel.font = [UIFont systemFontOfSize:10];
    [view addSubview:timeLabel];
    
    CGFloat height = [model.contents boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-62, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size.height;
    UILabel *bodyLabel = [[UILabel alloc]initWithFrame:CGRectMake(62, CGRectGetMaxY(timeLabel.frame)+5, SCREEN_WIDTH-62, height)];
    bodyLabel.numberOfLines = 0;
    bodyLabel.textColor = [UIColor colorWithHexString:@"676767"];
    bodyLabel.font = [UIFont systemFontOfSize:13];
    [view addSubview:bodyLabel];
    
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetMaxY(bodyLabel.frame)+5);
    [headImage sd_setImageWithURL:[NSURL URLWithString:model.iconpath] placeholderImage:[UIImage imageNamed:@"自己页面头像"]];
    nameLabel.text = model.name;
    timeLabel.text = model.addtime;
    bodyLabel.text = model.contents;
    
    return view;
}

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    HWGongGaoToolBar *bar = [[HWGongGaoToolBar alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)];
//    bar.backgroundColor = [UIColor whiteColor];
//    bar.model = self.listArr[section];
//    bar.section = section;
//    
//    return bar;
//    
//}

//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//    HWGongGaoChildModel *model = self.childArr[indexPath.row];
//    [self.keyboard.textView becomeFirstResponder];
//    NSString *str = [NSString stringWithFormat:@"回复:%@",model.name];
//    self.keyboard.textView.placeholder = str;
//    self.keyboard.indexpath = indexPath;
//}





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
