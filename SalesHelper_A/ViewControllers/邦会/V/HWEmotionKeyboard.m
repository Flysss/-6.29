//
//  HWEmotionKeyboard.m
//  HW_微博
//
//  Created by 胡伟 on 16/1/24.
//  Copyright © 2016年 胡伟. All rights reserved.
//

#import "HWEmotionKeyboard.h"
#import "HWEmotionListView.h"
#import "HWEmotionToolBar.h"
#import "HWEmotionTool.h"


@interface HWEmotionKeyboard ()<HWEmotionToolBarDelegate>

@property (nonatomic,weak) HWEmotionListView *listView;
@property (nonatomic,weak) HWEmotionToolBar *toolBar;



@end

@implementation HWEmotionKeyboard




- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
//        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"emoticon_keyboard_background"]];
        
        HWEmotionListView *listView = [HWEmotionListView new];

        [self addSubview:listView];
        self.listView = listView;
          self.listView.emotions = [HWEmotionTool emojiEmotions];
//        HWEmotionToolBar *toolBar = [HWEmotionToolBar new];
//        toolBar.delegate = self;
//        [self addSubview:toolBar];
//        self.toolBar = toolBar;
        
    }
    return self;
    
    
}

#pragma mark - HWEmotionToolBarDelegate
- (void)emotionToolBar:(HWEmotionToolBar *)toolBar didClickEmotionButton:(HWEmotionType)type
{
    switch (type) {
         case HWEmotionTypeRecent:
            self.listView.emotions = [HWEmotionTool RecentEmotions];
            break;
        case HWEmotionTypeEmoji:
            self.listView.emotions = [HWEmotionTool emojiEmotions];
            break;
  
    }
    
    
}



- (void)layoutSubviews
{
    [super layoutSubviews];
    
//    self.toolBar.width = self.width;
//    self.toolBar.height = 35;
//    self.toolBar.y = self.height - self.toolBar.height;
//    
    
    self.listView.width = self.width;
    self.listView.height = self.height;
    
       
    
}

@end
