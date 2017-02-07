//
//  CustmorStatusTableViewCell.m
//  SalesHelper_A
//
//  Created by summer on 15/11/4.
//  Copyright © 2015年 X. All rights reserved.
//

#import "CustmorStatusTableViewCell.h"

@implementation CustmorStatusTableViewCell
{
    
    __weak IBOutlet NSLayoutConstraint *statusLabelConstraint;
    __weak IBOutlet UILabel *phonelabel;
    __weak IBOutlet UILabel *nameLabel;
    __weak IBOutlet UILabel *timeLabel;
    __weak IBOutlet UILabel *propertyNameLabel;
    __weak IBOutlet UILabel *statusLabel;
}

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
- (void)setDataSource:(NSDictionary *)dataSource
{
    NSLog(@"%@", dataSource);
    
    propertyNameLabel.text = [dataSource objectForKey:@"propertyName"];
    nameLabel.text = [dataSource objectForKey:@"name"];
    timeLabel.text = [ProjectUtil compareDate:[dataSource objectForKey:@"refereeTime"]];
    phonelabel.text = [NSString stringWithFormat:@"%@",[dataSource objectForKey:@"phone"]];
    statusLabel.text = [dataSource objectForKey:@"newStepName"];
    
    //状态颜色
    if ([dataSource objectForKey:@"stepColor"] != nil &&
        [dataSource objectForKey:@"stepColor"] &&
        [dataSource objectForKey:@"stepColor"] != [NSNull null]
        )
    {
        statusLabel.textColor = [ProjectUtil colorWithHexString:[dataSource objectForKey:@"stepColor"]];
    }
    
    
    self.takeLookBtn.hidden = YES;
//    statusLabelConstraint.constant = 18;
    if ([dataSource objectForKey:@"look_type"] != nil && [dataSource objectForKey:@"look_type"] &&  ![[dataSource objectForKey:@"look_type"]isEqualToString:@""])
    {
//        && [[dataSource objectForKey:@"newStepName"] isEqualToString:@"有效"]
       NSString *num = [dataSource objectForKey:@"look_type"];
        if ([num isEqualToString:@"9"] && [[dataSource objectForKey:@"stage"] integerValue] == 2 ) {
//            statusLabelConstraint.constant = 48;
            self.takeLookBtn.hidden = NO;
        }
    }
    if ([dataSource objectForKey:@"look_time"] != nil && ![[dataSource objectForKey:@"look_time"]isKindOfClass:[NSNull class]] && [dataSource objectForKey:@"look_time"]) {
            NSString * str = [dataSource objectForKey:@"look_time"];
            if (str.length != 0) {
                statusLabel.text = nil;
                statusLabel.textColor = nil;
                NSString * baseStr =[dataSource objectForKey:@"newStepName"];
                NSString * numTodayStr = [NSString stringWithFormat:@"%@[已带看]",baseStr];
                NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc]initWithString:numTodayStr];
                [attrStr addAttribute:NSForegroundColorAttributeName value:[ProjectUtil colorWithHexString:[dataSource objectForKey:@"stepColor"]] range:NSMakeRange(0,baseStr.length)];
                [attrStr addAttribute:NSForegroundColorAttributeName value:[ProjectUtil colorWithHexString:@"1d9bf3"] range:NSMakeRange(baseStr.length,5)];
                statusLabel.attributedText = attrStr;
//                statusLabelConstraint.constant = 18;
                self.takeLookBtn.hidden = YES;
            }
    }
}
@end
