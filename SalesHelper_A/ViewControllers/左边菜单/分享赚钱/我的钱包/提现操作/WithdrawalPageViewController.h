//
//  WithdrawalPageViewController.h
//  SalesHelper_A
//
//  Created by Reconcilie on 14/10/25.
//  Copyright (c) 2014年 zhipu. All rights reserved.
//

#import "ModelViewController.h"
@protocol refreshDataDelegate <NSObject>
- (void)refresh;
@end
@interface WithdrawalPageViewController : ModelViewController

@property (nonatomic, strong) NSString *accountMoney;
@property(nonatomic,copy)NSString* moneyStr;
@property (nonatomic,assign)id <refreshDataDelegate>delegate;

@end
