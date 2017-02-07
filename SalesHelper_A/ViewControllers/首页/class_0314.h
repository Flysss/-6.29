//
//  class_0314.h
//  SalesHelper_A
//
//  Created by zhipu on 15/7/3.
//  Copyright (c) 2015年 X. All rights reserved.
//


#import <Foundation/Foundation.h>
//#import "Enum_0314.h"
#import <CoreLocation/CoreLocation.h>
@interface class_0314 : NSObject


/**电话*/
@property(strong, nonatomic) NSString * Phone;

#warning PhoneToken(用来打电话的)
@property(strong, nonatomic) NSString * PhoneToken;//用来打电话的

#warning Token(登录的时候读取到的，我TM不知道具体意义)
@property(strong, nonatomic) NSString * Token;

/***/
@property(nonatomic) NSString * Phone_Key;






@end
