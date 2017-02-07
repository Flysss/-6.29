//
//  DetailheadviewCell.m
//  SalesHelper_A
//
//  Created by zhipu on 15/7/3.
//  Copyright (c) 2015年 X. All rights reserved.
//

#import "DetailheadviewCell.h"

@implementation DetailheadviewCell

- (void)awakeFromNib {
    // Initialization code
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *urlString = [NSString stringWithFormat:@"%@/SalesServers/%@",REQUEST_SERVER_URL,[defaults objectForKey:@"login_User_face"]];
    [self.headimageview sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"toux"]];

    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
