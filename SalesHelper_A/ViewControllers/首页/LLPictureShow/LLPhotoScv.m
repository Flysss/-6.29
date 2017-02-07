//
//  LLPhotoScv.m
//  LLPictureShowDemo
//
//  Created by Eli on 15/8/31.
//  Copyright (c) 2015年 yimouleng. All rights reserved.
//

#import "LLPhotoScv.h"
#import "LLPhotoView.h"

@interface LLPhotoScv () <UIScrollViewDelegate>

@property (nonatomic,strong)  NSArray *imageArray;
@property (nonatomic,strong)  UIScrollView * scrollView;
@property (nonatomic, strong) UILabel * countLab;

@end

#define kWhith 64      //预留高度
@implementation LLPhotoScv

- (id)initWithFrame:(CGRect)frame andImage:(NSArray *)imageArr andTitle:(NSArray *)titleArr
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        _scrollView = [[UIScrollView alloc] initWithFrame:frame];
        self.scrollView.pagingEnabled = YES;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.scrollsToTop = NO;
        self.scrollView.delegate = self;
        /*
         //默认偏移量，需要时设置
        [self.scrollView setContentOffset:CGPointMake(0, 0)];
         */
        [self addSubview:self.scrollView];

        self.countLab = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-50, SCREEN_HEIGHT-40, 100, 20)];
        self.countLab.text = [NSString stringWithFormat:@"1/%d",(int)imageArr.count];
        self.countLab.textColor = [UIColor whiteColor];
        self.countLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.countLab];

        
        NSMutableArray *tempArray=[[NSMutableArray alloc] initWithArray:imageArr];
       
        _imageArray = [[NSArray alloc] initWithArray:tempArray];
        
        NSUInteger imgCount = [_imageArray count];
        
        /******设置scrollView的contentSize******/
         self.scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width *self.imageArray.count, 0);
        
        
        for (int i=0; i<imgCount; i++)
        {

            CGRect frame1 = CGRectMake([UIScreen mainScreen].bounds.size.width*i, 0,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
            
            LLPhotoView *s = [[LLPhotoView alloc] initWithFrame:frame1];
            s.backgroundColor = [UIColor clearColor];
            s.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height- kWhith);
            s.delegate = self;
            s.minimumZoomScale = 1.f;
            s.maximumZoomScale = 3.f;
            [s setZoomScale:1.f];
            s.userInteractionEnabled = YES;
            s.showsVerticalScrollIndicator = NO;
            s.showsHorizontalScrollIndicator = NO;
            
            NSString *imgName = self.imageArray[i];
            
            s  =  [s initWithFrame:frame1 andImage:imgName];
            [_scrollView addSubview:s];
            
            UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*i, SCREEN_HEIGHT-80, SCREEN_WIDTH,30)];
            label.backgroundColor = [UIColor clearColor];
            label.text = titleArr[i];
            label.textColor = [UIColor whiteColor];
            label.font = Default_Font_15;
            label.textAlignment = NSTextAlignmentCenter;
            [_scrollView addSubview:label];
        }
    }
    return self;
}
#pragma mark  ------   UIScrollViewDelegate


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //    CGFloat  x = scrollView.contentOffset.x;
    
    self.block ((NSInteger)(scrollView.contentOffset.x/SCREEN_WIDTH));
    self.countLab.text = [NSString stringWithFormat:@"%d/%d",(int)(1+scrollView.contentOffset.x/SCREEN_WIDTH),(int)self.imageArray.count];
}

    /******设置图片大小滚动还原******/
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat offset;
    offset = 0.0;
    
    if (scrollView == _scrollView){
        CGFloat x = scrollView.contentOffset.x;
        if (x==offset){
            
        }
        else {
            offset = x;
            for (UIScrollView *s in scrollView.subviews){
                if ([s isKindOfClass:[UIScrollView class]]){
                    [s setZoomScale:1.f];
                }
            }
        }
    }
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    
    for (UIView *v in scrollView.subviews){
       
        return v;
    }
    return nil;
}
@end
