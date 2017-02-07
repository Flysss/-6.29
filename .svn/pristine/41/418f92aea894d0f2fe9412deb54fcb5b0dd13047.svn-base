//
//  BHMessageCell.m
//  SalesHelper_A
//
//  Created by zhipu on 16/2/25.
//  Copyright © 2016年 X. All rights reserved.
//

#import "BHMessageCell.h"
#import "UIColor+Extend.h"

@implementation BHMessageCell
- (void)configTableViewWithDic:(NSDictionary *)dic;
{
    //头像
    UIImageView *headImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 13, 40, 40)];
    headImage.layer.cornerRadius = 20;
    headImage.layer.masksToBounds = YES;
    [headImage sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@""]];
    [self.contentView addSubview:headImage];
    
    //姓名
    UILabel *nameLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(headImage.frame)+18, 10, SCREEN_WIDTH-68-70, 20)];
    nameLable.text = dic[@""];
    nameLable.font = Default_Font_18;
    nameLable.textColor = [UIColor hexChangeFloat:@"676767"];
    [self.contentView addSubview:nameLable];
    
    //标注
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(headImage.frame)+18, CGRectGetMaxY(nameLable.frame), SCREEN_WIDTH-68-70, 20)];
    contentLabel.font = Default_Font_13;
    contentLabel.textColor = [UIColor hexChangeFloat:@"a4a4a4"];
    contentLabel.text = dic[@""];
    [self.contentView addSubview:contentLabel];
    
    //时间
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-70, 15, 60, 20)];
    timeLabel.font = Default_Font_13;
    timeLabel.textColor = [UIColor hexChangeFloat:@"dadadc"];
    timeLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:timeLabel];
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
