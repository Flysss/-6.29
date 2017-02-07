//
//  TieziTableViewCell.m
//  SalesHelper_A
//
//  Created by Brant on 16/2/19.
//  Copyright © 2016年 X. All rights reserved.
//

#import "TieziTableViewCell.h"
#import "UIColor+Extend.h"

@implementation TieziTableViewCell


- (void)configTableViewWithModel:(BHMyPostsModel *)model
{
    //头像
    UIImageView *headImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 9, 55, 55)];
    [headImage sd_setImageWithURL:[NSURL URLWithString:model.iconpath] placeholderImage:[UIImage imageNamed:@"toux"]];
    [self.contentView addSubview:headImage];
    
    //姓名
    CGFloat nameW = [model.name boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-85-55, 20) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:Default_Font_14} context:nil].size.width;
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(headImage.frame)+10, 16, nameW, 20)];
    nameLabel.text = model.name;
    nameLabel.font = Default_Font_14;
    nameLabel.textColor = [UIColor hexChangeFloat:KBlueColor];
    [self.contentView addSubview:nameLabel];
    
    //等级
    UILabel *level = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(nameLabel.frame)+5, 16+3, 35, 15)];
    level.textColor = [UIColor hexChangeFloat:KBlueColor];
    level.textAlignment = NSTextAlignmentCenter;
    level.font = Default_Font_10;
    level.layer.cornerRadius = 5;
    level.layer.masksToBounds = YES;
    level.layer.borderColor = [UIColor hexChangeFloat:@"d0d0d0"].CGColor;
    level.layer.borderWidth = 1;
    level.text = model.remark;
    [self.contentView addSubview:level];
    
    //时间
    CGFloat timeW = [model.addtime boundingRectWithSize:CGSizeMake(0, 15) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:Default_Font_10} context:nil].size.width;
    if (timeW>150) {
        timeW = 150;
    }
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(headImage.frame)+5, CGRectGetMaxY(nameLabel.frame)+9, timeW, 15)];
    timeLabel.textColor = [UIColor hexChangeFloat:KGrayColor];
    timeLabel.font = Default_Font_10;
    timeLabel.text = model.addtime;
    [self.contentView addSubview:timeLabel];
    
    //性质
    UILabel *guanjiaLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(timeLabel.frame)+7, CGRectGetMinY(timeLabel.frame), SCREEN_WIDTH-85-150, 15)];
    guanjiaLabel.textColor = [UIColor hexChangeFloat:KGrayColor];
    guanjiaLabel.font = Default_Font_10;
    guanjiaLabel.text = model.org_name;
    [self.contentView addSubview:guanjiaLabel];
    
    //大图
    UIImageView *bigImage = [[UIImageView alloc] init];
    if (model.imgpath != nil)
    {
        bigImage.frame = CGRectMake(0, 55+18, SCREEN_WIDTH, 436/2);
        [bigImage sd_setImageWithURL:[NSURL URLWithString:model.imgpath] placeholderImage:[UIImage imageNamed:@""]];;
    }
    else
    {
        bigImage.frame = CGRectZero;
    }
    [self.contentView addSubview:bigImage];
    
    UILabel *biaoZhuLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(bigImage.frame), SCREEN_WIDTH, 45)];
    biaoZhuLabel.font = Default_Font_25;
    biaoZhuLabel.text = model.contents;
    [self.contentView addSubview:biaoZhuLabel];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
