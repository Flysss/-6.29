//
//  UIColor+Extend.m
//  FlyBar
//
//  Created by Brant on 15/10/23.
//  Copyright (c) 2015年 Brant. All rights reserved.
//

#import "UIColor+Extend.h"

@implementation UIColor (Extend)

+ (UIColor *)hexChangeFloat:(NSString *)color {
//    unsigned int redInt_, greenInt_, blueInt_;
//    NSRange rangeNSRange_;
//    rangeNSRange_.length = 2;  // 范围长度为2
//    
//    // 取红色的值
//    rangeNSRange_.location = 0;
//    [[NSScanner scannerWithString:[hexColor substringWithRange:rangeNSRange_]]
//     scanHexInt:&redInt_];
//    
//    // 取绿色的值
//    rangeNSRange_.location = 2;
//    [[NSScanner scannerWithString:[hexColor substringWithRange:rangeNSRange_]]
//     scanHexInt:&greenInt_];
//    
//    // 取蓝色的值
//    rangeNSRange_.location = 4;
//    [[NSScanner scannerWithString:[hexColor substringWithRange:rangeNSRange_]]
//     scanHexInt:&blueInt_];
//    
//    return [UIColor colorWithRed:(float)(redInt_/255.0f)
//                           green:(float)(greenInt_/255.0f)
//                            blue:(float)(blueInt_/255.0f) 
//                           alpha:1.0f];
    
    
    
    
    
    
    
    
    //删除字符串中的空格
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6)
    {
        return [UIColor clearColor];
    }
    // strip 0X if it appears
    //如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
    if ([cString hasPrefix:@"0X"])
    {
        cString = [cString substringFromIndex:2];
    }
    //如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
    if ([cString hasPrefix:@"#"])
    {
        cString = [cString substringFromIndex:1];
    }
    if ([cString length] != 6 && [cString length]!= 8)
    {
        return [UIColor clearColor];
    }
    
    if ([cString length] == 8) {
        // Separate into r, g, b substrings
        NSRange range;
        range.location = 0;
        range.length = 2;
        //a
        NSString *astring = [cString substringWithRange:range];
        //r
        range.location = 2;
        NSString *rString = [cString substringWithRange:range];
        //g
        range.location = 4;
        NSString *gString = [cString substringWithRange:range];
        //b
        range.location = 6;
        NSString *bString = [cString substringWithRange:range];
        
        // Scan values
        unsigned int r, g, b, a;
        [[NSScanner scannerWithString:astring] scanHexInt:&a];
        [[NSScanner scannerWithString:rString] scanHexInt:&r];
        [[NSScanner scannerWithString:gString] scanHexInt:&g];
        [[NSScanner scannerWithString:bString] scanHexInt:&b];
        
        return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:((float)a/255.0f)];
    }else{
        
        NSRange range;
        range.location = 0;
        range.length = 2;
        //r
        NSString *rString = [cString substringWithRange:range];
        //g
        range.location = 2;
        NSString *gString = [cString substringWithRange:range];
        //b
        range.location = 4;
        NSString *bString = [cString substringWithRange:range];
        
        // Scan values
        unsigned int r, g, b;
        [[NSScanner scannerWithString:rString] scanHexInt:&r];
        [[NSScanner scannerWithString:gString] scanHexInt:&g];
        [[NSScanner scannerWithString:bString] scanHexInt:&b];
        
        return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:1.0];
    }
    
    return nil;
}

@end
