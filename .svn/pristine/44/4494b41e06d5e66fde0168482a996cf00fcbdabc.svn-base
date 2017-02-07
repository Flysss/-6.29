//
//  ZJPostNewBottomBar.m
//  SalesHelper_A
//
//  Created by zhipu on 16/5/16.
//  Copyright © 2016年 X. All rights reserved.
//

#import "ZJPostNewBottomBar.h"
#import "UIColor+HexColor.h"
#import "BHFirstListModel.h"
#import "BHHuaTiModel.h"

@implementation ZJPostNewBottomBar
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.btnComm = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [self.btnComm setImage:[UIImage imageNamed:@"评论"] forState:(UIControlStateNormal)];
        [self.btnComm addTarget:self action:@selector(commAction) forControlEvents:(UIControlEventTouchUpInside)];
        [self.btnComm setTitleColor:[UIColor colorWithHexString:@"a4a4a4"] forState:(UIControlStateNormal)];
        UIEdgeInsets edg = UIEdgeInsetsMake(0, 5, 0, 0);
        [self.btnComm setTitleEdgeInsets:edg];
        self.btnComm.titleLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.btnComm];
        
        self.btnShare = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [self.btnShare setImage:[UIImage imageNamed:@"分享转发"] forState:(UIControlStateNormal)];
        [self.btnShare addTarget:self action:@selector(shareAction) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:self.btnShare];
        
        self.btnZan = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [self.btnZan setImage:[UIImage imageNamed:@"点赞"] forState:(UIControlStateNormal)];
        [self.btnZan setTitleColor:[UIColor colorWithHexString:@"a4a4a4"] forState:(UIControlStateNormal)];
        UIEdgeInsets edg2 = UIEdgeInsetsMake(0, 5, 0, 0);
        [self.btnZan setTitleEdgeInsets:edg2];
        self.btnZan.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.btnZan addTarget:self action:@selector(zanAction) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:self.btnZan];
        
        self.lblTime = [[UILabel alloc]init];
        self.lblTime.font = [UIFont systemFontOfSize:10];
        self.lblTime.textColor = [UIColor colorWithHexString:@"a4a4a4"];
        [self addSubview:self.lblTime];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
   
}

- (void)setModel:(BHFirstListModel *)model
{
    _model = model;
    self.lblTime.frame = CGRectMake(0, 0, self.frame.size.width/2, 43);
    self.lblTime.text = model.addtime;
    if (model.ispraise != nil)
    {
        self.btnZan.selected = YES;
        [self.btnZan setImage:[UIImage imageNamed:@"点赞之后"] forState:(UIControlStateNormal)];
        
    }
    else
    {
        self.btnZan.selected = NO;
        [self.btnZan setImage:[UIImage imageNamed:@"点赞"] forState:(UIControlStateNormal)];
    }
    if ([model.nums isEqualToString:@"0"])
    {
        [self.btnZan setTitle:@"" forState:(UIControlStateNormal)];
    }else
    {
        [self.btnZan setTitle:model.nums forState:(UIControlStateNormal)];
    }
    if ([model.huis isEqualToString:@"0"])
    {
        [self.btnComm setTitle:@"" forState:(UIControlStateNormal)];
    }else
    {
        [self.btnComm setTitle:model.huis forState:(UIControlStateNormal)];
    }
    self.btnShare.frame = CGRectMake(self.width-10-30, 0, 30, 43);
    self.btnComm.frame = CGRectMake(CGRectGetMinX(self.btnShare.frame)-50, 0, 40, 43);
    self.btnZan.frame = CGRectMake(CGRectGetMinX(self.btnComm.frame)-50, 0, 40, 43);
}

- (void)setHmodel:(BHHuaTiModel *)Hmodel
{
    _Hmodel = Hmodel;
    self.lblTime.frame = CGRectMake(0, 0, self.frame.size.width/2, 43);

    self.lblTime.text = Hmodel.addtime;
    if (Hmodel.ispraise != nil)
    {
        self.btnZan.selected = YES;
        [self.btnZan setImage:[UIImage imageNamed:@"点赞之后"] forState:(UIControlStateNormal)];
    }
    else
    {
        self.btnZan.selected = NO;
        [self.btnZan setImage:[UIImage imageNamed:@"点赞"] forState:(UIControlStateNormal)];
    }
    if ([Hmodel.nums isEqualToString:@"0"])
    {
        [self.btnZan setTitle:@"" forState:(UIControlStateNormal)];
    }else
    {
        [self.btnZan setTitle:Hmodel.nums forState:(UIControlStateNormal)];
    }
    if ([Hmodel.huis isEqualToString:@"0"])
    {
        [self.btnComm setTitle:@"" forState:(UIControlStateNormal)];
    }else
    {
        [self.btnComm setTitle:Hmodel.huis forState:(UIControlStateNormal)];
    }

    self.btnShare.frame = CGRectMake(self.width-10-30, 0, 30, 43);
    self.btnComm.frame = CGRectMake(CGRectGetMinX(self.btnShare.frame)-50, 0, 40, 43);
    self.btnZan.frame = CGRectMake(CGRectGetMinX(self.btnComm.frame)-50, 0, 40, 43);
}

- (void)changeZanCount:(NSInteger)count
{
    NSString *str;
    if (count <= 0) {
        [self.btnZan setTitle:@"" forState:(UIControlStateNormal)];
    }
    else
    {
       str = [NSString stringWithFormat:@"%ld",(long)count];
        [self.btnZan setTitle:str forState:(UIControlStateNormal)];
//        if (count > 9) {
//            self.btnZan.titleLabel.font = [UIFont systemFontOfSize:14];
//        }else
//        {
//            self.btnZan.titleLabel.font = [UIFont systemFontOfSize:15];
//        }
    }
    
    
}

- (void)shareAction
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickBarButtonShare:)]) {
        [self.delegate clickBarButtonShare:self];
    }
}
- (void)commAction
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickBarButtonComm:)]) {
        [self.delegate clickBarButtonComm:self];
    }
}- (void)zanAction
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickBarButtonZan:)]) {
        [self.delegate clickBarButtonZan:self];
    }
}

@end
