//
//  HWEmotion.m
//  HW_微博
//
//  Created by 胡伟 on 16/1/25.
//  Copyright © 2016年 胡伟. All rights reserved.
//

#import "HWEmotion.h"
#import "NSString+HW.h"

@implementation HWEmotion

+ (instancetype)emotionWithDic:(NSDictionary *)dic
{
    HWEmotion *emotion = [[HWEmotion alloc] init];
    emotion.chs = dic[@"chs"];
    emotion.png = dic[@"png"];
    emotion.cht = dic[@"cht"];
    emotion.code = dic[@"code"];
    
//    [emotion setValuesForKeysWithDictionary:dic];
    
    return emotion;
    
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        
        self.chs = [aDecoder decodeObjectForKey:@"chs"];
        self.cht = [aDecoder decodeObjectForKey:@"cht"];
        self.png = [aDecoder decodeObjectForKey:@"png"];
        self.code = [aDecoder decodeObjectForKey:@"code"];
        
        
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    
    [aCoder encodeObject:self.chs forKey:@"chs"];
    [aCoder encodeObject:self.cht forKey:@"cht"];
    [aCoder encodeObject:self.png forKey:@"png"];
    [aCoder encodeObject:self.code forKey:@"code"];
    
    
}

+ (NSArray *)plistWithfile:(NSString *)file
{

    NSString *plist = [[NSBundle mainBundle] pathForResource:file ofType:nil];
    NSArray *array = [NSArray arrayWithContentsOfFile:plist];
    
    NSMutableArray *tempArray = [NSMutableArray array];
    
    for (NSDictionary *dic in array) {
        HWEmotion *emotion = [HWEmotion emotionWithDic:dic];
        
        [tempArray addObject:emotion];
    }
    
    
    
    return tempArray;
}


- (void)setCode:(NSString *)code
{
    
    _code = [code copy];
    
    if (code) {
        
        self.emoji = [NSString emojiWithStringCode:code];
    }
    
    
}

- (BOOL)isEqual:(HWEmotion *)otherEmotion
{
    if (self.code) {
        
        return [self.code isEqualToString:otherEmotion.code];
    }else
    {
        return ([self.png isEqualToString:otherEmotion.png] && [self.chs isEqualToString:otherEmotion.chs] && [self.cht isEqualToString:otherEmotion.cht]);
        
    }
    
    
}

@end
