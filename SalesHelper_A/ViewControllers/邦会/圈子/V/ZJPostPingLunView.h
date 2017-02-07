//
//  ZJPostPingLunView.h
//  SalesHelper_A
//
//  Created by zhipu on 16/5/16.
//  Copyright © 2016年 X. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZJPostReplyView;
@class ZJPostFirstLikeView;
@class BHFirstListModel;
@class BHHuaTiModel;
@interface ZJPostPingLunView : UIView

@property (nonatomic, strong) ZJPostReplyView *replyView;

@property (nonatomic, strong) ZJPostFirstLikeView *likeView;

@property (nonatomic, strong)NSMutableArray *zanCount;

@property (nonatomic, strong) UIImageView *imgReproduction;

@property (nonatomic, strong) UIView *viewLine;

@property (nonatomic, strong)BHFirstListModel *model;

@property (nonatomic, strong)BHHuaTiModel *Hmodel;



+ (CGFloat)heightForView:(BHFirstListModel *)model zanArr:(NSArray *)zanArr;

+ (CGFloat)heightForHView:(BHHuaTiModel *)model zanArr:(NSArray *)zanArr;


@end
