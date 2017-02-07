//
//  ZJPostNewBottomBar.h
//  SalesHelper_A
//
//  Created by zhipu on 16/5/16.
//  Copyright © 2016年 X. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZJPostNewBottomBar;
@class BHFirstListModel;
@class BHHuaTiModel;

@protocol ZJPostNewBottomBarDelegate <NSObject>

- (void)clickBarButtonZan:(ZJPostNewBottomBar *)psstBar;
- (void)clickBarButtonComm:(ZJPostNewBottomBar *)psstBar;
- (void)clickBarButtonShare:(ZJPostNewBottomBar *)psstBar;


@end

@interface ZJPostNewBottomBar : UIView

@property (nonatomic, strong) UIButton *btnZan;
@property (nonatomic, strong) UIButton *btnComm;
@property (nonatomic, strong) UIButton *btnShare;
@property (nonatomic, strong) UILabel *lblTime;

@property (nonatomic, strong) BHFirstListModel *model;
@property (nonatomic, strong) BHHuaTiModel *Hmodel;

@property (nonatomic, weak) id<ZJPostNewBottomBarDelegate>delegate;

- (void)changeZanCount:(NSInteger)count;

@end
