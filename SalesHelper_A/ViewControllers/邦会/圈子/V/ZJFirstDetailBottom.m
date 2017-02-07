//
//  ZJFirstDetailBottom.m
//  SalesHelper_A
//
//  Created by zhipu on 16/3/26.
//  Copyright © 2016年 X. All rights reserved.
//

#import "ZJFirstDetailBottom.h"
#import "UIColor+HexColor.h"
#import "BHPingLunModel.h"


@implementation ZJFirstDetailBottom
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.btnZan = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [self.btnZan addTarget:self action:@selector(zanAction) forControlEvents:(UIControlEventTouchUpInside)];
        [self.btnZan setImage:[UIImage imageNamed:@"点赞"] forState:(UIControlStateNormal)];
        self.btnZan.titleLabel.font = [UIFont systemFontOfSize:13];
        self.btnZan.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        [self.btnZan setTitleColor:[UIColor colorWithHexString:@"c8c8c8"] forState:(UIControlStateNormal)];
        [self addSubview:self.btnZan];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.btnZan.height = self.height;
    self.btnZan.width = 70;
    self.btnZan.x = self.width - self.btnZan.width;
    self.btnZan.y = 0;
    
}

-(void)setModel:(BHPingLunModel *)model
{
    _model = model;
    if (model.is_praise != nil)
    {
        [self btnstate:model.dz_num];
        [self.btnZan setImage:[UIImage imageNamed:@"点赞之后"] forState:(UIControlStateNormal)];
        self.btnZan.selected = YES;
    }
    else
    {
        [self btnstate:model.dz_num];
        [self.btnZan setImage:[UIImage imageNamed:@"点赞"] forState:(UIControlStateNormal)];
        self.btnZan.selected = NO;
    }
   
}

- (void)btnstate:(NSInteger)count
{
    if (count > 10000)
    {
        [self.btnZan setTitle:[NSString stringWithFormat:@"%.1f万",(long)count/10000.0] forState:(UIControlStateNormal)];
    }
    else if (count == 0)
    {
        [self.btnZan setTitle:@"赞" forState:(UIControlStateNormal)];
    }
    else
    {
        [self.btnZan setTitle:[NSString stringWithFormat:@"%ld",(long)count] forState:(UIControlStateNormal)];
    }
    
}

- (void)zanAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(clickBottomBtnZanAction:)])
    {
        [_delegate clickBottomBtnZanAction:self];
    }
}

@end
