//
//  BHNewMyPostViewController.m
//  SalesHelper_A
//
//  Created by zhipu on 16/3/29.
//  Copyright © 2016年 X. All rights reserved.
//

#import "BHNewMyPostViewController.h"
#import "HuifuTableViewCell.h"
#import "BHPostDetailViewController.h"

@interface BHNewMyPostViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) NSMutableArray *replyArr;
@property (nonatomic, assign) NSInteger page;

@end

@implementation BHNewMyPostViewController

-(NSMutableArray *)replyArr
{
    if (_replyArr == nil) {
        self.replyArr = [NSMutableArray array];
    }
    return _replyArr;
}
- (void)requsetReply:(BOOL)isDelet
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *longinuid =  [defaults objectForKey:@"id"];
    RequestInterface *interface = [[RequestInterface alloc]init];
    NSDictionary *dic = @{
                          @"uid":_uid,
                          @"p":@(_page),
                          @"loginuid":longinuid,
                          };
    [interface requestBHReplyWithDic:dic];
    [interface getInterfaceRequestObject:^(id data)
     {
//         NSLog(@"%@",data);
         if ([data[@"success"] boolValue] == YES)
         {
             if ([data[@"datas"] count] != 0)
             {
                 if (isDelet == YES) {
                     [self.replyArr removeAllObjects];
                 }
                 for (NSDictionary *dict in data[@"datas"])
                 {
                     BHMyReplyModel *model = [[BHMyReplyModel alloc]init];
                     [model setValuesForKeysWithDictionary:dict];
                     [self.replyArr addObject:model];
                 }
                 [self.tableview reloadData];
             }
             else
             {
                 [self.view makeToast:data[@"message"]];
             }
         }
         else
         {
             [self.view makeToast:data[@"message"]];
         }
         
     } Fail:^(NSError *error)
     {
         [self.view makeToast:@"请求失败"];
     }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _page = 1;
    
    [self requsetReply:NO];
    [self crerteTable];
    [self refresh];
}

- (void)crerteTable
{
    self.tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-(434+91)/2) style:UITableViewStylePlain];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.separatorStyle = UITableViewCellAccessoryNone;
    [self.tableview registerClass:[HuifuTableViewCell class] forCellReuseIdentifier:@"HuifuTableViewCell"];
    [self.view addSubview:self.tableview];

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.replyArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HuifuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HuifuTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    BHMyReplyModel *model = self.replyArr[indexPath.row];
    [cell configTableViewWithModel:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BHMyReplyModel *model = self.replyArr[indexPath.row];
    return [HuifuTableViewCell heightForCell:model];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BHMyReplyModel *model = self.replyArr[indexPath.row];
    [self pushToDetail:model.posts_id];
}

#pragma mark -跳转到帖子详情界面
- (void)pushToDetail:(NSString *)tid
{
    BHPostDetailViewController *detailVC = [[BHPostDetailViewController alloc]init];
    detailVC.tieZiID = tid;
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)refresh
{
    __weak BHNewMyPostViewController *test = self;
    [self.tableview addFooterWithCallback:^{
        test.page ++;
        [test requsetReply:NO];
        [test.tableview footerEndRefreshing];
    }];
    
    [self.tableview addHeaderWithCallback:^{
        test.page = 1;
        [test requsetReply:YES];
        [test.tableview headerEndRefreshing];
    }];
    
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
