//
//  HWComposePhotoView.m
//  HW_微博
//
//  Created by 胡伟 on 16/1/20.
//  Copyright © 2016年 胡伟. All rights reserved.
//

#import "HWComposePhotoView.h"

@implementation HWComposePhotoView

- (void)addImage:(UIImage *)image
{
    UIImageView *imageView = [UIImageView new];
    
    imageView.image = image;
    
    imageView.contentMode = UIViewContentModeScaleAspectFill;
//    imageView.layer.masksToBounds = YES;
    imageView.clipsToBounds = YES;
    [self addSubview:imageView];
    
    
    
    
    
}

- (NSMutableArray *)images
{
    
    NSMutableArray *array = [NSMutableArray array];
    
    for (UIImageView *imageView in self.subviews) {
        
        
        [array addObject:imageView.image];
        
    }
    
    return array;
    
}
- (void)layoutSubviews
{
    NSInteger count = self.subviews.count;
    CGFloat margin = 10;
    NSInteger maxcolumn = 4;
    CGFloat imageW = (self.width - (maxcolumn + 1)*margin) / maxcolumn;
    CGFloat imageH = imageW;
    
    for (int i = 0; i < count; i++) {
        
        NSInteger row = i / maxcolumn;
        NSInteger list = i % maxcolumn;
        
        UIImageView *imageView = self.subviews[i];
        
        imageView.width = imageW;
        imageView.height = imageH;
        imageView.x = list * (imageW + margin) + margin;
        
        imageView.y = row * (imageH + margin);
        
        
    }
    
}
@end
