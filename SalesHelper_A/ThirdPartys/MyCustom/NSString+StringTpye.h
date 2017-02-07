//
//  NSString+StringTpye.h
//  SalesHelper_C
//
//  Created by summer on 14/10/18.
//  Copyright (c) 2014年 X. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define PhoneStringLength 11
#define PasswordStringMinLength 6
#define PasswordStringMaxLength 16
#define IdentityCodeMaxLength 4


typedef NS_ENUM(NSInteger, StringType)
{
    StringTypePhone,//手机号
    StringTypePhoneNumber,//数字0-9
    StringTypePassword,//密码
    StringTypeChineseName,//中文名字
    StringTypeUrlString//网址
};

@interface NSString (StringTpye)
-(NSMutableAttributedString *)addUnderline;
-(CGSize)getSizeWithFont:(UIFont *)font;
-(CGSize)getSizeWithFont:(UIFont *)font Width:(CGFloat)width;
-(BOOL)isType:(StringType)stringType;
-(BOOL)isAllowInputWithMinLength:(NSInteger)minLength MaxLength:(NSInteger)maxLength StringType:(StringType)stringType;
- (NSString *)changeToStringToMd5String;
-(NSString *)changeToMyDate;
-(NSString *)changetoNomalDate;
-(NSString *)changeToChineseDate;
-(NSString *)changeToMyDateWithSegmentSign:(NSString *)segmentSign;
@end
