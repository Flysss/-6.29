//
//  BHLeftRootCell.m
//  SalesHelper_A
//
//  Created by zhipu on 16/2/19.
//  Copyright © 2016年 X. All rights reserved.
//

#import "BHLeftRootCell.h"
#import "UIColor+HexColor.h"
#import "UIImageView+WebCache.h"

#define KWHITECOLOR [UIColor colorWithHexString:@"ffffff"]

@implementation BHLeftRootCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.imgTitle = [[UIImageView alloc]initWithFrame:CGRectMake(16, 13, 35, 35)];
        [self.contentView addSubview:self.imgTitle];
        
        self.lblTitle = [[UILabel alloc]initWithFrame:CGRectMake(67, 13, SCREEN_WIDTH-67, 30)];
        self.lblTitle.font = Default_Font_15;
        self.lblTitle.textColor = KWHITECOLOR;
        [self.contentView addSubview:self.lblTitle];
        
        self.lblTopic = [[UILabel alloc]initWithFrame:CGRectMake(67, 50, 30, 20)];
        self.lblTopic.font = Default_Font_12;
        self.lblTopic.textColor = KWHITECOLOR;
        self.lblTopic.text = @"话题";
        [self.contentView addSubview:self.lblTopic];
        
        self.lblTopicNum = [[UILabel alloc]initWithFrame:CGRectMake(97, 50, 50, 20)];
        self.lblTopicNum.font = Default_Font_12;
        self.lblTopicNum.textColor = KWHITECOLOR;
        [self.contentView addSubview:self.lblTopicNum];
        
        self.lblsentiment = [[UILabel alloc]initWithFrame:CGRectMake(154, 50, 50, 20)];
        self.lblsentiment.font = Default_Font_12;
        self.lblsentiment.textColor = KWHITECOLOR;
        self.lblsentiment.text = @"人气";
        [self.contentView addSubview:self.lblsentiment];
        
        self.lblsentimentNum = [[UILabel alloc]initWithFrame:CGRectMake(204, 50, 50, 20)];
        self.lblsentimentNum.font = Default_Font_12;
        self.lblsentimentNum.textColor = KWHITECOLOR;
        [self.contentView addSubview:self.lblsentimentNum];
    }
    return self;
}
- (void)cellForModel:(BHLeftModel *)model
{
    self.lblTopicNum.text = model.huati;
    self.lblsentimentNum.text = model.renqi;
    self.lblTitle.text = model.topic;
    [self.imgTitle sd_setImageWithURL:[NSURL URLWithString:model.iconpath]];
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
