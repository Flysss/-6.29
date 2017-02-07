//
//  SelectBankTypeViewController.h
//  SalesHelper_A
//
//  Created by zhipu on 14/11/13.
//  Copyright (c) 2014年 zhipu. All rights reserved.
//

#import "ModelViewController.h"

@class SelectBankTypeViewController;

@protocol SelectBankTypeViewControllerDelegate <NSObject>

@optional

- (void)callBackWithBankInfo:(NSDictionary *)dict Index:(NSInteger)index;

@end


@interface SelectBankTypeViewController : ModelViewController

@property (nonatomic, weak) id<SelectBankTypeViewControllerDelegate> delegate;
@property (nonatomic,assign)NSInteger selectedItemIndex;
@end
