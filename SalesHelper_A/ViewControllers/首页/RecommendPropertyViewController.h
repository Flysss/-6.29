//
//  RecommendPropertyViewController.h
//  SalesHelper_A
//
//  Created by summer on 15/7/16.
//  Copyright (c) 2015年 X. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol recommendPropertyVCDelegate <NSObject>

- (void)addPropertyArrInfo:(NSArray *)propertyInfoArr;

@end

@interface RecommendPropertyViewController : UIViewController
//已被选择的储存数组
@property (retain , nonatomic)NSMutableArray * choosenArr;

@property (nonatomic,assign)id <recommendPropertyVCDelegate>recommendDelegate;

@end
