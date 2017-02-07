//
//  ZJShareIconView.m
//  SalesHelper_A
//
//  Created by zhipu on 16/6/17.
//  Copyright © 2016年 X. All rights reserved.
//

#import "ZJShareIconView.h"
#import "UIColor+HexColor.h"
@implementation ZJShareIconView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.btnShare = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [self addSubview:self.btnShare];
        
        self.lblTitle = [[UILabel alloc]init];
        self.lblTitle.textColor = [UIColor colorWithHexString:@"999999"];
        self.lblTitle.textAlignment = NSTextAlignmentCenter;
        self.lblTitle.font = [UIFont systemFontOfSize:12];
        [self addSubview:self.lblTitle];
    }
    return self;
}

- (void)shareIconViewWithIcom:(NSString *)icon title:(NSString *)title
{
    [self.btnShare setImage:[UIImage imageNamed:icon] forState:(UIControlStateNormal)];
    self.lblTitle.text = title;
    
    self.btnShare.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.lblTitle.frame = CGRectMake(0, CGRectGetMaxY(self.btnShare.frame), self.frame.size.width, 20);
    
}

- (void)shareIconViewWithDic:(NSDictionary *)dic
{
    if ([dic[@"uid"] isEqualToString:dic[@"loginuid"]]) {
        self.lblTitle.hidden = NO;
        self.btnShare.hidden = NO;
        self.hidden = NO;
    }
    else
    {
        self.hidden = YES;
        self.lblTitle.hidden = YES;
        self.btnShare.hidden = YES;
    }
}
- (void)shareIconViewWithDic1:(NSDictionary *)dic
{
    if (![dic[@"uid"] isEqualToString:dic[@"loginuid"]]) {
        self.lblTitle.hidden = NO;
        self.btnShare.hidden = NO;
        self.hidden = NO;
    }
    else
    {
        self.hidden = YES;
        self.lblTitle.hidden = YES;
        self.btnShare.hidden = YES;
    }
}
@end
