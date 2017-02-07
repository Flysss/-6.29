//
//  BHPingLunCell.h
//  SalesHelper_A
//
//  Created by 曾杰 on 16/3/10.
//  Copyright © 2016年 X. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HWGongGaoChildModel.h"

@class BHPingLunCell;

@protocol BHPingLunCellDelegate <NSObject>

- (void)removeHuiFu:(BHPingLunCell *)cell;

@end

@interface BHPingLunCell : UITableViewCell
@property (nonatomic, strong) UILabel *bodyLabel;
@property (nonatomic, strong) UIView *viewBac;
@property (nonatomic, strong) UIImageView *imgBac;

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, weak)id<BHPingLunCellDelegate>delegate;

@property (nonatomic, strong) NSIndexPath *indexpath;
@property (nonatomic, strong) NSString *loginuid;
@property (nonatomic, strong) HWGongGaoChildModel *hwmodel;

- (void)cellForModel:(HWGongGaoChildModel *)model;
+ (CGFloat)heightForString:(NSString *)str fontSize:(NSInteger)fontSize;

@end
