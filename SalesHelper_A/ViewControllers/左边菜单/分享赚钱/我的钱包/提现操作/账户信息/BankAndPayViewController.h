//
//  BankAndPayViewController.h
//  SalesHelper_A
//
//  Created by zhipu on 14/11/13.
//  Copyright (c) 2014年 zhipu. All rights reserved.
//

#import "ModelViewController.h"

@class BankAndPayViewController;

@protocol BankAndPayViewControllerDelegate <NSObject>

@optional

- (void)callBackWithBankOrPayInfo:(NSDictionary *)dict;

@end

@interface BankAndPayViewController : ModelViewController

@property (nonatomic, weak) id<BankAndPayViewControllerDelegate> delegate;

@property (nonatomic, strong) NSArray *bankPayArray;

@property (nonatomic, strong) NSDictionary *selectedDict;

@end
