//
//  UIPhotoView.h
//  ChatRoomDemo
//
//  Created by summer on 15/1/9.
//  Copyright (c) 2015年 X. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UIPhotoBrowser, UIPhoto, UIPhotoView;
@protocol UIPhotoViewDelegate <NSObject>
- (void)photoViewImageFinishLoad:(UIPhotoView *)photoView;
- (void)photoViewSingleTap:(UIPhotoView *)photoView;
- (void)photoViewDidEndZoom:(UIPhotoView *)photoView;
@end

@interface UIPhotoView : UIScrollView<UIScrollViewDelegate>
// 图片
@property (nonatomic, strong) UIPhoto *photo;
// 代理
@property (nonatomic, weak) id<UIPhotoViewDelegate> photoViewDelegate;


@end
