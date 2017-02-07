//
//  ZJFirstDetailBottom.h
//  SalesHelper_A
//
//  Created by zhipu on 16/3/26.
//  Copyright © 2016年 X. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZJFirstDetailBottom;
@class BHPingLunModel;

@protocol ZJFirstDetailBottomDelegate <NSObject>

- (void)clickBottomBtnZanAction:(ZJFirstDetailBottom *)bottomView;

@end


@interface ZJFirstDetailBottom : UIView


@property (nonatomic, strong) UIButton *btnZan;
@property (nonatomic, weak)id<ZJFirstDetailBottomDelegate>delegate;
@property (nonatomic, strong)BHPingLunModel *model;

- (void)btnstate:(NSInteger)count;


@end
