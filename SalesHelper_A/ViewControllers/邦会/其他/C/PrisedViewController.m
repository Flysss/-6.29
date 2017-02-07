//
//  PrisedViewController.m
//  SalesHelper_A
//
//  Created by Brant on 16/2/18.
//  Copyright © 2016年 X. All rights reserved.
//

#import "PrisedViewController.h"
#import "PrisedTableViewCell.h"
#import "BHPersonMyFansModel.h"
#import "BHNewPersonViewController.h"
#import "UIColor+HexColor.h"

@interface PrisedViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *m_tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, assign) NSInteger pageNum;
@property (nonatomic, strong) NSString *loginuid;

@property (nonatomic, strong)UILabel * titleLabel;


@end

@implementation PrisedViewController

-(NSMutableArray *)dataArr
{
    if (_dataArr == nil) {
        self.dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.navigationBar.translucent = NO;
//  [self.navigationController.navigationBar setBackgroundImage:[self imageWithBgColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0]] forBarMetrics:UIBarMetricsDefault];
//    
//  [self.navigationController.navigationBar setShadowImage:[self imageWithBgColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0]]];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *longinuid =  [defaults objectForKey:@"id"];
    self.loginuid = [NSString stringWithFormat:@"%@",longinuid];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.pageNum = 1;
    
    [self creatNaiviControl];
    
    [self creatTableView];
    
    [self requestDataWithHead:YES];

    
}

//创建导航栏
- (void)creatNaiviControl
{
    [self CreateCustomNavigtionBarWith:self leftItem:@selector(backToView) rightItem:nil];
    [self.backBtn setImage:[UIImage imageNamed:@"bc-1"] forState:(UIControlStateNormal)];
    self.rightBtn.hidden = YES;
    //创建标题
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = Default_Font_18;
    self.titleLabel.text = [NSString stringWithFormat:@"%lu人赞过",(unsigned long)self.dataArr.count];
    [self.titleLabel setTextColor:[UIColor whiteColor]];
    self.titleLabel.frame = CGRectMake(0, 20, SCREEN_WIDTH, 44);
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.topView addSubview:self.titleLabel];
    

}

- (void)backToView
{
    [self.navigationController popViewControllerAnimated:YES];
}

//创建列表
- (void)creatTableView
{
    self.m_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStyleGrouped];
    self.m_tableView.delegate = self;
    self.m_tableView.dataSource = self;
    self.m_tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.m_tableView];
    
    [self creatTableViewRefresh];
}

- (void)creatTableViewRefresh
{
    __block PrisedViewController *h = self;
    
    [self.m_tableView addHeaderWithCallback:^{
        h.pageNum = 1;
        [h requestDataWithHeader];
        [h.m_tableView headerEndRefreshing];
    }];
    
    [self.m_tableView addFooterWithCallback:^{
        h.pageNum++;
        [h requestDataWithHead:NO];
        [h.m_tableView footerEndRefreshing];
    }];
}



- (void)requestDataWithHeader
{
    
    NSDictionary *dic = @{
                          @"postid":_postID,
                          @"loginuid":self.loginuid,
                          @"p":@(_pageNum),
                          };
    RequestInterface *interFace = [[RequestInterface alloc] init];
    [self.view Loading_0314];
    [interFace requestLikeListWithDic:dic];
    [interFace getInterfaceRequestObject:^(id data)
     {
         if ([data[@"success"] boolValue] == YES)
         {
             [self.dataArr removeAllObjects];
             
             if ([data[@"datas"] count] != 0)
             {
                 for (NSDictionary *dict in data[@"datas"]) {
                     BHPersonMyFansModel *model = [[BHPersonMyFansModel alloc]init];
                     [model setValuesForKeysWithDictionary:dict];
                     
                     [self.dataArr addObject:model];
                 }
                 self.titleLabel.text = [NSString stringWithFormat:@"%lu人赞过",(unsigned long)self.dataArr.count];
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


//请求数据
- (void)requestDataWithHead:(BOOL)head
{
    NSDictionary *dic = @{
                          @"postid":_postID,
                          @"loginuid":self.loginuid,
                          @"p":@(_pageNum),
                          };
    RequestInterface *interFace = [[RequestInterface alloc] init];
    [self.view Loading_0314];
    [interFace requestLikeListWithDic:dic];
    [interFace getInterfaceRequestObject:^(id data)
     {
         
         HWLog(@"%@",data);
         
         if ([data[@"success"] boolValue] == YES)
         {
             if ([data[@"datas"] count] != 0)
             {
                 for (NSDictionary *dict in data[@"datas"]) {
                     BHPersonMyFansModel *model = [[BHPersonMyFansModel alloc]init];
                     [model setValuesForKeysWithDictionary:dict];
                     
                     [self.dataArr addObject:model];
                 }
                 self.titleLabel.text = [NSString stringWithFormat:@"%lu人赞过",(unsigned long)self.dataArr.count];
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
