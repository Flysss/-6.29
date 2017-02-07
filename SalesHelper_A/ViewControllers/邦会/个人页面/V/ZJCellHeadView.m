//
//  ZJCellHeadView.m
//  SalesHelper_A
//
//  Created by zhipu on 16/3/18.
//  Copyright © 2016年 X. All rights reserved.
//

#import "ZJCellHeadView.h"
#import "UIColor+HexColor.h"
#import "BHMyPostsModel.h"

@implementation ZJCellHeadView

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
        self.imgHead = [[UIImageView alloc]init];
        [self addSubview:self.imgHead];
        
        self.lblName = [[UILabel alloc]init];
        self.lblName.textColor = [UIColor colorWithHexString:@"00aff0"];
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
        self.lblOrgName.font = [UIFont systemFontOfSize:12];
        [self addSubview:self.lblOrgName];
        
        self.lblLine = [[UILabel alloc]init];
        self.lblLine.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
        [self addSubview:self.lblLine];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imgHead.frame = CGRectMake(10, 38/2, 85/2, 85/2);
    self.imgHead.layer.cornerRadius = self.imgHead.frame.size.width/2;
    self.imgHead.layer.masksToBounds = YES;
    
}


- (void)setModel:(BHMyPostsModel *)model
{
    _model = model;
    
    NSString *name = model.name;
    if (name != nil)
    {
        CGFloat width = [ZJCellHeadView widthForString:name font:15 height:15];
        
        self.lblName.frame = CGRectMake(10+9+85/2, 43/2, width, 15);
    }
    
    
    NSString *remark = model.remark;
    if (remark != nil)
    {
        CGFloat lwidth = [ZJCellHeadView widthForString:remark font:13 height:15];
        self.btnLV.frame = CGRectMake(CGRectGetMaxX(self.lblName.frame)+15/2, 43/2, lwidth+10, 15);
    }
    
    
    self.lblOrgName.frame = CGRectMake(10+9+85/2, CGRectGetMaxY(self.lblName.frame)+17/2, SCREEN_WIDTH-(20+18+85)/2, 20);
    
    
    [self.imgHead sd_setImageWithURL:[NSURL URLWithString:model.iconpath] placeholderImage:[UIImage imageNamed:@"默认个人图像"]];
    self.lblName.text = model.name;
    [self.btnLV setTitle:model.remark forState:(UIControlStateNormal)];
    self.lblOrgName.text = model.org_name;
    self.lblLine.frame = CGRectMake(10,(38+85+20)/2-0.5, SCREEN_WIDTH-10, 0.5);

    
}
#pragma mark-自适应宽度
+ (CGFloat)widthForString:(NSString *)str font:(CGFloat)font height:(CGFloat)height
{
    NSDictionary *dic = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:font] forKey:NSFontAttributeName];
    CGRect bound = [str boundingRectWithSize:CGSizeMake(0, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    return bound.size.width;
}
@end
