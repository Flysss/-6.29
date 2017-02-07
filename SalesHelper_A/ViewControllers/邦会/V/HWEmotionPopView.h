//
//  HWEmotionPopView.h
//  HW_微博
//
//  Created by 胡伟 on 16/1/26.
//  Copyright © 2016年 胡伟. All rights reserved.
//

#import <UIKit/UIKit.h>


@class HWEmotionView;
@interface HWEmotionPopView : UIView
+ (instancetype)popView;

- (void)showEmotionView:(HWEmotionView *)fromEmotionView;

- (void)dismiss;
@end
