//
//  redTitleViewForProperty.m
//  SalesHelper_A
//
//  Created by summer on 15/7/17.
//  Copyright (c) 2015年 X. All rights reserved.
//

#import "redTitleViewForProperty.h"

@implementation redTitleViewForProperty

//-(instancetype)initWithFrame:(CGRect)frame title:(NSString *)title
//{
//    if (self= [super initWithFrame:frame]) {
//        UIImageView * image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"销邦-楼盘详情页-新.png"]];
//        image.frame = CGRectMake(19, 14, 18, 18);
//        UILabel * label = [[UILabel alloc]init];
//        label.frame = CGRectMake(42, 14, self.frame.size.width - 42 , 18);
//        label.text = title;
//        label.font = [UIFont fontWithName:@"HYQiHei-EEJ" size:12];
//        label.textColor = [ProjectUtil colorWithHexString:@"#e93a3b"];
//        self.backgroundColor = [UIColor blackColor];
//        [self addSubview:image];
//        [self addSubview:label];
//    }
//    return self;
//}
- (void)awakeFromNib
{
    UIImageView * image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"选中.png"]];
    image.frame = CGRectMake(21, 0, 15, 15);
    UILabel * label = [[UILabel alloc]init];
    label.frame = CGRectMake(42,0, self.frame.size.width - 42 , 18);
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [ProjectUtil colorWithHexString:@"#e93a3b"];
    self.label = label;
    [self addSubview:image];
    [self addSubview:label];
    
}
@end
