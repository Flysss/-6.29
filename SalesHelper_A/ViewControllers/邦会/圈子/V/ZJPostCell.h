//
//  ZJPostCell.h
//  SalesHelper_A
//
//  Created by zhipu on 16/3/20.
//  Copyright © 2016年 X. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZJPostHead;
@class BHFirstListModel;
@class ZJPostBottomBar;
@class HWContentsLabel;
@class ZJPostPicView;
@class ZJPostNewBottomBar;
@class ZJPostPingLunView;
@class ZJForwardView;

@interface ZJPostCell : UITableViewCell

@property (nonatomic, strong) ZJPostHead *postHeadView;
@property (nonatomic, strong) HWContentsLabel *lblbody;
@property (nonatomic, strong) ZJPostBottomBar *postBar;
@property (nonatomic, strong) ZJPostPicView *postPicView;
@property (nonatomic, strong) ZJPostNewBottomBar *postNewBar;
@property (nonatomic, strong) ZJPostPingLunView *postPingView;
@property (nonatomic, strong) ZJForwardView *forwardView;


@property (nonatomic, strong) NSMutableArray *zanArr;//关于点赞的源数据
@property (nonatomic, strong) BHFirstListModel *model;
@property (nonatomic, strong) NSIndexPath *index;


+ (CGFloat)heightForModel:(BHFirstListModel *)model zanArr:(NSMutableArray *)zanArr;

@end
