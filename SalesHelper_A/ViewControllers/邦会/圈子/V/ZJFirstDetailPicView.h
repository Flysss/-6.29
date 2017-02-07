//
//  ZJFirstDetailPicView.h
//  SalesHelper_A
//
//  Created by zhipu on 16/3/24.
//  Copyright © 2016年 X. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BHDetailTopModel;
@class ZJFirstDetailPicView;
@protocol ZJFirstDetailPicViewDelegate <NSObject>

- (void)tapImg:(ZJFirstDetailPicView *)picView;

@end



@interface ZJFirstDetailPicView : UIView

@property (nonatomic, assign)NSInteger count;
@property (nonatomic, weak)id<ZJFirstDetailPicViewDelegate>delegate;
@property (nonatomic, strong)BHDetailTopModel *model;

@end
