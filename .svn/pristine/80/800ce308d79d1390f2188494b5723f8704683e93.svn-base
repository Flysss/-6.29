//
//  BHGongGaoCell.m
//  SalesHelper_A
//
//  Created by zhipu on 16/2/24.
//  Copyright © 2016年 X. All rights reserved.
//

#import "BHGongGaoCell.h"
#import "UIColor+HexColor.h"

@implementation BHGongGaoCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.imgHead = [[UIImageView alloc]initWithFrame:CGRectMake(10, 13, 40, 40)];
        self.imgHead.layer.cornerRadius = 20;
        self.imgHead.layer.masksToBounds = YES;
        [self.contentView addSubview:self.imgHead];
        
        self.lblName = [[UILabel alloc]initWithFrame:CGRectMake(62, 13, SCREEN_WIDTH-72, 20)];
        self.lblName.textColor = [UIColor colorWithHexString:@"676767"];
        self.lblName.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.lblName];
        
        self.lblTime = [[UILabel alloc]initWithFrame:CGRectMake(62, 33, SCREEN_WIDTH-72, 15)];
        self.lblTime.textColor = [UIColor colorWithHexString:@"c8c8c8"];
        self.lblTime.font = [UIFont systemFontOfSize:10];
        [self.contentView addSubview:self.lblTime];
        
        self.lblBody = [[UILabel alloc]initWithFrame:CGRectMake(62, 56, SCREEN_WIDTH-72, 25)];
        self.lblBody.textColor = [UIColor colorWithHexString:@"676767"];
        self.lblBody.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:self.lblBody];
        
        self.btnPingLun = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [self.btnPingLun setTitle:@" 评论" forState:(UIControlStateNormal)];
        [self.btnPingLun setImage:[UIImage imageNamed:@"评论"] forState:(UIControlStateNormal)];
        [self.btnPingLun setTitleColor:[UIColor colorWithHexString:@"c8c8c8"] forState:(UIControlStateNormal)];
        self.btnPingLun.titleLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:self.btnPingLun];
        
        self.btnZan = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [self.btnZan setTitle:@" 赞" forState:(UIControlStateNormal)];
        [self.btnZan setImage:[UIImage imageNamed:@"点赞"] forState:(UIControlStateNormal)];
        [self.btnZan setTitleColor:[UIColor colorWithHexString:@"c8c8c8"] forState:(UIControlStateNormal)];
        self.btnZan.titleLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:self.btnZan];
    }
    return self;
}

- (void)cellForModel
{
    NSString *str = @"干的漂亮";
    self.imgHead.image = [UIImage imageNamed:@"自己页面头像"];
    self.lblName.text = @"萌布布";
    self.lblTime.text = @"三天前";
    self.lblBody.text = str;
    self.lblBody.frame = CGRectMake(62, 56, SCREEN_WIDTH-72, [BHGongGaoCell heightForString:str]);
    self.btnPingLun.frame = CGRectMake(SCREEN_WIDTH-132, [BHGongGaoCell heightForString:str]+56, 60, 25);
    self.btnZan.frame = CGRectMake(SCREEN_WIDTH-66, [BHGongGaoCell heightForString:str]+56, 60, 25);
}

#pragma mark-行高
+ (CGFloat )heightForCell:(NSString *)str
{
    return [self heightForString:str] + 86;
}

#pragma mark-自适应高度
+ (CGFloat)heightForString:(NSString *)str
{
    NSDictionary *dic = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:13] forKey:NSFontAttributeName];
    if (str == nil) {
        return 0;
    }else
    {
        
        CGRect bound = [str boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-72, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
        return bound.size.height;
    }
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
