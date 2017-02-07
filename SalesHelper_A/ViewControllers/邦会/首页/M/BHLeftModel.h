//
//  BHLeftModel.h
//  SalesHelper_A
//
//  Created by 曾杰 on 16/3/4.
//  Copyright © 2016年 X. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BHLeftModel : NSObject
/**
 *  圈子的类别ID
 */
@property (nonatomic, strong) NSString *quanZiID;
/**
 *  圈子类别的图片
 */
@property (nonatomic, strong) NSString *bgimgpath;
/**
 *  标题图片
 */
@property (nonatomic, strong) NSString *iconpath;
/**
 *  话题数
 */
@property (nonatomic, strong) NSString *huati;
/**
 *  人气数
 */
@property (nonatomic, strong) NSString *renqi;
/**
 *  标题
 */
@property (nonatomic, strong) NSString *topic;
//@property (nonatomic, strong) NSString *bgimgpath
@end
