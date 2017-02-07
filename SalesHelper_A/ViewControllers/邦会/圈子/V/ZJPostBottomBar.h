//
//  ZJPostBottomBar.h
//  SalesHelper_A
//
//  Created by zhipu on 16/3/20.
//  Copyright © 2016年 X. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZJPostBottomBar;
@class BHFirstListModel;
@class BHHuaTiModel;
@protocol ZJPostBottomBarDelegate <NSObject>

- (void)clickBarButtonZan:(ZJPostBottomBar *)psstBar;
- (void)clickBarButtonComm:(ZJPostBottomBar *)psstBar;
- (void)clickBarButtonShare:(ZJPostBottomBar *)psstBar;


@end


@interface ZJPostBottomBar : UIView

@property (nonatomic, strong) UIButton *btnZan;
@property (nonatomic, strong) UIButton *btnComm;
@property (nonatomic, strong) UIButton *btnShare;

@property (nonatomic, strong) BHFirstListModel *model;
@property (nonatomic, strong) BHHuaTiModel *Hmodel;

@property (nonatomic, weak) id<ZJPostBottomBarDelegate>delegate;

@end
