//
//  BHNoDataView.m
//  SalesHelper_A
//
//  Created by zhipu on 16/4/1.
//  Copyright © 2016年 X. All rights reserved.
//

#import "BHNoDataView.h"
#import "UIColor+HexColor.h"

@implementation BHNoDataView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.imgBac = [[UIImageView alloc]init];
        [self.imgBac setImage:[UIImage imageNamed:@"暂无内容默认图片"]];
        self.imgBac.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.imgBac];
        
        self.btnData = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [self.btnData setTitle:@"重新加载数据" forState:(UIControlStateNormal)];
        [self.btnData addTarget:self action:@selector(requestData) forControlEvents:(UIControlEventTouchUpInside)];
        [self.btnData setTitleColor:[UIColor colorWithHexString:@"00aff0"] forState:(UIControlStateNormal)];
        self.btnData.titleLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:self.btnData];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imgBac.width = 60;
    self.imgBac.height = 60;
    self.imgBac.x = self.width/2 - self.imgBac.width/2;
    self.imgBac.y = self.height/2 - self.imgBac.height/2;
    
    self.btnData.width = 200;
    self.btnData.height = 30;
    self.btnData.x = self.width/2 - self.btnData.width/2;
    self.btnData.y = self.height/2 - self.btnData.height/2 + self.imgBac.height+5;
}


- (void)requestData
{
    if (_delegate && [_delegate respondsToSelector:@selector(clickDataButton:)]) {
        [_delegate clickDataButton:self];
    }
}


@end
