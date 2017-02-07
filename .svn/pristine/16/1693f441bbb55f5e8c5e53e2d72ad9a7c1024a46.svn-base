//
//  HWComposeToolBar.m
//  HW_微博
//
//  Created by 胡伟 on 16/1/20.
//  Copyright © 2016年 胡伟. All rights reserved.
//

#import "HWComposeToolBar.h"
#import "UIColor+HexColor.h"

@interface HWComposeToolBar ()

@property (nonatomic,weak) UIButton *emotionButton;
@property (nonatomic,weak) UIButton *shareButton;
@end
@implementation HWComposeToolBar

- (instancetype)initWithFrame:(CGRect)frame
{
    
    if (self = [super initWithFrame:frame]) {
 
        
        self.backgroundColor = [UIColor colorWithHexString:@"ebebeb"];
//        [self addButtonIcon:@"compose_camerabutton_background" highIcon:@"compose_camerabutton_background_highlighted" type:HWComposeToolbarButtonTypeCamera];
        [self addButtonIcon:@"图片" highIcon:@"图片" type:HWComposeToolbarButtonTypePicture];

        [self addButtonIcon:@"@" highIcon:@"@" type:HWComposeToolbarButtonTypeMention];
        
         self.emotionButton = [self addButtonIcon:@"表情" highIcon:@"表情" type:HWComposeToolbarButtonTypeEmotion];
        
        
//        UIButton *shareButton = [[UIButton alloc] init];
//        //    shareButton.backgroundColor = [UIColor redColor];
//        //    shareButton.titleLabel.backgroundColor = [UIColor blueColor];
//        
//        // 2.设置文字和图标
//        [shareButton setTitle:@"分享到名人馆" forState:UIControlStateNormal];
//        [shareButton setFont:[UIFont systemFontOfSize:13]];
//        [shareButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [shareButton setImage:[UIImage imageNamed:@"new_feature_share_false"] forState:UIControlStateNormal];
//        [shareButton setImage:[UIImage imageNamed:@"new_feature_share_true"] forState:UIControlStateSelected];
//        // 监听点击
//        [shareButton addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
//    
//        // 3.设置frame
//        shareButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
//        shareButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//        self.shareButton = shareButton;
//        [self addSubview:shareButton];
        
    }
    
    return self;
    
    
}

//- (void)share:(UIButton *)shareButton
//{
//    shareButton.selected = !shareButton.isSelected;
//    
//}

- (void)setShowEmotionButton:(BOOL)showEmotionButton
{
    _showEmotionButton = showEmotionButton;
    
    if (showEmotionButton) {
        
        [self.emotionButton setImage:[UIImage imageNamed:@"键盘"] forState:UIControlStateNormal];
        
        [self.emotionButton setImage:[UIImage imageNamed:@"键盘"] forState:UIControlStateHighlighted];
        
    
    }else{
        
        [self.emotionButton setImage:[UIImage imageNamed:@"表情"] forState:UIControlStateNormal];
        
        [self.emotionButton setImage:[UIImage imageNamed:@"表情"] forState:UIControlStateHighlighted];

    }
    
}

- (UIButton *)addButtonIcon:(NSString *)icon highIcon:(NSString *)highIcon type:(HWComposeToolbarButtonType)type
{
    UIButton *button = [UIButton new];
    [button setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
     [button setImage:[UIImage imageNamed:highIcon] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(ToolBarbuttonClick:) forControlEvents:UIControlEventTouchUpInside];
     button.tag = type;

    [self addSubview:button];
    

    return button;
    
    
}
- (void)ToolBarbuttonClick:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(composeTool:didClickButton:)]) {
        
        [self.delegate composeTool:self didClickButton:button.tag];
    }
    
    
}
- (void)layoutSubviews
{
    
    CGFloat buttonH = self.height;
    NSInteger count = self.subviews.count;
    for (int i = 0; i< count; i++) {
        
        UIButton *button = self.subviews[i];
        button.width = 60;
        button.x = button.width * i;
        button.height = buttonH;
        button.y = 0;
    }
    
    if (_isForward == YES) {
        UIButton *button = self.subviews[0];
        button.hidden = YES;
        UIButton *button1 = self.subviews[1];
        UIButton *button2 = self.subviews[2];
        
        button1.width = 60;
        button1.x = button.width * 0;
        button1.height = buttonH;
        button1.y = 0;
        
        button2.width = 60;
        button2.x = button.width * 1;
        button2.height = buttonH;
        button2.y = 0;

    }
    
    
}

@end
