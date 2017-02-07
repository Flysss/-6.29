//
//  HWBaseToolBar.m
//  HW_微博
//
//  Created by 胡伟 on 16/1/29.
//  Copyright © 2016年 胡伟. All rights reserved.
//

#import "HWBaseToolBar.h"

@interface HWBaseToolBar ()
@property (nonatomic, strong) NSMutableArray *btns;



@end
@implementation HWBaseToolBar
- (NSMutableArray *)btns
{
    if (_btns == nil) {
        self.btns = [NSMutableArray array];
    }
    return _btns;
}



- (void)drawRect:(CGRect)rect {

}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.attitudesButton = [self setupBtnWithIcon:@"点赞" title:@"赞"];
        self.commentsButton = [self setupBtnWithIcon:@"评论" title:@"评论"];
        self.repostsButton = [self setupBtnWithIcon:@"分享转发" title:@"转发"];
        
        [self.repostsButton addTarget:self action:@selector(repostsButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self.commentsButton addTarget:self action:@selector(commentsButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self.attitudesButton addTarget:self action:@selector(attitudesButtonClick) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    return self;
}



/**
 *  添加按钮
 *
 *  @param icon  图标
 *  @param title 标题
 */
- (UIButton *)setupBtnWithIcon:(NSString *)icon title:(NSString *)title
{
    UIButton *btn = [[UIButton alloc] init];
    [btn setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    
    // 设置高亮时的背景
    [btn setBackgroundImage:[UIImage resizeImage:@"common_card_bottom_background_highlighted"] forState:UIControlStateHighlighted];
    btn.adjustsImageWhenHighlighted = NO;
    
    // 设置间距
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    
    [self addSubview:btn];
    
    [self.btns addObject:btn];
    
    return btn;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 设置按钮的frame
    NSInteger btnCount = self.btns.count;
    CGFloat btnW = self.width / btnCount;
    CGFloat btnH = self.height;
    for (int i = 0; i<btnCount; i++) {
        UIButton *btn = self.btns[i];
        btn.width = btnW;
        btn.height = btnH;
        btn.y = 0;
        btn.x = i * btnW;
    }
    
}
- (void)repostsButtonClick
{
    if ([self.delegate respondsToSelector:@selector(baseToolBarRepostsButtonDidClick:)]) {
        
        [self.delegate baseToolBarRepostsButtonDidClick:self];
        
    }
    
}

- (void)commentsButtonClick
{
    if ([self.delegate respondsToSelector:@selector(baseToolBarCommentsButtonDidClick:)]) {
        
        [self.delegate baseToolBarCommentsButtonDidClick:self];
        
    }
    
}
- (void)attitudesButtonClick
{
    if ([self.delegate respondsToSelector:@selector(baseToolBarAttitudesButtonDidClick:)]) {
        
        [self.delegate baseToolBarAttitudesButtonDidClick:self];
        
    }
    
}
@end
