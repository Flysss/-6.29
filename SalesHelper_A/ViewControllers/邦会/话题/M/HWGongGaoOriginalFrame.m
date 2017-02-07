//
//  HWGongGaoOriginalFrame.m
//  SalesHelper_A
//
//  Created by 胡伟 on 16/3/8.
//  Copyright © 2016年 X. All rights reserved.
//

#import "HWGongGaoOriginalFrame.h"
#import "HWGongGaoModel.h"
@implementation HWGongGaoOriginalFrame

- (void)setModel:(HWGongGaoModel *)model
{
    
    _model = model;
    
    CGFloat iconX = 10;
    CGFloat  iconW = 40;
    CGFloat iconH = 40;
    CGFloat iconY = 13;
   self.iconFrame = CGRectMake(iconX, iconY, iconW, iconH);
    
    
    CGFloat nameX = CGRectGetMaxX(self.iconFrame) + 12;
    CGFloat nameY = iconY;
    CGSize nameSize = [model.name sizeWithFont:[UIFont systemFontOfSize:12]];
    self.nameFrame = (CGRect){{nameX, nameY}, nameSize};
    
    
    
    CGFloat timeX = nameX;
    CGFloat timeY = CGRectGetMaxY(self.nameFrame);
    CGSize timeSize = [model.addtime sizeWithFont:[UIFont systemFontOfSize:10]];
     self.timeFrame = (CGRect){{timeX, timeY}, timeSize};
    
    
    CGFloat contentsX = timeX;
    CGFloat contentsY = CGRectGetMaxY(self.timeFrame) + 9;
    CGFloat maxW = SCREEN_WIDTH - 2 *contentsX + 50;
    CGSize maxSize = CGSizeMake(maxW, MAXFLOAT);
    
    CGSize contensSize = [model.contents boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12]} context:nil].size;
    self.contentsFrame = (CGRect){{contentsX , contentsY}, contensSize};

    
    
    
    CGFloat H = CGRectGetMaxY(self.contentsFrame);

    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, H);
    
}

@end
