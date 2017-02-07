//
//  SegmentView.m
//  SelegementDemo
//
//  Created by summer on 14-10-15.
//  Copyright (c) 2014年 X. All rights reserved.
//

#import "SegmentView.h"
#import "ModelViewController.h"
@implementation SegmentView
{
    UIScrollView *_scrollView;
    UIColor *_nomalColor;
    UIColor *_selectedColor;
    UIColor *_titleColor;
}

@synthesize selectedIndex = _selectedIndex,scrollLabelView = _scrollLabelView;

-(id)initWithOrignalY:(CGFloat)orignalY ItemHeight:(CGFloat)itemHeight ItemWidth:(CGFloat)itemWidth ItemArr:(NSArray *)itemArr SelectedCount:(NSInteger)selectedCount NomalBackgroudColor:(UIColor *)nomalColor SelectedBackgroundColor:(UIColor *)selectedColor titleColor:(UIColor *)titleColor SegmentColor:(UIColor *)segmentColor
{
    CGFloat scrollWidth;
    _nomalColor = nomalColor;
    _selectedColor = selectedColor;
    _titleColor = titleColor;
    self.selectedIndex = selectedCount;
    if (itemArr.count*itemWidth>=SCREEN_WIDTH)
    {
        scrollWidth = SCREEN_WIDTH-20;
    }
    else
    {
        scrollWidth = itemArr.count*itemWidth;
    }
    self = [super initWithFrame:CGRectMake((SCREEN_WIDTH-scrollWidth)/2, orignalY, scrollWidth, itemHeight)];
    if (self)
    {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, scrollWidth, itemHeight)];
        _scrollView.contentSize = CGSizeMake(itemWidth*itemArr.count, itemHeight);
        _scrollView.showsHorizontalScrollIndicator = NO;
        for (int i = 0; i<itemArr.count; i++)
        {
            UILabel *label  =[[UILabel alloc]initWithFrame:CGRectMake( itemWidth*i,0, itemWidth, itemHeight)];
            label.tag = i+10;
            label.text = [itemArr objectAtIndex:i];
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = titleColor;
          //  label.font  = Default_Font2;
            label.backgroundColor = nomalColor;
            label.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[ UITapGestureRecognizer alloc]initWithTarget:self action:@selector(btnAction:)];
            [label addGestureRecognizer:tap];
            if (i!=itemArr.count-1&&segmentColor!=nil)
            {
                UIView *view = [[UIView alloc]initWithFrame:CGRectMake(itemWidth-0.5, 0, 0.5,itemHeight)];
                view.backgroundColor = NavigationBarColor;
                [label addSubview:view];
            }
            if (i == selectedCount)
            {
                label.backgroundColor = selectedColor;
                label.textColor = [UIColor whiteColor];
            }
            [_scrollView addSubview:label];
        }
        [self addSubview:_scrollView];
         self.scrollLabelView = _scrollView;
    }
   
    return self;
}

-(void)setSelectedIndex:(NSInteger)selectedIndex
{
    NSArray *subViews = _scrollView.subviews;
    for (int i = 0; i<subViews.count; i++)
    {
        UILabel *label = (UILabel *)[_scrollView viewWithTag:i+10];
        if (i==selectedIndex)
        {
            label.backgroundColor = _selectedColor;
            label.textColor = [UIColor whiteColor];
        }
        else
        {
            label.backgroundColor = _nomalColor;
            label.textColor = _titleColor;
        }
    }
}


-(void)btnAction:(UITapGestureRecognizer *)sender
{
    self.selectedIndex = sender.view.tag-10;
    [self.delegate segmentViewDidSelectedItem:sender.view.tag-10];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
