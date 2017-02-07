//
//  BaseNavigationController.m
//  SalesHelper_A
//
//  Created by ZhipuTech on 15/6/10.
//  Copyright (c) 2015年 X. All rights reserved.
//

#import "BaseNavigationController.h"
@interface BaseNavigationController ()<UIGestureRecognizerDelegate>
{
    //首页的tabbaritem
    IBOutlet UITabBarItem *homeItem;
   //客户的
    IBOutlet UITabBarItem *clientItem;
    // 发现
    IBOutlet UITabBarItem *discover;
    //底部
    IBOutlet UITabBarItem *myItem;
}
@end

@implementation BaseNavigationController

-(void)viewDidLoad
{
    [super viewDidLoad];
    __weak typeof (self) weakSelf = self;
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = weakSelf;
    }
    [self.navigationBar setTitleTextAttributes:
  @{
    NSForegroundColorAttributeName:[UIColor whiteColor]
    }];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
