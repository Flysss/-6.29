//
//  CustomBtn.m
//  SalesHelper_A
//
//  Created by zhipu on 16/2/24.
//  Copyright © 2016年 X. All rights reserved.
//

#import "CustomBtn.h"

@implementation CustomBtn
-(CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(contentRect.size.width*5/6, contentRect.size.height/4, contentRect.size.width/6, contentRect.size.height/2);
}
-(CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(0, 0, contentRect.size.width*5/6, contentRect.size.height);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
