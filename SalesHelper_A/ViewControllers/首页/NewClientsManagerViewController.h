//
//  NewClientsManagerViewController.h
//  SalesHelper_A
//
//  Created by summer on 15/10/30.
//  Copyright © 2015年 X. All rights reserved.
//

#import "ModelViewController.h"
typedef void (^passContentBlock)(NSDictionary * dict);

@interface NewClientsManagerViewController : ModelViewController
@property (nonatomic , assign)BOOL isChoosen;

@property (nonatomic , copy)passContentBlock myBlock;
- (void)passContentWithBlock:(passContentBlock)block;

@end
