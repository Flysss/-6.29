//
//  HWToolBarView.m
//  HW_微博
//
//  Created by 胡伟 on 16/1/23.
//  Copyright © 2016年 胡伟. All rights reserved.
//

#import "HWToolBarView.h"
@interface HWToolBarView()

@property (nonatomic, strong) NSMutableArray *dividers;




@end
@implementation HWToolBarView


- (NSMutableArray *)dividers
{
    if (_dividers == nil) {
        self.dividers = [NSMutableArray array];
    }
    return _dividers;
}


- (void)drawRect:(CGRect)rect
{
    
    [[UIImage imageNamed:@"timeline_card_bottom_background"] drawInRect:rect];
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        [self setupDivider];
        [self setupDivider];
        
    }
    return self;
}
/**
 *  分割线
 */
- (void)setupDivider
{
    UIImageView *divider = [[UIImageView alloc] init];
    divider.image = [UIImage imageNamed:@"timeline_card_bottom_line"];
    divider.contentMode = UIViewContentModeCenter;
    [self addSubview:divider];
    
    [self.dividers addObject:divider];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 设置按钮的frame

    
    // 设置分割线的frame
    
    NSInteger btnCount = self.dividers.count + 1;
    CGFloat btnW = self.width / btnCount;
    
    NSInteger dividerCount = self.dividers.count;
    for (int i = 0; i<dividerCount; i++) {
        UIImageView *divider = self.dividers[i];
        divider.width = 4;
        divider.height = self.height;
        divider.centerX = (i + 1) * btnW;
        divider.centerY = self.height * 0.5;
    }
}


@end
