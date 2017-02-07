//
//  HWPhotoCell.m
//  SalesHelper_A
//
//  Created by 胡伟 on 16/3/7.
//  Copyright © 2016年 X. All rights reserved.
//

#import "HWPhotoCell.h"

@implementation HWPhotoCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _imageView = [[UIImageView alloc] init];
        _imageView.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.500];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_imageView];
        self.clipsToBounds = YES;
        
        
        _deleteButton = [[UIButton alloc] init];
        _deleteButton.backgroundColor = [UIColor clearColor];
        
        [_deleteButton setBackgroundImage:[UIImage imageNamed:@"待选择框"] forState:UIControlStateNormal];
        [_deleteButton setImage:[UIImage imageNamed:@"删除"] forState:UIControlStateNormal];
        
        [_deleteButton addTarget:self action:@selector(deleteButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_deleteButton];
        
        
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _imageView.frame = self.bounds;
    
    _deleteButton.width = 20;
    _deleteButton.height = 20;
    _deleteButton.x = self.width - _deleteButton.width;

    
    
    
}

- (void)deleteButtonDidClick
{
    if ([self.delegate respondsToSelector:@selector(photoCellDeleteButtonDidClick:)]) {
        
        [self.delegate  photoCellDeleteButtonDidClick:self];
        
    }
    

}

@end
