//
//  BHFirstTopicCell.h
//  SalesHelper_A
//
//  Created by zhipu on 16/2/22.
//  Copyright © 2016年 X. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BHFirstListModel.h"
@class ZJPostHead;

@interface BHFirstTopicCell : UITableViewCell


@property (nonatomic, strong)ZJPostHead *headerView;
@property (nonatomic, strong)UILabel *lblContents;
@property (nonatomic, strong)UIImageView *imgTopic;

- (void)cellForModel:(BHFirstListModel *)model;
+ (CGFloat )heightWithModel:(BHFirstListModel *)model;

@end
