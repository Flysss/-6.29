//
//  UIBarButtonItem+HW.m
//  HW_微博
//
//  Created by 胡伟 on 16/1/16.
//  Copyright © 2016年 胡伟. All rights reserved.
//

#import "UIBarButtonItem+HW.h"

@implementation UIBarButtonItem (HW)

+ (UIBarButtonItem *)itemWithImage:(NSString *)imageName heighImage:(NSString *)heighImageName target:(id)target action:(SEL)action
{
    UIButton *btn = [UIButton new];
    
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:heighImageName] forState:UIControlStateSelected];
    [btn setImage:[UIImage imageByApplyingAlpha:[UIImage imageNamed:imageName]] forState:(UIControlStateHighlighted)];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    btn.height = btn.currentImage.size.height;
    btn.width = btn.currentImage.size.width + 10;
    
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    
 
    return button;
    
    
    
    
    
}
@end
