//
//  HWGongGaoOriginalView.m
//  SalesHelper_A
//
//  Created by 胡伟 on 16/3/8.
//  Copyright © 2016年 X. All rights reserved.
//

#import "HWGongGaoOriginalView.h"
#import "UIImageView+WebCache.h"

@interface HWGongGaoOriginalView ()

/** 头像 */
@property (nonatomic, strong) UIImageView *iconView;

/** 内容 */
@property (nonatomic, assign) UILabel *contentsLabel;

/** 评论人姓名 */
@property (nonatomic, assign) UILabel *nameLabel;

/** 评论时间 */
@property (nonatomic, assign) UILabel *timeLabel;


@end

@implementation HWGongGaoOriginalView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor blueColor];
        
        //头像
        UIImageView *iconView = [[UIImageView alloc] init];
        [self addSubview:iconView];
        iconView.layer.cornerRadius = 20;
        iconView.layer.masksToBounds = YES;
        self.iconView = iconView;
        
        //评论人姓名
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:nameLabel];
        self.nameLabel = nameLabel;
        
        //评论时间
        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.font = [UIFont systemFontOfSize:10];
        [self addSubview:timeLabel];
        self.timeLabel = timeLabel;
        
        //评论内容
        UILabel *contentsLabel = [[UILabel alloc] init];
        contentsLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:contentsLabel];
        contentsLabel.numberOfLines = 0;
        self.contentsLabel = contentsLabel;
        
        
        
        
    }
    return self;
    
    
}

- (void)setOriginalFrame:(HWGongGaoOriginalFrame *)originalFrame
{
    
    _originalFrame = originalFrame;

    [self.iconView sd_setImageWithURL:[NSURL URLWithString:originalFrame.model.iconpath] placeholderImage:[UIImage imageNamed:@"自己页面头像"]];
    self.iconView.frame = originalFrame.iconFrame;
    
    
    self.nameLabel.text = originalFrame.model.name;
    self.nameLabel.frame = self.originalFrame.nameFrame;
    
    
    self.timeLabel.text = originalFrame.model.addtime;
    self.timeLabel.frame = self.originalFrame.timeFrame;
    
    
    self.contentsLabel.text = originalFrame.model.contents;
    self.contentsLabel.frame = self.originalFrame.contentsFrame;
    
    
    
}

@end
