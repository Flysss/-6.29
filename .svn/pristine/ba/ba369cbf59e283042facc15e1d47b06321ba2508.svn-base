//
//  HWEmotionPopView.m
//  HW_微博
//
//  Created by 胡伟 on 16/1/26.
//  Copyright © 2016年 胡伟. All rights reserved.
//

#import "HWEmotionPopView.h"
#import "HWEmotionView.h"

@interface HWEmotionPopView ()

@property (weak, nonatomic) IBOutlet HWEmotionView *emotionButton;


@end
@implementation HWEmotionPopView

+ (instancetype)popView
{
    
    return [[[NSBundle mainBundle] loadNibNamed:@"HWEmotionPopView" owner:nil options:nil] lastObject];
    
    
}


- (void)drawRect:(CGRect)rect {

    [[UIImage imageNamed:@"emoticon_keyboard_magnifier"] drawInRect:rect];
    
}

- (void)showEmotionView:(HWEmotionView *)fromEmotionView
{
    if (fromEmotionView == nil) return;
    
    self.emotionButton.emotion = fromEmotionView.emotion;
    
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    [window addSubview:self];
    
    self.centerX = fromEmotionView.centerX;
    self.centerY = fromEmotionView.centerY - self.height * 0.5;
    
    CGPoint center = CGPointMake(self.centerX, self.centerY);
    
    self.center = [window convertPoint:center fromView:fromEmotionView.superview];
    
}
- (void)dismiss
{
    
    [self removeFromSuperview];
    
}
@end
