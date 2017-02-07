//
//  ZJPostPicView.h
//  SalesHelper_A
//
//  Created by zhipu on 16/5/16.
//  Copyright © 2016年 X. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BHFirstListModel;
@class BHHuaTiModel;
@class ZJPostPicView;


@protocol ZJPostPicViewDelegate <NSObject>

- (void)clickPicAction:(ZJPostPicView *)picView;

@end



@interface ZJPostPicView : UIView
@property (nonatomic, strong) BHFirstListModel *model;

@property (nonatomic, strong) UIImageView *imgOne;

@property (nonatomic, weak) id<ZJPostPicViewDelegate>delegate;

@property (nonatomic, strong) BHHuaTiModel *Hmodel;

@property (nonatomic, strong) NSIndexPath *indexpath;
+ (CGFloat)HeightForView:(BHFirstListModel *)model;
+ (CGFloat)HeightForHView:(BHHuaTiModel *)model;

@end
