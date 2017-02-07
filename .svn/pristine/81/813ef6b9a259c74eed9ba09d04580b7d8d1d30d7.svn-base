//
//  UIScrollImageViews.h
//  ChatRoomDemo
//
//  Created by summer on 15/1/6.
//  Copyright (c) 2015年 X. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIPhoto.h"
#import "UIPhotoView.h"

@protocol UIPhotoBrowserDelegate;

@interface UIPhotoBrowser : UIViewController<UIScrollViewDelegate>

// 代理
@property (nonatomic, weak) id<UIPhotoBrowserDelegate> delegate;
// 所有的图片对象
@property (nonatomic, strong) NSMutableArray * photos;
// 当前展示的图片索引
@property (nonatomic, assign) NSUInteger currentPhotoIndex;

- (void)setCurrentPhotoIndex:(NSUInteger)currentPhotoIndex;

// 显示
- (void)show;
@end

@protocol UIPhotoBrowserDelegate <NSObject>

@optional
// 切换到某一页图片
- (void)photoBrowser:(UIPhotoBrowser *)photoBrowser didChangedToPageAtIndex:(NSUInteger)index;
@end
