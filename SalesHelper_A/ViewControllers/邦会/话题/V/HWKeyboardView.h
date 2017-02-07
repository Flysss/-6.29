//
//  HWKeyboardView.h
//  SalesHelper_A
//
//  Created by 胡伟 on 16/3/11.
//  Copyright © 2016年 X. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HWTextView,HWKeyboardView;
@protocol HWKeyboardViewDelegate <NSObject>

- (void)keyboardViewCancelButtonDidClick:(HWKeyboardView *)keyboardView;
- (void)keyboardViewSendButtonDidClick:(HWKeyboardView *)keyboardView;


@end
@interface HWKeyboardView : UIView
+ (instancetype)keyboardView;

@property (nonatomic,weak) HWTextView *textView;
@property (nonatomic,weak) id<HWKeyboardViewDelegate> delegate;
@property (nonatomic, assign) NSInteger section;
@property (nonatomic, strong) NSIndexPath *indexpath;
@end
