//
//  ZJFirstDetailHeaderView.m
//  SalesHelper_A
//
//  Created by zhipu on 16/3/24.
//  Copyright © 2016年 X. All rights reserved.
//

#import "ZJFirstDetailHeaderView.h"
#import "UIColor+HexColor.h"
#import "BHDetailTopModel.h"

@implementation ZJFirstDetailHeaderView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.imgHead = [[UIImageView alloc]init];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(jumpPage)];
        self.imgHead.userInteractionEnabled = YES;
        [self.imgHead addGestureRecognizer:tap];
        [self addSubview:self.imgHead];
        
        self.lblName = [[UILabel alloc]init];
        self.lblName.textColor = [UIColor colorWithHexString:@"404040"];
        self.lblName.font = [UIFont systemFontOfSize:15];
        [self addSubview:self.lblName];
        
        self.btnLV = [UIButton buttonWithType:(UIButtonTypeRoundedRect)];
        [self.btnLV setTitleColor:[UIColor colorWithHexString:@"00aff0"] forState:(UIControlStateNormal)];
        self.btnLV.titleLabel.font = Default_Font_13;
        self.btnLV.layer.borderColor = [UIColor colorWithHexString:@"d0d0d0"].CGColor;
        self.btnLV.layer.borderWidth = 0.5;
        self.btnLV.layer.masksToBounds = YES;
        self.btnLV.layer.cornerRadius = 5;
        [self addSubview:self.btnLV];
        
        self.lblOrgName = [[UILabel alloc]init];
        self.lblOrgName.textColor = [UIColor colorWithHexString:@"c6c6c6"];
        self.lblOrgName.font = [UIFont systemFontOfSize:10];
        [self addSubview:self.lblOrgName];
        
        self.btnGuanZhu = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [self.btnGuanZhu setTitleColor:[UIColor colorWithHexString:@"676767"] forState:(UIControlStateNormal)];
        self.btnGuanZhu.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.btnGuanZhu addTarget:self action:@selector(guanzhuAction) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:self.btnGuanZhu];
        
        //        self.lblLine = [[UILabel alloc]init];
        //        self.lblLine.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
        //        [self addSubview:self.lblLine];
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imgHead.frame = CGRectMake(10, 29/2, 85/2, 85/2);
    self.imgHead.layer.cornerRadius = self.imgHead.frame.size.width/2;
    self.imgHead.layer.masksToBounds = YES;
    self.btnGuanZhu.frame = CGRectMake(0, 0, 61, 30);
    self.btnGuanZhu.center = CGPointMake(SCREEN_WIDTH-10-61/2, CGRectGetCenter(self.imgHead.frame).y);
}

#pragma mark-自适应宽度
+ (CGFloat)widthForString:(NSString *)str font:(CGFloat)font height:(CGFloat)height
{
    NSDictionary *dic = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:font] forKey:NSFontAttributeName];
    CGRect bound = [str boundingRectWithSize:CGSizeMake(0, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    return bound.size.width;
}

-(void)setModel:(BHDetailTopModel *)model
{
    _model = model;
    NSString *name = model.name;
    if (name != nil)
    {
        CGFloat width = [ZJFirstDetailHeaderView widthForString:name font:15 height:15];
        
        self.lblName.frame = CGRectMake(10+9+85/2, 38/2, width, 15);
    }
    
    
    NSString *remark = model.remark;
    if (remark != nil)
    {
        CGFloat lwidth = [ZJFirstDetailHeaderView widthForString:remark font:13 height:15];
        self.btnLV.frame = CGRectMake(CGRectGetMaxX(self.lblName.frame)+15/2, 43/2, lwidth+10, 15);
    }
    
    
    self.lblOrgName.frame = CGRectMake(10+9+85/2, CGRectGetMaxY(self.lblName.frame)+17/2, SCREEN_WIDTH-(20+18+85)/2, 20);
    
    [self.imgHead sd_setImageWithURL:[NSURL URLWithString:model.iconpath] placeholderImage:[UIImage imageNamed:@"默认个人图像"]];
    self.lblName.text = model.name;
    [self.btnLV setTitle:model.remark forState:(UIControlStateNormal)];
    if (model.org_name == nil) {
        model.org_name = @"";
    }
    NSString *time = [NSString stringWithFormat:@"%@  %@",model.addtime,model.org_name];
    self.lblOrgName.text = time;
    //    self.lblLine.frame = CGRectMake(10,(38+85+20)/2-0.5, SCREEN_WIDTH-10, 0.5);
    if ([_loginuid isEqualToString: model.uid]) {
        self.btnGuanZhu.hidden = YES;
    }
    else
    {
        self.btnGuanZhu.hidden = NO;
        if (model.isfocus != nil)
        {
            [self.btnGuanZhu setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            [self.btnGuanZhu setTitle:@"已关注" forState:(UIControlStateNormal)];
            self.btnGuanZhu.selected = YES;
        }
        else
        {
            [self.btnGuanZhu setImage:[UIImage imageNamed:@"plus_335px_1187514_easyicon.net"] forState:UIControlStateNormal];
            [self.btnGuanZhu setTitle:@"  关注" forState:(UIControlStateNormal)];
            self.btnGuanZhu.selected = NO;
        }
    }

}

- (void)guanzhuAction
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clikeGuanZhuButtonAction:)]) {
        [self.delegate clikeGuanZhuButtonAction:self];
    }
}
- (void)jumpPage
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(tapImgJumpPageAction:)]) {
        [self.delegate tapImgJumpPageAction:self];
    }
}



@end
