//
//  HWEmotionTextView.m
//  HW_微博
//
//  Created by 胡伟 on 16/1/27.
//  Copyright © 2016年 胡伟. All rights reserved.
//

#import "HWEmotionTextView.h"
#import "HWEmotionAttachment.h"
#import "HWEmotion.h"
@implementation HWEmotionTextView


- (void)appendEmotion:(HWEmotion *)emotion
{
    
    if (emotion.emoji) {
        
        [self insertText:emotion.emoji];
        
        
    }else
    {
       
        
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
        
        HWEmotionAttachment *attch = [[HWEmotionAttachment alloc] init];
        attch.emotion = emotion;
        attch.image = [UIImage imageNamed:emotion.png];
        attch.bounds = CGRectMake(0, -3, self.font.lineHeight, self.font.lineHeight);

        NSAttributedString *attchStr = [NSAttributedString attributedStringWithAttachment:attch];
        NSInteger selectedIndx = self.selectedRange.location;
        
        [attributedText insertAttributedString:attchStr atIndex:selectedIndx];
#warning 富文本的位置一定要在self.attributedText = attributedText之前 插入之后;
        [attributedText addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, attributedText.length)];
        
         self.attributedText = attributedText;
        self.selectedRange = NSMakeRange(selectedIndx + 1, 0);
    }
    
    
    
    
    
//    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
//    
//        if (emotion.emoji) {
//        
//            NSAttributedString *subStr = [[NSAttributedString alloc] initWithString:emotion.emoji];
//            [attributedText appendAttributedString:subStr];
//    
//    }else
//    {
//        
//        NSTextAttachment *textAtt = [[NSTextAttachment alloc] init];
//        textAtt.image = [UIImage imageNamed:emotion.png];
//        textAtt.bounds = CGRectMake(0, -3, 30, 30);
//    
//        NSAttributedString *subStr = [NSAttributedString attributedStringWithAttachment:textAtt];
//        [attributedText appendAttributedString:subStr];
//
//        
//    
//    }
//    
//    [attributedText addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, attributedText.length)];
//    
//    
//    
//    
//    
//    self.attributedText = attributedText;
}

- (NSString *)realText
{
    NSMutableString *string = [NSMutableString string];
    
    
    [self.attributedText enumerateAttributesInRange:NSMakeRange(0, self.attributedText.length) options:0 usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
        
        HWEmotionAttachment *attach = attrs[@"NSAttachment"];
        
        if (attach) {
            
            [string appendString:attach.emotion.chs];
            
        }else{
            
            NSString *subStr = [self.attributedText attributedSubstringFromRange:range].string;
            
            [string appendString:subStr];
        }
        
        
        
        
    }];
    return string;
    
}


@end
