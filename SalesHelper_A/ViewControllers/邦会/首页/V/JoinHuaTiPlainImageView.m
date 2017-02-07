//
//  JoinHuaTiPlainImageView.m
//  SalesHelper_A
//
//  Created by 曾杰 on 16/3/10.
//  Copyright © 2016年 X. All rights reserved.
//

#import "JoinHuaTiPlainImageView.h"

@implementation JoinHuaTiPlainImageView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    
   CGContextRef ref = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(ref, 100, 20);
    CGContextAddLineToPoint(ref, 80, 20);
    
    CGContextAddLineToPoint(ref, 80, 50);
    CGContextAddLineToPoint(ref, 100, 50);
    
    
    CGContextSetLineWidth(ref, 5);
    [[UIColor blueColor] set];
//    CGContextStrokePath(ref);
    CGContextFillPath(ref);
}


@end
