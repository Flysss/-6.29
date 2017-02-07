//
//  ZJPostImageBodyView.m
//  SalesHelper_A
//
//  Created by zhipu on 16/4/26.
//  Copyright © 2016年 X. All rights reserved.
//

#import "ZJPostImageBodyView.h"

#import "BHMyPostsModel.h"

@implementation ZJPostImageBodyView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        int totalloc=3;
        CGFloat clearance = 30;
        CGFloat W = (SCREEN_WIDTH-clearance)/3;
        CGFloat H = (SCREEN_WIDTH-clearance)/3;
        CGFloat margin=5;
        for (int i = 0; i < 9; i++) {
            int row = i/totalloc;//行号
            int loc = i%totalloc;//列号

            CGFloat X =10+(margin+W)*loc;
            CGFloat Y =10+(margin+H)*row;
            
            UIImageView *img = [[UIImageView alloc]init];
            img.frame = CGRectMake(X, Y, W, H);
            img.tag = i+1;
            img.contentMode = UIViewContentModeScaleAspectFill;
            img.clipsToBounds = YES;
            [self addSubview:img];
            img.hidden = YES;
        }
        
        self.imgOne = [[UIImageView alloc]init];
        self.imgOne.contentMode = UIViewContentModeScaleAspectFit;
        self.imgOne.frame = CGRectMake(10, 10, (SCREEN_WIDTH-20)/3+50, (SCREEN_WIDTH-20)/3+50-10);
        [self addSubview:self.imgOne];
        
    }
    return self;
}

- (void)setModel:(BHMyPostsModel *)model
{
    _model = model;
    NSInteger count = [model.imgpathsarr count];
    if (count > 9) {
        count = 9;
    }
    for (int i = 0; i < 9; i++) {
        UIImageView *img = [self viewWithTag:i+1];
        img.hidden = YES;
    }
    self.imgOne.hidden = YES;
    
    if (count == 1) {
        self.imgOne.hidden = NO;
        NSString *str = [NSString stringWithFormat:@"%@",[model.imgpathsarr firstObject]];
        [self.imgOne sd_setImageWithURL:[NSURL URLWithString:str]];
        
        
    }
    else
    {
    
        for (int i = 0; i < count; i++) {
            UIImageView *img = [self viewWithTag:i+1];
            img.hidden = NO;
            [img sd_setImageWithURL:[NSURL URLWithString:model.imgpathsarr[i]]];
        }
    }
    

    
}
    
+ (CGFloat)HeightForView:(BHMyPostsModel *)model
{
    CGFloat clearance = 20;
    CGFloat H = (SCREEN_WIDTH-clearance)/3;
    CGFloat Y = 0;
    CGFloat margin=5;
    NSInteger count = [model.imgpathsarr count];
    if (count > 9) {
        count = 9;
    }
    
    if (count == 1)
    {
        
        return (SCREEN_WIDTH-20)/3+50;
    }
    else
    {
        for (int i = 0; i < count; i++)
        {
            int totalloc=3;
            int row = i/totalloc;//行号
            Y = margin+(margin+H)*row;
        }
        return Y + H;
    }
    
}


@end

