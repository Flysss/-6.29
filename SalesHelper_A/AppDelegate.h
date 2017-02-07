//
//  AppDelegate.h
//  SalesHelper_A
//
//  Created by summer on 14/12/18.
//  Copyright (c) 2014年 X. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftSlideViewController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic,assign)BOOL  isPush;

@property (nonatomic,retain)NSDictionary * pushData;

@property (strong, nonatomic) LeftSlideViewController *LeftSlideVC;



@end

