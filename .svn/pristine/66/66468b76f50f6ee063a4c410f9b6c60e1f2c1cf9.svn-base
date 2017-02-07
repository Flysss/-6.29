//
//  HWEmotionListView.m
//  HW_微博
//
//  Created by 胡伟 on 16/1/24.
//  Copyright © 2016年 胡伟. All rights reserved.
//

#import "HWEmotionListView.h"
#import "HWEmotionGridView.h"
#define HWEmotionMaxCountOfPage 20

@interface HWEmotionListView ()<UIScrollViewDelegate>

@property (nonatomic,weak) UIScrollView *scrollView;
@property (nonatomic,weak) UIPageControl *pageControl;

@end
@implementation HWEmotionListView


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        
        UIScrollView *scrollView = [UIScrollView new];
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.pagingEnabled = YES;
        scrollView.delegate = self;
        [self addSubview:scrollView];
        self.scrollView = scrollView;
        
        
        UIPageControl *pageControl = [UIPageControl new];
        
        [pageControl setValue:[UIImage imageNamed:@"compose_keyboard_dot_selected"] forKeyPath:@"_currentPageImage"];
        [pageControl setValue:[UIImage imageNamed:@"compose_keyboard_dot_normal"] forKeyPath:@"_pageImage"];
        pageControl.hidesForSinglePage = YES;
        [self addSubview:pageControl];
        self.pageControl = pageControl;
        
    }
    return self;
    
}


- (void)setEmotions:(NSArray *)emotions
{
    _emotions = emotions;
    self.pageControl.currentPage = 0;
    self.scrollView.contentOffset = CGPointZero;

    
    NSInteger totalPage = (emotions.count + HWEmotionMaxCountOfPage - 1) / HWEmotionMaxCountOfPage;
    NSInteger currentPage = self.scrollView.subviews.count;
    
    self.pageControl.numberOfPages = totalPage;

    for (int i = 0; i < totalPage; i++) {
        HWEmotionGridView *gridView = nil;
        if (i >= currentPage) {
            gridView = [[HWEmotionGridView alloc] init];
//            gridView.backgroundColor = HWRandomColor;
            [self.scrollView addSubview:gridView];
        }else{
            
            gridView = self.scrollView.subviews[i];
            
        }
        NSUInteger loc = i * HWEmotionMaxCountOfPage;
        NSUInteger len = HWEmotionMaxCountOfPage;
        if (loc + len > emotions.count) {
            
            len = emotions.count - loc;
        }
        NSRange range = NSMakeRange(loc, len);
        gridView.emotions = [emotions subarrayWithRange:range];
        gridView.hidden = NO;
        
    }
    
    for (NSUInteger i = totalPage; i < currentPage; i++) {
        
        HWEmotionGridView *gridView = self.scrollView.subviews[i];
        gridView.hidden = YES;
        
        
    }

    
    
    
    
    [self setNeedsLayout];
    
    
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
    self.pageControl.width = self.width;
    self.pageControl.height = 35;
    self.pageControl.y = self.height - self.pageControl.height;
    
    self.scrollView.width = self.width;
    self.scrollView.height = self.pageControl.y;
    
    NSInteger count = self.pageControl.numberOfPages;
    
    
    
    self.scrollView.contentSize = CGSizeMake(count * self.scrollView.width, 0);
    
    CGFloat gridViewW = self.scrollView.width;
    CGFloat gridViewH = self.scrollView.height;
    for (int i = 0; i < count; i++) {
        HWEmotionGridView *gridView = self.scrollView.subviews[i];
        
        gridView.width = gridViewW;
        gridView.height = gridViewH;
        gridView.x = i * gridViewW;
        
    }

    
    
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    self.pageControl.currentPage = (NSInteger)(scrollView.contentOffset.x / self.scrollView.width + 0.5);
    
    
    
}

@end
