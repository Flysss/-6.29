//
//  BHListHuaTiCell.m
//  SalesHelper_A
//
//  Created by zhipu on 16/3/30.
//  Copyright © 2016年 X. All rights reserved.
//

#import "BHListHuaTiCell.h"
#import "BHListHuaTiAndGongGaoModel.h"
#import "UIColor+HexColor.h"

@implementation BHListHuaTiCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.imgLogo =[[UIImageView alloc]init];
        [self.contentView addSubview:self.imgLogo];
        
        self.lblTopic = [[UILabel alloc]init];
        self.lblTopic.textColor = [UIColor colorWithHexString:KBlueColor];
        self.lblTopic.font = [UIFont systemFontOfSize:18];
        self.lblTopic.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.lblTopic];
        
        self.lblTitle = [[UILabel alloc]init];
        self.lblTitle.textAlignment = NSTextAlignmentLeft;
        self.lblTitle.textColor = [UIColor colorWithHexString:@"676767"];
        self.lblTitle.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:self.lblTitle];
        
        self.imgTopic = [[JoinHuaTiPlainImageView alloc]init];
        self.imgTopic.contentMode = UIViewContentModeScaleAspectFill;
        self.imgTopic.clipsToBounds = YES;
        self.imgTopic.userInteractionEnabled = YES;
        [self.contentView addSubview:self.imgTopic];
        
        self.lblHuaTi = [[UILabel alloc]init];
        self.lblHuaTi.text = @"发表话题";
        self.lblHuaTi.textColor = [UIColor colorWithHexString:@"ffffff"];
        self.lblHuaTi.layer.cornerRadius = 8;
        self.lblHuaTi.layer.masksToBounds = YES;
        self.lblHuaTi.backgroundColor = [UIColor colorWithHexString:@"00aff0"];
        self.lblHuaTi.textAlignment = NSTextAlignmentCenter;
        [self.imgTopic addSubview:self.lblHuaTi];
        
    }
    return self;
}

- (void)setModel:(BHListHuaTiAndGongGaoModel *)model
{
    _model = model;
    
    
    
    
    if ([_isList isEqualToString:@"1"])
    {
        self.imgLogo.image = [UIImage imageNamed:@"话题"];
        self.lblHuaTi.hidden = NO;
    }
    else if([_isList isEqualToString:@"2"])
    {
        self.imgLogo.image = [UIImage imageNamed:@"公告"];
        self.lblHuaTi.hidden = YES;
    }
    else if([_isList isEqualToString:@"3"])
    {
        self.imgLogo.image = [UIImage imageNamed:@"公告"];
        self.lblHuaTi.hidden = YES;
        self.lblTopic.frame = CGRectMake(22, 0, 95, 50);
        self.lblTitle.frame = CGRectMake(114, 0, SCREEN_WIDTH-112, 50);

    }
    self.lblTopic.text = [NSString stringWithFormat:@"【%@】",model.z_topic];

    
  
    
    [self.imgTopic sd_setImageWithURL:[NSURL URLWithString:model.imgpath] placeholderImage:[UIImage imageNamed:@"pp_bg"]];
    
    if ([_isList isEqualToString:@"1"])
    {
        self.lblTitle.text = [NSString stringWithFormat:@"#%@#",model.topic];
    }
    else if ([_isList isEqualToString:@"2"])
    {
        self.lblTitle.text = [NSString stringWithFormat:@"%@",model.topic];
    }
    else if ([_isList isEqualToString:@"3"])
    {
        self.lblTitle.text = [NSString stringWithFormat:@"%@",model.topic];
    }
    
    CGFloat topicWidth = 0;
    if ([NSString stringWithFormat:@"【%@】",model.z_topic])
    {
        topicWidth = [[NSString stringWithFormat:@"【%@】",model.z_topic] boundingRectWithSize:CGSizeMake(0, 50) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18] } context:nil].size.width;
    }

    
    self.imgLogo.frame = CGRectMake(6, 6+10, 18, 18);
    self.lblTopic.frame = CGRectMake(22, 0, topicWidth, 50);
    self.lblTitle.frame = CGRectMake(22+topicWidth, 0, SCREEN_WIDTH-22-topicWidth-10, 50);
    self.imgTopic.frame = CGRectMake(6, 50, SCREEN_WIDTH-12, 180*SCREEN_WIDTH/320);
    
    self.lblHuaTi.frame = CGRectMake(0, 0, 80, 30);
    self.lblHuaTi.center = CGPointMake(self.imgTopic.size.width/2, self.imgTopic.size.height/2);
}

@end
