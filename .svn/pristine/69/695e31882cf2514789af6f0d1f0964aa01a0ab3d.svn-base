//
//  HWGongGaoCell.m
//  SalesHelper_A
//
//  Created by 胡伟 on 16/3/9.
//  Copyright © 2016年 X. All rights reserved.
//

#import "HWGongGaoCell.h"
#import "HWGongGaoDetailView.h"
#import "HWGongGaoToolBar.h"
#import "HWGongGaoFrame.h"

@interface HWGongGaoCell ()
@property (nonatomic,weak) HWGongGaoDetailView *detailView;
@property (nonatomic,weak) HWGongGaoToolBar *toolBar;
@end
@implementation HWGongGaoCell

+ (instancetype)gongGaoCellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"cell";
    
    HWGongGaoCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        
        cell = [[HWGongGaoCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        
    }
    
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
   if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    
    
    HWGongGaoDetailView *detailView = [HWGongGaoDetailView new];
    [self.contentView addSubview:detailView];
    self.detailView = detailView;
    
    
    HWGongGaoToolBar *toolBar = [HWGongGaoToolBar new];
    [self.contentView addSubview:toolBar];
    self.toolBar = toolBar;

 }

   return self;
    
}

- (void)setGongGaoFrame:(HWGongGaoFrame *)gongGaoFrame
{
    
    _gongGaoFrame = gongGaoFrame;
    
    
    self.detailView.detailFrame = gongGaoFrame.detailFrame;
    
    self.toolBar.frame = gongGaoFrame.toolBarFrame;
    self.toolBar.model = gongGaoFrame.model;
    
    
}



@end
