//
//  HomeTabViewCell.m
//  SalesHelper_A
//
//  Created by flysss on 16/2/17.
//  Copyright © 2016年 X. All rights reserved.
//

#import "HomeTabViewCell.h"
#import "UIColor+Extend.h"

@implementation HomeTabViewCell


//-(void)setCounts:(NSInteger)counts
//{
//    self.counts = counts;
//}
//-(NSInteger)counts
//{
//    return self.counts;
//}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
       self.buildingShowImageView = [[UIImageView alloc]initWithFrame:CGRectMake(12, 12, 110, 76)];
        [self.contentView addSubview:self.buildingShowImageView ];
//        self.signedCount = [[UILabel alloc]initWithFrame:CGRectMake(10,90-14, 80, 11)];
//        self.signedCount.textColor = [UIColor whiteColor];
//        self.signedCount.font = [UIFont systemFontOfSize:9];
//        [self.contentView addSubview:self.signedCount];
        self.d = [[UIImageView alloc]initWithFrame:CGRectMake(122-15, 73, 13, 14)];
        [self.contentView addSubview:self.d];
        
        self.smallPicLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(12, 12, 18, 18)];
        self.smallPicLabel1.textColor = [UIColor whiteColor];
        self.smallPicLabel1.font = Default_Font_13;
        self.smallPicLabel1.textAlignment = NSTextAlignmentCenter;
         [self.contentView addSubview:self.smallPicLabel1];
        self.smallPicLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(30, 12, 18, 18)];
        self.smallPicLabel2.textColor = [UIColor whiteColor];
        self.smallPicLabel2.font = Default_Font_13;
        self.smallPicLabel2.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.smallPicLabel2];
        self.communityName = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.buildingShowImageView.frame)+10, 9,95*SCREEN_WIDTH/320, 20)];
        self.communityName.textColor = [UIColor blackColor];
        self.communityName.font = Default_Font_15;
        [self.contentView addSubview:self.communityName];
        
        self.commissionPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-130, 9, 80*SCREEN_WIDTH/320, 20)];
//        self.commissionPriceLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.commissionPriceLabel];
        self.commissionPriceLabel.textColor = [UIColor redColor];
        self.commissionPriceLabel.font = Default_Font_15;
        self.yongImg= [[UIImageView alloc]init];
        [self.contentView addSubview:self.yongImg];
        
//        self.averageImg  = [[UIImageView alloc]initWithFrame:CGRectMake(120, 30, 15, 15)];
//        [self.contentView addSubview:self.averageImg];
        self.averagePrice = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.buildingShowImageView.frame)+10, 35, 150, 15)];
        [self.contentView addSubview:self.averagePrice];
        
//        self.allowanceImg  = [[UIImageView alloc]initWithFrame:CGRectMake(120, 50, 13, 13)];
//        [self.contentView addSubview:self.allowanceImg];
        //删除购房金
//        self.allowanceLabel = [[UILabel alloc]initWithFrame:CGRectMake(140, 47, 150, 15)];
//        [self.contentView addSubview:self.allowanceLabel];
    
        self.tagesLab1 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.buildingShowImageView.frame)+10, CGRectGetMaxY(self.averagePrice.frame)+5, 40, 10)];
        self.tagesLab1.textColor = [UIColor hexChangeFloat:KHuiseColor];
        self.tagesLab1.font = Default_Font_12;
        [self.contentView addSubview:self.tagesLab1];
        
        self.tagesLab2 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.buildingShowImageView.frame)+10+40, CGRectGetMaxY(self.averagePrice.frame)+5, 40, 10)];
        self.tagesLab2.textColor = [UIColor hexChangeFloat:KHuiseColor];
        self.tagesLab2.font = Default_Font_12;
        [self.contentView addSubview:self.tagesLab2];
        
        self.tagesLab3 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.buildingShowImageView.frame)+10+80, CGRectGetMaxY(self.averagePrice.frame)+5, 40, 10)];
        self.tagesLab3.textColor = [UIColor hexChangeFloat:KHuiseColor];
        self.tagesLab3.font = Default_Font_12;
        [self.contentView addSubview:self.tagesLab3];
        
        self.tagesLab4 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.buildingShowImageView.frame)+10+120, CGRectGetMaxY(self.averagePrice.frame)+5, 40, 10)];
        self.tagesLab4.textColor = [UIColor hexChangeFloat:KHuiseColor];
        self.tagesLab4.font = Default_Font_12;
        [self.contentView addSubview:self.tagesLab4];
        
        self.tagesLab5 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.buildingShowImageView.frame)+10+160, CGRectGetMaxY(self.averagePrice.frame)+5, 40, 10)];
        self.tagesLab5.textColor = [UIColor hexChangeFloat:KHuiseColor];
        self.tagesLab5.font = Default_Font_12;
        [self.contentView addSubview:self.tagesLab5];
        //增加物业类型
        self.tenementLab1 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.buildingShowImageView.frame)+10,72,40,15)];
        self.tenementLab1.layer.masksToBounds = YES;
        self.tenementLab1.layer.borderColor = [UIColor hexChangeFloat:@"00aff0"].CGColor;
        self.tenementLab1.layer.borderWidth = 0.5;
        self.tenementLab1.layer.cornerRadius = 5;
        
        self.tenementLab1.font = Default_Font_11;
        self.tenementLab1.textAlignment = NSTextAlignmentCenter;
        self.tenementLab1.textColor = [UIColor hexChangeFloat:@"00aff0"];
        [self.contentView addSubview:self.tenementLab1];
        
        self.tenementLab2 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.tenementLab1.frame)+5,72,40,15)];
        self.tenementLab2.layer.masksToBounds = YES;
        self.tenementLab2.layer.borderColor = [UIColor hexChangeFloat:@"00aff0"].CGColor;
        self.tenementLab2.layer.borderWidth = 0.5;
        self.tenementLab2.layer.cornerRadius = 5;
        self.tenementLab2.font = Default_Font_11;
        self.tenementLab2.textAlignment = NSTextAlignmentCenter;
        self.tenementLab2.textColor = [UIColor hexChangeFloat:@"00aff0"];
        [self.contentView addSubview:self.tenementLab2];
        
        self.tenementLab3 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.tenementLab2.frame)+5,72,40,15)];
        self.tenementLab3.layer.masksToBounds = YES;
        self.tenementLab3.layer.borderColor = [UIColor hexChangeFloat:@"00aff0"].CGColor;
        self.tenementLab3.layer.borderWidth = 0.5;
        self.tenementLab3.layer.cornerRadius = 5.0;
        self.tenementLab3.font = Default_Font_11;
        self.tenementLab3.textAlignment = NSTextAlignmentCenter;
        self.tenementLab3.textColor = [UIColor hexChangeFloat:@"00aff0"];
        [self.contentView addSubview:self.tenementLab3];
        
        self.tenementLab4 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.tenementLab1.frame)+5,72,40,15)];
        self.tenementLab4.layer.masksToBounds = YES;
        self.tenementLab4.layer.cornerRadius = 5;
        self.tenementLab4.layer.borderColor = [UIColor hexChangeFloat:@"00aff0"].CGColor;
        self.tenementLab4.layer.borderWidth = 0.5;
        self.tenementLab4.font = Default_Font_11;
        self.tenementLab4.textAlignment = NSTextAlignmentCenter;
        self.tenementLab4.textColor = [UIColor hexChangeFloat:@"00aff0"];
        [self.contentView addSubview:self.tenementLab4];
    }
    return self;
}


- (void)awakeFromNib
{
    
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

//        if ([dict objectForKey:@"refereeSum"]) {
//
//            //推荐数为0 则不显示
//            if ([[dict objectForKey:@"refereeSum"] integerValue] != 0)
//            {
//            self.signedCount.text =[NSString stringWithFormat:@"已推荐 %@组",dict[@"refereeSum"]];
//            }
//            else
//            {
//                self.signedCount.hidden = YES;
//            }
//        }

        if ([[dict objectForKey:@"isDeposit"] boolValue]) {
            self.d.hidden = NO;
            self.d.image = [UIImage imageNamed:@"销邦-首页-房源-认证.png"];
        }else{
            self.d.hidden = YES;
        }
    
//        NSMutableArray* array = [NSMutableArray array];
//        [array addObject:[dict objectForKey:@"dname"]];
//        if (([dict objectForKey:@"propertyTages"] && [dict objectForKey:@"propertyTages"] !=[NSNull null] && [dict objectForKey:@"propertyTages"] !=nil))
//        {
//            NSArray* arr = [dict objectForKey:@"propertyTages"];
//            if (arr.count>0)
//            {
//                for (int i=0; i<arr.count; i++)
//                {
//                    if ([arr[i] objectForKey:@"tage"])
//                    {
//                        [array addObject:arr[i][@"tage"]];
//                    }
//                }
//            }
//        }
    
    if (([dict objectForKey:@"dname"] && [dict objectForKey:@"dname"] !=[NSNull null] && [dict objectForKey:@"dname"] !=nil))
    {
        self.tagesLab1.text = [dict objectForKey:@"dname"];
        CGFloat width = [self.tagesLab1.text boundingRectWithSize:CGSizeMake(0, 15) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:Default_Font_11} context:nil].size.width;
        self.tagesLab1.frame = CGRectMake(CGRectGetMaxX(self.buildingShowImageView.frame)+10, CGRectGetMaxY(self.averagePrice.frame)+5, width+10, 10);
        self.tagesLab2.hidden = YES;
        self.tagesLab3.hidden = YES;
        self.tagesLab4.hidden = YES;
    }
    if (([dict objectForKey:@"propertyTages"] && [dict objectForKey:@"propertyTages"] !=[NSNull null] && [dict objectForKey:@"propertyTages"] !=nil))
    {
        
        NSInteger count = [[dict objectForKey:@"propertyTages"] count];
        if (count ==1)
        {
            
            self.tagesLab2.text = [dict objectForKey:@"propertyTages"][0][@"tage"];
            CGFloat width = [self.tagesLab2.text boundingRectWithSize:CGSizeMake(0, 15) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:Default_Font_11} context:nil].size.width;
            self.tagesLab2.frame = CGRectMake(CGRectGetMaxX(self.tagesLab1.frame)+5, CGRectGetMaxY(self.averagePrice.frame)+5, width+10, 10);
             self.tagesLab2.hidden = NO;
            self.tagesLab3.hidden = YES;
            self.tagesLab4.hidden = YES;
        }
        else if (count == 2)
        {
            
            self.tagesLab2.text = [dict objectForKey:@"propertyTages"][0][@"tage"];
            self.tagesLab3.text = [dict objectForKey:@"propertyTages"][1][@"tage"];
            CGFloat width = [self.tagesLab2.text boundingRectWithSize:CGSizeMake(0, 15) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:Default_Font_11} context:nil].size.width;
            self.tagesLab2.frame = CGRectMake(CGRectGetMaxX(self.tagesLab1.frame)+5, CGRectGetMaxY(self.averagePrice.frame)+5, width+10, 10);
            
             CGFloat width1 = [self.tagesLab3.text boundingRectWithSize:CGSizeMake(0, 15) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:Default_Font_11} context:nil].size.width;
            self.tagesLab3.frame = CGRectMake(CGRectGetMaxX(self.tagesLab2.frame)+5, CGRectGetMaxY(self.averagePrice.frame)+5, width1+10, 10);
            
            self.tagesLab2.hidden = NO;
            self.tagesLab3.hidden = NO;
            self.tagesLab4.hidden = YES;
        }else if (count >= 3)
        {
            self.tagesLab2.text = [dict objectForKey:@"propertyTages"][0][@"tage"];
            self.tagesLab3.text = [dict objectForKey:@"propertyTages"][1][@"tage"];
            self.tagesLab4.text = [dict objectForKey:@"propertyTages"][2][@"tage"];
            CGFloat width = [self.tagesLab2.text boundingRectWithSize:CGSizeMake(0, 15) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:Default_Font_11} context:nil].size.width;
            self.tagesLab2.frame = CGRectMake(CGRectGetMaxX(self.tagesLab1.frame)+5, CGRectGetMaxY(self.averagePrice.frame)+5, width+10, 10);
            
            CGFloat width1 = [self.tagesLab3.text boundingRectWithSize:CGSizeMake(0, 15) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:Default_Font_11} context:nil].size.width;
            self.tagesLab3.frame = CGRectMake(CGRectGetMaxX(self.tagesLab2.frame)+5, CGRectGetMaxY(self.averagePrice.frame)+5, width1+10, 10);
            
            CGFloat width2 = [self.tagesLab3.text boundingRectWithSize:CGSizeMake(0, 15) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:Default_Font_11} context:nil].size.width;
            self.tagesLab4.frame = CGRectMake(CGRectGetMaxX(self.tagesLab3.frame)+5, CGRectGetMaxY(self.averagePrice.frame)+5, width2+10, 10);
            
            self.tagesLab3.hidden = NO;
            self.tagesLab4.hidden = NO;
            self.tagesLab2.hidden = NO;
        }else
        {
            self.tagesLab2.hidden = YES;
            self.tagesLab3.hidden = YES;
            self.tagesLab4.hidden = YES;
        }
        
    }else
    {
        self.tagesLab2.hidden = YES;
        self.tagesLab3.hidden = YES;
        self.tagesLab4.hidden = YES;
    }
    
    if (([dict objectForKey:@"estateLines"] && [dict objectForKey:@"estateLines"] != [NSNull null] && [dict objectForKey:@"estateLines"] != nil))
    {
       NSInteger  numCount = [[dict objectForKey:@"estateLines"] count];
//        NSLog(@"num=%d-%@",numCount,[dict objectForKey:@"estateLines"]);
        
        if (numCount == 1)
         {
             CGFloat width = [[dict objectForKey:@"estateLines"][0][@"name"] boundingRectWithSize:CGSizeMake(0, 15) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:Default_Font_11} context:nil].size.width;
//             NSLog(@"width = %f",width);

             self.tenementLab1.text = [dict objectForKey:@"estateLines"][0][@"name"];
             self.tenementLab1.frame = CGRectMake(CGRectGetMaxX(self.buildingShowImageView.frame)+10, 74, width+10, 15);
             self.tenementLab1.hidden = NO;
             self.tenementLab2.hidden = YES;
             self.tenementLab3.hidden = YES;
             self.tenementLab4.hidden = YES;
         }else if (numCount == 2)
         {
             CGFloat width = [[dict objectForKey:@"estateLines"][0][@"name"] boundingRectWithSize:CGSizeMake(0, 15) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:Default_Font_11} context:nil].size.width;
//             NSLog(@"width = %f",width);
           self.tenementLab1.text = [dict objectForKey:@"estateLines"][0][@"name"];
             self.tenementLab1.frame = CGRectMake(CGRectGetMaxX(self.buildingShowImageView.frame)+10, 74, width+10, 15);
             CGFloat width1 = [[dict objectForKey:@"estateLines"][1][@"name"] boundingRectWithSize:CGSizeMake(0, 15) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:Default_Font_11} context:nil].size.width;
           self.tenementLab2.text = [dict objectForKey:@"estateLines"][1][@"name"];
             self.tenementLab2.frame = CGRectMake(CGRectGetMaxX(self.tenementLab1.frame)+5, 74, width1+10, 15);
           self.tenementLab2.hidden = NO;
           self.tenementLab3.hidden = YES;
           self.tenementLab4.hidden = YES;
         }else if (numCount == 3)
        {
           self.tenementLab1.text = [dict objectForKey:@"estateLines"][0][@"name"];
             CGFloat width = [[dict objectForKey:@"estateLines"][0][@"name"] boundingRectWithSize:CGSizeMake(0, 15) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:Default_Font_11} context:nil].size.width;
             self.tenementLab1.frame = CGRectMake(CGRectGetMaxX(self.buildingShowImageView.frame)+10, 74, width+10, 15);
           self.tenementLab2.text = [dict objectForKey:@"estateLines"][1][@"name"];
             CGFloat width1 = [[dict objectForKey:@"estateLines"][1][@"name"] boundingRectWithSize:CGSizeMake(0, 15) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:Default_Font_11} context:nil].size.width;
             self.tenementLab2.frame = CGRectMake(CGRectGetMaxX(self.tenementLab1.frame)+5, 74, width1+10, 15);
           self.tenementLab3.text = [dict objectForKey:@"estateLines"][2][@"name"];
            CGFloat width2 = [[dict objectForKey:@"estateLines"][2][@"name"] boundingRectWithSize:CGSizeMake(0, 15) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:Default_Font_11} context:nil].size.width;
            self.tenementLab3.frame = CGRectMake(CGRectGetMaxX(self.tenementLab2.frame)+5, 74, width2+10, 15);
            self.tenementLab2.hidden = NO;
            self.tenementLab3.hidden = NO;
           self.tenementLab4.hidden = YES;
        }else if (numCount >= 4)
        {
            self.tenementLab1.text = [dict objectForKey:@"estateLines"][0][@"name"];
            self.tenementLab2.text = [dict objectForKey:@"estateLines"][1][@"name"];
            self.tenementLab3.text = [dict objectForKey:@"estateLines"][2][@"name"];
            self.tenementLab4.text = [dict objectForKey:@"estateLines"][3][@"name"];
            CGFloat width = [[dict objectForKey:@"estateLines"][0][@"name"] boundingRectWithSize:CGSizeMake(0, 15) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:Default_Font_11} context:nil].size.width;
            self.tenementLab1.frame = CGRectMake(CGRectGetMaxX(self.buildingShowImageView.frame)+10, 74, width+10, 15);
            CGFloat width1 = [[dict objectForKey:@"estateLines"][1][@"name"] boundingRectWithSize:CGSizeMake(0, 15) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:Default_Font_11} context:nil].size.width;
            self.tenementLab2.frame = CGRectMake(CGRectGetMaxX(self.tenementLab1.frame)+5, 74, width1+10, 15);
            CGFloat width2 = [[dict objectForKey:@"estateLines"][2][@"name"] boundingRectWithSize:CGSizeMake(0, 15) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:Default_Font_11} context:nil].size.width;
            self.tenementLab3.frame = CGRectMake(CGRectGetMaxX(self.tenementLab2.frame)+5, 74, width2+10, 15);
            CGFloat width3 = [[dict objectForKey:@"estateLines"][3][@"name"] boundingRectWithSize:CGSizeMake(0, 15) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:Default_Font_11} context:nil].size.width;
            self.tenementLab4.frame = CGRectMake(CGRectGetMaxX(self.tenementLab3.frame)+5, 74, width3+10, 15);
            self.tenementLab2.hidden = NO;
            self.tenementLab3.hidden = NO;
            self.tenementLab4.hidden = NO;
        }
        else
        {
            self.tenementLab1.hidden = YES;
            self.tenementLab2.hidden = YES;
            self.tenementLab3.hidden = YES;
            self.tenementLab4.hidden = YES;
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
        NSLog(@"biaoqian%@",array);
        if (array.count > 0)
        {
            self.smallPicLabel1.hidden = NO;
            self.smallPicLabel2.hidden = YES;
            self.smallPicLabel1.text = [array[0] objectForKey:@"name"];
            self.smallPicLabel1.backgroundColor = [ProjectUtil colorWithHexString:[array[0] objectForKey:@"color"]];
            
            if (array.count == 2)
            {
                self.smallPicLabel2.hidden = NO;
                self.smallPicLabel2.text = [array[1] objectForKey:@"name"];
                self.smallPicLabel2.backgroundColor = [ProjectUtil colorWithHexString:[array[1] objectForKey:@"color"]];
            }
        }
        
    }
    else
    {
        self.smallPicLabel1.hidden = YES;
        self.smallPicLabel2.hidden = YES;
    }
    
    
        if ([dict objectForKey:@"name"]) {
            
            self.communityName.text = [dict objectForKey:@"name"];
            
        }
        //佣金
        if ([dict  objectForKey:@"priceRemark"])
        {
           
            if ([GetOrgType isEqualToString:@"2"]
                && GetUserID != nil && GetUserID != [NSNull null] )
            {
                self.commissionPriceLabel.text = [NSString stringWithFormat:@"%@",[dict  objectForKey:@"priceRemark"] ];
                CGFloat x = [self.commissionPriceLabel.text boundingRectWithSize:CGSizeMake(0, 20) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:Default_Font_15} context:nil].size.width;
                self.commissionPriceLabel.font = Default_Font_14;
                self.commissionPriceLabel.textAlignment = NSTextAlignmentRight;
                self.commissionPriceLabel.textColor = [UIColor hexChangeFloat:@"ff5f66"];
                self.yongImg.image = [UIImage imageNamed:@"销邦-首页-房源-佣.png"];
                self.commissionPriceLabel.frame = CGRectMake(SCREEN_WIDTH-x-10,12,x, 15);
                self.yongImg.frame = CGRectMake(CGRectGetMaxX(self.commissionPriceLabel.frame)-15-x,12, 15, 15);
            }
            if ( GetUserID == nil)
            {
                self.commissionPriceLabel.text = @"登录后查看";
                self.commissionPriceLabel.textColor = [UIColor hexChangeFloat:KGrayColor];
                self.commissionPriceLabel.font = Default_Font_12;
                self.commissionPriceLabel.frame = CGRectMake(SCREEN_WIDTH-75,12, 75, 15);
                self.yongImg.frame = CGRectMake(CGRectGetMaxX(self.commissionPriceLabel.frame)-90,12, 15, 15);
                self.commissionPriceLabel.textAlignment = NSTextAlignmentLeft;
                self.yongImg.image = [UIImage imageNamed:@"销邦-首页-房源-佣.png"];
            }
//            NSLog(@"用户：%@--%@",GetUserID,GetOrgCode);
            if (GetUserID != nil && ([GetOrgType isEqualToString:@"1"] || [GetOrgType isEqualToString:@"3"]))
            {
                self.commissionPriceLabel.text = @"无权限查看";
                self.commissionPriceLabel.textColor = [UIColor hexChangeFloat:KGrayColor];
                self.commissionPriceLabel.font = Default_Font_12;
                self.commissionPriceLabel.frame = CGRectMake(SCREEN_WIDTH-75,12,75, 15);
                self.yongImg.frame = CGRectMake(CGRectGetMaxX(self.commissionPriceLabel.frame)-90,12, 15, 15);
                self.commissionPriceLabel.textAlignment = NSTextAlignmentLeft;
                self.yongImg.image = [UIImage imageNamed:@"销邦-首页-房源-佣.png"];
            }
        }
        
        if ([dict objectForKey:@"price"])
        {
//            self.averageImg.image = [UIImage imageNamed:@"销邦-首页-房源-均价.png"];
            self.averagePrice.text = [NSString stringWithFormat:@"均价%@元/平米",[dict objectForKey:@"price"]];
            self.averagePrice.textColor = [UIColor hexChangeFloat:KHuiseColor];
            self.averagePrice.font = Default_Font_13;
//           NSMutableAttributedString* attributeStr = [[NSMutableAttributedString alloc]initWithString:self.averagePrice.text];
//            [attributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(2, [self.averagePrice.text length]-6)];
//            [attributeStr addAttribute:NSFontAttributeName value:Default_Font_17 range:NSMakeRange(2, self.averagePrice.text.length-6)];
//            self.averagePrice.attributedText = attributeStr;
        }
        
//        if ([dict objectForKey:@"discountPrice"])
//        {
//            if ([[dict objectForKey:@"discountPrice"] integerValue] != 0)
//            {
//            self.allowanceImg.image = [UIImage imageNamed:@"销邦-首页-房源-补助.png"];
//            self.allowanceLabel.text = [NSString stringWithFormat:@"补贴购房基金%@元",[dict objectForKey:@"discountPrice"]];
//            self.allowanceLabel.textColor = [UIColor hexChangeFloat:KHuiseColor];
//            self.allowanceLabel.font = Default_Font_13;
//            NSMutableAttributedString* attributeStr = [[NSMutableAttributedString alloc]initWithString:self.allowanceLabel.text];
//            [attributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(6, self.allowanceLabel.text.length-7)];
//            [attributeStr addAttribute:NSFontAttributeName value:Default_Font_17 range:NSMakeRange(6, self.allowanceLabel.text.length-7)];
//            self.allowanceLabel.attributedText = attributeStr;
//            }
//        }
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

-(void)layoutSubviews
{
    
    [super layoutSubviews];
    for (UIView * subView in self.subviews)
    {
        if ([NSStringFromClass([subView class]) isEqualToString:@"UITableViewCellDeleteConfirmationView"])
        {
            ((UIView*)[subView.subviews firstObject]).backgroundColor = [UIColor hexChangeFloat:@"ff5f66"];
        }
    }
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
