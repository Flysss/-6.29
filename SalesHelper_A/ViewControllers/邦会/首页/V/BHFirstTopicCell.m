//
//  BHFirstTopicCell.m
//  SalesHelper_A
//
//  Created by zhipu on 16/2/22.
//  Copyright © 2016年 X. All rights reserved.
//

#import "BHFirstTopicCell.h"
#import "UIColor+HexColor.h"
#import "ZJPostHead.h"

#define DistanceX 10+10+35

@implementation BHFirstTopicCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        

//        
//        self.lblTopic = [[UILabel alloc]init];
//        self.lblTopic.textAlignment = NSTextAlignmentCenter;
//        self.lblTopic.textColor = [UIColor colorWithHexString:KBlueColor];
//        self.lblTopic.font = [UIFont systemFontOfSize:18];
//        [self.contentView addSubview:self.lblTopic];
//
        self.lblContents = [[UILabel alloc]init];
        self.lblContents.font = [UIFont systemFontOfSize:17];
        self.lblContents.numberOfLines = 2;
        self.lblContents.textColor = [UIColor colorWithHexString:@"6e6e6e"];
        [self.contentView addSubview:self.lblContents];
        
        self.imgTopic = [[UIImageView alloc]init];
        self.imgTopic.contentMode = UIViewContentModeScaleAspectFill;
        self.imgTopic.clipsToBounds = YES;
        self.imgTopic.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];
        [self.contentView addSubview:self.imgTopic];
        
        self.headerView = [[ZJPostHead alloc]init];
        [self.contentView addSubview:self.headerView];
    }
    return self;
}

- (void)cellForModel:(BHFirstListModel *)model
{
    self.headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
   
    CGFloat marge = DistanceX+10;
    
    CGFloat contensWidth = SCREEN_WIDTH-marge;
    
    CGFloat contensHeight = [model.topic_b boundingRectWithSize:CGSizeMake(contensWidth, 0) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.height ;
    
    self.lblContents.frame = CGRectMake(DistanceX, CGRectGetMaxY(self.headerView.frame)+10, contensWidth, contensHeight);
    
    self.imgTopic.frame = CGRectMake(DistanceX, CGRectGetMaxY(self.lblContents.frame)+10, contensWidth, 180*SCREEN_WIDTH/320);
    
    
    if ([model.type isEqualToString:@"2"])
    {
        [self.headerView.imgHead setImage:[UIImage imageNamed:@"公告"]];
    }else
    {
        [self.headerView.imgHead setImage:[UIImage imageNamed:@"邦学院"]];
    }
    self.headerView.lblName.text = model.z_topic;

    self.headerView.lblName.frame = CGRectMake(10+10+35, 32/2, self.headerView.width, 15);
    
    self.headerView.btnGuanZhu.hidden = YES;
    self.headerView.btnLV.hidden = YES;
    self.headerView.lblOrgName.text = model.f_topic;
    self.headerView.lblOrgName.frame = CGRectMake(CGRectGetMinX(self.headerView.lblName.frame), CGRectGetMaxY(self.headerView.lblName.frame), SCREEN_WIDTH-(20+18+85)/2-15-61, 20);
    

    self.lblContents.text = model.topic;
    [self.imgTopic sd_setImageWithURL:[NSURL URLWithString:model.imgpath]];

}

+ (CGFloat )heightWithModel:(BHFirstListModel *)model
{
    CGFloat H = 0;
    
    H += 50;
    CGFloat marge = DistanceX+10;
    
    CGFloat contensWidth = SCREEN_WIDTH-marge;
    CGFloat contensHeight = [model.topic_b boundingRectWithSize:CGSizeMake(contensWidth, 0) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.height ;
    H += contensHeight;
    H += 30;
    H += 180*SCREEN_WIDTH/320;
    return H;
}


#pragma mark - 时间转换
- (NSString *)dataWithTime:(NSString *)time
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"EEE MMM dd HH:mm:ss Z yyyy";
#warning 真机调试必须加上这句
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    
    // 获得微博发布的具体时间
    NSTimeInterval timer = [time doubleValue];
    NSDate *createDate = [NSDate dateWithTimeIntervalSince1970:timer];
    
    fmt.dateFormat = @"yyyy-MM-dd";
    return [fmt stringFromDate:createDate];;
    
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
