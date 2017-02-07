//
//  CreatCustomUI.h
//  SalesHelper_C
//
//  Created by summer on 14/10/17.
//  Copyright (c) 2014年 X. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TextFieldStyle)
{
    TextFieldStylePassword,//密码输入框
    TextFieldStylePhone,//手机输入框
    TextFieldStyleIdentityNum,//身份证号码输入框
    TextFieldStyleIdentityCode,//验证码输入框
};

@interface CreatCustom : NSObject
+(UIImage*)creatUIImageWithColor:(UIColor*)color;
+(UILabel *)creatUILabelWithOrignalX:(CGFloat)orignalX OrignalY:(CGFloat)orignalY Height:(CGFloat)height Text:(NSString *)text Font:(UIFont *)font;
+(UILabel *)creatUILabelWithOrignalY:(CGFloat)orignalY Width:(CGFloat)width Text:(NSString *)text Font:(UIFont *)font;

+(UIView *)creatUIViewWithFrame:(CGRect)frame BackgroundColor:(UIColor *)backgroundColor;
+(UIButton *)creatUIButtonWithFrame:(CGRect)frame BackgroundColor:(UIColor *)backgroundColor Title:(NSString *)title TitleColor:(UIColor *)titleColor Target:(id)target Action:(SEL)action;

+(UITextField *)creatUITextFieldWithFrame:(CGRect)frame TextFieldStyle:(TextFieldStyle)textFieldStyle;

+(CGRect)creatFrameWithOrignalX:(CGFloat)orignalX OrignalY:(CGFloat)orignalY Height:(CGFloat)height;

+(CGRect)creatFrameWithWidth:(CGFloat)width Height:(CGFloat)height OrignalY:(CGFloat)orignalY;

+(CGRect)creatNavigationBarFrameWithWidth:(CGFloat)width Height:(CGFloat)height;

+(UITabBarController *)creatTabBarItemsWithTitle:(NSArray *)titles SelectedImages:(NSArray *)selectedImages UnSelectedImages:(NSArray *)unSelectedImages  ViewControllers:(NSArray *)viewControllers selectedIndex:(NSUInteger)index;
@end
