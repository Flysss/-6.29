//
//  HWEmotionTool.m
//  HW_微博
//
//  Created by 胡伟 on 16/1/26.
//  Copyright © 2016年 胡伟. All rights reserved.
//

#define HWEmotionPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"emotions_recent.data"]
#import "HWEmotionTool.h"
#import "HWEmotion.h"

@implementation HWEmotionTool

/** 默认表情 */
static NSArray *_defaultEmotions;
/** emoji表情 */
static NSArray *_emojiEmotions;
/** 浪小花表情 */
static NSArray *_lxhEmotions;
/** 最近    */
static NSMutableArray *_RecentEmotions;
+ (NSArray *)defaultEmotions
{
    
    if (!_defaultEmotions) {
        
        
        _defaultEmotions = [HWEmotion plistWithfile:@"default.plist"];
        
        //        [_defaultEmotions makeObjectsPerformSelector:@selector(setDirectory:) withObject:@"EmotionIcons/default"];
        
    }
    
    return _defaultEmotions;
    
}
+ (NSArray *)emojiEmotions
{
    
    if (!_emojiEmotions) {
        
        _emojiEmotions = [HWEmotion plistWithfile:@"HWemoji1.plist"];
        //         [_emojiEmotions makeObjectsPerformSelector:@selector(setDirectory:) withObject:@"EmotionIcons/emoji"];
    }
    
    return _emojiEmotions;
    
}

+ (NSArray *)lxhEmotions
{
    
    if (!_lxhEmotions) {
        
        _lxhEmotions = [HWEmotion plistWithfile:@"lxh.plist"];
        //        [_lxhEmotions makeObjectsPerformSelector:@selector(setDirectory:) withObject:@"EmotionIcons/lxh"];
    }
    
    return _lxhEmotions;
    
}

+ (NSArray *)RecentEmotions
{
    if (!_RecentEmotions) {
        
        _RecentEmotions = [NSKeyedUnarchiver unarchiveObjectWithFile:HWEmotionPath];
        
        if (!_RecentEmotions) {
            
            _RecentEmotions = [NSMutableArray array];
        }

    }
    return _RecentEmotions;
    
}

+ (void)saveEmotion:(HWEmotion *)emotion
{
    [self RecentEmotions];
    [_RecentEmotions removeObject:emotion];
    [_RecentEmotions insertObject:emotion atIndex:0];
    [NSKeyedArchiver archiveRootObject:_RecentEmotions toFile:HWEmotionPath];
    
}
+ (HWEmotion *)emotionWithDesc:(NSString *)desc
{
    if (!desc) return nil;
    
    __block HWEmotion *foundEmotion = nil;
    
    // 从默认表情中找
    [[self defaultEmotions] enumerateObjectsUsingBlock:^(HWEmotion *emotion, NSUInteger idx, BOOL *stop) {
        if ([desc isEqualToString:emotion.chs] || [desc isEqualToString:emotion.cht]) {
            foundEmotion = emotion;
            *stop = YES;
        }
    }];
    if (foundEmotion) return foundEmotion;
    
    // 从浪小花表情中查找
    [[self lxhEmotions] enumerateObjectsUsingBlock:^(HWEmotion *emotion, NSUInteger idx, BOOL *stop) {
        if ([desc isEqualToString:emotion.chs] || [desc isEqualToString:emotion.cht]) {
            foundEmotion = emotion;
            *stop = YES;
        }
    }];
    
    return foundEmotion;
}

@end
