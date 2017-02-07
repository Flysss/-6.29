//
//  HWEmotionTool.h
//  HW_微博
//
//  Created by 胡伟 on 16/1/26.
//  Copyright © 2016年 胡伟. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HWEmotion;
@interface HWEmotionTool : NSObject

+ (NSArray *)defaultEmotions;
+ (NSArray *)emojiEmotions;
+ (NSArray *)lxhEmotions;
+ (NSArray *)RecentEmotions;


+ (void)saveEmotion:(HWEmotion *)emotion;

+ (HWEmotion *)emotionWithDesc:(NSString *)desc;
@end
