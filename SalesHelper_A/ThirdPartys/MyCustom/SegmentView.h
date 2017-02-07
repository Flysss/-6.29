//
//  SegmentView.h
//  SelegementDemo
//
//  Created by summer on 14-10-15.
//  Copyright (c) 2014年 X. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SegmentDelegate <NSObject>

-(void)segmentViewDidSelectedItem:(NSInteger)index;

@end

@interface SegmentView : UIView
-(id)initWithOrignalY:(CGFloat)orignalY ItemHeight:(CGFloat)itemHeight ItemWidth:(CGFloat)itemWidth ItemArr:(NSArray *)itemArr SelectedCount:(NSInteger)selectedCount NomalBackgroudColor:(UIColor *)nomalColor SelectedBackgroundColor:(UIColor *)selectedColor titleColor:(UIColor *)titleColor SegmentColor:(UIColor *)segmentColor;

@property (nonatomic,assign)id<SegmentDelegate>delegate;
@property (nonatomic,assign)NSInteger selectedIndex;
@property (nonatomic,retain)UIScrollView *scrollLabelView;
@end
