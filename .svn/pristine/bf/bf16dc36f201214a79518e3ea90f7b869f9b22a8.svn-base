//
//  HWEmotionToolBar.m
//  HW_微博
//
//  Created by 胡伟 on 16/1/24.
//  Copyright © 2016年 胡伟. All rights reserved.
//

#import "HWEmotionToolBar.h"
#define HWEmotionToolbarButtonMaxCount 2

@interface HWEmotionToolBar ()

@property (nonatomic,weak) UIButton *defaultButton;
@property (nonatomic,weak) UIButton *selectedButton;
@end
@implementation HWEmotionToolBar


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
       [self setupButtonWithTitle:@"最近" withTag:HWEmotionTypeRecent];
//        self.defaultButton = [self setupButtonWithTitle:@"默认" withTag:HWEmotionTypeDefault];
        self.defaultButton = [self setupButtonWithTitle:@"Emotion" withTag:HWEmotionTypeEmoji];
//        [self setupButtonWithTitle:@"浪小花" withTag:HWEmotionTypeLxh];
//        
        //发出通知
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emotionSelected:) name:HWEMotionViewDidSelectedNotification object:nil];


    }
    return self;
}

- (void)emotionSelected:(NSNotification *)note
{
    if (self.selectedButton.tag == HWEmotionTypeRecent) {
        
        [self buttonClick:self.selectedButton];
        
    }
    
    
}
- (UIButton *)setupButtonWithTitle:(NSString *)title withTag:(HWEmotionType)tag
{
    UIButton *button = [[UIButton alloc] init];
    button.tag = tag;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateSelected];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    
    [self addSubview:button];
    
    NSInteger count = self.subviews.count;
    if (count == 1) {
        
        [button setBackgroundImage:[UIImage resizeImage:@"compose_emotion_table_left_normal"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage resizeImage:@"compose_emotion_table_left_selected"] forState:UIControlStateSelected];
        
        
    }else if (count == HWEmotionToolbarButtonMaxCount){
        [button setBackgroundImage:[UIImage resizeImage:@"compose_emotion_table_right_normal"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage resizeImage:@"compose_emotion_table_right_selected"] forState:UIControlStateSelected];
        
        
        
    }else{
        
        [button setBackgroundImage:[UIImage resizeImage:@"compose_emotion_table_mid_normal"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage resizeImage:@"compose_emotion_table_mid_selected"] forState:UIControlStateSelected];
        
    }
    
    
    
    return button;
    
}
- (void)buttonClick:(UIButton *)button
{
    self.selectedButton.selected = NO;
    button.selected = YES;
    self.selectedButton = button;
    
    if ([self.delegate respondsToSelector:@selector(emotionToolBar:didClickEmotionButton:)]){
        
        [self.delegate emotionToolBar:self didClickEmotionButton:button.tag];
    }
    

    
}
- (void)setDelegate:(id<HWEmotionToolBarDelegate>)delegate
{
    _delegate = delegate;
    
  [self buttonClick:self.defaultButton];
}

- (void)layoutSubviews
{
    
    [super layoutSubviews];
    CGFloat buttonW = self.width / HWEmotionToolbarButtonMaxCount;
    CGFloat buttonH = self.height;
    for (int i = 0; i < HWEmotionToolbarButtonMaxCount; i++) {
        UIButton *button = self.subviews[i];
        button.width = buttonW;
        button.height = buttonH;
        button.x = i * button.width;
        
    }

}
@end
