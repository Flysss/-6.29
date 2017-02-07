//
//  ZJPostBottomBar.m
//  SalesHelper_A
//
//  Created by zhipu on 16/3/20.
//  Copyright © 2016年 X. All rights reserved.
//

#import "ZJPostBottomBar.h"
#import "UIColor+HexColor.h"
#import "BHFirstListModel.h"
#import "BHHuaTiModel.h"

@interface ZJPostBottomBar ()

@property (nonatomic, strong) UILabel *lblLine;

@property (nonatomic, strong) UILabel *lblLine2;

@end

@implementation ZJPostBottomBar

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.btnComm = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [self.btnComm setImage:[UIImage imageNamed:@"评论"] forState:(UIControlStateNormal)];
        [self.btnComm setTitle:@"  评论" forState:(UIControlStateNormal)];
        self.btnComm.titleLabel.font = Default_Font_14;
        [self.btnComm setTitleColor:[UIColor colorWithHexString:@"909090"] forState:(UIControlStateNormal)];
        [self.btnComm addTarget:self action:@selector(commAction) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:self.btnComm];
        
        self.btnShare = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [self.btnShare setImage:[UIImage imageNamed:@"分享转发"] forState:(UIControlStateNormal)];
        [self.btnShare setTitle:@"  分享" forState:(UIControlStateNormal)];
        [self.btnShare setTitleColor:[UIColor colorWithHexString:@"909090"] forState:(UIControlStateNormal)];
        self.btnShare.titleLabel.font = Default_Font_14;
        [self.btnShare addTarget:self action:@selector(shareAction) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:self.btnShare];
        
        self.btnZan = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [self.btnZan setImage:[UIImage imageNamed:@"点赞"] forState:(UIControlStateNormal)];
        [self.btnZan setTitle:@"  赞" forState:(UIControlStateNormal)];
        self.btnZan.titleLabel.font = Default_Font_14;
        [self.btnZan addTarget:self action:@selector(zanAction) forControlEvents:(UIControlEventTouchUpInside)];
        [self.btnZan setTitleColor:[UIColor colorWithHexString:@"909090"] forState:(UIControlStateNormal)];
        [self addSubview:self.btnZan];
        
        self.lblLine = [[UILabel alloc]init];
        self.lblLine.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
        [self addSubview:self.lblLine];
        

        
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.btnZan.frame = CGRectMake(0, 0, SCREEN_WIDTH/3, 43);
    self.btnComm.frame = CGRectMake(SCREEN_WIDTH/3, 0, SCREEN_WIDTH/3, 43);
    self.btnShare.frame = CGRectMake(SCREEN_WIDTH*2/3, 0, SCREEN_WIDTH/3, 43);
    self.lblLine.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0.5);
    [self.btnZan setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 4, 0)];
    [self.btnZan setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 4, 0)];
    
    [self.btnComm setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 4, 0)];
    [self.btnComm setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 4, 0)];
    
    [self.btnShare setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 4, 0)];
    [self.btnShare setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 4, 0)];
    
}

- (void)setModel:(BHFirstListModel *)model
{
    _model = model;
    if (model.ispraise != nil)
    {
        self.btnZan.selected = YES;
        [self.btnZan setImage:[UIImage imageNamed:@"点赞之后"] forState:(UIControlStateNormal)];
        [self.btnZan setTitle:@"  已赞" forState:(UIControlStateNormal)];
    }
    else
    {
        self.btnZan.selected = NO;
        [self.btnZan setImage:[UIImage imageNamed:@"点赞"] forState:(UIControlStateNormal)];
        [self.btnZan setTitle:@"  赞" forState:(UIControlStateNormal)];
    }
}

- (void)setHmodel:(BHHuaTiModel *)Hmodel
{
    _Hmodel = Hmodel;
    if (_Hmodel.ispraise != nil)
    {
        self.btnZan.selected = YES;
        [self.btnZan setImage:[UIImage imageNamed:@"点赞之后"] forState:(UIControlStateNormal)];
        [self.btnZan setTitle:@"  已赞" forState:(UIControlStateNormal)];
    }
    else
    {
        self.btnZan.selected = NO;
        [self.btnZan setImage:[UIImage imageNamed:@"点赞"] forState:(UIControlStateNormal)];
        [self.btnZan setTitle:@"  赞" forState:(UIControlStateNormal)];
    }
//    self.lblLine2.frame = CGRectMake(0, self.frame.size.height-0.5, SCREEN_WIDTH, 0.5);
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
