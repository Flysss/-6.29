//
//  ListChoosenView.h
//  SalesHelper_A
//
//  Created by summer on 15/7/13.
//  Copyright (c) 2015年 X. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ListChoosenViewDelegate <NSObject>

- (void)sendRequstWithParams:(NSDictionary *)params;

@end

@interface ListChoosenView : UIView <UITableViewDelegate,UITableViewDataSource>

-(instancetype)initWithItemArr:(NSDictionary *)itemDic titleArr:(NSArray *)titleArr picImageStr:(NSString *)picImageStr frame:(CGRect)aFrame;
/**
 *  弹出tableView
 */
@property (nonatomic,retain) UITableView *tv;
/**
 *  tableView内容字典
 */
@property (nonatomic,retain) NSDictionary *tableDIc;
/**
 *  title数组
 */
@property (nonatomic,retain)NSArray * titleArray;
/**
 *  title按钮图片
 */
@property (nonatomic,copy)NSString * icon;

@property (nonatomic,assign)id <ListChoosenViewDelegate>delegate;
@end
