//
//  ApplyVisitTableViewCell.m
//  SalesHelper_A
//
//  Created by Brant on 16/1/20.
//  Copyright (c) 2016年 X. All rights reserved.
//

#import "ApplyVisitTableViewCell.h"
#import "UIColor+Extend.h"

@implementation ApplyVisitTableViewCell


- (void)configTableViewWIthDic:(NSDictionary *)dic
{
//    NSLog(@"%@", dic);
    //姓名
        NSString *nameStr = dic[@"name"];
        CGFloat nameW = [nameStr boundingRectWithSize:CGSizeMake(0, 20) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:Default_Font_18} context:nil].size.width;
    if (nameW >SCREEN_WIDTH-140)
    {
        nameW = SCREEN_WIDTH-140;
    } 
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 13, nameW, 20)];
        nameLabel.textColor = [UIColor hexChangeFloat:KBlackColor];
        nameLabel.font = Default_Font_18;
        nameLabel.text = nameStr;
        [self.contentView addSubview:nameLabel];
    
    //电话
        UILabel *phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(nameLabel.frame)+10, 13, 120, 20)];
        phoneLabel.font = Default_Font_14;
        phoneLabel.textColor = [UIColor hexChangeFloat:@"9fa0a0"];
        phoneLabel.text = dic[@"phone"];
        [self.contentView addSubview:phoneLabel];
    
    //地址
        UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(nameLabel.frame)+10, SCREEN_WIDTH/2-10, 20)];
        addressLabel.font = Default_Font_15;
        addressLabel.textColor = [UIColor hexChangeFloat:@"9fa0a0"];
        addressLabel.text = dic[@"propertyName"];
        [self.contentView addSubview:addressLabel];
    
//    //时间
//        UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, CGRectGetMinY(addressLabel.frame), SCREEN_WIDTH/2-10, 20)];
//        timeLabel.font = Default_Font_14;
//        timeLabel.textColor = [UIColor hexChangeFloat:@"9fa0a0"];
//        timeLabel.textAlignment = NSTextAlignmentRight;
//        timeLabel.text = dic[@"refereeDate"];
//        [self.contentView addSubview:timeLabel];
    
    //状态
    UILabel *stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-65, CGRectGetMinY(nameLabel.frame), 55, 25)];
    stateLabel.font = Default_Font_14;
    stateLabel.textAlignment = NSTextAlignmentCenter;
    stateLabel.layer.cornerRadius = 5;
    stateLabel.layer.masksToBounds = YES;
    stateLabel.layer.borderWidth = 1;
    if ([dic[@"statuName"] isEqualToString:@"未通过"] ||
        [dic[@"statuName"] isEqualToString:@"拒绝"])
    {
        stateLabel.layer.borderColor = [UIColor hexChangeFloat:@"e93a3b"].CGColor;
        stateLabel.textColor = [UIColor hexChangeFloat:@"e93a3b"];
    }
    else  if ([dic[@"statuName"] isEqualToString:@"审核中"]) {
        stateLabel.layer.borderColor = [UIColor hexChangeFloat:@"00aff0"].CGColor;
        stateLabel.textColor = [UIColor hexChangeFloat:@"00aff0"];
    }
    else  if ([dic[@"statuName"] isEqualToString:@"已通过"]) {
        stateLabel.layer.borderColor = [UIColor hexChangeFloat:@"24c180"].CGColor;
        stateLabel.textColor = [UIColor hexChangeFloat:@"24c180"];
    }
    else
    {
        stateLabel.layer.borderColor = [UIColor hexChangeFloat:@"e93a3b"].CGColor;
        stateLabel.textColor = [UIColor hexChangeFloat:@"e93a3b"];
    }
    stateLabel.text = dic[@"statuName"];
    [self.contentView addSubview:stateLabel];
    
    //时间
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, CGRectGetMinY(addressLabel.frame), SCREEN_WIDTH/2-10, 20)];
    timeLabel.font = Default_Font_14;
    timeLabel.textColor = [UIColor hexChangeFloat:@"9fa0a0"];
    timeLabel.textAlignment = NSTextAlignmentRight;
    NSTimeInterval timeNum = [[NSDate date] timeIntervalSince1970];
    NSInteger aTimer = timeNum - [dic[@"applicantTime"] integerValue];
    if (aTimer/60 < 5)
    {
        timeLabel.text = @"刚刚";
    }
    else if (aTimer/60 < 60)
    {
        timeLabel.text = [NSString stringWithFormat:@"%d分钟前", (int)aTimer/60];
    }
    else if (aTimer/3600 < 2)
    {
        timeLabel.text = @"1小时前";
    }
    else if (aTimer/3600 < 24)
    {
        timeLabel.text = [NSString stringWithFormat:@"%d小时前", (int)aTimer/3600];
    }
    else if (aTimer/3600 < 48)
    {
        timeLabel.text = @"昨天";
    }
    else if (aTimer/60 < 72)
    {
        timeLabel.text = @"前天";
    }
    else
    {
        NSDate  *date = [NSDate dateWithTimeIntervalSince1970:[dic[@"applicantTime"] integerValue]];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
        timeLabel.text = [dateFormatter stringFromDate:date];
    }
    
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
