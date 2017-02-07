//
//  HWEmotionView.m
//  HW_微博
//
//  Created by 胡伟 on 16/1/26.
//  Copyright © 2016年 胡伟. All rights reserved.
//

#import "HWEmotionView.h"
#import "HWEmotion.h"

@implementation HWEmotionView

- (void)setEmotion:(HWEmotion *)emotion
{
    
    _emotion = emotion;
    
    if (emotion.code) {
        [UIView setAnimationsEnabled:NO];
        self.titleLabel.font = [UIFont systemFontOfSize:32];
        [self setTitle:emotion.emoji forState:UIControlStateNormal];
        [self setImage:nil forState:UIControlStateNormal];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView setAnimationsEnabled:YES];
        });
        

    }else{

        UIImage *image = [UIImage imageNamed:emotion.png];
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self setImage:image forState:UIControlStateNormal];
        [self setTitle:nil forState:UIControlStateNormal];
    }
    
}
@end
