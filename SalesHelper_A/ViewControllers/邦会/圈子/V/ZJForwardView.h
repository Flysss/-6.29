//
//  ZJForwardView.h
//  SalesHelper_A
//
//  Created by zhipu on 16/6/15.
//  Copyright © 2016年 X. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZJForwardView;
@protocol ZJForwardViewDelegate <NSObject>

- (void)ZJForwardViewClickJumpAction:(ZJForwardView *)ForwardView;

@end


@interface ZJForwardView : UIView

@property (nonatomic, strong)UIImageView *imgForward;
@property (nonatomic, strong)UILabel *lblForwardName;
@property (nonatomic, strong)UILabel *lblForwardContent;
@property (nonatomic, strong)UILabel *lblForwardTopic;


@property (nonatomic, assign)BOOL isPosting;//是否是发帖界面

@property (nonatomic, strong)NSDictionary *dic;
@property (nonatomic, strong)id<ZJForwardViewDelegate>delegate;
@property (nonatomic, strong)NSIndexPath *indexpath;
@property (nonatomic, strong)NSString *forward_id;

@end
