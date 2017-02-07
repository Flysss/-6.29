//
//  BHPostsDetailModel.m
//  SalesHelper_A
//
//  Created by 曾杰 on 16/3/11.
//  Copyright © 2016年 X. All rights reserved.
//

#import "BHPostsDetailModel.h"

#import "NSDate+HW.h"
#import "RegexKitLite.h"
#import "HWEmotion.h"
#import "HWRegexResult.h"
#import "HWEmotionTool.h"
#import "HWEmotionAttachment.h"
#import "UIColor+HexColor.h"


@implementation BHPostsDetailModel
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
    
    
    
    
    if (self.subject_id && self.contents ) {
        
        NSString *totalString = [NSString stringWithFormat:@"#%@#%@",self.subject_id[@"topic"],self.contents];
        self.attributedContents = [self attributedStringWithContents:totalString];
        
    }else{
        
        self.attributedContents = [self attributedStringWithContents:self.contents];
        
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
            
            NSString *trendRegex = @"#[a-zA-Z0-9\\u4e00-\\u9fa5]+#";
            [regexResult.string enumerateStringsMatchedByRegex:trendRegex usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
                [subStr addAttribute:NSForegroundColorAttributeName value:HWColor(88, 161, 253) range:*capturedRanges];
                [subStr addAttribute:HWLinkText value:*capturedStrings range:*capturedRanges];
                
            }];
            
            // 匹配@提到
            NSString *mentionRegex = @"@[a-zA-Z0-9\\u4e00-\\u9fa5\\-_]+";
            [regexResult.string enumerateStringsMatchedByRegex:mentionRegex usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
                [subStr addAttribute:NSForegroundColorAttributeName value:HWColor(88, 161, 253) range:*capturedRanges];
                
                [subStr addAttribute:HWLinkText value:*capturedStrings range:*capturedRanges];
                
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
    
    [attributedText addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"676767"] range:NSMakeRange(0,attributedText.length)];
    
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


@end
