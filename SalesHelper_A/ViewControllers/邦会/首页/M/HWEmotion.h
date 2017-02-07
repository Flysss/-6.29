//
//  HWEmotion.h
//  HW_微博
//
//  Created by 胡伟 on 16/1/25.
//  Copyright © 2016年 胡伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HWEmotion : NSObject<NSCoding>

/** 表情的文字描述 */
@property (nonatomic, copy) NSString *chs;
@property (nonatomic, copy) NSString *cht;

/** 表情的文png图片名 */
@property (nonatomic, copy) NSString *png;
/** emoji表情的编码 */
@property (nonatomic, copy) NSString *code;

@property (nonatomic,copy) NSString *emoji;

//@property (nonatomic, copy) NSString *directory;

+ (instancetype)emotionWithDic:(NSDictionary *)dic;


+ (NSArray *)plistWithfile:(NSString *)file;
@end
