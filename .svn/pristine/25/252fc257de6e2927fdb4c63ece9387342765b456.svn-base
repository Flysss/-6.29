//
//  CreatCustomUI.m
//  SalesHelper_C
//
//  Created by summer on 14/10/17.
//  Copyright (c) 2014年 X. All rights reserved.
//

#import "CreatCustom.h"
#import "NSString+StringTpye.h"

@implementation CreatCustom
+(UILabel *)creatUILabelWithOrignalX:(CGFloat)orignalX OrignalY:(CGFloat)orignalY Height:(CGFloat)height Text:(NSString *)text Font:(UIFont *)font
{
    CGSize size = CGSizeZero;
    if (IOS_VERSION<7.0)
    {
//        size = [text sizeWithFont:font];
        size = [text sizeWithAttributes:@{NSFontAttributeName:font}];
    }
    else
    {
         size = [text sizeWithAttributes:[NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName]];
    }
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(orignalX, orignalY, size.width, height)];
    label.text = text;
    label.font = font;
    label.backgroundColor = [UIColor clearColor];
    return label;
}

+(UILabel *)creatUILabelWithOrignalY:(CGFloat)orignalY Width:(CGFloat)width Text:(NSString *)text Font:(UIFont *)font
{
    CGSize size = [text getSizeWithFont:font Width:width];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-size.width)/2, orignalY, size.width, size.height)];
    label.text = text;
    label.font = font;
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    return label;
}

+(UIImage*)creatUIImageWithColor:(UIColor*)color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage*theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

+(UIColor *)creatUIColorWithRed:(CGFloat)red Green:(CGFloat)green Blue:(CGFloat)blue
{
    return [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1.0];
}

+(UIButton *)creatUIButtonWithFrame:(CGRect)frame BackgroundColor:(UIColor *)backgroundColor Title:(NSString *)title TitleColor:(UIColor *)titleColor Target:(id)target Action:(SEL)action
{
    if (backgroundColor==nil)
    {
        backgroundColor = [UIColor clearColor];
    }
    UIButton *button;
    if (IOS_VERSION<7.0)
    {
        button = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    else
    {
        button = [UIButton buttonWithType:UIButtonTypeSystem];
    }
    button.frame = frame;
    [button setBackgroundColor:backgroundColor];
    if (titleColor==nil)
    {
        titleColor = [UIColor whiteColor];
        button.titleLabel.font = Default_Font_17;
    }
    else
    {
        button.titleLabel.font = Default_Font_17;
    }
    
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateHighlighted];
    [button setTitleColor:titleColor forState:UIControlStateHighlighted];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

+(UIView *)creatUIViewWithFrame:(CGRect)frame BackgroundColor:(UIColor *)backgroundColor
{
    UIView *view = [[UIView alloc]initWithFrame:frame];
    view.backgroundColor = backgroundColor;
    return view;
}


+(UITextField *)creatUITextFieldWithFrame:(CGRect)frame TextFieldStyle:(TextFieldStyle)textFieldStyle
{
    UITextField *textField = [[UITextField alloc]initWithFrame:frame];
    if (textField)
    {
        textField.returnKeyType = UIReturnKeyDone;
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        textField.autocorrectionType = UITextAutocorrectionTypeNo;
        textField.font = Default_Font_15;
        textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        if (textFieldStyle==TextFieldStylePassword)
        {
            textField.keyboardType = UIKeyboardTypeAlphabet;
            textField.secureTextEntry = YES;
        }
        else if (textFieldStyle ==TextFieldStylePhone|textFieldStyle==TextFieldStyleIdentityCode|textFieldStyle ==TextFieldStyleIdentityNum)
        {
             textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        }
        else
        {
            textField.keyboardType = UIKeyboardTypeDefault;
        }
    }
    return textField;
}

+(UITableView *)creatUITableViewWithOrignalX:(CGFloat)orignalX OrignalY:(CGFloat)orignalY MaxHeight:(CGFloat)maxHeight SegmentHeight:(CGFloat)segmentHeight DataCellHeight:(CGFloat)dataCellHeight DataArr:(NSMutableArray *)dataArr;
{
    CGFloat tableViewHeight = dataArr.count*segmentHeight+dataCellHeight;
    //insert data
    if (segmentHeight!=0)
    {
        for (int i = 0; i<dataArr.count; i++)
        {
            if (i%2!=0)
            {
                [dataArr insertObject:[NSDictionary dictionary] atIndex:i];
            }
        }

    }
    if (tableViewHeight>=maxHeight)
    {
        tableViewHeight = maxHeight;
    }
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(orignalX, orignalY, (SCREEN_WIDTH-orignalX*2), tableViewHeight) style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor clearColor];
    if (segmentHeight!=0)
    {
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return tableView;
}

+(CGRect)creatFrameWithOrignalX:(CGFloat)orignalX OrignalY:(CGFloat)orignalY Height:(CGFloat)height
{
    return  CGRectMake(orignalX, orignalY, SCREEN_WIDTH-2*orignalX, height);
}

+(CGRect)creatFrameWithWidth:(CGFloat)width Height:(CGFloat)height OrignalY:(CGFloat)orignalY
{
    return CGRectMake((SCREEN_WIDTH-width)/2, orignalY, width, height);
}

+(CGRect)creatNavigationBarFrameWithWidth:(CGFloat)width Height:(CGFloat)height
{
    CGFloat segment = 16.0;
    if (IOS_VERSION<7.0)
    {
        segment = 5.0;
    }
    if (SCREEN_HEIGHT>=736)
    {
        segment = 20.0;
    }
    
    return CGRectMake((SCREEN_WIDTH-segment-width), 20+(44-height)/2, width, height);
}


+(UITabBarController*)creatTabBarItemsWithTitle:(NSArray *)titles SelectedImages:(NSArray *)selectedImages UnSelectedImages:(NSArray *)unSelectedImages ViewControllers:(NSArray *)viewControllers selectedIndex:(NSUInteger)index
{
    for (int i=0; i<viewControllers.count; i++)
    {
        UIViewController *viewController = [viewControllers objectAtIndex:i];
        
        if (IOS_VERSION<7.0)
        {
            [viewController.tabBarItem setTitle:[titles objectAtIndex:i]];
            [viewController.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:[selectedImages objectAtIndex:i]] withFinishedUnselectedImage:[UIImage imageNamed:[unSelectedImages objectAtIndex:i]]];
           
        }
        else
        {
            viewController.tabBarItem = [[UITabBarItem alloc]initWithTitle:[titles objectAtIndex:i] image:[UIImage imageNamed:[unSelectedImages objectAtIndex:i]] selectedImage:[UIImage imageNamed:[selectedImages objectAtIndex:i]]];
            viewController.tabBarItem.selectedImage = [viewController.tabBarItem.selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            viewController.tabBarItem.image = [viewController.tabBarItem.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        }
    }
    
    UITabBarController *tabBC = [[UITabBarController alloc]init];
    UIView *tabBarBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 49)];
    tabBarBackView.backgroundColor = NavigationBarColor;
    [tabBC.tabBar insertSubview:tabBarBackView atIndex:0];
    tabBC.viewControllers = viewControllers;
    tabBC.selectedIndex = index;
    return tabBC;
}





@end
