//
//  HouseSourceCell.m
//  SalesHelper_A
//
//  Created by flysss on 16/5/4.
//  Copyright © 2016年 X. All rights reserved.
//

#import "HouseSourceCell.h"
#import "UIColor+Extend.h"

@implementation HouseSourceCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.unitLab = [[UILabel alloc]init];
        self.unitLab.textColor = [UIColor hexChangeFloat:KBlackColor];
        self.unitLab.font = Default_Font_15;
        self.unitLab.frame = CGRectMake(10, 7, 150, 20);
        [self.contentView addSubview:self.unitLab];
        
        self.houseGroupLab = [[UILabel alloc]init];
        self.houseGroupLab.textColor = [UIColor hexChangeFloat:KHuiseColor];
        self.houseGroupLab.font = Default_Font_13;
        self.houseGroupLab.frame = CGRectMake(10, CGRectGetMaxY(self.unitLab.frame)+5, 140, 15);
        [self.contentView addSubview:self.houseGroupLab];
        
        self.flotLab = [[UILabel alloc]init];
        self.flotLab.textColor = [UIColor hexChangeFloat:KHuiseColor];
        self.flotLab.font = Default_Font_13;
        self.flotLab.frame = CGRectMake(CGRectGetMaxX(self.houseGroupLab.frame)+5, CGRectGetMaxY(self.unitLab.frame)+5, 30, 15);
        [self.contentView addSubview:self.flotLab];
        
        self.saleStateLab = [[UILabel alloc]init];
        self.saleStateLab.font = Default_Font_14;
        self.saleStateLab.layer.cornerRadius = 5.0f;
        self.saleStateLab.layer.masksToBounds = YES;
        self.saleStateLab.frame = CGRectMake(SCREEN_WIDTH-55, 20, 45, 20);
        self.saleStateLab.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.saleStateLab];
        
    }
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    return self;
}

-(void)setAttributeForCellWithData:(NSDictionary *)dict

{
    
    if (dict[@"danYuan"] != [NSNull null] && dict[@"num"] != [NSNull null])
    {
        self.unitLab.text = [NSString stringWithFormat:@"%@单元 %@室",dict[@"danYuan"],dict[@"num"]];
    }
    
    if (dict[@"topic"] != [NSNull null] && dict[@"topic"] != nil && dict[@"topic"] )
    {
        self.houseGroupLab.text = dict[@"topic"];
        
//        CGFloat width = [dict[@"topic"] boundingRectWithSize:CGSizeMake(0, 15) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size.width;
        CGFloat width = [self.houseGroupLab.text boundingRectWithSize:CGSizeMake(0, 15) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:nil context:nil].size.width;
        self.houseGroupLab.frame = CGRectMake(10, CGRectGetMaxY(self.unitLab.frame)+5, width + 10 , 15);
    }
    
    if (dict[@"lnum"] != [NSNull null] && dict[@"lnum"] != nil && dict[@"lnum"]) {
        self.flotLab.text =[NSString stringWithFormat:@"%@栋",dict[@"lnum"]];
        self.flotLab.frame = CGRectMake(CGRectGetMaxX(self.houseGroupLab.frame)+5, CGRectGetMaxY(self.unitLab.frame)+5, 30, 15);
    }
    if (dict[@"isState"] != [NSNull null] && dict[@"isState"] != nil && dict[@"isState"])
    {
       if ([dict[@"isState"] integerValue] == 2)
       {
        self.saleStateLab.text = @"不可售";
        self.saleStateLab.textColor = [UIColor redColor];
        self.saleStateLab.layer.borderColor = [UIColor redColor].CGColor;
        self.saleStateLab.layer.borderWidth = 0.5f;
        
        }
        else if ([dict[@"isState"] integerValue] == 1)
        {
        self.saleStateLab.text = @"可售";
        self.saleStateLab.textColor = [UIColor greenColor];
        self.saleStateLab.layer.borderColor = [UIColor greenColor].CGColor;
        self.saleStateLab.layer.borderWidth = 0.5f;
        }
        
    }
}




- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
