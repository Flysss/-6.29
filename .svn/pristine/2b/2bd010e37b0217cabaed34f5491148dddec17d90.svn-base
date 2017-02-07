//
//  BHMyFansViewController.m
//  SalesHelper_A
//
//  Created by zhipu on 16/3/30.
//  Copyright © 2016年 X. All rights reserved.
//

#import "BHMyFansViewController.h"
#import "BHPersonMyFansModel.h"
#import "PrisedTableViewCell.h"
#import "UIColor+HexColor.h"
#import "BHNewPersonViewController.h"

@interface BHMyFansViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) UITableView *m_tableView;
@property (nonatomic, strong) NSString *loginuid;
@property (nonatomic, assign) NSInteger pageNum;
@property (nonatomic, strong) UIView *topView;

@end

@implementation BHMyFansViewController
-(NSMutableArray *)dataArr
{
    if (_dataArr == nil) {
        self.dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
//请求数据
- (void)requestDataWithHead:(BOOL)head
{
    NSDictionary *dic = @{
                          @"uid":_uid,
                          @"loginuid":self.loginuid,
                          @"p":@(_pageNum),
                          };
    RequestInterface *interFace = [[RequestInterface alloc] init];
    [self.view Loading_0314];
    [interFace requestBHMyFansWithDic:dic];
    [interFace getInterfaceRequestObject:^(id data)
     {
         
         HWLog(@"%@",data);
         
         if ([data[@"success"] boolValue] == YES)
         {
             if ([data[@"datas"] count] != 0)
             {
                 
                 if (head)
                 {
                     [self.dataArr removeAllObjects];
                 }
                 for (NSDictionary *dict in data[@"datas"]) {
                     BHPersonMyFansModel *model = [[BHPersonMyFansModel alloc]init];
                     [model setValuesForKeysWithDictionary:dict];
                     
                     [self.dataArr addObject:model];
                 }
                 //                 self.titleLabel.text = [NSString stringWithFormat:@"%lu人赞过",(unsigned long)self.dataArr.count];
                 //                 [self.titleLabel sizeToFit];
                 [self.m_tableView reloadData];
                 [self.view Hidden];
             }
             else
             {
                 [self.view Hidden];
                 [self.view makeToast:@"没有更多数据了"];
             }
         }
         else
         {
             [self.view Hidden];
             [self.view makeToast:@"没有更多数据了"];
         }
     } Fail:^(NSError *error)
     {
         
     }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *longinuid =  [defaults objectForKey:@"id"];
    self.loginuid = [NSString stringWithFormat:@"%@",longinuid];
    _pageNum = 1;
    [self requestDataWithHead:NO];
    [self customTopView];
    [self creatTableView];
    [self creatTableViewRefresh];
}

//创建列表
- (void)creatTableView
{
    self.m_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStyleGrouped];
    self.m_tableView.delegate = self;
    self.m_tableView.dataSource = self;
    self.m_tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.m_tableView];
    
 
}

#pragma mark -自定义导航栏
- (void)customTopView
{
    self.topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    UIButton *btnBack = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [btnBack setImage:[UIImage imageNamed:@"bc-1"] forState:(UIControlStateNormal)];
    [btnBack addTarget:self action:@selector(returnPage) forControlEvents:(UIControlEventTouchUpInside)];
    btnBack.frame = CGRectMake(11, 20, 30, 44);
    
    [self.topView addSubview:btnBack];
    
    UILabel *lblName = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 44)];
    lblName.textColor = [UIColor colorWithHexString:@"ffffff"];
    lblName.font = [UIFont systemFontOfSize:20];
    lblName.textAlignment = NSTextAlignmentCenter;
    lblName.tag = 505;
    lblName.text = @"我的邦粉";
    [self.topView addSubview:lblName];
    self.topView.backgroundColor = [UIColor colorWithHexString:@"00aff0"];
    
    //    UIButton *btnMore = [UIButton buttonWithType:(UIButtonTypeCustom)];
    //    btnMore.frame = CGRectMake(SCREEN_WIDTH-11-30, 20, 30, 44);
    //    [btnMore setImage:[UIImage imageNamed:@"gd-1"] forState:(UIControlStateNormal)];
    //    [btnMore addTarget:self action:@selector(moreChoore) forControlEvents:(UIControlEventTouchUpInside)];
    //    [self.topView addSubview:btnMore];
        [self.view addSubview:self.topView];
}
- (void)returnPage
{
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)creatTableViewRefresh
{
    __block BHMyFansViewController *h = self;
    
    [self.m_tableView addHeaderWithCallback:^{
        h.pageNum = 1;
        [h requestDataWithHead:YES];
        [h.m_tableView headerEndRefreshing];
    }];
    
    [self.m_tableView addFooterWithCallback:^{
        h.pageNum++;
        [h requestDataWithHead:NO];
        [h.m_tableView footerEndRefreshing];
    }];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *ID = @"cell";
    PrisedTableViewCell *cell = (PrisedTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[PrisedTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.loginuid = self.loginuid;
    [cell configTableViewCellWithModel:self.dataArr[indexPath.row]];
    
    cell.prisedBtn.tag = indexPath.row;
    [cell.prisedBtn addTarget:self action:@selector(guanzhuClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (void)guanzhuClick:(UIButton *)sender
{
    [self setGuanZhu:sender];
    [self zanAnimation:sender];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
//    self.m_tableView.footerHidden = self.dataArr.count <= 10;
    
    return self.dataArr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        BHNewPersonViewController *vc = [[BHNewPersonViewController alloc] init];
    
    
        vc.uid = [self.dataArr[indexPath.row] uid];
    
    
    
        [self.navigationController pushViewController:vc animated:YES];
}



#pragma mark - 网络请求-关注接口
- (void)setGuanZhu:(UIButton *)btn
{
    BHPersonMyFansModel *model = self.dataArr[btn.tag];
    
    btn.selected  = !btn.selected;
    if ([GetOrgType isEqualToString:@"2"])
    {
        if (btn.selected == YES)
        {
            [btn setTitle:@"  已关注" forState:(UIControlStateNormal)];
            [btn setImage:[UIImage imageNamed:@""] forState:(UIControlStateNormal)];
            model.isfocus = @"33";
        }
        else
        {
            
            [btn setTitle:@"  关注" forState:(UIControlStateNormal)];
            [btn setImage:[UIImage imageNamed:@"plus_335px_1187514_easyicon.net"] forState:(UIControlStateNormal)];
            model.isfocus = nil;
        }
        
        
        RequestInterface *interface = [[RequestInterface alloc]init];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

@end
