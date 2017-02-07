//
//  ProjectUtil.m
//  AnJieWealth
//
//  Created by zhipu on 14-8-28.
//  Copyright (c) 2014年 deayou. All rights reserved.
//

#import "ProjectUtil.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation ProjectUtil

//输出日志
+(void)showLog:(NSString *)log,...
{
	if (CGLOBAL_SHOW_LOG_FLAG)
    {
		va_list args;
		va_start(args,log);
		NSString *str = [[NSString alloc] initWithFormat:log arguments:args];
		va_end(args);
		NSLog(@" %@ ",str);
	}
}
//显示弹出框
+(void)showAlert:(NSString *)title message:(NSString *)msg {
    NSString *strAlertOK = NSLocalizedString(@"确定",nil);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:msg
                                                   delegate:nil
                                          cancelButtonTitle:strAlertOK
                                          otherButtonTitles:nil];
    [alert show];
}

//判断手机号
+ (BOOL)isPersonPhone:(NSString *)strPhone
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188,178
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|4[0-9]|5[0-35-9]|7[0-9]|8[0235-9])\\d{8}$";
    /**
     * 中国移动：China Mobile
     * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188,178
     */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|78[0-9]|8[278])\\d)\\d{7}$";
    /**
     * 中国联通：China Unicom
     * 130,131,132,152,155,156,185,186,176
     */
    NSString * CU = @"^1(3[0-2]|5[256]|76|8[56])\\d{8}$";
    /**
     * 中国电信：China Telecom
     * 133,1349,153,180,189,177
     */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349|77[0-9])\\d{7}$";
    /**
     * 大陆地区固话及小灵通
     * 区号：010,020,021,022,023,024,025,027,028,029
     * 号码：七位或八位
     */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:strPhone] == YES)
        || ([regextestcm evaluateWithObject:strPhone] == YES)
        || ([regextestct evaluateWithObject:strPhone] == YES)
        || ([regextestcu evaluateWithObject:strPhone] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

//判断手机号 11 位即可
+ (BOOL)isFuzzyPhone:(NSString *)strPhone
{
    NSString * MOBILE = @"^1([0-9])\\d{9}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    return [regextestmobile evaluateWithObject:strPhone];
}

//利用正则表达式验证邮箱
+ (BOOL)isValidateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

//判断字母和数字
+ (BOOL)isNumAndAlphabet:(NSString *)strValue
{
    NSString * regex = @"^[A-Za-z0-9]+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:strValue];
    return isMatch;
}

//根据金额得到相应的字符串 两位小数
+ (NSString *)moneyToString:(NSString *)money
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    NSString *moneyStr = [formatter stringFromNumber:[NSNumber numberWithFloat:[money floatValue]]];
    
    if ([money intValue] >= 1000000) {
        float million = [money floatValue] / 1000000.00;
//        moneyStr = [formatter stringFromNumber:[NSNumber numberWithFloat:million]];
        moneyStr = [NSString stringWithFormat:@"%.2f",million];
        moneyStr = [moneyStr stringByAppendingString:@"百万元"];
    }else if ([money intValue] >= 10000) {
        float tenThousand = [money intValue] / 10000.00;
        moneyStr = [NSString stringWithFormat:@"%.2f",tenThousand];
        
        moneyStr = [moneyStr stringByAppendingString:@"万元"];
    }else{
        float singleDigits = [money floatValue];
        moneyStr = [NSString stringWithFormat:@"%.2f",singleDigits];
        moneyStr = [moneyStr stringByAppendingString:@"元"];
    }
    
    return moneyStr;
}

//根据金额得到相应的字符串 整数
+ (NSString *)moneyToNumString:(NSString *)money
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    NSString *moneyStr = [formatter stringFromNumber:[NSNumber numberWithFloat:[money floatValue]]];
    
    if ([money intValue] >= 1000000) {
        float million = [money floatValue] / 1000000.00;
        //        moneyStr = [formatter stringFromNumber:[NSNumber numberWithFloat:million]];
        moneyStr = [NSString stringWithFormat:@"%.f",million];
        moneyStr = [moneyStr stringByAppendingString:@"百万元"];
    }else if ([money intValue] >= 10000) {
        float tenThousand = [money intValue] / 10000.00;
        moneyStr = [NSString stringWithFormat:@"%.f",tenThousand];
        
        moneyStr = [moneyStr stringByAppendingString:@"万元"];
    }else{
        float singleDigits = [money floatValue];
        moneyStr = [NSString stringWithFormat:@"%.f",singleDigits];
        moneyStr = [moneyStr stringByAppendingString:@"元"];
    }
    
    return moneyStr;
}

//固话验证
+ (BOOL)validateTelphone:(NSString *)telphone

{
    NSString *phoneRegex = @"\\d{3}-\\d{8}|\\d{4}-\\d{7,8}";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:telphone];
    
}

//金额验证
+ (BOOL)validateMoney:(NSString *)money

{
    NSString *moneyRegex = @"^-?[0-9]+(.[0-9]{1,2})?$";
    NSPredicate *moneyTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",moneyRegex];
    return [moneyTest evaluateWithObject:money];
    
}

//数据是否为NULL
+ (NSString *)stringIsNilOrNull:(id)str

{
    if (str == nil || str == [NSNull null]) {
        return @"";
    }else{
        return str;
    }

}

//时间戳转换为日期格式
+ (NSString *)timestampToStrDate:(NSString *)string
{
    if (string == nil) {
        return @"";
    }
    long  long  time = [string longLongValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
//    NSInteger interval = [zone secondsFromGMTForDate: date];
//    NSDate *localeDate = [date dateByAddingTimeInterval: interval];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateStyle:NSDateFormatterMediumStyle];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormat setTimeZone:zone];
    NSString *dateStr = [dateFormat stringFromDate: date];
    return  dateStr;
}

+ (NSString *)timestampToStrDate:(NSString *)string withFormat:(NSString *)format
{
    if (string == nil) {
        return @"";
    }
    long  long  time = [string longLongValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    //    NSInteger interval = [zone secondsFromGMTForDate: date];
    //    NSDate *localeDate = [date dateByAddingTimeInterval: interval];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateStyle:NSDateFormatterMediumStyle];
    [dateFormat setDateFormat:format];
    [dateFormat setTimeZone:zone];
    NSString *dateStr = [dateFormat stringFromDate: date];
    return  dateStr;
}

//去除字典集中的null值
+ (NSDictionary *)replaceNullObject:(NSDictionary *)dict
{
    NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
    for (id key in dict) {
        [newDict setObject:[self stringIsNilOrNull:[dict objectForKey:key]] forKey:key];
    }
    return  newDict;
}

//Json 转字符串
+ (NSData*)JSONString:(id)data
{
    NSError* error = nil;
    id result = [NSJSONSerialization dataWithJSONObject:data
                                                options:kNilOptions error:&error];
    if (error != nil) return nil;
    return result;
}

//生成MD5值
+(NSString *)changeToStringToMd5String:(NSString *)string
{
    const char *cStr = [string UTF8String];
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

//格式化银行卡号
+ (NSString *)formatCardNumber:(NSString *)cardNum
{
    NSNumber *number = @([cardNum longLongValue]);
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setUsesGroupingSeparator:YES];
    [formatter setGroupingSize:4];
    [formatter setGroupingSeparator:@" "];
    
    NSString *returnStr = [formatter stringFromNumber:number];
    
    return [returnStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

//由对应的color生成相应的image
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size

{
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, color.CGColor);
    
    CGContextFillRect(context, rect);
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();

    return img;
    
}

//获得本地数据库地址
+ (NSString *)fileFMDatabasePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDir = [paths objectAtIndex:0];
    [ProjectUtil showLog:@"%@",[documentDir stringByAppendingPathComponent:@"ZP_SalesHelperA_db.db"]];
    NSString *newfile = [[documentDir stringByAppendingPathComponent:@"ZP_SalesHelperA_db"] stringByAppendingPathComponent:[ProjectUtil changeToStringToMd5String:RequestKey]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:newfile]) {
        [fileManager createDirectoryAtPath:newfile withIntermediateDirectories:YES attributes:nil error:nil];
    }

    return [newfile stringByAppendingPathComponent:@".ZP_SalesHelperA_db.db"];
}

//获取String类型的值
+ (NSString *) GetStringValueForDataSource:(id)dataSource ForKey:(NSString *)key{
    if(!dataSource) return @"";
    
    id value = [dataSource objectForKey:key];
    
    if(value && value != [NSNull null] && value != nil){
        return [NSString stringWithFormat:@"%@", value];
    }
    else{
        return @"";
    }
}

//获取Interger类型的值
+ (NSInteger) GetIntegerValueForDataSource:(id)dataSource ForKey:(NSString *)key{
    if(!dataSource) return NSIntegerMin;
    
    id value = [dataSource valueForKeyPath:key];
    
    if(value && value != [NSNull null] && value != nil){
        return [value integerValue];
    }
    else{
        return NSIntegerMin;
    }
}

//获取Float类型的值
+ (CGFloat) GetFloatValueForDataSource:(id)dataSource ForKey:(NSString *)key{
    if(!dataSource) return NSIntegerMin;
    
    id value = [dataSource valueForKeyPath:key];
    
    if(value && value != [NSNull null] && value != nil){
        return [value floatValue];
    }
    else{
        return NSIntegerMin;
    }
}

+ (UIColor *)colorWithHexString:(NSString *)color
{
    //删除字符串中的空格
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6)
    {
        return [UIColor clearColor];
    }
    // strip @"0x if it appears
    //如果是@"0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
    if ([cString hasPrefix:@"0x"])
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
    
    if ([cString length] == 8)
    {
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
    }
    else
    {
        
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

- (NSString *)awayFromNow:(NSString *)timeStr
{
    long  long  time = [timeStr longLongValue];
    NSDate * timeDate = [NSDate dateWithTimeIntervalSince1970:time];
    NSDate * nowDate = [NSDate date];
    NSTimeInterval aTimer = [nowDate timeIntervalSinceDate:timeDate];
    NSInteger hour = (int)(aTimer/3600);
    NSInteger minute = (int)(aTimer - hour*3600)/60;
    NSString * str ;
    if (minute < 30 && hour == 0)
    {
        str = @"刚刚";
    }
    else if (minute > 30 && hour == 0)
    {
       str = @"30分钟前";
    }
    else if (hour > 0 && hour < 2)
    {
        str = @"1小时前";
    }
    else if (hour < 24 && hour > 2){
        str = [NSString stringWithFormat:@"%lu小时前",(long)hour];
    }
    else if (hour >= 24 && hour < 48)
    {
        str = [NSString stringWithFormat:@"昨天"];
    }
    else if (hour >= 24 && hour < 48)
    {
        str = [NSString stringWithFormat:@"昨天"];
    }
    return str;

}
+ (NSString *)compareDate:(NSString *)dateStr
{
    long  long  time = [dateStr longLongValue];
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:time];

    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSDate *today = [[NSDate alloc] init];
    NSDate *yesterday;
    
    yesterday = [today dateByAddingTimeInterval: -secondsPerDay];
    
    // 10 first characters of description is the calendar date:
    NSString * todayString = [[today description] substringToIndex:10];
    NSString * yesterdayString = [[yesterday description] substringToIndex:10];
    
    NSString * dateString = [[date description] substringToIndex:10];
    
    if ([dateString isEqualToString:todayString])
    {
        NSTimeInterval aTimer = [[NSDate date] timeIntervalSinceDate:date];
        NSInteger hour = (int)(aTimer/3600);
        NSInteger minute = (int)(aTimer - hour*3600)/60;
        NSString * str ;
        if (minute < 30 && hour == 0) {
            str = @"刚刚";
        }else if (minute > 30 && hour == 0){
            str = @"30分钟前";
        }else if (hour > 0 && hour < 2){
            str = @"1小时前";
        }else if (hour < 24 && hour > 2){
            str = [NSString stringWithFormat:@"%lu小时前",hour];
        }
        return str;
    } else if ([dateString isEqualToString:yesterdayString])
    {
        return @"昨天";
    }else
    {
        return [ProjectUtil timestampToStrDate:dateStr withFormat:@"yyyy-MM-dd"];
    }
}

+ (NSString *)makeColorStringWithNameStr:(NSString *)nameStr
{
    NSArray * colorArr = @[  @"e57373",
                             @"f06292",
                             @"ba68c8",
                             @"9575cd",
                             @"7986cb",
                             @"64b5f6",
                             @"4fc3f7",
                             @"4dd0e1",
                             @"4db6ac",
                             @"81c784",
                             @"aed581",
                             @"ff8a65",
                             @"d4e157",
                             @"ffd54f",
                             @"ffb74d",
                             @"a1887f",
                             @"90a4ae",
                                       ];
    
    NSInteger index = abs((int)[nameStr hash])%colorArr.count;

    
    return colorArr[index];
}

@end
