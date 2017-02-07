//
//  ZJHuaTiHeadView.m
//  SalesHelper_A
//
//  Created by zhipu on 16/3/17.
//  Copyright © 2016年 X. All rights reserved.
//

#import "ZJHuaTiHeadView.h"

@implementation ZJHuaTiHeadView

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
    if (self) {
        self.imgHead = [[UIImageView alloc]init];
        [self addSubview:self.imgHead];
        
        self.lblBody = [[UILabel alloc]init];
        [self addSubview:self.lblBody];
        
        self.lblNum = [[UILabel alloc]init];
        [self addSubview:self.lblNum];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imgHead.frame = CGRectMake(0, 0, SCREEN_WIDTH, 190);
    
    self.lblNum.frame = CGRectMake(10, CGRectGetHeight(self.imgHead.frame)-40, SCREEN_WIDTH-20, 20);
    
    NSString *str = @"";
    self.lblBody.frame = CGRectMake(10, CGRectGetMaxY(self.imgHead.frame)+10, SCREEN_WIDTH-20, [ZJHuaTiHeadView heightForString:str]);
}

#pragma mark-自适应高度
+ (CGFloat)heightForString:(NSString *)str
{
    NSDictionary *dic = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:12] forKey:NSFontAttributeName];
    CGRect bound = [str boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    return bound.size.height;
}
@end
