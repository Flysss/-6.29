//
//  HWMyFocusListViewController.m
//  SalesHelper_A
//
//  Created by 胡伟 on 16/3/23.
//  Copyright © 2016年 X. All rights reserved.
//

#import "HWMyFocusListViewController.h"
#import "RequestInterface.h"
#import "PrisedViewController.h"
#import "BHPersonMyFansModel.h"
#import "MJExtension.h"
#import "PrisedTableViewCell.h"
#import "MJRefresh.h"
#import "BHNoDataView.h"
@interface HWMyFocusListViewController ()

@property (nonatomic, assign)NSInteger page;
@property (nonatomic, strong)BHNoDataView *imgBac;
@end

@implementation HWMyFocusListViewController

- (NSMutableArray *)listArray
{
    if (!_listArray) {
        _listArray = [NSMutableArray array];
    }
    
    return _listArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 1;
    self.tableView.rowHeight = 70;
    
    //创建标题
    UILabel * titleLabel = [UILabel new];
    titleLabel.text = @"关注的人";
    titleLabel.font = Default_Font_18;
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"返回" heighImage:@"返回" target:self action:@selector(cancelClick)];

    
    
    [self setupFocusListData];
    
    [self.tableView registerClass:[PrisedTableViewCell class] forCellReuseIdentifier:@"cell"];
     self.tableView.tableFooterView = [[UIView alloc]init];
    
    [self refresh];
    
    self.imgBac = [[BHNoDataView alloc]init];
    self.imgBac.hidden = YES;
    self.imgBac.frame = self.tableView.frame;
    self.imgBac.contentMode = UIViewContentModeCenter;
    [self.imgBac.btnData setTitle:@"你还没有关注过别人哟" forState:(UIControlStateNormal)];
//    self.imgBac.delegate = self;
    [self.view addSubview:self.imgBac];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[self imageWithBgColor:[UIColor colorWithRed:23/255.0f green:183/255.0f blue:242/255.0f alpha:1]] forBarMetrics:UIBarMetricsDefault];
    
}

- (void)setupFocusListData
{
    

    [self.view Loading_0314];
     RequestInterface *interface = [[RequestInterface alloc]init];

    NSDictionary *dic = @{
                          @"uid" : self.loginuid,
                          @"p":@(_page)
                          
                          };
      [interface requestBHMyFocusWithDic:dic];
      [interface getInterfaceRequestObject:^(id data) {
          
          if ([data[@"success"] boolValue] == YES)
          {
              for (NSDictionary *dict in data[@"datas"])
              {
                  
                  BHPersonMyFansModel *model = [[BHPersonMyFansModel alloc] init];
                  
                  [model setKeyValues:dict];
                  
                  [self.listArray addObject:model];

                  HWLog(@"%@",self.listArray);
                  
                  [self.tableView reloadData];
                  
                  
              }
              [self.view Hidden];
              [self.tableView footerEndRefreshing];
          }
          else
          {
              
              [self.view Hidden];
              [self.view makeToast:@"没有更多了" duration:2 position:@"center"];
              [self.tableView footerEndRefreshing];

          }


          
          
          
          
          
      } Fail:^(NSError *error) {
          [self.view Hidden];
          [self.view Message:@"请求失败" HiddenAfterDelay:3];
          [self.tableView footerEndRefreshing];

      }];
    
    
    
    
}
#pragma mark - 刷新
- (void)refresh
{
    __weak HWMyFocusListViewController *test = self;
    [self.tableView addFooterWithCallback:^{
        test.page ++;
        [test setupFocusListData];
    }];
    
    
    
    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {



    self.imgBac.hidden = self.listArray.count != 0;
    
    return self.listArray.count;
    
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    

    PrisedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    [cell configTableViewCellWithModel:self.listArray[indexPath.row]];
    
    cell.prisedBtn.tag = indexPath.row;
    [cell.prisedBtn addTarget:self action:@selector(guanzhuClick:) forControlEvents:UIControlEventTouchUpInside];

    
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    BHPersonMyFansModel *model = self.listArray[indexPath.row];

    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:HWMentionSomeOneNotie object:nil userInfo:@{HWMenionModel : model,@"array" : self.listArray}];
    
}
- (void)guanzhuClick:(UIButton *)sender
{
    [self setGuanZhu:sender];
    [self zanAnimation:sender];
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

#pragma mark - 网络请求-关注接口
- (void)setGuanZhu:(UIButton *)btn
{
    BHPersonMyFansModel *model = self.listArray[btn.tag];
    btn.selected = !btn.selected;
    if (btn.selected == YES)
    {
        [btn setImage:[UIImage imageNamed:@""] forState:(UIControlStateNormal)];
        [btn setTitle:@"已关注" forState:(UIControlStateNormal)];
        model.isfocus = @"333";
    
        [self alertView:nil message:@"关注成功"];
    }
    else
    {
    [btn setTitle:@"  关注" forState:(UIControlStateNormal)];
    [btn setImage:[UIImage imageNamed:@"plus_335px_1187514_easyicon.net"] forState:(UIControlStateNormal)];
        model.isfocus = nil;
        [self alertView:nil message:@"取消关注"];
    }
    
    
    RequestInterface *interface = [[RequestInterface alloc]init];

    NSDictionary *dic = @{
                          @"uid":model.uid,
                          @"loginuid":self.loginuid
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

}
#pragma mark  绘制图片
- (UIImage *)imageWithBgColor:(UIColor *)color {
    
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return image;
}
- (void)cancelClick
{
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
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

@end
