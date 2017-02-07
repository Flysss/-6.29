//
//  ClientsInfosViewController.h
//  SalesHelper_A
//
//  Created by summer on 15/11/3.
//  Copyright © 2015年 X. All rights reserved.
//

#import "ModelViewController.h"
typedef void (^MyRefreshBlock)();

@interface ClientsInfosViewController : ModelViewController

@property (nonatomic,retain) NSDictionary * custmorData;
@property (nonatomic,copy)MyRefreshBlock refreshBlock;
@property (nonatomic,assign)BOOL isEdit;
- (void)refeshCLientsManager:(MyRefreshBlock)block;

@end
