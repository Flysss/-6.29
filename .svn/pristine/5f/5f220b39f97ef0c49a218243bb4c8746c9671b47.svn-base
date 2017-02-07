//
//  ZJPostLikeView.m
//  SalesHelper_A
//
//  Created by zhipu on 16/3/20.
//  Copyright © 2016年 X. All rights reserved.
//

#import "ZJPostLikeView.h"

#import "BHFirstListModel.h"
#import "UIColor+HexColor.h"
#import "BHFirstZanModel.h"
#import "BHHuaTiModel.h"

#import "UIButton+WebCache.h"

@interface ZJPostLikeView ()

@property (nonatomic, strong)UILabel *lblLine;

@end

@implementation ZJPostLikeView

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
        self.lblLine = [[UILabel alloc]init];
        self.lblLine.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0.5);
        self.lblLine.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
        [self addSubview:self.lblLine];
        
        UIButton *btnzan = [UIButton buttonWithType:(UIButtonTypeCustom)];
        btnzan.frame = CGRectMake(12, 10,(SCREEN_WIDTH-30)/10-5, (SCREEN_WIDTH-30)/10-5);
        [btnzan setImage:[UIImage imageNamed:@"点赞"] forState:(UIControlStateNormal)];
        [self addSubview:btnzan];
        
        self.btnZanCount = [UIButton buttonWithType:(UIButtonTypeCustom)];
        self.btnZanCount.frame = CGRectMake(SCREEN_WIDTH-(SCREEN_WIDTH-18)/10- 14, 10,(SCREEN_WIDTH-30)/10-5, (SCREEN_WIDTH-30)/10-5);
        
        [self.btnZanCount setImage:[UIImage imageNamed:@"点赞更多"] forState:UIControlStateNormal];
        [self.btnZanCount addTarget:self action:@selector(jumpPageLikePeople) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:self.btnZanCount];
        
        for (NSInteger i = 8; i > 0; i--)
        {
            UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
            button.tag = i+1000;
            button.frame = CGRectMake(((SCREEN_WIDTH-30)/10)*i+14, 10, (SCREEN_WIDTH-30)/10-5, (SCREEN_WIDTH-30)/10-5);
            
            button.layer.cornerRadius = button.width/2;
            button.layer.masksToBounds = YES;
            [self addSubview:button];
        }
        
    }
    return self;
}

- (void)setModel:(BHFirstListModel *)model
{
    _model = model;
    NSInteger count = self.zanCount.count;
//    UIButton *btnZanCount = self.subviews[1];
    if (count > 8)
    {
        count = 8;
        self.btnZanCount.hidden = NO;
    }else
    {
        self.btnZanCount.hidden = YES;
    }
    for (int i = 8; i > 0; i--)
    {
        UIButton *button = [self viewWithTag:i+1000];
        button.hidden = YES;
    }
    
    
    for (NSInteger i = count; i > 0; i--)
    {
        UIButton *button = [self viewWithTag:i+1000];
        button.hidden = NO;
        BHFirstZanModel *zanModel = self.zanCount[button.tag -1001];
        if (![zanModel.iconpath isKindOfClass:[NSNull class]]) {
            
            [button sd_setBackgroundImageWithURL:[NSURL URLWithString:zanModel.iconpath] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"默认个人图像"]];
        }
//        [button addTarget:self action:@selector(tapLikeHeadImgJumpPage:) forControlEvents:(UIControlEventTouchUpInside)];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapLikeHeadImgJumpPage:)];
        button.userInteractionEnabled = YES;
        [button addGestureRecognizer:tap];
    }
//    btnzan.hidden = NO;
//    btnZanCount.hidden = NO;
}

-(void)setHmodel:(BHHuaTiModel *)Hmodel
{
    _Hmodel = Hmodel;
    NSInteger count = self.zanCount.count;
    //    UIButton *btnZanCount = self.subviews[1];
    if (count > 8)
    {
        count = 8;
        self.btnZanCount.hidden = NO;
    }else
    {
        self.btnZanCount.hidden = YES;
    }
    for (int i = 8; i > 0; i--)
    {
        UIButton *button = [self viewWithTag:i+1000];
        button.hidden = YES;
    }
    
    
    for (NSInteger i = count; i > 0; i--)
    {
        UIButton *button = [self viewWithTag:i+1000];
        button.hidden = NO;
        BHFirstZanModel *zanModel = self.zanCount[button.tag -1001];
        if (![zanModel.iconpath isKindOfClass:[NSNull class]]) {
            
            [button sd_setBackgroundImageWithURL:[NSURL URLWithString:zanModel.iconpath] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"默认个人图像"]];
        }
//        [button addTarget:self action:@selector(tapLikeHeadImgJumpPage:) forControlEvents:(UIControlEventTouchUpInside)];

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapLikeHeadImgJumpPage:)];
        button.userInteractionEnabled = YES;
        [button addGestureRecognizer:tap];
    }

}















- (void)tapLikeHeadImgJumpPage:(UITapGestureRecognizer *)tap
{
    _n = tap.view.tag-1001;
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
