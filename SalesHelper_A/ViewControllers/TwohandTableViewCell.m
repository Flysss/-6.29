//
//  TwohandTableViewCell.m
//  SalesHelper_A
//
//  Created by Brant on 16/1/7.
//  Copyright (c) 2016年 X. All rights reserved.
//

#import "TwohandTableViewCell.h"
#import "UIColor+Extend.h"

@implementation TwohandTableViewCell


- (void)awakeFromNib {
    // Initialization code
}

- (void)configTableCellWithDic:(NSDictionary *)dic
{
    //头像
    UIImageView *headImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 13, 100, 74)];
    headImage.image = [UIImage imageNamed:@"pp_bg"];
    headImage.clipsToBounds = YES;
    headImage.contentMode = UIViewContentModeScaleAspectFill;
    if (dic[@"iamge"] != nil &&
        dic[@"iamge"] != [NSNull null] &&
        dic[@"iamge"]
        )
    {
        [headImage sd_setImageWithURL:[NSURL URLWithString:dic[@"iamge"]] placeholderImage:[UIImage imageNamed:@"pp_bg"]];
    }
   
    [self.contentView addSubview:headImage];
    
    //标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(headImage.frame)+8, 13, SCREEN_WIDTH-28-100, 20)];
    titleLabel.text = dic[@"topic"];
    titleLabel.textColor = [UIColor hexChangeFloat:KBlackColor];
    titleLabel.font = Default_Font_16;
//    titleLabel.numberOfLines = 2;
    [self.contentView addSubview:titleLabel];
    //数据
    UILabel *bujuLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(headImage.frame)+8,35, SCREEN_WIDTH-100-18-70, 15)];
    bujuLabel.textColor = [UIColor hexChangeFloat:KGrayColor];
    bujuLabel.font = Default_Font_12;
    bujuLabel.text = [NSString stringWithFormat:@"%@ %@室%@厅", dic[@"plot"], dic[@"shi"], dic[@"ting"]];
    [self.contentView addSubview:bujuLabel];
    
    //价格
    CGFloat jiaqian = [dic[@"mianji"] floatValue] * [dic[@"danjia"] floatValue];
    UILabel *jiageLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-70, CGRectGetMaxY(titleLabel.frame)+3, 60, 20)];
    jiageLabel.textAlignment = NSTextAlignmentRight;
    NSString *str;
    if (jiaqian>=10000)
    {
        str = [NSString stringWithFormat:@"%.f万", jiaqian/10000];
    } else {
        str = [NSString stringWithFormat:@"%.f元", jiaqian];
    }
    
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:str];
    //富文本样式
    //文字颜色
    [attributeStr addAttribute:NSForegroundColorAttributeName
                         value:[UIColor hexChangeFloat:@"db393b"]
                         range:NSMakeRange(0, [str length]-1)];
    //文字字体
    [attributeStr addAttribute:NSFontAttributeName
                         value:Default_Font_20
                         range:NSMakeRange(0, [str length]-1)];
    //文字颜色
    [attributeStr addAttribute:NSForegroundColorAttributeName
                         value:[UIColor hexChangeFloat:@"727171"]
                         range:NSMakeRange([str length]-1, 1)];
    //文字字体
    [attributeStr addAttribute:NSFontAttributeName
                         value:Default_Font_13
                         range:NSMakeRange([str length]-1, 1)];
    
    jiageLabel.attributedText = attributeStr;
    [self.contentView addSubview:jiageLabel];
    
    
    NSArray *strarrray = [NSArray array];
    if (dic[@"tages"] != nil &&
        dic[@"tages"] != [NSNull null] &&
        [dic[@"tages"] count] > 0
        )
    {
       strarrray = dic[@"tages"];
        CGFloat lablew;
        lablew = 0;
        //类别
        NSInteger  tagesNum = strarrray.count;
        if (SCREEN_WIDTH==320)
        {
            if (tagesNum > 3) {
                tagesNum = 3;
            }
        } else if (SCREEN_WIDTH == 375 || SCREEN_WIDTH == 414)
        {
            if (tagesNum > 4) {
                tagesNum = 4;
            }
        }
        else
        {
            
        }
        for (int i = 0; i < tagesNum; i++)
        {
            CGFloat labelwww = [strarrray[i][@"name"] boundingRectWithSize:CGSizeMake(0, 15) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:Default_Font_12} context:nil].size.width;
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(115+lablew+4, CGRectGetMaxY(bujuLabel.frame)+5, labelwww+5, 15)];
            label.text = strarrray[i][@"name"];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = Default_Font_12;
            label.layer.cornerRadius = 5;
            label.layer.masksToBounds = YES;
            label.layer.borderWidth = 0.5;
            [self.contentView addSubview:label];
            
            if (strarrray[i][@"color"] != nil &&
                strarrray[i][@"color"] != [NSNull null] &&
                strarrray[i][@"color"]
                )
            {
                label.textColor = [UIColor hexChangeFloat:strarrray[i][@"color"]];
                label.layer.borderColor = [UIColor hexChangeFloat:strarrray[i][@"color"]].CGColor;
            }
            
            lablew = labelwww+5 + lablew+4;
        }
    }
    
    UILabel * tradeArea = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(headImage.frame)+8, CGRectGetMaxY(bujuLabel.frame)+25, SCREEN_WIDTH-130, 15)];
    tradeArea.textColor = [UIColor hexChangeFloat:KGrayColor];
    tradeArea.font = Default_Font_11;
    if (dic[@"isShangQuanname"] != nil &&
        dic[@"isShangQuanname"] != [NSNull null] &&
        dic[@"isShangQuanname"])
    {
        tradeArea.text =[NSString stringWithFormat:@"附近商圈:%@",dic[@"isShangQuanname"]];
    }
    else
    {
        tradeArea.text = @"";
    }
    [self.contentView addSubview:tradeArea];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
