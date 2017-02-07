//
//  ProjectUtil.h
//  AnJieWealth
//
//  Created by zhipu on 14-8-28.
//  Copyright (c) 2014年 deayou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProjectUtil : NSObject

#pragma mark -log
+(void)showLog:(NSString *)log,...;
//显示弹出框
+(void)showAlert:(NSString *)title message:(NSString *)msg;

#pragma mark -正则
//判断手机号
+ (BOOL)isPersonPhone:(NSString *)strPhone;
//判断手机号 11 位即可
+ (BOOL)isFuzzyPhone:(NSString *)strPhone;
//利用正则表达式验证邮箱
+ (BOOL)isValidateEmail:(NSString *)email;
//判断字母和数字
+ (BOOL)isNumAndAlphabet:(NSString *)strValue;
//根据金额得到相应的字符串 两位小数
+ (NSString *)moneyToString:(NSString *)money;
//根据金额得到相应的字符串 整数
+ (NSString *)moneyToNumString:(NSString *)money;

//固话验证
+ (BOOL)validateTelphone:(NSString *)telphone;
//金额验证
+ (BOOL)validateMoney:(NSString *)money;
//数据是否为NULL
+ (NSString *)stringIsNilOrNull:(id)str;
//时间戳转换为日期格式
+ (NSString *)timestampToStrDate:(NSString *)string;
//去除字典集中的null值
+ (NSDictionary *)replaceNullObject:(NSDictionary *)dict;
//Json 转字符串
+ (NSData*)JSONString:(id)data;
//生成MD5值
+(NSString *)changeToStringToMd5String:(NSString *)string;
//格式化银行卡号
+ (NSString *)formatCardNumber:(NSString *)cardNum;
//由对应的color生成相应的image
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

//获得本地数据库地址
+ (NSString *)fileFMDatabasePath;

+ (UIColor *)colorWithHexString:(NSString *)color;

+ (NSString *) GetStringValueForDataSource:(id)dataSource ForKey:(NSString *)key;

+ (NSString *)compareDate:(NSString *)dateStr;

+ (NSString *)makeColorStringWithNameStr:(NSString *)nameStr;
@end
