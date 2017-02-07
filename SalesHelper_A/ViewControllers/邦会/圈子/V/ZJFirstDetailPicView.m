//
//  ZJFirstDetailPicView.m
//  SalesHelper_A
//
//  Created by zhipu on 16/3/24.
//  Copyright © 2016年 X. All rights reserved.
//

#import "ZJFirstDetailPicView.h"

#import "BHDetailTopModel.h"
@implementation ZJFirstDetailPicView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
               
    }
    return self;
}


-(void)setModel:(BHDetailTopModel *)model
{
    _model = model;
    CGFloat count = [_model.imgpaths count];
    CGFloat margin = 5;
    CGFloat imgBodyH = 190;
    for (int i = 0; i < count; i++)
    {
        UIImageView *img = [[UIImageView alloc]init];
        img.contentMode = UIViewContentModeScaleAspectFill;
        img.clipsToBounds = YES;
        img.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(jumpPic:)];
        img.tag = i;
        img.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];
        [img addGestureRecognizer:tap];
        [img sd_setImageWithURL:[NSURL URLWithString:_model.imgpaths[i]]];
        img.frame = CGRectMake(0, imgBodyH * i + margin, SCREEN_WIDTH,imgBodyH - margin);
        [self addSubview:img];
    }

}

- (void)jumpPic:(UITapGestureRecognizer *)tap
{
    if (_delegate && [_delegate respondsToSelector:@selector(tapImg:)]) {
        [_delegate tapImg:self];
    }
}

@end
