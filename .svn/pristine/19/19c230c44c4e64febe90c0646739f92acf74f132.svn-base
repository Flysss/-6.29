//
//  HWGongGaoDetailView.m
//  SalesHelper_A
//
//  Created by 胡伟 on 16/3/8.
//  Copyright © 2016年 X. All rights reserved.
//

#import "HWGongGaoDetailView.h"
#import "HWGongGaoOriginalView.h"
#import "HWGongGaoChildView.h"
#import "HWGongGaoDetailFrame.h"

@interface HWGongGaoDetailView ()


@property (nonatomic,strong) HWGongGaoOriginalView *originalView;
@property (nonatomic,strong) HWGongGaoChildView *childView;

@end
@implementation HWGongGaoDetailView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
      //添加源评论
      HWGongGaoOriginalView *originalView = [[HWGongGaoOriginalView alloc] init];
        [self addSubview:originalView];
        self.originalView = originalView;
        
        
      //添加回复评论
        HWGongGaoChildView *childView = [[HWGongGaoChildView alloc] init];
        [self addSubview:childView];
        self.childView = childView;
        
        
        
        
    }
    
    return self;
    
    
}

- (void)setDetailFrame:(HWGongGaoDetailFrame *)detailFrame
{
    _detailFrame = detailFrame;
    
    
    self.frame = detailFrame.frame;
    self.originalView.originalFrame = detailFrame.originalFrame;
    
//    self.childView.childFrame = detailFrame.childFrame;
    
    
    
}
@end
