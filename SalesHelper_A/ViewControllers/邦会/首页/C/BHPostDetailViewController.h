//
//  BHPostDetailViewController.h
//  SalesHelper_A
//
//  Created by zhipu on 16/2/29.
//  Copyright © 2016年 X. All rights reserved.
//

#import "ModelViewController.h"

typedef void(^changeStateBlock)(BOOL);


@interface BHPostDetailViewController : ModelViewController
@property (nonatomic ,strong)NSString *tieZiID;
@property (nonatomic ,copy)changeStateBlock changestateblock;

@property (nonatomic, assign)NSInteger index_row;
@property (nonatomic, assign) BOOL isMessageVC;

@property (nonatomic, assign) BOOL isHuaTi;

@property (nonatomic, assign) BOOL iskeyboardShow;

@end
