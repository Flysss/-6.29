//
//  HWGongGaoFrame.m
//  SalesHelper_A
//
//  Created by 胡伟 on 16/3/8.
//  Copyright © 2016年 X. All rights reserved.
//

#import "HWGongGaoFrame.h"

@implementation HWGongGaoFrame
- (void)setModel:(HWGongGaoModel *)model
{
    _model = model;
    
    [self setupDetialFrame];
    
    [self setupToolBarFrame];
    
    self.cellHeight = CGRectGetMaxY(self.toolBarFrame);
    
    
}

- (void)setupDetialFrame
{
    HWGongGaoDetailFrame *detailFrame = [[HWGongGaoDetailFrame alloc] init];
    
    detailFrame.model = self.model;
    
    self.detailFrame = detailFrame;
    
    
    
}
- (void)setupToolBarFrame
{
    CGFloat X = 0;
    CGFloat Y = CGRectGetMaxY(self.detailFrame.frame);
    CGFloat W = [UIScreen mainScreen].bounds.size.width;
    CGFloat H = 30;
    self.toolBarFrame = CGRectMake(X, Y, W, H);

}


@end
