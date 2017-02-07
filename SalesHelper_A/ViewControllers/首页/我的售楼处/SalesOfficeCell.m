//
//  SalesOfficeCell.m
//  SalesHelper_A
//
//  Created by flysss on 16/5/3.
//  Copyright © 2016年 X. All rights reserved.
//

#import "SalesOfficeCell.h"
#import "UIColor+Extend.h"

@implementation SalesOfficeCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.choosenBtn = [[UIButton alloc]initWithFrame:CGRectMake(5, 35, 20,20)];
        [self.choosenBtn setImage:[UIImage imageNamed:@"未选中.png"] forState:UIControlStateNormal];
        [self.choosenBtn setImage:[UIImage imageNamed:@"选中.png"] forState:UIControlStateSelected];
        [self.contentView addSubview:self.choosenBtn];
        
        self.buildingShowImageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.choosenBtn.frame)+5, 7, 100, 80)];
        [self.contentView addSubview:self.buildingShowImageView ];

        self.d = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.choosenBtn.frame)+117-15, 90-15, 13, 14)];
        [self.contentView addSubview:self.d];
        
        
        self.smallPicLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.choosenBtn.frame)+7, 7, 18, 18)];
        self.smallPicLabel1.textColor = [UIColor whiteColor];
        self.smallPicLabel1.font = Default_Font_13;
        self.smallPicLabel1.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.smallPicLabel1];
        self.smallPicLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.choosenBtn.frame)+25,7, 18, 18)];
        self.smallPicLabel2.textColor = [UIColor whiteColor];
        self.smallPicLabel2.font = Default_Font_13;
        self.smallPicLabel2.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.smallPicLabel2];
        self.communityName = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.choosenBtn.frame)+115, 5, 100, 20)];
        self.communityName.textColor = [UIColor blackColor];
        self.communityName.font = Default_Font_15;
        [self.contentView addSubview:self.communityName];
        
        self.commissionPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.communityName.frame)+15, 5, 120, 20)];
//        self.commissionPriceLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.commissionPriceLabel];
        self.commissionPriceLabel.textColor = [UIColor redColor];
        self.commissionPriceLabel.font = Default_Font_15;
        self.yongImg= [[UIImageView alloc]init];
        [self.contentView addSubview:self.yongImg];

        self.averagePrice = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.choosenBtn.frame)+115, 30, 150, 15)];
        [self.contentView addSubview:self.averagePrice];
        
        
        self.tagesLab1 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.choosenBtn.frame)+115, 52, 40, 10)];
        self.tagesLab1.textColor = [UIColor hexChangeFloat:KHuiseColor];
        self.tagesLab1.font = Default_Font_12;
        [self.contentView addSubview:self.tagesLab1];
        
        self.tagesLab2 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.choosenBtn.frame)+155, 52, 40, 10)];
        self.tagesLab2.textColor = [UIColor hexChangeFloat:KHuiseColor];
        self.tagesLab2.font = Default_Font_12;
        [self.contentView addSubview:self.tagesLab2];
        
        self.tagesLab3 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.choosenBtn.frame)+195, 52, 40, 10)];
        self.tagesLab3.textColor = [UIColor hexChangeFloat:KHuiseColor];
        self.tagesLab3.font = Default_Font_12;
        [self.contentView addSubview:self.tagesLab3];
        
        self.tagesLab4 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.choosenBtn.frame)+235, 52, 40, 10)];
        self.tagesLab4.textColor = [UIColor hexChangeFloat:KHuiseColor];
        self.tagesLab4.font = Default_Font_12;
        [self.contentView addSubview:self.tagesLab4];
        
        self.tagesLab5 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.choosenBtn.frame)+275, 52, 40, 10)];
        self.tagesLab5.textColor = [UIColor hexChangeFloat:KHuiseColor];
        self.tagesLab5.font = Default_Font_12;
        [self.contentView addSubview:self.tagesLab5];
        //增加物业类型
        self.tenementLab1 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.choosenBtn.frame)+115,72,40,15)];
        self.tenementLab1.layer.borderColor = [UIColor hexChangeFloat:@"00aff0"].CGColor;
        self.tenementLab1.layer.borderWidth = 0.5f;
        self.tenementLab1.layer.cornerRadius = 4;
        self.tenementLab1.layer.masksToBounds = YES;
        self.tenementLab1.font = Default_Font_11;
        self.tenementLab1.textAlignment = NSTextAlignmentCenter;
        self.tenementLab1.textColor = [UIColor hexChangeFloat:@"00aff0"];
        [self.contentView addSubview:self.tenementLab1];
        
        self.tenementLab2 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.choosenBtn.frame)+160,72,40,15)];
        self.tenementLab2.layer.borderColor = [UIColor hexChangeFloat:@"00aff0"].CGColor;
        self.tenementLab2.layer.borderWidth = 0.5f;
        self.tenementLab2.layer.cornerRadius = 4;
        self.tenementLab2.layer.masksToBounds = YES;
        self.tenementLab2.font = Default_Font_11;
        self.tenementLab2.textAlignment = NSTextAlignmentCenter;
        self.tenementLab2.textColor = [UIColor hexChangeFloat:@"00aff0"];
        [self.contentView addSubview:self.tenementLab2];
        
        self.tenementLab3 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.choosenBtn.frame)+205,72,40,15)];
        self.tenementLab3.layer.borderColor = [UIColor hexChangeFloat:@"00aff0"].CGColor;
        self.tenementLab3.layer.borderWidth = 0.5f;
        self.tenementLab3.layer.cornerRadius = 4;
        self.tenementLab3.layer.masksToBounds = YES;
        self.tenementLab3.font = Default_Font_11;
        self.tenementLab3.textAlignment = NSTextAlignmentCenter;
        self.tenementLab3.textColor = [UIColor hexChangeFloat:@"00aff0"];
        [self.contentView addSubview:self.tenementLab3];
        
        self.tenementLab4 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.choosenBtn.frame)+250,72,40,15)];
        self.tenementLab4.layer.borderColor = [UIColor hexChangeFloat:@"00aff0"].CGColor;
        self.tenementLab4.layer.borderWidth = 0.5f;
        self.tenementLab4.layer.cornerRadius = 4;
        self.tenementLab4.layer.masksToBounds = YES;
        self.tenementLab4.font = Default_Font_11;
        self.tenementLab4.textAlignment = NSTextAlignmentCenter;
        self.tenementLab4.textColor = [UIColor hexChangeFloat:@"00aff0"];
        [self.contentView addSubview:self.tenementLab4];
        
    }
    return self;
}
-(void)setAttributeForCell:(NSDictionary*)dict{
    
    if (dict[@"imageUrl"] !=nil)
    {
        
        NSURL* url = [NSURL URLWithString:[REQUEST_IMG_SERVER_URL stringByAppendingString:dict[@"imageUrl"]]];
        [self.buildingShowImageView  sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"房源默认图.png"]];
    }
    if ([dict objectForKey:@"id"])
    {
        self.ID = dict[@"id"];
    }
    
    if ([[dict objectForKey:@"isDeposit"] boolValue]) {
        self.d.hidden = NO;
        self.d.image = [UIImage imageNamed:@"销邦-首页-房源-认证.png"];
    }else{
        self.d.hidden = YES;
    }
    
    if (([dict objectForKey:@"dname"] && [dict objectForKey:@"dname"] !=[NSNull null] && [dict objectForKey:@"dname"] !=nil))
    {
        self.tagesLab1.text = [dict objectForKey:@"dname"];
    }
    if (([dict objectForKey:@"propertyTages"] && [dict objectForKey:@"propertyTages"] !=[NSNull null] && [dict objectForKey:@"propertyTages"] !=nil))
    {
        
        NSInteger count = [[dict objectForKey:@"propertyTages"] count];
        //        NSLog(@"count=%d-%@",count,[dict objectForKey:@"propertyTages"]);
        if (count ==1)
        {
            self.tagesLab2.text = [dict objectForKey:@"propertyTages"][0][@"tage"];
            self.tagesLab3.hidden = YES;
            self.tagesLab4.hidden = YES;
        }else if (count == 2)
        {
            self.tagesLab2.text = [dict objectForKey:@"propertyTages"][0][@"tage"];
            self.tagesLab3.text = [dict objectForKey:@"propertyTages"][1][@"tage"];
            self.tagesLab3.hidden = NO;
            self.tagesLab4.hidden = YES;
        }else if (count >= 3)
        {
            self.tagesLab2.text = [dict objectForKey:@"propertyTages"][0][@"tage"];
            self.tagesLab3.text = [dict objectForKey:@"propertyTages"][1][@"tage"];
            self.tagesLab4.text = [dict objectForKey:@"propertyTages"][2][@"tage"];
            self.tagesLab3.hidden = NO;
            self.tagesLab4.hidden = NO;
        }
        
    }
    
    if (([dict objectForKey:@"estateLines"] && [dict objectForKey:@"estateLines"] != [NSNull null] && [dict objectForKey:@"estateLines"] != nil))
    {
        NSInteger  numCount = [[dict objectForKey:@"estateLines"] count];
        //        NSLog(@"num=%d-%@",numCount,[dict objectForKey:@"estateLines"]);
        if (numCount == 1)
        {
            self.tenementLab1.text = [dict objectForKey:@"estateLines"][0][@"name"];
            self.tenementLab2.hidden = YES;
            self.tenementLab3.hidden = YES;
            self.tenementLab4.hidden = YES;
        }else if (numCount == 2)
        {
            self.tenementLab1.text = [dict objectForKey:@"estateLines"][0][@"name"];
            self.tenementLab2.text = [dict objectForKey:@"estateLines"][1][@"name"];
            self.tenementLab2.hidden = NO;
            self.tenementLab3.hidden = YES;
            self.tenementLab4.hidden = YES;
        }else if (numCount == 3)
        {
            
            self.tenementLab1.text = [dict objectForKey:@"estateLines"][0][@"name"];
            self.tenementLab2.text = [dict objectForKey:@"estateLines"][1][@"name"];
            self.tenementLab3.text = [dict objectForKey:@"estateLines"][2][@"name"];
            self.tenementLab2.hidden = NO;
            self.tenementLab3.hidden = NO;
            self.tenementLab4.hidden = YES;
        }else if (numCount >= 4)
        {
            self.tenementLab1.text = [dict objectForKey:@"estateLines"][0][@"name"];
            self.tenementLab2.text = [dict objectForKey:@"estateLines"][1][@"name"];
            self.tenementLab3.text = [dict objectForKey:@"estateLines"][2][@"name"];
            self.tenementLab4.text = [dict objectForKey:@"estateLines"][3][@"name"];
            self.tenementLab2.hidden = NO;
            self.tenementLab3.hidden = NO;
            self.tenementLab4.hidden = NO;
        }
        
    }else{
        self.tenementLab1.hidden = YES;
        self.tenementLab2.hidden = YES;
        self.tenementLab3.hidden = YES;
        self.tenementLab4.hidden = YES;
    }
    
    if (([dict objectForKey:@"xjjLabelLines"] && [dict objectForKey:@"xjjLabelLines"] != [NSNull null] && [dict objectForKey:@"xjjLabelLines"] != nil))
    {
        NSArray * array = [dict objectForKey:@"xjjLabelLines"];
        
        if (array.count > 0)
        {
            self.smallPicLabel1.hidden = NO;
            self.smallPicLabel1.text = [array[0] objectForKey:@"name"];
            self.smallPicLabel1.backgroundColor = [ProjectUtil colorWithHexString:[array[0] objectForKey:@"color"]];
            
            if (array.count == 2)
            {
                self.smallPicLabel2.hidden = NO;
                self.smallPicLabel2.text = [array[1] objectForKey:@"name"];
                self.smallPicLabel2.backgroundColor = [ProjectUtil colorWithHexString:[array[1] objectForKey:@"color"]];
            }
        }
    }else
    {
        self.smallPicLabel1.hidden = YES;
        self.smallPicLabel2.hidden = YES;
    }    if ([dict objectForKey:@"name"]) {
        
        self.communityName.text = [dict objectForKey:@"name"];
//        CGFloat x = [self.communityName.text boundingRectWithSize:CGSizeMake(0, 20) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:Default_Font_15} context:nil].size.width;
//        self.communityName.frame = CGRectMake(CGRectGetMaxX(self.choosenBtn.frame)+115, 5, x+10, 20);
    
        
        
    }
    //佣金
    if ([dict  objectForKey:@"priceRemark"])
    {
        if ((GetOrgCode != nil )
            && GetUserID != nil )
        {
            self.commissionPriceLabel.text = [NSString stringWithFormat:@"%@",[dict  objectForKey:@"priceRemark"] ];
            CGFloat x = [self.commissionPriceLabel.text boundingRectWithSize:CGSizeMake(0, 20) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:Default_Font_15} context:nil].size.width;
             self.yongImg.frame=CGRectMake(CGRectGetMaxX(self.communityName.frame)-5, 8, 15, 15);
            self.commissionPriceLabel.textColor = [UIColor hexChangeFloat:@"ff5f66"];
            self.commissionPriceLabel.frame = CGRectMake(CGRectGetMaxX(self.communityName.frame)+10, 8, x, 15);
            self.yongImg.image = [UIImage imageNamed:@"销邦-首页-房源-佣.png"];
        }
        if (GetOrgCode ==nil || GetUserID == nil)
        {
            self.commissionPriceLabel.text = @"登录后查看";
            self.commissionPriceLabel.textColor = [UIColor hexChangeFloat:KGrayColor];
            self.commissionPriceLabel.font = Default_Font_12;
            
            self.yongImg.frame = CGRectMake(CGRectGetMaxX(self.commissionPriceLabel.frame)-75, 8, 15, 15);
            self.yongImg.image = [UIImage imageNamed:@"销邦-首页-房源-佣.png"];
        }
        if (GetUserID != nil && GetOrgCode == nil )
        {
            
            self.commissionPriceLabel.text = @"无权限查看";
            self.commissionPriceLabel.textColor = [UIColor hexChangeFloat:KGrayColor];
            self.commissionPriceLabel.font = Default_Font_12;
            self.yongImg.frame = CGRectMake(CGRectGetMaxX(self.commissionPriceLabel.frame)-75, 8, 15, 15);
            self.yongImg.image = [UIImage imageNamed:@"销邦-首页-房源-佣.png"];
        }
    }
    if ([dict objectForKey:@"price"])
    {
        self.averagePrice.text = [NSString stringWithFormat:@"均价%@元/平米",[dict objectForKey:@"price"]];
        self.averagePrice.textColor = [UIColor hexChangeFloat:KHuiseColor];
        self.averagePrice.font = Default_Font_13;
        
    }
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}


- (void)awakeFromNib
{
    
    
    
    
    
    
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
