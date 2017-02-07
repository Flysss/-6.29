//
//  popTableView.m
//  SalesHelper_A
//
//  Created by summer on 15/7/15.
//  Copyright (c) 2015年 X. All rights reserved.
//

#import "popTableView.h"

@implementation popTableView
{
    void(^cellSelectedBlock)(NSDictionary * dic);
}
- (instancetype)init{
    self = [super init];
    if(self){
        [self Init_0314];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self Init_0314];
    }
    return self;
}

//初始化相关参数
- (void)Init_0314{
    self.dataSource = self;
    self.delegate = self;
    self.bounces = NO;
    
    //隐藏滚动条
    self.showsHorizontalScrollIndicator = YES;
    self.showsVerticalScrollIndicator = NO;
    
    //透明背景
    self.backgroundColor = [UIColor clearColor];
    
    //圆角
    self.layer.cornerRadius = 6;
    
//    self.
    //禁用分隔线
//    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //注册Cell
//    [self registerNib:[UINib nibWithNibName:@"TableViewCell_HUD" bundle:nil] forCellReuseIdentifier:@"TableViewCell_HUD"];
    [self registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ListTableView"];
}

//Cell选中回调
- (void)CellSelected:(void(^)(NSDictionary * dic))newBlock{
    
    self->cellSelectedBlock = newBlock;
}

-(NSInteger)numberOfRowsInSection:(NSInteger)section{
    return self.DataSource_0314 == nil ? 0 : 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.DataSource_0314.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier_TableViewCell = @"ListTableView";
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier_TableViewCell forIndexPath:indexPath];
    
    NSDictionary * dic = [self.DataSource_0314 objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [dic objectForKey:@"name"];
    cell.textLabel.font = Default_Font_14;
    cell.textLabel.textColor = [UIColor colorWithWhite:0.463 alpha:1.000];
    if (self.alignment == popTableViewCellAlignmentLCenter) {
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if(self->cellSelectedBlock){
        NSDictionary * dic = [self.DataSource_0314 objectAtIndex:indexPath.row];
        self->cellSelectedBlock(dic);
    }
}

@end
