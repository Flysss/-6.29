//
//  walletCell.m
//  SalesHelper_A
//
//  Created by flysss on 16/4/22.
//  Copyright © 2016年 X. All rights reserved.
//

#import "walletCell.h"
#import "UIColor+Extend.h"

@implementation walletCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 80, 20)];
        self.nameLabel.textColor = [UIColor hexChangeFloat:KGrayColor];
        self.nameLabel.font = Default_Font_17;
        self.nameLabel.textColor = [UIColor redColor];
        [self.contentView addSubview:self.nameLabel];
        
        self.statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.nameLabel.frame), 10, 60, 20)];
        self.statusLabel.textColor = [UIColor hexChangeFloat:KGrayColor];
        self.statusLabel.font = Default_Font_15;
        [self.contentView addSubview:self.statusLabel];
        
         self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.nameLabel.frame)+10, 200, 20)];
        self.timeLabel.textColor = [UIColor hexChangeFloat:KGrayColor];
        self.timeLabel.font = Default_Font_15;
        [self.contentView addSubview:self.timeLabel];
        
        self.moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-100, 21, 90, 30)];
        self.moneyLabel.textColor = [UIColor redColor];
        self.moneyLabel.font = Default_Font_17;
        self.moneyLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.moneyLabel];
        
    }
    return self;
}

-(void)setAttributeForCellWithParam:(NSDictionary *)dict
{
    
//    NSLog(@"cell = %@",dict);
    
    
    
    if ([dict objectForKey:@"name"] != [NSNull null] &&
        [dict objectForKey:@"name"] != nil &&
        [dict objectForKey:@"name"])
    {
        self.nameLabel.text = [dict objectForKey:@"name"];
        
    }else{
        self.nameLabel.text = @"";
    }
    NSUserDefaults* defaults=[NSUserDefaults standardUserDefaults];
    
    if ([[dict objectForKey:@"rewardType"] integerValue] == 2)
    {
        self.statusLabel.text = @"提现";
        self.moneyLabel.text = [NSString stringWithFormat:@"-%.2f",[[dict objectForKey:@"reward"] floatValue]];
        self.moneyLabel.textColor = [ProjectUtil colorWithHexString:@"52a346"];
        self.timeLabel.text = [dict objectForKey:@"regDate"];
    }
    else if ([[dict objectForKey:@"rewardType"]integerValue] == 1)
    {
        self.statusLabel.text=@"邀请";
        self.timeLabel.text=[dict objectForKey:@"regDate"];
        
        NSString* str005=[NSString stringWithFormat:@"%@",[dict objectForKey:@"userId"]];
        
        NSString* str=[NSString stringWithFormat:@"%@",[defaults objectForKey:@"id"] ];
        if ([str005 isEqualToString:str])
        {
            self.moneyLabel.text = [NSString stringWithFormat:@"+%.2f",[[dict objectForKey:@"reward"] floatValue]];
            
        }
        else
        {
            if ([dict objectForKey:@"invitReward"] != [NSNull null] &&
                [dict objectForKey:@"invitReward"] != nil &&
                [dict objectForKey:@"invitReward"])
            {
                self.moneyLabel.text=[NSString stringWithFormat:@"+%.2f",[[dict objectForKey:@"invitReward"] floatValue]];
            }
        }
        self.moneyLabel.textColor = [ProjectUtil colorWithHexString:@"e93a3b"];
    }
    else if ([[dict objectForKey:@"rewardType"] integerValue]== 0)
    {
        self.statusLabel.text=@"成交";
        self.timeLabel.text=[dict objectForKey:@"regDate"];
        
        NSString* str007=[NSString stringWithFormat:@"%@",[dict objectForKey:@"userId"]];
        NSString* str=[NSString stringWithFormat:@"%@",[defaults objectForKey:@"id"] ];
        
        
        if ([str007 isEqualToString:str]) {
            self.moneyLabel.text=[NSString stringWithFormat:@"+%.2f",[[dict objectForKey:@"reward"] floatValue]];
            
        }
        else
        {
            if ([dict objectForKey:@"invitReward"] != [NSNull null] &&
                [dict objectForKey:@"invitReward"] != nil &&
                [dict objectForKey:@"invitReward"])
            {
                self.moneyLabel.text=[NSString stringWithFormat:@"+%.2f",[[dict objectForKey:@"invitReward"] floatValue]];
            }
            
        }
        self.moneyLabel.textColor = [ProjectUtil colorWithHexString:@"e93a3b"];
    }
    else if ([[dict objectForKey:@"rewardType"] integerValue] == 3)
    {
        self.timeLabel.text=[dict objectForKey:@"regDate"];
        
        NSString* str007=[NSString stringWithFormat:@"%@",[dict objectForKey:@"userId"]];
        NSString* str=[NSString stringWithFormat:@"%@",[defaults objectForKey:@"id"] ];
        
        if ([str007 isEqualToString:str]) {
            self.moneyLabel.text=[NSString stringWithFormat:@"+%.2f",[[dict objectForKey:@"reward"] floatValue]];
            if ([dict objectForKey:@"typeName"] != [NSNull null] &&
                [dict objectForKey:@"typeName"] != nil &&
                [dict objectForKey:@"typeName"])
            {
                self.statusLabel.text=[dict objectForKey:@"typeName"];
            }
            
            
        }else{
            self.moneyLabel.text=[NSString stringWithFormat:@"+%.2f",[[dict objectForKey:@"invitReward"] floatValue]];
            if ([dict objectForKey:@"codeTypeName"] != [NSNull null] &&
                [dict objectForKey:@"codeTypeName"] != nil &&
                [dict objectForKey:@"codeTypeName"])
            {
                self.statusLabel.text=[dict objectForKey:@"codeTypeName"];
            }
        }
        self.moneyLabel.textColor = [ProjectUtil colorWithHexString:@"e93a3b"];
        
    }
    else if ([[dict objectForKey:@"rewardType"]integerValue] == 4){
        self.timeLabel.text=[dict objectForKey:@"regDate"];
        
        NSString* str007=[NSString stringWithFormat:@"%@",[dict objectForKey:@"userId"]];
        NSString* str=[NSString stringWithFormat:@"%@",[defaults objectForKey:@"id"] ];
        if ([str007 isEqualToString:str]) {
            self.moneyLabel.text=[NSString stringWithFormat:@"+%.2f",[[dict objectForKey:@"reward"] floatValue]];
            
            if ([dict objectForKey:@"typeName"] != [NSNull null] &&
                [dict objectForKey:@"typeName"] != nil &&
                [dict objectForKey:@"typeName"])
            {
                self.statusLabel.text=[dict objectForKey:@"typeName"];
            }
            
        }
        else
        {
            if ([dict objectForKey:@"invitReward"] != [NSNull null] &&
                [dict objectForKey:@"invitReward"] != nil &&
                [dict objectForKey:@"invitReward"])
            {
               self. moneyLabel.text=[NSString stringWithFormat:@"+%.2f",[[dict objectForKey:@"invitReward"] floatValue]];
            }
            
            if ([dict objectForKey:@"codeTypeName"] != [NSNull null] &&
                [dict objectForKey:@"codeTypeName"] != nil &&
                [dict objectForKey:@"codeTypeName"])
            {
                self.statusLabel.text=[dict objectForKey:@"codeTypeName"];
            }
            
        }
        self.moneyLabel.textColor = [ProjectUtil colorWithHexString:@"e93a3b"];
    }
    else{
        self.timeLabel.text = [dict objectForKey:@"regDate"];
       self.moneyLabel.text = [NSString stringWithFormat:@"+%.2f",[[dict objectForKey:@"reward"] floatValue]];
       self.moneyLabel.textColor = [ProjectUtil colorWithHexString:@"e93a3b"];
       self.nameLabel.text = @"";
        if ([dict objectForKey:@"typeName"] != [NSNull null] &&
            [dict objectForKey:@"typeName"] != nil &&
            [dict objectForKey:@"typeName"])
        {
            self.statusLabel.text=[dict objectForKey:@"typeName"];
        }
    }
    CGFloat width = [self.nameLabel.text boundingRectWithSize:CGSizeMake(0, 20) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:Default_Font_17} context:nil].size.width;
    self.nameLabel.frame = CGRectMake(10, 10, width, 20);
    self.statusLabel.frame = CGRectMake(CGRectGetMaxX(self.nameLabel.frame), 10, 60, 20);
    self.selectionStyle = UITableViewCellSelectionStyleNone;

}


- (void)awakeFromNib {
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
