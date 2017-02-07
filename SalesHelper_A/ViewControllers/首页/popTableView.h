//
//  popTableView.h
//  SalesHelper_A
//
//  Created by summer on 15/7/15.
//  Copyright (c) 2015年 X. All rights reserved.
//
typedef NS_ENUM(NSInteger, popTableViewCellAlignment)
{
    popTableViewCellAlignmentLeft,
    popTableViewCellAlignmentLCenter,
};

#import <UIKit/UIKit.h>

@interface popTableView : UITableView <UITableViewDataSource,UITableViewDelegate>

@property(nonatomic) NSMutableArray * DataSource_0314;

@property(nonatomic)popTableViewCellAlignment alignment;

- (void)CellSelected:(void(^)(NSDictionary * dic))newBlock;

@end
