//
//  SaleHelperModelViewController.m
//  SalesHelper_C
//
//  Created by summer on 14-10-11.
//  Copyright (c) 2014年 X. All rights reserved.
//

#import "SaleHelperModelViewController.h"

@interface SaleHelperModelViewController ()

@end

@implementation SaleHelperModelViewController
@synthesize userType = _userType;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatNavigationItemWithMNavigationItem:MNavigationItemTypeTitle ItemName:self.title];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    id login = [userDefaults objectForKey:@"login"];
    
    self.token = [login objectForKey:@"token"]==nil?@"":[login objectForKey:@"token"];
}

-(NSString *)getIdWithKey:(NSString *)key
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    id login = [userDefaults objectForKey:@"login"];
    return [login objectForKey:key];
}

//-(NSString *)getAvatarUrl
//{
//    return [NSString stringWithFormat:@"%@%@",URL_BASE,[self getIdWithKey:@"face"]];
//}

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
