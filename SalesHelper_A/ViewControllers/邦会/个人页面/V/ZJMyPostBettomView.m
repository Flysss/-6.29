//
//  ZJMyPostBettomView.m
//  SalesHelper_A
//
//  Created by zhipu on 16/6/23.
//  Copyright © 2016年 X. All rights reserved.
//

#import "ZJMyPostBettomView.h"
#import "UIColor+HexColor.h"
#import "BHMyPostsModel.h"

@implementation ZJMyPostBettomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.lblTime = [[UILabel alloc]init];
        self.lblTime.textColor = [UIColor colorWithHexString:@"bdbdbd"];
        self.lblTime.font = [UIFont systemFontOfSize:12];
        [self addSubview:self.lblTime];
        
        self.btnLike = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [self.btnLike setImage:[UIImage imageNamed:@""] forState:(UIControlStateNormal)];
        [self.btnLike setTitleColor:[UIColor colorWithHexString:@"cfcfcf"] forState:(UIControlStateNormal)];
        self.btnLike.titleLabel.font = [UIFont systemFontOfSize:10];
        [self.btnLike addTarget:self action:@selector(likeAction) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:self.btnLike];
        
        self.btnReply = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [self.btnReply setImage:[UIImage imageNamed:@""] forState:(UIControlStateNormal)];
        [self.btnReply setTitleColor:[UIColor colorWithHexString:@"cfcfcf"] forState:(UIControlStateNormal)];
        self.btnReply.titleLabel.font = [UIFont systemFontOfSize:10];
        [self.btnReply addTarget:self action:@selector(replyActon) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:self.btnReply];
        
        self.lblLine = [[UILabel alloc]init];
        self.lblLine.backgroundColor = [UIColor colorWithHexString:@"dadadc"];
        [self addSubview:self.lblLine];
        
    }
    return self;
}

- (void)setModel:(BHMyPostsModel *)model
{
    self.btnLike.tag = _indexpath.row;
    self.btnReply.tag = _indexpath.row;
    CGFloat H = 0;
    self.lblTime.frame = CGRectMake(21/2,H+25/2, SCREEN_WIDTH-21, 15);
    H += 25/2;
    NSInteger count = _model.zan.count;
    if (_model.ispraise != nil)
    {
        [self.btnLike setImage:[UIImage imageNamed:@"点赞之后小版"] forState:(UIControlStateNormal)];
        [self.btnLike setTitle:[NSString stringWithFormat:@"%ld",(long)count] forState:(UIControlStateNormal)];
        self.btnLike.titleLabel.textAlignment = NSTextAlignmentRight;
        self.btnLike.selected = YES;
    }
    else
    {
        [self.btnLike setImage:[UIImage imageNamed:@"点赞小版"] forState:(UIControlStateNormal)];
        [self.btnLike setTitle:[NSString stringWithFormat:@"%ld",(long)count] forState:(UIControlStateNormal)];
        self.btnLike.titleLabel.textAlignment = NSTextAlignmentRight;
        self.btnLike.selected = NO;
    }
    H += 15;
    
    
    self.btnLike.frame = CGRectMake(SCREEN_WIDTH-13-11/2-40-40, CGRectGetMidY(self.lblTime.frame)-15/2, 50, 12);
    [self.btnLike setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    
    self.btnReply.frame = CGRectMake(SCREEN_WIDTH-13-40, CGRectGetMidY(self.lblTime.frame)-15/2, 50, 12);
    [self.btnReply setImage:[UIImage imageNamed:@"评论小版"] forState:(UIControlStateNormal)];
    [self.btnReply setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    
    self.lblLine.frame = CGRectMake(0, H+21/2-0.5, SCREEN_WIDTH, 0.5);
    H += 21/2;
    
    self.lblTime.text = [NSString stringWithFormat:@"%@  %@",model.addtime,model.source];
    NSString *likeNum = [NSString stringWithFormat:@"%lu",(unsigned long)model.zan.count];
    NSString *replyNume = [NSString stringWithFormat:@"%@",model.huis];
    [self.btnLike setTitle:likeNum forState:(UIControlStateNormal)];
    [self.btnReply setTitle:replyNume forState:(UIControlStateNormal)];
    
}


+ (CGFloat)heightBodyView:(BHMyPostsModel *)model
{
    CGFloat H = 0;
    H += 25/2;
    H += 15;
    H += 21/2;
    return H;
}






- (void)likeAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(clickLikeButtonAction:)]) {
        [self.delegate clickLikeButtonAction:self];
    }
}
- (void)replyActon
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickComButtonAction:)]) {
        [self.delegate clickComButtonAction:self];
    }
}
@end
