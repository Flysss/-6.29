//
//  ChooseTableCell.m
//  SalesHelper_A
//
//  Created by summer on 15/7/13.
//  Copyright (c) 2015年 X. All rights reserved.
//

#import "ChooseTableCell.h"
#import "UIImageView+NHLinearShadow.h"

@interface ChooseTableCell()
@end
@implementation ChooseTableCell

- (void)awakeFromNib {
    self.firstLabel.layer.borderWidth = 0.5;
    self.firstLabel.layer.cornerRadius = 5;
    self.firstLabel.layer.masksToBounds = YES;
    self.firstLabel.layer.borderColor = [UIColor clearColor].CGColor;
    
    self.secondLabel.layer.borderWidth = 0.5;
    self.secondLabel.layer.cornerRadius = 5;
    self.secondLabel.layer.masksToBounds = YES;
    self.secondLabel.layer.borderColor = [UIColor clearColor].CGColor;
    self.thirdLabel.layer.borderWidth = 0.5;
    self.thirdLabel.layer.cornerRadius = 5;
    self.thirdLabel.layer.masksToBounds = YES;
    self.thirdLabel.layer.borderColor = [UIColor clearColor].CGColor;
    self.fourthLabel.layer.borderWidth = 0.5;
    self.fourthLabel.layer.cornerRadius = 5;
    self.fourthLabel.layer.masksToBounds = YES;
    self.fourthLabel.layer.borderColor = [UIColor clearColor].CGColor;
    
    [UIImageView addShadowWithColor:[UIColor blackColor] inImageView:self.buildingShowImageView];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setInfo:(NSDictionary *)info
{
    _info = info;
    if ([info objectForKey:@"name"]) {
        self.communityName.text = [info objectForKey:@"name"];
    }
    if ([info  objectForKey:@"priceRemark"]) {
        self.commissionPriceLabel.text = [NSString stringWithFormat:@"%@",[info  objectForKey:@"priceRemark"] ];
    }
    if ([info objectForKey:@"price"]) {
        self.averagePrice.text = [NSString stringWithFormat:@"%@",[info objectForKey:@"price"]];
    }
    
    if ([info objectForKey:@"discountPrice"]) {
        self.allowanceLabel.text = [NSString stringWithFormat:@"%@",[info objectForKey:@"discountPrice"]];
    }
    if ([info objectForKey:@"imageUrl"]) {
        NSString * str = [info objectForKey:@"imageUrl"];
        str = [REQUEST_IMG_SERVER_URL stringByAppendingString:str];
        NSURL * url = [NSURL URLWithString:str];
        [self.buildingShowImageView sd_setImageWithURL:url];
    }

    if ([info objectForKey:@"refereeSum"]){
        self.signedCounts.text = [NSString stringWithFormat:@"已报名  %@人",[info objectForKey:@"refereeSum"]];
    }
    if ([info objectForKey:@"id"]) {
        self.ID = [NSString stringWithFormat:@"%@",[info objectForKey:@"id"]];
    }
    
    if (([info objectForKey:@"labelLines"] && [info objectForKey:@"labelLines"] != [NSNull null] && [info objectForKey:@"labelLines"] != nil)) {
        NSArray * arr = [info objectForKey:@"labelLines"];
        if (arr.count > 0) {
            for (int i = 0 ; i < arr.count; i++) {
                UILabel * label = (UILabel *)[self viewWithTag:1888+i];
                if ([arr[i]objectForKey:@"name"]) {
                    label.text = [arr[i]objectForKey:@"name"];
                    
                }
                if ([arr[i]objectForKey:@"color"]) {
                    label.textColor = [ProjectUtil colorWithHexString:[arr[i]objectForKey:@"color"]];
                    label.layer.borderColor = [ProjectUtil colorWithHexString:[arr[i]objectForKey:@"color"]].CGColor;
                }
            }
        }
    }
    if (([info objectForKey:@"xjjLabelLines"] && [info objectForKey:@"xjjLabelLines"] != [NSNull null] && [info objectForKey:@"xjjLabelLines"] != nil)) {
        NSArray * arr = [info objectForKey:@"xjjLabelLines"];
        if (arr.count > 0) {
            for (int i = 0 ; i < arr.count; i++) {
                UILabel * label = (UILabel *)[self viewWithTag:1024+i];
                if ([arr[i]objectForKey:@"name"]) {
                    label.text = [arr[i]objectForKey:@"name"];
                    
                }
                if ([arr[i]objectForKey:@"color"]) {
                    label.backgroundColor = [ProjectUtil colorWithHexString:[arr[i]objectForKey:@"color"]];
                }
            }
        }
    }
    if ([[info objectForKey:@"isDeposit"] boolValue]) {
        self.d.hidden = NO;
        self.d.image = [UIImage imageNamed:@"销邦-首页-房源-认证.png"];
    }else
    {
        self.d.hidden = YES;
        self.d.image = nil;
    }

}
//- (void)setChoosenImage:(UIImageView *)ChoosenImage
//{
//
//}
//- (void)setChoosen:(BOOL)choosen
//{
//    if (choosen) {
//        _choosen = choosen;
//        self.ChoosenImage.image = [UIImage imageNamed:@"选中.png"];
//    }else{
//        _choosen = choosen;
//        self.ChoosenImage.image = [UIImage imageNamed:@"未选中.png"];
//    }
//}
@end
