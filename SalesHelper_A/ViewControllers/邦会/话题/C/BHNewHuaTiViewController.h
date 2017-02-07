//
//  BHNewHuaTiViewController.h
//  SalesHelper_A
//
//  Created by zhipu on 16/3/17.
//  Copyright © 2016年 X. All rights reserved.
//

#import "ModelViewController.h"
@class BHFirstListModel;

@interface BHNewHuaTiViewController : ModelViewController

//@property (nonatomic, strong) BHFirstListModel *model;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *huatiid;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSString *subid;
@end
