//
//  NSString+StringTpye.m
//  SalesHelper_C
//
//  Created by summer on 14/10/18.
//  Copyright (c) 2014年 X. All rights reserved.
//

#import "NSString+StringTpye.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (StringTpye)
-(NSMutableAttributedString *)addUnderline
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:self];
    NSRange attributedRange = {0,[attributedString length]};
    [attributedString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:attributedRange];
    return attributedString;
}

-(BOOL)isType:(StringType)stringType
{
    NSString *regex;
    if (stringType==StringTypePhone)
    {
        regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,5-9]))\\d{8}$";
    }
    if (stringType==StringTypePhoneNumber)
    {
        regex = @"^[0-9]\\d*$";
    }
    if (stringType == StringTypeChineseName)
    {
        regex = @"[\\u4e00-\\u9fa5]+$";
    }
    if (stringType==StringTypePassword)
    {
        regex = @"^[A-Za-z0-9]+$";
    }
    if (stringType==StringTypeUrlString)
    {
        regex = @"^(http://|https://)?((?:[A-Za-z0-9]+-[A-Za-z0-9]+|[A-Za-z0-9]+)\\.)+([A-Za-z]+)[/\?\\:]?.*$";
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [predicate evaluateWithObject:self];
}

-(CGSize)getSizeWithFont:(UIFont *)font
{
    CGSize size;
    if (IOS_VERSION<7.0)
    {
//        size = [self sizeWithFont:font];
        size = [self sizeWithAttributes:@{NSFontAttributeName:font}];
    }
    else
    {
        size = [self sizeWithAttributes:[NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName]];
    }
    return size;
}

-(CGSize)getSizeWithFont:(UIFont *)font Width:(CGFloat)width
{
    CGSize size;
    CGSize constrainSize = CGSizeMake(width,2000);

    if (IOS_VERSION<7.0)
    {
//        size = [self sizeWithFont:font constrainedToSize:constrainSize lineBreakMode:NSLineBreakByWordWrapping];
        size = [self boundingRectWithSize:constrainSize options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName] context:nil].size;
    }
    else
    {
        size = [self boundingRectWithSize:constrainSize options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName] context:nil].size;
    }
    return size;
}


-(BOOL)isAllowInputWithMinLength:(NSInteger)minLength MaxLength:(NSInteger)maxLength StringType:(StringType)stringType
{
    BOOL isAllowInput;
    if (self.length>=minLength&&self.length<=maxLength)
    {
        if ([self isType:stringType])
        {
            isAllowInput = YES;
        }
        else
        {
            isAllowInput = NO;
        }
    }
    else
    {
        isAllowInput = NO;
    }
    return isAllowInput;
}

-(NSString *)changeToStringToMd5String
{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (unsigned)strlen(cStr), result);
    return [[NSString stringWithFormat:
             @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ]uppercaseString];
}

-(NSString *)changeToMyDate
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[self integerValue]];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr = [formatter stringFromDate:date];
    return dateStr;
}

-(NSString *)changeToChineseDate
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[self integerValue]];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    NSString *dateStr = [formatter stringFromDate:date];
    return dateStr;
}

-(NSString *)changetoNomalDate
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[self integerValue]];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateStr = [formatter stringFromDate:date];
    return dateStr;

}

-(NSString *)changeToMyDateWithSegmentSign:(NSString *)segmentSign
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[self integerValue]];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:[NSString stringWithFormat:@"yyyy%@MM%@dd",segmentSign,segmentSign]];
    NSString *dateStr = [formatter stringFromDate:date];
    return dateStr;
}

@end
