//
//  PrisedTableViewCell.m
//  SalesHelper_A
//
//  Created by Brant on 16/2/18.
//  Copyright © 2016年 X. All rights reserved.
//

#import "PrisedTableViewCell.h"
#import "UIColor+HexColor.h"

@implementation PrisedTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.headImage = [[UIImageView alloc] init];
        [self.contentView addSubview:self.headImage];

        self.nameLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.nameLabel];

         self.levelLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.levelLabel];

        self.prisedNumLab = [[UILabel alloc] init];
        [self.contentView addSubview:self.prisedNumLab];

    }
    return self;
}



- (void)configTableViewCellWithModel:(BHPersonMyFansModel *)model
{
    //头像
    self.headImage.frame = CGRectMake(10, 10, 50, 50);
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:model.iconpath] placeholderImage:[UIImage imageNamed:@"默认个人图像"]];
    self.headImage.layer.cornerRadius = 25;
    self.headImage.layer.masksToBounds = YES;
    
    
    //姓名
    
    NSString *nameStr = model.name;
    CGFloat nameW = [nameStr boundingRectWithSize:CGSizeMake(0, 20) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:Default_Font_15} context:nil].size.width;
    if (nameW > SCREEN_WIDTH-70-70-40) {
        nameW = SCREEN_WIDTH-180;
    }
    self.nameLabel.frame = CGRectMake(CGRectGetMaxX(self.headImage.frame)+10, 10+2, nameW, 15);
    self.nameLabel.text = nameStr;
    self.nameLabel.font = Default_Font_15;
    self.nameLabel.textColor = [UIColor colorWithHexString:@"00aff0"];
    
    //等级
    
    if (![model.remark isKindOfClass:[NSNull class]] && model.remark) {
        
            CGFloat lwidth = [PrisedTableViewCell widthForString:model.remark font:13 height:15];
        
       self.levelLabel.frame = CGRectMake(CGRectGetMaxX(self.nameLabel.frame)+15/2, CGRectGetMinY(self.nameLabel.frame), lwidth+10, 15);
        self.levelLabel.y = CGRectGetCenter(self.nameLabel.frame).y - self.nameLabel.height/2;
        self.levelLabel.text = model.remark;
        self.levelLabel.font = Default_Font_13;
        self.levelLabel.textAlignment = NSTextAlignmentCenter;
        self.levelLabel.textColor = [UIColor colorWithHexString:KBlueColor];
        self.levelLabel.layer.borderColor = [UIColor colorWithHexString:@"d0d0d0"].CGColor;
        self.levelLabel.layer.borderWidth = 0.5;
        self.levelLabel.layer.masksToBounds = YES;
        self.levelLabel.layer.cornerRadius = 5;
    }
   
    
    //被赞次数
    NSString *numStr = @"被赞0次";;
    if (model.praise_num != nil && ![model.praise_num isKindOfClass:[NSNull class]]) {
        numStr = [NSString stringWithFormat:@"被赞%@次", model.praise_num];
    }
    CGFloat prisedW = [numStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-70-70, 20) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:Default_Font_13} context:nil].size.width;
    self.prisedNumLab.frame = CGRectMake(CGRectGetMaxX(self.headImage.frame)+10, CGRectGetMaxY(self.nameLabel.frame)+5+5, prisedW, 20);
    self.prisedNumLab.font = Default_Font_13;
    
    NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithString:numStr];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:KBlueColor] range:NSMakeRange(2,numStr.length-3)];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"666666"] range:NSMakeRange(0,2)];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"666666"] range:NSMakeRange(numStr.length-3+2,1)];
    self.prisedNumLab.attributedText = attrStr;
    
    //关注按钮
    self.prisedBtn.hidden = YES;
//    if ([_loginuid isEqualToString:model.uid])
//    {
//        self.prisedBtn.hidden = YES;
//    }
//    else
//    {
//        self.prisedBtn.hidden = NO;
//        self.prisedBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-70, 20, 60, 30)];
//        NSLog(@"%@",model.isfocus);
//        if (model.isfocus != nil && ![model.isfocus isKindOfClass:[NSNull class]])
//        {
//            [self.prisedBtn setTitle:@"已关注" forState:UIControlStateNormal];
//            [self.prisedBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
//            
//            self.prisedBtn.selected = YES;
//        }
//        else
//        {
//            [self.prisedBtn setTitle:@"关注" forState:UIControlStateNormal];
//            [self.prisedBtn setImage:[UIImage imageNamed:@"plus_335px_1187514_easyicon.net"] forState:UIControlStateNormal];
//            self.prisedBtn.selected = NO;
//        }
//    }
    
//    [self.prisedBtn setTitleColor:[UIColor colorWithHexString:KBlackColor] forState:UIControlStateNormal];
//    self.prisedBtn.titleLabel.font = Default_Font_15;
//    [self.contentView addSubview:self.prisedBtn];

}

#pragma mark-自适应宽度
+ (CGFloat)widthForString:(NSString *)str font:(CGFloat)font height:(CGFloat)height
{
    NSDictionary *dic = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:font] forKey:NSFontAttributeName];
    CGRect bound = [str boundingRectWithSize:CGSizeMake(0, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    return bound.size.width;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
