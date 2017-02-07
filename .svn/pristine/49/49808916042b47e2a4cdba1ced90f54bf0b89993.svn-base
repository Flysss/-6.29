//
//  HWComposeToolBar.h
//  HW_微博
//
//  Created by 胡伟 on 16/1/20.
//  Copyright © 2016年 胡伟. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,HWComposeToolbarButtonType)
{
//    HWComposeToolbarButtonTypeCamera, //相机
    HWComposeToolbarButtonTypePicture, // 相册
    HWComposeToolbarButtonTypeMention, // @某些人
    HWComposeToolbarButtonTypeEmotion, // 表情
//    HWComposeToolbarButtonTypeShared // 分享到全名健身
    
};

@class HWComposeToolBar;
@protocol HWComposeToolBarDelegate <NSObject>

- (void)composeTool:(HWComposeToolBar *)composeTool didClickButton:(HWComposeToolbarButtonType)type;

@end

@interface HWComposeToolBar : UIView

@property (nonatomic,weak) id<HWComposeToolBarDelegate> delegate;

@property (nonatomic,assign,getter=isShowEmotionButton) BOOL showEmotionButton;

@property (nonatomic, assign)BOOL isForward;//是否是转发

@end
