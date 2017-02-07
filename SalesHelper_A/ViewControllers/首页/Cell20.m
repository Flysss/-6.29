//
//  Cell20.m
//  SalesHelper_A
//
//  Created by ZhipuTech on 15/6/19.
//  Copyright (c) 2015年 X. All rights reserved.
//

#import "Cell20.h"

@implementation Cell20
{
  
    __weak IBOutlet NSLayoutConstraint *lineWidth;
   
}

- (void)awakeFromNib {
    // Initialization code
    lineWidth.constant = 0.5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
