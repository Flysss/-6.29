//
//  ListChoosenView.m
//  SalesHelper_A
//
//  Created by summer on 15/7/13.
//  Copyright (c) 2015年 X. All rights reserved.
//

#import "ListChoosenView.h"
//#import "LeftImageBtn.h"
#import <objc/runtime.h>

@implementation ListChoosenView
{
    BOOL showList;//是否弹出下拉列表
    CGFloat tabheight;//table下拉列表的高度
    CGFloat frameHeight;//frame的高度
    NSUInteger index;//点击的button index
    NSMutableArray * contentArr;
    NSMutableDictionary * sendDic;
}

-(instancetype)initWithItemArr:(NSDictionary *)itemDic titleArr:(NSArray *)titleArr picImageStr:(NSString *)picImageStr frame:(CGRect)aFrame
{
    if (self = [super init]) {
        self.tableDIc = itemDic;
        self.frame = aFrame;
        self.titleArray = titleArr;
        self.icon = picImageStr;
        sendDic = [NSMutableDictionary dictionaryWithCapacity:0];
        [self loadItemsWithFrame:aFrame];
        [self loadBtnWithTitle:(NSArray *)titleArr picArr:(NSString *)picImageStr];
    }
    return self;
}
- (void)loadItemsWithFrame:(CGRect)aFrame;
{
    showList = NO; //默认不显示下拉框
    self.tv = [[UITableView alloc] initWithFrame:CGRectMake(0, aFrame.size.height, aFrame.size.width, 0)];
    self.tv.delegate = self;
    self.tv.dataSource = self;
    self.tv.hidden = YES;
    self.tv.rowHeight = 44;
    [self addSubview:self.tv];
}
- (void)loadBtnWithTitle:(NSArray *)titleArr picArr:(NSString *)picImageStr
{
//    for (int i = 0; i < titleArr.count; i++) {
//        LeftImageBtn * btn =  [[LeftImageBtn alloc]initWithFrame:CGRectMake(0, i * (self.frame.size.width/titleArr.count) + (self.frame.size.width/titleArr.count), self.frame.size.width/titleArr.count, self.frame.size.height)];
//        CGFloat maggin = self.frame.size.height / 5;
//        if (i != (titleArr.count -1 )) {
//            UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(btn.frame.size.width + btn.frame.origin.x,maggin, 1 , self.frame.size.height - 2 * maggin)];
//            [self addSubview:lineView];
//        }
//        btn.tag = i + 1000;
//        [btn addTarget:self action:@selector(showTableList:) forControlEvents:UIControlEventTouchUpInside];
//        [btn setTitle:[titleArr objectAtIndex:i] forState:UIControlStateNormal];
//        [btn setImage:[UIImage imageNamed:picImageStr] forState:UIControlStateNormal];
//        [self addSubview:btn];
//    }
    
}
#pragma mark - 按钮点击时间
- (void)showTableList:(UIButton *)button
{
    index = button.tag - 1000;
    if (index == 0) {
        NSMutableArray * arr = [self.tableDIc objectForKey:@"districts"];
        for (int i = 0; arr.count; i ++) {
            NSDictionary * districtsDic = arr[i];
            [contentArr addObject:[districtsDic objectForKey:@"name"]];
        }
    }
//    contentArr =  [NSMutableArray arrayWithArray:self.tableArray[index]];
    self.tv.hidden = NO;
}
#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return contentArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * str = @"reuseIdentifier";
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:str];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str forIndexPath:indexPath];
    cell.textLabel.text = contentArr[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIButton * button = (UIButton *)[self viewWithTag:1000+index];
    NSString * typeStr = button.titleLabel.text;
    if ([typeStr isEqualToString:@"区域"]) {
        typeStr = @"districtId";
    }else if ([typeStr isEqualToString:@"类型"]) {
        typeStr = @"stateId";
    }else if ([typeStr isEqualToString:@"价格"]) {
        typeStr = @"stateId";
    }
    [button setTitle:[contentArr objectAtIndex:indexPath.row] forState:UIControlStateNormal];
    if (typeStr.length > 2) {
        [sendDic setObject:[contentArr objectAtIndex:indexPath.row] forKey:typeStr];
    }else{
        [sendDic setObject:[contentArr objectAtIndex:indexPath.row] forKey:@"priceId"];
    }
    [self.delegate sendRequstWithParams:sendDic];
}
@end
