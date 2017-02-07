//
//  HWEmotionGridView.m
//  HW_微博
//
//  Created by 胡伟 on 16/1/25.
//  Copyright © 2016年 胡伟. All rights reserved.
//

#import "HWEmotionGridView.h"

#import "HWEmotionView.h"
#import "HWEmotionPopView.h"
#import "HWEmotionTool.h"

@interface HWEmotionGridView ()

@property (nonatomic,strong) NSMutableArray *emotionButtons;
@property (nonatomic,weak) UIButton *clearButton;
@property (nonatomic,strong) HWEmotionPopView *popView;

@end

@implementation HWEmotionGridView

- (HWEmotionPopView *)popView
{
    if (!_popView) {
        _popView = [HWEmotionPopView popView];
    }
    return _popView;
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        UIButton *clearButton = [[UIButton alloc] init];
        
        [clearButton setImage:[UIImage imageNamed:@"compose_emotion_delete"] forState:UIControlStateNormal];
        [clearButton setImage:[UIImage imageNamed:@"compose_emotion_delete_highlighted"] forState:UIControlStateNormal];
        [clearButton addTarget:self action:@selector(clearButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:clearButton];
        self.clearButton = clearButton;
        
        
        //给自己添加一个长按手势
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        
        [self addGestureRecognizer:longPress];
        
        
        
    }
    return self;
    
    
    
}


- (NSMutableArray *)emotionButtons
{
    if (!_emotionButtons) {
        
        _emotionButtons = [NSMutableArray array];
    }
    return _emotionButtons;
    
    
}


- (void)setEmotions:(NSArray *)emotions
{
    _emotions = emotions;
    
    NSInteger count = emotions.count;
    NSInteger emotionButtonCount = self.emotionButtons.count;
    

    for (NSUInteger i = 0; i < count; i++) {
        
        HWEmotionView *emotionButton = nil;
        if (i >= emotionButtonCount) {
            
         emotionButton = [[HWEmotionView alloc] init];
         [emotionButton addTarget:self action:@selector(emotionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:emotionButton];
            [self.emotionButtons addObject:emotionButton];
            
        }else
        {
            emotionButton = self.emotionButtons[i];
            
        }
        
        emotionButton.hidden = NO;
        emotionButton.emotion = emotions[i];
    }
    

    for (NSUInteger i = count; i < emotionButtonCount; i++) {
        
        HWEmotionView *emotionButton = self.emotionButtons[i];
        emotionButton.hidden = YES;
        
        
    }
    
}

- (HWEmotionView *)emotionViewWithPoint:(CGPoint)point
{
   __block HWEmotionView *foundEmotionButton = nil;
    [self.emotionButtons enumerateObjectsUsingBlock:^(HWEmotionView *emotinButton, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (CGRectContainsPoint(emotinButton.frame, point) && emotinButton.hidden == NO) {
            
            foundEmotionButton = emotinButton;
            
            *stop = YES;
        }
    }];

    
    return foundEmotionButton;
}

- (void)longPress:(UILongPressGestureRecognizer *)longPress
{
    CGPoint point = [longPress locationInView:longPress.view];
    
    
    HWEmotionView *emotionView = [self emotionViewWithPoint:point];
    if (longPress.state == UIGestureRecognizerStateEnded) {
        
        [self.popView dismiss];
        
        [self selectedEmotion:emotionView];
        
    }else{
        
        [self.popView showEmotionView:emotionView];
        
    }
    
    
    
    
}

- (void)selectedEmotion:(HWEmotionView *)emotionView
{
    if (emotionView == nil) return;
    
    
    [HWEmotionTool saveEmotion:emotionView.emotion];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:HWEMotionViewDidSelectedNotification object:nil userInfo:@{HWEmotionViewEmotion : emotionView.emotion}];
    
    

    

}

- (void)clearButtonClick
{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:HWEmotionDidClearButton object:nil];
    
}
- (void)emotionButtonClick:(HWEmotionView *)emotionView
{
    
    
    [self.popView showEmotionView:emotionView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.popView dismiss];
        [self selectedEmotion:emotionView];

        
    });
    
    
    
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat leftMarign = 15;
    CGFloat topMarign = 15;
    
    CGFloat emotionW = (self.width - 2 * leftMarign) / HWEmotionMaxCols;
    CGFloat emotionH = (self.height - topMarign) / HWEmotionMaxRow;
    
    for (NSUInteger i = 0; i < self.emotions.count; i++) {
        
        UIButton *emotionButton = self.emotionButtons[i];
        emotionButton.width = emotionW;
        emotionButton.height = emotionH;
        emotionButton.x = (i % HWEmotionMaxCols) * emotionW + leftMarign;;
        emotionButton.y = (i / HWEmotionMaxCols) * emotionH + topMarign;
    }

    
    self.clearButton.width = emotionW;
    self.clearButton.height = emotionH;
    self.clearButton.x = self.width - leftMarign - self.clearButton.width;
    self.clearButton.y = self.height - self.clearButton.height;
    
    
    
}
@end
