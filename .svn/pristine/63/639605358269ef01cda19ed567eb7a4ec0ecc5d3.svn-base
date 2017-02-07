//
//  ZJHuaTiCell.h
//  SalesHelper_A
//
//  Created by zhipu on 16/3/26.
//  Copyright © 2016年 X. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZJPostHead;
@class BHHuaTiModel;
@class ZJPostBottomBar;
@class HWContentsLabel;
@class ZJPostPicView;
@class ZJPostNewBottomBar;
@class ZJPostPingLunView;
@class ZJForwardView;
@interface ZJHuaTiCell : UITableViewCell


@property (nonatomic, strong) ZJPostHead *postHeadView;
@property (nonatomic, strong) HWContentsLabel *lblbody;
@property (nonatomic, strong) ZJPostBottomBar *postBar;
@property (nonatomic, strong) ZJPostPicView *postPicView;
@property (nonatomic, strong) ZJPostNewBottomBar *postNewBar;
@property (nonatomic, strong) ZJPostPingLunView *postPingView;
@property (nonatomic, strong) ZJForwardView *forwardView;


@property (nonatomic, strong) NSMutableArray *zanArr;//关于点赞的源数据
@property (nonatomic, strong) BHHuaTiModel *model;


+ (CGFloat)heightForModel:(BHHuaTiModel *)model zanArr:(NSMutableArray *)zanArr;

@end
