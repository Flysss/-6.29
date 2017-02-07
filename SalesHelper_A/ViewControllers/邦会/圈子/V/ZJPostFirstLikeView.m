//
//  ZJPostFirstLikeView.m
//  SalesHelper_A
//
//  Created by zhipu on 16/5/16.
//  Copyright © 2016年 X. All rights reserved.
//

#import "ZJPostFirstLikeView.h"
#import "BHFirstZanModel.h"
#import "UIButton+WebCache.h"

@implementation ZJPostFirstLikeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        CGFloat width = SCREEN_WIDTH-(10+10+35)-10;
        CGFloat btnWidth = width/8-5;
        CGFloat margin = 5;
        if ([UIScreen mainScreen].bounds.size.width == 375)
        {
            btnWidth = width/8 - 8;
            margin = 8;
        }
        else if ([UIScreen mainScreen].bounds.size.width == 414)
        {
            btnWidth = width/8 - 12;
            margin = 12;
        }
        else
        {
            btnWidth = 250/8-5;
            margin = 5;
        }
        for (NSInteger i = 0; i < 7; i++)
        {
            UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
            button.frame = CGRectMake((btnWidth+margin)*i+5, 12, btnWidth, btnWidth);
            button.layer.cornerRadius = button.width/2;
            button.layer.masksToBounds = YES;
            [self addSubview:button];
        }
                self.btnZanCount = [UIButton buttonWithType:(UIButtonTypeCustom)];
                self.btnZanCount.frame = CGRectMake((btnWidth+margin)*7+5, 12, btnWidth, btnWidth);
        [self.btnZanCount setBackgroundImage:[UIImage imageNamed:@"点赞更多"] forState:(UIControlStateNormal)];
                [self.btnZanCount addTarget:self action:@selector(jumpPageLikePeople) forControlEvents:(UIControlEventTouchUpInside)];
                [self addSubview:self.btnZanCount];
    }
    return self;
}
- (void)setModel:(BHFirstListModel *)model
{
    _model = model;
    NSInteger count = self.zanCount.count;
    if (count > 7)
    {
        count = 7;
        self.btnZanCount.hidden = NO;
    }else
    {
        self.btnZanCount.hidden = YES;
    }
    for (int i = 0; i < 7; i++)
    {
        UIButton *button = self.subviews[i];
        button.hidden = YES;
    }
    
    
    for (NSInteger i = 0; i < count; i++)
    {
        UIButton *button = self.subviews[i];
        button.hidden = NO;
        BHFirstZanModel *zanModel = self.zanCount[i];
        if ( zanModel.iconpath != nil) {
            
            [button sd_setBackgroundImageWithURL:[NSURL URLWithString:zanModel.iconpath] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"默认个人图像"]];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapLikeHeadImgJumpPage:)];
            button.tag = i;
            button.userInteractionEnabled = YES;
            [button addGestureRecognizer:tap];
        }
    }
}

+ (CGFloat)heightForView:(NSArray *)zanArr
{
    CGFloat width = SCREEN_WIDTH-(10+10+35)-10;
    if (zanArr.count == 0) {
        return 0;
    }else
    {
        if ([UIScreen mainScreen].bounds.size.width == 375)
        {
            return width/8+10;
        }
        else if ([UIScreen mainScreen].bounds.size.width == 414)
        {
            return width/8+10-4.5;
        }
        else
        {
            return width/8+10;
        }

    }
}

- (void)setHmodel:(BHHuaTiModel *)Hmodel
{
    _Hmodel = Hmodel;
    NSInteger count = self.zanCount.count;
    if (count > 7)
    {
        count = 7;
        self.btnZanCount.hidden = NO;
    }else
    {
        self.btnZanCount.hidden = YES;
    }
    for (int i = 0; i < 7; i++)
    {
        UIButton *button = self.subviews[i];
        button.hidden = YES;
    }
    
    
    for (NSInteger i = 0; i < count; i++)
    {
        UIButton *button = self.subviews[i];
        button.hidden = NO;
        BHFirstZanModel *zanModel = self.zanCount[i];
        if ( zanModel.iconpath != nil) {
            
            [button sd_setBackgroundImageWithURL:[NSURL URLWithString:zanModel.iconpath] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"默认个人图像"]];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapLikeHeadImgJumpPage:)];
            button.tag = i;
            button.userInteractionEnabled = YES;
            [button addGestureRecognizer:tap];
        }
    }
}





- (void)tapLikeHeadImgJumpPage:(UITapGestureRecognizer *)tap
{
    _n = tap.view.tag;
    if (self.delegate && [self.delegate respondsToSelector:@selector(tapLikeHeadImgJumpPageAction:)]) {
        [self.delegate tapLikeHeadImgJumpPageAction:self];
    }
}
- (void)jumpPageLikePeople
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickJumpPageLikePeopleButtonAction:)]) {
        [self.delegate clickJumpPageLikePeopleButtonAction:self];
    }
}

@end
