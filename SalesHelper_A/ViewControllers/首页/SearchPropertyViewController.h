//
//  SearchPropertyViewController.h
//  SalesHelper_A
//
//  Created by summer on 15/7/13.
//  Copyright (c) 2015年 X. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface SearchPropertyViewController : BaseViewController
/**
 *  主页 “住” “墅” 等 点击传过来的字典
 */
@property (nonatomic,retain)NSDictionary *  choosenDic;

@property (nonatomic ,copy)NSString * locationStr;

@end
