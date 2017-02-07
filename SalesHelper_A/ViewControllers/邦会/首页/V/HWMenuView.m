//
//  HWMenuView.m
//  SalesHelper_A
//
//  Created by 胡伟 on 16/3/18.
//  Copyright © 2016年 X. All rights reserved.
//

#import "HWMenuView.h"
//#import "BHLeftRootCell.h"
#import "HWQuanZiCell.h"
#import "BHLeftModel.h"
#import "UIColor+HexColor.h"

@interface HWMenuView ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end
@implementation HWMenuView


+ (instancetype)menuView
{
    
    return  [[[NSBundle mainBundle] loadNibNamed:@"HWMenuView" owner:nil options:nil] lastObject];
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        

        

    }
    
    return self;
}

- (void)awakeFromNib
{


    
    
}

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    
//    return 10;
//    
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *ID = @"cell";
//    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
//    
//    if (cell == nil) {
//        
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
//        
//    }
//    cell.textLabel.text = [NSString stringWithFormat:@"测试数据----%ld",indexPath.row];
//    
//    return cell;
//    
//}

#pragma mark - UITableViewDataSource

- (void)tableViewReloadData
{
    [self.tableView reloadData];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  1;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if (section == 0) {
//        return 1;
//    }else{

        return self.dataArr.count;
        
//    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    HWQuanZiCell *cell = [HWQuanZiCell quanZiCellWithTableView:tableView];
    cell.backgroundColor = [UIColor clearColor];
    cell.model = self.dataArr[indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row == self.dataArr.count - 1) {
        
        cell.bottomLine.hidden = YES;
        
        
        
    }else{
        
        cell.bottomLine.hidden = NO;
    }
    
    
        return cell;
    
    
    
    
}
#pragma mark-分区视图
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 45+75)];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(66, 75, SCREEN_WIDTH-7, 29)];
    label.textColor = [UIColor colorWithHexString:@"ffffff"];
    label.text = @"逛圈子";
    label.font = [UIFont systemFontOfSize:20];
    [view addSubview:label];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"逛圈子"];
    
    imageView.y = label.y + 6;
    imageView.width = 20;
    imageView.height = 20;
    imageView.x = 30;
    
    [view addSubview:imageView];
    
    return view;
}
#pragma mark-UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BHLeftModel *model = self.dataArr[indexPath.row];
    NSDictionary *dic = @{@"leftModel":model};
    NSNotification *noti = [NSNotification notificationWithName:@"pushToPage" object:nil userInfo:dic];
    [[NSNotificationCenter defaultCenter]postNotification:noti];
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45+75;
}
@end
