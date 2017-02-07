//
//  ZJPostBodyView.h
//  SalesHelper_A
//
//  Created by zhipu on 16/3/19.
//  Copyright © 2016年 X. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BHMyPostsModel;
@class ZJPostBodyView;
@class HWContentsLabel;
@class ZJPostImageBodyView;

@interface ZJPostBodyView : UIView



@property (nonatomic, strong)HWContentsLabel *lblBody;
@property (nonatomic, strong) UILabel *lblBod;

@property (nonatomic, strong) ZJPostImageBodyView *imgBodyView;

@property (nonatomic, strong) BHMyPostsModel *model;
@property (nonatomic, strong) NSIndexPath *indexpath;

+ (CGFloat)heightForString:(NSString *)str font:(CGFloat)font width:(CGFloat )width;
+ (CGFloat)heightBodyView:(BHMyPostsModel *)model;


@end
