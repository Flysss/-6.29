//
//  BHHeadView.m
//  SalesHelper_A
//
//  Created by 曾杰 on 16/3/10.
//  Copyright © 2016年 X. All rights reserved.
//

#import "BHHeadView.h"
#import "UIColor+HexColor.h"
#import "UIImageView+WebCache.h"

@interface BHHeadView ()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *orangeLabel;
@property (nonatomic, strong) UIImageView *imgHead;
@property (nonatomic, strong) UIButton *btnGuanZhu;
@property (nonatomic, strong) UIButton *btnLV;

@end


@implementation BHHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.nameLabel = [[UILabel alloc]init];
        [self addSubview:self.nameLabel];
        
        self.timeLabel = [[UILabel alloc]init];
        [self addSubview:self.timeLabel];
        
        self.orangeLabel = [[UILabel alloc]init];
        [self addSubview:self.orangeLabel];
        
        self.btnGuanZhu = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [self addSubview:self.btnGuanZhu];
        
        self.imgHead = [[UIImageView alloc]init];
        [self addSubview:self.imgHead];
        
        self.btnLV = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [self addSubview:self.btnLV];
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imgHead.frame = CGRectMake(10, 9, 55, 55);
    self.imgHead.layer.cornerRadius = 27.5;
    self.imgHead.layer.masksToBounds = YES;
    
    self.btnGuanZhu.frame = CGRectMake(SCREEN_WIDTH-61, 23, 51, 30);
    [self.btnGuanZhu setTitleColor:[UIColor colorWithHexString:@"676767"] forState:(UIControlStateNormal)];
    self.btnGuanZhu.titleLabel.font = Default_Font_15;
    
    self.btnLV.frame = CGRectMake(182, 17, 40, 20);
    [self.btnLV setTitleColor:[UIColor colorWithHexString:@"00aff0"] forState:(UIControlStateNormal)];
    self.btnLV.titleLabel.font = Default_Font_11;
    self.btnLV.layer.borderColor = [UIColor colorWithHexString:@"d0d0d0"].CGColor;
    self.btnLV.layer.borderWidth = 0.5;
    self.btnLV.layer.masksToBounds = YES;
    self.btnLV.layer.cornerRadius = 10;
    
    self.nameLabel.frame = CGRectMake(76, 17, 100, 20 );
    self.nameLabel.font = Default_Font_14;
    self.nameLabel.textColor = [UIColor colorWithHexString:@"00aff0"];
    
    self.timeLabel.frame = CGRectMake(76, 47,SCREEN_WIDTH-152, 20);
    self.timeLabel.font = Default_Font_10;
    self.timeLabel.textColor = [UIColor colorWithHexString:@"bdbdbd"];
}

-(void)setModel:(BHPostsDetailModel *)model
{
    _model = model;
    self.nameLabel.frame = CGRectMake(76, 17, [BHHeadView widthForString:self.model.oper size:14], 20 );
    self.btnLV.frame = CGRectMake([BHHeadView widthForString:self.model.oper size:14]+76+6, 17, [BHHeadView widthForString:self.model.remark size:11], 20);
    self.nameLabel.text = model.oper;
    [self.btnLV setTitle:model.remark forState:(UIControlStateNormal)];
    self.timeLabel.text = model.addtime;
    self.orangeLabel.text = model.org_name;
    [self.imgHead sd_setImageWithURL:[NSURL URLWithString:model.iconpath] placeholderImage:[UIImage imageNamed:@"自己页面头像"]];
    if (model.isfocus == nil)
    {
        [self.btnGuanZhu setImage:[UIImage imageNamed:@"plus_335px_1187514_easyicon.net"] forState:UIControlStateNormal];
        [self.btnGuanZhu setTitle:@"关注" forState:(UIControlStateNormal)];
    }
    else
    {
        [self.btnGuanZhu setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [self.btnGuanZhu setTitle:@"已关注" forState:(UIControlStateNormal)];
    }

}

#pragma mark-自适应宽度
+ (CGFloat)widthForString:(NSString *)str size:(CGFloat)size
{
    
    NSDictionary *dic = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:size] forKey:NSFontAttributeName];
    CGRect bound = [str boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    return bound.size.width;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
