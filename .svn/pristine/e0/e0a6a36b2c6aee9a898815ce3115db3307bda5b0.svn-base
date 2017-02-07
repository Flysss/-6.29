//
//  SelectClientTableViewCell.m
//  SalesHelper_A
//
//  Created by Brant on 16/1/20.
//  Copyright (c) 2016年 X. All rights reserved.
//

#import "SelectClientTableViewCell.h"
#import "UIColor+Extend.h"

@implementation SelectClientTableViewCell

- (void)configTableViewCellWithDic:(NSDictionary *)dic
{
    //姓名
    NSString *nameStr = dic[@"name"];
    CGFloat nameW = [nameStr boundingRectWithSize:CGSizeMake(0, 20) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:Default_Font_16} context:nil].size.width;
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 13, nameW, 20)];
    nameLabel.textColor = [UIColor hexChangeFloat:KBlackColor];
    nameLabel.font = Default_Font_16;
    nameLabel.text = nameStr;
    [self.contentView addSubview:nameLabel];
    
    //号码
    UILabel *phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(nameLabel.frame)+10, CGRectGetMinY(nameLabel.frame), 120, 20)];
    phoneLabel.font = Default_Font_14;
    phoneLabel.textColor = [UIColor hexChangeFloat:KGrayColor];
    phoneLabel.text = dic[@"phone"];
    [self.contentView addSubview:phoneLabel];
    
    //地点
    UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(nameLabel.frame)+10, SCREEN_WIDTH/2-10, 20)];
    addressLabel.font = Default_Font_15;
    addressLabel.textColor = [UIColor hexChangeFloat:KGrayColor];
    addressLabel.text = dic[@"propertyName"];
    [self.contentView addSubview:addressLabel];
    
    //状态
    UILabel *stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-100, CGRectGetMinY(nameLabel.frame), 90, 20)];
    stateLabel.font = Default_Font_15;
    stateLabel.textAlignment = NSTextAlignmentRight;
    if (dic[@"stepColor"] != nil &&
        dic[@"stepColor"] != [NSNull null] &&
        dic[@"stepColor"])
    {
        stateLabel.textColor = [UIColor hexChangeFloat:dic[@"stepColor"]];
    }
    stateLabel.text = dic[@"newStepName"];
    [self.contentView addSubview:stateLabel];
    
    //时间
    UILabel * timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, CGRectGetMinY(addressLabel.frame), SCREEN_WIDTH/2-10, 20)];
    timeLabel.font = Default_Font_14;
    timeLabel.textAlignment = NSTextAlignmentRight;
    timeLabel.textColor = [UIColor hexChangeFloat:KGrayColor];
    timeLabel.text = dic[@"refereeDate"];
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
