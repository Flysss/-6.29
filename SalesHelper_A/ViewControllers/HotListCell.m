//
//  HotListCell.m
//  SalesHelper_A
//
//  Created by flysss on 16/5/17.
//  Copyright © 2016年 X. All rights reserved.
//

#import "HotListCell.h"
#import "UIColor+Extend.h"

@implementation HotListCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.headImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 60, 60)];
        self.headImg.layer.cornerRadius = 30;
        self.headImg.layer.masksToBounds = YES;
        [self.contentView addSubview:self.headImg];
        
        self.nameLab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.headImg.frame)+10, 15,50, 20)];
        self.nameLab.font = Default_Font_15;
        self.nameLab.textColor = [UIColor hexChangeFloat:KBlackColor];
        [self.contentView addSubview:self.nameLab];
        
//        self.genderLab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.nameLab.frame)+5, 17, 15, 15)];
//        self.genderLab.font = Default_Font_12;
//        self.genderLab.textAlignment = NSTextAlignmentCenter;
//        self.genderLab.textColor = [UIColor hexChangeFloat:KBlackColor];
//        self.genderLab.layer.cornerRadius = 8.0f;
//        self.genderLab.layer.masksToBounds = YES;
//        self.genderLab.layer.borderColor = [UIColor hexChangeFloat:KBlackColor].CGColor;
//        self.genderLab.layer.borderWidth  = 0.5;
//        [self.contentView addSubview:self.genderLab];
        
        self.genderImg = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.nameLab.frame)+5, 19, 11, 11)];
        [self.contentView addSubview:self.genderImg];
        
        self.phoneLab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.headImg.frame)+10, CGRectGetMaxY(self.nameLab.frame)+17, 200, 15)];
        self.phoneLab.font = Default_Font_13;
        self.phoneLab.textColor = [UIColor hexChangeFloat:KGrayColor];
        [self.contentView addSubview:self.phoneLab];
        
        self.numberLab = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-70, 20, 60, 40)];
        self.numberLab.numberOfLines = 0;
        self.numberLab.font = Default_Font_11;
        self.numberLab.textAlignment = NSTextAlignmentRight;
        self.numberLab.textColor = [UIColor hexChangeFloat:KGrayColor];
        [self.contentView addSubview:self.numberLab];

        
//        self.messageBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-50, 20, 40, 40)];
//        [self.messageBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
//        [self.messageBtn addTarget:self action:@selector(ClickToSendMessage:) forControlEvents:UIControlEventTouchUpInside];
//        [self.contentView addSubview:self.messageBtn];
//        
//        self.sympolImg = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-30, 30, 20, 20)];
//        self.sympolImg.hidden = YES;
//        [self.contentView addSubview:self.sympolImg];
        
    }
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    return self;
}

-(void)setAttributeForCellWithDictionary:(NSDictionary *)dict
{
    
    
    if (dict[@"name"] != [NSNull null])
    {
        if ([dict[@"name"] length])
        {
           NSString * subStr = [dict[@"name"] substringToIndex:1];
           self.nameLab.text = [NSString stringWithFormat:@"%@**",subStr];
        }
        else
        {
            self.nameLab.text = @"匿名";
        }
        
    }else
    {
        self.nameLab.text = @"匿名";
    }
    CGFloat  width = [self.nameLab.text boundingRectWithSize:CGSizeMake(0, 20) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: Default_Font_15} context:nil].size.width;
    self.nameLab.frame = CGRectMake(CGRectGetMaxX(self.headImg.frame)+10, 15,width+10, 20);
    self.genderImg.frame = CGRectMake(CGRectGetMaxX(self.nameLab.frame), 19, 15, 15);
    if (dict[@"orgname"] != [NSNull null])
    {
        self.phoneLab.text = dict[@"orgname"];
    }
    if (dict[@"sex"] != [NSNull null])
    {
        if ([dict[@"sex"] floatValue] == 0)
        {
           
            self.genderImg.image = [UIImage imageNamed:@"grymxbn-2"];
        }
        else
        {
            self.genderImg.image = [UIImage imageNamed:@"grymxb2-1"];
        }
    }
    if (dict[@"face"] != [NSNull null])
    {
        [self.headImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",Image_Url,dict[@"face"]]] placeholderImage:[UIImage imageNamed:@"toux.png"]];
    }
    else
    {
        self.headImg.image = [UIImage imageNamed:@"toux.png"];
    }
    if (dict[@"counts"])
    {

    self.numberLab.text = [NSString stringWithFormat:@"%@组\n已成交",dict[@"counts"]];

    NSMutableAttributedString * aAttributedString = [[NSMutableAttributedString alloc] initWithString:self.numberLab.text];
    //富文本样式
    [aAttributedString addAttribute:NSForegroundColorAttributeName  //文字颜色
                              value:[UIColor hexChangeFloat:@"ff5f66"]
                              range:NSMakeRange(0, self.numberLab.text.length-5)];
    
    [aAttributedString addAttribute:NSFontAttributeName             //文字字体
                              value:[UIFont systemFontOfSize:18]
                              range:NSMakeRange(0, self.numberLab.text.length-5)];
    self.numberLab.attributedText = aAttributedString;
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
