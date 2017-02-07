//
//  HomeTableViewCell.m
//  SalesHelper_A
//
//  Created by summer on 15/7/9.
//  Copyright (c) 2015年 X. All rights reserved.
//

#import "HomeTableViewCell.h"
#import "UIImageView+NHLinearShadow.h"
#import "UIColor+Extend.h"

@interface HomeTableViewCell()
/**
 *  带看奖左边约束 当一日内界定hidden的时候更改约束
 */
@end
@implementation HomeTableViewCell
{
    __weak IBOutlet NSLayoutConstraint *labelWidth;
}

- (void)awakeFromNib {
    
    if ([UIScreen mainScreen].bounds.size.width == 414)
    {
        labelWidth.constant = 180;
    }
    
    if ([UIScreen mainScreen].bounds.size.width == 375)
    {
        labelWidth.constant = 140;
    }
    
    //    self.firstLabel.layer.borderWidth = 0.5;
    //    self.firstLabel.layer.cornerRadius = 5;
    //    self.firstLabel.layer.masksToBounds = YES;
    //    self.firstLabel.layer.borderColor = [UIColor clearColor].CGColor;
    //
    //    self.secondLabel.layer.borderWidth = 0.5;
    //    self.secondLabel.layer.cornerRadius = 5;
    //    self.secondLabel.layer.masksToBounds = YES;
    //    self.secondLabel.layer.borderColor = [UIColor clearColor].CGColor;
    //    self.thirdLabel.layer.borderWidth = 0.5;
    //    self.thirdLabel.layer.cornerRadius = 5;
    //    self.thirdLabel.layer.masksToBounds = YES;
    //    self.thirdLabel.layer.borderColor = [UIColor clearColor].CGColor;
    //    self.fourthLabel.layer.borderWidth = 0.5;
    //    self.fourthLabel.layer.cornerRadius = 5;
    //    self.fourthLabel.layer.masksToBounds = YES;
    //    self.fourthLabel.layer.borderColor = [UIColor clearColor].CGColor;
    
    
    
    [UIImageView addShadowWithColor:[UIColor blackColor] inImageView:self.buildingShowImageView];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)setInfo:(NSDictionary *)info
{
    _info = info;

    if ([info objectForKey:@"name"])
    {
        self.communityName.text = [info objectForKey:@"name"];
    }
    
    if ([info  objectForKey:@"priceRemark"])
    {
        self.commissionPriceLabel.text = [NSString stringWithFormat:@"%@",[info  objectForKey:@"priceRemark"] ];
    }
    
    if ([info objectForKey:@"price"])
    {
        self.averagePrice.text = [NSString stringWithFormat:@"%@",[info objectForKey:@"price"]];
    }
    
    if ([info objectForKey:@"discountPrice"])
    {
        self.allowanceLabel.text = [NSString stringWithFormat:@"%@",[info objectForKey:@"discountPrice"]];
    }
    
    if ([info objectForKey:@"imageUrl"])
    {
        
        NSString * str = [info objectForKey:@"imageUrl"];
        str = [REQUEST_IMG_SERVER_URL stringByAppendingString:str];
        NSURL * url = [NSURL URLWithString:str];
        [self.buildingShowImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"房源默认图.png"]];
    }
    //    NSArray * arr = [info objectForKey:@"xjjLabelLines"];
    
    if ([info objectForKey:@"refereeSum"])
    {
        self.signedCounts.text = [NSString stringWithFormat:@"已推荐  %@组",[info objectForKey:@"refereeSum"]];
    }
    
    if ([info objectForKey:@"id"])
    {
        self.ID = [NSString stringWithFormat:@"%@",[info objectForKey:@"id"]];
    }
    
    if ([[info objectForKey:@"isDeposit"] boolValue])
    {
        self.d.hidden = NO;
        self.d.image = [UIImage imageNamed:@"销邦-首页-房源-认证.png"];
    }
    else
    {
        self.d.hidden = YES;
    }
    
#if 0
    if (([info objectForKey:@"labelLines"] && [info objectForKey:@"labelLines"] != [NSNull null] && [info objectForKey:@"labelLines"] != nil))
    {
        NSArray * arr = [info objectForKey:@"labelLines"];
        if (arr.count > 0)
        {
            NSString* dname = [info objectForKey:@"dname"];
            NSLog(@"dname----%@",dname);
            NSLog(@"tage ---- %@",[info objectForKey:@"propertyTages"]);
            
            for (int i = 0 ; i < arr.count; i++)
            {
                UILabel * label = (UILabel *)[self viewWithTag:1888+i];
                
                if ([arr[i]objectForKey:@"name"])
                {
                    label.text = [arr[i]objectForKey:@"name"];
                    
                }
                
                if ([arr[i]objectForKey:@"color"])
                {
                    //                    label.textColor = [ProjectUtil colorWithHexString:[arr[i]objectForKey:@"color"]];
                    //                    label.layer.borderColor = [ProjectUtil colorWithHexString:[arr[i]objectForKey:@"color"]].CGColor;
                    label.textColor = [UIColor hexChangeFloat:KHuiseColor];
                    label.font = Default_Font_12;
                }
            }
        }
    }
    
#endif
     NSMutableArray* array = [NSMutableArray array];
    [array addObject:[info objectForKey:@"dname"]];
    if (([info objectForKey:@"propertyTages"] && [info objectForKey:@"propertyTages"] !=[NSNull null] && [info objectForKey:@"propertyTages"] !=nil)) {
        
        NSArray* arr = [info objectForKey:@"propertyTages"];
        
        if (arr.count>0) {
            
            for (int i=0; i<arr.count; i++) {
                if ([arr[i] objectForKey:@"tage"]) {
                    [array addObject:arr[i][@"tage"]];
                }
            }
        }
        
    }
        for (int i=0; i<array.count; i++) {
            
            UILabel* label = (UILabel*)[self viewWithTag:1888+i];
            label.text = array[i];
            label.textColor = [UIColor hexChangeFloat:KHuiseColor];
            label.font = Default_Font_12;
         
        }
    
    if (([info objectForKey:@"xjjLabelLines"] && [info objectForKey:@"xjjLabelLines"] != [NSNull null] && [info objectForKey:@"xjjLabelLines"] != nil))
    {
        NSArray * array = [info objectForKey:@"xjjLabelLines"];
        
        if (array.count > 0)
        {
            self.smallPicLabel1.text = [array[0] objectForKey:@"name"];
            self.smallPicLabel1.textColor = [UIColor whiteColor];
            self.smallPicLabel1.backgroundColor = [ProjectUtil colorWithHexString:[array[0] objectForKey:@"color"]];
            
            if (array.count == 2)
            {
                self.smallPicLabel2.text = [array[1] objectForKey:@"name"];
                self.smallPicLabel2.textColor = [UIColor whiteColor];
                self.smallPicLabel2.backgroundColor = [ProjectUtil colorWithHexString:[array[1] objectForKey:@"color"]];
            }
        }
    }
    
    
    
    
    
    
}

@end
