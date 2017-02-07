//
//  HWMessageViewController.m
//  SalesHelper_A
//
//  Created by 胡伟 on 16/3/18.
//  Copyright © 2016年 X. All rights reserved.
//

#import "HWMessageViewController.h"
#import "HWMessageCell.h"
#import "MJExtension.h"

#import "HWMessageModel.h"
#import "BHNewPersonViewController.h"
#import "BHPostDetailViewController.h"


@interface HWMessageViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSMutableArray *messages;
@property (nonatomic, strong)UIImageView *imgBac;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation HWMessageViewController


- (NSMutableArray *)messages
{
    if (!_messages) {
        
        _messages = [NSMutableArray array];
    }
    return _messages;
    
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.navigationBar.translucent = NO;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createTableView];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.page = 1;

    
    [self customTopView];
    
    [self.view Loading_0314];
    
    [self requestFirstListData:NO];
    
    [self refresh];
    
    self.imgBac = [[UIImageView alloc]init];
    self.imgBac.hidden = YES;
    self.imgBac.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    self.imgBac.image = [UIImage imageNamed:@"暂无内容默认图片"];
    self.imgBac.contentMode = UIViewContentModeCenter;
    [self.tableView addSubview:self.imgBac];
}
- (void)createTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, SCREEN_HEIGHT-44) style:(UITableViewStylePlain)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}
#pragma mark -自定义导航栏
- (void)customTopView
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    view.backgroundColor = [UIColor hexChangeFloat:@"00aff0"];
    [self.view addSubview:view];
    
    UIButton *btnBack = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btnBack.frame = CGRectMake(10, 20, 30, 44);
    [btnBack addTarget:self action:@selector(backClick) forControlEvents:(UIControlEventTouchUpInside)];
    [btnBack setImage:[UIImage imageNamed:@"bc-1"] forState:(UIControlStateNormal)];
    [btnBack setImage:[UIImage imageByApplyingAlpha:[UIImage imageNamed:@"bc-1"]] forState:(UIControlStateHighlighted)];
    [view addSubview:btnBack];
    
    UILabel *lblName = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 44)];
    lblName.textColor = [UIColor whiteColor];
    lblName.font = [UIFont systemFontOfSize:18];
    lblName.textAlignment = NSTextAlignmentCenter;
    lblName.tag = 505;
    lblName.text = @"消息";
    [view addSubview:lblName];
}

- (void)requestFirstListData:(BOOL)isDelet
{
    
    
    

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *loginuid = [userDefaults objectForKey:@"id"];
    

    RequestInterface *interface = [[RequestInterface alloc]init];
    NSDictionary *dic = @{
            
                          @"loginuid" :loginuid,
                          @"p": @(_page)
                          
                          };
    [interface requestMessageWithDict:dic];
    [interface getInterfaceRequestObject:^(id data)
     {
         NSLog(@"%@",data);
         
         if ([data[@"success"] boolValue] == YES)
         {
             if ([data[@"datas"] count] != 0)
             {
                 if (isDelet == YES)
                 {
                     [self.messages removeAllObjects];
                 }
                 for (NSDictionary *dict in data[@"datas"])
                 {

                     HWMessageModel *model = [HWMessageModel objectWithKeyValues:dict];
                     [self.messages addObject:model];
                     [self.tableView reloadData];
                     NSLog(@"%@",model.contents);
                 }
             }
             
             self.tableView.separatorStyle = UITableViewCellSelectionStyleDefault;
             [self.view Hidden];
         }
     } Fail:^(NSError *error)
     {
         self.imgBac.hidden = NO;
         [self.view Hidden];

     }];
}
#pragma mark - 刷新
- (void)refresh
{
    __block HWMessageViewController *test = self;
   
    [self.tableView addFooterWithCallback:^{
        test.page ++;
        [test requestFirstListData:NO];
        
        [test.tableView footerEndRefreshing];
        
    }];
    
    [self.tableView addHeaderWithCallback:^{
        test.page = 1;
        [test requestFirstListData:YES];
        [test.tableView headerEndRefreshing];
        
    }];
    
}

#pragma mark - Table view data sourc

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    HWMessageModel *model = self.messages[indexPath.row];
    
    if ([model.istype isEqualToString:@"3"]) {
        return [self heightForRowWithModel:model] + 120;
        
    }else{
        return 140;
    }
    
    
}

- (CGFloat)heightForRowWithModel:(HWMessageModel *)model
{
    
    CGSize maxSize = CGSizeMake(200, MAXFLOAT);
    
    CGSize textSize = [model.contents boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:19]} context:nil].size;
    
    return textSize.height;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
    return self.messages.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    HWMessageCell *cell = [HWMessageCell messageCellWithTableView:tableView];    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    cell.model = self.messages[indexPath.row];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HWMessageModel *model = self.messages[indexPath.row];
    if ([model.istype isEqualToString:@"2"])
    {
        BHNewPersonViewController *personVC = [[BHNewPersonViewController alloc]init];
        personVC.uid = model.uid;
        NSLog(@"%@",model.uid);
        [self.navigationController pushViewController:personVC animated:YES];
    }
    else
    {
        BHPostDetailViewController *detailVC = [[BHPostDetailViewController alloc]init];
        NSLog(@"%@",model.ID);
        detailVC.tieZiID = model.eventid;
        detailVC.isMessageVC = YES;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    
    if (IOS_VERSION >= 8.0)
    {
        if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)])
        {
            [cell setPreservesSuperviewLayoutMargins:NO];
        }
        if ([cell respondsToSelector:@selector(setLayoutMargins:)])
        {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
    }
}
- (void)backClick
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


@end
