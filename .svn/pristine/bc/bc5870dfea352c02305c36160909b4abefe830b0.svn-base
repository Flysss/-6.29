//
//  HWKeyboardView.m
//  SalesHelper_A
//
//  Created by 胡伟 on 16/3/11.
//  Copyright © 2016年 X. All rights reserved.
//

#import "HWKeyboardView.h"
#import "HWTextView.h"
#import "UIColor+HexColor.h"

@interface HWKeyboardView ()

@property (nonatomic,weak) UIButton *leftButton;
@property (nonatomic,weak) UIButton *rightButton;


@end

@implementation HWKeyboardView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        UIButton *leftButton = [[UIButton alloc] init];
        [leftButton setTitle:@"取消" forState:UIControlStateNormal];
        [leftButton setTitleColor:[UIColor colorWithHexString:@"00aff0"] forState:(UIControlStateNormal)];
        
        [leftButton addTarget:self action:@selector(cancelButtonCLick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:leftButton];
        self.leftButton = leftButton;
        
        UIButton *rightButton = [[UIButton alloc] init];
        [rightButton setTitle:@"确定" forState:UIControlStateNormal];
        [rightButton setTitleColor:[UIColor colorWithHexString:@"00aff0"] forState:(UIControlStateNormal)];
        [rightButton addTarget:self action:@selector(sendButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:rightButton];
        self.rightButton = rightButton;
        
        
        
        

        HWTextView *textView = [[HWTextView alloc] init];
        self.textView = textView;
        self.textView.placeholder = @"我也来说一说";
        [self addSubview:textView];
        
        
        
    }
    
    
    return self;
}

+ (instancetype)keyboardView
{
    return [[self alloc] init];
    
}

- (void)layoutSubviews
{
   [super layoutSubviews];
    
    self.leftButton.width = 70;
    self.leftButton.height = 35;
    
    self.rightButton.x = SCREEN_WIDTH - 70;
    self.rightButton.width = 70;
    self.rightButton.height = 35;

    self.textView.y = self.leftButton.height;
    self.textView.width = SCREEN_WIDTH;
    self.textView.height = self.height - self.leftButton.height;
    
    
}

- (void)cancelButtonCLick
{
    
    if ([self.delegate respondsToSelector:@selector(keyboardViewCancelButtonDidClick:)]) {
        
        [self.delegate keyboardViewCancelButtonDidClick:self];
        
    }
    
}
- (void)sendButtonClick
{
    if ([self.delegate respondsToSelector:@selector(keyboardViewSendButtonDidClick:)]) {
        
        [self.delegate keyboardViewSendButtonDidClick:self];
        
    }

    
    
    
}
@end
