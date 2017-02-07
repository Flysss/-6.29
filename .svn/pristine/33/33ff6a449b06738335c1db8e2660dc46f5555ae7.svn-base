//
//  BHNoDataView.h
//  SalesHelper_A
//
//  Created by zhipu on 16/4/1.
//  Copyright © 2016年 X. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BHNoDataView;

@protocol BHNoDataViewDelegate <NSObject>

- (void)clickDataButton:(BHNoDataView *)noDataView;

@end


@interface BHNoDataView : UIView

@property (nonatomic, strong) UIImageView *imgBac;
@property (nonatomic, strong) UIButton *btnData;
@property (nonatomic, weak) id<BHNoDataViewDelegate>delegate;


@end
