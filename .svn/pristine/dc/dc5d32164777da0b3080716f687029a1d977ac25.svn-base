//
//  HWTitleButton.h
//  SalesHelper_A
//
//  Created by 胡伟 on 16/3/7.
//  Copyright © 2016年 X. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HWTitleButton;
@protocol HWTitleButtonDelegate <NSObject>

- (void)titleButtonDidClick:(HWTitleButton *)titleButton;
@end
@interface HWTitleButton : UIView

@property (nonatomic,weak) id<HWTitleButtonDelegate> delegate;

+ (instancetype)titleButton;
@end
