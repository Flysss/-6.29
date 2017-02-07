//
//  ClientsEditViewController.h
//  SalesHelper_A
//
//  Created by summer on 15/11/4.
//  Copyright © 2015年 X. All rights reserved.
//

#import "ModelViewController.h"

typedef void (^RefreshBlock)(NSDictionary * dict);

@interface ClientsEditViewController : ModelViewController

@property (nonatomic,retain)NSDictionary * custmorData;
@property (nonatomic,copy)RefreshBlock refreshBlock;
- (void)refesh:(RefreshBlock)block;

@end
