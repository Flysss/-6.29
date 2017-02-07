//
//  HWBaseToolBar.h
//  HW_微博
//
//  Created by 胡伟 on 16/1/29.
//  Copyright © 2016年 胡伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HWBaseToolBar;
@protocol HWBaseToolBarDelegate <NSObject>

- (void)baseToolBarRepostsButtonDidClick:(HWBaseToolBar *)toolBar;
- (void)baseToolBarCommentsButtonDidClick:(HWBaseToolBar *)toolBar;
- (void)baseToolBarAttitudesButtonDidClick:(HWBaseToolBar *)toolBar;


@end


@interface HWBaseToolBar : UIView
@property (nonatomic,weak) UIButton *repostsButton;
@property (nonatomic,weak) UIButton *commentsButton;
@property (nonatomic,weak) UIButton *attitudesButton;

@property (nonatomic,weak) id<HWBaseToolBarDelegate> delegate;

@end
