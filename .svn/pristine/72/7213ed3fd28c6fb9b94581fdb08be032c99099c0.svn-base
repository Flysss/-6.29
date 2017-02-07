//
//  TableView_HUD.m
//  SalesHelperC
//
//  Created by summer on 15/4/21.
//  Copyright (c) 2015年 X. All rights reserved.
//

#import "TableView_HUD.h"
#import "TableViewCell_HUD.h"

@implementation TableView_HUD{
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
    
//隐藏滚动条
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    
//透明背景
    self.backgroundColor = [UIColor clearColor];
    
//圆角
    self.layer.cornerRadius = 6;

//禁用分隔线
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    
//注册Cell
    [self registerNib:[UINib nibWithNibName:@"TableViewCell_HUD" bundle:nil] forCellReuseIdentifier:@"TableViewCell_HUD"];
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
    static NSString * identifier_TableViewCell = @"TableViewCell_HUD";
    
    TableViewCell_HUD * cell = [tableView dequeueReusableCellWithIdentifier:identifier_TableViewCell forIndexPath:indexPath];
    
    NSDictionary * dic = [self.DataSource_0314 objectAtIndex:indexPath.row];
    
    cell.DataSource_0314 = dic;
//    cell.separatorInset = UIEdgeInsetsZero;
    
//    if(indexPath.row == 3){
//        cell.HightLight_0314 = YES;
//    }
//    
//    if(indexPath.row == 2){
//        cell.Disabled_0314 = YES;
//    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TableViewCell_HUD * cell = (TableViewCell_HUD *)[tableView cellForRowAtIndexPath:indexPath];
    
    if(self->cellSelectedBlock && !cell.Disabled_0314){
        NSDictionary * dic = [self.DataSource_0314 objectAtIndex:indexPath.row];
        
        self->cellSelectedBlock(dic);
    }
}

@end
