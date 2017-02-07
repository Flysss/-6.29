//
//  HWEmotionToolBar.h
//  HW_微博
//
//  Created by 胡伟 on 16/1/24.
//  Copyright © 2016年 胡伟. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,HWEmotionType) {
    HWEmotionTypeRecent, // 最近
    HWEmotionTypeEmoji, // Emoji
    
};
@class HWEmotionToolBar;
@protocol HWEmotionToolBarDelegate <NSObject>

- (void)emotionToolBar:(HWEmotionToolBar *)toolBar didClickEmotionButton:(HWEmotionType)type;

@end

@interface HWEmotionToolBar : UIView

@property (nonatomic,weak) id<HWEmotionToolBarDelegate> delegate;
@end
