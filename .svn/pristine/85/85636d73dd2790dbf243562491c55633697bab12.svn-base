//
//  BHFirstListModel.m
//  SalesHelper_A
//
//  Created by 曾杰 on 16/3/7.
//  Copyright © 2016年 X. All rights reserved.
//

#import "BHFirstListModel.h"
#import "NSDate+HW.h"
#import "RegexKitLite.h"
#import "HWEmotion.h"
#import "HWRegexResult.h"
#import "HWEmotionTool.h"
#import "HWEmotionAttachment.h"
#import "UIColor+HexColor.h"

#import <objc/runtime.h>
@implementation BHFirstListModel




-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
-(void)setValue:(id)value forKey:(NSString *)key
{
    [super setValue:value forKey:key];
    if ([key isEqualToString:@"id"]) {
        _tieZiID = value;
    }
}
- (NSString *)addtime
{
    
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"EEE MMM dd HH:mm:ss Z yyyy";
#warning 真机调试必须加上这句
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    
    // 获得微博发布的具体时间
    NSTimeInterval timer = [_addtime doubleValue];
    NSDate *createDate = [NSDate dateWithTimeIntervalSince1970:timer];
    
    // 判断是否为今年
    if (createDate.isThisYear) {
        if (createDate.isToday) { // 今天
            NSDateComponents *cmps = [createDate deltaWithNow];
            if (cmps.hour >= 1) { // 至少是1小时前发的
                return [NSString stringWithFormat:@"%ld小时前", (long)cmps.hour];
            } else if (cmps.minute >= 1) { // 1~59分钟之前发的
                return [NSString stringWithFormat:@"%ld分钟前", (long)cmps.minute];
            } else { // 1分钟内发的
                return @"刚刚";
            }
        } else if (createDate.isYesterday) { // 昨天
            fmt.dateFormat = @"昨天";
            return [fmt stringFromDate:createDate];
        } else { // 至少是前天
            fmt.dateFormat = @"MM-dd HH:mm";
            return [fmt stringFromDate:createDate];
        }
    } else { // 非今年
        fmt.dateFormat = @"yyyy-MM-dd";
        return [fmt stringFromDate:createDate];;
    }
    
    
}

- (void)setUsercalls:(NSArray *)usercalls
{
    _usercalls = usercalls;
    
    
    [self createAttrobutedContents];
}

- (void)setContents:(NSString *)contents
{
    _contents = [contents copy];
    

   [self createAttrobutedContents];
    
    
}
- (void)setSubject_id:(NSString *)subject_id
{
    _subject_id  = [subject_id copy];
    
    HWLog(@"%@",self.subject_id[@"topic"]);
    
    [self createAttrobutedContents];
    
}

- (void)createAttrobutedContents
{
//     if (self.subject_id == nil || self.contents == nil) return;
//    
//    NSString *totalString = [NSString stringWithFormat:@"%@%@",self.subject_id,self.contents];
    
    
    NSString *str = self.contents;
    NSLog(@"%@",self.usercalls);
    if (self.usercalls.count) {
        
        
        for (NSUInteger i = 0; i < self.usercalls.count; i++) {
            
            NSDictionary *dic = self.usercalls[i];
            
            str = [str stringByReplacingOccurrencesOfString:dic[@"id"] withString:dic[@"name"]];

            HWLog(@"%@",str);
            
        }

//        
//        for (NSDictionary *dic in self.usercalls) {
//            
//            
//       str = [self.contents stringByReplacingOccurrencesOfString:dic[@"id"] withString:dic[@"name"]];
//            
//            HWLog(@"%@",self.usercalls);
//            
//        }
        
        
    }
    
    
    
    if (self.subject_id && self.contents ) {
    
    NSString *totalString = [NSString stringWithFormat:@"#%@#%@",self.subject_id[@"topic"],str];
    self.attributedContents = [self attributedStringWithContents:totalString];
        
    }else{
        
        self.attributedContents = [self attributedStringWithContents:str];
        
    }
    

}

- (NSAttributedString *)attributedStringWithContents:(NSString *)contents
{
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] init];
    
    NSArray *regexResults = [self regexResultsWithText:contents];
    
    
    [regexResults enumerateObjectsUsingBlock:^(HWRegexResult *regexResult, NSUInteger idx, BOOL * _Nonnull stop) {
        HWEmotion *emotion = nil;
        if (regexResult.isEmotion) {//是个表情
            emotion = [HWEmotionTool emotionWithDesc:regexResult.string];
            
        }
        if (emotion) {
            
            HWEmotionAttachment *attch = [[HWEmotionAttachment alloc] init];
            attch.emotion = emotion;
            attch.bounds = CGRectMake(0, -3, [UIFont systemFontOfSize:17].lineHeight, [UIFont systemFontOfSize:17].lineHeight);
            NSAttributedString *attributed = [NSAttributedString attributedStringWithAttachment:attch];
            [attributedText appendAttributedString:attributed];
            
        }
        
        else{//非表情
            
            NSMutableAttributedString *subStr = [[NSMutableAttributedString alloc] initWithString:regexResult.string];
            
             [subStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"676767"] range:NSMakeRange(0,subStr.length)];
            
//            NSString *trendRegex = @"#[a-zA-Z0-9\\u4e00-\\u9fa5]+#";

           
            NSString *trendRegex = @"#[\\s|\\S]*#";
            
            [regexResult.string enumerateStringsMatchedByRegex:trendRegex usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
                
                NSString *totalString = [NSString stringWithFormat:@"#%@#",self.subject_id[@"topic"]];
                                         
                if ([totalString isEqualToString:*capturedStrings]) {
                    
                    
                    [subStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"00aff0"] range:*capturedRanges];
                    
                    HWLog(@"%@",*capturedStrings);
                    
                    [subStr addAttribute:HWLinkText value:*capturedStrings range:*capturedRanges];
                    
                }
                
                
                
            }];
            
            // 匹配@提到
            NSString *mentionRegex = @"@[a-zA-Z0-9\\u4e00-\\u9fa5\\-_]+";
            [regexResult.string enumerateStringsMatchedByRegex:mentionRegex usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
                NSString *myStr = [*capturedStrings substringFromIndex:1];
                
                
                
                for (NSDictionary *dic in self.usercalls) {
                    
                    HWLog(@"%@",dic[@"name"]);
                    
                    if ([myStr isEqualToString:dic[@"name"]]) {
                        
                        
                        [subStr addAttribute:NSForegroundColorAttributeName value:HWColor(88, 161, 253) range:*capturedRanges];
                        
                        [subStr addAttribute:HWLinkText value:*capturedStrings range:*capturedRanges];
                        
                    }
                    
                    
                }
            }];
            
            // 匹配超链接
            NSString *httpRegex = @"http(s)?://([a-zA-Z|\\d]+\\.)+[a-zA-Z|\\d]+(/[a-zA-Z|\\d|\\-|\\+|_./?%&=]*)?";
            [regexResult.string enumerateStringsMatchedByRegex:httpRegex usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
                [subStr addAttribute:NSForegroundColorAttributeName value:HWColor(88, 161, 253) range:*capturedRanges];
                [subStr addAttribute:HWLinkText value:*capturedStrings range:*capturedRanges];
            }];
            
            
            
            
            
            [attributedText appendAttributedString:subStr];
            
        }
        
    }];
    
    
    [attributedText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, attributedText.length)];
    
    
    
    //加载plist文件中的数据
    NSBundle *bundle = [NSBundle mainBundle];
    //寻找资源的路径
    NSString *path = [bundle pathForResource:@"HWemoji1" ofType:@"plist"];
    //获取plist中的数据
    NSArray *face = [[NSArray alloc] initWithContentsOfFile:path];
    
    NSString * pattern = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
    NSError *error = nil;
    NSRegularExpression * re = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    
    if (!re) {
        NSLog(@"%@", [error localizedDescription]);
    }
    //    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:attributedText.string];
    //通过正则表达式来匹配字符串
    NSArray *resultArray = [re matchesInString:attributedText.string options:0 range:NSMakeRange(0, attributedText.length)];
    
    //用来存放字典，字典中存储的是图片和图片对应的位置
    NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:resultArray.count];
    
    //根据匹配范围来用图片进行相应的替换
    for(NSTextCheckingResult *match in resultArray) {
        //获取数组元素中得到range
        NSRange range = [match range];
        
        //获取原字符串中对应的值
        NSString *subStr = [attributedText.string substringWithRange:range];
        
        for (int i = 0; i < face.count; i ++)
        {
            if ([face[i][@"chs"] isEqualToString:subStr])
            {
                
                //face[i][@"gif"]就是我们要加载的图片
                //新建文字附件来存放我们的图片
                NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
                
                //给附件添加图片
                textAttachment.image = [UIImage imageNamed:face[i][@"png"]];
                textAttachment.bounds = CGRectMake(0, -3, [UIFont systemFontOfSize:17].lineHeight, [UIFont systemFontOfSize:17].lineHeight);
                //把附件转换成可变字符串，用于替换掉源字符串中的表情文字
                NSAttributedString *imageStr = [NSAttributedString attributedStringWithAttachment:textAttachment];
                
                //把图片和图片对应的位置存入字典中
                NSMutableDictionary *imageDic = [NSMutableDictionary dictionaryWithCapacity:2];
                [imageDic setObject:imageStr forKey:@"image"];
                [imageDic setObject:[NSValue valueWithRange:range] forKey:@"range"];
                
                //把字典存入数组中
                [imageArray addObject:imageDic];
                
            }
        }
    }
    //从后往前替换
    for (NSInteger j = imageArray.count -1; j >= 0; j--)
    {
        NSRange range;
        [imageArray[j][@"range"] getValue:&range];
        //进行替换
        [attributedText replaceCharactersInRange:range withAttributedString:imageArray[j][@"image"]];
        
    }
//    [attributedText addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"676767"] range:NSMakeRange(0,attributedText.length)];
    
    return attributedText;
}




- (NSArray *)regexResultsWithText:(NSString *)text
{
    
    NSMutableArray *regexResults = [NSMutableArray array];
    
    NSString *emotionRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
    [text enumerateStringsMatchedByRegex:emotionRegex usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        HWRegexResult *rr = [[HWRegexResult alloc] init];
        rr.string = *capturedStrings;
        rr.range = *capturedRanges;
        rr.emotion = YES;
        [regexResults addObject:rr];
    }];
    
    // 匹配非表情
    [text enumerateStringsSeparatedByRegex:emotionRegex usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        HWRegexResult *rr = [[HWRegexResult alloc] init];
        rr.string = *capturedStrings;
        rr.range = *capturedRanges;
        rr.emotion = NO;
        [regexResults addObject:rr];
    }];
    
    // 排序
    [regexResults sortUsingComparator:^NSComparisonResult(HWRegexResult *rr1, HWRegexResult *rr2) {
        NSInteger loc1 = rr1.range.location;
        NSInteger loc2 = rr2.range.location;
        return [@(loc1) compare:@(loc2)];
        
    }];
    
    return regexResults;
    
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    unsigned int count;
    Ivar *ivar = class_copyIvarList([self class], &count);
    for (int i=0; i<count; i++) {
        Ivar iv = ivar[i];
        const char *name = ivar_getName(iv);
        NSString *strName = [NSString stringWithUTF8String:name];
        //利用KVC取值
        id value = [self valueForKey:strName];
        [aCoder encodeObject:value forKey:strName];
    }
    free(ivar);
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        unsigned int count = 0;
        Ivar *ivar = class_copyIvarList([self class], &count);
        for (int i = 0; i < count; i++) {
            Ivar iva = ivar[i];
            const char *name = ivar_getName(iva);
            NSString *strName = [NSString stringWithUTF8String:name];
            id value = [aDecoder decodeObjectForKey:strName];
            [self setValue:value forKey:strName];
        }
        free(ivar);
    }
    return self;
}




@end
