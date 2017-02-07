//
//  HWGongGaoDetailFrame.m
//  SalesHelper_A
//
//  Created by 胡伟 on 16/3/8.
//  Copyright © 2016年 X. All rights reserved.
//

#import "HWGongGaoDetailFrame.h"

@implementation HWGongGaoDetailFrame

- (void)setModel:(HWGongGaoModel *)model
{
    _model = model;
    
    HWGongGaoOriginalFrame *originalFrame = [[HWGongGaoOriginalFrame alloc] init];

    originalFrame.model = model;
    
    self.originalFrame = originalFrame;
    
    
    CGFloat H = 0;
    if (model.child.count) {
        
        HWGongGaoChildFrame *childFrame = [[HWGongGaoChildFrame alloc] init];
        childFrame.child = model.child;
        
        CGRect f = childFrame.frame;
        f.origin.y = CGRectGetMaxY(originalFrame.frame) + 10;
        childFrame.frame = f;
        
        self.childFrame = childFrame;
        
        H = CGRectGetMaxY(childFrame.frame);
        
    
    }else{
    
         H = CGRectGetMaxY(originalFrame.frame);
        
    }
    

    self.frame = CGRectMake(0, 10, SCREEN_WIDTH, H);
    

}

@end
