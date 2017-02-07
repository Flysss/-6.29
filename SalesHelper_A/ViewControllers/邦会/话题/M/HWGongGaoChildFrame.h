//
//  HWGongGaoChildFrame.h
//  SalesHelper_A
//
//  Created by 胡伟 on 16/3/8.
//  Copyright © 2016年 X. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HWGongGaoChildModel;
@interface HWGongGaoChildFrame : NSObject

@property (nonatomic,strong) NSArray *child;

@property (nonatomic,assign) CGRect oneHuiFuFrame;
@property (nonatomic,assign) CGRect twoHuiFuFrame;
@property (nonatomic,assign) CGRect threeHuiFuFrame;
@property (nonatomic,assign) CGRect moreButtonFrame;

@property (nonatomic,assign) CGRect frame; //自己的frame
@end
